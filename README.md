[![CircleCI](https://circleci.com/gh/giantswarm/prometheus-rules.svg?style=shield)](https://circleci.com/gh/giantswarm/prometheus-rules)

# Prometheus rules chart

**What is this app?**

This repository contains Giant Swarm alerting and recording rules




### Mixin

To Update `kubernetes-mixin` recording rules:

* Check for a suitable release in the [upstream](https://github.com/kubernetes-monitoring/kubernetes-mixin#releases)

* Clone the repo (use the release branch) and follow those [instructions](https://github.com/kubernetes-monitoring/kubernetes-mixin#generate-config-files)

* Copy the content of `prometheus_rules.yaml` and overwrite `helm/prometheus-rules/recording-rules/kubernetes-mixins.rules.yml` (Make sure to overwrite the groups and not the whole file)

* Adjust labels

```
(cluster)                  =>  (cluster_id)

job="apiserver"            =>  component="apiserver"

job="cadvisor"             =>  app="cadvisor"

job="kube-state-metrics"   =>  app="kube-state-metrics"

job="kube-scheduler"       =>  app="kube-scheduler"

job="node-exporter"        =>  app="node-exporter"

job="kubelet"              =>  app="kubelet"
```

* make sure to update [grafana dashboards](https://github.com/giantswarm/dashboards/tree/master/helm/dashboards/dashboards/mixin)