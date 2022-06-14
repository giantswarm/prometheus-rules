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
helm.sh/chart: {{ include "chart" . | quote }}
giantswarm.io/service-type: {{ .Values.serviceType }}
{{- end -}}

{{- define "providerTeam" -}}
{{- if has .Values.managementCluster.provider.kind (list "kvm" "openstack" "vcd" "vsphere") -}}
rocket
{{- else -}}
phoenix
{{- end -}}
{{- end -}}

{{- define "workingHoursOnly" -}}
{{- if has .Values.managementCluster.provider.kind (list "openstack") -}}
"true"
{{- else -}}
"false"
{{- end -}}
{{- end -}}

{{- define "isCertExporterInstalled" -}}
{{- if has .Values.managementCluster.provider.kind (list "openstack" "vcd" "vsphere") -}}
false
{{- else -}}
true
{{- end -}}
{{- end -}}

{{- define "isClusterServiceInstalled" -}}
{{- if has .Values.managementCluster.provider.kind (list "openstack" "vcd" "vsphere") -}}
false
{{- else -}}
true
{{- end -}}
{{- end -}}

{{- define "isVaultBeingMonitored" -}}
{{- if has .Values.managementCluster.provider.kind (list "openstack" "vcd" "vsphere") -}}
false
{{- else -}}
true
{{- end -}}
{{- end -}}

{{- define "isBastionBeingMonitored" -}}
{{- if has .Values.managementCluster.provider.kind (list "openstack" "vcd" "vsphere") -}}
false
{{- else -}}
true
{{- end -}}
{{- end -}}
