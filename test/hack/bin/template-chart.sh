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

    [[ $provider =~ ([a-z]+)/([a-z]+)([-]*[a-z]*) ]]

    helm template \
      "$GIT_WORKDIR"/helm/prometheus-rules \
      --set="managementCluster.provider.flavor=${BASH_REMATCH[1]}" \
      --set="managementCluster.provider.kind=${BASH_REMATCH[2]}" \
      --set="managementCluster.name=myinstall" \
      --set="managementCluster.pipeline=stable" \
      --output-dir "$GIT_WORKDIR"/test/hack/output/helm-chart/"$provider"
  done
}

main "$@"
