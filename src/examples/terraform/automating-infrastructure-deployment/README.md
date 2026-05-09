# Práctica Terraform: Automating Infrastructure Deployment With Terraform

Este ejemplo replica el flujo central del lab de Google Skills para desplegar infraestructura básica con Terraform:

- VPC auto mode (`mynetwork`)
- Firewall para SSH/HTTP/RDP/ICMP
- Dos VM instances (`mynet-vm-1` y `mynet-vm-2`)

Lab original: [Automating the Deployment of Infrastructure Using Terraform](https://www.skills.google/focuses/19098?parent=catalog)

## Archivos

- `versions.tf`: versión de Terraform, provider y configuración base de `google`.
- `variables.tf`: variables de entrada para proyecto, red, zonas y VMs.
- `main.tf`: habilitación de API + recursos principales.
- `outputs.tf`: datos útiles post-deploy.

## Uso rápido

1. Crear un archivo `terraform.tfvars` (o pasar variables por CLI):

```hcl
project_id = "tu-proyecto"
region     = "us-central1"
zones      = ["us-central1-a", "us-central1-b"]
```

2. Ejecutar:

```bash
terraform init
terraform fmt
terraform plan
terraform apply
```

## Buenas prácticas aplicadas

- Variables para valores configurables (`project_id`, `region`, `zones`, nombres).
- `locals` para definir estructura de VMs.
- `outputs` útiles para inspección y debugging.
- API de Compute habilitada con `disable_on_destroy = false`.
- Sin secretos hardcodeados.
