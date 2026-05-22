# Conversor de PDFs con Go y Cloud Run

Practica basada en el lab GSP762. Despliega un servicio Cloud Run que convierte documentos a PDF usando LibreOffice, implementado en Go. El flujo es event-driven: subir un archivo al bucket de upload dispara automáticamente la conversión.

## Arquitectura

```
gsutil cp archivo.docx gs://<PROJECT_ID>-upload/
        │
        ▼ OBJECT_FINALIZE
  Pub/Sub topic: new-doc
        │ push autenticado
        ▼
  Cloud Run: pdf-converter (privado, 2Gi)
        │
        ▼
  gs://<PROJECT_ID>-processed/<archivo>.pdf
```

> Diferencia con el lab `pdf-converter` (GSP644): mismo patrón de arquitectura, pero la implementación del servidor usa Go en lugar de Node.js, y el código fuente es `Deleplace/pet-theory lab03`.

## Pre-requisito: construir la imagen

```bash
git clone https://github.com/Deleplace/pet-theory.git
cd pet-theory/lab03

go build -o server

gcloud builds submit \
  --tag gcr.io/$PROJECT_ID/pdf-converter
```

## Uso

```bash
terraform init

terraform apply \
  -var="project_id=<PROJECT_ID>" \
  -var="pdf_converter_image=gcr.io/<PROJECT_ID>/pdf-converter"
```

## Probar el flujo

```bash
# Subir un documento al bucket de upload
gsutil cp mi-documento.docx gs://$(terraform output -raw upload_bucket)/

# Verificar que el PDF apareció en el bucket de procesados
gsutil ls gs://$(terraform output -raw processed_bucket)/
```

## Variables requeridas

| Variable | Descripción |
|---|---|
| `project_id` | ID del proyecto GCP |
| `pdf_converter_image` | URI de la imagen construida con Cloud Build |

## Nota sobre memoria

LibreOffice requiere al menos 2Gi de RAM. La variable `cloud_run_memory` tiene ese valor como default — no reducirlo o el servicio fallará con OOM.
