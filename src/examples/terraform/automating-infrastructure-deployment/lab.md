[Link al lab](https://www.skills.google/course_templates/636/labs/592697)

> La URL del lab requiere login. Para extraer comandos se usó como fuente pública equivalente este walkthrough: [GSP345 | Automating Infrastructure on Google Cloud with Terraform: Challenge Lab (Gist)](https://gist.github.com/Syed-Hassaan/e41a83345832666846ee6be0f69c1f36).

## Recursos identificados

- APIs habilitadas en el flujo: `compute.googleapis.com` y `storage.googleapis.com`.
- Recursos principales:
  - Compute Engine instances (`tf-instance-1`, `tf-instance-2` y temporalmente `tf-instance-3`).
  - Cloud Storage bucket para `backend "gcs"` de Terraform state.
  - VPC y subnets creadas con módulo del Terraform Registry (`terraform-google-modules/network/google`).
  - Firewall rule (`google_compute_firewall`) para tráfico `tcp:80`.
- IAM:
  - uso implícito de permisos del usuario/sesión de Cloud Shell para crear/importar y administrar recursos.
  - no se define un `service account` custom en la guía base.
- Integraciones:
  - Terraform import para adoptar instancias ya existentes.
  - Terraform backend remoto en GCS (`prefix = "terraform/state"`).
  - Integración con módulo público del Terraform Registry para networking.

## Comandos ejecutados

### Estructura inicial de archivos
```bash
touch main.tf
touch variables.tf
mkdir modules
cd modules
mkdir instances
cd instances
touch instances.tf
touch outputs.tf
touch variables.tf
cd ..
mkdir storage
cd storage
touch storage.tf
touch outputs.tf
touch variables.tf
cd
```

### Inicialización de Terraform
```bash
terraform init
```

### Import de infraestructura existente
```bash
terraform import module.instances.google_compute_instance.tf-instance-1 <Instance ID - 1>
terraform import module.instances.google_compute_instance.tf-instance-2 <Instance ID - 2>
```

### Revisar y aplicar cambios de estado
```bash
terraform plan
terraform apply
```

### Crear bucket para backend remoto
```bash
terraform init
terraform apply
```

### Migrar state a backend GCS
```bash
terraform init
```

### Actualizar infraestructura de instancias
```bash
terraform init
terraform apply
```

### Taint y recreación de recurso
```bash
terraform taint module.instances.google_compute_instance.tf-instance-3
terraform init
terraform apply
```

### Eliminar tercer recurso y reconciliar
```bash
terraform apply
```

### Crear VPC con módulo del Registry
```bash
terraform init
terraform apply
```

### Reconfigurar instancias sobre nuevas subnets
```bash
terraform init
terraform apply
```

### Configurar firewall final
```bash
terraform init
terraform apply
```
