#!/bin/bash
set -euo pipefail
#
# This test ensures that all prometheus rules are valid
#

set -eu

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

    START_TIME="$(date +%s)"
    echo "$(date '+%H:%M:%S') promtool: start"

    local GIT_WORKDIR
    GIT_WORKDIR=$(git rev-parse --show-toplevel)

    local PROMTOOL=test/hack/bin/promtool
    local HELM=test/hack/bin/helm
    local ARCHITECT=test/hack/bin/architect
    local YQ=test/hack/bin/yq

    # prepare the helm chart
    echo "### Helm chart preparation"
    "$GIT_WORKDIR/$ARCHITECT" helm template --dir "$GIT_WORKDIR/helm/prometheus-rules" --dry-run

    expected_failure_relative_file_global="test/conf/promtool_ignore"
    expected_failure_file_global="$GIT_WORKDIR/$expected_failure_relative_file_global"

    # Retrieve all files we're going to check
    local -a all_files
    mapfile -t all_files < <(
        cd "$GIT_WORKDIR" || return 1
        # filter alerting-rules files, and remove prefix `helm/prometheus-rules/`
        git ls-files |
            sed -En 's_^helm/prometheus-rules/(templates/alerting-rules/.*\.ya?ml)$_\1_p' || echo error
    )

    # Get prefixes whitelisted via the failure_file
    local -a expected_failure_prefixes_global=()
    [[ -f "$expected_failure_file_global" ]] \
        && mapfile -t expected_failure_prefixes_global <"$expected_failure_file_global"

    local -a providers
    mapfile -t providers <"$GIT_WORKDIR/test/conf/providers"

    local -a promtool_check_errors=()
    local -a promtool_test_errors=()

    for provider in "${providers[@]}"; do
        echo "### Running tests for provider: $provider"

        # Get the list of whitelisted files for this provider
        local expected_failure_relative_file_provider="test/conf/promtool_ignore_$provider"
        local expected_failure_file_provider="$GIT_WORKDIR/$expected_failure_relative_file_provider"
        local -a expected_failure_prefixes_provider=()
        [[ -f "$expected_failure_file_provider" ]] \
            && mapfile -t expected_failure_prefixes_provider <"$expected_failure_file_provider"

        for file in "${all_files[@]}"; do

            # if the file is whitelisted via the global ignore file
            if array_contains "$file" "${expected_failure_prefixes_global[@]}"; then
                # don't run tests for it
                echo "###  Skipping $file: listed in $expected_failure_relative_file_global"
                continue
            fi
            # if the file is whitelisted via the provider ignore file
            if array_contains "$file" "${expected_failure_prefixes_provider[@]}"; then
                # don't run tests for it
                echo "###  Skipping $file: listed in $expected_failure_relative_file_provider"
                continue
            fi

            echo "###  Testing $file"

            # retrieve basename in pure bash
            filename="${file##*/}"

            # don't run tests if no provider specific tests are defined
            if [[ ! -d "$GIT_WORKDIR/test/tests/providers/$provider" ]]; then
                echo "###   No tests for proviter $provider - skipping"
                continue
            fi

            echo "###    extracting $GIT_WORKDIR/test/providers/$provider/$filename"
            "$GIT_WORKDIR/$HELM" template \
                --set="managementCluster.provider.kind=$provider" \
                --release-name prometheus-rules \
                --namespace giantswarm "$GIT_WORKDIR"/helm/prometheus-rules \
                -s "$file" |
                "$GIT_WORKDIR/$YQ" '.spec' - >"$GIT_WORKDIR/test/tests/providers/$provider/$filename"

            echo "###    promtool check rules $GIT_WORKDIR/test/tests/providers/$provider/$filename"
            local promtool_check_output
            promtool_check_output="$("$GIT_WORKDIR/$PROMTOOL" check rules "$GIT_WORKDIR/test/tests/providers/$provider/$filename" 2>&1)" ||
                promtool_check_errors+=("$promtool_check_output")

            local global_testfile="$GIT_WORKDIR/test/tests/providers/global/${filename%.yml}.test.yml"
            local provider_testfile="$GIT_WORKDIR/test/tests/providers/$provider/${filename%.yml}.test.yml"

            # Fail if no testfile found
            if [[ ! -f "$global_testfile" ]] \
                && [[ ! -f "$provider_testfile" ]]
            then
                echo "### No testfile found for $filename - error"
                promtool_test_errors+=("NO TEST FILE for $filename")
                continue
            fi

            local promtool_test_output

            if [[ -f "$global_testfile" ]]; then
                echo "###    promtool test rules ${filename%.yml}.test.yml - global"
                promtool_test_output="$("$GIT_WORKDIR/$PROMTOOL" test rules "$global_testfile" 2>&1)" ||
                    promtool_test_errors+=("$promtool_test_output")
            fi

            if [[ -f "$provider_testfile" ]]; then
                echo "###    promtool test rules ${filename%.yml}.test.yml - $provider"
                promtool_test_output="$("$GIT_WORKDIR/$PROMTOOL" test rules "$provider_testfile" 2>&1)" ||
                    promtool_test_errors+=("$promtool_test_output")
            fi

        done
    done

    # Cleanup
    git checkout -- "$GIT_WORKDIR/helm/prometheus-rules/Chart.yaml"
    git checkout -- "$GIT_WORKDIR/helm/prometheus-rules/values.yaml"

    # Job is done, print end time
    echo "$(date '+%H:%M:%S') promtool: end (Elapsed time: $(($(date +%s) - START_TIME))s)"

    # Final output
    if [[ ${#promtool_test_errors[@]} -eq 0 && ${#promtool_check_errors[@]} -eq 0 ]]; then
        echo "Congratulations!  All prometheus rules have been promtool checked."
    else
        {
            echo
            echo "Please review the below errors."
            echo
            for err in "${promtool_test_errors[@]}"; do
                echo "  $err"
            done

            for err in "${promtool_check_errors[@]}"; do
                echo "  $err"
            done
        } >&2
        false
    fi
}

main "$@"
