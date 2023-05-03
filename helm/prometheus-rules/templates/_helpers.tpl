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
app.giantswarm.io/branch: {{ .Values.project.branch | replace "#" "-" | replace "/" "-" | replace "." "-" | trunc 63 | trimSuffix "-" | quote }}
app.giantswarm.io/commit: {{ .Values.project.commit | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
application.giantswarm.io/team: {{ index .Chart.Annotations "application.giantswarm.io/team" | default "atlas" | quote }}
helm.sh/chart: {{ include "chart" . | quote }}
giantswarm.io/service-type: {{ .Values.serviceType }}
{{- end -}}

{{- define "providerTeam" -}}
{{- if has .Values.managementCluster.provider.kind (list "kvm" "openstack" "cloud-director" "vsphere") -}}
rocket
{{- else if has .Values.managementCluster.provider.kind (list "gcp" "capa") -}}
{{- /* hydra alerts merged into phoenix business hours on-call */ -}}
phoenix
{{- else if eq .Values.managementCluster.provider.kind "capz" -}}
clippy
{{- else -}}
phoenix
{{- end -}}
{{- end -}}

{{- define "workingHoursOnly" -}}
{{- if has .Values.managementCluster.provider.kind (list "openstack" "capz") -}}
"true"
{{- else -}}
"false"
{{- end -}}
{{- end -}}

{{- define "isCertExporterInstalled" -}}
{{- if has .Values.managementCluster.provider.kind (list "openstack" "cloud-director" "vsphere" "capa") -}}
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
