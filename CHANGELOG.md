# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.107.0] - 2023-06-26

### Changed

- Split Grafana Cloud recording rules into smaller groups.

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
- Added "cancel_if_prometheus_agent_down" for phoenix alerts ManagementClusterCriticalPodMetricMissing, ManagementClusterDeploymentMissingAWS, WorkloadClusterNonCriticalDeploymentNotSatisfiedKaas

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

[Unreleased]: https://github.com/giantswarm/prometheus-rules/compare/v2.107.0...HEAD
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
