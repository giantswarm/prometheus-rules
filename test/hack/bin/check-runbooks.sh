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

# merge_docs () merges a Hugo docs hierarchy from a source directory (first arg) into a destination directory (second arg).
merge_docs() {
    if [[ ! -d "$1/content/docs/." ]] ; then
        echo "Source Hugo base directory not specified or invalid (must contain content/docs)!" >&2
    fi
    if [[ ! -d "$2/content/docs/." ]] ; then
        echo "Destination Hugo base directory not specified or invalid (must contain content/docs)!" >&2
    fi
    find "$1/content/docs" -mindepth 1 -maxdepth 1 -type d -print0 | xargs -0 cp -v -x -a -r -u -t "$2/content/docs/." | \
        grep -o -P "(?<= -> ').*\.md" | \
        xargs sed -s -i'' '0,/^---.*$/s//---\nsourceOrigin: handbook/'
}

listRunbooks () {
    local runInCi="$1" && shift
    privateRunbooksParentDirectory="./giantswarm"
    privateRunbooksHandbookParentDirectory="./handbook"
    # CI clones git dependencies, but if we run it locally we have to do it ourselves
    if [[ "$runInCi" == false ]]; then
        tmpDir="$(mktemp -d)"
        tmpDirHandbook="$(mktemp -d)"
        git clone --depth 1 --single-branch -b main -q git@github.com:giantswarm/giantswarm.git "$tmpDir"
        git clone --depth=1 --single-branch -b main -q git@github.com:giantswarm/handbook.git "$tmpDirHandbook"
        privateRunbooksParentDirectory="$tmpDir"
        privateRunbooksHandbookParentDirectory="$tmpDirHandbook"
    fi

    # perform merge as done by intranet build
    merge_docs "$privateRunbooksHandbookParentDirectory" "$privateRunbooksParentDirectory"

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

    echo "Number of runbooks found: ${#runbooks[@]}"
    echo "List of runbooks:"
    for runbook in "${runbooks[@]}"; do
        echo " - $runbook"
    done

    # Find all `runbook_url:` occurrences in .y[a]ml files under ./helm/prometheus-rules
    rulesFiles=$(find ./helm/prometheus-rules -type f \( -name "*.yml" -o -name "*.yaml" \))

    # iterate over all rules files
    for rulesFile in $rulesFiles; do
        echo "Processing rules file: $rulesFile"
        # iterate over all rules in a file
        url=$(grep --no-filename "runbook_url:" $rulesFile | sed 's|runbook_url:||' | sed -e 's|[[:space:]]+||' | sed -e "s|[\"']||g")
        
        # Check if url is in runbooks array
        echo "Checking runbook URL '$url'"
        if ! isInArray "$url" "${runbooks[@]}"; then
            local message="file $prettyRulesFilename / alert \"$alertname\" links to unexisting runbook (\"$runbook\")"
            E_unexistingrunbook+=("$message")
            continue
        fi
    done

    if [[ "${#E_unexistingrunbook[@]}" -gt 0 ]]; then
        echo ""
        echo "Alerts using unexisting runbook: ${#E_unexistingrunbook[@]}"
        for message in "${E_unexistingrunbook[@]}"; do
            echo "$message"
        done
        returncode=1
    fi

    return "$returncode"
}

main "$@"
