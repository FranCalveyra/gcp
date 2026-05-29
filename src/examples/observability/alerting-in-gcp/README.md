# Práctica Terraform: Alerting in GCP

Este ejemplo implementa con Terraform una base reproducible para el lab **Alerting in Google Cloud**:

- Habilita APIs necesarias.
- Crea la **App Engine application** del proyecto.
- Crea un **Cloud Monitoring alerting policy** sobre latencia (99th percentile).
- (Opcional) Crea un **notification channel** de tipo email.

## Qué NO despliega

- El código de la aplicación y el deploy de App Engine (eso en el lab se hace con `gcloud app deploy`).
- El generador de carga con `curl` (es un comando del lab para disparar incidentes).

## Uso rápido

1. Inicializá:

```bash
terraform init
```

2. Creá `terraform.tfvars`:

```hcl
project_id             = "tu-project-id"
region                 = "us-central1"
app_engine_location_id = "us-central"

# Opcional: crea el notification channel
notification_email = "tu-email@ejemplo.com"
```

3. Plan y apply:

```bash
terraform plan
terraform apply
```

## Notas de compatibilidad

- `app_engine_location_id` **no** es lo mismo que `region`. Ejemplos típicos:
  - Region: `us-central1` → App Engine location: `us-central`
  - Region: `southamerica-east1` → App Engine location: `southamerica-east1`

## Salidas útiles

El ejemplo expone por `outputs`:

- `alert_policy_name`
- `notification_channel_name` (si aplica)

