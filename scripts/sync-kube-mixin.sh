#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

TMPDIR="$(mktemp -d -t 'tmp.XXXXXXXXXX')"
trap 'cleanup' EXIT

function cleanup {
  rm -rf "$TMPDIR"
}

function main {
  local MIXIN_VER
  # make a temporary dir to work in
  local MIXIN_REPO="git@github.com:giantswarm/giantswarm-kubernetes-mixin.git"
  # clone a branch or tag if provided
  local BRANCH="${1:-}"

  if [[ -z "$BRANCH" ]]; then
      # clone the mixins repo
      echo -e "\nCloning master branch:\n"
      git clone --single-branch "$MIXIN_REPO" "$TMPDIR"/mixins
  else
      # clone the mixins repo branch or tag
      echo -e "\nCloning branch or tag '$BRANCH':\n"
      git clone --branch "$BRANCH" --single-branch "$MIXIN_REPO" "$TMPDIR"/mixins
  fi

  # get the current commit of the mixin repo
  cd "$TMPDIR"/mixins
  MIXIN_VER="$(git rev-parse HEAD)"
  cd - > /dev/null

  local RULESFILE="helm/prometheus-rules/templates/recording-rules/kubernetes-mixins.rules.yml"

  local PRECONTENT='apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  labels:
    {{- include "labels.common" . | nindent 4 }}
  name: kube-mixins.recording.rules
  namespace: {{ .Values.namespace  }}
spec:
'

  # copy generated rules file
  cp "$TMPDIR"/mixins/files/prometheus-rules/rules.yml "$RULESFILE"

  # prepend K8s objectmeta to the rules file
  printf '%s  %s' "$PRECONTENT" "$(cat "$RULESFILE")" > "$RULESFILE"

  echo -e "\nSynced mixin repo at commit: $MIXIN_VER\n"

  # tidy up
  cleanup
}

main "$@"
