# This script is used to update the Tempo alerts from mixins from the upstream repository.
#
# Usage:
#  ./tempo/update.sh from the root of the repository

set -eau o pipefail

BRANCHREF="heads/main"
MIXIN_URL="https://raw.githubusercontent.com/grafana/tempo/refs/$BRANCHREF/operations/tempo-mixin-compiled/alerts.yaml"
OUTPUT_FILE="$(pwd)/helm/prometheus-rules/templates/platform/atlas/alerting-rules/tempo-mixins.rules.yml"

print_header() {
echo '---
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  labels:
    {{- include "labels.common" . | nindent 4 }}
  name: tempo-mixins.rules
  namespace: {{ .Values.namespace  }}
spec:
  groups:
    - name: tempo_alerts
      rules:'
}

apply_global_sed_fixes() {
    local rule="$*"
    echo "$rule" | jq -r |
      sed 's/cluster/cluster_id/g' | # Rename cluster to cluster_id
      sed 's/cluster_id,/cluster_id, installation, pipeline, provider,/g' | # Add mandatory labels
      sed 's/{\([a-z]\)/{cluster_type=\\\"management_cluster\\\", \1/g' | # Only apply this alert to management clusters - this one is where there's already a selector
      sed 's/{}/{cluster_type=\\\"management_cluster\\\"}/g' | # Only apply this alert to management clusters - this one is where there is no selector
      sed 's/'\''/ /g' | # Fix single quotes in alert messages
      sed 's/\(message": "\)\(.*\)"/description": "{{`\2`}}"/g' | # Wrap alert messages in double curly braces to avoid Helm template parsing issues. Also, rename the field to `description`.
      sed 's/, namespace=~\\"\.\*\\"//g' #| # Remove useless namespace selector
      #jq -c
}

update_rules() {
    local tempoRules="$*"

    # Go through each rule for fixes
    readarray tempoRules < <(echo "$rawUpstreamRules" | jq -c '.groups[].rules[]')

    echo "["
    remainingRules=${#tempoRules[@]}
    for rule in "${tempoRules[@]}"; do

        alert_name=$(echo "$rule" | jq -r -c '.alert')

        ## Global fixes
        rule=$(apply_global_sed_fixes "$rule")

        # Add alert labels
        rule="$(echo "$rule" | jq '.labels += {"area": "platform", "team": "atlas", "topic": "observability", "cancel_if_outside_working_hours": "true", "severity": "page"}')"

        ## Manage rule-specific fixes
        case "$alert_name" in
            "TempoBlockListRisingQuickly")
                # label are required and should be preserved when aggregating
                rule="$(echo "$rule" \
                    | sed 's/avg(\(.*\)}) \//avg(\1}) by (cluster_id, installation, pipeline, provider, namespace) \//' \
                    )"
                ;;
            "TempoMetricsGeneratorPartitionLagCritical")
                # Template is using `group` label but the query removes it.
                rule="$(echo "$rule" \
                    | sed 's/max by (/max by (group, /'
                )"
                ;;
            "TempoBlockBuilderPartitionLagWarning")
                # Template is using `pod` label but the query removes it.
                rule="$(echo "$rule" \
                    | sed 's/max by (/max by (pod, /'
                )"
                ;;
            "TempoBlockBuilderPartitionLagCritical")
                # Template is using `pod` label but the query removes it.
                rule="$(echo "$rule" \
                    | sed 's/max by (/max by (pod, /'
                )"
                # Unnecessary regexp match on static string
                rule="$(echo "$rule" \
                    | sed 's/container=~/container=/' \
                )"
                ;;
            *)
                ;;
        esac

        ## Output the rule
        echo "$rule" | jq -c -j

        # Add comma if not the last rule
        remainingRules=$((remainingRules - 1))
        if [[ "$remainingRules" -gt 0 ]]; then
            echo ','
        fi
    done
    echo "]"
}

# Retrieve rules and store them as json string in a variable
rawUpstreamRules="$(
    curl -so- "$MIXIN_URL" \
    | yq -o=j -I=0
)"


# Start with the PrometheusRule metadata header
print_header > "$OUTPUT_FILE"

update_rules tempoRules \
    | yq -P \
    | sed 's/^/        /g' \
    >> "$OUTPUT_FILE"
