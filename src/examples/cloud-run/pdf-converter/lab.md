[Link al lab](https://www.skills.google/paths/12/course_templates/741/labs/592444)

## Recursos identificados

- APIs: `run.googleapis.com`, `pubsub.googleapis.com`, `cloudbuild.googleapis.com`, `storage.googleapis.com`.
- Cloud Run service: `pdf-converter` (privado, con variable de entorno `PDF_BUCKET`).
- Artifact Registry: imagen `gcr.io/$GOOGLE_CLOUD_PROJECT/pdf-converter` construida con Cloud Build.
- Cloud Storage: bucket de upload (`$GOOGLE_CLOUD_PROJECT-upload`), bucket de procesados (`$GOOGLE_CLOUD_PROJECT-processed`).
- Pub/Sub: topic `new-doc`, suscripcion push `pdf-conv-sub`.
- IAM service account: `pubsub-cloud-run-invoker`.
- IAM bindings:
  - `roles/run.invoker` sobre `pdf-converter` para la service account invocadora.
  - `roles/iam.serviceAccountTokenCreator` para la Pub/Sub service agent del proyecto.
- Notificacion de Cloud Storage sobre evento `OBJECT_FINALIZE` → Pub/Sub topic `new-doc`.

## Comandos ejecutados

### Clonar el repositorio de Pet Theory
Se usa para obtener el codigo fuente del lab.
```bash
git clone https://github.com/rosera/pet-theory.git
cd pet-theory/lab03
```

### Instalar dependencias Node.js
Se usan para el servidor Express y la integracion con Cloud Storage.
```bash
npm install express
npm install body-parser
npm install child_process
npm install @google-cloud/storage
```

### Construir la imagen del contenedor (primera version)
Se usa para empaquetar la app Node.js y subirla a Artifact Registry.
```bash
gcloud builds submit \
  --tag gcr.io/$GOOGLE_CLOUD_PROJECT/pdf-converter
```

### Desplegar la primera revision del servicio
Se usa para exponer el endpoint privado del convertidor de PDFs.
```bash
gcloud run deploy pdf-converter \
  --image gcr.io/$GOOGLE_CLOUD_PROJECT/pdf-converter \
  --platform managed \
  --region $REGION \
  --no-allow-unauthenticated \
  --max-instances=1
```

### Obtener la URL del servicio
Se usa para guardar el endpoint en una variable de entorno.
```bash
SERVICE_URL=$(gcloud beta run services describe pdf-converter \
  --platform managed \
  --region $REGION \
  --format="value(status.url)")
echo $SERVICE_URL
```

### Verificar que el acceso anonimo esta bloqueado
Se espera un error 403, lo cual confirma que el servicio es privado.
```bash
curl -X POST $SERVICE_URL
```

### Invocar el servicio como usuario autenticado
Se usa para verificar que el servicio responde correctamente con credenciales validas.
```bash
curl -X POST -H "Authorization: Bearer $(gcloud auth print-identity-token)" $SERVICE_URL
```

### Crear el bucket de upload
Se usa como staging area para los archivos a convertir.
```bash
gsutil mb gs://$GOOGLE_CLOUD_PROJECT-upload
```

### Crear el bucket de procesados
Se usa para almacenar los PDFs generados por el servicio.
```bash
gsutil mb gs://$GOOGLE_CLOUD_PROJECT-processed
```

### Configurar notificacion de Pub/Sub sobre el bucket de upload
Se usa para que Cloud Storage publique un evento en el topic `new-doc` al finalizar cada upload.
```bash
gsutil notification create \
  -t new-doc \
  -f json \
  -e OBJECT_FINALIZE \
  gs://$GOOGLE_CLOUD_PROJECT-upload
```

### Crear la service account invocadora
Se usa para que Pub/Sub pueda invocar el servicio Cloud Run de forma autenticada.
```bash
gcloud iam service-accounts create pubsub-cloud-run-invoker \
  --display-name "PubSub Cloud Run Invoker"
```

### Asignar rol de invoker al service account
Se usa para autorizar a la service account a llamar al servicio `pdf-converter`.
```bash
gcloud beta run services add-iam-policy-binding pdf-converter \
  --member=serviceAccount:pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com \
  --role=roles/run.invoker \
  --platform managed \
  --region $REGION
```

### Obtener el numero de proyecto
Se usa para construir el email de la service agent administrada de Pub/Sub.
```bash
gcloud projects list
PROJECT_NUMBER=[project number]
```

### Habilitar Cloud Pub/Sub API
Se usa para activar la API si no estaba habilitada.
```bash
gcloud services enable pubsub.googleapis.com --project=$GOOGLE_CLOUD_PROJECT
```

### Permitir que Pub/Sub genere tokens de autenticacion
Se usa para que la service agent de Pub/Sub firme tokens OIDC al hacer push.
```bash
gcloud projects add-iam-policy-binding $GOOGLE_CLOUD_PROJECT \
  --member=serviceAccount:service-$PROJECT_NUMBER@gcp-sa-pubsub.iam.gserviceaccount.com \
  --role=roles/iam.serviceAccountTokenCreator
```

### Crear la suscripcion push hacia el servicio
Se usa para conectar el topic `new-doc` con el endpoint del convertidor, con autenticacion OIDC.
```bash
gcloud beta pubsub subscriptions create pdf-conv-sub \
  --topic new-doc \
  --push-endpoint=$SERVICE_URL \
  --push-auth-service-account=pubsub-cloud-run-invoker@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
```

### Copiar archivos de prueba al bucket de upload
Se usa para disparar el flujo de conversion y verificar el comportamiento end-to-end.
```bash
gsutil -m cp gs://spls/gsp644/* gs://$GOOGLE_CLOUD_PROJECT-upload
```

### Limpiar el bucket de upload
Se usa para preparar la siguiente iteracion de pruebas.
```bash
gsutil -m rm gs://$GOOGLE_CLOUD_PROJECT-upload/*
```

### Construir la imagen con LibreOffice (version final)
Se usa para agregar el paquete `libreoffice` al contenedor y habilitar la conversion real de archivos.
```bash
gcloud builds submit \
  --tag gcr.io/$GOOGLE_CLOUD_PROJECT/pdf-converter
```

### Desplegar la revision final con LibreOffice y variable de entorno
Se usa para actualizar el servicio con 2 GB de RAM y la variable `PDF_BUCKET` que indica donde guardar los PDFs.
```bash
gcloud run deploy pdf-converter \
  --image gcr.io/$GOOGLE_CLOUD_PROJECT/pdf-converter \
  --platform managed \
  --region $REGION \
  --memory=2Gi \
  --no-allow-unauthenticated \
  --max-instances=1 \
  --set-env-vars PDF_BUCKET=$GOOGLE_CLOUD_PROJECT-processed
```

### Verificar el servicio actualizado
Se usa para confirmar que la nueva revision responde correctamente.
```bash
curl -X POST -H "Authorization: Bearer $(gcloud auth print-identity-token)" $SERVICE_URL
```

### Script para copiar archivos con delay y verificar conversion
Se usa para subir los archivos uno a uno con pausa de 5 segundos y observar la conversion en tiempo real.
```bash
cat <<'EOF' > copy_files.sh
#!/bin/bash
SOURCE_BUCKET="gs://spls/gsp644"
DESTINATION_BUCKET="gs://${GOOGLE_CLOUD_PROJECT}-upload"
DELAY=5
files=$(gsutil ls "$SOURCE_BUCKET")
for file in $files; do
  gsutil cp "$file" "$DESTINATION_BUCKET"
  if [ $? -eq 0 ]; then
    echo "Copied: $file to $DESTINATION_BUCKET"
  else
    echo "Failed to copy: $file"
  fi
  sleep $DELAY
done
echo "All files copied!"
EOF

bash copy_files.sh
```
