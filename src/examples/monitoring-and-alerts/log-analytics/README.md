# Práctica Terraform: Log Analytics

Este ejemplo implementa con Terraform una base reproducible inspirada en el lab **Log Analytics on Google Cloud (GSP1088)**:

- Habilita APIs necesarias.
- Crea un **cluster GKE**.
- Crea un **log bucket** con **Log Analytics** habilitado.
- Crea un **linked dataset** en BigQuery para consultar logs con SQL.
- Crea un **log sink** con el filtro `resource.type="k8s_container"` hacia el log bucket.

## Qué NO despliega

- El deploy de la app **microservices-demo** (Online Boutique) con Terraform. En el lab se hace con `kubectl` y acá queda documentado como comandos.

## Prerrequisitos

- Terraform instalado.
- Permisos en el proyecto para crear GKE, Logging y BigQuery.
- `gcloud` y `kubectl` si vas a desplegar la demo.

## Uso rápido

1. Inicializá:

```bash
terraform init
```

2. Creá `terraform.tfvars`:

```hcl
project_id = "tu-project-id"
region     = "us-west1"
zone       = "us-west1-a"
```

3. Plan y apply:

```bash
terraform plan
terraform apply
```

## Comandos del lab (deploy de Online Boutique)

> Estos comandos están extraídos del lab; sirven para generar carga y logs desde GKE.

```bash
git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
cd microservices-demo
kubectl apply -f release/kubernetes-manifests.yaml
kubectl get pods
```

```bash
export EXTERNAL_IP=$(kubectl get service frontend-external -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
echo $EXTERNAL_IP
curl -o /dev/null -s -w "%{http_code}\n" http://${EXTERNAL_IP}
```

## Consultas del lab (Log Analytics / BigQuery)

Filtro usado para el sink:

```bash
resource.type="k8s_container"
```

Ejemplos SQL (ajustá `PROJECT_ID` si lo pegás tal cual):

```sql
SELECT
  hour,
  MIN(took_ms) AS min,
  MAX(took_ms) AS max,
  AVG(took_ms) AS avg
FROM (
  SELECT
    FORMAT_TIMESTAMP("%H", timestamp) AS hour,
    CAST(JSON_VALUE(json_payload, '$."http.resp.took_ms"') AS INT64) AS took_ms
  FROM `PROJECT_ID.global.day2ops-log._AllLogs`
  WHERE timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 24 HOUR)
    AND json_payload IS NOT NULL
    AND SEARCH(labels, "frontend")
    AND JSON_VALUE(json_payload.message) = "request complete"
  ORDER BY took_ms DESC, timestamp ASC
)
GROUP BY 1
ORDER BY 1
```

```sql
SELECT
  count(*)
FROM `PROJECT_ID.global.day2ops-log._AllLogs`
WHERE text_payload like "GET %/product/L9ECAV7KIM %"
  AND timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
```

```sql
SELECT
  JSON_VALUE(json_payload.session),
  COUNT(*)
FROM `PROJECT_ID.global.day2ops-log._AllLogs`
WHERE JSON_VALUE(json_payload['http.req.method']) = "POST"
  AND JSON_VALUE(json_payload['http.req.path']) = "/cart/checkout"
  AND timestamp > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR)
GROUP BY JSON_VALUE(json_payload.session)
```

## Salidas útiles

El ejemplo expone por `outputs`:

- `cluster_name`, `cluster_location`
- `log_bucket_name`, `log_bucket_destination`
- `linked_dataset_resource_name`
- `sink_name`, `sink_writer_identity`

