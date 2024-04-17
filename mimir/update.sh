#!/bin/bash

# Update Mimir mixins from upstream
#
# This script is used to update the Mimir mixins from the upstream repository.
#
# Usage:
#  ./mimir/update.sh from the root of the repository

set -e

BRANCH="main"
MIXIN_URL=https://github.com/grafana/mimir/operations/mimir-mixin@$BRANCH
OUTPUT_FILE="$(pwd)"/helm/prometheus-rules/templates/recording-rules/mimir-mixins.rules.yml

cd mimir
rm -rf vendor jsonnetfile.* "$OUTPUT_FILE"

jb init
jb install $MIXIN_URL
mixtool generate rules mixin.libsonnet -r "$OUTPUT_FILE"

# Remove the initial `groups:` line
sed -i '1d' "$OUTPUT_FILE"

# Add the PrometheusRule metadata header
sed -i '1i\
apiVersion: monitoring.coreos.com/v1\
kind: PrometheusRule\
metadata:\
  labels:\
    {{- include "labels.common" . | nindent 4 }}\
  name: mimir.recording.rules\
  namespace: {{ .Values.namespace  }}\
spec:\
  groups:' "$OUTPUT_FILE"

# Add the mimir enabled helm conditional blocks
sed -i '1i{{- if .Values.mimir.enabled }}' "$OUTPUT_FILE"
sed -i -e '$a{{- end }}' "$OUTPUT_FILE"
