# Práctica Terraform: Service Monitoring

Este ejemplo implementa con Terraform una base reproducible para el lab **Service Monitoring**:

- Habilita APIs necesarias.
- Crea la **App Engine application** del proyecto.
- Crea un **Service Monitoring SLO** de disponibilidad (rolling window) para el App Engine service `default`.
- Crea un **Cloud Monitoring alert policy** basado en **burn rate del error budget** del SLO (via MQL `select_slo_burn_rate`).
- (Opcional) Crea un **notification channel** de tipo email.

## Qué NO despliega

- El código de la app Node.js ni el deploy a App Engine (en el lab se hace con `gcloud app deploy`).
- La generación de carga con `curl` (en el lab se usa para provocar errores).

## Prerrequisitos

- Tener un servicio App Engine `default` desplegado en el proyecto. Si todavía no existe, el datasource `google_monitoring_app_engine_service` puede fallar porque Service Monitoring aún no “ve” el servicio.

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

# Defaults del lab
slo_goal                  = 0.995
slo_rolling_period_days    = 7
burn_rate_lookback_seconds = 600
burn_rate_threshold        = 1.5
```

3. Plan y apply:

```bash
terraform plan
terraform apply
```

## Salidas útiles

El ejemplo expone por `outputs`:

- `slo_name`
- `alert_policy_name`
- `notification_channel_name` (si aplica)

