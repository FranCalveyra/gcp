# Loading Data into BigQuery

Práctica Terraform basada en el lab [Loading data into BigQuery](https://www.skills.google/focuses/19280?parent=catalog).

Crea el dataset `nyctaxi`, una tabla externa apuntando a datos de NYC Taxi en GCS, y una vista de viajes de enero.

## Recursos creados

| Recurso | Tipo | Descripción |
|---|---|---|
| `nyctaxi` | `google_bigquery_dataset` | Dataset principal |
| `2018trips` | `google_bigquery_table` (external) | Tabla externa sobre CSV en GCS |
| `january_trips` | `google_bigquery_table` (view) | Vista filtrada por mes de enero |

## Uso

```bash
terraform init
terraform plan -var="project_id=<TU_PROYECTO>"
terraform apply -var="project_id=<TU_PROYECTO>"
```

## Variables principales

| Variable | Default | Descripción |
|---|---|---|
| `project_id` | — | ID del proyecto GCP (obligatoria) |
| `region` | `US` | Ubicación del dataset |
| `dataset_id` | `nyctaxi` | ID del dataset |
| `gcs_source_uri` | URI del CSV de NYC Taxi en GCS | Fuente de datos para la tabla externa |

> **Nota**: el lab original carga los datos vía `bq load` y UI. Esta práctica modela el estado final con tabla externa (sin necesidad de copiar datos al proyecto) y una vista equivalente a `january_trips`.
