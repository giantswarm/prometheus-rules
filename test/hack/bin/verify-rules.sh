#!/bin/bash
set -euo pipefail

#
# This test ensures that all prometheus rules are valid
#

set -eu

function array_contains() {
    local search="$1" && shift

    local element
    for element; do
        if [[ "$element" == "$search" ]]; then
            return 0
        fi
    done
    return 1
}

function main() {

    START_TIME="$(date +%s)"
    echo "$(date '+%H:%M:%S') promtool: start"

    local GIT_WORKDIR
    GIT_WORKDIR=$(git rev-parse --show-toplevel)

    local PROMTOOL=test/hack/bin/promtool
    local HELM=test/hack/bin/helm
    local ARCHITECT=test/hack/bin/architect

    # prepare the helm chart
    echo "### Helm chart preparation"
    "$GIT_WORKDIR/$ARCHITECT" helm template --dir "$GIT_WORKDIR/helm/prometheus-rules" --dry-run

    expected_failure_relative_file="test/hack/allowlist/.promtool_ignore"
    expected_failure_file="$GIT_WORKDIR/$expected_failure_relative_file"

    # Retrieve all files we're going to check
    local -a all_files
    mapfile -t all_files < <(
        cd "$GIT_WORKDIR" || return 1
        # filter alerting-rules files, and remove prefix `helm/prometheus-rules/`
        git ls-files \
            | sed -En 's_^helm/prometheus-rules/(templates/alerting-rules/.*\.ya?ml)$_\1_p' || echo error
    )

    # Get prefixes whitelisted via the failure_file
    local -a expected_failure_prefixes
    mapfile -t expected_failure_prefixes <"$expected_failure_file"

    local -a providers
    mapfile -t providers <"$GIT_WORKDIR/test/hack/allowlist/providers"

    local -a promtool_check_errors=()
    local -a promtool_test_errors=()

    for file in "${all_files[@]}"; do

        # if the $file is whitelisted via the $expected_failure_file
        if array_contains "$file" "${expected_failure_prefixes[@]}"; then
            # don't run tests for it
            echo "### Skipping $file"
            continue
        fi

        echo "### Testing $file"
        for provider in "${providers[@]}"; do
            echo "###    Provider: $provider"

            # retrieve basename in pure bash
            filename="${file##*/}"

            # don't run tests if no provider specific tests are defined
            if [[ ! -d "$GIT_WORKDIR/test/providers/$provider" ]]; then
                echo "###   No tests for proviter $provider - skipping"
                continue
            fi

            echo "###    extracting $GIT_WORKDIR/test/providers/$provider/$filename"
            "$GIT_WORKDIR/$HELM" template \
                --set="managementCluster.provider.kind=$provider" \
                --release-name prometheus-rules \
                --namespace giantswarm "$GIT_WORKDIR"/helm/prometheus-rules \
                -s "$file" \
                | yq '.spec' - > "$GIT_WORKDIR/test/providers/$provider/$filename"

            echo "###    promtool check rules $GIT_WORKDIR/test/providers/$provider/$filename"
            local promtool_check_output
            promtool_check_output="$("$GIT_WORKDIR/$PROMTOOL" check rules "$GIT_WORKDIR/test/providers/$provider/$filename" 2>&1)" \
                || promtool_check_errors+=("$promtool_check_output")

            local promtool_test_output
            local testfile="$GIT_WORKDIR/test/providers/$provider/${filename%.yml}.test.yml"
            if [[ ! -f "$testfile" ]]; then
                echo "###    testfile $testfile not found, skipping promtool test"
            fi
            echo "###    promtool test rules ${filename%.yml}.test.yml"
            promtool_test_output="$("$GIT_WORKDIR/$PROMTOOL" test rules "$testfile" 2>&1)" \
                || promtool_test_errors+=("$promtool_test_output")

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
