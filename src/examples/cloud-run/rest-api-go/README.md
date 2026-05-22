# REST API con Go y Cloud Run

Practica basada en el lab GSP761. Despliega una REST API escrita en Go que expone datos de clientes desde Firestore, junto con el bucket de Cloud Storage usado para la importacion inicial de datos.

## Arquitectura

```
cliente HTTP
     │
     ▼
Cloud Run: rest-api (público)
  GET /v1/customer/{id}
     │
     ▼
Firestore: coleccion customers / treatments
```

## Pre-requisito: construir la imagen

La imagen se construye desde el repositorio [rosera/pet-theory](https://github.com/rosera/pet-theory), subdirectorio `lab08`:

```bash
git clone https://github.com/rosera/pet-theory.git
cd pet-theory/lab08

go build -o server

gcloud builds submit \
  --tag gcr.io/$PROJECT_ID/rest-api:0.2
```

## Uso

```bash
terraform init

terraform apply \
  -var="project_id=<PROJECT_ID>" \
  -var="rest_api_image=gcr.io/<PROJECT_ID>/rest-api:0.2"
```

## Importar datos de clientes a Firestore

Después del `apply`, importar el dataset de Qwiklabs:

```bash
gsutil cp -r gs://spls/gsp645/2019-10-06T20:10:37_43617 gs://<PROJECT_ID>-customer

gcloud beta firestore import gs://<PROJECT_ID>-customer/2019-10-06T20:10:37_43617/
```

## Probar el endpoint

```bash
API_URL=$(terraform output -raw rest_api_url)

# Health check
curl $API_URL/v1/

# Consultar cliente por ID
curl $API_URL/v1/customer/22521
```

## Variables requeridas

| Variable | Descripción |
|---|---|
| `project_id` | ID del proyecto GCP |
| `rest_api_image` | URI de la imagen construida con Cloud Build |
