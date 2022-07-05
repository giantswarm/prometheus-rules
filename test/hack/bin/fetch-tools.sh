#!/usr/bin/env bash

# let's have reproducable tests - pin to specific versions
ARCHITECT_VERSION="6.5.0"
PROMETHEUS_VERSION="2.36.2"
HELM_VERSION="3.9.0"

GIT_WORKDIR=$(git rev-parse --show-toplevel)

OS_BASE="$(uname -s)"
case "${OS_BASE}" in
    Linux*)
        export PROMETHEUS_SOURCE="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz"
        export HELM_SOURCE="https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
        export ARCHITECT_SOURCE="https://github.com/giantswarm/architect/releases/download/v${ARCHITECT_VERSION}/architect-v${ARCHITECT_VERSION}-linux-amd64.tar.gz"
        ;;

    Darwin*)
        export PROMETHEUS_SOURCE="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.darwin-amd64.tar.gz"
        export HELM_SOURCE="https://get.helm.sh/helm-v${HELM_VERSION}-darwin-amd64.tar.gz"
        export ARCHITECT_SOURCE="https://github.com/giantswarm/architect/releases/download/v${ARCHITECT_VERSION}/architect-v${ARCHITECT_VERSION}-darwin-amd64.tar.gz"
        ;;
        
    *)
        echo "${OS_BASE} not supported - if needed, please implement by your own." 

esac

# download files only if they don't exist yet
if [[ ! -f ${GIT_WORKDIR}/test/hack/bin/helm-${HELM_VERSION}.tar.gz ]]; then
    curl -L -o ${GIT_WORKDIR}/test/hack/bin/helm-${HELM_VERSION}.tar.gz ${HELM_SOURCE}
fi

if [[ ! -f ${GIT_WORKDIR}/test/hack/bin/prometheus-${PROMETHEUS_VERSION}.tar.gz ]]; then
    curl -L -o ${GIT_WORKDIR}/test/hack/bin/prometheus-${PROMETHEUS_VERSION}.tar.gz ${PROMETHEUS_SOURCE}
fi

if [[ ! -f ${GIT_WORKDIR}/test/hack/bin/architect-${ARCHITECT_VERSION}.tar.gz ]]; then
    curl -L -o ${GIT_WORKDIR}/test/hack/bin/architect-${ARCHITECT_VERSION}.tar.gz ${ARCHITECT_SOURCE}
fi

# extract files only if not exist yet
if [[ ! -f ${GIT_WORKDIR}/test/hack/bin/promtool ]]; then
    tar -tzvf ${GIT_WORKDIR}/test/hack/bin/prometheus-${PROMETHEUS_VERSION}.tar.gz
    tar -xvf ${GIT_WORKDIR}/test/hack/bin/prometheus-${PROMETHEUS_VERSION}.tar.gz -C ${GIT_WORKDIR}/test/hack/bin/ --strip-components=1 --wildcards "prometheus-${PROMETHEUS_VERSION}*/promtool"
fi

if [[ ! -f ${GIT_WORKDIR}/test/hack/bin/helm ]]; then
    tar -tzvf ${GIT_WORKDIR}/test/hack/bin/helm-${HELM_VERSION}.tar.gz
    tar -xvf ${GIT_WORKDIR}/test/hack/bin/helm-${HELM_VERSION}.tar.gz -C ${GIT_WORKDIR}/test/hack/bin/ --strip-components=1 --wildcards "*/helm"
fi

if [[ ! -f ${GIT_WORKDIR}/test/hack/bin/architect ]]; then
    tar -tzvf ${GIT_WORKDIR}/test/hack/bin/architect-${ARCHITECT_VERSION}.tar.gz
    tar -xvf ${GIT_WORKDIR}/test/hack/bin/architect-${ARCHITECT_VERSION}.tar.gz -C ${GIT_WORKDIR}/test/hack/bin/ --strip-components=1 --wildcards "architect-v${ARCHITECT_VERSION}-*/architect"
fi



