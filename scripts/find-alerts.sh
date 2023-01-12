#!/bin/bash
#
# Contributed during Xmas 2022 hackathon.
#

# Example how to run it:
# scripts/find-alerts.sh '.labels.team=="atlas"' '.labels.cancel_if_outside_working_hours=="true"' '.labels.severity=="page"'
# => will report all alerts for team Atlas that page but are canceled out of working hours.

# /!\ This script is provided as-is.
# It won't break anything in your files, but parameters management, help, error handling is missing.
# Meaning: no guarantee about the quality of generated output

# In this place we can file helm-generated rules
rulesFilesDir=test/tests/providers/aws/
# => prerequisite: have files generated. for instance "make test" starts with generating files.

# Custom (user-provided) filters
selectQueries=("$@")

# Build `jq` query from filters given as parameters
selectQueriesString="$(printf "| select(%s)\n" "${selectQueries[@]}")"

# For each rules file
for rulesFile in "$rulesFilesDir"/*.rules.yml; do

    # Retrieve (in an array) alert names that match the query
    mapfile -t alertsList < <(
        yq -ojson "$rulesFile" 2>/dev/null \
        | jq '.groups[].rules[]
            '"$selectQueriesString"'
            | .alert' 2>/dev/null
    ) || continue

    # Console output
    for alert in "${alertsList[@]}"; do
        echo "alert $alert - file $(basename "$rulesFile")"
    done
done
