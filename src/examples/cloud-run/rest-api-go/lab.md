[Link al lab](https://www.skills.google/paths/12/course_templates/741/labs/592446)

## Recursos identificados

- APIs: `run.googleapis.com`, `cloudbuild.googleapis.com`, `firestore.googleapis.com`.
- Cloud Run service: `rest-api` (público, dos versiones: 0.1 y 0.2).
- Cloud Storage bucket: `$PROJECT_ID-customer` (importación de datos a Firestore).
- Firestore: base de datos en modo nativo, ubicación `nam5`.
- Código fuente: repositorio [`rosera/pet-theory`](https://github.com/rosera/pet-theory), subdirectorio `lab08`.
- Imagen construida con Cloud Build y almacenada en Container Registry.

## Comandos ejecutados

### Configurar el proyecto activo
```bash
gcloud config set project $GOOGLE_CLOUD_PROJECT
```

### Habilitar APIs necesarias
```bash
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
```

### Clonar repositorio pet-theory e ir a lab08
```bash
git clone https://github.com/rosera/pet-theory.git
cd pet-theory/lab08
```

### Construir el binario Go (v0.1)
El `main.go` inicial expone solo un endpoint `/v1/` que devuelve `{status: 'running'}`.
```bash
go build -o server
```

### Enviar imagen v0.1 a Container Registry con Cloud Build
```bash
gcloud builds submit \
  --tag gcr.io/$GOOGLE_CLOUD_PROJECT/rest-api:0.1
```

### Desplegar v0.1 en Cloud Run (público)
```bash
gcloud run deploy rest-api \
  --image gcr.io/$GOOGLE_CLOUD_PROJECT/rest-api:0.1 \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --max-instances=2
```

### Crear bucket de Cloud Storage para importar datos de clientes
```bash
gsutil mb -c standard -l $REGION gs://$GOOGLE_CLOUD_PROJECT-customer
```

### Copiar dataset de clientes al bucket
El dataset viene de un bucket público de Qwiklabs.
```bash
gsutil cp -r gs://spls/gsp645/2019-10-06T20:10:37_43617 gs://$GOOGLE_CLOUD_PROJECT-customer
```

### Crear base de datos Firestore en modo nativo
```bash
gcloud firestore databases create --location nam5
```

### Importar datos de clientes desde Cloud Storage a Firestore
```bash
gcloud beta firestore import gs://$GOOGLE_CLOUD_PROJECT-customer/2019-10-06T20:10:37_43617/
```

### Construir el binario Go (v0.2)
El `main.go` actualizado conecta con Firestore y expone `/v1/customer/{id}` para consultar tratamientos.
```bash
go build -o server
```

### Enviar imagen v0.2 a Container Registry con Cloud Build
```bash
gcloud builds submit \
  --tag gcr.io/$GOOGLE_CLOUD_PROJECT/rest-api:0.2
```

### Desplegar v0.2 en Cloud Run
```bash
gcloud run deploy rest-api \
  --image gcr.io/$GOOGLE_CLOUD_PROJECT/rest-api:0.2 \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --max-instances=2
```
