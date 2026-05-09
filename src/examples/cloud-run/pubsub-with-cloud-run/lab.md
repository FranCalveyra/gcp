[Link al lab](https://www.skills.google/paths/12/course_templates/559/labs/564964)

## Recursos identificados

- APIs: `run.googleapis.com` (y uso de `pubsub.googleapis.com` en operaciones de Pub/Sub).
- Cloud Run services: `store-service` (público), `order-service` (privado).
- Pub/Sub: topic `ORDER_PLACED`, subscription push `order-service-sub`.
- IAM service account: `pubsub-cloud-run-invoker`.
- IAM bindings:
  - `roles/run.invoker` sobre `order-service` para la service account invocadora.
  - `roles/iam.serviceAccountTokenCreator` para la Pub/Sub service agent del proyecto.
- Integración push autenticada Pub/Sub -> Cloud Run con `--push-auth-service-account`.

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

### Habilitar la API de Cloud Run
Se usa para poder desplegar servicios en Cloud Run.
```bash
gcloud services enable run.googleapis.com
```

### Definir region en variable de entorno
Se usa para reutilizar la misma region en todo el lab.
```bash
LOCATION={{{project_0.default_region|REGION}}}
```

### Configurar region por defecto de gcloud
Se usa para evitar pasar la region manualmente en cada comando.
```bash
gcloud config set compute/region $LOCATION
```

### Desplegar servicio publico store-service
Se usa para publicar el productor accesible sin autenticacion.
```bash
gcloud run deploy store-service \
  --image gcr.io/qwiklabs-resources/gsp724-store-service \
  --region $LOCATION \
  --allow-unauthenticated
```

### Desplegar servicio privado order-service
Se usa para publicar el consumidor solo para cuentas autenticadas.
```bash
gcloud run deploy order-service \
  --image gcr.io/qwiklabs-resources/gsp724-order-service \
  --region $LOCATION \
  --no-allow-unauthenticated
```

### Crear topic de Pub/Sub
Se usa para recibir eventos de ordenes creadas.
```bash
gcloud pubsub topics create ORDER_PLACED
```

### Crear service account invocadora
Se usa para que Pub/Sub pueda invocar `order-service`.
```bash
gcloud iam service-accounts create pubsub-cloud-run-invoker \
  --display-name "Order Initiator"
```

### Listar service account creada
Se usa para confirmar que la cuenta existe.
```bash
gcloud iam service-accounts list --filter="Order Initiator"
```

### Asignar rol Cloud Run Invoker al service account
Se usa para permitir invocar `order-service`.
```bash
gcloud run services add-iam-policy-binding order-service \
  --region $LOCATION \
  --member=serviceAccount:pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
  --role=roles/run.invoker \
  --platform managed
```

### Obtener numero de proyecto
Se usa para guardarlo en la variable `PROJECT_NUMBER`.
```bash
PROJECT_NUMBER=$(gcloud projects list \
  --filter="qwiklabs-gcp" \
  --format='value(PROJECT_NUMBER)')
```

### Permitir creacion de tokens para Pub/Sub
Se usa para que la service account administrada de Pub/Sub firme tokens.
```bash
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
  --member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com \
  --role=roles/iam.serviceAccountTokenCreator
```

### Obtener URL de order-service
Se usa para guardarla en `ORDER_SERVICE_URL`.
```bash
ORDER_SERVICE_URL=$(gcloud run services describe order-service \
  --region $LOCATION \
  --format="value(status.address.url)")
```

### Crear suscripcion push hacia order-service
Se usa para conectar el topic con el endpoint privado usando autenticacion.
```bash
gcloud pubsub subscriptions create order-service-sub \
  --topic ORDER_PLACED \
  --push-endpoint=$ORDER_SERVICE_URL \
  --push-auth-service-account=pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
```

### Obtener URL de store-service
Se usa para guardarla en `STORE_SERVICE_URL`.
```bash
STORE_SERVICE_URL=$(gcloud run services describe store-service \
  --region $LOCATION \
  --format="value(status.address.url)")
```

### Enviar payload de prueba al productor
Se usa para publicar una orden y validar el flujo completo.
```bash
curl -X POST -H "Content-Type: application/json" -d @test.json $STORE_SERVICE_URL
```
