# Terraform Example: Configuring IAM with gcloud

Este ejemplo implementa una version Terraform de la parte reproducible del lab **Configuring IAM Permissions with gcloud**, enfocada en el segundo proyecto del escenario.

## Que crea

- APIs necesarias: `compute.googleapis.com`, `iam.googleapis.com`.
- Rol custom `devops` con los permisos de Compute Engine usados en el lab.
- Bindings IAM para `user2`:
  - `roles/viewer`
  - `roles/iam.serviceAccountUser`
  - `projects/<project>/roles/devops`
- Service account `devops`.
- Bindings IAM para la service account:
  - `roles/iam.serviceAccountUser`
  - `roles/compute.instanceAdmin`
- VM `lab-3` con la service account adjunta.

## Uso rapido

1. Inicializa Terraform:

```bash
terraform init
```

2. Defini un `terraform.tfvars`:

```hcl
project_id      = "tu-project-id"
user2_email     = "usuario2@example.com"
region          = "us-central1"
zone            = "us-central1-a"
network_name    = "default"
subnetwork_name = "default"
```

3. Revisa y aplica:

```bash
terraform plan
terraform apply
```

## Verificaciones manuales

- Revisar el rol custom:

```bash
gcloud iam roles describe devops --project <PROJECT_ID>
```

- Revisar bindings del usuario secundario:

```bash
gcloud projects get-iam-policy <PROJECT_ID> \
  --flatten="bindings[].members" \
  --filter="bindings.members:user:<USER2_EMAIL>" \
  --format="table(bindings.role)"
```

- Confirmar la service account adjunta en la VM:

```bash
gcloud compute instances describe lab-3 \
  --zone <ZONE> \
  --format="value(serviceAccounts.email)"
```

## Notas

- El ejemplo asume que ya existe una VPC y subred, igual que en el lab original. Por default usa `default`/`default`, pero se puede apuntar a otra red cambiando variables.
- No modela el paso interactivo de `gcloud auth login`, `gcloud init` ni el cambio entre configuraciones locales (`default` y `user2`), porque Terraform trabaja contra una identidad ya autenticada.
- La VM usa el scope `cloud-platform` por default y limita acceso real via roles IAM, que es la recomendacion actual en lugar de depender solo de scopes legacy.
- Los custom roles tienen soft-delete en GCP. Si ya existio un rol con el mismo `custom_role_id`, puede hacer falta cambiar el nombre o esperar a que quede disponible otra vez.
