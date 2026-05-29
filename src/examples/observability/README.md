# Observabilidad

Prácticas Terraform para observabilidad en Google Cloud: monitoreo, alertas, logs, métricas, trazas y SLOs.

| Práctica | Descripción |
|---|---|
| [Alerting in GCP](./alerting-in-gcp/README.md) | App Engine + alert policy de Cloud Monitoring (latencia p99) |
| [Service Monitoring](./service-monitoring/README.md) | App Engine + SLO de disponibilidad y alerta por burn rate del error budget |
| [Log Analytics](./log-analytics/README.md) | GKE + log bucket con Log Analytics, dataset enlazado en BigQuery y log sink |
| [Cloud Trace](./cloud-trace/README.md) | Cluster GKE con scopes para Cloud Trace y app demo con OpenTelemetry |
| [Ops Agent Monitoring](./ops-agent-monitoring/README.md) | VM con Apache + Ops Agent vía startup script, canal de notificación y alerting opcional |
| [Monitoring Applications in GCP](./monitoring-apps-in-gcp/README.md) | Monitoreo de aplicaciones desplegadas en Google Cloud |

## Uso rápido

```bash
cd <practica>
terraform init
terraform plan -var="project_id=<PROJECT_ID>"
terraform apply -var="project_id=<PROJECT_ID>"
```

## Recomendaciones

- Revisar el README de cada práctica: algunas requieren pasos manuales (desplegar la app demo, habilitar APIs).
- Usar `terraform destroy` al terminar para evitar costos innecesarios.
