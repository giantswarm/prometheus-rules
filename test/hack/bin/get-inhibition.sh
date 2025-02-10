#!/bin/bash

GIT_WORKDIR="$(git rev-parse --show-toplevel)"
REPO_VERSION="$(curl -s https://api.github.com/repos/giantswarm/observability-operator/releases/latest | ./test/hack/bin/yq -r .name)"

curl -s https://raw.githubusercontent.com/giantswarm/observability-operator/"$REPO_VERSION"/helm/observability-operator/files/alertmanager/alertmanager.yaml.helm-template > "$GIT_WORKDIR"/test/hack/checkLabels/alertmanager.yaml

# Deleting all lines from begining of the file to the concerned section to avoid issues with go templates
sed -i '/global:/,/inhibit_rules:/{/inhibit_rules/b a;/^.*/d; :a}' "$GIT_WORKDIR"/test/hack/checkLabels/alertmanager.yaml
