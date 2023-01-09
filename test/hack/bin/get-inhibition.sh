#!/bin/bash

GIT_WORKDIR="$(git rev-parse --show-toplevel)"
REPO_VERSION="$(curl -s https://api.github.com/repos/giantswarm/prometheus-meta-operator/releases/latest | jq -r .name)"

curl https://raw.githubusercontent.com/giantswarm/prometheus-meta-operator/"$REPO_VERSION"/files/templates/alertmanager/alertmanager.yaml > "$GIT_WORKDIR"/test/hack/checkLabels/alertmanager.yaml

# Deleting all lines from begining of the file to the concerned section to avoid issues with go templates
sed -i '/global:/,/inhibit_rules:/{/inhibit_rules/b a;/^.*/d; :a}' "$GIT_WORKDIR"/test/hack/checkLabels/alertmanager.yaml
