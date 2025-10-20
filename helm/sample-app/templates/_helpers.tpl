{{- define "sample-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "sample-app.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "sample-app.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
