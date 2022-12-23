#!/usr/bin/env bash

sed -i "s/\[\[\ \.Version\ \]\]/2.1.1/g" helm/prometheus-rules/Chart.yaml
helm template helm/prometheus-rules --output-dir hack/output
sed -i "s/2\.1\.1/\[\[\ \.Version\ \]\]/g" helm/prometheus-rules/Chart.yaml
