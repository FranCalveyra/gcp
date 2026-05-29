# DevOps Pipeline con Cloud Build y Artifact Registry

Practica basada en el lab "Building a DevOps Pipeline" (curso 41). Crea la infraestructura CI/CD que construye y publica automáticamente una imagen Docker en Artifact Registry cada vez que se hace push a la rama `main` de un repositorio GitHub.

## Arquitectura

```
git push → GitHub repo (devops-repo)
               │
               ▼ webhook (Cloud Build GitHub App)
         Cloud Build trigger (devops-trigger)
               │ usa cloudbuild.yaml
               ▼
         Artifact Registry (devops-repo)
         $REGION-docker.pkg.dev/$PROJECT_ID/devops-repo/devops-image:$COMMIT_SHA
```

## Pre-requisito: conectar GitHub a Cloud Build

El trigger usa la Cloud Build GitHub App, que requiere una conexión OAuth manual:

1. Ir a **Cloud Build → Triggers → Manage repositories** en Cloud Console.
2. Conectar la cuenta GitHub y autorizar el repositorio `devops-repo`.
3. Recién después ejecutar `terraform apply`.

Sin este paso, el trigger falla con un error de permisos sobre el repositorio GitHub.

## Uso

```bash
terraform init

terraform apply \
  -var="project_id=<PROJECT_ID>" \
  -var="github_owner=<GITHUB_USERNAME>"
```

## cloudbuild.yaml esperado en el repositorio

El repositorio GitHub debe contener un `cloudbuild.yaml` en la raíz:

```yaml
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'REGION-docker.pkg.dev/PROJECT_ID/devops-repo/devops-image:$COMMIT_SHA', '.']
images:
  - 'REGION-docker.pkg.dev/PROJECT_ID/devops-repo/devops-image:$COMMIT_SHA'
options:
  logging: CLOUD_LOGGING_ONLY
```

## Probar el pipeline

```bash
# En el repositorio GitHub clonado localmente:
git commit -a -m "Testing Build Trigger"
git push origin main

# Verificar que se disparó el build:
gcloud builds list --region=$REGION --limit=5

# Ver la imagen publicada:
gcloud artifacts docker images list \
  $(terraform output -raw artifact_registry_url)
```

## Variables requeridas

| Variable | Descripción |
|---|---|
| `project_id` | ID del proyecto GCP |
| `github_owner` | Usuario u organización dueña del repo GitHub |
