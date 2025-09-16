#!/bin/bash
set -euo pipefail

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

generateAnnotationsJson() {
    local -a annotations_data=("$@")
    local first=true
    
    echo "["
    for annotation in "${annotations_data[@]}"; do
        IFS='|' read -r filename line_number url <<< "$annotation"
        
        if [[ "$first" == true ]]; then
            first=false
        else
            echo ","
        fi
        
        # Escape quotes in the URL for JSON
        escaped_url=$(echo "$url" | sed 's/"/\\"/g')
        
        cat << EOF
  {
    "file": "$filename",
    "line": $line_number,
    "title": "Bad runbook URL",
    "message": "This runbook URL does not exist: $escaped_url",
    "annotation_level": "failure"
  }
EOF
    done
    echo ""
    echo "]"
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
    local -a annotations_data=()
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
        urls=$(grep -H --line-number "runbook_url:" $rulesFile 2>/dev/null || true)
        # Skip if no runbook_url found in this file
        if [[ -z "$urls" ]]; then
            continue
        fi

        while IFS= read -r line; do
            # Parse grep output: filename:line_number:matched_text
            filename=$(echo "$line" | cut -d':' -f1)
            line_number=$(echo "$line" | cut -d':' -f2)
            matched_text=$(echo "$line" | cut -d':' -f3-)
            
            url=$(echo "$matched_text" | sed 's|runbook_url:||' | sed -e 's|^[[:space:]]*||' | sed -e 's|[[:space:]]*$||' | sed -e 's|#.*||g' | sed -e "s|[\"']||g")
            if [[ -z "$url" ]]; then
                continue
            fi

            # Skip URLs that don't start with https://intranet.giantswarm.io
            if [[ ! "$url" =~ ^https://intranet\.giantswarm\.io ]]; then
                continue
            fi

            # Check if url is in runbooks array
            if ! isInArray "$url" "${runbooks[@]}"; then
                local message="File $filename:$line_number links to nonexisting URL $url"
                E_unexistingrunbook+=("$message")
                # Store annotation data as pipe-separated values for JSON generation
                annotations_data+=("$filename|$line_number|$url")
                continue
            fi
        done <<< "$urls"
    done

    if [[ "${#E_unexistingrunbook[@]}" -gt 0 ]]; then
        echo ""
        echo "${#E_unexistingrunbook[@]} bad runbook URLs found" >> $GITHUB_STEP_SUMMARY
        for message in "${E_unexistingrunbook[@]}"; do
            echo "$message"
        done
        
        # Generate GitHub annotations JSON file
        echo ""
        echo "Writing GitHub annotations to /home/runner/work/prometheus-rules/annotations.json"
        generateAnnotationsJson "${annotations_data[@]}" > /home/runner/work/prometheus-rules/annotations.json
        
        returncode=1
    fi

    return "$returncode"
}

main "$@"
