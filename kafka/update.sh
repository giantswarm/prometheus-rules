#!/bin/bash
#
# Update Kafka and Strimzi alerting rules from the upstream Strimzi release.
#
# Fetches the raw PrometheusRule manifests from
# strimzi/strimzi-kafka-operator, applies the Giant Swarm atlas
# conventions, and writes the results to
# helm/prometheus-rules/templates/platform/atlas/alerting-rules/.
#
# Bump STRIMZI_REF below to track a new release. After running, review
# the diff and run `make test-rules` before committing.
#
# Usage:
#   ./kafka/update.sh                       from the root of the repository
#   STRIMZI_REF=1.0.0 ./kafka/update.sh

set -euo pipefail

STRIMZI_REF="${STRIMZI_REF:-1.0.0}"
UPSTREAM_BASE="https://raw.githubusercontent.com/strimzi/strimzi-kafka-operator/${STRIMZI_REF}/examples/metrics/prometheus-install/prometheus-rules"

GIT_ROOT="$(git rev-parse --show-toplevel)"
OUTPUT_DIR="${GIT_ROOT}/helm/prometheus-rules/templates/platform/atlas/alerting-rules"
YQ="${GIT_ROOT}/test/hack/bin/yq"

if [[ ! -x "${YQ}" ]]; then
    echo "yq not found at ${YQ}. Run 'make install-tools' first." >&2
    exit 1
fi

# Upstream filename -> atlas basename (no .rules.yml suffix)
declare -A FILE_MAP=(
    [prometheus-kafka-rules.yaml]=kafka
    [prometheus-kafka-bridge-rules.yaml]=kafka-bridge
    [prometheus-kafka-certificate-rules.yaml]=kafka-certificate
    [prometheus-kafka-connect-rules.yaml]=kafka-connect
    [prometheus-kafka-exporter-topic-rules-group.yaml]=kafka-exporter
    [prometheus-mirrormaker2-rules.yaml]=kafka-mirrormaker2
    [prometheus-strimzi-cluster-operator-rules.yaml]=strimzi-cluster-operator
    [prometheus-strimzi-entity-operator-rules.yaml]=strimzi-entity-operator
)

transform() {
    local upstream="$1"
    local basename="$2"
    local output_file="${OUTPUT_DIR}/${basename}.rules.yml"

    echo "### Update ${basename}.rules.yml"

    # kafka-exporter source metrics carry a topic= label that collides
    # with the atlas topic taxonomy. Drop the atlas topic on those alerts.
    local atlas_labels='{"area":"platform","severity":"none","team":"atlas","topic":"kafka"}'
    if [[ "${basename}" == "kafka-exporter" ]]; then
        atlas_labels='{"area":"platform","severity":"none","team":"atlas"}'
    fi

    # 1. Pre-escape annotation values containing {{ ... }} so Helm passes
    #    them through verbatim: 'X {{ $value }} Y' -> '{{`X {{ $value }} Y`}}'.
    # 2. Apply structural rewrites with yq: metadata labels/name/namespace,
    #    spec.groups[].name, and atlas labels on every rule.
    # 3. Restore the Helm directives that yq cannot emit verbatim.
    curl -fsSL "${UPSTREAM_BASE}/${upstream}" \
        | sed -E "s@^(        (description|summary)): ['\"](.*\\{\\{.*)['\"]\$@\\1: '{{\`\\3\`}}'@" \
        | "${YQ}" eval "
            .metadata.labels = {\"__LABELS_COMMON__\": \"\"}
            | .metadata.name = \"${basename}.rules\"
            | .metadata.namespace = \"__NAMESPACE__\"
            | .spec.groups[].name = \"${basename}\"
            | .spec.groups[].rules[].labels = ${atlas_labels}
        " - > "${output_file}"

    sed -i \
        -e 's@^    __LABELS_COMMON__: ""$@    {{- include "labels.common" . | nindent 4 }}@' \
        -e 's@^  namespace: __NAMESPACE__$@  namespace: {{ .Values.namespace  }}@' \
        "${output_file}"
}

for upstream in "${!FILE_MAP[@]}"; do
    transform "${upstream}" "${FILE_MAP[${upstream}]}"
done

# Rename upstream alert names to the Giant Swarm naming convention.
rename_alert() {
    local file="$1" old="$2" new="$3"
    sed -i "s|^        - alert: ${old}\$|        - alert: ${new}|" \
        "${OUTPUT_DIR}/${file}.rules.yml"
}

# kafka.rules.yml
rename_alert kafka                    UnderReplicatedPartitions    KafkaUnderReplicatedPartitions
rename_alert kafka                    AbnormalControllerState      KafkaAbnormalControllerState
rename_alert kafka                    OfflinePartitions            KafkaOfflinePartitions
rename_alert kafka                    UnderMinIsrPartitionCount    KafkaUnderMinIsrPartitionCount
rename_alert kafka                    OfflineLogDirectoryCount     KafkaOfflineLogDirectoryCount
rename_alert kafka                    ScrapeProblem                KafkaScrapeProblem
# kafka-bridge.rules.yml
rename_alert kafka-bridge             BridgeContainersDown         KafkaBridgeContainersDown
rename_alert kafka-bridge             AvgProducerLatency           KafkaBridgeAvgProducerLatency
rename_alert kafka-bridge             AvgConsumerFetchLatency      KafkaBridgeAvgConsumerFetchLatency
rename_alert kafka-bridge             AvgConsumerCommitLatency     KafkaBridgeAvgConsumerCommitLatency
rename_alert kafka-bridge             Http4xxErrorRate             KafkaBridgeHttp4xxErrorRate
rename_alert kafka-bridge             Http5xxErrorRate             KafkaBridgeHttp5xxErrorRate
# kafka-certificate.rules.yml
rename_alert kafka-certificate        CertificateExpiration        KafkaCertificateExpiration
# kafka-connect.rules.yml
rename_alert kafka-connect            ConnectContainersDown        KafkaConnectContainersDown
rename_alert kafka-connect            ConnectFailedConnector       KafkaConnectFailedConnector
rename_alert kafka-connect            ConnectFailedTask            KafkaConnectFailedTask
# kafka-exporter.rules.yml
rename_alert kafka-exporter           UnderReplicatedPartition     KafkaExporterUnderReplicatedPartition
rename_alert kafka-exporter           TooLargeConsumerGroupLag     KafkaExporterTooLargeConsumerGroupLag
rename_alert kafka-exporter           NoMessageForTooLong          KafkaExporterNoMessageForTooLong
# kafka-mirrormaker2.rules.yml
rename_alert kafka-mirrormaker2       MirrorMaker2ContainerDown    KafkaMirrorMaker2ContainerDown
# strimzi-cluster-operator.rules.yml
rename_alert strimzi-cluster-operator ClusterOperatorContainerDown StrimziClusterOperatorContainerDown
# strimzi-entity-operator.rules.yml
rename_alert strimzi-entity-operator  TopicOperatorContainerDown   StrimziTopicOperatorContainerDown
rename_alert strimzi-entity-operator  UserOperatorContainerDown    StrimziUserOperatorContainerDown

echo
echo "Done. Review with:  git diff -- ${OUTPUT_DIR#${GIT_ROOT}/}"
echo "Validate with:      make test-rules"
