#!/usr/bin/env bash
set -euo pipefail

# let's have reproducable tests - pin to specific versions
ARCHITECT_VERSION="6.17.0"
PROMETHEUS_VERSION="2.54.0"
HELM_VERSION="3.1.0"
YQ_VERSION="4.44.3"
JQ_VERSION="1.7.1"
PINT_VERSION="0.64.0"

GIT_WORKDIR=$(git rev-parse --show-toplevel)

OS_BASE="$(uname -s)"
TAR_CMD="tar"
case "${OS_BASE}" in
Linux*)
    export PROMETHEUS_SOURCE="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz"
    export HELM_SOURCE="https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
    export ARCHITECT_SOURCE="https://github.com/giantswarm/architect/releases/download/v${ARCHITECT_VERSION}/architect-v${ARCHITECT_VERSION}-linux-amd64.tar.gz"
    export YQ_SOURCE="https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64.tar.gz"
    export YQ_BIN_FILE="yq_linux_amd64"
    export JQ_SOURCE="https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux-amd64"
    export JQ_BIN_FILE="jq"
    export PINT_SOURCE="https://github.com/cloudflare/pint/releases/download/v${PINT_VERSION}/pint-${PINT_VERSION}-linux-amd64.tar.gz"
    export PINT_BIN_FILE="pint-linux-amd64"
    ;;

Darwin*)
    export PROMETHEUS_SOURCE="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.darwin-amd64.tar.gz"
    export HELM_SOURCE="https://get.helm.sh/helm-v${HELM_VERSION}-darwin-amd64.tar.gz"
    export ARCHITECT_SOURCE="https://github.com/giantswarm/architect/releases/download/v${ARCHITECT_VERSION}/architect-v${ARCHITECT_VERSION}-darwin-amd64.tar.gz"
    export YQ_SOURCE="https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_darwin_amd64.tar.gz"
    export YQ_BIN_FILE="yq_darwin_amd64"
    export JQ_SOURCE="https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-macos-amd64"
    export JQ_BIN_FILE="jq"
    export PINT_SOURCE="https://github.com/cloudflare/pint/releases/download/v${PINT_VERSION}/pint-${PINT_VERSION}-darwin-amd64.tar.gz"
    export PINT_BIN_FILE="pint-darwin-amd64"
    TAR_CMD="gtar"
    ;;

*)
    echo "${OS_BASE} not supported - if needed, please implement by your own."
    exit 1
    ;;

esac

download() {
    local sourcefile="$1" && shift
    local destfile="$1" && shift

    # download files only if they don't exist yet
    if [[ ! -f "$destfile" ]]; then
        echo "Downloading $destfile"
        curl -s -L -o "$destfile" "$sourcefile"
    fi

    if [[ ! -f "$destfile" ]]; then
        echo "Failed downloading $destfile"
        return 1
    fi
}

extract() {
    local binfile="$1" && shift
    local tarfile="$1" && shift
    local sourceurl="$1" && shift
    local wildcards="$1" && shift
    local stripcomponents="${1:-1}" && shift || true

    # extract files only if not exist yet
    if [[ ! -f "$binfile" ]]; then

        download "$sourceurl" "$tarfile"

        echo ""
        echo "## Contents for $tarfile:"
        "$TAR_CMD" -tzvf "$tarfile"

        echo "## Extracted files:"
        "$TAR_CMD" -xvf "$tarfile" \
            -C "$GIT_WORKDIR/test/hack/bin/" \
            --strip-components="$stripcomponents" \
            --wildcards "$wildcards"
    fi

    if [[ ! -f "$binfile" ]]; then
        echo "Failed downloading $binfile"
        return 1
    fi
}

main() {
    extract \
        "${GIT_WORKDIR}/test/hack/bin/promtool" \
        "$GIT_WORKDIR/test/hack/bin/prometheus-$PROMETHEUS_VERSION.tar.gz" \
        "$PROMETHEUS_SOURCE" \
        "prometheus-$PROMETHEUS_VERSION*/promtool"
    extract \
        "${GIT_WORKDIR}/test/hack/bin/helm" \
        "${GIT_WORKDIR}/test/hack/bin/helm-${HELM_VERSION}.tar.gz" \
        "$HELM_SOURCE" \
        "*/helm"
    extract \
        "${GIT_WORKDIR}/test/hack/bin/architect" \
        "${GIT_WORKDIR}/test/hack/bin/architect-${ARCHITECT_VERSION}.tar.gz" \
        "$ARCHITECT_SOURCE" \
        "architect-v${ARCHITECT_VERSION}-*/architect"
    extract \
        "${GIT_WORKDIR}/test/hack/bin/${YQ_BIN_FILE}" \
        "${GIT_WORKDIR}/test/hack/bin/yq-${YQ_VERSION}.tar.gz" \
        "$YQ_SOURCE" \
        "*/yq_*"
    download \
        "${JQ_SOURCE}" \
        "${GIT_WORKDIR}/test/hack/bin/${JQ_BIN_FILE}"
    chmod +x "${GIT_WORKDIR}/test/hack/bin/${JQ_BIN_FILE}"
    if [[ ! -f "${GIT_WORKDIR}/test/hack/bin/yq" ]]; then
        ln -s "${GIT_WORKDIR}/test/hack/bin/${YQ_BIN_FILE}" "${GIT_WORKDIR}/test/hack/bin/yq"
    fi
    extract \
        "${GIT_WORKDIR}/test/hack/bin/${PINT_BIN_FILE}" \
        "${GIT_WORKDIR}/test/hack/bin/pint-${PINT_VERSION}.tar.gz" \
        "$PINT_SOURCE" \
        "pint-*" \
        0
    if [[ ! -f "${GIT_WORKDIR}/test/hack/bin/pint" ]]; then
        ln -s "${GIT_WORKDIR}/test/hack/bin/${PINT_BIN_FILE}" "${GIT_WORKDIR}/test/hack/bin/pint"
    fi
}

main "$@"
