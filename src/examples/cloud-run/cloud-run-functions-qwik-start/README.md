# Terraform Example: Cloud Run Functions Qwik Start

Este ejemplo replica los recursos principales del lab **Cloud Run Functions Qwik Start** usando Terraform.

## Qué despliega

- Habilitación de APIs necesarias (`cloudfunctions`, `run`, `eventarc`, `pubsub`, etc.).
- Bucket de Cloud Storage para eventos.
- Permisos IAM requeridos para integración de eventos.
- Funciones de Cloud Run Functions (gen2):
  - `nodejs-http-function`
  - `nodejs-storage-function`
  - `gce-vm-labeler`
  - `hello-world-colored`
  - `slow-function`
  - `slow-concurrent-function`

## Importante

Las funciones se despliegan desde ZIPs en Cloud Storage. Tenés que subir previamente esos artefactos al bucket definido en `source_bucket_name`.

## Uso rápido

1. Inicializá:

```bash
terraform init
```

2. Creá `terraform.tfvars`:

```hcl
project_id         = "tu-project-id"
region             = "us-central1"
source_bucket_name = "tu-bucket-con-zips"

source_objects = {
  nodejs_http              = "nodejs-http-function.zip"
  nodejs_storage           = "nodejs-storage-function.zip"
  gce_vm_labeler           = "gce-vm-labeler.zip"
  hello_world_colored      = "hello-world-colored.zip"
  slow_function            = "slow-function.zip"
  slow_concurrent_function = "slow-concurrent-function.zip"
}
```

3. Plan y apply:

```bash
terraform plan
terraform apply
```
