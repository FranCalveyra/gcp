# Terraform Example: Configuring VPC

Este ejemplo implementa una versión Terraform del lab **Configuring VPC Firewalls**.

## Qué crea

- API necesaria: `compute.googleapis.com`.
- VPC auto mode `mynetwork`.
- 2 VMs de prueba:
  - `mynet-vm-1`
  - `mynet-vm-2`
- Reglas de firewall equivalentes al escenario final del lab:
  - SSH desde una IP/CIDR puntual hacia instancias taggeadas con `lab-ssh`
  - ICMP interno permitido dentro de `10.128.0.0/9`
  - deny ICMP ingress con prioridad `2000`
  - deny ICMP egress con prioridad `10000`

## Uso rápido

1. Inicializá:

```bash
terraform init
```

2. Definí `terraform.tfvars`:

```hcl
project_id      = "tu-project-id"
region          = "us-central1"
zone_1          = "us-central1-a"
zone_2          = "us-central1-b"
ssh_source_cidr = "203.0.113.10/32"
```

3. Plan y apply:

```bash
terraform plan
terraform apply
```

## Notas

- Para replicar el comportamiento del lab, usá en `ssh_source_cidr` la IP pública de tu Cloud Shell en formato CIDR `/32`.
- Este ejemplo modela el estado final útil del lab. La inspección manual de la red `default` y su eliminación quedan fuera de Terraform a propósito.
