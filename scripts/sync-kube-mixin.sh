#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# make a temporary dir to work in
TMPDIR=$(mktemp -d -t 'tmp.XXXXXXXXXX')
trap 'rm -f $TMPDIR' EXIT
MIXIN_REPO="git@github.com:giantswarm/giantswarm-kubernetes-mixin.git"
# clone a branch of tag if provided
BRANCH=${1:-""}

if [ -z "${BRANCH}" ]; then
    # clone the mixins repo
    echo -e "\nCloning master branch:\n"
    git clone --single-branch "${MIXIN_REPO}" "${TMPDIR}"/mixins
else
    # clone the mixins repo branch or tag
    echo -e "\nCloning branch or tag '${BRANCH}':\n"
    git clone --branch "${BRANCH}" --single-branch "${MIXIN_REPO}" "${TMPDIR}"/mixins
fi

# get the current commit of the mixin repo
cd "${TMPDIR}"/mixins
MIXIN_VER=$(git rev-parse HEAD)
cd - > /dev/null


#CONTENT=$(cat "${TMPDIR}"/mixins/files/prometheus-rules/rules.yml| yq -P .groups)

cp "${TMPDIR}"/mixins/files/prometheus-rules/rules.yml helm/prometheus-rules/templates/recording-rules/kubernetes-mixin-test.yml

CONTENT='apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  labels:
    {{- include "labels.common" . | nindent 4 }}
  name: kube-mixins.recording.rules
  namespace: {{ .Values.namespace  }}
spec:
'

printf '%s  %s' "${CONTENT}" "$(cat helm/prometheus-rules/templates/recording-rules/kubernetes-mixin-test.yml)" >helm/prometheus-rules/templates/recording-rules/kubernetes-mixin-test.yml


# cat <<EOF
# apiVersion: monitoring.coreos.com/v1
# kind: PrometheusRule
# metadata:
#   labels:
#     {{- include "labels.common" . | nindent 4 }}
#   name: kube-mixins.recording.rules
#   namespace: {{ .Values.namespace  }}
# spec:
#   groups:
# EOF helm/prometheus-rules/templates/recording-rules/kubernetes-mixin-test.yml > helm/prometheus-rules/templates/recording-rules/kubernetes-mixin-test2.yml


# cat <<EOF >helm/prometheus-rules/templates/recording-rules/kubernetes-mixin.yml
# apiVersion: monitoring.coreos.com/v1
# kind: PrometheusRule
# metadata:
#   labels:
#     {{- include "labels.common" . | nindent 4 }}
#   name: kube-mixins.recording.rules
#   namespace: {{ .Values.namespace  }}
# spec:
#   groups:
# EOF
#  > helm/prometheus-rules/templates/recording-rules/kubernetes-mixin-test.yml

# # override current rules file
# cat <<EOF >helm/prometheus-rules/templates/recording-rules/kubernetes-mixin-test.yml
# apiVersion: monitoring.coreos.com/v1
# kind: PrometheusRule
# metadata:
#   labels:
#     {{- include "labels.common" . | nindent 4 }}
#   name: kube-mixins.recording.rules
#   namespace: {{ .Values.namespace  }}
# spec:
#   groups:
# EOF

# cat "${TMPDIR}"/mixins/files/prometheus-rules/rules.yml| yq -P --indent  .groups >>helm/prometheus-rules/templates/recording-rules/kubernetes-mixin-test.yml


# cp -a "${TMPDIR}"/files/prometheus-rules/rules.yml helm/prometheus-rules/templates/recording-rules/kubernetes-mixins.rules.yml

echo -e "\nSynced mixin repo at commit: ${MIXIN_VER}\n"

# tidy up
rm -rf "${TMPDIR}"