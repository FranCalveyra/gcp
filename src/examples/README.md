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
- `storage/buckets/`
  - Ejemplo Terraform basado en el lab **Cloud Storage** (versioning, lifecycle y objetos de muestra).
- `storage/cloud-sql/`
  - Ejemplo Terraform basado en el lab **Implementing Cloud SQL** (Cloud SQL, peering privado y VMs de demo).
- `virtual-machines/create-vm/`
  - Ejemplo Terraform para crear una VM en Compute Engine.

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
