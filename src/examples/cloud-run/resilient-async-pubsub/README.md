# Sistema asíncrono resiliente con Cloud Run y Pub/Sub

Practica basada en el lab GSP650. Despliega un sistema de fan-out donde un productor publica reportes en Pub/Sub y dos consumidores independientes (email y SMS) los procesan en paralelo via push subscriptions autenticadas.

## Arquitectura

```
lab-report-service (público)
        │
        ▼
  Pub/Sub topic: new-lab-report
        │
   ┌────┴────┐
   ▼         ▼
email-service  sms-service
(privado)     (privado)
```

## Pre-requisito: construir imágenes

Los servicios usan código del repositorio [rosera/pet-theory](https://github.com/rosera/pet-theory). Construir y pushear las imágenes antes de aplicar Terraform:

```bash
git clone https://github.com/rosera/pet-theory
cd pet-theory/lab05/lab-service && npm install
gcloud builds submit --tag gcr.io/$PROJECT_ID/lab-report-service

cd ../email-service && npm install
gcloud builds submit --tag gcr.io/$PROJECT_ID/email-service

cd ../sms-service && npm install
gcloud builds submit --tag gcr.io/$PROJECT_ID/sms-service
```

## Uso

```bash
terraform init

terraform apply -var="project_id=<PROJECT_ID>" \
  -var="lab_report_service_image=gcr.io/<PROJECT_ID>/lab-report-service" \
  -var="email_service_image=gcr.io/<PROJECT_ID>/email-service" \
  -var="sms_service_image=gcr.io/<PROJECT_ID>/sms-service"
```

## Probar el flujo

```bash
LAB_URL=$(terraform output -raw lab_report_service_url)

curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"id": 12, "status": "pending"}' \
  $LAB_URL/v1/report
```

Los logs de `email-service` y `sms-service` en Cloud Logging deben mostrar el mensaje recibido.

## Variables requeridas

| Variable | Descripción |
|---|---|
| `project_id` | ID del proyecto GCP |
| `lab_report_service_image` | URI de imagen del productor |
| `email_service_image` | URI de imagen del consumidor email |
| `sms_service_image` | URI de imagen del consumidor SMS |
