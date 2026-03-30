# Terraform Example: Cloud Storage Lab

Este ejemplo implementa una práctica Terraform basada en el lab **Cloud Storage**.

## Qué crea

- Bucket de Cloud Storage con nombre único global.
- Versioning habilitable (`enable_versioning`).
- Lifecycle rule para borrar objetos por edad (`lifecycle_delete_age_days`).
- Objetos de ejemplo (`setup.html`, `setup2.html`, `setup3.html`) opcionales.
- Opción de acceso público de lectura por IAM (`make_sample_public`).

## Uso rápido

1. Inicializá:

```bash
terraform init
```

2. Definí variables en `terraform.tfvars`:

```hcl
project_id                = "tu-project-id"
region                    = "us-central1"
bucket_name_prefix        = "cloud-storage-lab"
enable_versioning         = true
lifecycle_delete_age_days = 31
upload_sample_objects     = true
make_sample_public        = false
```

3. Plan y apply:

```bash
terraform plan
terraform apply
```

## Notas

- El lab original usa ACLs y CSEK operados manualmente con `gsutil` + `.boto`.
- Este ejemplo prioriza prácticas IaC estándar con IAM y configuración declarativa del bucket.
- Si necesitás reproducir CSEK manual exacto, conviene mantenerlo en un paso operativo fuera de Terraform.
