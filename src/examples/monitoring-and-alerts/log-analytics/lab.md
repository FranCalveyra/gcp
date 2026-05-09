[Link al lab](https://www.skills.google/focuses/49749?parent=catalog)

## Recursos identificados
- **GKE**: cluster `day2-ops` (trabajo con workloads `k8s_container`).
- **Cloud Logging**:
  - Log bucket (upgrade del bucket existente `_Default` o creación de un bucket nuevo).
  - Log Analytics habilitado en el bucket.
  - Log view `_AllLogs` dentro del bucket.
  - Log sink con filtro `resource.type="k8s_container"` hacia el bucket.
- **BigQuery**:
  - Dataset linkeado al log bucket (para ejecutar consultas SQL sobre el log view).
- **Integraciones**:
  - Export/routing de logs vía Logs Router (sink) hacia un log bucket.

## Comandos ejecutados

```bash
gcloud auth list
```

```bash
gcloud config list project
```

```bash
gcloud config set compute/zone ZONE
```

```bash
gcloud container clusters list
```

```bash
gcloud container clusters get-credentials day2-ops --region REGION
```

```bash
kubectl get nodes
```

```bash
git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
```

```bash
cd microservices-demo
```

```bash
kubectl apply -f release/kubernetes-manifests.yaml
```

```bash
kubectl get pods
```

```bash
export EXTERNAL_IP=$(kubectl get service frontend-external -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
echo $EXTERNAL_IP
```

```bash
curl -o /dev/null -s -w "%{http_code}\n" http://${EXTERNAL_IP}
```

```bash
resource.type="k8s_container"
```

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

