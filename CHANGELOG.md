# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Increase timeout for ArgoCD alerts.

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

[Unreleased]: https://github.com/giantswarm/prometheus-rules/compare/v0.13.0...HEAD
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
