# Cloud Trace — Análisis de latencia de aplicaciones

Práctica Terraform basada en el lab [View application latency with Cloud Trace](https://www.skills.google/course_templates/864/labs/621043).

Crea un cluster GKE con los scopes necesarios para exportar traces a Cloud Trace. La app demo (Python + OpenTelemetry) se despliega manualmente con el script del repositorio oficial de Google.

## Recursos creados

| Recurso | Nombre |
|---|---|
| Cluster GKE | `cloud-trace-demo` |
| Node pool | `cloud-trace-demo-nodes` (e2-medium × 3) |

> Cloud Trace no requiere recursos Terraform — los spans llegan automáticamente desde la app via OpenTelemetry con el scope `cloud-platform`.

## Uso rápido

```bash
terraform init

terraform apply \
  -var="project_id=TU_PROJECT_ID"
```

## Deployar la app demo

Una vez que el cluster esté activo:

```bash
# Configurar kubectl
gcloud container clusters get-credentials cloud-trace-demo \
  --zone us-central1-c \
  --project TU_PROJECT_ID

# Verificar nodos
kubectl get nodes

# Clonar y deployar la app
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
cd python-docs-samples/trace/cloud-trace-demo-app-opentelemetry && ./setup.sh
```

## Generar tráfico para ver traces

```bash
curl $(kubectl get svc \
  -o=jsonpath='{.items[?(@.metadata.name=="cloud-trace-demo-a")].status.loadBalancer.ingress[0].ip}')
```

Repetir varias veces, luego ir a **Cloud Trace → Explorador de traces** en la consola para ver los spans distribuidos entre los tres servicios (a→b→c).

## Variables requeridas

| Variable | Descripción |
|---|---|
| `project_id` | ID del proyecto GCP |

## Notas

- El cluster usa `oauth_scopes = ["cloud-platform"]` que incluye `cloudtrace.append` — necesario para que los pods exporten spans sin service account adicional.
- No se puede validar runtime real sin un proyecto activo con billing habilitado y la app desplegada.
