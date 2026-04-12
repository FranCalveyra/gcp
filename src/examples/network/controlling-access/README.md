# Terraform Example: VPC Controlling Access

Este ejemplo implementa una versión Terraform del lab **VPC Networks - Controlling Access**.

## Qué crea

- APIs necesarias: `compute.googleapis.com`, `iam.googleapis.com`.
- 2 web servers en la red `default`:
  - `blue` con tag `web-server`
  - `green` sin tag
- Instalación automática de `nginx-light` y página diferenciada en cada servidor.
- Firewall rule `allow-http-web-server` para exponer `tcp:80` e `icmp` solo a instancias con el tag `web-server`.
- VM `test-vm` para validar conectividad.
- Service account `network-admin` adjunta a `test-vm`, con:
  - `roles/compute.networkAdmin`
  - `roles/compute.securityAdmin` opcional según variable

## Uso rápido

1. Inicializá:

```bash
terraform init
```

2. Definí `terraform.tfvars`:

```hcl
project_id           = "tu-project-id"
region               = "us-central1"
zone                 = "us-central1-a"
network_name         = "default"
subnetwork_name      = "default"
grant_security_admin = true
```

3. Plan y apply:

```bash
terraform plan
terraform apply
```

## Notas

- Este ejemplo asume que existe la red `default` y que conserva la regla `default-allow-internal`, igual que en el lab original.
- Para reproducir la progresión del lab, podés aplicar primero con `grant_security_admin = false` y verificar que desde `test-vm` se pueden listar firewall rules pero no borrarlas; después cambiás a `true` y volvés a aplicar.
- El lab original usa una clave JSON subida manualmente a la VM. Acá se evita esa práctica y se adjunta la service account directamente a `test-vm`.
