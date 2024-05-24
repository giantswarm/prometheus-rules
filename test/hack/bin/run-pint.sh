#!/bin/bash

set -euo pipefail

## Arguments:

# 1. config file
# 2. team filter (optional)


main () {
    echo "Running Pint"
    declare -a PINT_FILES_LIST

    PINT_CONFIG="${1:-test/conf/pint/pint-config.hcl}"

    if [[ "${2:-}" != "" ]]; then
        mapfile -t PINT_FILES_LIST < <(grep -lr "team:.*${PINT_TEAM_FILTER}" "test/hack/output/generated/capi/capa-mimir/" | grep -v ".test.yml")
    else
        mapfile -t PINT_FILES_LIST < <(find test/hack/output/generated/capi/capa-mimir/ -name "*.rules.yml")
    fi

    test/hack/bin/pint -c "$PINT_CONFIG" lint "${PINT_FILES_LIST[@]}"
}

main "$@"
