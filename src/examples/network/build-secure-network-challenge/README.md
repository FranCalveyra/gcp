# Terraform Example: Build a Secure Network - Challenge

Este ejemplo modela en Terraform una versión reproducible del challenge **Build a Secure Google Cloud Network (GSP322)**.

## Qué crea

- APIs:
  - `compute.googleapis.com`
  - `iap.googleapis.com`
- Red:
  - VPC `acme-vpc` (custom mode).
  - Subred `acme-mgmt-subnet` para administración.
  - Subred `acme-web-subnet` para `juice-shop`.
- Firewall:
  - `allow-ssh-iap-ingress`: permite SSH solo desde rango IAP (`35.235.240.0/20`) hacia `bastion`.
  - `allow-http-ingress`: permite HTTP (`tcp:80`) desde Internet a `juice-shop`.
  - `allow-ssh-internal-ingress`: permite SSH interno desde la subnet de management hacia `juice-shop`.
- Compute Engine:
  - VM `bastion` sin public IP (acceso por IAP).
  - VM `juice-shop` con public IP y `nginx` como placeholder de workload HTTP.

## Uso rápido

1. Inicializá:

```bash
terraform init
```

2. Definí variables en `terraform.tfvars`:

```hcl
project_id = "tu-project-id"
region     = "us-central1"
zone       = "us-central1-b"
```

3. Plan y apply:

```bash
terraform plan
terraform apply
```

## Notas

- Este ejemplo representa el estado objetivo del challenge con reglas de firewall restrictivas y tags explícitos.
- No incluye recursos temporales del laboratorio administrado por Skills Boost (grading/checkpoints).
- Para limpieza, corré:

```bash
terraform destroy
```
