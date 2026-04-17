# Terraform Example: Exploring IAM

Este ejemplo implementa una version Terraform del lab **Exploring IAM**.

## Que crea

- APIs necesarias: `compute.googleapis.com`, `iam.googleapis.com`, `storage.googleapis.com`.
- Bucket de Cloud Storage multi-region con nombre unico global.
- Objeto de prueba `sample.txt`.
- Grant opcional de `roles/storage.objectViewer` sobre el bucket para un principal externo.
- Service account `read-bucket-objects`.
- Roles sobre el bucket para el service account de la VM:
  - `roles/storage.objectViewer`
  - `roles/storage.objectCreator`
- Grant opcional de `roles/iam.serviceAccountUser` sobre el service account.
- Grant opcional de `roles/compute.instanceAdmin.v1` a nivel proyecto.
- VM `demoiam` con imagen Debian 12 y scope de Storage read/write.

## Uso rapido

1. Inicializa:

```bash
terraform init
```

2. Crea `terraform.tfvars`:

```hcl
project_id = "tu-project-id"
region     = "us-central1"
zone       = "us-central1-a"

network_name    = "default"
subnetwork_name = "default"

limited_storage_member        = "user:student-02@example.com"
service_account_user_member   = "group:platform-admins@example.com"
compute_instance_admin_member = "group:platform-admins@example.com"
```

3. Revisa cambios y aplica:

```bash
terraform plan
terraform apply
```

## Notas

- El lab original concede `Storage Object Viewer` desde el IAM del proyecto; en este ejemplo se acota ese acceso al bucket para mantener menor privilegio sin perder el comportamiento observable del ejercicio.
- Si queres reproducir el momento del `403 AccessDeniedException`, aplica primero con:

```hcl
service_account_bucket_roles = [
  "roles/storage.objectViewer",
]
```

  Despues agrega `roles/storage.objectCreator` y vuelve a aplicar.
- La VM usa solo el scope `https://www.googleapis.com/auth/devstorage.read_write`, asi que desde adentro de la instancia deberias seguir viendo que `gcloud compute instances list` no queda habilitado como en el lab.
- Se asume que ya existe una red/subred accesible para la VM. Los defaults `default/default` suelen calzar con el escenario del lab; si tu proyecto no las tiene, ajusta `network_name` y `subnetwork_name`.
