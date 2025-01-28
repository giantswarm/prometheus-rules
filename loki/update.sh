#!/bin/bash

# Update Loki mixins from upstream
#
# This script is used to update the Loki mixins from the upstream repository.
#
# Usage:
#  ./loki/update.sh from the root of the repository

set -e

BRANCH="main"
MIXIN_URL=https://github.com/grafana/loki/production/loki-mixin@$BRANCH
OUTPUT_FILE="$(pwd)"/helm/prometheus-rules/templates/platform/atlas/recording-rules/loki-mixins.rules.yml

cd loki
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
  name: loki.recording.rules\
  namespace: {{ .Values.namespace  }}\
spec:\
  groups:' "$OUTPUT_FILE"

sed -i 's/cluster_id,/cluster_id, installation, pipeline, provider,/g' "$OUTPUT_FILE"
