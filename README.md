[![CircleCI](https://circleci.com/gh/giantswarm/prometheus-rules.svg?style=shield)](https://circleci.com/gh/giantswarm/prometheus-rules)

# Giant Swarm alert and recording rules

## Table of Contents

- [Introduction](#introduction)
- [Alerting](#alerting)
  - [Alert structure](#alert-structure)
    - [Metrics-based alerts](#metrics-based-alerts)
    - [Logs-based alerts](#logs-based-alerts)
  - [Best practices](#best-practices)
    - [Mandatory annotations](#mandatory-annotations)
    - [Recommended annotations](#recommended-annotations)
    - [Dashboard URL construction](#dashboard-url-construction)
    - [Mandatory labels](#mandatory-labels)
    - [Optional labels](#optional-labels)
    - [`Absent` function](#absent-function)
    - [Useful links](#useful-links)
  - [Alert routing](#alert-routing)
    - [Opsgenie routing](#opsgenie-routing)
    - [Inhibitions](#inhibitions)
  - [Recording rules](#recording-rules)
- [Mixins management](#mixins)
  - [kubernetes-mixins](#kubernetes-mixins)
  - [mimir-mixins](#mimir-mixins)
  - [loki-mixins](#loki-mixins)
- [Testing](#testing)
  - [Prometheus rules unit tests](#prometheus-rules-unit-tests)
  - [Test syntax](#test-syntax)
  - [Test exceptions](#test-exceptions)
  - [Test "no data" case](#test-no-data-case)
  - [Hints & tips](#hints--tips)
- [Linting](#linting)
  - [Alertmanager inhibition dependency check](#alertmanager-inhibition-dependency-check)
  - [Runbook check](#runbook-check)
  - [Prometheus Linter](#prometheus-linter)

## Introduction

This repository serves as a centralized collection of Prometheus configurations for Giant Swarm's monitoring system. It includes:

- **Alerting Rules**: Definitions for monitoring and alerting across different teams and platforms
- **Recording Rules**: Pre-computed expressions for efficient querying
- **Mixin Configurations**: Integration with kubernetes, mimir, and loki mixins
- **Testing Framework**: Comprehensive testing utilities for rules validation
- **Quality Checks**: Linting and validation tools to ensure rule consistency

The repository is structured to support multi-team collaboration while maintaining high standards through automated testing, proper documentation, and standardized alert routing.

## Alerting

The alerting rules are located in `helm/prometheus-rules/templates/<area>/<team>/alerting-rules` in the specific area/team to which they belong.

### Alert structure

Giant Swarm supports two different types of alert rules:

#### Metrics-based alerts

These are standard Prometheus alerts based on PromQL queries against metrics data. They are stored in files ending with `.rules.yaml`.

Example:

```yaml
# management-cluster-app-failed-atlas.rules.yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: management-cluster-app-failed-atlas
  namespace: monitoring
  labels:
    area: platform
    team: atlas
spec:
  groups:
  - name: app
    rules:
    - alert: ManagementClusterAppFailedAtlas
      annotations:
        summary: Management cluster app not deployed correctly
        description: '{{`Management Cluster App {{ $labels.name }}, version {{ $labels.version }} is {{if $labels.status }} in {{ $labels.status }} state. {{else}} not installed. {{end}}`}}'
        __dashboardUid__: unique-id-of-the-dashboard
        __panelId__: 42 # id of the panel in the dashboard
        dashboardQueryParams: "orgid=1"
        # dashboardExternalUrl: https://link-to-my-dashboard
        runbook_url: https://intranet.giantswarm.io/docs/support-and-ops/runbooks/app-failures/
      expr: app_operator_app_info{status!~"(?i:(deployed|cordoned))", catalog=~"control-plane-.*",team="atlas"}
      for: 30m
      labels:
        area: platform
        cancel_if_cluster_status_creating: "true"
        cancel_if_cluster_status_deleting: "true"
        cancel_if_cluster_status_updating: "true"
        cancel_if_outside_working_hours: "true"
        severity: page
        sig: none
        team: atlas
```

#### Logs-based alerts

These alerts are generated from log data using LogQL queries processed by Loki. To create a log-based alert:

- Ensure the `expr` field contains a valid LogQL query
- Name the file with a `.logs.yml` extension, this will render the following labels on the alert and ensure the alert is loaded into Loki:
  * `application.giantswarm.io/prometheus-rule-kind: loki` (deprecated, will be removed once all management clusters have been upgraded to v30)
  * `observability.giantswarm.io/rule-type: logs` (new label for releases > v30)

Example:

```yaml
# log-based-alerts-example.logs.yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: log-based-alerts-example
  namespace: monitoring
  labels:
    area: platform
    team: myteam
spec:
  groups:
  - name: log-alerts
    rules:
    - alert: HighErrorRate
      annotations:
        description: "High error rate detected in application logs"
        summary: "Log-based alert for errors"
        __dashboardUid__: UniqueID of the dashboard
        __panelId__: id of the panel in the dashboard
        dashboardQueryParams: "orgid=1"
        runbook_url: https://intranet.giantswarm.io/docs/support-and-ops/ops-recipes/log-errors/
      expr: sum(rate({app="my-app"} |= "error" [5m])) > 100
      for: 10m
      labels:
        severity: page
        team: myteam
        area: platform
```

Log-based alerts are processed differently in the observability platform but appear alongside metrics-based alerts in alerting interfaces.

### Best practices

We follow standardized practices for organizing our alerts using PrometheusRule custom resources.

#### Mandatory annotations
- `description`: Detailed explanation of what happened and what the alert is monitoring
- `runbook_url`: Link to a runbook page with incident management instructions

#### Recommended annotations
- `summary`: Brief overview of what the alert detected
- `__dashboardUid__`: Unique identifier of the relevant dashboard
- `__panelId__`: Specific panel ID within the referenced dashboard
- `dashboardQueryParams`: Additional URL parameters (must include `orgId=1` for Shared Org dashboards or `orgId=2` for others)
- `dashboardExternalUrl`: Optional link to an external Grafana instance (like Grafana Cloud)

##### Dashboard URL construction

Alertmanager generates dashboard URLs for Opsgenie and Slack alerts using these rules:

1. With only `__dashboardUid__`: `https://grafana.domain/__dashboardUid__`
2. With both `__dashboardUid__` and `dashboardQueryParams`: `https://grafana.domain/__dashboardUid__?dashboardQueryParams`
3. If `dashboardExternalUrl` is set: Uses the exact URL provided

#### Mandatory labels
- `area`: Functional area (e.g., platform, apps)
- `team`: Responsible team identifier
- `severity`: Alert severity level (page, notify)

#### Optional labels
- `cancel_if_*`: Labels used for alert inhibitions
- `all_pipelines: "true"`: Ensures the alert is sent to Opsgenie regardless of installation's pipeline

#### `Absent` function

If you want to make sure a metrics exists on one cluster, you can't just use the `absent` function anymore.
With `mimir` we have metrics for all the clusters on a single database, and it makes detecting the absence of one metrics on one cluster much harder.

To achieve such a test, you should do like [`PrometheusAgentFailing`](https://github.com/giantswarm/prometheus-rules/blob/master/helm/prometheus-rules/templates/alerting-rules/areas/platform/atlas/prometheus-agent.rules.yml) alert does.

#### Useful links

* [PromQL cheatsheet](https://promlabs.com/promql-cheat-sheet/)
* [Promlens](https://demo.promlens.com/) - explain promql queries
* [Awesome prometheus alerts](https://awesome-prometheus-alerts.grep.to/) - library of queries

### Alert routing

Alertmanager does the routing based on the labels menitoned above.
You can see the routing rules in alertmanager's config (opsctl open `alertmanager`, then go to `Status`), section `route:`.

* are sent to opsgenie:
  * all `severity=page` alerts
* are sent to slack team-specific channels:
  * `severity=page` or `severity=notify`
  * `team` defines which channel to route to.

#### Opsgenie routing

Opsgenie routing is defined in the `Teams` section of the Opsgenie application.

Opsgenie route alerts based on the `team` label.

### Inhibitions

The `cancel_if_*` labels are used to inhibit alerts, they are defined in [Alertmanager's config](https://github.com/giantswarm/observability-operator/blob/main/helm/observability-operator/files/alertmanager/alertmanager.yaml.helm-template#L325).

The base principle is: if an alert is currently firing with a `source_matcher` label, then all alerts that have a `target_matcher` label are inhibited (or muted).

To make inhibitions easier to read, let's try to follow this naming convention inhibition-related labels:
* `inhibit_[something]` for `source` matchers
* `cancel_if_[something]` for `target` matchers

Official documentation for inhibit rules can be found here: https://www.prometheus.io/docs/alerting/latest/configuration/#inhibit_rule

### Recording rules

The recording rules are located in `helm/prometheus-rules/templates/<area>/<team>/recording-rules` in the specific area/team to which they belong.

### Mixins management

#### kubernetes-mixins

To Update `kubernetes-mixins` recording rules:

* Follow the instructions in [giantswarm-kubernetes-mixin](https://github.com/giantswarm/giantswarm-kubernetes-mixin)
* Run `./scripts/sync-kube-mixin.sh (?my-fancy-branch-or-tag)` to updated the `helm/prometheus-rules/templates/shared/recording-rules/kubernetes-mixins.rules.yml` folder.
* make sure to update [grafana dashboards](https://github.com/giantswarm/dashboards/tree/master/helm/dashboards/dashboards/mixin)

#### mimir-mixins

To update `mimir-mixins` recording rules:

* Run `./mimir/update.sh`
* make sure to update [grafana dashboards](https://github.com/giantswarm/dashboards)

#### loki-mixins

To update `loki-mixins` recording rules:

* Run `./loki/update.sh`
* make sure to update [grafana dashboards](https://github.com/giantswarm/dashboards)

#### tempo-mixins

To update `tempo-mixins` alerting rules:

* Run `./tempo/update.sh`

## Testing

You can run all tests by running `make test`.

There are 4 different types tests implemented:

- [Prometheus rules unit tests](#prometheus-rules-unit-tests)
- [Alertmanager inhibition dependency check](#alertmanager-inhibition-dependency-check)
- [Runbook check](#runbook-check)
- [Prometheus Linter](#prometheus-linter)
---

### Prometheus rules unit tests

By creating unit tests for Alerting rules it's possible to get early feedback about possible misbehavior in alerting rules.
Unit tests are executed via `promtool` (part of `prometheus`).

By running `make test-rules` in your local environment, all required binaries will be downloaded and tests will be executed.

There are 2 kinds of tests on rules:
- syntax check (promtool check) - run on all files that can be generated from helm, nothing specific to do
- unit tests (promtool test) - you have to write some unit tests, or add your rules files to the `promtool_ignore` file.

#### Writing new Alerting rules unit tests

1. remove the rules file you would like to test from `test/conf/promtool_ignore`
1. create a new test file in [unit testing rules] format either globally in `test/tests/providers/global/` or provider-specific in `test/tests/providers/<provider>/`
1. by running `make test-rules` you can validate your testing rules.
   Output should look like the follows:

   ```
   [...]
   ###  Testing platform/atlas/alerting-rules/prometheus-operator.rules.yml
   ###    promtool check rules /home/marie/github-repo/prometheus-rules/test/hack/output/generated/capi/capa/platform/atlas/alerting-rules/prometheus-operator.rules.yml
   ###    Skipping platform/atlas/alerting-rules/prometheus-operator.rules.yml: listed in test/conf/promtool_ignore
   ###  Testing platform/atlas/alerting-rules/prometheus.rules.yml
   ###    promtool check rules /home/marie/github-repo/prometheus-rules/test/hack/output/generated/capi/capa/platform/atlas/alerting-rules/prometheus.rules.yml
   ###    promtool test rules prometheus.rules.test.yml - capi/capa
   [...]
   09:06:29 promtool: end (Elapsed time: 1s)
   Congratulations!  Prometheus rules have been promtool checked and tested
   ```

#### Test syntax

When writing unit tests, the first thing to do is to "feed" the testing tool with input series. Unfortunately, the official documentation does not give a lot of information about the tests syntax, especially for the `input_series`.

For each `input_series`, one has to provide a prometheus timeseries as well as its values over time :

```
[...]
tests:
  - interval: 1m
    input_series:
      - series: '<prometheus_timeseries>'
        values: "_x20 1+0x20 0+0x20"
      - series: '<prometheus_timeseries>'
        values: "0+600x40 24000+400x40"
[...]
```

Let's breakdown the above example:
* For the first input series, the prometheus timeseries returns an `empty query result` for 20 minutes (20*interval), then it is returning the value `1` for 20 minutes. Finally, it is returning the value `0` for 20 minutes.
This is a good example of an input series for testing an `up` query.
* The second series introduce a timeseries which first returns a `0` value and which adds `600` every minutes (=interval) for 40 minutes. After 40 minutes it has reached a value of `24000` (600x40) and goes on by adding `400` every minutes for 40 more minutes.
This is a good example of an input series for testing a `range` query.

#### Test templating

In order to reduce the need for provider-specific test files, you can use `$provider` in your test file and our tooling will replace it with the provider name.

#### Test exceptions

* Rule files that can't be tested are listed in `test/conf/promtool_ignore`.
* Rule files that can't be tested with a specific provider are listed in `test/conf/promtool_ignore_<provider>`.

#### Limitation

* The current implementation only renders rules for different providers via the helm value `managementCluster.provider.kind`.

#### A word on the testing logic

Here is a simplistic pseudocode view of the generate&test loop:
```
for each provider from test/conf/providers:
  for each file in test/hack/output/helm-chart/<provider>/prometheus-rules/templates/<area>/<team>/alerting-rules:
    copy the test rules file in test/hack/output/generated/<provider>/<area>/<team>/alerting-rules
    generate the rule using helm template in the same directory test/hack/output/generated/<provider>/<area>/<team>/alerting-rules
    if generation fails:
      we will try with next provider
    else:
      check rules syntax
      keep track that this file's syntax has been tested

    if no ignore on the file:
      run unit tests

Show a summary of encountered errors
Show success
```

#### Hints & tips

##### Run selected tests

You can filter which rules files you will test with a regular expression:
```
make test-rules test_filter=grafana.management-cluster.rules.yml
make test-rules test_filter=grafana
make test-rules test_filter=gr.*na
```

##### Filter rules type

You can select which type of rules you want to test, by default all rules are tested:

```
make test-rules rules_type=prometheus
make test-rules rules_type=loki
```

#### Test "no data" case

* It can be nice to test what happens when serie does not exist.
* For instance, You can have your first 60 iterations with no data like this: `_x60`

#### Useful links

* [unit testing rules](https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/)

## Linting

### Alertmanager inhibition dependency check

In order for Alertmanager inhibition to work we need 3 elements:
  - an Alerting rule with some source labels
  - an Inhibition definition mapping source labels to target labels in the alertmanager config file
  - an Alert rule with some target labels

An alert having a target label will be inhibited whenever the condition specified in the target label's name is fulfilled. This is why target labels' names are most of the time prefixed by "cancel_if_" (e.g "cancel_if_outside_working_hours").

An alert with a source label will define the conditions under which the target label is effective. For example, if an alert with the "outside_working_hours" label were to fire, all other alerts having the corresponding target label, i.e "cancel_if_outside_working_hours" would be inhibited.

This is possible thanks to the alertmanager config file stored in the [observability-operator](https://github.com/giantswarm/observability-operator/blob/main/helm/observability-operator/files/alertmanager/alertmanager.yaml.helm-template) which defines the target/source labels coupling.

This is what we call the inhibition dependency chain.

One can check whether inhibition labels (mostly "cancel_if_" prefixed ones) are well defined and triggered by a corresponding label in the alerting rules by running the `make test-inhibitions` command at the projet's root directory.

This command will output the list of missing labels. Each of them will need to be defined in either the alerting rules or the alertmanager config file depending on its nature : either an inhibition label or its source label.
If there is no labels outputed, this means tests passed and did not find missing inhibition labels.

![inhibition-graph](assets/inhibition-graph.png)

The inhibition labels checking script is also run automatically at PR's creation and will block merging when it fails.

#### Limitations (might happen)

- Inhibition checking script does not trigger at PR's creation : stuck in `pending` state. Must push empty commit to trigger it
- When ran for the first time in a PR (after empty commit) usually fails to retrieve the alertmanager config file's data and thus fires error stating that all labels are missing.
- Must manually re-run the action for it to pass

### Runbook check

You can run `make test-runbooks` to check if linked runbooks are valid.

This check is not part of the global `make test` command until we fix all missing / wrong runbooks.

### Prometheus Linter

[pint](https://cloudflare.github.io/pint/) performs static analysis on Prometheus rules.

```bash
# Run basic checks
make pint

# Test specific team's rules
make pint PINT_TEAM_FILTER=myteam

# Run extended checks
make pint-all
```
