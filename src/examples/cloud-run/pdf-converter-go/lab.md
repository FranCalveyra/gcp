[Link al lab](https://www.skills.google/paths/12/course_templates/741/labs/592447)

## Recursos identificados

- APIs: `run.googleapis.com`, `cloudbuild.googleapis.com`, `storage-component.googleapis.com`.
- Cloud Run service: `pdf-converter` (privado, 2Gi RAM, variable de entorno `PDF_BUCKET`).
- Cloud Storage:
  - bucket `$PROJECT_ID-upload` — recibe archivos subidos, dispara notificaciones Pub/Sub.
  - bucket `$PROJECT_ID-processed` — destino de los PDFs convertidos.
- Pub/Sub topic: `new-doc` (creado via notificación de GCS).
- Pub/Sub subscription push: `pdf-conv-sub` → `pdf-converter`.
- IAM service account: `pubsub-cloud-run-invoker`.
- IAM bindings:
  - `roles/run.invoker` sobre `pdf-converter` para `pubsub-cloud-run-invoker`.
  - `roles/iam.serviceAccountTokenCreator` para el service agent de Pub/Sub del proyecto.
- Código fuente: repositorio [`Deleplace/pet-theory`](https://github.com/Deleplace/pet-theory), subdirectorio `lab03`. Implementación en Go con LibreOffice para la conversión.

## Comandos ejecutados

### Habilitar APIs necesarias
```bash
gcloud services enable cloudbuild.googleapis.com
gcloud services enable storage-component.googleapis.com
gcloud services enable run.googleapis.com
```

### Verificar cuenta activa
```bash
gcloud auth list --filter=status:ACTIVE --format="value(account)"
```

### Clonar repositorio e ir al subdirectorio
```bash
git clone https://github.com/Deleplace/pet-theory.git
cd pet-theory/lab03
```

### Construir el binario Go
El `server.go` implementa la conversión de documentos a PDF usando LibreOffice.
```bash
go build -o server
```

### Enviar imagen a Container Registry con Cloud Build
```bash
gcloud builds submit \
  --tag gcr.io/$GOOGLE_CLOUD_PROJECT/pdf-converter
```

### Desplegar pdf-converter en Cloud Run (privado)
El servicio requiere 2Gi de RAM por LibreOffice. Máximo 3 instancias simultáneas.
```bash
gcloud run deploy pdf-converter \
  --image gcr.io/$GOOGLE_CLOUD_PROJECT/pdf-converter \
  --platform managed \
  --region $REGION \
  --memory=2Gi \
  --no-allow-unauthenticated \
  --set-env-vars PDF_BUCKET=$GOOGLE_CLOUD_PROJECT-processed \
  --max-instances=3
```

### Crear notificación Pub/Sub en el bucket de upload
Cada `OBJECT_FINALIZE` en el bucket dispara un mensaje al topic `new-doc`.
```bash
gsutil notification create \
  -t new-doc \
  -f json \
  -e OBJECT_FINALIZE \
  gs://$GOOGLE_CLOUD_PROJECT-upload
```

### Crear service account invocadora
```bash
gcloud iam service-accounts create pubsub-cloud-run-invoker \
  --display-name "PubSub Cloud Run Invoker"
```

### Asignar rol run.invoker sobre pdf-converter
```bash
gcloud run services add-iam-policy-binding pdf-converter \
  --member=serviceAccount:pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
  --role=roles/run.invoker \
  --region $REGION \
  --platform managed
```

### Obtener número de proyecto
```bash
PROJECT_NUMBER=$(gcloud projects list \
  --format="value(PROJECT_NUMBER)" \
  --filter="$GOOGLE_CLOUD_PROJECT")
```

### Permitir creación de tokens para el service agent de Pub/Sub
```bash
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
  --member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com \
  --role=roles/iam.serviceAccountTokenCreator
```

### Obtener URL del servicio
```bash
SERVICE_URL=$(gcloud run services describe pdf-converter \
  --platform managed \
  --region $REGION \
  --format "value(status.url)")
```

### Crear suscripción push hacia pdf-converter
```bash
gcloud pubsub subscriptions create pdf-conv-sub \
  --topic new-doc \
  --push-endpoint=$SERVICE_URL \
  --push-auth-service-account=pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
```
