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

    # find all runbooks ".md" files, and keep only the runbook name (may contain a path, like "rolling-nodes/rolling-nodes")
    find "$privateRunbooksParentDirectory"/content/docs/support-and-ops/ops-recipes -type f -name \*.md \
        | sed -n 's_'"$privateRunbooksParentDirectory"'/content/docs/support-and-ops/ops-recipes/\(.*\).md_\1_p' \
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

    if [[ "$DEBUG_MODE" != "false" ]]; then
        echo "List of runbooks:"
        for runbook in "${runbooks[@]}"; do
            echo " - \"$runbook\""
        done
    fi

    # Look at each rules file
    while IFS= read -r -d '' rulesFile; do
        prettyRulesFilename="$(basename "$rulesFile")"

        # skip if rules file has already been checked
        isInArray "$prettyRulesFilename" "${checkedRules[@]}" \
            && continue

        while read -r alertname runbook severity overflow ; do

            # Discard non-paging alerts
            [[ "$severity" != "page" ]] && continue

            # Get rid of url prefix
            runbook=${runbook#https://intranet.giantswarm.io/docs/support-and-ops/ops-recipes/}
            # Get rid of anchors
            runbook="${runbook%%#*}"
            # Get rid of trailing slash
            runbook="${runbook%/}"


            # There should be no data in $overflow
            # If there is, it means something went wrong with the parsing
            if [[ "$overflow" != "" ]]; then
                local message="file: $prettyRulesFilename / alert \"$alertname\" / runbook \"$runbook\": extra data \"$overflow\""
                E_extradata+=("$message")
                continue
            fi

            # When there is no runbook annotation, yq outputs "null"
            if [[ "$runbook" == "null" ]]; then
                local message="file $prettyRulesFilename / alert \"$alertname\" has no runbook"
                E_norunbook+=("$message")
                continue
            fi

            # Let's check if the runbook is in our list of existing runbooks
            # or is a valid URL starting with http
            if ! isInArray "$runbook" "${runbooks[@]}" && [[ "$runbook" != http* ]]; then
                local message="file $prettyRulesFilename / alert \"$alertname\" links to unexisting runbook (\"$runbook\")"
                E_unexistingrunbook+=("$message")
                continue
            fi

            if [[ "$DEBUG_MODE" != "false" ]]; then
                echo "file $prettyRulesFilename / alert: $alertname / runbook: $runbook - OK"
            fi

        # parse rules yaml files, and for each rule found output alertname, runbook, and severity, space-separated, on one line.
        done < <("$GIT_WORKDIR/$YQ" -o json "$rulesFile" | "$GIT_WORKDIR/$JQ" -j '.spec.groups[]?.rules[] | .alert, " ", .annotations.runbook_url, " ", .labels.severity, "\n"')

        checkedRules+=("$rulesFile")
    done < <(find "${RULES_FILES[@]}" -type f -print0)


    # Output section - let's write down our findings
    #################################################

    if [[ "$CHECK_EXTRADATA_ERRORS" != "false" ]]; then
        if [[ "${#E_extradata[@]}" -gt 0 ]]; then
            echo ""
            echo "Alerts that failed parsing: ${#E_extradata[@]}"
            for message in "${E_extradata[@]}"; do
                echo "$message"
            done
            returncode=1
        fi
    fi
    if [[ "$CHECK_NORUNBOOK_ERRORS" != "false" ]]; then
        if [[ "${#E_norunbook[@]}" -gt 0 ]]; then
            echo ""
            echo "Alerts missing runbook: ${#E_norunbook[@]}"
            for message in "${E_norunbook[@]}"; do
                echo "$message"
            done
            returncode=1
        fi
    fi
    if [[ "$CHECK_UNEXISTINGRUNBOOK_ERRORS" != "false" ]]; then
        if [[ "${#E_unexistingrunbook[@]}" -gt 0 ]]; then
            echo ""
            echo "Alerts using unexisting runbook: ${#E_unexistingrunbook[@]}"
            for message in "${E_unexistingrunbook[@]}"; do
                echo "$message"
            done
            returncode=1
        fi
    fi

    return "$returncode"
}

main "$@"
