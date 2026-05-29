# Monitoring Applications in Google Cloud

Práctica Terraform basada en el [lab GSP659](https://www.skills.google/focuses/19105?parent=catalog).

Provisiona la infraestructura de observabilidad para una app App Engine: uptime checks, alertas de latencia y canal de notificaciones por email.

> **Nota**: el código de la aplicación Flask se despliega con `gcloud app deploy`, no con Terraform. Este ejemplo cubre exclusivamente la capa de monitoreo.

## Recursos creados

| Recurso | Descripción |
|---|---|
| `google_app_engine_application` | Aplicación App Engine en el proyecto |
| `google_monitoring_uptime_check_config` | Uptime check HTTPS cada 60s |
| `google_monitoring_alert_policy` (latencia) | Alerta cuando p99 > umbral configurado |
| `google_monitoring_alert_policy` (uptime) | Alerta ante falla del uptime check |
| `google_monitoring_notification_channel` | Canal de email (opcional) |

## Uso

```bash
terraform init
terraform plan -var="project_id=<PROJECT_ID>" -var="uptime_check_host=<PROJECT_ID>.appspot.com"
terraform apply -var="project_id=<PROJECT_ID>" -var="uptime_check_host=<PROJECT_ID>.appspot.com"
```

Con notificaciones por email:

```bash
terraform apply \
  -var="project_id=<PROJECT_ID>" \
  -var="uptime_check_host=<PROJECT_ID>.appspot.com" \
  -var="notification_email=tu@email.com"
```

## Variables principales

| Variable | Requerida | Default | Descripción |
|---|---|---|---|
| `project_id` | ✅ | — | GCP project ID |
| `uptime_check_host` | ✅ | — | Host del uptime check |
| `app_engine_location_id` | — | `us-central` | Location de App Engine |
| `region` | — | `us-central1` | Region para recursos regionales |
| `notification_email` | — | `null` | Email para alertas |
| `latency_threshold_seconds` | — | `8` | Umbral p99 latencia (segundos) |
