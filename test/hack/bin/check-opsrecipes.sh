#!/bin/bash
set -euo pipefail

# List of generated rules
RULES_FILES=(./test/hack/output/*/prometheus-rules/templates/alerting-rules/*)
#RULES_FILES=(./test/hack/output/*/prometheus-rules/templates/alerting-rules/up*)

DEBUG_MODE=false
CHECK_EXTRADATA_ERRORS=true
CHECK_NORECIPE_ERRORS=true
CHECK_UNEXISTINGRECIPE_ERRORS=true

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


listOpsRecipes () {
    # find list of opsrecipes from git repo
    tmpDir="$(mktemp -d)"
    git clone --depth 1 --single-branch -b main -q git@github.com:giantswarm/giantswarm.git "$tmpDir"
    # find all ops-recipes ".md" files, and keep only the opsrecipe name (may contain a path, like "rolling-nodes/rolling-nodes")
    find "$tmpDir"/content/docs/support-and-ops/ops-recipes -type f -name \*.md \
        | sed -n 's_'"$tmpDir"'/content/docs/support-and-ops/ops-recipes/\(.*\).md_\1_p'
    rm -rf "$tmpDir"

    # Add extra opsrecipes
    # These ones are defined as aliases of `deployment-not-satisfied`:
    echo "workload-cluster-managed-deployment-not-satisfied"
    echo "workload-cluster-deployment-not-satisfied"
    echo "deployment-not-satisfied-china"
}


main() {
    local -a checkedRules=()
    local -a opsRecipes=()
    local -a E_extradata=()
    local -a E_norecipe=()
    local -a E_unexistingrecipe=()
    local returncode=0

    # Investigation section
    ########################

    # Retrieve list of opsrecipes
    mapfile -t opsRecipes < <(listOpsRecipes)

    if [[ "$DEBUG_MODE" != "false" ]]; then
        echo "List of opsrecipe:"
        for recipe in "${opsRecipes[@]}"; do
            echo " - \"$recipe\""
        done
    fi

    # Look at each rules file
    for rulesFile in "${RULES_FILES[@]}" ; do
        # echo "rules file: $rulesFile"
        prettyRulesFilename="$(basename "$rulesFile")"

        # skip if rules file has already been checked
        isInArray "$prettyRulesFilename" "${checkedRules[@]}" \
            && continue

        while read -r alertname opsrecipe severity overflow ; do

            # Discard non-paging alerts
            [[ "$severity" != "page" ]] && continue

            # Get rid of anchors
            opsrecipe="${opsrecipe%%#*}"
            # Get rid of trailing slash
            opsrecipe="${opsrecipe%/}"

            # There should be no data in $overflow
            # If there is, it means something went wrong with the parsing
            if [[ "$overflow" != "" ]]; then
                local message="file: $prettyRulesFilename / alert \"$alertname\" / recipe \"$opsrecipe\": extra data \"$overflow\""
                E_extradata+=("$message")
                continue
            fi

            # When there is no opsrecipe annotation, yq outputs "null"
            if [[ "$opsrecipe" == "null" ]]; then
                local message="file $prettyRulesFilename / alert \"$alertname\" has no opsrecipe"
                E_norecipe+=("$message")
                continue
            fi

            # Let's check if the opsrecipe is in our list of existing opsrecipes
            if ! isInArray "$opsrecipe" "${opsRecipes[@]}"; then
                local message="file $prettyRulesFilename / alert \"$alertname\" links to unexisting opsrecipe (\"$opsrecipe\")"
                E_unexistingrecipe+=("$message")
                continue
            fi

            if [[ "$DEBUG_MODE" != "false" ]]; then
                echo "file $prettyRulesFilename / alert: $alertname / recipe: $opsrecipe - OK"
            fi
        # parse rules yaml files, and for each rule found output alertname, opsrecipe, and severity, space-separated, on one line.
        done < <(yq -o json "$rulesFile" | jq -j '.spec.groups[].rules[] | .alert, " ", .annotations.opsrecipe, " ", .labels.severity, "\n"')

        checkedRules+=("$prettyRulesFilename")
    done

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
    if [[ "$CHECK_NORECIPE_ERRORS" != "false" ]]; then
        if [[ "${#E_norecipe[@]}" -gt 0 ]]; then
            echo ""
            echo "Alerts missing recipe: ${#E_norecipe[@]}"
            for message in "${E_norecipe[@]}"; do
                echo "$message"
            done
            returncode=1
        fi
    fi
    if [[ "$CHECK_UNEXISTINGRECIPE_ERRORS" != "false" ]]; then
        if [[ "${#E_unexistingrecipe[@]}" -gt 0 ]]; then
            echo ""
            echo "Alerts using unexisting recipe: ${#E_unexistingrecipe[@]}"
            for message in "${E_unexistingrecipe[@]}"; do
                echo "$message"
            done
            returncode=1
        fi
    fi

    return "$returncode"
}

main "$@"
