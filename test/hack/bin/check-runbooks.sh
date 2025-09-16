#!/bin/bash
set -euo pipefail

# List of generated rules
RULES_FILES=(./test/hack/output/helm-chart)

DEBUG_MODE=false

CHECK_EXTRADATA_ERRORS=true
CHECK_NORUNBOOK_ERRORS=true
CHECK_UNEXISTINGRUNBOOK_ERRORS=true

# Parameters:
# - an element
# - an array
# Returns:
# - 0 if element is not found in the array
# - 1 if element is found in the array
isInArray () {
    referenceElement="$1" && shift
    array=("$@")

    for element in "${array[@]}"; do
        [[ "$element" == "$referenceElement" ]] \
            && return 0
    done
    return 1
}

listRunbooks () {
    local runInCi="$1" && shift
    privateRunbooksParentDirectory="./giantswarm"
    # CI clones git dependencies, but if we run it locally we have to do it ourselves
    if [[ "$runInCi" == false ]]; then
        tmpDir="$(mktemp -d)"
        git clone --depth 1 --single-branch -b main -q git@github.com:giantswarm/giantswarm.git "$tmpDir"
        privateRunbooksParentDirectory="$tmpDir"
    fi

    # find all page ".md" files and form a proper URL
    find "$privateRunbooksParentDirectory"/content/docs -type f -name \*.md \
        | sed 's|_index\.md||' \
        | sed 's|index\.md||' \
        | sed 's|\.md|/|' \
        | sed 's|//|/|' \
        | sed 'y|ABCDEFGHIJKLMNOPQRSTUVWXYZ|abcdefghijklmnopqrstuvwxyz|' \
        | sed "s|./giantswarm/content/|https://intranet.giantswarm.io/|g" \
        | sed 's/\/_index//g' # Removes the _index.md files and keep the directory name
    rm -rf "$privateRunbooksParentDirectory"
}

main() {
    local -a runInCi=false
    for arg in "$@"; do
        shift
        case "$arg" in
            '--ci')  runInCi=true   ;;
        esac
    done

    local -a checkedRules=()
    local -a runbooks=()
    local -a E_extradata=()
    local -a E_norunbook=()
    local -a E_unexistingrunbook=()
    local returncode=0

    local -r GIT_WORKDIR="$(git rev-parse --show-toplevel)"
    local -r YQ=test/hack/bin/yq
    local -r JQ=test/hack/bin/jq

    # Investigation section
    ########################

    # Retrieve list of runbooks
    mapfile -t runbooks < <(listRunbooks "$runInCi")

    # Find all `runbook_url:` occurrences in .y[a]ml files under ./helm/prometheus-rules
    rulesFiles=$(find ./helm/prometheus-rules -type f \( -name "*.yml" -o -name "*.yaml" \))

    # iterate over all rules files
    for rulesFile in $rulesFiles; do
        # iterate over all rules in a file
        urls=$(grep --no-filename "runbook_url:" $rulesFile 2>/dev/null || true)
        # Skip if no runbook_url found in this file
        if [[ -z "$urls" ]]; then
            continue
        fi

        for url in $urls; do
            url=$(echo "$url" | sed 's|runbook_url:||' | sed -e 's|[[:space:]]+||g' | sed -e 's|#.*||g' | sed -e "s|[\"']||g")
            if [[ -z "$url" ]]; then
                continue
            fi

            # Check if url is in runbooks array
            if ! isInArray "$url" "${runbooks[@]}"; then
                local message="File $rulesFile links to nonexisting URL $url"
                E_unexistingrunbook+=("$message")
                continue
            fi
        done
    done

    if [[ "${#E_unexistingrunbook[@]}" -gt 0 ]]; then
        echo ""
        echo "${#E_unexistingrunbook[@]} bad runbook URLs found"
        for message in "${E_unexistingrunbook[@]}"; do
            echo "$message"
        done
        returncode=1
    fi

    return "$returncode"
}

main "$@"
