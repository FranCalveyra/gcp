# Terraform Example: PDF Converter con Cloud Run

Este ejemplo implementa la arquitectura del lab **Build a Serverless App with Cloud Run that Creates PDF Files** (GSP644) con Terraform.

## Qué despliega

- APIs necesarias (`run`, `pubsub`, `cloudbuild`, `storage`).
- Bucket de upload (`<project_id>-upload`) con notificacion Pub/Sub en `OBJECT_FINALIZE`.
- Bucket de procesados (`<project_id>-processed`) donde se guardan los PDFs.
- Topic de Pub/Sub `new-doc`.
- Cloud Run `pdf-converter` (privado, 2 GB RAM, variable `PDF_BUCKET`).
- Service account `pubsub-cloud-run-invoker` + bindings IAM.
- Suscripcion push `pdf-conv-sub` con autenticacion OIDC.

## Pre-requisito: construir la imagen

Terraform no construye la imagen. Antes de hacer `apply`, ejecutá desde el directorio `pet-theory/lab03`:

```bash
git clone https://github.com/rosera/pet-theory.git
cd pet-theory/lab03
gcloud builds submit --tag gcr.io/<PROJECT_ID>/pdf-converter
```

## Uso rápido

1. Inicializá:

```bash
terraform init
```

2. Creá `terraform.tfvars`:

```hcl
project_id          = "tu-project-id"
region              = "us-central1"
pdf_converter_image = "gcr.io/tu-project-id/pdf-converter"
```

3. Plan y apply:

```bash
terraform plan
terraform apply
```

## Salidas útiles

El ejemplo expone por `outputs`:

- URL del servicio `pdf-converter`
- Nombre del bucket de upload
- Nombre del bucket de procesados
- Nombre del topic y la suscripcion Pub/Sub
- Email de la service account invocadora
