# VPC Flow Logs — Análisis de tráfico de red

Práctica Terraform basada en el lab [Analyzing Network Traffic with VPC Flow Logs](https://www.skills.google/course_templates/864/labs/621037).

Crea una VPC custom con Flow Logs habilitados, una VM web-server con Apache, un log sink a BigQuery, y los permisos necesarios para que el sink pueda escribir en el dataset.

## Recursos creados

| Recurso | Nombre |
|---|---|
| VPC custom | `vpc-net` |
| Subred con Flow Logs | `vpc-subnet` (10.1.3.0/24) |
| Firewall | `allow-http-ssh` (tcp:22,80) |
| VM | `web-server` (e2-micro, Apache) |
| BigQuery dataset | `bq_vpcflows` |
| Log sink | `vpc-flows` → BigQuery |

## Uso rápido

```bash
terraform init

terraform apply \
  -var="project_id=TU_PROJECT_ID"
```

## Variables requeridas

| Variable | Descripción |
|---|---|
| `project_id` | ID del proyecto GCP |

Las demás variables tienen defaults razonables; ver `variables.tf`.

## Generar tráfico para análisis

Una vez aplicado:

```bash
export MY_SERVER=$(terraform output -raw web_server_external_ip)
for ((i=1;i<=50;i++)); do curl $MY_SERVER; done
```

Esperá unos minutos para que los logs se exporten a BigQuery, luego ejecutá la query de análisis desde la consola de BigQuery:

```sql
#standardSQL
SELECT
  jsonPayload.src_vpc.vpc_name,
  SUM(CAST(jsonPayload.bytes_sent AS INT64)) AS bytes,
  jsonPayload.src_vpc.subnetwork_name,
  jsonPayload.connection.src_ip,
  jsonPayload.connection.src_port,
  jsonPayload.connection.dest_ip,
  jsonPayload.connection.dest_port,
  jsonPayload.connection.protocol
FROM
  `TU_PROJECT_ID.bq_vpcflows.compute_googleapis_com_vpc_flows_*`
GROUP BY
  jsonPayload.src_vpc.vpc_name,
  jsonPayload.src_vpc.subnetwork_name,
  jsonPayload.connection.src_ip,
  jsonPayload.connection.src_port,
  jsonPayload.connection.dest_ip,
  jsonPayload.connection.dest_port,
  jsonPayload.connection.protocol
ORDER BY bytes DESC
LIMIT 15
```

## Notas

- El sink usa `unique_writer_identity = true`, lo que crea una service account dedicada. El recurso `google_bigquery_dataset_iam_member` le otorga automáticamente `roles/bigquery.dataEditor`.
- No se puede validar runtime real sin un proyecto activo con billing habilitado.
