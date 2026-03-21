# Terraform Example: Pub/Sub with Cloud Run

Este ejemplo implementa la arquitectura del lab **Cloud Pub Sub With Cloud Run** con Terraform.

## Qué despliega

- APIs necesarias (`run`, `pubsub`, `iam`).
- Cloud Run `store-service` (público).
- Cloud Run `order-service` (privado).
- Topic de Pub/Sub `ORDER_PLACED`.
- Subscription push hacia `order-service`.
- Service account invocadora + IAM bindings requeridos.

## Uso rápido

1. Inicializá:

```bash
terraform init
```

2. Creá `terraform.tfvars`:

```hcl
project_id = "tu-project-id"
region     = "us-central1"
```

3. Plan y apply:

```bash
terraform plan
terraform apply
```

## Salidas útiles

El ejemplo expone por `outputs`:

- URL de `store-service`
- URL de `order-service`
- nombre del topic
- nombre de la subscription
- email de la service account invocadora
