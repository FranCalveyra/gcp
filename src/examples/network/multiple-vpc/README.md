# Terraform Example: Multiple VPC Networks

Este ejemplo implementa una versión Terraform del lab **Multiple VPC Networks**.

## Qué crea

- API necesaria: `compute.googleapis.com`.
- 3 redes para reproducir el escenario completo:
  - `managementnet` como custom mode
  - `privatenet` como custom mode
  - `mynetwork` como auto mode
- Subredes:
  - `managementsubnet-1`
  - `privatesubnet-1`
  - `privatesubnet-2`
  - subredes automáticas de `mynetwork` en `region_1` y `region_2`
- Firewall rules para permitir `icmp`, `tcp:22` y `tcp:3389` en las tres redes necesarias.
- VMs simples:
  - `managementnet-vm-1`
  - `privatenet-vm-1`
  - `mynet-vm-1`
  - `mynet-vm-2`
- VM `vm-appliance` con 3 interfaces:
  - `privatesubnet-1`
  - `managementsubnet-1`
  - subred automática de `mynetwork` en `region_1`

## Uso rápido

1. Inicializá:

```bash
terraform init
```

2. Definí `terraform.tfvars`:

```hcl
project_id = "tu-project-id"
region_1   = "us-central1"
region_2   = "us-east1"
zone_1     = "us-central1-a"
zone_2     = "us-east1-b"
```

3. Plan y apply:

```bash
terraform plan
terraform apply
```

## Notas

- El lab original asume que `mynetwork`, `mynet-vm-1` y `mynet-vm-2` ya existen. En este ejemplo se crean también para que la práctica sea autocontenida.
- La `vm-appliance` instala `net-tools` para que puedas correr `ifconfig` como en el lab.
- La conectividad esperada replica la idea central del ejercicio: `vm-appliance` llega a subredes directamente conectadas, pero no necesariamente a otras subredes remotas de `mynetwork` sin policy routing adicional.
