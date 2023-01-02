#!/bin/bash

local GIT_WORKDIR
GIT_WORKDIR=$(git rev-parse --show-toplevel)

local -a providers
mapfile -t providers <"$GIT_WORKDIR/test/conf/providers"

for provider in "${providers[@]}"; do
    echo "Templating chart for provider: $provider"

    helm template \
    "$GIT_WORKDIR"/helm/prometheus-rules \
    --set="managementCluster.provider.kind=$provider" \
    --output-dir "$GIT_WORKDIR"/test/hack/output/"$provider"

done
