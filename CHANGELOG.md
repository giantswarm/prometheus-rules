All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Update app failure alerts to point to new runbook with variables (`ManagementClusterAppFailed`, `WorkloadClusterAppFailed`, `WorkloadClusterAppNotInstalled`)
- Update `AppWithoutTeamAnnotation` alert runbook URL to point to migrated runbook
- Update `ManagementClusterAppPendingUpdate`, `WorkloadClusterAppPendingUpdate`, and `ClusterUpgradeStuck` alert runbook URLs to point to migrated runbook with templated variables
- Adjust `PodsUnschedulable` alert trigger time: Pods have to be more than 10 minutes Pending for the alert to trigger

### Added

- Add `TeleportKubeAgentInstancesNotReady` and `TeleportKubeAgentZeroReadyReplicas` alerts.

### Changed

- Update `ChartOrphanConfigMap` alert runbook URL to point to new runbook location with templated installation and cluster variables.

## [4.77.2] - 2025-10-09

### Changed

- Update Zot runbook URL
- Remove non-existing runbook_url from HelmHistorySecretCountTooHigh alert
- Update tempo alerts

## [4.77.1] - 2025-10-07

### Changed

- Alert `MimirToGrafanaCloudExporterTooManyRestarts` is less sensitive
- Alert `PodsUnschedulable` gets a dashsboard link

## [4.77.0] - 2025-10-02

### Added

- Add the observability signal for the setup activity which is the actual number of unique logins for observability platform users in the last month: `aggregation:giantswarm:observability:signals:user_logins`. This will be added to the observability platform signals dashboard in grafana cloud.

## [4.76.0] - 2025-10-02

### Added

- Tempo alerts
- Karpenter unregistered nodes

## [4.75.0] - 2025-10-01

### Added

- New alert `ControlPlaneNodeMemoryPressureTaint`.
- New alert `IRSAClaimNotReady` to monitor Crossplane IRSA objects.
- Add quicker alerts for Kyverno's `svc-fail` validation/mutation webhooks taking very long or timing out
- Add alerts for EFS pods

### Fixed

- Fixed runbook for alertmanager alerts

### Changed

- Update some runbook URLs to point to the actual URL instead of to a redirect
- Remove aliases from runbook URL validation
- Runbook URL validation refactored
- Change runbook URL for AppExporterDown alert
- Change runbook URL for OpeartorKit alerts

## [4.74.1] - 2025-09-03

### Changed

- Update `falco` recording rule to make it work with new Falco version.

## [4.74.0] - 2025-09-02

### Added

- New alert `MimirDistributorReachingInflightPushRequestLimit` to monitor when Mimir distributors are approaching their inflight push request limit (80% threshold).

## [4.73.2] - 2025-08-29

### Fixed

- Fix `ClusterControlPlaneMachineStatusNotHealthy`: take workload cluster name from `cluster_name` label because `cluster_id` may be globally overridden in metrics

### Changed

- Change labels provided for `aggregation:docker:containers_from_deprecated_registries:*` recording rules, adding `namespace`, `pod` and `image` labels, removing `region` label.

## [4.73.1] - 2025-08-27

### Fixed

- Fix `GrafanaPostgresqlRecoveryTestFailed` which relies on a metric that does not exist.

### Added

- Recording rule sending job scraping failures to Grafana Cloud

## [4.73.0] - 2025-08-25

### Added

- Add Grafana cloud aggregations for use of deprecated registries (`aggregation:docker:containers_from_deprecated_registries:*`)

## [4.72.7] - 2025-08-12

### Changed

- Make `KubeStateMetricsDown` page only during business hours

## [4.72.6] - 2025-08-07

### Changed

- Update CAPA `InhibitionClusterWithoutWorkerNodes` to only apply to CAPA clusters.

## [4.72.5] - 2025-07-31

### Fixed

- Fix provider label in cluster recording rules for hybrid installations.

## [4.72.4] - 2025-07-31

### Changed

- Change `ClusterControlPlaneMachineStatusNotHealthy` to page

## [4.72.3] - 2025-07-29

### Added

- Add `ClusterControlPlaneMachineStatusNotHealthy` alert (very broad, using `severity: notify` for testing how often it happens)

## [4.72.2] - 2025-07-28

### Fixed

- Fix observability-platform overview regex patterns.

## [4.72.1] - 2025-07-28

### Fixed

- Fix observability-platform overview recording rules.

## [4.72.0] - 2025-07-23

### Added

- Added `CiliumOperatorRestartingTooOften` alert

## [4.71.1] - 2025-07-22

### Fixed

- Rewrite Flux alerting rules towards the `gotk_resource_info` emitted by the Kube State Metrics.

## [4.71.0] - 2025-07-21

### Added

- Add new observability recording rules for Grafana Cloud to be able to check the actual resource usage of the observability platform.

## [4.70.0] - 2025-07-03

### Added

- Added `PodsUnschedulable` alert

### Changed

- LokiObjectStorageLowRate: don't page when WCs are being created

## [4.69.0] - 2025-07-03

### Added

- add `GrafanaPostgresqlRecoveryTestFailed` alerting rule.

### Changed

- `PrometheusOperatorRejectedResources`: only page for MC resources

### Removed

- DuplicatePrometheusOperatorKubeletService was for clusters before v20, which we don't have anymore.

## [4.68.0] - 2025-07-02

### Changed

- Update CoreDNS alerts to page only for resources in "kube-system" namespace.
- Route `FluxKustomizationFailed` for `silences` kustomization to Atlas.

## [4.67.0] - 2025-06-27

### Changed

- `FluentbitDropRatio` only pages for management cluster instances (giantswarm-managed).

### Removed

- Removed `FluentbitTooManyErrors` alerts, at this is already covered by `FluentbitDropRatio` alerts and they mostly page together.

## [4.66.0] - 2025-06-24

### Added

- Added `cancel_if_metrics_broken` inhibition to following alerts:
  - `ManagementClusterDeploymentMissingCAPA`
  - `ManagementClusterDeploymentMissingCAPI`
  - `ETCDBackupMetricsMissing`
  - `PrometheusMissingGrafanaCloud`
  - `MimirToGrafanaCloudExporterDown`
  - `ManagementClusterDexAppMissing`
- Add CiliumAgentPodPending alert for Cabbage.

### Changed

- `LogForwardingErrors` description improvement

## [4.65.1] - 2025-06-16

### Changed

- Increase `MimirIngesterNeedsToBeScaledUp` alert's time to trigger from 6h to 12h to avoid noise coming from temporary spikes.
- WorkloadClusterWebhookDurationExceedsTimeoutSolutionEngineers alert: make it page only during business hours, and increase delay to 1h before it pages
- MetricForwardingErrors alert: make it less sensitive

## [4.65.0] - 2025-06-10

### Changed

- Improved `ClusterAutoscalerFailedScaling` alert expression to reduce false positives by detecting ongoing scaling failures rather than cumulative historical failures.

## [4.64.0] - 2025-06-05

### Changed

- Removed `grafana` from `DeploymentNotSatisfiedAtlas` because it's already monitored via `GrafanaDown` alert.
- Rework Rocket's `ManagementClusterContainerIsRestartingTooFrequently` to use pod names as the selector.
- Update alert for Cilium HelmRelease to match timeout.

## [4.63.0] - 2025-06-02

### Added

- Add `IncorrectResourceUsageData` alert.

### Changed

- Made `MimirIngesterNeedsToBeScaledUp` alert less sensitive to CPU usage.
- Increase `MimirIngesterNeedsToBeScaledUp` alert's time to trigger from 1h to 6h to avoid noise coming from temporary spikes like from `stable-testing` installations (https://github.com/giantswarm/giantswarm/issues/33513)
- Rewrite Flux alerting rules towards the `gotk_resource_info` emitted by the Kube State Metrics.
- Drop customer-related alerting rules of Flux.
- Rules unit tests: support for `$provider` template so we can move provider-specific tests to global tests.
- Rules unit tests: simplify files organization by removing the `capi` folder. Also fixes a bug in cloud-director tests.
- Rules linting: run against all configured providers.
- Exclude more containers from Rocket's `ManagementClusterContainerIsRestartingTooFrequently` alert.
## [4.62.0] - 2025-05-15

### Added

- Add `AppAdmissionControllerWebhookDurationExceedsTimeout` alert, business hours only.

### Removed

- Remove `app-admission-controller` from generic `ManagementClusterWebhookDurationExceedsTimeout` alert.

### Changed

- Remove duplicate test files for Atlas since all tests are the same accross all CAPI providers.
- Remove duplicate test files for Honeybadger since all tests are the same accross all CAPI providers.
- Remove duplicate test files for Shield since all tests are the same accross all CAPI providers.
- Remove duplicate test files for Tenet since all tests are the same accross all CAPI providers.

## [4.61.0] - 2025-05-14

### Changed

- Add `grafana-postgresql` in the `ObservabilityStorageSpaceTooLow` alert's monitored PVCs.

### Added

- Add `GrafanaPostgresqlReplicationFailure` and `GrafanaPostgresqlArchivingFailure` alerting rules in `grafana.rules.yml`.
- Vintage cleanup:
  - Removed code behind obvious vintage/capi conditions in Cabbage rules.
  - Removed code behind obvious vintage/capi conditions in Honeybadger rules.
  - Removed code behind obvious vintage/capi conditions in Tenet rules.
  - Removed code behind obvious vintage/capi conditions in Shield rules.
  - Remove the "aws" provider.
  - Clean up mimir-heartbeat type that was needed when we have both old and new heartbeats.
- Add `CAPATooManyReconciliations` to page when CAPA controllers are stuck reconciling over and over.

## [4.60.0] - 2025-05-13

### Added

- Add `OnPremCloudProviderAPIIsDown` alert to all clusters

### Changed

- Vintage cleanup:
  - Stopped running tests for vintage. Meaning some vintage-specific labels had to be removed.
  - Removed code behind obvious vintage/capi conditions in Atlas rules.
  - Removed code behind obvious vintage/capi conditions in Phoenix rules.

## [4.59.2] - 2025-05-09

### Changed

- Improved `AlloyUnhealthyComponents` alert by adding pod name

## [4.59.1] - 2025-05-09

### Changed

- `LogForwardingErrors`: don't page out of business hours

## [4.59.0] - 2025-05-08

### Added

- Add new alert `KonfigureOperatorDeploymentNotSatisfied`: when `konfigure-operator` deployment in `giantswarm` namespace is not ready for 30 mins.
- Add new alert `KonfigurationReconciliationFailed`: when a `ManagementClusterConfiguration` CR in not `Ready` condition for 10 mins.

## [4.58.0] - 2025-05-07

### Changed

- DeploymentNotSatisfiedAtlas: lower sensitivity and page only during business hours

### Added

- Add new alert `ClusterUpgradeStuck` to detect if the cluster app cannot be upgraded.
- Addd `konfigure-operator` related alerts and tests.

## [4.57.0] - 2025-04-30

### Changed

- PromtailRequestsErrors does not fire anymore when alloy-logs is running

### Added

- Added PromtailConflictsWithAlloy alert

## [4.56.1] - 2025-04-28

### Changed

- Reenabled storage alerts LogVolumeSpaceTooLow and RootVolumeSpaceTooLow as paging during working hours until we have node problem detector deployed.

### Fixed

- Fix SLOs recording rules sent to Grafana Cloud that sometimes trigger PrometheusRulesFailure due to the origin metric pod changing.

## [4.56.0] - 2025-04-24

### Changed

- Improved `ClusterAutoscalerFailedScaling` alert to detect stuck states where cluster-autoscaler fails to scale.

## [4.55.0] - 2025-04-22

### Changed

- Improve ClusterCrossplaneResourcesNotReady with new metrics where available
- Improve alert for Karpenter machines not being Ready

### Removed

- Remove alerts related to `alloy-rules`.

### Fixed

- Use `exported_namespace` for certificate expiration alerts.

## [4.54.1] - 2025-04-08

### Fixed

- Fix `MonitoringAgentDown` to not page for non deleting clusters.

## [4.54.0] - 2025-04-07

### Changed

- Label all our alerts with the giantswarm tenant.
- Get rid of the alloy rules app as it will now be managed by the observability operator.

## [4.53.0] - 2025-04-02

### Added

- Add new alert to detect missing installation logs that relates to teleport access.
- Fine tune the `MetricForwardingErrors` so it does not trigger on sporadic issues like duplicate samples (e.g. when a pod restarts too frequently for a small time window). This alert is now based on the upstream alert and uses a percentage of failed remote storage samples as described in this issue https://github.com/giantswarm/giantswarm/issues/32873

## [4.52.0] - 2025-03-26

### Changed

- Reduce management cluster resource usage alert window from 2d to 30m.

### Fixed

- Make sure HelmReleaseFailed for onprem clusters pages our onprem team.

## [4.51.0] - 2025-03-25

### Changed

- Increased the threshold time for `ManagementClusterWebhookDurationExceedsTimeout` from 15m to 25m
- Set `WorkloadClusterNodeUnexpectedTaintNodeCAPIUninitialized` to page
- Cancel `WorkloadClusterEtcdNumberOfLeaderChangesTooHigh` during cluster upgrades, creation and deletion
- Tweaked the time and size of the `KubeletVolumeSpaceTooLow` alerts.
- Change the `KubeletVolumeSpaceTooLow` for <500Mb available to page instead of notify
- Tweaked the time and size of the `DockerVolumeSpaceTooLow` alerts.
- Change the `DockerVolumeSpaceTooLow` for <1Gb available to page instead of notify

## [4.50.0] - 2025-03-18

### Changed

- Changed the severity of several Team Tenet alerts to be "notify"

## [4.49.3] - 2025-03-17

### Changed

- Increase threshold time for `KubeStateMetricsSlow` from 7s to 15s.

## [4.49.2] - 2025-03-14

### Changed

- Fixed some grafana-cloud recording rules to specifically use metrics giantswarm metrics
- Update `PromtailRequestsErrors` to fire after 1h instead of 25min.
- Update `PromtailRequestsErrors` to cancel outside of working hours.

## [4.49.1] - 2025-03-12

### Changed

- Update `MimirDataPushFailures` runbook url.

## [4.49.0] - 2025-03-12

### Changed

- Rename `MimirObjectStoreLowRate` to `MimirDataPushFailures` and update its expression to only target `upload` operations from the `ingester` component.

## [4.48.0] - 2025-03-11

### Added

- Add first log based alert to detect CIDRNotAvailable events.
- Add Loki rules validation in CI.

### Changed

- Update `StatefulsetNotSatisfiedAtlas` to fire after 3 days.

### Removed

- Remove `PrometheusOperatorSyncFailed` alert.
- Remove `PrometheusOperatorReconcileErrors` alert.

### Fixed

- Use the api group for the crossplane alerts to filter out resources that we don't care about.

## [4.47.0] - 2025-03-04

### Added

- Document how to create alerts based on logs.

### Changed

- Make logs and metrics tenant configurable via helm values.

## [4.46.1] - 2025-02-27

- make disk fill up alert for `zot` more sensitive

## [4.46.0] - 2025-02-26

### Added

- Add `LokiLogTenantIdMissing` alert to detect dropped log lines due to missing tenant.

### Changed

- Make `JobHasNotBeenScheduledForTooLong` alerts business hours only.

## [4.45.0] - 2025-02-25

### Changed

- update the alert annotation to match with the grafana built-in annotations to be able to link alerts with dashboards.
  - `runbook_url` is now the full url to the runbook
  - `dashboardUid` is now split between `__dashboardUid__` and `dashboardQueryParams` and `dashboardExternalUrl`

### Removed

- clean up the loki ruler datasource as we now have a datasource per tenant

## [4.44.0] - 2025-02-20

### Changed

- clean up our alert annotations to match with best practices
- rename `check-opsrecipes.sh` to `check-runbooks.sh`
- rename make target `test-opsrecipes` to `test-runbooks`

## [4.43.0] - 2025-02-20

### Changed

- Load loki rules into the giantswarm tenant.

## [4.42.1] - 2025-02-17

### Fixed

- Fix dashboard annotation for the `MimirObjectStorageLowRate` alert.

## [4.42.0] - 2025-02-14

### Changed

- Update grafana permission cronjob related alerts to only run on vintage installations

## [4.41.0] - 2025-02-14

### Removed

- Remove `ManagementClusterAPIServerLatencyTooHigh` and `KubeletDockerOperationsLatencyTooHigh` noisy notifying alerts.

## [4.40.0] - 2025-02-13

### Changed

- Add the necessary orgIds to public and private dashboards (https://github.com/giantswarm/roadmap/issues/3826)

## [4.39.1] - 2025-02-12

### Fixed

- fix all capi alerts for hybrid provider

## [4.39.0] - 2025-02-11

### Added

- Add alert `ClusterCrossplaneResourcesNotReady` for Crossplane resources that are critical for clusters

### Fixed

- fix capi-kubeadmconfig rule for hybrid providers

## [4.38.1] - 2025-02-06

### Fixed

- Fix `NodeExporterCollectorFailed` alert being received for customer workload.

## [4.38.0] - 2025-02-04

### Changed

- Change alertmanager config url in CI and README
- Exclude `CONNECT` for API server request duration due to long-lived connections in management clusters.
- Exclude `exec_sync` from `KubeletDockerOperationsLatencyTooHigh` because they are operations which can be long-running.
- Exclude Kong validation webhook from `WorkloadClusterAPIServerAdmissionWebhookErrors`.

## [4.37.0] - 2025-01-31

### Changed

- Ignore webhook rejection for `Kyverno` webhooks.
- Exclude `CONNECT` for API server request duration due to long-lived connections.
- Increase timeout for unexpected taints on CAPI nodes.

## [4.36.0] - 2025-01-30

### Changed

- Change team label `turtles` to `tenet`.

### Fixed

- Fix the `MimirObjectStorageLowRate` alert to be based on a better aligned metric to avoid false positives when Mimir restarts (c.f. https://github.com/giantswarm/giantswarm/issues/32419).

## [4.35.0] - 2025-01-28

### Added

- Add `WorkloadClusterNodeUnexpectedTaintNodeCAPIUninitialized` alert.

### Removed

- Remove KongDatastoreNotReachable.

## [4.34.0] - 2025-01-21

### Changed

- Support hybrid providers on the app platform alerts.

## [4.33.0] - 2025-01-20

### Added

- Add Mimir Alertmanager alerts

## [4.32.0] - 2025-01-16

### Changed

- Disabled fluentbit monitoring on on-prem providers (vsphere and cloud-director)

## [4.31.0] - 2025-01-13

### Added

- Add dashboard annotation for `PromtailRequestsErrors` alert.

### Fixed

- Fix duplicate series in `PromtailDown` alert.

## [4.30.0] - 2024-12-10

### Added

- Add alerts for `karpenter` issues.

## [4.29.0] - 2024-12-09

### Changed

- Increase time to trigger `PromtailRequestsErrors` alert from 15 to 25m.

## [4.28.0] - 2024-12-02

### Added

- Add alert to monitor the `KubeadmConfig` CRs having trouble generating bootstrap data.

### Changed

- Ignore HelmReleases in e2e test organization namespaces for cabbage `FluxHelmReleaseFailed` (cilium, network-policies, coredns)

## [4.27.0] - 2024-11-27

### Added

- `KongProductionDeploymentNotSatisfied` to alert on clusters starting with `p`.
- `KongNonProdDeploymentNotSatisfied` to alert on clusters not starting with `p`.

### Removed

- Split `KongDeploymentNotSatisfied` into `KongProductionDeploymentNotSatisfied` and `KongNonProdDeploymentNotSatisfied` to be able to control alerting in- and outside business hours.

## [4.26.2] - 2024-11-27

### Added

- Add `cloud-provider-controller.rules` to monitor the cloud-provider-controller components across providers.
- Add alerts to monitor the `HelmReleases` for `cilium` and `coredns`.
- Add alert to monitor the `HelmRelease` for the `vertical-pod-autoscaler-crd` app.
- Add alert to monitor Shield pods restarts.
- Add `MimirRulerTooManyFailedQueries` alert to detect when Mimir ruler is failing to evaluate rules

### Changed

- Remove `label_replace` from `app_operator_app_info` based alerts and use the `cluster_id` from the metric on CAPI.

### Fixed

- Fix dashboard link for `MimirContinuousTestFailing` alert
- Fix tests so they fail if some helm template fails to render

## [4.26.1] - 2024-11-19

### Changed

- MimirObjectStorageLowRate and LokiObjectStorageLowRate only check management cluster apps
- MimirObjectStorageLowRate and LokiObjectStorageLowRate are less sensitive

## [4.26.0] - 2024-11-19

### Changed

- Bump alloy-rules app version to 0.7.0
  - Upgrades alloy to 1.4.2 to 1.5.0

### Added

- new MimirObjectStorageLowRate alert
- new LokiObjectStorageLowRate alert

## [4.25.0] - 2024-11-18

### Changed

- Mimir compactor alert: better failure detection

### Added

- Add new mimir continuous test alerts:
  - `MimirContinuousTestFailingOnWrites`
  - `MimirContinuousTestFailingOnReads`
  - `MimirContinuousTestMissing`
  - `MimirContinuousTestFailing`

### Removed

- Remove the `mimir.enabled` property to replace it with the MC flavor as all CAPI MCs now run Mimir.

## [4.24.1] - 2024-11-12

### Fixed

- Fix `MonitoringAgentDown` to page when both prometheus-agent and alloy-metrics jobs are missing.

## [4.24.0] - 2024-11-12

### Added

- Add a set of sensible alerts to monitor alloy.
  - `AlloySlowComponentEvaluations` and `AlloyUnhealthyComponents` to report about alloy component state.
  - `LoggingAgentDown` to be alerted when the logging agent is down.
  - `LogForwardingErrors` to be alerted when the `loki.write` component is failing.
  - `LogReceivingErrors` to be alerted when the `loki.source.api` components of the gateway is failing.
  - `MonitoringAgentDown` to be alerted when the monitoring agent is down.
  - `MonitoringAgentShardsNotSatisfied` to be alerted when the monitoring agent is missing any number of desired shards.

### Changed

- Update `DeploymentNotSatisfiedAtlas` to take into account the following components:
  - `observability-operator`
  - `alloy-rules`
  - `observability-gateway`
- Move all `grafana-cloud` related alerts to their own file.
- Move all alloy related alerts to the alloy alert file.
- Rename and move the following alerts as they are not specific to Prometheus:
  - `PrometheusCriticalJobScrapingFailure` => `CriticalJobScrapingFailure`
  - `PrometheusJobScrapingFailure` => `JobScrapingFailure`
  - `PrometheusFailsToCommunicateWithRemoteStorageAPI` => `MetricForwardingErrors`

## [4.23.0] - 2024-10-30

### Changed

- Rename all `prometheus-agent` related inhibitions to `monitoring-agent` inhibitions.
- Move `Inhibition` from a suffix to a prefix for the prometheus-agent inhibitions to match with the other inhibition alerts:
- `PrometheusAgentFailingInhibition`       => `InhibitionPrometheusAgentFailing`
- `PrometheusAgentShardsMissingInhibition` => `InhibitionPrometheusAgentShardsMissing`

### Fixed

- Fixes the statefulset.rules name as it is currently replacing the deployment.rules alerts.
- Extends AppCR-related alerts with cancelation for CAPI clusters with unavailable control plane.

## [4.22.0] - 2024-10-29

### Changed

- Change `KubeletVolumeSpaceTooLow` to only page when there are 500MB or less of space left, letting the node-problem-detector handle the rest.

## [4.21.1] - 2024-10-25

### Fixed

- Updated `aggregation:giantswarm:cluster_release_version` expression to support CAPI clusters

## [4.21.0] - 2024-10-25

### Changed

- Set the `InhibitionControlPlaneUnhealthy` to be valid for all CAPI clusters, not just MCs.

## [4.20.0] - 2024-10-22

### Added

- Added InhibitionClusterWithoutWorkerNodes for CAPA

### Changed

- Modify `KyvernoWebhookHasNoAvailableReplicas` to check specifically for Kyverno resource webhook.
- Inhibit prometheas-agent alerts when a cluster has no worker nodes (AWS vintage only for now)

## [4.19.0] - 2024-10-15

### Added

- Alert `StatefulsetNotSatisfiedAtlas`

### Changed

- Update alloy-app to 0.6.1. This includes:
    - an upgrade to upstream version 1.4.2
    - a ciliumnetworkpolicy fix for clustering.

## [4.18.0] - 2024-10-08

### Added

- Alerting rule for Loki missing logs at ingestion

## [4.17.0] - 2024-10-03

### Removed

- Remove legacy in-house slo framework.

## [4.16.1] - 2024-09-26

### Fixed

- fix `LokiFailedCompaction` to take latest successfull compaction across multiple compactor/backend pods

## [4.16.0] - 2024-09-26

### Added

- Add `LokiFailedCompaction` alert to know when Loki did not manage to run a successfull compaction in the last 2 hours.

### Changed

- Migrate BigMac alerts to Shield
- Upgrade Alloy to 0.5.2 which brings no value to this repo.

### Removed

- Remove CRsync alerting rules.

### Fixed

- Dashboard links in alertmanager and mimir rules
- Fix cert-manager down alert.
- Remove deprecated app labels for `external-dns` and `ingress-nginx` alerts.
- Remove deprecated app labels for `kube-state-metrics` alerts.
- Fix falco events alerts node label to hostname as node does not exist.
- Fix `MimirHPAReachedMaxReplicas` description to render the horizontalpodautoscaler label.

## [4.15.2] - 2024-09-17

### Fixed

- Update `MimirHPAReachedMaxReplicas` opsrecipe link
- Fix aggregation rule of the `slo:current_burn_rate:ratio` slo.

## [4.15.1] - 2024-09-16

### Removed

- Remove aggregation of slo:period_error_budget_remaining:ratio as this value can be easily computed and creates a lot of time series in Grafana Cloud

## [4.15.0] - 2024-09-16

### Added

- Add aggregations for slo metrics to export them to grafana cloud
- Add `MimirHPAReachedMaxReplicas` alert, to detect when Mimir's HPAs have reached maximum capacity.

### Changed

- Added dashboards to several mimir alerts
- Change `IRSAACMCertificateExpiringInLessThan60Days` to
  `IRSAACMCertificateExpiringInLessThan45Days`. The ACM certificate is renewed
  60 days before expiration and the alert can fire prematurely.

## [4.14.0] - 2024-09-05

### Added

- Add `MimirCompactorFailedCompaction` alert.

## [4.13.3] - 2024-09-05

### Changed

- Increase `MimirIngesterNeedsToBeScaledUp` alert's time to trigger from 30m to 1h.

## [4.13.2] - 2024-09-03

### Changed

- Updated `LokiHpaReachedMaxReplicas` alert.

## [4.13.1] - 2024-09-03

### Fixed

- Fix `PromtailRequestsErrors` alerts as promtail retries after some backoff so actual errors are hidden.

## [4.13.0] - 2024-09-03

### Changed

- alertmanager alerts: add link to dashboard
- Upgrade Alloy to 0.5.1 and enable vertical-pod-autoscaler.

### Fixed

- Fix PromtailRequestError to also account for 4xx and -1 errors (https://github.com/giantswarm/giantswarm/issues/31387).

## [4.12.0] - 2024-08-26

### Added

- Add CAPI cluster namespace to recording rule `aggregation:giantswarm:cluster_info` for use by [`resource-police`](https://github.com/giantswarm/resource-police/) to find out to whom each test cluster belongs

## [4.11.0] - 2024-08-26

### Changed

- Assign alerts on core components directly to turtles.

### Fixed

- Ignore new `watchdog` collector of node-exporter since our clusters will not have data for these devices and therefore the `node_scrape_collector_success` metric would be 0

## [4.10.0] - 2024-08-20

### Changed

- Upgrade Alloy to 0.4.1

### Fixed

- Fix Prometheus Agent Failing alert for Multi-provider MCs.

## [4.9.1] - 2024-08-06

### Changed

- Restricted range of `LokiHpaReachedMaxReplicas` and `LokiNeedsToBeScaledDown` rules to management clusters.

## [4.9.0] - 2024-08-01

### Added

- Add `LokiHpaReachedMaxReplicas` alerting rule.
- Add `LokiNeedsToBeScaledDown` alert.

## [4.8.2] - 2024-07-31

### Changed

- Update PrometheusAgentShardsMissing sensitivity.

## [4.8.1] - 2024-07-22

### Changed

- Remove Linkerd alerts.

### Fixed

- alloy-rules CNP allows loading rules to loki-backend

## [4.8.0] - 2024-07-15

### Changed

- Move alloy to monitoring namespace

## [4.7.0] - 2024-07-15

### Added

- Support for loki rules to management clusters in alloy config
- grafana datasource for MC loki ruler

### Fixed

- Make dns-operator-azure capz only.
- Fix PromtailDown alert to fire only when the node is ready.

## [4.6.3] - 2024-07-11

### Changed

- link AlloyForPrometheusRulesDown alert to mimir-rules ops-recipe

### Fixed

- Fix `CiliumNetworkPolicy` for `alloy`.

## [4.6.2] - 2024-07-09

### Changed

- Removed `aggregation:container:images` recording rule to save on Grafana Cloud cost.

### Fixed

- Make sure prometheus-operator alerts page for all clusters.

## [4.6.1] - 2024-07-09

## [4.6.0] - 2024-07-09

### Changed

- Replace grafana-agent with alloy to import PrometheusRules into Mimir.

## [4.5.1] - 2024-07-08

### Changed

- Disabled `aggregation:kyverno_policy_deployment_status_team` recording rule to save on Grafana Cloud cost.

## [4.5.0] - 2024-07-03

### Changed

- Get rid of the `app`, `role` and `node` external labels in Phoenix rules.

## [4.4.2] - 2024-07-02

### Added

- Add Atlas app-configuration alerts to check unexpected configmaps and secrets.

## [4.4.1] - 2024-07-02

### Added

- add new node inhibitions to avoid paging for daemonsets when nodes are not ready/unschedulable.

### Changed

- Updated `monitoring.resource-usage-estimation.recording.rules` to support mimir.
- fluentbit alerts now have a dashboard
- add alert on sloth restarting too often (https://github.com/giantswarm/giantswarm/issues/31133)

### Fixed

- Add missing labels to `MimirToGrafanaCloudExporterDown` alert

## [4.4.0] - 2024-06-26

### Added

- Added `zot` related alerts
  - Added `ZotPersistentVolumeFillingUp` when storage is beyond 80% used and projected to fill up in 4 hours.
  - Added `ZotDeploymentNotSatisfied` when there are not enough available replicas for the main Zot deployment on the MC.

### Changed

- Renamed alert `DeploymentNotSatisfiedCrossplane` to `CrossplaneDeploymentNotSatisfied`
- Renamed alert `DeploymentNotSatisfiedExternalSecrets` to `ExternalSecretsDeploymentNotSatisfied`
- Renamed alert `DeploymentNotSatisfiedFlux` to `FluxDeploymentNotSatisfied`
- Add extra pint validations.

## [4.3.5] - 2024-06-24

### Fixed
- Fixed MimirToGrafanaCloudExporterFailures alerts: labels cleanup

## [4.3.4] - 2024-06-21

### Fixed

- Fixed MimirToGrafanaCloudExporterFailures alerts

## [4.3.3] - 2024-06-21

### Fixed

- Fixed mimir recording rules to grafana cloud so they only run on mimir and they are safer when labels are missing.

## [4.3.2] - 2024-06-21

### Added

- Added new alerting rules to monitor the Prometheus reading data from Mimir and sending them to Grafana Cloud.
- Recording rule to send mimir memory usage and metrics amount to grafana cloud

## [4.3.1] - 2024-06-18

### Changed

- Increase time in volume filled related alerts to allow node-problem-detector to shut down nodes properly.

### Removed

- Remove old kaas daemonset slos as they are now in sloth slos.
- Remove old cilium daemonset slos as they are now in sloth slos.

### Fixed

- Fix cert-exporter alerts to render the secret namespace and not the cert-exporter namespace in the alert description.

## [4.3.0] - 2024-06-17

### Removed

- Remove old cloud-api slos as they are now in sloth slos.
- Remove old `Heartbeat` and `MatchingNumberOfPrometheusAndCluster` on mimir-equipped installations.

## [4.2.1] - 2024-06-14

### Changed

- Finish reviewing `turles` alerts for multi-provider MCs and Mimir.
  - Prefix all vintage alerts with `vintage` to facilitate maintenance.
  - Fix kubelet container runtime alerts.
  - Fix pod_name label to use pod instead.

### Fixed

- removed duplicate slo-target on AWS

## [4.2.0] - 2024-06-13

### Added

- Added a new alerting rule to `falco.rules.yml` to fire an alert for XZ-backdoor.
- Added `CiliumAPITooSlow`.
- Added `CODEOWNERS` files.
- Added `MimirIngesterNeedsToBeScaledUp` and `MimirIngesterNeedsToBeScaledDown` alerting rules to `mimir-rules.yml`.

### Changed

- Restrict `grafana-agent-rules` CiliumNetworkPolicy.
- Use `ready` replicas for Kyverno webhooks alert.
- Sort out shared alert ownership by distributing them all to teams.
- Review and fix phoenix alerts towards Mimir and multi-provider MCs.
  - Move core components alerts from phoenix to turtles (`cluster-autoscaler`, `vertical-pod-autoscaler`, `kubelet`, `etcd-kubernetes-resources-count-exporter`, `certificates`)
  - Split the phoenix job alert into 2:
    - Add the aws specific job alerts in the `vintage.aws.management-cluster.rules` file.
    - Move the rest of `job.rules` to turtles because it is provider independent
  - Prefix all vintage alerts with `vintage` to facilitate maintenance.
  - Merge `kiam` and `inhibit.kiam` into one file.
  - Support any AWS WC in the aws-load-balancer-controller alerts.
  - Create a shared IRSA alerts rule file to avoid duplication between capa and vintage aws.
- Review and fix cabbage alerts for multi-provider MCs and Mimir.
- Review and fix shield alerts for multi-provider MCs and Mimir.
- Review and fix honeybadger alerts for multi-provider MCs and Mimir.
- Review and fix bigmac alerts for multi-provider MCs and Mimir.
  - Fix `ManagementClusterDexAppMissing` use of absent for mimir.
  - Update team bigmac rules based on the label changes
- Review and fix atlas alerts for multi-provider MCs and Mimir.
  - Fix alerts using absent metrics for Mimir.
- Review and fix turtles alerts for multi-provider MCs and Mimir.
  - Fix alerts using absent metrics for Mimir.
  - Reviewed turtles alerts labels.

### Removed

- cleanup: get rid of microendpoint alerts as it never fired and probably never will
- cleanup: remove scrape timeout inhibition leftovers (documentation and labels)

### Fixed

- Fixed usage of yq, and jq in check-opsrecipes.sh
- Fetch jq with make install-tools
- Fixed and improve the check-opsrecipes.sh script to support <directory>/_index.md based ops-recipes.
- Fixed all area alert labels.
- Fixed `cert-exporter` alerts to page on all providers.
- Fixed `cilium` SLO recording rule, setting a proper threshold for the alert.

## [4.1.2] - 2024-05-31

### Changed

- Updated `ContainerdVolumeSpaceTooLow`, `KubeletVolumeSpaceTooLow` and `LogVolumeSpaceTooLow` alerts to not trigger when the node-problem-detector is already remediating the issue.

## [4.1.1] - 2024-05-30

### Changed

- Get rid of the `app`, `role` and `node` external labels in Atlas rules.

## [4.1.0] - 2024-05-30

### Added

- Add `aggregation:capi_infrastructure_crd_versions` metric to Grafana Cloud.

### Fixed

- Fix remaining pint issues.

### Removed

- Remove api-server from old SLO framework.

## [4.0.0] - 2024-05-29

### Changed

- *! Breaking change !*
  - Folder architecture for rules changed to fit with areas and teams for a better overview (https://github.com/giantswarm/giantswarm/issues/30769)

### Added

- Add new alert to detect old and new prometheus-operator kubelet services in the same cluster (https://github.com/giantswarm/giantswarm/issues/30888).

## [3.15.0] - 2024-05-27

### Removed

- Remove atlas old slo alerts in favor of sloth alerts.

### Changed

- pint tests: run automatically on CI. Also, target names have changed.

### Fixed

- Fix node load alerts for CAPI clusters.
- Remove trailing spaces in rules.
- Fix `KubeStateMetricsNotRetrievingMetrics` on mimir.
- Fix nginx ingress controller opsrecipe link.

## [3.14.2] - 2024-05-16

### Changed

- Adjust the KubeletVolumeSpaceTooLow period to 30m. This will sync it better with the node-problem-detector.

## [3.14.1] - 2024-05-15

### Fixed

- Fix resource estimation recording rules for clusters that have more than 1 prometheus.

## [3.14.0] - 2024-05-15

### Added

- Add recording rules to show prometheus scraping job memory usage.
- Add `cluster_control_plane_unhealthy` inhibition.
- Add inhibitions expressions for CAPI clusters.
- Add ops-recipe for `KeyPairStorageAlmostFull` alert
- Add missing opsrecipe for Mimir alerts.
- Add opsrecipe to `CoreDNSMaxHPAReplicasReached`
- make targets for pint linter

### Changed

- Replace `cancel_if_apiserver_down` with `cancel_if_cluster_control_plane_unhealthy`

### Removed

- Removed `apiserver_down` inhibition dummy trigger.
- Remove cilium entry from KAAS SLOs.
- Remove elasticsearch and tempo related alerts and recording rules.

### Fixed

- Fix shield alert labels for Mimir.
- Fix cabbage alert labels for Mimir.
- Fix honeybadger alert labels for Mimir.
- Fix cert-manager alert labels for Mimir.
- Fix operatorkit alert labels for Mimir.
- Fix all mixins according to `pint` recommendations.
- Fix etcd alert labels for Mimir.
- Fix apiserver alert labels for Mimir.

## [3.13.1] - 2024-04-30

### Removed

- Removed alerts for absent `crsync` deployments. They cause false alerts because the rules apply to all prometheus instances on the MC.

## [3.13.0] - 2024-04-30

### Added

- Added alerts for absent `crsync` deployments.

### Changed

- Update LokiRingUnhealthy query to avoid false positive when a new pod is starting.
- Changed DeploymentNotSatisfiedBigMac alert to work for teleport related deployments only on CAPI flavored clusters

## [3.12.2] - 2024-04-25

### Fixed

- Removed check for Teleport operators in `DeploymentNotSatisfiedBigMac` alert as it is not valid on vintage

## [3.12.1] - 2024-04-25

### Fixed

- Fix alerting rules for `crsync`.

## [3.12.0] - 2024-04-19

### Changed

- Update ops-recipe link for promtail alerts.
- Remove Linkerd form Service SLO alerts.
- Include all Linkerd Namespaces in LinkerdDeploymentNotSatisfied alert.
- Make LinkerdDeploymentNotSatisfied alert business hours only.

### Fixed

- Fix expression for teleport DeploymentNotSatisfiedBigMac

## [3.11.2] - 2024-04-18

### Added

- Add ops recipe for flux being suspended for too long alert.

## [3.11.1] - 2024-04-17

### Added

- Add CAPI and CAPA dashbaord to the coresponding alerts.

### Fixed

- link to `PrometheusMissingGrafanaCloud` opsrecipe

## [3.11.0] - 2024-04-15

### Added

- Add CiliumNetworkPolicyFailed alert.

## [3.10.1] - 2024-04-12

### Fixed

- Fix `MatchingNumberOfPrometheusAndCluster` alert.

## [3.10.0] - 2024-04-10

### Added

- Add `IRSAACMCertificateExpiringInLessThan60Days` alert.

## [3.9.0] - 2024-04-10

### Added

- Add ops recipe for `ClusterCertificateExpirationMetricsMissing` alert.

## [3.8.1] - 2024-04-09

### Fixed

- Fix cluster_type label for vintage clusters in `aggregation:giantswarm:cluster_info` recording query.

## [3.8.0] - 2024-04-08

### Added

- Add non-blocking opsrecipe validation.

### Fixed

- Fix `WorkloadClusterMasterMemoryUsageTooHigh` opsrecipe.

## [3.7.2] - 2024-04-08

### Fixed

- Fix `PrometheusMissingGrafanaCloud` alert for non-mimir installations.
- Fix `IngressControllerDeploymentNotSatisfied` opsrecipe.

## [3.7.1] - 2024-04-08

### Fixed

- Fix `kube-state-metrics` down alert.

## [3.7.0] - 2024-04-08

### Changed

- Make Atlas rules compatible with Mimir:
  - Add labels `cluster_id, installation, provider, pipeline` for each aggregation functions
  - Rewrite some of `absent` functions

### Fixed

- Fix missing ops-recipes.

## [3.6.2] - 2024-04-04

### Changed

- Limit alerts for the split setup (dual vs single flux) to the `flux-giantswarm` controller ones.

## [3.6.1] - 2024-04-04

### Changed

- Adjust Flux alerts for single Flux scenario.

## [3.6.0] - 2024-04-02

### Added

- Add Heartbeat alert for mimir.
- Add missing alert about loki containers not running to ensure we do not suffer from [extra cloud cost](https://github.com/giantswarm/giantswarm/issues/30124).
- Add missing alert about mimir containers not running to ensure we do not suffer from [extra cloud cost](https://github.com/giantswarm/giantswarm/issues/30124).
- Add recording rule for ingresses using the baseDomain.

## [3.5.0] - 2024-03-27

### Changed

- Assign `cilium` SLO alerts to cabbage/empowerment.

## [3.4.0] - 2024-03-25

### Added

- Add rules to monitor that `grafana-agent` is sending `PrometheusRules` to `Mimir ruler`.
- Add rules to monitor that `grafana-agent` is running.

### Changed

- Changed severity for `TeleportJoinTokenSecret/ConfigmapMistamch` to `notify` and increased alert interval from 30m to 120m

## [3.3.0] - 2024-03-18

### Added

- Add label `giantswarm.io/remote-write-target: grafana-cloud` to recording rules that are to be sent to mimir so the Prometheus instance in the Mimir architecture in-charge of sending data to Grafana Cloud can only select the data it needs and not try to execute all rules in this repository.
- Add `grafana-agent` App CR to send PrometheusRules to mimir ruler.

## [3.2.0] - 2024-03-18

### Changed

- Increase `PromtailDown` "for" value.

### Fixed

- Fix missing recording rules removed when removing the azure provider.
- Fix certificate recording rules.

## [3.1.1] - 2024-03-14

### Changed

- Adjusted cert-manager `CertManagerPodHighMemoryUsage` alerting threshold (https://github.com/giantswarm/prometheus-rules/pull/1077)

### Fixed

- Fix teleport alerts for mimir.

## [3.1.0] - 2024-03-13

### Changed

- Remove `aws-network-topology-operator` from `ManagementClusterDeploymentMissingCAPA` alert.

## [3.0.3] - 2024-03-12

### Changed

- Set `PromtailDown` alert to not page out of business hours

## [3.0.2] - 2024-03-12

### Fixed

- Fix `AWSLoadBalancerControllerReconcileErrors` alert query.

## [3.0.1] - 2024-03-12

### Fixed

- Fix management-cluster.rules paging on WCs.

## [3.0.0] - 2024-03-12

### Added

- Add new mimir.enabled property to disable the MC/WC split in alerts.
- Add new alert for reconciling errors of `AWS load balancer controller`.

### Changed

- Adjust CAPI rules.
- Change ownership of `CadvisorDown` to Turtles/Phoenix.
- Review alerting prior to Mimir migration.
- Increase duration for fluentbit rules to avoid false alerts when a new release is deployed.
- Improve `AWS load balancer controller` alert for failed AWS calls query.

### Removed

= Remove `kvm` provider alerts.
- Remove `azure` provider alerts.
- Remove `tiller` alerts.
- Remove `gcp` provider alerts.
- Remove `openstack` provider alerts.

## [2.153.1] - 2024-02-28

### Fixed

- Fix `PersistentVolumeSpaceTooLow` to ignore the observability components and `DataDiskPersistentVolumeSpaceTooLow` to alert on the new observability stack components.

## [2.153.0] - 2024-02-27

### Removed

- Remove `NodeExporterDeviceError` alert.

## [2.152.1] - 2024-02-26

### Fixed

- Fix `ManagementClusterContainerIsRestartingTooFrequently` alert to only page for rocket components.

## [2.152.0] - 2024-02-14

### Added

- Add Alerts for missing or failing CAPI controller pods.
- Add Alerts for missing or failing CAPA controller pods.
- Add recording rule for more detailed cluster compliance information.

## [2.151.0] - 2024-01-31

### Added

- Check creation CAPI cluster creation time before paging `LatestETCDBackup2DaysOld`.
- Added recording rule for cluster_compliance_metrics.

### Changed

- Rename `dipstick` report count metric.
- Changed `MachinePoolReplicasMismatch` and `MachineUnhealthyPhase` to page.

## [2.150.1] - 2024-01-24

### Fixed

- Fix Labels `ManagementClusterCertificateIsMissing`.

## [2.150.0] - 2024-01-24

### Added

- Add alert for missing certificates when only secret is present.

## [2.149.0] - 2024-01-22

### Added

- Ship `dipstick` metrics to Grafana Cloud.

### Changed

- Changed teleport alerts to take into account only `Provisioned` clusters
- Made use of `workingHoursOnly` template on more alerts to ensure `stable-testing` MCs don't page out of hours
- No longer silence all CAPA and CAPZ alerts out of hours by default
- Transfer ownership of `circleci` Azure app registration expiry alert to honeybadger

## [2.148.0] - 2024-01-17

### Added

- Added specific deployment status alerts for BigMac application
- Added teleport-operator alerts for missing secrets and configmaps

### Changed

- Silence `ManagementClusterDeploymentMissingAWS` if KSM is down.

## [2.147.1] - 2024-01-11

### Changed

- Update ops recipe link for all prometheus-agent alerts.

## [2.147.0] - 2024-01-09

### Changed

- Update `AlertManagerNotificationsFailing` routing on Atlas slack for opsgenie integration.

## [2.146.0] - 2024-01-04

### Changed

- Increase the time window for `NodeConnTrackAlmostExhausted`.
- Fix expression for KongDeploymentNotSatisfied

### Removed

- Ignore `api-spec` from `AppWithoutTeamAnnotation` alert.
- Remove `WorkloadClusterManagedDeploymentNotSatisfiedPhoenix` as `cert-manager` is no longer owned by Phoenix.
- Remove `InhibitionClusterIsNotRunningPrometheusAgent` inhibition on CAPI.

## [2.145.0] - 2023-11-30

### Fixed

- Fix `WorkloadClusterContainerIsRestartingTooFrequentlyAWS` expr to use `ebs-plugin` and not `ebs-csi`

### Changed

- reduced sensitivity for lokiringunhealthy

## [2.144.0] - 2023-11-27

### Changed

- Relabel team in `ServiceLevelBurnRateTooHigh` alert.

## [2.143.2] - 2023-11-22

### Changed

- Make `aggregation:container:images` an aggregation to avoid sending too much data to Grafana Cloud.

## [2.143.1] - 2023-11-21

### Fixed

- Fix aggregation:container:images by adding the namespace to avoid issues when one application is deployed multiple times in one cluster.

## [2.143.0] - 2023-11-21

### Added

- Add new aggreration to list giantswarm images used in our clusters.

## [2.142.2] - 2023-11-20

### Fixed

- Fix counting of docker.io images by using the `image_spec` label instead of `image`:
  - `aggregation:docker:containers_using_dockerhub_image`
  - `aggregation:docker:containers_using_dockerhub_image_relative`

## [2.142.1] - 2023-11-20

### Changed

- Change these aggregations to also account for init containers:
  - `aggregation:docker:containers_using_dockerhub_image`
  - `aggregation:docker:containers_using_dockerhub_image_relative`

## [2.142.0] - 2023-11-20

### Added

- Add two aggregations to track usage of Docker Hub
  - `aggregation:docker:containers_using_dockerhub_image`: Number of containers running iwht image from docker.io.
  - `aggregation:docker:containers_using_dockerhub_image_relative`: Percentage of all running containers that use an image from docker.io (range 0.0 to 1.0).

## [2.141.0] - 2023-11-15

### Changed

- Support multiple KSM pods in our alerts.
- Split prometheus-agent alerts (`PrometheusAgentFailing` and `PrometheusAgentShardsMissing`) in 2:
  - existing alerts will fire later
  - new inhibitions alerts will fire earlier

## [2.140.2] - 2023-11-13

### Fixed

- Use `exported_namespace` for certificate expiration alerts.

## [2.140.1] - 2023-11-13

### Fixed

- Fix `raw_slo_requests` recording rule expression for kubelet status.

## [2.140.0] - 2023-11-13

### Added

- Add new alert that fires if etcd backup metrics are missing for 12h.

## [2.139.0] - 2023-11-07

### Added

- Add KEDA alerting rules.

### Changed

- Added `namespace` label to Flux helm release related alerts

## [2.138.3] - 2023-11-02

### Changed

- fixed `aggregation:kyverno_policy_job_status_team` expression.

### Added

- Recording rules for Tempo

## [2.138.2] - 2023-10-23

### Added

- Add recording rules to list all clusters.
- Fix typo in `ManagementClusterAppFailed` and `ManagementClusterAppPendingUpdate`.

## [2.138.1] - 2023-10-11

### Fixed

- Fix link for node exporter opsrecipe
- Fix AppWithoutTeamAnnotation so it only pages for Giant Swarm catalogs.

## [2.138.0] - 2023-10-05

### Fixed

- Add missing team label to slo alerts.

### Changed

- Change ownership from Atlas to Turtles/Phoenix for all vertical pod autoscaler alerts

### Removed

- Remove vertical-pod-autoscaler slo as it was moved to Sloth.

## [2.137.0] - 2023-10-04

### Removed

- Remove role label usage instead of relying on `kube_node_role`` metric.

## [2.136.0] - 2023-10-04

### Changed

- Remove PrometheusAvailabilityRatio alert.

## [2.135.0] - 2023-10-02

### Changed

- Handover cert-manager alerts to BigMac
- Ignore ETCD alerts on EKS clusters.

## [2.134.1] - 2023-09-26

### Fixed

- Improve InhibitionClusterIsNotRunningPrometheusAgent to keep paging if the kube-state-metrics metric is missing for 5 minutes (avoid flapping of inhibitions).

## [2.134.0] - 2023-09-21

### Changed

- Split `KubeStateMetricsDown` alert into 2 alerts : `KubeStateMetricsDown` and `KubeStateMetricsNotRetrievingMetrics`

## [2.133.0] - 2023-09-19

### Changed

- Add missing prometheus-agent inhibition to `KubeStateMetricsDown` alert
- Change time duration before `ManagementClusterDeploymentMissingAWS` pages because it is dependant on the `PrometheusAgentFailing` alert.

### Fixed

- Remove `cancel_if_outside_working_hours` from PrometheusAgent alerts.

## [2.132.0] - 2023-09-15

### Changed

- `PrometheusAgentFailing` and `PrometheusAgentShardsMissing`: keep alerts for 5min after it's solved

## [2.131.0] - 2023-09-12

### Changed

- Remove `DNSRequestDurationTooSlow` in favor of SLO alerting.

## [2.130.0] - 2023-09-12

### Changed

- Refactor the Kyverno policy reports recording rule to include missing apps from Team Overview dashboard.
- Change `ClusterUnhealthyPhase` severity to page, so that we get paged when a cluster is not working properly.

## [2.129.0] - 2023-09-11

### Changed

- Unit tests for `PrometheusAgentShardsMissing`
- fixes for `PrometheusAgentShardsMissing`

## [2.128.0] - 2023-09-05

### Added

- Unit tests for KubeStateMetricsDown

### Changed

- Loki alerts only during working hours
- `PrometheusAgentFailing` does not rely on KSM metrics anymore
- Prometheus-agent inhibition rework, run on the MC
- `ManagementClusterApp` alerts now check for default catalog as well

## [2.127.0] - 2023-08-21

### Changed

- WorkloadClusterApp alerts now also monitor default catalog

## [2.126.1] - 2023-08-14

### Changed

- Changed master memory limits to 80%

### Fixed

- Revert change concerning port 8081 in `KubeStateMetricsDown` alert.

## [2.126.0] - 2023-08-10

## Changed

- `ManagementClusterWebhookDurationExceedsTimeout`, `WorkloadClusterWebhookDurationExceedsTimeoutSolutionEngineers`, `WorkloadClusterWebhookDurationExceedsTimeoutHoneybadger`, `WorkloadClusterWebhookDurationExceedsTimeoutCabbage`, and `WorkloadClusterWebhookDurationExceedsTimeoutAtlas` are changed to use the 95th percentile latency of the webhook, instead of the average rate of change.

## [2.125.0] - 2023-08-09

## Changed

- `KubeStateMetricsDown` also triggers when KSM does not show enough data (less than 10 metrics)

## [2.124.0] - 2023-08-08

### Added

- Add `WorkloadClusterDeploymentScaledDownToZeroShield` for Shield deployments on WCs.

### Fixed

- Add port 8081 for the `instance` label in `KubeStateMetricsDown` alert.

### Changed

- Move CoreDNS alerts from phoenix to cabbage.

## [2.123.0] - 2023-08-03

### Changed

- Ignore `prometheus` PVCs in `PersistentVolumeSpaceTooLow` alert (they have a dedicated alert).

## [2.122.0] - 2023-08-02

### Changed

- Allow 1 error/5 minutes for `ManagementClusterAPIServerAdmissionWebhookErrors`.

### Fixed

- Add webhook name in `ManagementClusterAPIServerAdmissionWebhookErrors` alert title.

## [2.121.0] - 2023-08-02

### Changed

- Move Cert-manager alerts to Cabbage

### Fixed

- Make `ManagementClusterContainerIsRestartingTooFrequentlyAWS` alert title include the involved pod.
- Make `DeploymentNotSatisfiedKaas` alert title include the involved deployment.
- Make `WorkloadClusterNonCriticalDeploymentNotSatisfiedKaas` alert title include the involved deployment.
- Make `WorkloadClusterDeploymentNotSatisfiedKaas` alert title include the involved deployment.
- Make `WorkloadClusterContainerIsRestartingTooFrequentlyAWS` alert title include the involved pod.
- Make `WorkloadClusterManagedDeploymentNotSatisfiedPhoenix` alert title include the involved deployment.

## [2.120.0] - 2023-08-01

### Changed

- Move Kyverno certificate expiry alert from KaaS to Managed Services.
- Decrease sensitivity for alerting on KVM WC critical pods from 10m to 15m.

## [2.119.0] - 2023-07-31

### Changed

- Assign `clippy` rules to `phoenix`.

## [2.118.1] - 2023-07-31

### Fixed

- Check division by zero in `ManagementClusterWebhookDurationExceedsTimeout` alert's query.

## [2.118.0] - 2023-07-28

### Changed

- Increase alert threshold for KVM WC critical pods from 5m to 10m.

## [2.117.0] - 2023-07-27

### Changed

- Increase time window of `ManagementClusterAPIServerAdmissionWebhookErrors` from 5m to 15m.

## [2.116.0] - 2023-07-20

### Fixed

- Fix `KubeStateMetricsDown` on pre-servicemonitor clusters

### Changed

- Switch `HighNumberOfAllocatedSockets` and `HighNumberOfOrphanedSockets` from Rocket to provider teams.

## [2.115.1] - 2023-07-20

### Fixed

- Fix `KubeStateMetricsDown`

## [2.115.0] - 2023-07-20

### Added

- New alert `KubeStateMetricsSlow` that inhibits KSM related alerts.

### Fixed

- Fix `KubeStateMetricsDown` inhibition.

## [2.114.0] - 2023-07-20

### Added

- Add `DNSRequestDurationTooSlow` to catch slow DNS.

### Removed

- Remove `CoreDNSLoadUnbalanced` alert.
- Remove `CoreDNSCPUUsageTooHigh` alert.

## [2.113.0] - 2023-07-18

### Added

- Add cilium BPF map monitoring.
- Add `VpaComponentTooManyRestarts` alerting rule.

### Changed

- Make `VaultIsDown` page after 40m.

## [2.112.0] - 2023-07-13

### Fixed

- Use all nodes instead of just the Ready ones as raw_slo_requests

### Removed

- Remove kiam-agent and kiam-server from the ServiceLevelBurnRateTooHigh alert

## [2.111.0] - 2023-07-11

### Removed

- Remove `CoreDNSLatencyTooHigh` alert as it's flaky and superseeded by SLO alert.

## [2.110.0] - 2023-07-10

### Changed

- Change `ManagementClusterAPIServerAdmissionWebhookErrors` severity to page.
- CAPA alerts only during business hours.
- Fix Kyverno recording rule to ignore WorkloadCluster Apps.
- Make `CoreDNSLatencyTooHigh` alert page rather than notify.

## [2.109.0] - 2023-06-30

### Added

- Add two new alerts for ALB role errors.
- Add dashboard link to `ServiceLevelBurnRateTooHigh` alert.
- Ship Kyverno policy enforcement status to Grafana Cloud.

## [2.108.0] - 2023-06-28

### Changed

- Change `for` setting of `WorkloadClusterCriticalPodNotRunningAWS` to 20 minutes.
- Remove duplicate workload_name label in favor of existing daemonset|statefulset|deployment labels.

## [2.107.0] - 2023-06-26

### Changed

- Split Grafana Cloud recording rules into smaller groups.

### Added

- Add rule for AWS load balancer controller deployment satisfied.

## [2.106.0] - 2023-06-22

### Added

- Add alerts for legacy vault's etcd backups.

## [2.105.0] - 2023-06-22

### Fixed

- Add missing cluster-id label to the PrometheusAvailabilityRatio alert.

## [2.104.0] - 2023-06-21

### Added

- Rules: Add `ingress-nginx`. ([#791](https://github.com/giantswarm/prometheus-rules/pull/791))
- Push number of replicas for nginx-ingress-controller-app deployment to Grafana Cloud.

### Fixed

- `ClusterStatusNotRead` description is missing the cluster name

### Changed

- Ingress Controller: Rename `IngressControllerDown` recipe. ([#793](https://github.com/giantswarm/prometheus-rules/pull/793))
- Respect also `apiserver_flowcontrol_request_concurrency_limit_overwrite` metric for `FlowcontrolTooManyRequests` alerts.

## [2.103.0] - 2023-06-14

### Added

- Add Container Disk Usage too low.

## [2.102.0] - 2023-06-13

### Removed

- Remove `KiamDaemonsetNotCleanedUp`.

## [2.101.0] - 2023-06-12

### Added

- Add `KiamDaemonsetNotCleanedUp`.

## [2.100.1] - 2023-06-06

### Fixed

- Fix PrometheusAgentShardsMissing because it should not use a `count`.

## [2.100.0] - 2023-06-06

### Added

- Add new `PrometheusAgentShardsMissing` alert.
- Add non-paging alerts for `paused` CAPI CRs.

## [2.99.0] - 2023-05-25

### Added

- Add new alert on Silence operator reconciliation errors.

## [2.98.4] - 2023-05-25

### Changed

- Split `AzureServicePrincipalExpires` alert to page team bigmac in case of dex related service principals.
- Split all CAPI CR based alerts into a rule file per CR.
- Differentiate between CAPI and vintage during `promtool` based unit tests.

### Fixed

- Fix query for `WorkloadClusterControlPlaneNodeMissingAWS`.

## [2.98.3] - 2023-05-24

### Changed

- Send `dex` alerts to team bigmac.

### Fixed

- Fix Prometheus Agent alerts for sharded agents.

## [2.98.2] - 2023-05-22

### Changed

- Send `DeploymentNotSatisfiedKaas` for `nginx-ingress-controller` to cabbage.

## [2.98.1] - 2023-05-16

### Changed

- Exclude `/token` handler from `DexErrorRateHigh` alert.
- Reduce PrometheusRuleFailures interval to 5m
- Reduce CertificateWillExpireInLessThanTwoWeeks period from 14 days to 13
  days. This accounts for a [bug in cert-manager](https://github.com/cert-manager/cert-manager/issues/5851) and gives
  the certificate an extra day to renew without paging.

## [2.98.0] - 2023-05-10

### Added

- Add `WorkloadClusterMasterMemoryUsageTooHigh` alert.

### Changed

- Update Grafana Cloud push rules for Kyverno to include more pod controller types.

## [2.97.2] - 2023-05-09

### Removed

- Stop pushing to `openstack-app-collection`.

### Changed

- Update Flux work queue limit to 1h from previous 30 min.

## [2.97.1] - 2023-05-05

### Changed

- Updated `PrometheusAvailabilityRatio` to be executed only on MC prometheus.

## [2.97.0] - 2023-05-04

### Changed

- updated `PrometheusAvailabilityRatio` alert to set window to 1h rather than 10h.

## [2.96.6] - 2023-05-03

### Fixed

- Fix typo in AppFailed alerts on CAPI clusters.

## [2.96.5] - 2023-05-03

### Fixed

- Fix missing quotes on boolean.

## [2.96.4] - 2023-05-03

### Fixed

- Fix AppFailed alerts on CAPI clusters.
- Fix `WorkloadClusterHAControlPlaneDownForTooLong` alert to ensure it only pages if there are exclusively 2 `control-plane` or `master` nodes.

## [2.96.3] - 2023-05-03

### Fixed

- Fix dashboard links for prometheus-availability and prometheus-remote-write.
- Fix `WorkloadClusterHAControlPlaneDownForTooLong` alert.

## [2.96.2] - 2023-05-02

### Fixed

- Fix KubeStateMetricsDown inhibition.

## [2.96.1] - 2023-05-02

### Fixed

- Fix `WorkloadClusterControlPlaneNodeMissing` alerts for all providers (previous fix was not working)

### Changed

- Reduced delay for heartbeats from 10m to none

### Added

- added `PrometheusAvailabilityRatio` alert

## [2.96.0] - 2023-04-28

### Added

- Add an alert that pages if etcd metrics are missing.

## [2.95.2] - 2023-04-28

### Fixed

- Fix `WorkloadClusterControlPlaneNodeMissing` alerts for all providers.

## [2.95.1] - 2023-04-27

### Fixed

- Fix control-plane-node-down inhibition.

## [2.95.0] - 2023-04-27

### Changed

- Deprecate `role=master` in favor of `role=control-plane`.
- Rename alerts containing `Master` with `ControlPlane`
- Added `cancel_if_prometheus_agent_down` for phoenix alerts ManagementClusterCriticalPodMetricMissing, ManagementClusterDeploymentMissingAWS, WorkloadClusterNonCriticalDeploymentNotSatisfiedKaas

## [2.94.0] - 2023-04-26

### Added

- Alert `MimirComponentDown` for Mimir app

### Fixed

- Fix colliding resources names in recording rules

## [2.93.0] - 2023-04-24

### Fixed

- `make help` shows test targets again

### Added

- Alert `ClusterDNSZoneMissing` added for `dns-operator-azure`
- Alert `AzureDNSOperatorAPIErrorRate` added for `dns-operator-azure`
- Recording rules for Mimir
- Recording rules for Loki
- Label to trigger inhibition when prometheus-agent is down
- Test recording rules
- Unit test for recording rule `helm-operations`

### Changed

- Forward WorkloadClusterCertificateExpiring to team-teddyfriends on Slack
- README: naming convention for inhibition labels

## [2.92.0] - 2023-04-19

### Added

- Revert: Do not inhibit azure clusters without worker nodes because the source metric is missing and the inhibition is preventing real alerts to go through.

## [2.91.0] - 2023-04-18

### Changed

- Changed `GiantswarmManagedCertificateCRWillExpireInLessThanTwoWeeks` alert to work for both workload clusters and management clusters.

## [2.90.0] - 2023-04-17

### Added

- Alert `KongDeploymentNotSatisfied` for managed kong deployments.

### Removed

- Alert `WorkloadClusterManagedDeploymentNotSatisfiedCabbage`.
- Do not inhibit azure clusters without worker nodes because the source metric is missing and the inhibition is preventing real alerts to go through.

### Changed

- Decrease severity for PrometheusJobScrapingFailure alerts, so they don't show in Slack.
- set unique names for alert groups.

## [2.89.0] - 2023-04-12

### Changed

- Only page during business hours if `etcd-kubernetes-resources-count-exporter` deployment is not satisfied.

## [2.88.0] - 2023-04-11

### Added

- Alert `LinkerdDeploymentNotSatisfied` for managed Linkerd deployments.
- New `make test-opsrecipes` target
- Alert `SlothDown` for Sloth app

### Changed

- Change all `hydra` alerts to point to team `phoenix` since we merge the business hours on-call

## [2.87.0] - 2023-04-06

### Added

- Alert for `etcd-kubernetes-resources-count-exporter`.

### Fixed

- some broken opsrecipe links

### Changed

- added dashboard to `PrometheusFailsToCommunicateWithRemoteStorageAPI` alert
- updated kube mixins to 0.12
- `PrometheusCantCommunicateWithKubernetesAPI` : added `cancel_if_cluster_has_no_workers`

## [2.86.1] - 2023-03-28

### Changed

- Tuned prometheus-cant-communicate-with-remote-storage-api alert

## [2.86.0] - 2023-03-27

### Fixed

- Page when the agent cannot send data to Prometheus.

## [2.85.0] - 2023-03-24

### Added

- Ship Kyverno-related resource counts to Grafana Cloud.

## [2.84.0] - 2023-03-21

### Fixed

- Fix `PersistentVolumeSpaceTooLow` alert.

### Changed

- Silence `IRSATooManyErrors` during cluster creation and deletion.

## [2.83.0] - 2023-03-16

### Added

- Unit test for kong rules
- Add `cluster-autoscaler` among deployments paging if unsatisfied.
- Add `DeploymentNotSatisfiedShield` alert for Kyverno and remove Kyverno from Honeybadger.

### Changed

- Prevent the PrometheusAgent from paging outside of business hours.

## [2.82.4] - 2023-03-14

### Changed

- Fix `MachineUnhealthyPhase` rule to exclude bastion nodes
- Fix `MachineDeploymentReplicasMismatch` rule to exclude bastion nodes and fix description

## [2.82.3] - 2023-03-07

### Changed

- Splits `kyverno` certificate expiry alert & created `KyvernoCertificateSecretWillExpireInLessThanTwoDays`.
- Tweak ETCD DB Too Large alert

## [2.82.2] - 2023-03-03

### Fixed

- fix ClusterEtcdDBSizeTooLarge alerts.

## [2.82.1] - 2023-03-01

### Fixed

- Add `app` differentiator to the `FluxSourceFailed` alert.

## [2.82.0] - 2023-02-28

### Changed

- Make `NodeExporterDeviceError` only if relevant disk scraping fails.
- Add team labels to prometheus rules for https://github.com/giantswarm/prometheus-meta-operator/pull/1181
- Split Calico notify alerts per provider team

## [2.80.1] - 2023-02-14

### Changed

- Update dummy inhibitions' expressions

## [2.80.0] - 2023-02-13

### Added

- Add `WorkloadClusterAWSCNIIpExhausted` and `WorkloadClusterAWSCNIIpAlmostExhausted` alerts.

## [2.79.0] - 2023-02-09

### Changed

- rename github workflow based unit tests
- fix node_status metrics for cortex
- fix typo in memory request/limit recording rule
- add container memory/cpu usage for MCs to cortex

### Fixed

- fix ManagedCertificateCRWillExpireInLessThanTwoWeeks unit tests

## [2.78.0] - 2023-02-06

### Changed

- Fix cortex recording rules for requests and limits
- Upgrade inhibition labels checking script
- inhibition script now throwing error in github-action if missing labels are detected

## [2.77.0] - 2023-02-03

### Added

- Add `PrometheusMissingGrafanaCloud` alert.

## [2.76.1] - 2023-02-03

### Fixed

- Avoid `scan-vulnerabilityreport` pods to fire `WorkloadClusterCriticalPodNotRunningAWS` alerts.

## [2.76.0] - 2023-02-01

### Changed

- Turn `AzureClusterCreationFailed`'s severity from `notify` to page.
- Split `ManagedCertificateCRWillExpireInLessThanTwoWeeks` alert between giantswarm and customer secrets.

### Added

- Dummy inhibition alerting rules to make ci happy.

## [2.75.0] - 2023-01-23

### Added

- Add `AzureServicePrincipalExpirationMetricsMissing` firing on `gollum` only to catch when the service principal expiration metrics are missing.

## [2.74.0] - 2023-01-18

### Changed

- Raise `ClusterAutoscalerUnneededNodes` alert threshold to 4 hours.

### Removed

- Remove `ClusterAutoscalerUnschedulablePods` alert as it is too unreliable.

## [2.73.2] - 2023-01-18

### Changed

- Alert for `dex` only in management clusters.

## [2.73.1] - 2023-01-18

### Changed

- Update prometheus tool to `2.41.0` and Fix bash in chart-template target.

### Added

- Ship per-team Kyverno policy information to Grafana cloud.
- Add basic rule that checks for deployments of `external-secrets` on MCs during business hours.

### Removed

- Remove `CrossplaneHelmReleaseFailed` alert because `FluxHelmReleaseFailed` triggers for the same thing. As long as the releases are stored in `flux-giantswarm`, but they have to be kept there because of our multi-tenant flux setup.

### Changed

- Improve `PrometheusAgentFailing` to ignore
- NodeExporter: Disabled nvme collector checks - were too unreliable
- NodeExporter: Disabled pressure collector for kvm
- NodeExporter: page again

## [2.73.0] - 2023-01-16

### Fixed

- Fix boolean in rules.

### Added

- Initial version of `CAPZ` related alerting rules
- Add `ClusterAutoscalerUnneededNodes` and `ClusterAutoscalerUnschedulablePods`
- Add `DexSecretExpired` and `ManagementClusterDexAppMissing` alerts in working hours.

### Changed

- Removed Cilium alerts as those were for tests only
- Move `NodeExporter*` alert ownership to provider team
- Remove `ClusterAutoScalerErrors`
- rework tests to generate helm templating only once

## [2.72.0] - 2023-01-09

### Added

- Add recording rule for expiry time of identity provider oauth app secrets managed by dex operator.

## [2.71.1] - 2023-01-09

### Fixed

- Use `pod` label rather than `container` label to match for critical pods in `ManagementClusterCriticalPodNotRunning`.

## [2.71.0] - 2023-01-05

### Added

- Go and bash scripts to check for potential missing labels in alerting rules for each provider
- Add alert to check IRSA certificate expiration.

### Changed

- Custom makefile which executes the go script to check inhibition labels
- prometheus-agent rule: add dashboard link (prometheus remote-write)
- prometheus-agent alerts delay increased from 10m to 30m

## [2.70.5] - 2022-12-30

### Changed

- Increase time for VaultIsDown from 15 to 20 minutes.

## [2.70.4] - 2022-12-29

### Changed

- alert AppWithoutTeamLabel renamed to AppWithoutTeamAnnotation
- alert AppWithoutTeamAnnotation opsrecipe
- unit tests for AppWithoutTeamAnnotation
- AppWithoutTeamAnnotation fires only during working hours
- Combine `KubeStateMetricsDown` and `KubeStateMetricsMissing` and fix inhibtion.

## [2.70.3] - 2022-12-19

### Added

* small tool to look for / filter alerts

### Fixed

- Fix `MatchingNumberOfPrometheusAndCluster` for CAPI clusters.

## [2.70.2] - 2022-12-15

### Fixed

- Revert previous fix.
- Ensure `PrometheusCriticalJobScrapingFailure` does not page on kvm.

## [2.70.1] - 2022-12-15

### Fixed

- Fix prometheus-agent inhibition on kvm.

## [2.70.0] - 2022-12-14

### Fixed

- fix `PrometheusCriticalJobScrapingFailure` alert by ignoring bastion node exporters and add the prometheus-agent not running inhibition because we know targets prior to that will have k8s component scraping failing.

### Added

- Documented how to add dashboard link

## [2.69.0] - 2022-12-13

### Added

- unit tests for AWS
- added values schema
- README: test hints

### Changed

- removed "workingHoursOnly" template from loki and crossplane tests
- upgraded Promtool and Architect for tests
- removed inhibition of GCP alerts from outside working hours

### Fixed

- fix `kubelet_down` inhibition alert.

## [2.68.0] - 2022-12-12

### Added

- Split cert-manager & cert expiring alerts per provider.

### Changed

- updated README with doc about the UT syntax.

### Fixed

- Fix fluentbit down alert.
- Ensure Prometheus Agent alerts are not running on `kvm` installations.

## [2.67.0] - 2022-12-08

### Changed

- Handle `aws-pod-identity-webhook` with optional prefix.

## [2.66.0] - 2022-12-08

### Added

- Push to capz-app-collection.
- Send CAPZ alerts to clippy.
- Added Promtail alerting rule

## [2.65.0] - 2022-12-06

### Changed

- Add `PrometheusCriticalJobScrapingFailure` to page once critical prometheus target is down.
- Change `Heartbeat` alert to ignore prometheus-agent.
- Improve InhibitionClusterIsNotRunningPrometheusAgent to fire on each cluster.
- Raise `PrometheusJobScrapingFailure` duration from 1h to 1d.

## [2.64.0] - 2022-11-30

### Changed

- Route `NoKyvernoPodRunning` alert with team label.
- Silence some Flux alerts outside of business hours.

## [2.63.1] - 2022-11-30

### Changed

- Change PrometheusAgentFailing alert to also being on MC

### Added

- unit tests: you can run tests against a specific file
- Add monitoring for `aws-pod-identity-webhook` deployment (IRSA).

## [2.63.0] - 2022-11-30

### Added

- Add basic rules for Crossplane: deployment not satisfied in `crossplane` namespace and crossplane `HelmRelease` failed

## [2.62.1] - 2022-11-29

- Update 'vpa' slo availability to 99%

## [2.62.0] - 2022-11-25

### Added

- Add PrometheusAgentFailing alert.
- Add InhibitionClusterIsNotRunningPrometheusAgent

## [2.61.0] - 2022-11-24

### Added

- Add alert to page when `Cluster` is stuck on deletion.

### Changed

- Disable bastion monitoring rules for CAPA

## [2.60.2] - 2022-11-22

### Changed

- Disable 'cluster-service' and vault rules for CAPA

### Fixed

- Setting `label_application_giantswarm_io_team` label to `atlas` for vpa slo recording rules
- Fix `make test` on macos

## [2.60.1] - 2022-11-14

### Changed

- Disable `cancel_if_outside_working_hours` for `disk.workload-cluster.rules`

### Fixed

- Flux slow reconciliation error budget was counting periods with suspended reconciliation as failures

## [2.60.0] - 2022-11-14

### Changed

- Inhibit `WorkloadClusterAppNotInstalled` when there are no workers.

### Fixed

- Fix `FluentBitDown` alert description.

## [2.59.0] - 2022-11-14

### Changed

- Disable `cancel_if_outside_working_hours` for `disk.workload-cluster.rules`
- FluxKustomizationFailed "stuck" time increased from 10m to 20m
- Flux slow reconciliation switched to error budget alert

## [2.58.0] - 2022-11-10

### Added

- Add VPA SLO alert.

## [2.57.0] - 2022-11-08

### Added

- Add `FluxWorkqueueTooLong` alert.

### Changed

- Narrow down Flux `FluxKustomizationFailed` alert.

## [2.56.0] - 2022-11-03

### Added

- Add SLO alert for Cilium Agent.

## [2.55.1] - 2022-11-02

### Changed

- Change ownership of Cert-manager related alerts

## [2.55.0] - 2022-10-24

### Removed

- `KongIngressControllerConfigurationPushErrorCountTooHigh`

## [2.54.0] - 2022-10-17

### Changed

- App CR related (coming from app-exporter) alerting rules are changed:
  - Per-team duplicated rules are removed and only one rule per alert type is kept. It doesn't overwrite the
    incoming `team` label, so alerts are always routed according to the `team` label value coming from `app-exporter`
- unassigned team is now detected using empty or 'noteam' value of the `team` label (alert routed to 'atlas')
- Move `KongIngressControllerConfigurationPushErrorCountTooHigh` alerting rule to business hours only.

### Removed

- Drop `blackbox-exporter` alerts for KVM clusters.

## [2.53.0] - 2022-10-12

### Changed

- Move `node-operator` NotReconciling alert to the provider team.

## [2.52.0] - 2022-10-11

### Fixed

- Fix ownership of `kong` and `external-dns` from team-honeybadger to team-cabbage.
- Fix ownership of `cert-manager from` team-honeybadger to team-hydra.
- Limit `WorkloadClusterAppFailed` alert to specific catalogs.
- Limit `WorkloadClusterAppPendingUpdate` alert to specific catalogs.
- Remove old, unused ArgoCD alerts pointing to team-honeybadger.
- Fix `AppExporterDown` rule to take endpoints defined by ServiceMonitors into consideration.

## [2.51.0] - 2022-09-29

### Added

- Change `OperatorNotReconcilingRocket` to page excluding cert operator.
- new loki alert: `LokiRingUnhealthy`
- PR template now asks to add unit tests
- Add `FlowcontrolTooManyRequests` when one fairness bucket is being hit too hard.

## [2.50.0] - 2022-09-26

### Added

- Add `aggregation:dex_k8s_authenticator_requests` recording rule.

### Changed

- Change `NodeHasConstantOOMKills` to consider only pods managed by us.
- Stop Rocket being alerted for AWS and GCP clusters.

## [2.49.0] - 2022-09-20

### Added

- Add `KongDatastoreNotReachable` alerting rule.
- Add `KongIngressControllerConfigurationPushErrorCountTooHigh` alerting rule.

## [2.48.2] - 2022-09-16

### Changed

- Include namespace in `WorkloadClusterAppFailed` alert's description.

### Added

- Add `PrometheusJobScrapingFailure` alerting rule.

## [2.48.1] - 2022-09-08

### Fixed

- Fix `aggregation:giantswarm:cluster_release_version` query for Azure cluster.

## [2.48.0] - 2022-09-08

### Added

- Add `FlowcontrolRejectedRequests` to alert when k8s API Server's fairness is rejecting API calls.

### Changed

- Lowered `ManagedLoggingElasticsearchDataNodesNotSatisfied` alert sensitivity - now triggers after 15min to avoid triggering on pod restarts.

## [2.47.1] - 2022-09-06

### Changed

- Enable alerts for dex in workload clusters.

## [2.47.0] - 2022-09-06

### Added

- Add CertManagerTooManyCertificateRequests (Team Cabbage).

## [2.46.0] - 2022-08-26

### Added

- Add `FluxImageAutomationControllerStuck` alert for stuck Flux Image Automation Controller.

## [2.45.1] - 2022-08-23

### Changed

- Fix ManagementClusterContainerIsRestartingTooFrequentlyGCP expression.

## [2.45.0] - 2022-08-18

### Added

- Add ManagementClusterAppFailedHydra (Team Hydra alert for GCP).
- Add WorkloadClusterAppFailedHydra (Team Hydra alert for GCP).
- Add ManagementClusterPodPendingGCP (Team Hydra alert for GCP).
- Add ManagementClusterContainerIsRestartingTooFrequentlyGCP (Team Hydra alert for GCP).
- Add ManagementClusterDeploymentMissingGCP (Team Hydra alert for GCP).
- Add WorkloadClusterContainerIsRestartingTooFrequentlyGCP (Team Hydra alert for GCP).
- Add WorkloadClusterCriticalPodNotRunningGCP (Team Hydra alert for GCP).
- Add WorkloadClusterPodPendingGCP (Team Hydra alert for GCP).
- Enable CAPI alerts (MachineUnhealthyPhase, MachineDeploymentReplicasMismatch, KubeadmControlPlaneReplicasMismatch, ClusterUnhealthyPhase) for GCP.

### Changed

- Extending time period for AWS cluster updates.
- Add `$labels.name` to team `WorkloadClusterWebhookDurationExceedsTimeout` alerts.
- Increase timeout for `VaultIsDown` to 15 minutes.

## [2.44.0] - 2022-08-12

### Changed

- prometheus-meta-operator reconcile errors alert are now limited to prometheus-meta-operator

## [2.43.0] - 2022-08-11

### Added

- Add ops-recipe for prometheus rule failures.

### Changed

- GrafanaDown page again

### Fixed

- Fix `cluster_id` in `InhibitionClusterStatus*` inhibition alerts.

## [2.42.2] - 2022-08-04

## Fixed

- Fix CadvisorDown for 1h.

## [2.42.1] - 2022-08-04

## Fixed

- Fix description and add opsrecipe for CadvisorDown.

## [2.42.0] - 2022-08-03

## Added

- Add InhibitionKubeletDown to bring back kubelet down inhibition.

## Changed

- Inhibit CadvisorDown with InhibitionKubeletDown.
- Extend delay CadvisorDown to 1h.
- CadvisorDown only triggered during working hours.

## [2.41.0] - 2022-08-02

### Changed

- Make InhibitionClusterStatusCreating last longer.

## [2.40.0] - 2022-08-01

### Added

- DataDiskPersistentVolumeSpaceTooLow for 10% threshold.

## [2.39.2] - 2022-07-27

### Changed

- NodeExporterCollectorFailed does not page anymore
- GrafanaDown does not page anymore

## [2.39.1] - 2022-07-27

### fixed

- GrafanaFolderPermissionsCronjobFails alert

## [2.39.0] - 2022-07-27

### Added

- alert "GrafanaFolderPermissionsCronjobFails"
- alert "FluentbitDropRatio"
- Alerting documentation

### Changed

- Atlas alerts that did not page now do, at least during workhours

## [2.38.0] - 2022-07-21

### Changed
- Revert enable api-server SLO alert during upgrades of HA masters clusters.

## [2.37.0] - 2022-07-21

### Changed

- Inhibit gcp alerts out of business hours.
- Don't monitor bastions on gcp.
- Don't monitor vault on gcp.
- Don't monitor cluster-service on gcp.
- Enable api-server SLO alert during upgrades of HA masters clusters.

## [2.36.0] - 2022-07-20

### Added

- Add `pmo` reconcile errors alert.

## [2.35.0] - 2022-07-20

### Changed

- Improve `CoreDNSDeploymentNotSatisfied` query to consider both Coredns deployments (running in masters and workers).

## [2.34.0] - 2022-07-20

### Changed

- Split Giant Swarm and customer Flux alerts.
- Switch `severity` of customer's Flux alerts to `notify`.
- Make `ClusterAutoscalerFailedScaling` less sensitive.

## [2.33.0] - 2022-07-18

### Changed
- Move AzureServicePrincipalExpiresInX alerts to page only in BH

## [2.32.1] - 2022-07-18

### Fixed

- Fixing `capi` and `capo` template rendering

## [2.32.0] - 2022-07-14

### Changed

- Rename provider `vcd` to `cloud-director`.

## [2.31.0] - 2022-07-06

### Added

- Add `cilium` to the Daemonset under SLO.

### Changed

- Route `WorkloadClusterCertificateWillExpireInLessThanAMonth` to AEs

## [2.30.0] - 2022-07-05

### Removed

- Removed `KiamSTSIssuingErrors` alert.

## [2.29.0] - 2022-07-01

### Added

- Add Rules for Cluster API and Cluster API Openstack for team rocket
- Add `aws-cloud-controller-manager`, `azure-cloud-controller-manager`, `azure-cloud-node-manager`, `azure-scheduled-events` and `csi-azuredisk-node` to the daemonset SLO query.

## [2.28.0] - 2022-06-30

### Added

- Add current AWS quota values to Cortex.

### Changed

- Improve AWS quota metrics.

## [2.27.0] - 2022-06-28

### Added

- Push aws-servicequotas-operator errors to Cortex.
- Route ServiceLevelBurnRateTooHigh alert using application.giantswarm.io/team label.
- Alerts for Loki
- Add support for VCD provider.

### Changed

- Route Certificate Expiration alerts to SE team.

## [2.26.0] - 2022-06-08

### Added

- Alert when the silence sync job is not scheduled for more than 1 day.
- Add script to sync mixin rules

### Changed

- Split mixin recording rules into 2 files (kubernetes, kube-prometheus).

## [2.25.0] - 2022-05-26

### Fixed

- Fixing mixins prometheus recording rules.

## [2.24.0] - 2022-05-25

### Changed

- Improve EtcdDBSizeTooLarge alerts.

## [2.23.0] - 2022-05-23

### Changed

- Split `WorkloadClusterWebhookDurationExceedsTimeout` by team owning the component.

## [2.22.0] - 2022-05-20

## Fixed

- FluentbitTooManyErrors improvements.

## Added

- fluent-logshipping-app down alerts.

## [2.21.0] - 2022-05-13

### Changed

- Add kong to `WorkloadClusterManagedDeploymentNotSatisfied` alert.
- Relax external-dns and cert-manager managed app names in `WorkloadClusterManagedDeploymentNotSatisfied` alert.

## [2.20.0] - 2022-05-13

### Changed

- Change `*EtcdDBSizeTooLarge`'s `for` to `7h` to catch when automated defrag is not happening.

## [2.19.0] - 2022-05-12

### Changed

- Improve '*EtcdDBSizeTooLarge' alerts.

## [2.18.0] - 2022-05-11

### Added

- Add new alert for irsa-operator erros.
- Add managed alertmanager to `ServiceLevelBurnRateTooHigh` alert.

### Fixed

- Fix Service Level alert for prometheus.

## [2.17.0] - 2022-05-10

### Added

- Push irsa-operator erros to Cortex.

## [2.16.1] - 2022-05-04

### Fixed

- Rename `ClusterCertificateWillExpireMetricMissing` alert to `ClusterCertificateExpirationMetricsMissing` to avoid being paged for test installations.

## [2.16.0] - 2022-05-04

### Added

- new alerts for Grafana

### Fixed

- Disable cert-exporter rules for CAPO and CAPV clusters.

## [2.15.1] - 2022-05-04

### Fixed

- Fix query for `WorkloadClusterCertificateWillExpireMetricMissing` alert and rename to `ClusterCertificateWillExpireMetricMissing`.

## [2.15.0] - 2022-04-20

### Added

- Add new SLO metric for nodepool-specific node health.

### Changed

- Increase the cert expiration alert to page before a month in KVM installations.
- Remove exception from `InhibitionOutsideWorkingHours` for ascension day 2022.

### Fixed

- Fixed query for kubelet SLO requests.

## [2.14.1] - 2022-04-12

### Fixed

- Opsrecipie link for `KiamSTSIssuingErrors`.

## [2.14.0] - 2022-04-12

### Changed

- Disable `NoHealthyJumphost` for CAPO and CAPV.

## [2.13.0] - 2022-04-11

### Changed

- Disable `cluster-service` and `vault` rules for CAPO and CAPV.

## [2.12.0] - 2022-04-11

### Added

- Push failing Kyverno policy information to Cortex.
- Extend `InhibitionOutsideWorkingHours` to also fire during ascension day 2022.

## [2.11.0] - 2022-04-08

### Changed

- Avoid alerting if `nvme` collector in node exporter is down on Azure.
- Use plain kube-state-metrics metrics for `IngressControllerDeploymentNotSatisfied` until [kube-state-metrics-app v1.9.0](https://github.com/giantswarm/kube-state-metrics-app/releases/tag/v1.9.0) is available in all WCs.

## [2.10.0] - 2022-03-30

### Changed

- Improve `OperatorkitErrorRateTooHighPhoenix` to page only if a meaningful numer of errors is happening.

## [2.9.0] - 2022-03-29

### Added

- Add aggregations for kong metrics

## [2.8.0] - 2022-03-24

## [1.9.1] - 2022-03-24

### Fixed

- Fix recording query to gather total number of Pods and Containers in a cluster.

## [1.9.0] - 2022-03-24

### Added

- Add new alert for when `Kyverno` scraping fails for 5m.

## [1.8.0] - 2022-03-23

### Removed

- Removed `ManagementClusterPodPendingFor15Min` and `ManagementClusterPodPending`.

## [1.7.1] - 2022-03-22

### Changed

- Inhibit `WorkloadClusterAppFailedPhoenix` if cluster has no worker nodes

## [1.7.0] - 2022-03-22

### Added

- Add a function to cancel alerts for openstack installations.

## [1.6.1] - 2022-03-17

### Fixed

- Print `PrometheusRuleFailures` decimals.
- Restrict `WorkloadClusterEtcdDown` query in order to avoid false alerts.

## [1.6.0] - 2022-03-07

### Changed

- Check if there is a meaningful number of DNS queries before firing `CoreDNSLoadUnbalanced`.

## [1.5.4] - 2022-03-04

### Changed

- Don't page if Node Exporter does not provide `tapestats` and `fibrechannel` metrics.

## [1.5.3] - 2022-03-02

### Fixed

- Fix Division By Zero error in `WorkloadClusterWebhookDurationExceedsTimeout`.

## [1.5.2] - 2022-02-25

### Changed

- Split `OperatorkitErrorRateTooHighRocket` out to provider teams.

## [1.5.1] - 2022-02-25

### Fixed

- Fixed query for `CoreDNSLoadUnbalanced` to make it work across all clusters in a MC.

## [1.5.0] - 2022-02-25

### Added

- Add `CoreDNSLoadUnbalanced` alert to check when DNS traffic is served by a subset of the coredns pods.

## [1.4.1] - 2022-02-23

### Fixed

- Fixed broken `ServiceLevelBurnRateTooHigh` alert.

## [1.4.0] - 2022-02-23

### Added

- Add `FluxSuspendedForTooLong` alert.

## [1.3.0] - 2022-02-16

### Changed

- Raise timeout before alerting for alerts that have `cancel_if_kube_state_metrics_down`.

## [1.2.1] - 2022-02-15

### Fixed

- Fix `managed_app_deployment_status_replicas_available` and `managed_app_deployment_status_replicas_unavailable` recording rules in cases where multiple deployments have the same name.

## [1.2.0] - 2022-02-11

### Added

- Add managed prometheus to `ServiceLevelBurnRateTooHigh` alert.
- Add `DeploymentNotSatisfiedFlux` alert.

## [1.1.0] - 2022-02-07

### Changed

- Update team ownership for KaaS-related alerts to be provider dependent.

## [1.0.0] - 2022-02-03

### Added

- Add `PrometheusRuleFailures` alert rule.

### Removed

- Remove `ChartOrphanSecret` rule that is no longer required.

### Fixed

- Fix `ServiceLevelBurnRateTooHigh` alert failure : many-to-many matching not allowed.

## [0.57.1] - 2022-02-01

### Changed

- Fix `NoHealthyJumphost` alert routing.
- Split apiserver routing for onprem and cloud.
- Replaced deprecated apiserver latency metric

## [0.57.0] - 2022-01-25

### Added

- Push unique CVE counts to cortex.

## [0.56.0] - 2022-01-25

### Added

- Add alert for workload cluster certificates about to expire.

### Changed

- Send SE alerts to correct KaaS teams.
- Use a template definition for KaaS team templating.

## [0.55.1] - 2022-01-21

- Removes `aggregation:prometheus:targets_count` recording rule.

## [0.55.0] - 2022-01-21

- Inhibit `PrometheusCantCommunicateWithKubernetesAPI` during cluster creating and upgrade.
- Add `aggregation:prometheus:targets_count` recording rule.

## [0.54.0] - 2022-01-21

### Added

- Added SLO alert for internal API request errors in kube-scheduler and kube-controller-manager.
- Added SLO alert for cloud (Azure and AWS) API request errors in kube-scheduler and kube-controller-manager.

## [0.53.0] - 2022-01-20

### Added

- Add `aggregation:giantswarm:app_info` cortex record.

## [0.52.0] - 2022-01-20

### Added

- Added new alert for `azure-scheduled-events` app.

## [0.51.1] - 2022-01-20

### Changed

- Make `DexErrorRateHigh` alert less sensitive.

## [0.51.0] - 2022-01-19

### Changed

- Make `DexErrorRateHigh` alert less sensitive.
- Add `NginxIngressDown`, `ExternalDNSDown` and `CertManagerDown` alerts.
- Include installaton, cluster and namespace in existing external-dns alerts.

## [0.50.0] - 2022-01-13

- Inhibit `MatchingNumberOfPrometheusAndCluster` during cluster creation.

## [0.50.0] - 2022-01-13

### Added

- Adding alert for high dex error rate.

## [0.49.0] - 2022-01-12

### Changed

- Change description of Falco alerts to differentiate between host- and pod-level events.

### Removed

- Delete unhelpful `HighNumberOfTimeWaitSockets` alert.

## [0.48.0] - 2022-01-11

### Fixed

- Fix Kubernetes and kubelet versions in cortex aggregations.

## [0.47.0] - 2022-01-07

### Changed

- Don't page KaaS with `DeploymentNotSatisfiedKaas` when monitoring deployments are not satisfied on management clusters.
- Don't page KaaS with `DeploymentNotSatisfiedKaas` when app platform deployments are not satisfied on management clusters.
- Remove `IngressControllerSSLCertificateWillExpireSoon`. It is covered by alert `CertificateSecretWillExpireInLessThanTwoWeeks`.
- Route workload cluster app failed alerts to teams.

## [0.46.2] - 2022-01-03

### Fixed

- Improve `WorkloadClusterCriticalPodNotRunningAWS` by ensuring the expected pod that is not missing is included in the description.

## [0.46.1] - 2022-01-03

### Fixed

- Fix opsrecipe for `CertOperatorVaultTokenAlmostExpired`.

## [0.46.0] - 2021-12-22

### Changed

- Silence `WorkloadClusterCriticalPodNotRunningAzure` and `WorkloadClusterCriticalPodNotRunningAWS` if `kube-state-metrics` is down.

## [0.45.0] - 2021-12-22

### Changed

- Silence `ClusterAutoscalerErrors` if cluster has no workers because `CoreDNS isn't running and that makes the autoscaler fail.

### Fixed

- Fix `aggregation:kubelet:version` and `aggregation:kubernetes:version` not showing kubernetes version.
- Added per-team ownership (alerts go to relevant teams, not Honeybadger) of efk-stack-app and
  nginx-ingress-controller-app for the WorkloadClusterAppFailed alert

## [0.44.0] - 2021-12-17

### Changed

- Silence some alerts when the workload cluster has 0 worker nodes.

## [0.43.0] - 2021-12-14

## [0.42.0] - 2021-12-13

### Changed

- Exclude `kiam-watchdog` from AWS workload cluster rules.

## [0.41.0] - 2021-12-06

### Added

- Alerts for EBS CSI.

### Changed

- Change ManagementClusterHasLessThanThreeNodes alert to use a metrics with reliable `role` label.

## [0.40.2] - 2021-12-03

### Fixed

- Consolidate alerts that covered the same issues.

## [0.40.1] - 2021-12-02

### Fixed

- Fix alert rule webhook errors for management clusters.

## [0.40.0] - 2021-11-30

### Added

- Add inhibition when cluster has no workers (AWS and Azure only).

## [0.39.0] - 2021-11-30

### Changed

- Split Flux alerts based on `cluster_type`
- Extend trigger period for Flux Workload Cluster alerts
- Prevent Flux Workload Cluster alerts from paging outside business hours

## [0.38.0] - 2021-11-30

### Changed

- Route more KaaS alerts based on the provider.

## [0.37.0] - 2021-11-29

### Changed

- Trigger `FluxSourceFailed` if it has been ongoing for 2h.

## [0.36.0] - 2021-11-24

### Changed

- Route some alerts based on the provider.

## [0.35.0] - 2021-11-22

### Changed

- Make `WorkloadClusterEtcdDBSizeTooLarge` only alert during business hours.

## [0.34.0] - 2021-11-12

### Changed

- Change management cluster app failed alerts to match new team structure.

## [0.33.0] - 2021-11-12

### Changed

- Make `CertificateSecretWillExpireInLessThanTwoWeeks` only alert for certificate secrets expriry on management clusters.

## [0.32.0] - 2021-11-10

### Changed

- Change `WorkloadClusterEtcdCommitDurationTooHigh` severity to paging.

## [0.31.3] - 2021-11-09

### Fixed

- Filter phoenix components correctly in `DeploymentNotSatisfiedPhoenix` alert..

## [0.31.2] - 2021-11-09

### Fixed

- Add `> 0` to FluxCD rules.

## [0.31.1] - 2021-11-09

### Fixed

- Fix FluxCD rule expression.

## [0.31.0] - 2021-11-09

### Added

- Add FluxCD rules.

## [0.30.0] - 2021-11-05

### Changed

- Ignore secrets whose name contains `kiam` in `CertificateSecretWillExpireInLessThanTwoWeeks`.
- Add `KiamCertificateSecretWillExpireInLessThanTwoWeeks` alerting for certificate secrets whose name contain `kiam`.
- Add `ManagedCertificateCRWillExpireInLessThanTwoWeeks` alerting on cert-manager certificates issued by default giantswarm managed `ClusterIssuer`.
- Report affected node instead of cert-exporter instance in certificate expiration alerts (WC and MC).
- Change ownership of rules to match new team structure.

## [0.29.0] - 2021-10-19

### Changed

- Move all daemonset alerts on workload clusters to the SLO framework.
- Move firecracker daemonset alerts on management clusters to the SLO framework.
- Change ownership of rules from `firecracker` to `phoenix`.

## [0.28.0] - 2021-10-18

### Changed

- Moved `WorkloadClusterDaemonSetNotSatisfiedLudacris` to `ServiceLevelBurnRateTooHigh` for calico daemonset.

## [0.27.2] - 2021-10-05

### Changed

- Revert cluster-api deployments to the `ManagementClusterDeploymentMissingFirecracker` alert rule.

## [0.27.1] - 2021-10-05

### Added

- Added cluster-api deployments to the `ManagementClusterDeploymentMissingFirecracker` alert rule

## [0.27.0] - 2021-10-05

### Added

- `ManagementClusterDeploymentMissingFirecracker` alert added to notify on missing critical MC deployments.

## [0.26.1] - 2021-10-05

### Changed

- Increase time for `WorkloadClusterCriticalPodNotRunningAWS` alert.

## [0.26.0] - 2021-10-01

### Changed

- Move event-exporter-.* to firecracker.
- Move grafana.* to atlas.

### Fixed

- Adjust `ServiceLevelBurnRateTooHigh` metric to avoid "multiple matches for labels" error.

### Added

- Bring back `WorkloadClusterCriticalPodNotRunningAWS` alert.

## [0.25.1] - 2021-09-29

### Changed

- Adjust time frame for error reports in `cluster-autoscaler`.

## [0.25.0] - 2021-09-28

### Changed

- Reduce blackbox-exporter service level target from 99.999% to 99.99%.

### Added

- Add alerts for the `cluster-autoscaler`.

## [0.24.0] - 2021-09-16

### Added

- Add recording rule for scheduled cluster upgrades `aggregation:giantswarm:cluster_scheduled_upgrades_time`

## [0.23.0] - 2021-09-16

### Changed

- Ignore non GS deployments in `WorkloadClusterManagedDeploymentNotSatisfied` alert.

### Fixed

- Exclude apps in giantswarm namespace from `aggregation:giantswarm:app_upgrade_available`.

## [0.22.0] - 2021-09-10

### Added

- Add `upgrade-schedule-operator` and `event-exporter-app` to `DeploymentNotSatisfiedFirecracker`

## [0.21.0] - 2021-09-08

### Added

- Add `app_version` label to `aggregation:giantswarm:app_deployed_workload_cluster_total`.

### Changed

- Cancel `PrometheusCantCommunicateWithKubernetesAPI` for deleting clusters.

## [0.20.0] - 2021-09-03

### Changed

- Remove 'InvalidLabellingSchema' alert.

## [0.19.0] - 2021-09-02

### Changed

- Only drop PII labels from `aggregation:grafana_analytics_sessions_total`,
  preserve the others so they can be used in analytics dashboard.

## [0.18.0] - 2021-09-02

### Added

- Add recording rule for Managed Apps with available upgrades.

## [0.17.1] - 2021-08-30

### Fixed

- Fix CI by upgrading architect-orb to 4.2.0
- Fix aggregation:grafana_analytics_sessions_total error. #85

## [0.17.0] - 2021-08-30

### Added

- Add workload cluster vertical pod autoscaler (VPA) availability alerts.

### Changed

- Remove `-unique` suffix from app, deployment, and daemonset names used in multiple alerts.
- Update grafana analytics recoding rule. #76 #80

### Fixed

- Fix labels on Batman operatorkit alerts.

## [0.16.0] - 2021-08-19

### Changed

- Drop user related labels from aggregation:grafana_analytics_sessions_total

## [0.15.0] - 2021-08-18

### Changed

- Increase timeout for ArgoCD alerts to 2h.

## [0.14.0] - 2021-08-18

### Changed

- Increase timeout for ArgoCD alerts to 30m.

## [0.13.0] - 2021-08-18

### Added

- Add alerts for unhealthy/out-of-sync ArgoCD Applications.

## [0.12.0] - 2021-08-17

### Changed

- Rename deployment `cluster-api-core-unique-webhook` -> `cluster-api-core-webhook`.

## [0.11.1] - 2021-08-16

### Added

- Push Falco event counts to cortex.

## [0.11.0] - 2021-08-11

### Added

- Add recording rule for `grafana_analytics_sessions_total`
- Add alerting rule for blackbox exporter endpoint down on KVM.

### Changed

- Include `DaemonSetNotSatisfiedChinaFirecracker` into `ServiceLevelBurnRateTooHigh` SLO alert for daemonsets.
- Improve `KiamSTSIssuingErrors` for AWS workload clusters.

## [0.10.0] - 2021-08-09

### Added

- Add basic Falco alerting rules.

### Changed

- Upgrade AppPendingUpdate alerts to page during working hours.

## [0.9.1] - 2021-08-05

### Fixed

- Fixed recording rule naming for IP exhaustion.

## [0.9.0] - 2021-08-05

### Added

- Add new alerts for the Prometheus Operator.
- Add recording rules to send the total of ready and not ready pods to Cortex to be able to investigate outages when a prometheus is gone or missing.

## [0.8.0] - 2021-08-05

### Changed

- Turn `DaemonSetNotSatisfiedFirecracker` into `ServiceLevelBurnRateTooHigh` SLO alert.

### Added

- Add recording rules for IP exhaustion on AWS.
- Add missing opsrecipe for `PrometheusFailsToCommunicateWithRemoteStorageAPI`.

### Removed

- Remove the severity from the `InvalidLabellingSchema` alert.

## [0.7.2] - 2021-07-26

### Changed

- Trigger `ETCDBackupJobFailedOrStuck` only during working hours.

## [0.7.1] - 2021-07-23

### Fixed

- Fixed Kiam rules.

## [0.7.0] - 2021-07-23

### Added

- Added KiamSTSIssuingErrors for AWS workload clusters.

## [0.6.1] - 2021-07-22

### Changed

- Add recording in recording Prometheus Rules to avoid conflicts with alerting rules.

## [0.6.0] - 2021-07-22

### Added

- Alert when Calico cannot save or restore iptables rules (KVM only).

### Removed

- Removed custom alerts for `dragon` and `dinosaur` installations.

## [0.5.0] - 2021-07-19

### Changed

- Only alert for failed etcd v2 backups on kvm management clusters.

## [0.4.0] - 2021-07-14

### Changed

- Update the alert description in `WorkloadClusterAppFailed`.
- Use `giantswarm/config` to generate managed configuration.

### Added

- Add `DeploymentNotSatisfiedLudacris` for Kyverno.

## [0.3.0] - 2021-07-09

### Changed

- `WorkloadClusterEtcdHasNoLeader` will not fire for loki or promtail pods any more.
- Use configuration management instead of `Installation.V1` values.

### Fixed

- Add namespace to `AppOperatorNotReady` alert description.

## [0.2.0] - 2021-07-02

### Added

- Add `ManagementClusterAppFailedLudacris`.

### Fixed

- Fix cluster ID in `WorkloadClusterAppPendingUpdate`.

### Removed

- Removed unused `NodeExporterMissing` alert.
- Remove outdated `cluster-autoscaler` app rules.

## [0.1.2] - 2021-06-28

### Changed

- Only alert during working hours for `ElasticsearchDataVolumeSpaceTooLow`
- Alert `IngressControllerDeploymentNotSatisfied` uses newly introduced recording rules and selects on app label

### Added

- Recording rules `managed_app_deployment_status_replicas_available` and `managed_app_deployment_status_replicas_unavailable` for deployments with label `giantswarm.io/service-type: "managed"`

## [0.1.1] - 2021-06-24

### Added

- Add team ownership annotation

## [0.1.0] - 2021-06-23

### Added

- Add existing rules from https://github.com/giantswarm/prometheus-meta-operator/pull/637/commits/bc6a26759eb955de92b41ed5eb33fa37980660f2

[Unreleased]: https://github.com/giantswarm/prometheus-rules/compare/v4.77.2...HEAD
[4.77.2]: https://github.com/giantswarm/prometheus-rules/compare/v4.77.1...v4.77.2
[4.77.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.77.0...v4.77.1
[4.77.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.76.0...v4.77.0
[4.76.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.75.0...v4.76.0
[4.75.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.74.1...v4.75.0
[4.74.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.74.0...v4.74.1
[4.74.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.73.2...v4.74.0
[4.73.2]: https://github.com/giantswarm/prometheus-rules/compare/v4.73.1...v4.73.2
[4.73.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.73.0...v4.73.1
[4.73.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.72.7...v4.73.0
[4.72.7]: https://github.com/giantswarm/prometheus-rules/compare/v4.72.6...v4.72.7
[4.72.6]: https://github.com/giantswarm/prometheus-rules/compare/v4.72.5...v4.72.6
[4.72.5]: https://github.com/giantswarm/prometheus-rules/compare/v4.72.4...v4.72.5
[4.72.4]: https://github.com/giantswarm/prometheus-rules/compare/v4.72.3...v4.72.4
[4.72.3]: https://github.com/giantswarm/prometheus-rules/compare/v4.72.2...v4.72.3
[4.72.2]: https://github.com/giantswarm/prometheus-rules/compare/v4.72.1...v4.72.2
[4.72.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.72.0...v4.72.1
[4.72.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.71.1...v4.72.0
[4.71.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.71.0...v4.71.1
[4.71.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.70.0...v4.71.0
[4.70.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.69.0...v4.70.0
[4.69.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.68.0...v4.69.0
[4.68.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.67.0...v4.68.0
[4.67.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.66.0...v4.67.0
[4.66.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.65.1...v4.66.0
[4.65.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.65.0...v4.65.1
[4.65.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.64.0...v4.65.0
[4.64.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.63.0...v4.64.0
[4.63.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.62.0...v4.63.0
[4.62.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.61.0...v4.62.0
[4.61.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.60.0...v4.61.0
[4.60.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.59.2...v4.60.0
[4.59.2]: https://github.com/giantswarm/prometheus-rules/compare/v4.59.1...v4.59.2
[4.59.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.59.0...v4.59.1
[4.59.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.58.0...v4.59.0
[4.58.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.57.0...v4.58.0
[4.57.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.56.1...v4.57.0
[4.56.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.56.0...v4.56.1
[4.56.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.55.0...v4.56.0
[4.55.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.54.1...v4.55.0
[4.54.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.54.0...v4.54.1
[4.54.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.53.0...v4.54.0
[4.53.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.52.0...v4.53.0
[4.52.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.51.0...v4.52.0
[4.51.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.50.0...v4.51.0
[4.50.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.49.3...v4.50.0
[4.49.3]: https://github.com/giantswarm/prometheus-rules/compare/v4.49.2...v4.49.3
[4.49.2]: https://github.com/giantswarm/prometheus-rules/compare/v4.49.1...v4.49.2
[4.49.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.49.0...v4.49.1
[4.49.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.48.0...v4.49.0
[4.48.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.47.0...v4.48.0
[4.47.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.46.1...v4.47.0
[4.46.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.46.0...v4.46.1
[4.46.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.45.0...v4.46.0
[4.45.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.44.0...v4.45.0
[4.44.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.43.0...v4.44.0
[4.43.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.42.1...v4.43.0
[4.42.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.42.0...v4.42.1
[4.42.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.41.0...v4.42.0
[4.41.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.40.0...v4.41.0
[4.40.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.39.1...v4.40.0
[4.39.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.39.0...v4.39.1
[4.39.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.38.1...v4.39.0
[4.38.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.38.0...v4.38.1
[4.38.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.37.0...v4.38.0
[4.37.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.36.0...v4.37.0
[4.36.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.35.0...v4.36.0
[4.35.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.34.0...v4.35.0
[4.34.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.33.0...v4.34.0
[4.33.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.32.0...v4.33.0
[4.32.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.31.0...v4.32.0
[4.31.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.30.0...v4.31.0
[4.30.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.29.0...v4.30.0
[4.29.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.28.0...v4.29.0
[4.28.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.27.0...v4.28.0
[4.27.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.26.2...v4.27.0
[4.26.2]: https://github.com/giantswarm/prometheus-rules/compare/v4.26.1...v4.26.2
[4.26.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.26.0...v4.26.1
[4.26.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.25.0...v4.26.0
[4.25.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.24.1...v4.25.0
[4.24.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.24.0...v4.24.1
[4.24.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.23.0...v4.24.0
[4.23.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.22.0...v4.23.0
[4.22.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.21.1...v4.22.0
[4.21.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.21.0...v4.21.1
[4.21.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.20.0...v4.21.0
[4.20.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.19.0...v4.20.0
[4.19.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.18.0...v4.19.0
[4.18.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.17.0...v4.18.0
[4.17.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.16.1...v4.17.0
[4.16.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.16.0...v4.16.1
[4.16.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.15.2...v4.16.0
[4.15.2]: https://github.com/giantswarm/prometheus-rules/compare/v4.15.1...v4.15.2
[4.15.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.15.0...v4.15.1
[4.15.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.14.0...v4.15.0
[4.14.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.13.3...v4.14.0
[4.13.3]: https://github.com/giantswarm/prometheus-rules/compare/v4.13.2...v4.13.3
[4.13.2]: https://github.com/giantswarm/prometheus-rules/compare/v4.13.1...v4.13.2
[4.13.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.13.0...v4.13.1
[4.13.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.12.0...v4.13.0
[4.12.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.11.0...v4.12.0
[4.11.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.10.0...v4.11.0
[4.10.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.9.1...v4.10.0
[4.9.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.9.0...v4.9.1
[4.9.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.8.2...v4.9.0
[4.8.2]: https://github.com/giantswarm/prometheus-rules/compare/v4.8.1...v4.8.2
[4.8.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.8.0...v4.8.1
[4.8.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.7.0...v4.8.0
[4.7.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.6.3...v4.7.0
[4.6.3]: https://github.com/giantswarm/prometheus-rules/compare/v4.6.2...v4.6.3
[4.6.2]: https://github.com/giantswarm/prometheus-rules/compare/v4.6.1...v4.6.2
[4.6.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.6.0...v4.6.1
[4.6.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.5.1...v4.6.0
[4.5.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.5.0...v4.5.1
[4.5.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.4.2...v4.5.0
[4.4.2]: https://github.com/giantswarm/prometheus-rules/compare/v4.4.1...v4.4.2
[4.4.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.4.0...v4.4.1
[4.4.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.3.5...v4.4.0
[4.3.5]: https://github.com/giantswarm/prometheus-rules/compare/v4.3.4...v4.3.5
[4.3.4]: https://github.com/giantswarm/prometheus-rules/compare/v4.3.3...v4.3.4
[4.3.3]: https://github.com/giantswarm/prometheus-rules/compare/v4.3.2...v4.3.3
[4.3.2]: https://github.com/giantswarm/prometheus-rules/compare/v4.3.1...v4.3.2
[4.3.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.3.0...v4.3.1
[4.3.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.2.1...v4.3.0
[4.2.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.2.0...v4.2.1
[4.2.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.1.2...v4.2.0
[4.1.2]: https://github.com/giantswarm/prometheus-rules/compare/v4.1.1...v4.1.2
[4.1.1]: https://github.com/giantswarm/prometheus-rules/compare/v4.1.0...v4.1.1
[4.1.0]: https://github.com/giantswarm/prometheus-rules/compare/v4.0.0...v4.1.0
[4.0.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.15.0...v4.0.0
[3.15.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.14.2...v3.15.0
[3.14.2]: https://github.com/giantswarm/prometheus-rules/compare/v3.14.1...v3.14.2
[3.14.1]: https://github.com/giantswarm/prometheus-rules/compare/v3.14.0...v3.14.1
[3.14.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.13.1...v3.14.0
[3.13.1]: https://github.com/giantswarm/prometheus-rules/compare/v3.13.0...v3.13.1
[3.13.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.12.2...v3.13.0
[3.12.2]: https://github.com/giantswarm/prometheus-rules/compare/v3.12.1...v3.12.2
[3.12.1]: https://github.com/giantswarm/prometheus-rules/compare/v3.12.0...v3.12.1
[3.12.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.11.2...v3.12.0
[3.11.2]: https://github.com/giantswarm/prometheus-rules/compare/v3.11.1...v3.11.2
[3.11.1]: https://github.com/giantswarm/prometheus-rules/compare/v3.11.0...v3.11.1
[3.11.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.10.1...v3.11.0
[3.10.1]: https://github.com/giantswarm/prometheus-rules/compare/v3.10.0...v3.10.1
[3.10.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.9.0...v3.10.0
[3.9.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.8.1...v3.9.0
[3.8.1]: https://github.com/giantswarm/prometheus-rules/compare/v3.8.0...v3.8.1
[3.8.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.7.2...v3.8.0
[3.7.2]: https://github.com/giantswarm/prometheus-rules/compare/v3.7.1...v3.7.2
[3.7.1]: https://github.com/giantswarm/prometheus-rules/compare/v3.7.0...v3.7.1
[3.7.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.6.2...v3.7.0
[3.6.2]: https://github.com/giantswarm/prometheus-rules/compare/v3.6.1...v3.6.2
[3.6.1]: https://github.com/giantswarm/prometheus-rules/compare/v3.6.0...v3.6.1
[3.6.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.5.0...v3.6.0
[3.5.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.4.0...v3.5.0
[3.4.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.3.0...v3.4.0
[3.3.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.2.0...v3.3.0
[3.2.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.1.1...v3.2.0
[3.1.1]: https://github.com/giantswarm/prometheus-rules/compare/v3.1.0...v3.1.1
[3.1.0]: https://github.com/giantswarm/prometheus-rules/compare/v3.0.3...v3.1.0
[3.0.3]: https://github.com/giantswarm/prometheus-rules/compare/v3.0.2...v3.0.3
[3.0.2]: https://github.com/giantswarm/prometheus-rules/compare/v3.0.1...v3.0.2
[3.0.1]: https://github.com/giantswarm/prometheus-rules/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.153.1...v3.0.0
[2.153.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.153.0...v2.153.1
[2.153.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.152.1...v2.153.0
[2.152.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.152.0...v2.152.1
[2.152.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.151.0...v2.152.0
[2.151.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.150.1...v2.151.0
[2.150.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.150.0...v2.150.1
[2.150.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.149.0...v2.150.0
[2.149.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.148.0...v2.149.0
[2.148.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.147.1...v2.148.0
[2.147.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.147.0...v2.147.1
[2.147.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.146.0...v2.147.0
[2.146.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.145.0...v2.146.0
[2.145.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.144.0...v2.145.0
[2.144.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.143.2...v2.144.0
[2.143.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.143.1...v2.143.2
[2.143.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.143.0...v2.143.1
[2.143.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.142.2...v2.143.0
[2.142.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.142.1...v2.142.2
[2.142.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.142.0...v2.142.1
[2.142.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.141.0...v2.142.0
[2.141.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.140.2...v2.141.0
[2.140.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.140.1...v2.140.2
[2.140.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.140.0...v2.140.1
[2.140.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.139.0...v2.140.0
[2.139.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.138.3...v2.139.0
[2.138.3]: https://github.com/giantswarm/prometheus-rules/compare/v2.138.2...v2.138.3
[2.138.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.138.1...v2.138.2
[2.138.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.138.0...v2.138.1
[2.138.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.137.0...v2.138.0
[2.137.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.136.0...v2.137.0
[2.136.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.135.0...v2.136.0
[2.135.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.134.1...v2.135.0
[2.134.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.134.0...v2.134.1
[2.134.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.133.0...v2.134.0
[2.133.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.132.0...v2.133.0
[2.132.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.131.0...v2.132.0
[2.131.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.130.0...v2.131.0
[2.130.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.129.0...v2.130.0
[2.129.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.128.0...v2.129.0
[2.128.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.127.0...v2.128.0
[2.127.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.126.1...v2.127.0
[2.126.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.126.0...v2.126.1
[2.126.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.125.0...v2.126.0
[2.125.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.124.0...v2.125.0
[2.124.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.123.0...v2.124.0
[2.123.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.122.0...v2.123.0
[2.122.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.121.0...v2.122.0
[2.121.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.120.0...v2.121.0
[2.120.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.119.0...v2.120.0
[2.119.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.118.1...v2.119.0
[2.118.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.118.0...v2.118.1
[2.118.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.117.0...v2.118.0
[2.117.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.116.0...v2.117.0
[2.116.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.115.1...v2.116.0
[2.115.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.115.0...v2.115.1
[2.115.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.114.0...v2.115.0
[2.114.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.113.0...v2.114.0
[2.113.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.112.0...v2.113.0
[2.112.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.111.0...v2.112.0
[2.111.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.110.0...v2.111.0
[2.110.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.109.0...v2.110.0
[2.109.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.108.0...v2.109.0
[2.108.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.107.0...v2.108.0
[2.107.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.106.0...v2.107.0
[2.106.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.105.0...v2.106.0
[2.105.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.104.0...v2.105.0
[2.104.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.103.0...v2.104.0
[2.103.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.102.0...v2.103.0
[2.102.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.101.0...v2.102.0
[2.101.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.100.1...v2.101.0
[2.100.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.100.0...v2.100.1
[2.100.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.99.0...v2.100.0
[2.99.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.98.4...v2.99.0
[2.98.4]: https://github.com/giantswarm/prometheus-rules/compare/v2.98.3...v2.98.4
[2.98.3]: https://github.com/giantswarm/prometheus-rules/compare/v2.98.2...v2.98.3
[2.98.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.98.1...v2.98.2
[2.98.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.98.0...v2.98.1
[2.98.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.97.2...v2.98.0
[2.97.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.97.1...v2.97.2
[2.97.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.97.0...v2.97.1
[2.97.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.96.6...v2.97.0
[2.96.6]: https://github.com/giantswarm/prometheus-rules/compare/v2.96.5...v2.96.6
[2.96.5]: https://github.com/giantswarm/prometheus-rules/compare/v2.96.4...v2.96.5
[2.96.4]: https://github.com/giantswarm/prometheus-rules/compare/v2.96.3...v2.96.4
[2.96.3]: https://github.com/giantswarm/prometheus-rules/compare/v2.96.2...v2.96.3
[2.96.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.96.1...v2.96.2
[2.96.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.96.0...v2.96.1
[2.96.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.95.2...v2.96.0
[2.95.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.95.1...v2.95.2
[2.95.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.95.0...v2.95.1
[2.95.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.94.0...v2.95.0
[2.94.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.93.0...v2.94.0
[2.93.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.92.0...v2.93.0
[2.92.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.91.0...v2.92.0
[2.91.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.90.0...v2.91.0
[2.90.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.89.0...v2.90.0
[2.89.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.88.0...v2.89.0
[2.88.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.87.0...v2.88.0
[2.87.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.86.1...v2.87.0
[2.86.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.86.0...v2.86.1
[2.86.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.85.0...v2.86.0
[2.85.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.84.0...v2.85.0
[2.84.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.83.0...v2.84.0
[2.83.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.82.4...v2.83.0
[2.82.4]: https://github.com/giantswarm/prometheus-rules/compare/v2.82.3...v2.82.4
[2.82.3]: https://github.com/giantswarm/prometheus-rules/compare/v2.82.2...v2.82.3
[2.82.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.82.1...v2.82.2
[2.82.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.82.0...v2.82.1
[2.82.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.80.1...v2.82.0
[2.80.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.80.0...v2.80.1
[2.80.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.79.0...v2.80.0
[2.79.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.78.0...v2.79.0
[2.78.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.77.0...v2.78.0
[2.77.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.76.1...v2.77.0
[2.76.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.76.0...v2.76.1
[2.76.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.75.0...v2.76.0
[2.75.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.74.0...v2.75.0
[2.74.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.73.2...v2.74.0
[2.73.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.73.1...v2.73.2
[2.73.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.73.0...v2.73.1
[2.73.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.72.0...v2.73.0
[2.72.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.71.1...v2.72.0
[2.71.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.71.0...v2.71.1
[2.71.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.70.5...v2.71.0
[2.70.5]: https://github.com/giantswarm/prometheus-rules/compare/v2.70.4...v2.70.5
[2.70.4]: https://github.com/giantswarm/prometheus-rules/compare/v2.70.3...v2.70.4
[2.70.3]: https://github.com/giantswarm/prometheus-rules/compare/v2.70.2...v2.70.3
[2.70.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.70.1...v2.70.2
[2.70.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.70.0...v2.70.1
[2.70.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.69.0...v2.70.0
[2.69.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.68.0...v2.69.0
[2.68.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.67.0...v2.68.0
[2.67.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.66.0...v2.67.0
[2.66.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.65.0...v2.66.0
[2.65.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.64.0...v2.65.0
[2.64.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.63.1...v2.64.0
[2.63.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.63.0...v2.63.1
[2.63.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.62.1...v2.63.0
[2.62.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.62.0...v2.62.1
[2.62.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.61.0...v2.62.0
[2.61.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.60.2...v2.61.0
[2.60.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.60.1...v2.60.2
[2.60.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.60.0...v2.60.1
[2.60.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.59.0...v2.60.0
[2.59.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.58.0...v2.59.0
[2.58.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.57.0...v2.58.0
[2.57.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.56.0...v2.57.0
[2.56.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.55.1...v2.56.0
[2.55.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.55.0...v2.55.1
[2.55.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.54.0...v2.55.0
[2.54.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.53.0...v2.54.0
[2.53.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.52.0...v2.53.0
[2.52.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.51.0...v2.52.0
[2.51.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.50.0...v2.51.0
[2.50.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.49.0...v2.50.0
[2.49.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.48.2...v2.49.0
[2.48.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.48.1...v2.48.2
[2.48.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.48.0...v2.48.1
[2.48.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.47.1...v2.48.0
[2.47.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.47.0...v2.47.1
[2.47.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.46.0...v2.47.0
[2.46.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.45.1...v2.46.0
[2.45.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.45.0...v2.45.1
[2.45.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.44.0...v2.45.0
[2.44.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.43.0...v2.44.0
[2.43.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.42.2...v2.43.0
[2.42.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.42.1...v2.42.2
[2.42.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.42.0...v2.42.1
[2.42.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.41.0...v2.42.0
[2.41.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.40.0...v2.41.0
[2.40.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.39.2...v2.40.0
[2.39.2]: https://github.com/giantswarm/prometheus-rules/compare/v2.39.1...v2.39.2
[2.39.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.39.0...v2.39.1
[2.39.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.38.0...v2.39.0
[2.38.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.37.0...v2.38.0
[2.37.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.36.0...v2.37.0
[2.36.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.35.0...v2.36.0
[2.35.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.34.0...v2.35.0
[2.34.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.33.0...v2.34.0
[2.33.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.32.1...v2.33.0
[2.32.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.32.0...v2.32.1
[2.32.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.31.0...v2.32.0
[2.31.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.30.0...v2.31.0
[2.30.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.29.0...v2.30.0
[2.29.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.28.0...v2.29.0
[2.28.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.27.0...v2.28.0
[2.27.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.26.0...v2.27.0
[2.26.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.25.0...v2.26.0
[2.25.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.24.0...v2.25.0
[2.24.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.23.0...v2.24.0
[2.23.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.22.0...v2.23.0
[2.22.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.21.0...v2.22.0
[2.21.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.20.0...v2.21.0
[2.20.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.19.0...v2.20.0
[2.19.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.18.0...v2.19.0
[2.18.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.17.0...v2.18.0
[2.17.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.16.1...v2.17.0
[2.16.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.16.0...v2.16.1
[2.16.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.15.1...v2.16.0
[2.15.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.15.0...v2.15.1
[2.15.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.14.1...v2.15.0
[2.14.1]: https://github.com/giantswarm/prometheus-rules/compare/v2.14.0...v2.14.1
[2.14.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.13.0...v2.14.0
[2.13.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.12.0...v2.13.0
[2.12.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.11.0...v2.12.0
[2.11.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.10.0...v2.11.0
[2.10.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.9.0...v2.10.0
[2.9.0]: https://github.com/giantswarm/prometheus-rules/compare/v2.8.0...v2.9.0
[2.8.0]: https://github.com/giantswarm/prometheus-rules/compare/v1.9.1...v2.8.0
[1.9.1]: https://github.com/giantswarm/prometheus-rules/compare/v1.9.0...v1.9.1
[1.9.0]: https://github.com/giantswarm/prometheus-rules/compare/v1.7.1...v1.9.0
[1.7.1]: https://github.com/giantswarm/prometheus-rules/compare/v1.7.0...v1.7.1
[1.7.0]: https://github.com/giantswarm/prometheus-rules/compare/v1.6.1...v1.7.0
[1.6.1]: https://github.com/giantswarm/prometheus-rules/compare/v1.6.0...v1.6.1
[1.6.0]: https://github.com/giantswarm/prometheus-rules/compare/v1.5.4...v1.6.0
[1.5.4]: https://github.com/giantswarm/prometheus-rules/compare/v1.5.3...v1.5.4
[1.5.3]: https://github.com/giantswarm/prometheus-rules/compare/v1.5.2...v1.5.3
[1.5.2]: https://github.com/giantswarm/prometheus-rules/compare/v1.5.1...v1.5.2
[1.5.1]: https://github.com/giantswarm/prometheus-rules/compare/v1.5.0...v1.5.1
[1.5.0]: https://github.com/giantswarm/prometheus-rules/compare/v1.4.1...v1.5.0
[1.4.1]: https://github.com/giantswarm/prometheus-rules/compare/v1.4.0...v1.4.1
[1.4.0]: https://github.com/giantswarm/prometheus-rules/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/giantswarm/prometheus-rules/compare/v1.2.1...v1.3.0
[1.2.1]: https://github.com/giantswarm/prometheus-rules/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/giantswarm/prometheus-rules/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/giantswarm/prometheus-rules/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.57.1...v1.0.0
[0.57.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.57.0...v0.57.1
[0.57.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.56.0...v0.57.0
[0.56.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.55.1...v0.56.0
[0.55.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.55.0...v0.55.1
[0.55.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.54.0...v0.55.0
[0.54.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.53.0...v0.54.0
[0.53.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.52.0...v0.53.0
[0.52.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.51.1...v0.52.0
[0.51.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.51.0...v0.51.1
[0.51.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.50.0...v0.51.0
[0.50.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.49.0...v0.50.0
[0.49.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.48.0...v0.49.0
[0.48.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.47.0...v0.48.0
[0.47.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.46.2...v0.47.0
[0.46.2]: https://github.com/giantswarm/prometheus-rules/compare/v0.46.1...v0.46.2
[0.46.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.46.0...v0.46.1
[0.46.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.45.0...v0.46.0
[0.45.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.44.0...v0.45.0
[0.44.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.43.0...v0.44.0
[0.43.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.42.0...v0.43.0
[0.42.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.41.0...v0.42.0
[0.41.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.40.2...v0.41.0
[0.40.2]: https://github.com/giantswarm/prometheus-rules/compare/v0.40.1...v0.40.2
[0.40.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.40.0...v0.40.1
[0.40.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.39.0...v0.40.0
[0.39.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.38.0...v0.39.0
[0.38.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.37.0...v0.38.0
[0.37.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.36.0...v0.37.0
[0.36.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.35.0...v0.36.0
[0.35.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.34.0...v0.35.0
[0.34.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.33.0...v0.34.0
[0.33.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.32.0...v0.33.0
[0.32.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.31.3...v0.32.0
[0.31.3]: https://github.com/giantswarm/prometheus-rules/compare/v0.31.2...v0.31.3
[0.31.2]: https://github.com/giantswarm/prometheus-rules/compare/v0.31.1...v0.31.2
[0.31.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.31.0...v0.31.1
[0.31.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.30.0...v0.31.0
[0.30.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.29.0...v0.30.0
[0.29.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.28.0...v0.29.0
[0.28.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.27.2...v0.28.0
[0.27.2]: https://github.com/giantswarm/prometheus-rules/compare/v0.27.1...v0.27.2
[0.27.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.27.0...v0.27.1
[0.27.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.26.1...v0.27.0
[0.26.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.26.0...v0.26.1
[0.26.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.25.1...v0.26.0
[0.25.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.25.0...v0.25.1
[0.25.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.24.0...v0.25.0
[0.24.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.23.0...v0.24.0
[0.23.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.22.0...v0.23.0
[0.22.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.21.0...v0.22.0
[0.21.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.20.0...v0.21.0
[0.20.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.19.0...v0.20.0
[0.19.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.18.0...v0.19.0
[0.18.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.17.1...v0.18.0
[0.17.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.17.0...v0.17.1
[0.17.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.16.0...v0.17.0
[0.16.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.15.0...v0.16.0
[0.15.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.14.0...v0.15.0
[0.14.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.13.0...v0.14.0
[0.13.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.12.0...v0.13.0
[0.12.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.11.1...v0.12.0
[0.11.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.11.0...v0.11.1
[0.11.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.10.0...v0.11.0
[0.10.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.9.1...v0.10.0
[0.9.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.7.2...v0.8.0
[0.7.2]: https://github.com/giantswarm/prometheus-rules/compare/v0.7.1...v0.7.2
[0.7.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.7.0...v0.7.1
[0.7.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.6.1...v0.7.0
[0.6.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/giantswarm/prometheus-rules/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/giantswarm/prometheus-rules/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/giantswarm/prometheus-rules/releases/tag/v0.1.0
