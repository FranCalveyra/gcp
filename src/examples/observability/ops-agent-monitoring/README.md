# Ops Agent Monitoring — Monitoreo de Compute Engine

Práctica Terraform basada en el lab [Monitoring a Compute Engine by using Ops Agent](https://www.skills.google/course_templates/864/labs/621027).

Crea una VM con Apache y el Ops Agent preconfigurado via startup script. Opcionalmente crea un canal de notificación y un alerting policy para tráfico Apache.

## Recursos creados

| Recurso | Nombre |
|---|---|
| VM Compute Engine | `quickstart-vm` (e2-small, Debian) |
| Firewall | `allow-http-ops-agent` (tcp:80) |
| Notification channel | email (opcional) |
| Alert policy | Apache traffic > threshold (opcional) |

## Uso rápido

```bash
terraform init

# Sin alertas
terraform apply \
  -var="project_id=TU_PROJECT_ID"

# Con alertas
terraform apply \
  -var="project_id=TU_PROJECT_ID" \
  -var="alert_notification_email=tu@email.com"
```

## Variables requeridas

| Variable | Descripción |
|---|---|
| `project_id` | ID del proyecto GCP |

## Generar tráfico para ver métricas

Una vez desplegado, conectate a la VM y generá tráfico:

```bash
# SSH a la VM
gcloud compute ssh --zone us-east4-c quickstart-vm --project TU_PROJECT_ID

# Generar requests durante 2 minutos
timeout 120 bash -c -- 'while true; do curl localhost; sleep $((RANDOM % 4)) ; done'
```

Luego ir a **Cloud Monitoring → Dashboards → Apache Overview** para ver las métricas exportadas por el Ops Agent.

## Notas

- El startup script instala Apache, PHP y el Ops Agent, y escribe la config de pipelines para Apache automáticamente.
- El scope `cloud-platform` en la service account incluye `monitoring.write` y `logging.write`, necesarios para que el Ops Agent exporte datos.
- La alerta y el canal de notificación son opcionales — se crean solo si se pasa `alert_notification_email`.
- No se puede validar runtime real sin un proyecto activo con billing habilitado.
