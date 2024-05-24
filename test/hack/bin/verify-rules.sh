#!/bin/bash
set -euo pipefail
#
# This test ensures that all prometheus rules are valid
#

set -eu

# Global options

## GENERATE_ONLY: if set to true, the script will only generate the rules files
GENERATE_ONLY="${GENERATE_ONLY:-false}"

array_contains() {
    local search="$1" && shift

    local element
    for element; do
        if [[ "$element" == "$search" ]]; then
            return 0
        fi
    done
    return 1
}

main() {
    # Filter (grep) rules files to test
    filter="${1:-}"

    START_TIME="$(date +%s)"
    echo "$(date '+%H:%M:%S') promtool: start"

    local GIT_WORKDIR
    GIT_WORKDIR=$(git rev-parse --show-toplevel)

    local PROMTOOL=test/hack/bin/promtool
    local YQ=test/hack/bin/yq

    expected_failure_relative_file_global="test/conf/promtool_ignore"
    expected_failure_file_global="$GIT_WORKDIR/$expected_failure_relative_file_global"

    # Retrieve all files we're going to check
    local -a all_files
    mapfile -t all_files < <(
        cd "$GIT_WORKDIR" || return 1
        # filter alerting-rules files, and remove prefix `helm/prometheus-rules/templates/`
        git ls-files |
            sed -En 's_^helm/prometheus-rules/templates/((alerting|recording)-rules/.*\.ya?ml)$_\1_p' || echo error
    )

    # Get prefixes whitelisted via the failure_file
    local -a expected_failure_prefixes_global=()
    [[ -f "$expected_failure_file_global" ]] \
        && mapfile -t expected_failure_prefixes_global <"$expected_failure_file_global"

    local -a providers
    mapfile -t providers <"$GIT_WORKDIR/test/conf/providers"

    local -a promtool_check_errors=()
    local -a promtool_test_errors=()
    local -a failing_extraction=()

    # Create generated directory with all test files
    local outputPath="$GIT_WORKDIR/test/hack/output"
    [[ -d "$outputPath/generated" ]] || cp -r "$GIT_WORKDIR/test/tests/providers/." "$outputPath/generated/"
    # We remove the global directory
    rm -rf "$outputPath/generated/global"

    for provider in "${providers[@]}"; do
        # We need to copy the global test files in every provider directory
        rsync -a "$GIT_WORKDIR/test/tests/providers/global/alerting-rules/" "$outputPath/generated/$provider/alerting-rules"

        echo "### Running tests for provider: $provider"

        # Get the list of whitelisted files for this provider
        local expected_failure_relative_file_provider="test/conf/promtool_ignore_$provider"
        local expected_failure_file_provider="$GIT_WORKDIR/$expected_failure_relative_file_provider"
        local -a expected_failure_prefixes_provider=()
        [[ -f "$expected_failure_file_provider" ]] \
            && mapfile -t expected_failure_prefixes_provider <"$expected_failure_file_provider"

        # Look at each rules file for current provider
        cd "$outputPath/generated/$provider"
        while IFS= read -r -d '' file; do
            # Remove "./" at the vbeggining of the file path
            file="${file#./}"

            [[ ! "$file" =~ .*$filter.* ]] && continue

            echo "###  Testing $file"

            # retrieve basename and dirname in pure bash
            local filename="${file##*/}"
            local dirname="${file%/*}"
            local filenameWithoutExtension="${filename%.*}"

            # Extract rules file from helm template
            if [[ -f "$outputPath/helm-chart/$provider/prometheus-rules/templates/$file" ]]
            then
                [[ -d "$outputPath/generated/$provider/$dirname" ]] || mkdir -p "$outputPath/generated/$provider/$dirname"
                "$GIT_WORKDIR/$YQ" '.spec' "$outputPath/helm-chart/$provider/prometheus-rules/templates/$file" > "$outputPath/generated/$provider/$file"
            else
                # Fail when file is not found
                echo "###    Failed extracting rules file $file"
                failing_extraction+=("$provider:$file")
                continue
            fi

            # Skip next steps if GENERATE_ONLY is set
            if [[ "$GENERATE_ONLY" == "true" ]]; then continue; fi

            # Syntax check of rules file
            echo "###    promtool check rules $outputPath/generated/$provider/$file"
            local promtool_check_output
            if ! promtool_check_output="$("$GIT_WORKDIR/$PROMTOOL" check rules "$outputPath/generated/$provider/$file" 2>&1)";
            then
                echo "###   Syntax check failing for $file:"
                echo "$promtool_check_output"
                promtool_check_errors+=("$promtool_check_output")
                continue
            fi

            local provider_testfile="$outputPath/generated/$provider/$dirname/$filenameWithoutExtension.test.yml"


            # if the file is whitelisted via the global ignore file
            if array_contains "$file" "${expected_failure_prefixes_global[@]}"; then
                # don't run tests for it
                echo "###    Skipping $file: listed in $expected_failure_relative_file_global"
                continue
            fi
            # if the file is whitelisted via the provider ignore file
            if array_contains "$file" "${expected_failure_prefixes_provider[@]}"; then
                # don't run tests for it
                echo "###    Skipping $file: listed in $expected_failure_relative_file_provider"
                continue
            fi

            # Fail if no testfile found
            if [[ ! -f "$provider_testfile" ]]
            then
                echo "###  Warning: no testfile found for $filename"
                continue
            fi

            local promtool_test_output

            if [[ -f "$provider_testfile" ]]; then
                echo "###    promtool test rules $filenameWithoutExtension.test.yml - $provider"
                promtool_test_output="$("$GIT_WORKDIR/$PROMTOOL" test rules "$provider_testfile" 2>&1)" ||
                    promtool_test_errors+=("$promtool_test_output")
            fi

        done < <(find . -type f -name "*rules.yml" -print0)
    done

    # Job is done, print end time
    echo "$(date '+%H:%M:%S') promtool: end (Elapsed time: $(($(date +%s) - START_TIME))s)"

    # Final output
    # Bypassed checks
    if [[ ${#failing_extraction[@]} -gt 0 ]]; then
        echo
        echo "Warning: some files could not be generated:"
        for file in "${failing_extraction[@]}"; do
            echo " - $file"
        done
        echo
    fi

    # Test results
    if [[ ${#promtool_test_errors[@]} -eq 0 && ${#promtool_check_errors[@]} -eq 0 ]]; then
        echo
        echo "Congratulations!  Prometheus rules have been promtool checked and tested"
    else
        echo
        echo "Please review the below errors."
        echo
        for err in "${promtool_test_errors[@]}"; do
            echo "  $err"
            echo
        done

        for err in "${promtool_check_errors[@]}"; do
            echo "  $err"
            echo
        done
        return 1
    fi
}

main "$@"
