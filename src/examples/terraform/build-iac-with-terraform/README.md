# Terraform Example: Build IaC with Terraform

Este ejemplo implementa una práctica Terraform basada en el lab **Build IaC with Terraform**.

## Referencias del lab

- Lab original (requiere login): [Build IaC with Terraform](https://www.skills.google/course_templates/636/labs/592697)
- Fuente pública usada para trazabilidad de comandos: [GSP345 Walkthrough (Gist)](https://gist.github.com/Syed-Hassaan/e41a83345832666846ee6be0f69c1f36)

## Qué crea

- APIs: `compute.googleapis.com`, `storage.googleapis.com`.
- Cloud Storage bucket para simular backend/state remoto.
- VPC + subnets mediante módulo `terraform-google-modules/network/google`.
- Compute Engine instances `tf-instance-1` y `tf-instance-2`.
- Tercera instancia opcional (`create_third_instance`) para practicar `taint` y reconciliación.
- Firewall `tf-firewall` para exponer `tcp:80`.
- Service account para VMs con rol `roles/logging.logWriter`.

## Uso rápido

1. Crear `terraform.tfvars`:

```hcl
project_id = "tu-project-id"
region     = "us-central1"
zone       = "us-central1-a"
bucket_name = "tf-bucket-unico-12345"

# Opcional para practicar task de taint/recreate
create_third_instance = true
third_instance_name   = "tf-instance-3"
```

2. Inicializar y planificar:

```bash
terraform init
terraform plan
```

3. Aplicar:

```bash
terraform apply
```

## Comandos del flujo del lab

```bash
terraform import google_compute_instance.tf_instance_1 <INSTANCE_ID_1>
terraform import google_compute_instance.tf_instance_2 <INSTANCE_ID_2>
terraform taint google_compute_instance.tf_instance_3[0]
```

La guía original usa estructura de módulos locales (`modules/instances` y `modules/storage`); este ejemplo lo simplifica en un layout compacto pero mantiene los mismos conceptos del lab.

## Notas

- `disable_on_destroy = false` se aplica al habilitar APIs para evitar apagarlas al destruir.
- No hay secretos hardcodeados en los archivos `.tf`.
- Para backend remoto real, después de crear el bucket podés migrar estado agregando un bloque `backend "gcs"` y re-ejecutar `terraform init`.
