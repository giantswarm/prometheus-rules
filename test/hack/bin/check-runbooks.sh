#!/usr/bin/env bash
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
        | tr '[:upper:]' '[:lower:]' \
        | sed "s|$privateRunbooksParentDirectory/content/|https://intranet.giantswarm.io/|g" \
        | sed 's/\/_index//g' # Removes the _index.md files and keep the directory name
    rm -rf "$privateRunbooksParentDirectory"
}

# Extract and clean URL from runbook_url value, handling templated URLs
extractRunbookUrl() {
    local raw_url="$1"
    local url
    
    # Remove runbook_url: prefix and trim whitespace
    url=$(echo "$raw_url" | sed 's|runbook_url:||' | sed -e 's|^[[:space:]]*||' | sed -e 's|[[:space:]]*$||')
    
    # Remove quotes (single or double)
    url=$(echo "$url" | sed -e "s|^[\"']||" | sed -e "s|[\"']$||")
    
    # Handle templated URLs with {{` ... `}} syntax
    if [[ "$url" =~ ^\{\{\`.*\`\}\}$ ]]; then
        # Extract content between {{` and `}}
        url=$(echo "$url" | sed 's|^{{`||' | sed 's|`}}$||')
    fi
    
    # Remove query parameters (everything after ?)
    url=$(echo "$url" | sed 's|?.*$||')
    
    # Remove fragment identifiers that might remain
    url=$(echo "$url" | sed 's|#.*$||')
    
    echo "$url"
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
            
            url=$(extractRunbookUrl "$matched_text")
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

    # Check for alerts that fire outside business hours but lack runbook URLs
    ########################
    
    # Find all alerts with severity: page that don't have cancel_if_outside_working_hours: "true"
    for rulesFile in $rulesFiles; do
        # Use yq to directly query YAML and find alerts missing runbook URLs
        "$GIT_WORKDIR/$YQ" eval '
            .spec.groups[]? |
            select(.rules) |
            .rules[] |
            select(.alert) |
            select(.labels.severity == "page") |
            select(.labels.cancel_if_outside_working_hours != "true") |
            select(.annotations.runbook_url == null or .annotations.runbook_url == "") |
            "'"$rulesFile"': Alert \"" + .alert + "\" (severity: page, no cancel_if_outside_working_hours) is missing runbook_url"
        ' "$rulesFile" 2>/dev/null || true
    done | while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            E_norunbook+=("$line")
        fi
    done

    if [[ "${#E_unexistingrunbook[@]}" -gt 0 ]]; then
        echo ""
        if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
            echo "${#E_unexistingrunbook[@]} bad runbook URLs found" >> $GITHUB_STEP_SUMMARY
        fi
        for message in "${E_unexistingrunbook[@]}"; do
            echo "$message"
        done
        
        if [[ -n "${GITHUB_ENV:-}" ]]; then
            # Generate GitHub annotations JSON file
            echo ""
            echo "Writing GitHub annotations to ./annotations.json"
            generateAnnotationsJson "${annotations_data[@]}" > ./annotations.json

            # Write to GITHUB_ENV for later steps
            echo "found_bad_urls=true" >> "$GITHUB_ENV"
        fi
        returncode=1
    fi

    if [[ "${#E_norunbook[@]}" -gt 0 ]]; then
        echo ""
        echo "${#E_norunbook[@]} alerts that fire outside business hours are missing runbook URLs:"
        if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
            echo "${#E_norunbook[@]} alerts missing runbook URLs (fire outside business hours)" >> "$GITHUB_STEP_SUMMARY"
        fi
        for message in "${E_norunbook[@]}"; do
            echo "$message"
        done
        returncode=1
    fi

    return "$returncode"
}

main "$@"
