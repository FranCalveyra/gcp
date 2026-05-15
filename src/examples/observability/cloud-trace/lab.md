[Link al lab](https://www.skills.google/course_templates/864/labs/621043)

## Recursos identificados

- APIs habilitadas: `container.googleapis.com`, `cloudtrace.googleapis.com`.
- Cluster GKE: `cloud-trace-demo` (standard, us-central1-c).
- Deployments de Kubernetes: `cloud-trace-demo-a`, `cloud-trace-demo-b`, `cloud-trace-demo-c` — app Python con Flask + OpenTelemetry que propaga contexto de tracing entre servicios.
- Services de Kubernetes: LoadBalancer para `cloud-trace-demo-a` (punto de entrada), ClusterIP para b y c.
- Cloud Trace: recibe los spans exportados por la app via OpenTelemetry; no requiere recursos Terraform propios.
- IAM: las VMs del nodo pool usan la service account por defecto del proyecto con scope `trace.append`.

## Comandos ejecutados

En los comandos siguientes, reemplazá `<ZONE>` y `<PROJECT_ID>` por los valores de tu lab.

### Verificar autenticación y proyecto activo

```bash
gcloud auth list
gcloud config list project
```

### Crear el cluster GKE

```bash
gcloud container clusters create cloud-trace-demo \
  --zone us-central1-c
```

### Configurar kubectl para el cluster

```bash
gcloud container clusters get-credentials cloud-trace-demo \
  --zone us-central1-c

kubectl get nodes
```

### Clonar el repositorio de la app demo

```bash
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
```

### Deployar la app con el script de setup

```bash
cd python-docs-samples/trace/cloud-trace-demo-app-opentelemetry && ./setup.sh
```

> El script despliega los tres servicios (a, b, c) y espera a que el LoadBalancer de `cloud-trace-demo-a` obtenga IP externa.

### Obtener la IP externa del servicio de entrada

```bash
kubectl get svc
```

### Generar tráfico para producir traces

```bash
curl $(kubectl get svc -o=jsonpath='{.items[?(@.metadata.name=="cloud-trace-demo-a")].status.loadBalancer.ingress[0].ip}')
```

> Repetir varias veces para generar suficientes spans visibles en Cloud Trace.

### Ver los traces (Console)

> **Cloud Trace → Explorador de traces** — los puntos en el scatter plot representan requests individuales. Hacer click en un punto para ver el Gantt chart con los spans de a→b→c y los atributos de cada span.

### Limpiar el cluster al terminar

```bash
gcloud container clusters delete cloud-trace-demo \
  --zone us-central1-c
```
