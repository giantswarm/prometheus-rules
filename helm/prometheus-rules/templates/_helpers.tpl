{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "labels.common" -}}
app.kubernetes.io/name: {{ include "name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
application.giantswarm.io/team: {{ index .Chart.Annotations "io.giantswarm.application.team" | default "atlas" | quote }}
helm.sh/chart: {{ include "chart" . | quote }}
giantswarm.io/service-type: {{ .Values.serviceType }}
{{- if or (.Template.Name | hasSuffix "logs.yaml") (.Template.Name | hasSuffix "logs.yml")}}
application.giantswarm.io/prometheus-rule-kind: loki
{{- end }}
observability.giantswarm.io/tenant: giantswarm
{{- end -}}

{{- define "providerTeam" -}}
'{{`{{ if or (eq .Labels.provider "cloud-director") (eq .Labels.provider "vsphere") }}rocket{{ else }}phoenix{{ end }}`}}'
{{- end -}}

{{- define "workingHoursOnly" -}}
{{- if eq .Values.managementCluster.pipeline "stable-testing" -}}
"true"
{{- else -}}
"false"
{{- end -}}
{{- end -}}

{{- define "namespaceNotGiantswarm" -}}
"(([^g]|g[^i]|gi[^a]|gia[^n]|gian[^t]|giant[^s]|giants[^w]|giantsw[^a]|giantswa[^r]|giantswar[^m])*)"
{{- end -}}
