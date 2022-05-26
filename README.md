[![CircleCI](https://circleci.com/gh/giantswarm/prometheus-rules.svg?style=shield)](https://circleci.com/gh/giantswarm/prometheus-rules)

# Prometheus rules chart

**What is this app?**

This repository contains Giant Swarm alerting and recording rules




### Mixin

To Update `kubernetes-mixin` recording rules:

* Follow instructions in [giantswarm-kubernetes-mixin](https://github.com/giantswarm/giantswarm-kubernetes-mixin)

* !YAML! Copy the content of `file/prometheus_rules/` and overwrite `helm/prometheus-rules/recording-rules/kubernetes-mixins.rules.yml` (Make sure to overwrite the groups and not the whole file)

* make sure to update [grafana dashboards](https://github.com/giantswarm/dashboards/tree/master/helm/dashboards/dashboards/mixin)