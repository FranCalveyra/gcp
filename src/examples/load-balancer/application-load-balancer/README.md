# Terraform Example: Application Load Balancer with Autoscaling

Este ejemplo implementa una versión Terraform del lab **Application Load Balancer with Autoscaling**.

## Qué crea

- Firewall rule para health checks.
- Cloud Router + Cloud NAT en las regiones de backend.
- Instance template para servidores web.
- 2 Managed Instance Groups (uno en `us-central1` y otro en `europe-west1`).
- Autoscaler para cada MIG.
- Application Load Balancer HTTP global (`EXTERNAL_MANAGED`) con:
  - backend service
  - URL map
  - target HTTP proxy
  - forwarding rule IPv4
  - forwarding rule IPv6 opcional

## Uso rápido

1. Inicializá:

```bash
terraform init
```

2. Definí variables en `terraform.tfvars`:

```hcl
project_id     = "tu-project-id"
default_region = "us-central1"
network_name   = "default"
```

3. Plan y apply:

```bash
terraform plan
terraform apply
```

## Notas

- El lab original usa una imagen custom (`mywebserver`). Este ejemplo usa una imagen Debian por defecto + startup script.
- Si querés replicar más fielmente el lab, podés cambiar `instance_image` por tu imagen custom.
