{{/*
Expand the name of the chart.
*/}}
{{- define "mychart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mychart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mychart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mychart.labels" -}}
helm.sh/chart: {{ include "mychart.chart" . }}
{{ include "mychart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mychart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mychart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Dataset PV Name
*/}}
{{- define "mychart.datasetPV" -}}
{{- include "mychart.fullname" . | trunc 55}}-dataset
{{- end }}

{{/*
Functions PV Name
*/}}
{{- define "mychart.functionsPV" -}}
{{- include "mychart.fullname" . | trunc 53}}-functions
{{- end }}

{{/*
Result PV Name
*/}}
{{- define "mychart.resultPV" -}}
{{- include "mychart.fullname" . | trunc 55}}-results
{{- end }}

{{/*
cluster-resources CM Name
*/}}
{{- define "mychart.clusterResourcesCM" -}}
{{- include "mychart.fullname" . | trunc 45}}-cluster-resources
{{- end }}

{{/*
k8s-params CM Name
*/}}
{{- define "mychart.kubernetesParamsCM" -}}
{{- include "mychart.fullname" . | trunc 52}}-k8s-params
{{- end }}

{{/*
ServiceCell Image
*/}}
{{- define "mychart.serviceCell.image" -}}  
{{- printf "%s:%s" .Values.benchmark.service_cell.template.image.name .Values.benchmark.service_cell.template.image.version }}
{{- end }}

{{/*
ServiceCell FQDN suffic
*/}}
{{- define "mychart.serviceCell.fqdnSuffix" -}}  
{{- printf ".%s.svc.%s.local%s" .Values.benchmark.namespace .Values.benchmark.cluster_domain .Values.benchmark.service_cell.api_path }}
{{- end }}

{{/*
csv-runner-params CM Name
*/}}
{{- define "mychart.csvRunnerParamsCM" -}}
{{- include "mychart.fullname" . | trunc 45}}-csv-runner-params
{{- end }}


{{/*
workmodel-params CM Name
*/}}
{{- define "mychart.workmodelParamsCM" -}}
{{- include "mychart.fullname" . | trunc 46}}-workmodel-params
{{- end }}
