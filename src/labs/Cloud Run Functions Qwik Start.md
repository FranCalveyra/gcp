[Link al lab](https://www.skills.google/focuses/49757?catalog_rank=%7B%22rank%22%3A1%2C%22num_filters%22%3A0%2C%22has_search%22%3Atrue%7D&parent=catalog&search_id=77151388)

## Recursos identificados

- APIs: `artifactregistry.googleapis.com`, `cloudfunctions.googleapis.com`, `cloudbuild.googleapis.com`, `eventarc.googleapis.com`, `run.googleapis.com`, `logging.googleapis.com`, `pubsub.googleapis.com`.
- Cloud Run Functions (gen2):
  - `nodejs-http-function` (HTTP)
  - `nodejs-storage-function` (evento de Cloud Storage)
  - `gce-vm-labeler` (evento de Cloud Audit Logs)
  - `hello-world-colored` (HTTP con variable de entorno)
  - `slow-function` (HTTP, prueba de cold start)
  - `slow-concurrent-function` (HTTP, min instances y concurrencia)
- Cloud Storage bucket para eventos: `gcf-gen2-storage-<PROJECT_ID>`.
- IAM bindings:
  - `roles/pubsub.publisher` para la Cloud Storage service account.
  - `roles/eventarc.eventReceiver` para la Compute Engine default service account.
- Compute Engine VM de prueba: `instance-1` (creacion y borrado para test de Audit Logs).
- Cloud Run service revisions (via consola) para pruebas de color, min instances y concurrencia.

## Comandos ejecutados

### Verificar la cuenta activa en Cloud Shell
Se usa para confirmar con que identidad estas autenticado.
```bash
gcloud auth list
```

### Verificar el proyecto activo
Se usa para validar el `PROJECT_ID` que usara `gcloud`.
```bash
gcloud config list project
```

### Habilitar APIs necesarias del lab
Se usa para activar servicios base de Cloud Run Functions, build, eventos y logs.
```bash
gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com
```

### Habilitar Gemini for Google Cloud API
Se usa para permitir Gemini Code Assist en el entorno del lab.
```bash
gcloud services enable cloudaicompanion.googleapis.com
```

### Crear carpeta base de la funcion HTTP
Se usa para inicializar el directorio de trabajo y entrar en el.
```bash
mkdir ~/hello-http && cd $_
```

### Crear archivo de codigo de la funcion HTTP
Se usa para crear `index.js`.
```bash
touch index.js
```

### Crear manifiesto de dependencias de la funcion HTTP
Se usa para crear `package.json`.
```bash
touch package.json
```

### Desplegar funcion HTTP en Cloud Run Functions (gen2)
Se usa para publicar la funcion `nodejs-http-function`.
```bash
gcloud functions deploy nodejs-http-function \
  --gen2 \
  --runtime nodejs22 \
  --entry-point helloWorld \
  --source . \
  --region {{{project_0.default_region|Region}}} \
  --trigger-http \
  --timeout 600s \
  --max-instances 1
```

### Probar la funcion HTTP desplegada
Se usa para invocar la funcion y validar la respuesta.
```bash
gcloud functions call nodejs-http-function \
  --gen2 \
  --region {{{project_0.default_region|Region}}}
```

### Obtener el numero de proyecto
Se usa para guardar el `PROJECT_NUMBER` en una variable.
```bash
PROJECT_NUMBER=$(gcloud projects list --filter="project_id:{{{ project_0.project_id | PROJECT_ID }}}" --format='value(project_number)')
```

### Obtener service account de Cloud Storage para KMS
Se usa para guardar la cuenta de servicio requerida en una variable.
```bash
SERVICE_ACCOUNT=$(gsutil kms serviceaccount -p $PROJECT_NUMBER)
```

### Asignar rol pubsub.publisher a Cloud Storage
Se usa para permitir que eventos de Cloud Storage publiquen en Pub/Sub.
```bash
gcloud projects add-iam-policy-binding {{{ project_0.project_id | PROJECT_ID }}} \
  --member serviceAccount:$SERVICE_ACCOUNT \
  --role roles/pubsub.publisher
```

### Crear carpeta base de la funcion de Cloud Storage
Se usa para inicializar el directorio de trabajo y entrar en el.
```bash
mkdir ~/hello-storage && cd $_
```

### Crear archivo de codigo de la funcion de Cloud Storage
Se usa para crear `index.js`.
```bash
touch index.js
```

### Crear manifiesto de dependencias de la funcion de Cloud Storage
Se usa para crear `package.json`.
```bash
touch package.json
```

### Definir nombre del bucket en variable
Se usa para reutilizar el bucket en comandos posteriores.
```bash
BUCKET="gs://gcf-gen2-storage-{{{ project_0.project_id | PROJECT_ID }}}"
```

### Crear bucket de Cloud Storage
Se usa para generar eventos que disparen la funcion.
```bash
gsutil mb -l {{{project_0.default_region|Region}}} $BUCKET
```

### Desplegar funcion disparada por bucket
Se usa para publicar `nodejs-storage-function` con trigger de Cloud Storage.
```bash
gcloud functions deploy nodejs-storage-function \
  --gen2 \
  --runtime nodejs22 \
  --entry-point helloStorage \
  --source . \
  --region {{{project_0.default_region|Region}}} \
  --trigger-bucket $BUCKET \
  --trigger-location {{{project_0.default_region|Region}}} \
  --max-instances 1
```

### Crear archivo de prueba local
Se usa para tener un objeto a subir al bucket.
```bash
echo "Hello World" > random.txt
```

### Subir archivo al bucket
Se usa para disparar el evento de Cloud Storage.
```bash
gsutil cp random.txt $BUCKET/random.txt
```

### Leer logs de la funcion de Cloud Storage
Se usa para confirmar que la funcion recibio el CloudEvent.
```bash
gcloud functions logs read nodejs-storage-function \
  --region {{{project_0.default_region|Region}}} \
  --gen2 \
  --limit=100 \
  --format "value(log)"
```

### Asignar rol eventarc.eventReceiver a Compute Engine default SA
Se usa para habilitar recepcion de eventos de Audit Logs via Eventarc.
```bash
gcloud projects add-iam-policy-binding {{{ project_0.project_id | PROJECT_ID }}} \
  --member serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
  --role roles/eventarc.eventReceiver
```

### Ir al home de Cloud Shell
Se usa para posicionarse donde se clonara el repositorio.
```bash
cd ~
```

### Clonar repositorio de ejemplo de Eventarc
Se usa para obtener el codigo de `gce-vm-labeler`.
```bash
git clone https://github.com/GoogleCloudPlatform/eventarc-samples.git
```

### Entrar al directorio del ejemplo nodejs
Se usa para desplegar desde el path correcto.
```bash
cd ~/eventarc-samples/gce-vm-labeler/gcf/nodejs
```

### Desplegar funcion basada en Cloud Audit Logs
Se usa para etiquetar VMs creadas segun filtros de evento.
```bash
gcloud functions deploy gce-vm-labeler \
  --gen2 \
  --runtime nodejs22 \
  --entry-point labelVmCreation \
  --source . \
  --region {{{project_0.default_region|Region}}} \
  --trigger-event-filters="type=google.cloud.audit.log.v1.written,serviceName=compute.googleapis.com,methodName=beta.compute.instances.insert" \
  --trigger-location {{{project_0.default_region|Region}}} \
  --max-instances 1
```

### Describir VM para verificar etiqueta creator
Se usa para comprobar que la funcion aplico labels.
```bash
gcloud compute instances describe instance-1 --zone {{{project_0.default_zone | "Zone"}}}
```

### Eliminar VM de prueba
Se usa para limpieza de recursos.
```bash
gcloud compute instances delete instance-1 --zone {{{project_0.default_zone | "Zone"}}}
```

### Crear carpeta base para funcion con revisiones
Se usa para preparar proyecto Python.
```bash
mkdir ~/hello-world-colored && cd $_
```

### Crear codigo de funcion Python
Se usa para crear `main.py`.
```bash
touch main.py
```

### Crear archivo de dependencias Python
Se usa para crear `requirements.txt`.
```bash
touch requirements.txt
```

### Definir variable de color inicial
Se usa para pasarla como env var en el deploy.
```bash
COLOR=orange
```

### Desplegar revision inicial de funcion coloreada
Se usa para publicar `hello-world-colored` con color naranja.
```bash
gcloud functions deploy hello-world-colored \
  --gen2 \
  --runtime python311 \
  --entry-point hello_world \
  --source . \
  --region {{{project_0.default_region|Region}}} \
  --trigger-http \
  --allow-unauthenticated \
  --update-env-vars COLOR=$COLOR \
  --max-instances 1
```

### Crear carpeta base para prueba de cold start
Se usa para preparar proyecto Go.
```bash
mkdir ~/min-instances && cd $_
```

### Crear codigo de funcion Go
Se usa para crear `main.go`.
```bash
touch main.go
```

### Crear modulo Go
Se usa para crear `go.mod`.
```bash
touch go.mod
```

### Desplegar funcion lenta sin min instances
Se usa para observar cold start inicial.
```bash
gcloud functions deploy slow-function \
  --gen2 \
  --runtime go123 \
  --entry-point HelloWorld \
  --source . \
  --region {{{project_0.default_region|Region}}} \
  --trigger-http \
  --allow-unauthenticated \
  --max-instances 4
```

### Primera invocacion de la funcion lenta
Se usa para medir latencia con cold start.
```bash
gcloud functions call slow-function \
  --gen2 \
  --region {{{project_0.default_region|Region}}}
```

### Segunda invocacion de la funcion lenta
Se usa para comparar latencia posterior al warm-up.
```bash
gcloud functions call slow-function \
  --gen2 \
  --region {{{project_0.default_region|Region}}}
```

### Instalar herramienta de carga hey
Se usa para enviar requests concurrentes.
```bash
sudo apt install hey
```

### Obtener URL de la funcion lenta
Se usa para guardarla en `SLOW_URL`.
```bash
SLOW_URL=$(gcloud functions describe slow-function --region {{{project_0.default_region|Region}}} --gen2 --format="value(serviceConfig.uri)")
```

### Ejecutar prueba de concurrencia sin ajuste de concurrency
Se usa para observar tiempos altos por escalado/cold start.
```bash
hey -n 10 -c 10 $SLOW_URL
```

### Eliminar servicio slow-function
Se usa para limpiar antes del siguiente despliegue.
```bash
gcloud run services delete slow-function --region {{{project_0.default_region | "Region"}}}
```

### Desplegar funcion con min instances para prueba de concurrency
Se usa para publicar `slow-concurrent-function`.
```bash
gcloud functions deploy slow-concurrent-function \
  --gen2 \
  --runtime go123 \
  --entry-point HelloWorld \
  --source . \
  --region {{{project_0.default_region|Region}}} \
  --trigger-http \
  --allow-unauthenticated \
  --min-instances 1 \
  --max-instances 4
```

### Obtener URL de la funcion concurrente
Se usa para guardarla en `SLOW_CONCURRENT_URL`.
```bash
SLOW_CONCURRENT_URL=$(gcloud functions describe slow-concurrent-function --region {{{project_0.default_region|Region}}} --gen2 --format="value(serviceConfig.uri)")
```

### Ejecutar prueba de concurrencia con servicio ajustado
Se usa para validar mejora de tiempos con concurrencia alta.
```bash
hey -n 10 -c 10 $SLOW_CONCURRENT_URL
```