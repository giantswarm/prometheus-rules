[![CircleCI](https://circleci.com/gh/giantswarm/prometheus-rules.svg?style=shield)](https://circleci.com/gh/giantswarm/prometheus-rules)

# Prometheus rules chart

**What is this app?**

This repository contains Giant Swarm alerting and recording rules




### Mixin

To Update `kubernetes-mixin` recording rules:

* Follow the instructions in [giantswarm-kubernetes-mixin](https://github.com/giantswarm/giantswarm-kubernetes-mixin)
* Run `./scripts/sync-kube-mixin.sh (?my-fancy-branch-or-tag)` to updated the `helm/prometheus-rules/templates/recording-rules/kubernetes-mixins.rules.yml` folder.
* make sure to update [grafana dashboards](https://github.com/giantswarm/dashboards/tree/master/helm/dashboards/dashboards/mixin)