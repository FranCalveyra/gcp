# BigQuery

Prácticas Terraform sobre BigQuery: carga de datos, consultas y gestión de datasets.

## Prácticas disponibles

| Práctica | Descripción |
|---|---|
| [Loading Data into BigQuery](./loading-data/README.md) | Crea dataset, tabla externa desde GCS y vista filtrada |

## Uso rápido

```bash
cd loading-data
terraform init
terraform apply -var="project_id=<TU_PROYECTO>"
```
