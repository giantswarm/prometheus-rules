# This script is used to update the Tempo alerts from mixins from the upstream repository.
#
# Usage:
#  ./tempo/update.sh from the root of the repository

set -eau o pipefail

BRANCHREF="heads/main"
MIXIN_URL="https://raw.githubusercontent.com/grafana/tempo/refs/$BRANCHREF/operations/tempo-mixin-compiled/alerts.yaml"
OUTPUT_FILE="$(pwd)/helm/prometheus-rules/templates/platform/atlas/alerting-rules/tempo-mixins.rules.yml"

# Retrieve rules and cleanup yaml formatting
curl -so- "$MIXIN_URL" \
    | yq -P -M > "$OUTPUT_FILE"

# Add alert labels
yq -i e '.groups[].rules[].labels += {"area": "platform", "team": "atlas", "topic": "observability", "cancel_if_outside_working_hours": "true", "severity": "page"}' "$OUTPUT_FILE"

# Remove the initial `groups:` line
sed -i '1d' "$OUTPUT_FILE"

# Add indentation to each line
sed -i 's/^/  /g' "$OUTPUT_FILE"

# Add the PrometheusRule metadata header
sed -i '1i\
apiVersion: monitoring.coreos.com/v1\
kind: PrometheusRule\
metadata:\
  labels:\
    {{- include "labels.common" . | nindent 4 }}\
  name: tempo-mixins.rules\
  namespace: {{ .Values.namespace  }}\
spec:\
  groups:' "$OUTPUT_FILE"

# Our cluster labels are named `cluster_id`
sed -i 's/cluster/cluster_id/g' "$OUTPUT_FILE"
# Add mandatory labels
sed -i 's/cluster_id,/cluster_id, installation, pipeline, provider,/g' "$OUTPUT_FILE"
# Only apply this alert to management clusters - this one is where there's already a selector
sed -i 's/{\([a-z].*\)}/{cluster_type="management_cluster", \1}/g' "$OUTPUT_FILE"
# Only apply this alert to management clusters - this one is where there is no selector
sed -i 's/{}/{cluster_type="management_cluster"}/g' "$OUTPUT_FILE"
# Fix single quotes in alert messages
sed -i 's/'\''/ /g' "$OUTPUT_FILE"
# Wrap alert messages in double curly braces to avoid Helm template parsing issues. Also, rename the field to `description`.
sed -i 's/\(message: \)\(.*\)/description: '\''{{`\2`}}'\''/g' "$OUTPUT_FILE"
# Remove useless namespace selector
sed -i 's/, namespace=~"\.\*"//g' "$OUTPUT_FILE"
