# Terraform Example: Crear una VM en Compute Engine

Ejemplo mínimo de Infraestructura como Código para crear una instancia de Compute Engine, equivalente a crear una VM desde la consola o con `gcloud compute instances create`.

## Qué despliega

- Una `google_compute_instance` (`my-vm`, `n1-standard-1`) con imagen Ubuntu en la zona configurada.
- Disco de arranque inicializado con la imagen.
- Interfaz de red sobre la red `default` con `access_config` (IP externa efímera).

## Uso rápido

```bash
terraform init
terraform plan -var="project_id=<PROJECT_ID>"
terraform apply -var="project_id=<PROJECT_ID>"
```

El nombre y las IPs (interna y externa) de la instancia quedan expuestos en los outputs.

## Recomendaciones

- No hardcodear `project_id`, región ni imagen: usá variables (ya parametrizadas).
- Corré `terraform destroy` al terminar para evitar costos.
