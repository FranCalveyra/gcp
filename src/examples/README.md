# Prácticas de infraestructura (`src/examples`)

En esta carpeta vas a encontrar prácticas de infraestructura pensadas para acompañar los labs del curso, con foco en Terraform y buenas prácticas (variables reutilizables, `outputs`, estructura clara por caso de uso, etc.).

## Qué incluye hoy

- `cloud-run/cloud-run-functions-qwik-start/`
  - Ejemplo Terraform basado en el lab **Cloud Run Functions Qwik Start**.
  - Cubre APIs, Cloud Run Functions (gen2), triggers y recursos asociados.
- `cloud-run/pubsub-with-cloud-run/`
  - Ejemplo Terraform basado en el lab **Cloud Pub Sub With Cloud Run**.
  - Cubre servicios Cloud Run, topic/subscription de Pub/Sub, service account e IAM.
- `iam/configuring-iam-with-gcloud/`
  - Ejemplo Terraform basado en el lab **Configuring IAM Permissions with gcloud**.
  - Cubre rol custom, bindings IAM para un segundo usuario, service account y una VM con identidad adjunta.
- `iam/exploring-iam/`
  - Ejemplo Terraform basado en el lab **Exploring IAM**.
  - Cubre bucket de prueba, grants IAM acotados, service account y VM `demoiam`.
- `load-balancer/create-nlb/`
  - Ejemplo Terraform para crear un Network Load Balancer.
- `load-balancer/application-load-balancer/`
  - Ejemplo Terraform para un Application Load Balancer con autoscaling (MIG + autoscaler).
- `network/configuring-vpc/`
  - Ejemplo Terraform basado en el lab **Configuring VPC Firewalls**.
  - Cubre VPC auto mode, VMs de demo y reglas de firewall ingress/egress.
- `network/controlling-access/`
  - Ejemplo Terraform basado en el lab **VPC Networks - Controlling Access**.
  - Cubre VMs web, firewall taggeado y service account para probar permisos de red.
- `network/multiple-vpc/`
  - Ejemplo Terraform basado en el lab **Multiple VPC Networks**.
  - Cubre VPCs custom/auto mode, VMs y una appliance con múltiples interfaces de red.
- `network/vpc-flow-logs/`
  - Ejemplo Terraform basado en el lab **Analyzing Network Traffic with VPC Flow Logs**.
  - Cubre VPC custom con Flow Logs, firewall, VM Apache, log sink a BigQuery y permisos IAM del sink.
- `network/build-secure-network-challenge/`
  - Ejemplo Terraform basado en el lab **Build a Secure Network - Challenge**.
  - Cubre bastion sin IP pública vía IAP, `juice-shop` con HTTP, y reglas de firewall restrictivas por tags/subred.
- `storage/buckets/`
  - Ejemplo Terraform basado en el lab **Cloud Storage** (versioning, lifecycle y objetos de muestra).
- `storage/cloud-sql/`
  - Ejemplo Terraform basado en el lab **Implementing Cloud SQL** (Cloud SQL, peering privado y VMs de demo).
- `terraform/automating-infrastructure-deployment/`
  - Ejemplo Terraform basado en el lab **Automating the Deployment of Infrastructure Using Terraform**.
  - Cubre VPC auto mode, firewall ICMP/SSH/HTTP/RDP y dos VM instances en zonas distintas.
- `virtual-machines/create-vm/`
  - Ejemplo Terraform para crear una VM en Compute Engine.
- `terraform/build-iac-with-terraform/`
  - Ejemplo Terraform basado en el lab **Build IaC with Terraform**.
  - Cubre import de Compute Engine, bucket para estado remoto, VPC con módulo del registry y firewall.
- `storage/cloud-storage/bucket/`
  - Ejemplo del **SDK de Cloud Storage en Python** (`google-cloud-storage`): funciones `upload_blob`/`download_blob`. No es Terraform.
- `observability/ops-agent-monitoring/`
  - Ejemplo Terraform basado en el lab **Monitoring a Compute Engine by using Ops Agent**.
  - Cubre VM con Apache + Ops Agent preconfigurado vía startup script, firewall HTTP, canal de notificación y alerting policy opcionales.
- `observability/cloud-trace/`
  - Ejemplo Terraform basado en el lab **View application latency with Cloud Trace**.
  - Cubre cluster GKE con scopes para Cloud Trace; la app demo Python + OpenTelemetry se despliega con el script oficial.
- `observability/alerting-in-gcp/`
  - Ejemplo Terraform basado en el lab **Alerting in Google Cloud**.
  - Cubre App Engine application y un alert policy de Cloud Monitoring (latencia 99th percentile) con notification channel opcional.
- `observability/service-monitoring/`
  - Ejemplo Terraform basado en el lab **Service Monitoring**.
  - Cubre App Engine application, un SLO de disponibilidad (rolling window) para el servicio `default` y un alert policy por burn rate del error budget (notification channel opcional).
- `observability/log-analytics/`
  - Ejemplo Terraform basado en el lab **Log Analytics on Google Cloud (GSP1088)**.
  - Cubre GKE, log bucket con Log Analytics habilitado, linked dataset en BigQuery y log sink para enrutar logs `k8s_container`.
- `observability/monitoring-apps-in-gcp/`
  - Ejemplo Terraform basado en el lab **Monitoring Applications in Google Cloud**.
- `cicd/devops-pipeline/`
  - Ejemplo Terraform basado en el lab **Building a DevOps Pipeline** (curso 41).
  - Cubre Cloud Build trigger + Artifact Registry conectado a GitHub.

## Cómo usar estas prácticas

1. Entrá a la carpeta del ejemplo que quieras.
2. Inicializá Terraform con `terraform init`.
3. Definí variables (por ejemplo en `terraform.tfvars`).
4. Revisá cambios con `terraform plan`.
5. Aplicá con `terraform apply`.

## Recomendaciones

- No hardcodear `project_id`, región o nombres sensibles: usá variables.
- Usar `terraform fmt` y, si podés, `terraform validate` antes de aplicar.
- Si estás probando en un proyecto temporal, al terminar corré `terraform destroy`.

## Carpeta remota en GitHub

- [github.com/FranCalveyra/gcp/src/examples/](https://github.com/FranCalveyra/gcp/tree/main/src/examples)
