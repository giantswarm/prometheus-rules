#!/bin/bash
set -euo pipefail

main() {
  local GIT_WORKDIR
  GIT_WORKDIR="$(git rev-parse --show-toplevel)"

  local -a providers
  mapfile -t providers <"$GIT_WORKDIR/test/conf/providers"

  rm -rf "$GIT_WORKDIR"/test/hack/output/helm-chart/

  for provider in "${providers[@]}"; do
    echo "Templating chart for provider: $provider"

    helm template \
      "$GIT_WORKDIR"/helm/prometheus-rules \
      --set="managementCluster.provider.flavor=capi" \
      --set="managementCluster.provider.kind=$provider" \
      --set="managementCluster.name=myinstall" \
      --set="managementCluster.pipeline=stable" \
      --output-dir "$GIT_WORKDIR"/test/hack/output/helm-chart/"$provider"
  done
}

main "$@"
