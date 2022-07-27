[![CircleCI](https://circleci.com/gh/giantswarm/prometheus-rules.svg?style=shield)](https://circleci.com/gh/giantswarm/prometheus-rules)

# Prometheus rules chart

**What is this app?**

This repository contains Giant Swarm alerting and recording rules


### Testing

By creating unit tests for Alerting rules it's possible to get early feedback about possible misbehavior in alerting rules.
Unit tests are executed via `promtool` (part of `prometheus`).

By running `make test` in your local environment, all required binaries will be downloaded and tests will be executed.

#### Writing new tests

1. remove the rules file you would like to test from `test/conf/promtool_ignore`
1. create a new test file in [unit testing rules] format either globally in `test/conf/providers/global/` or provider-specific in `test/tests/providers/<provider>/`
1. by running `make test` you can validate the your testing rules.
   Output should look like the follows:

   ```
   [...]
   ### Skipping templates/alerting-rules/calico.rules.yml
   ### Testing templates/alerting-rules/capi.rules.yml
   ###    Provider: openstack
   ###    extracting /home/marioc/go/src/github.com/giantswarm/prometheus-rules/test/providers/openstack/capi.rules.yml
   ###    promtool check rules /home/marioc/go/src/github.com/giantswarm/prometheus-rules/test/tests/providers/openstack/capi.rules.yml
   ###    promtool test rules capi.rules.test.yml
   ### Testing templates/alerting-rules/capo.rules.yml
   ###    Provider: openstack
   ###    extracting /home/marioc/go/src/github.com/giantswarm/prometheus-rules/test/providers/openstack/capo.rules.yml
   ###    promtool check rules /home/marioc/go/src/github.com/giantswarm/prometheus-rules/test/tests/providers/openstack/capo.rules.yml
   ###    promtool test rules capo.rules.test.yml
   ### Skipping templates/alerting-rules/cert-manager.rules.yml
   ### Skipping templates/alerting-rules/certificate.all.rules.yml
   [...]
   09:06:29 promtool: end (Elapsed time: 1s)
   Congratulations!  All prometheus rules have been promtool checked.
   ```

#### Test exceptions

* Rule files that can't be tested are listed in `test/conf/promtool_ignore`.
* Rule files that can't be tested with a specific provider are listed in `test/conf/promtool_ignore_<provider>`.

#### Limitation

The current implementation only renders alerting rules for different providers via the helm value `managementCluster.provider.kind`.
Any other decision in the current helm chart is ignored for now (e.g. `helm/prometheus-rules/templates/alerting-rules/alertmanager-dashboard.rules.yml`)


[unit testing rules]: https://prometheus.io/docs/prometheus/latest/configuration/unit_testing_rules/

### Alerting

The alerting rules are located in `helm/prometheus-rules/templates/alerting-rules`

#### How alerts are structured

At Giant Swarm we follow some best practices to organize our alerts:

here is an example:

```yaml
  groups:
  - name: app
    rules:
    - alert: ManagementClusterAppFailedAtlas
        annotations:
            description: '{{`Management Cluster App {{ $labels.name }}, version {{ $labels.version }} is {{if $labels.status }} in {{ $labels.status }} state. {{else}} not installed. {{end}}`}}'
            opsrecipe: app-failed/
        expr: app_operator_app_info{status!~"(?i:(deployed|cordoned))", catalog=~"control-plane-.*",team="atlas"}
        for: 30m
        labels:
            area: managedservices
            cancel_if_cluster_status_creating: "true"
            cancel_if_cluster_status_deleting: "true"
            cancel_if_cluster_status_updating: "true"
            cancel_if_outside_working_hours: "true"
            severity: page
            sig: none
            team: atlas
```

Any Alert includes:

* A description
* An [opsrecipe](https://intranet.giantswarm.io/docs/support-and-ops/ops-recipes/) 
* Mandatory labels:
   - `area`
   - `team`
   - `severity`

* Optional labels:
   - `sig`
   - `cancel_if_.*`


#### Routing

Alertmanager does the routing based on the labels menitoned above.
You can see the routing rules in alertmanager's config (opsctl open `alertmanager`, then go to `Status`), section `route:`.

* are sent to opsgenie:
  * all `severity=page` alerts
* are sent to slack team-specific channels:
  * `severity=page` or `severity=notify`
  * `team` defines which channel to route to.


##### Opsgenie routing

Opsgenie routing is defined in the `Teams` section of the Opsgenie application.

Opsgenie route alerts based on the `team` label.


#### Inhibitions

The "cancel_if" labels are used for inhibitions.
You can see the inhibition rules in alertmanager's config (opsctl open `alertmanager`, then go to `Status`), section `inhibit_rules:`.

Official documentation for inhibit rules can be found here: https://www.prometheus.io/docs/alerting/latest/configuration/#inhibit_rule

The base principle of an `source_matcher` inhibit_rule is:
> if an alert is currently firing with a `source_matcher` label, then inhibit all alerts that hate a `target_matcher` label



### Recording rules

The recording rules are located `helm/prometheus-rules/templates/recording-rules`


### Mixin

To Update `kubernetes-mixin` recording rules:

* Follow the instructions in [giantswarm-kubernetes-mixin](https://github.com/giantswarm/giantswarm-kubernetes-mixin)
* Run `./scripts/sync-kube-mixin.sh (?my-fancy-branch-or-tag)` to updated the `helm/prometheus-rules/templates/recording-rules/kubernetes-mixins.rules.yml` folder.
* make sure to update [grafana dashboards](https://github.com/giantswarm/dashboards/tree/master/helm/dashboards/dashboards/mixin)
