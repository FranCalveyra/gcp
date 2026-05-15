[Link al lab](https://www.skills.google/course_templates/864/labs/621037)

## Recursos identificados

- APIs habilitadas: `compute.googleapis.com`, `logging.googleapis.com`, `bigquery.googleapis.com`.
- Red: VPC custom mode `vpc-net`, subred `vpc-subnet` (10.1.3.0/24) con VPC Flow Logs habilitados (intervalo 5 s, sampling 50%, metadata completa).
- Instancia: `web-server` (e2-micro, Debian, tag `http-server`) en `vpc-subnet`.
- Firewall: `allow-http-ssh` — permite tcp:22 y tcp:80 desde `0.0.0.0/0` a VMs con tag `http-server`.
- Log sink: `vpc-flows` exporta logs `compute.googleapis.com/vpc_flows` a BigQuery.
- BigQuery dataset: `bq_vpcflows` — recibe los registros de flujo para análisis SQL.
- IAM: la service account writer del sink recibe `roles/bigquery.dataEditor` sobre el dataset.

## Comandos ejecutados

En los comandos siguientes, reemplazá `<ZONE>` y `<EXTERNAL_IP>` por los valores de tu lab.

### Verificar autenticación y proyecto activo

```bash
gcloud auth list
gcloud config list project
```

### Crear la VPC custom y la subred con Flow Logs

```bash
gcloud compute networks create vpc-net \
  --subnet-mode=custom \
  --bgp-routing-mode=regional

gcloud compute networks subnets create vpc-subnet \
  --network=vpc-net \
  --region=us-central1 \
  --range=10.1.3.0/24 \
  --enable-flow-logs \
  --logging-aggregation-interval=interval-5-sec \
  --logging-flow-sampling=0.5 \
  --logging-metadata=include-all
```

### Crear la regla de firewall

```bash
gcloud compute firewall-rules create allow-http-ssh \
  --direction=INGRESS \
  --priority=1000 \
  --network=vpc-net \
  --action=ALLOW \
  --rules=tcp:22,tcp:80 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=http-server
```

### Crear la VM web-server

```bash
gcloud compute instances create web-server \
  --zone=<ZONE> \
  --machine-type=e2-micro \
  --subnet=vpc-subnet \
  --tags=http-server \
  --image-family=debian-12 \
  --image-project=debian-cloud
```

### Instalar Apache en la VM (via SSH)

```bash
sudo apt-get update
sudo apt-get install apache2 -y
echo '<!doctype html><html><body><h1>Hello World!</h1></body></html>' | sudo tee /var/www/html/index.html
exit
```

### Generar tráfico desde Cloud Shell

```bash
export MY_SERVER=<EXTERNAL_IP>
for ((i=1;i<=50;i++)); do curl $MY_SERVER; done
```

### Crear el log sink hacia BigQuery (Console)

> Esta tarea se realiza desde la consola: **Logging → Explorador de logs → Más acciones → Crear receptor**.
> - Nombre del receptor: `vpc-flows`
> - Destino: BigQuery dataset `bq_vpcflows` (crear nuevo)

### Consultar los logs en BigQuery

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
  `<PROJECT_ID>.bq_vpcflows.compute_googleapis_com_vpc_flows_*`
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

### Ajustar la agregación de Flow Logs (Console)

> **VPC network → vpc-net → vpc-subnet → Editar → Configurar logs**
> - Intervalo de agregación: 30 segundos
> - Tasa de muestreo: 25 %
