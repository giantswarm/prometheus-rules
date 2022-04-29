# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- new alerts for Grafana

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

- Opsrecipie link for `KiamSTSIssuingErrors`

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

[Unreleased]: https://github.com/giantswarm/prometheus-rules/compare/v2.15.0...HEAD
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
