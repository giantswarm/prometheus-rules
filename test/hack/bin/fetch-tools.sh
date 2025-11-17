#!/usr/bin/env bash
set -euo pipefail

# let's have reproducable tests - pin to specific versions
ARCHITECT_VERSION="7.3.0"
HELM_VERSION="4.0.0"
JQ_VERSION="1.8.1"
LOKITOOL_VERSION="3.5.8"
PINT_VERSION="0.77.1"
PROMETHEUS_VERSION="3.7.3"
YQ_VERSION="4.48.1"

GIT_WORKDIR=$(git rev-parse --show-toplevel)
OS_BASE="$(uname -s)"

case "${OS_BASE}" in
Linux*)
    TAR_CMD="$(command -v tar)"

    export ARCHITECT_SOURCE="https://github.com/giantswarm/architect/releases/download/v${ARCHITECT_VERSION}/architect-v${ARCHITECT_VERSION}-linux-amd64.tar.gz"
    export HELM_SOURCE="https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
    export JQ_BIN_FILE="jq-linux-amd64"
    export JQ_SOURCE="https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux-amd64"
    export LOKITOOL_BIN_FILE="lokitool-linux-amd64"
    export LOKITOOL_SOURCE="https://github.com/grafana/loki/releases/download/v${LOKITOOL_VERSION}/lokitool-linux-amd64.zip"
    export PINT_BIN_FILE="pint-linux-amd64"
    export PINT_SOURCE="https://github.com/cloudflare/pint/releases/download/v${PINT_VERSION}/pint-${PINT_VERSION}-linux-amd64.tar.gz"
    export PROMETHEUS_SOURCE="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz"
    export YQ_BIN_FILE="yq_linux_amd64"
    export YQ_SOURCE="https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64.tar.gz"
    ;;

Darwin*)
    TAR_CMD="$(command -v gtar)"

    export ARCHITECT_SOURCE="https://github.com/giantswarm/architect/releases/download/v${ARCHITECT_VERSION}/architect-v${ARCHITECT_VERSION}-darwin-amd64.tar.gz"
    export HELM_SOURCE="https://get.helm.sh/helm-v${HELM_VERSION}-darwin-amd64.tar.gz"
    export JQ_BIN_FILE="jq-macos-amd64"
    export JQ_SOURCE="https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-macos-amd64"
    export LOKITOOL_BIN_FILE="lokitool-darwin-amd64"
    export LOKITOOL_SOURCE="https://github.com/grafana/loki/releases/download/v${LOKITOOL_VERSION}/lokitool-darwin-amd64.zip"
    export PINT_BIN_FILE="pint-darwin-amd64"
    export PINT_SOURCE="https://github.com/cloudflare/pint/releases/download/v${PINT_VERSION}/pint-${PINT_VERSION}-darwin-amd64.tar.gz"
    export PROMETHEUS_SOURCE="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.darwin-amd64.tar.gz"
    export YQ_BIN_FILE="yq_darwin_amd64"
    export YQ_SOURCE="https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_darwin_amd64.tar.gz"
    ;;

*)
    echo "${OS_BASE} not supported - if needed, please implement by your own."
    exit 1
    ;;

esac

download() {
    local sourceurl="$1" && shift
    local destfile="$1" && shift

    # download files only if they don't exist yet
    if [[ ! -f "$destfile" ]]; then
        echo "## Downloading $sourceurl"
        curl --silent --location --output "$destfile" "$sourceurl"
    fi

    if [[ ! -f "$destfile" ]]; then
        echo "## Failed downloading $destfile"
        return 1
    fi
}

extract() {
    local binfile="$1" && shift
    local sourceurl="$1" && shift
    local archivebinpath="$1" && shift
    local stripcomponents="${1:-1}" && shift || true

    local archivefile
    remotearchivefile="${sourceurl##*/}"
    archivefile="${TMP_DIR}/${remotearchivefile}"

    # extract files only if not exist yet
    if [[ ! -f "$binfile" ]]; then
        echo
        echo "## Installing $binfile"

        download "$sourceurl" "$archivefile"
        archivedir="$TMP_DIR/${remotearchivefile}.extracted"
        mkdir -p "$archivedir"

        case "$archivefile" in
          *.tar*)
            echo "## Contents for $archivefile:"
            "$TAR_CMD" --list --gzip --verbose --file "$archivefile"

            echo "## Extracted files:"
            "$TAR_CMD" --extract --gzip --verbose --file "$archivefile" \
                --directory "$archivedir" \
                --strip-components "$stripcomponents"
            ;;
          *.zip)
            echo "## Contents for $archivefile:"
            unzip -l "$archivefile"

            echo "## Extracted files:"
            unzip -q "$archivefile" -d "$archivedir" "$archivebinpath"
            ;;
          *)
            # assuming it's a binary
            mv "$archivefile" "$archivedir/$archivebinpath"
            ;;
        esac

        mv "$archivedir/$archivebinpath" "$binfile"
        chmod +x "$binfile"
    fi

    if [[ ! -f "$binfile" ]]; then
        echo "Failed downloading $binfile"
        return 1
    fi
}

main() {
    TMP_DIR="$(mktemp -d -t fetch-tools-XXXXXXXXXX)"
    trap 'rm -rf "$TMP_DIR"' EXIT

    extract \
        "${GIT_WORKDIR}/test/hack/bin/architect" \
        "$ARCHITECT_SOURCE" \
        "architect"

    extract \
        "${GIT_WORKDIR}/test/hack/bin/helm" \
        "$HELM_SOURCE" \
        "helm"

    extract \
        "${GIT_WORKDIR}/test/hack/bin/jq" \
        "$JQ_SOURCE" \
        "$JQ_BIN_FILE"

    extract \
        "${GIT_WORKDIR}/test/hack/bin/lokitool" \
        "$LOKITOOL_SOURCE" \
        "$LOKITOOL_BIN_FILE"

    extract \
        "${GIT_WORKDIR}/test/hack/bin/pint" \
        "$PINT_SOURCE" \
        "$PINT_BIN_FILE" \
        0

    extract \
        "${GIT_WORKDIR}/test/hack/bin/promtool" \
        "$PROMETHEUS_SOURCE" \
        "promtool"

    extract \
        "${GIT_WORKDIR}/test/hack/bin/yq" \
        "$YQ_SOURCE" \
        "$YQ_BIN_FILE"
}

main "$@"
