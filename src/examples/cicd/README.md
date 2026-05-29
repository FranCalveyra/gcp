# CI/CD

Prácticas Terraform para pipelines de integración y entrega continua en Google Cloud (curso "Reliable Google Cloud Infrastructure: Design and Process").

| Práctica | Descripción |
|---|---|
| [DevOps Pipeline con Cloud Build](./devops-pipeline/README.md) | Cloud Build trigger + Artifact Registry conectado a GitHub |

## Uso rápido

```bash
cd <practica>
terraform init
terraform plan -var="project_id=<PROJECT_ID>"
terraform apply -var="project_id=<PROJECT_ID>"
```

## Recomendaciones

- Revisar el README de cada práctica antes de hacer `apply` — algunas requieren pasos manuales previos (por ejemplo, conectar GitHub a Cloud Build).
- Usar `terraform destroy` al terminar para evitar costos innecesarios.
