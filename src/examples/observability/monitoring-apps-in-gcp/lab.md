[Link al lab](https://www.skills.google/focuses/19105?parent=catalog)

Este lab se complementa con la práctica Terraform en `README.md` dentro de esta misma carpeta.

## Recursos identificados

- **App Engine**: aplicación Python 3.11 (Flask) desplegada con `gcloud app deploy`
- **Cloud Profiler**: habilitado via SDK en la app (`google-cloud-profiler`)
- **Cloud Trace**: integrado automáticamente en App Engine
- **Cloud Monitoring**: dashboards, uptime checks y alert policies
- **Compute Engine**: VM usada para generar carga con `ab` (Apache Bench)
- **APIs**: `cloudprofiler.googleapis.com`, `appengine.googleapis.com`, `monitoring.googleapis.com`, `compute.googleapis.com`

## Comandos ejecutados

### Configuración inicial

```bash
gcloud auth list
gcloud config list project
gcloud config set project [PROJECT_ID]
```

### Clonar el código de ejemplo

```bash
mkdir gcp-logging
cd gcp-logging
gcloud storage cp gs://cloud-training/CBL175/design-process.zip .
unzip design-process.zip
cd design-process/deploying-apps-to-gcp
```

### Habilitar Cloud Profiler

```bash
gcloud services enable cloudprofiler.googleapis.com
```

### Probar la app localmente con Docker

```bash
docker build -t test-python .
docker run --rm -p 8080:8080 test-python
```

### Crear la aplicación en App Engine y desplegar

```bash
gcloud app create --region=[REGION]
gcloud app deploy --version=one --quiet
```

### Generar carga desde la VM de Compute Engine

```bash
sudo apt update
sudo apt install apache2-utils -y
ab -k -n 1000 -c 10 https://<your-project-id>.appspot.com/
```

## Modificaciones al código de la app

**`main.py`**: agregar inicialización del profiler:

```python
import googlecloudprofiler

try:
    googlecloudprofiler.start(verbose=3)
except (ValueError, NotImplementedError) as exc:
    print(exc)
```

**`requirements.txt`**: agregar dependencias:

```
google-cloud-profiler==4.1.0
protobuf==3.20.1
```

**`app.yaml`**:

```yaml
runtime: python311
```
