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
application.giantswarm.io/team: {{ index .Chart.Annotations "application.giantswarm.io/team" | default "atlas" | quote }}
helm.sh/chart: {{ include "chart" . | quote }}
giantswarm.io/service-type: {{ .Values.serviceType }}
{{- end -}}

{{- define "providerTeam" -}}
{{- if has .Values.managementCluster.provider.kind (list "cloud-director" "vsphere") -}}
rocket
{{- else if has .Values.managementCluster.provider.kind (list "capa" "capz") -}}
{{- /* hydra alerts merged into phoenix business hours on-call */ -}}
phoenix
{{- else -}}
phoenix
{{- end -}}
{{- end -}}

{{- define "workingHoursOnly" -}}
{{- if eq .Values.managementCluster.pipeline "stable-testing" -}}
"true"
{{- else -}}
"false"
{{- end -}}
{{- end -}}

{{- define "isCertExporterInstalled" -}}
{{- if has .Values.managementCluster.provider.kind (list "cloud-director" "vsphere" "capa") -}}
false
{{- else -}}
true
{{- end -}}
{{- end -}}

{{- define "isClusterServiceInstalled" -}}
{{ not (eq .Values.managementCluster.provider.flavor "capi") }}
{{- end -}}

{{- define "isVaultBeingMonitored" -}}
{{ not (eq .Values.managementCluster.provider.flavor "capi") }}
{{- end -}}

{{- define "isBastionBeingMonitored" -}}
{{ not (eq .Values.managementCluster.provider.flavor "capi") }}
{{- end -}}

{{- define "namespaceNotGiantswarm" -}}
"(([^g]|g[^i]|gi[^a]|gia[^n]|gian[^t]|giant[^s]|giants[^w]|giantsw[^a]|giantswa[^r]|giantswar[^m])*)"
{{- end -}}
