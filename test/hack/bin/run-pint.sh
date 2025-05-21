#!/bin/bash

set -euo pipefail

## Arguments:

# 1. config file
# 2. team filter (optional)


main () {
    echo "Running Pint"

    local GIT_WORKDIR
    GIT_WORKDIR="$(git rev-parse --show-toplevel)"

    local -a PINT_FILES_LIST
    local -a PROVIDERS

    PINT_CONFIG="${1:-test/conf/pint/pint-config.hcl}"
    mapfile -t PROVIDERS <"$GIT_WORKDIR/test/conf/providers"

    if [[ "${2:-}" != "" ]]; then
        for provider in "${PROVIDERS[@]}"; do
            mapfile -t PINT_FILES_LIST < <(grep -lr "team:.*${PINT_TEAM_FILTER}" "test/hack/output/generated/$provider/" | grep -v ".test.yml")
        done
    else
        for provider in "${PROVIDERS[@]}"; do
            mapfile -t PINT_FILES_LIST < <(find test/hack/output/generated/$provider/ -name "*.rules.yml")
        done
    fi

    test/hack/bin/pint -c "$PINT_CONFIG" lint "${PINT_FILES_LIST[@]}"
}

main "$@"
