# Kafka / Strimzi monitoring setup

How the Kafka alerting rules in this repo get their metrics, and the
cluster-side configuration that has to exist for them to fire.

The PrometheusRules live here; the metric *production* (Strimzi resource
`metricsConfig`, PodMonitors) lives on the cluster / in the deployment repo.
This file records what was configured on `graveler-theo` so the
`kafka-connect`, `kafka-mirrormaker2` and `kafka-bridge` rules have live data.

## Background

The broker (`Kafka my-cluster`) already exported metrics via the Strimzi
Metrics Reporter (`metricsConfig.type: strimziMetricsReporter`). The
Bridge / Connect / MirrorMaker2 resources had **no `metricsConfig`**, so the
metrics those three rule files reference produced 0 series — the alerts could
never fire.

## What was configured on the cluster

### 1. Enable the Strimzi Metrics Reporter on the three components

`metricsConfig.type: strimziMetricsReporter` was added to each CR (matching the
broker). These CRs are **applied manually** (not Flux/Helm-managed), so the
change persists.

```sh
kubectl patch kafkabridge/my-bridge       -n kafka --type merge \
  -p '{"spec":{"metricsConfig":{"type":"strimziMetricsReporter"}}}'
kubectl patch kafkaconnect/my-connect     -n kafka --type merge \
  -p '{"spec":{"metricsConfig":{"type":"strimziMetricsReporter"}}}'
kubectl patch kafkamirrormaker2/my-mm2    -n kafka --type merge \
  -p '{"spec":{"metricsConfig":{"type":"strimziMetricsReporter"}}}'
```

Enabling `metricsConfig` makes the operator add the `tcp-prometheus` (9404)
container port to Connect/MM2 pods and a `/metrics` endpoint to the Bridge.

### 2. Extend the Bridge allowlist (consumer fetch/commit latency)

The Bridge's default reporter allowlist only covers
`kafka_consumer_consumer_metrics.*` and `kafka_producer_producer_metrics.*`.
The consumer **fetch** and **commit** latency metrics live under different
prefixes, so the allowlist was widened (note: `allowList` **replaces** the
default, so every wanted family must be listed):

```yaml
spec:
  metricsConfig:
    type: strimziMetricsReporter
    values:
      allowList:
        - "kafka_producer_producer_metrics.*"              # producer request latency
        - "kafka_consumer_consumer_fetch_manager_metrics.*" # consumer fetch latency
        - "kafka_consumer_consumer_coordinator_metrics.*"   # consumer commit latency
        - "kafka_consumer_consumer_metrics.*"
```

### 3. Fix the Bridge PodMonitor scrape port  ⚠️ NOT durable

The Bridge serves `/metrics` on its **management** port `rest-api-mgmt` (8081),
but the `strimzi-kafka-operator-kafka-bridge` PodMonitor scraped `rest-api`
(8080), which returns `503` → 0 samples. It was patched to scrape 8081:

```sh
kubectl patch podmonitor strimzi-kafka-operator-kafka-bridge -n kafka --type json \
  -p '[{"op":"replace","path":"/spec/podMetricsEndpoints/0/port","value":"rest-api-mgmt"}]'
```

This PodMonitor is **Helm/Flux-managed** (`helm.toolkit.fluxcd.io/name:
theo-strimzi-kafka-operator`, chart `strimzi-kafka-operator-0.1.1`). The live
patch will be **reverted on the next Flux reconcile**. The durable fix must set
the bridge PodMonitor port to `rest-api-mgmt` in that Helm chart / HelmRelease
(`theo-strimzi-kafka-operator` in namespace `org-theo`).

## Scrape topology

| Component | PodMonitor | Port | Notes |
|---|---|---|---|
| Kafka brokers | `strimzi-kafka-operator-kafka-resources` | `tcp-prometheus` 9404 | selector `strimzi.io/kind in (Kafka,KafkaConnect,KafkaMirrorMaker2)` |
| Connect | same as above | `tcp-prometheus` 9404 | covered automatically once `metricsConfig` is set |
| MirrorMaker2 | same as above | `tcp-prometheus` 9404 | covered automatically once `metricsConfig` is set |
| Bridge | `strimzi-kafka-operator-kafka-bridge` | `rest-api-mgmt` 8081 | see ⚠️ above |

## Metric name mapping (rule expressions)

The Strimzi Metrics Reporter exposes raw Kafka client/connect metric names,
which differ from the upstream Strimzi JMX-exporter names the rules originally
carried. The rules in this repo were rewritten to the reporter names:

| Rule file | Old name (JMX exporter, never present) | New name (strimziMetricsReporter, live) |
|---|---|---|
| kafka-connect | `kafka_connect_connector_status{status="failed"}` | `kafka_connect_connector_metrics_status_info{status="failed"}` |
| kafka-connect | `kafka_connect_worker_connector_failed_task_count` | `kafka_connect_connect_worker_metrics_connector_failed_task_count` |
| kafka-mirrormaker2 | same two as above, filtered by `pod=~".+-mirrormaker2-.+"` | same two new names, same filter |
| kafka-bridge | `strimzi_bridge_kafka_producer_request_latency_avg` | `kafka_producer_producer_metrics_request_latency_avg{container=~".+-bridge"}` |
| kafka-bridge | `strimzi_bridge_kafka_consumer_fetch_latency_avg` | `kafka_consumer_consumer_fetch_manager_metrics_fetch_latency_avg{container=~".+-bridge"}` |
| kafka-bridge | `strimzi_bridge_kafka_consumer_commit_latency_avg` | `kafka_consumer_consumer_coordinator_metrics_commit_latency_avg{container=~".+-bridge"}` |
| kafka-bridge | `strimzi_bridge_http_server_requests_total` | **unchanged** — already correct; only needed the PodMonitor port fix |

Notes:
- The Kafka client latency metrics (`kafka_producer_*` / `kafka_consumer_*`)
  are emitted by **all** components that run Kafka clients (Bridge, Connect,
  MM2). The Bridge latency rules are scoped with `container=~".+-bridge"` so
  they don't fire on Connect/MM2 client latency. The client label is
  `client_id` (the old rules used `clientId`).
- The Connect failed-connector/task metrics are shared by MM2 (MM2 runs on the
  Connect runtime). `kafka-connect` rules are intentionally left unscoped to
  match upstream behaviour, so an MM2 connector failure also trips the
  `KafkaConnect*` alerts (all `severity: none`).
- Bridge Kafka-client metrics only exist while a producer/consumer client is
  active; `*_latency_avg` reads `NaN` when idle (no samples in the window) and
  the `> threshold` comparison stays false — correct behaviour.

## ⚠️ Upstream sync caveat

`kafka/update.sh` regenerates these rule files from upstream Strimzi, which
uses the **JMX-exporter** metric names. Re-running it will overwrite the
`strimziMetricsReporter` names above. Either re-apply these renames after a
sync, or add the mapping as `sed` substitutions in `update.sh`.
