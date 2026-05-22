[Link al lab](https://www.skills.google/paths/12/course_templates/741/labs/592445)

## Recursos identificados

- APIs: `run.googleapis.com`, `pubsub.googleapis.com`, `iam.googleapis.com`.
- Cloud Run services:
  - `lab-report-service` (público) — productor, recibe reportes y los publica en Pub/Sub.
  - `email-service` (privado) — consumidor, envía notificaciones por email.
  - `sms-service` (privado) — consumidor, envía notificaciones por SMS.
- Pub/Sub topic: `new-lab-report`.
- Pub/Sub subscriptions push:
  - `email-service-sub` → push autenticado a `email-service`.
  - `sms-service-sub` → push autenticado a `sms-service`.
- IAM service account: `pubsub-cloud-run-invoker`.
- IAM bindings:
  - `roles/run.invoker` sobre `email-service` para `pubsub-cloud-run-invoker`.
  - `roles/run.invoker` sobre `sms-service` para `pubsub-cloud-run-invoker`.
  - `roles/iam.serviceAccountTokenCreator` para el service agent de Pub/Sub del proyecto.
- Código fuente: repositorio [`rosera/pet-theory`](https://github.com/rosera/pet-theory).

## Comandos ejecutados

### Verificar la cuenta activa
```bash
gcloud auth list
```

### Verificar el proyecto activo
```bash
gcloud config list project
```

### Habilitar la API de Cloud Run
```bash
gcloud services enable run.googleapis.com
```

### Clonar repositorio pet-theory
```bash
git clone https://github.com/rosera/pet-theory
```

### Crear topic de Pub/Sub
```bash
gcloud pubsub topics create new-lab-report
```

### Desplegar lab-report-service (productor público)
Se construye la imagen localmente y se despliega como servicio público.
```bash
gcloud run deploy lab-report-service \
  --image gcr.io/$GOOGLE_CLOUD_PROJECT/lab-report-service \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --max-instances=1
```

### Desplegar email-service (consumidor privado)
```bash
gcloud run deploy email-service \
  --image gcr.io/$GOOGLE_CLOUD_PROJECT/email-service \
  --platform managed \
  --region us-central1 \
  --no-allow-unauthenticated \
  --max-instances=1
```

### Desplegar sms-service (consumidor privado)
```bash
gcloud run deploy sms-service \
  --image gcr.io/$GOOGLE_CLOUD_PROJECT/sms-service \
  --platform managed \
  --region us-central1 \
  --no-allow-unauthenticated \
  --max-instances=1
```

### Crear service account invocadora
```bash
gcloud iam service-accounts create pubsub-cloud-run-invoker \
  --display-name "PubSub Cloud Run Invoker"
```

### Asignar rol run.invoker sobre email-service
```bash
gcloud run services add-iam-policy-binding email-service \
  --member=serviceAccount:pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
  --role=roles/run.invoker \
  --region us-central1 \
  --platform managed
```

### Asignar rol run.invoker sobre sms-service
```bash
gcloud run services add-iam-policy-binding sms-service \
  --member=serviceAccount:pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
  --role=roles/run.invoker \
  --region us-central1 \
  --platform managed
```

### Obtener número de proyecto
```bash
PROJECT_NUMBER=$(gcloud projects list \
  --filter="qwiklabs-gcp" \
  --format='value(PROJECT_NUMBER)')
```

### Permitir creación de tokens para el service agent de Pub/Sub
```bash
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
  --member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com \
  --role=roles/iam.serviceAccountTokenCreator
```

### Obtener URL de email-service
```bash
EMAIL_SERVICE_URL=$(gcloud run services describe email-service \
  --platform managed \
  --region us-central1 \
  --format="value(status.address.url)")
```

### Crear suscripción push hacia email-service
```bash
gcloud pubsub subscriptions create email-service-sub \
  --topic new-lab-report \
  --push-endpoint=$EMAIL_SERVICE_URL \
  --push-auth-service-account=pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
```

### Obtener URL de sms-service
```bash
SMS_SERVICE_URL=$(gcloud run services describe sms-service \
  --platform managed \
  --region us-central1 \
  --format="value(status.address.url)")
```

### Crear suscripción push hacia sms-service
```bash
gcloud pubsub subscriptions create sms-service-sub \
  --topic new-lab-report \
  --push-endpoint=$SMS_SERVICE_URL \
  --push-auth-service-account=pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
```

### Obtener URL de lab-report-service
```bash
LAB_REPORT_SERVICE_URL=$(gcloud run services describe lab-report-service \
  --platform managed \
  --region us-central1 \
  --format="value(status.address.url)")
```

### Probar el flujo completo enviando un reporte
```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"id": 12, "status": "pending"}' \
  $LAB_REPORT_SERVICE_URL/v1/report
```
