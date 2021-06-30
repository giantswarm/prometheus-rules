# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- AlertingRules for Loki + Promtail

### Changed

- Removed unused `NodeExporterMissing` alert.

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

[Unreleased]: https://github.com/giantswarm/prometheus-rules/compare/v0.1.2...HEAD
[0.1.2]: https://github.com/giantswarm/prometheus-rules/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/giantswarm/prometheus-rules/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/giantswarm/prometheus-rules/releases/tag/v0.1.0
