#!/usr/bin/env bash
set -euo pipefail

# let's have reproducable tests - pin to specific versions
ARCHITECT_VERSION="6.8.0"
PROMETHEUS_VERSION="2.41.0"
HELM_VERSION="3.9.0"
YQ_VERSION="4.26.1"

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
    ;;

Darwin*)
    export PROMETHEUS_SOURCE="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.darwin-amd64.tar.gz"
    export HELM_SOURCE="https://get.helm.sh/helm-v${HELM_VERSION}-darwin-amd64.tar.gz"
    export ARCHITECT_SOURCE="https://github.com/giantswarm/architect/releases/download/v${ARCHITECT_VERSION}/architect-v${ARCHITECT_VERSION}-darwin-amd64.tar.gz"
    export YQ_SOURCE="https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_darwin_amd64.tar.gz"
    export YQ_BIN_FILE="yq_darwin_amd64"
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

    # extract files only if not exist yet
    if [[ ! -f "$binfile" ]]; then

        download "$sourceurl" "$tarfile"

        echo ""
        echo "## Contents for $tarfile:"
        "$TAR_CMD" -tzvf "$tarfile"

        echo "## Extracted files:"
        "$TAR_CMD" -xvf "$tarfile" \
            -C "$GIT_WORKDIR/test/hack/bin/" \
            --strip-components=1 \
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
    if [[ ! -f "${GIT_WORKDIR}/test/hack/bin/yq" ]]; then
        ln -s "${GIT_WORKDIR}/test/hack/bin/${YQ_BIN_FILE}" "${GIT_WORKDIR}/test/hack/bin/yq"
    fi
}

main "$@"
