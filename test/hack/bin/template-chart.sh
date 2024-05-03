#!/bin/bash

main() {
  local GIT_WORKDIR
  GIT_WORKDIR="$(git rev-parse --show-toplevel)"

  local -a providers
  mapfile -t providers <"$GIT_WORKDIR/test/conf/providers"

  for provider in "${providers[@]}"; do
    echo "Templating chart for provider: $provider"

    [[ $provider =~ ([a-z]+)/([a-z]+)(-[a-z]+) ]]
    [[ "${BASH_REMATCH[3]}" == "-mimir" ]] && mimir_enabled=true || mimir_enabled=false

    helm template \
      "$GIT_WORKDIR"/helm/prometheus-rules \
      --set="managementCluster.provider.flavor=${BASH_REMATCH[1]}" \
      --set="managementCluster.provider.kind=${BASH_REMATCH[2]}" \
      --set="managementCluster.name=myinstall" \
      --set="mimir.enabled=$mimir_enabled" \
      --output-dir "$GIT_WORKDIR"/test/hack/output/"$provider"
  done
}

main "$@"

#input="US/Central - 10:26 PM (CST)"
#[[ $input =~ ([0-9]+:[0-9]+) ]]
#echo ${BASH_REMATCH[1]}
