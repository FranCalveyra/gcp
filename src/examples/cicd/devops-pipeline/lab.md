[Link al lab](https://www.skills.google/paths/12/course_templates/41/labs/613369)

## Recursos identificados

- APIs: `cloudbuild.googleapis.com`, `artifactregistry.googleapis.com`.
- Artifact Registry: repositorio `devops-repo` (formato Docker, regional).
- Cloud Build trigger: `devops-trigger` — se dispara en cada push a `main` del repositorio GitHub.
- Cloud Build config: `cloudbuild.yaml` que construye y pushea la imagen con tag `$COMMIT_SHA`.
- GitHub repository: `devops-repo` (privado) — fuente del código del pipeline.
- Imagen Docker: `$REGION-docker.pkg.dev/$PROJECT_ID/devops-repo/devops-image:$COMMIT_SHA`.
- Compute Engine VMs: dos instancias de prueba creadas manualmente para validar el deploy.

## Comandos ejecutados

### Instalar GitHub CLI
```bash
curl -sS https://webi.sh/gh | sh
```

### Autenticarse con GitHub
```bash
gh auth login
```

### Obtener username de GitHub y configurar git
```bash
GITHUB_USERNAME=$(gh api user -q ".login")
echo ${GITHUB_USERNAME}

git config --global user.name "${GITHUB_USERNAME}"
git config --global user.email "<YOUR_EMAIL>"
```

### Crear repositorio privado en GitHub y clonarlo
```bash
gh repo create devops-repo --private
gh repo clone devops-repo
cd devops-repo
```

### Crear repositorio Docker en Artifact Registry
```bash
gcloud artifacts repositories create devops-repo \
  --repository-format=docker \
  --location=$REGION
```

### Configurar autenticación Docker para Artifact Registry
```bash
gcloud auth configure-docker $REGION-docker.pkg.dev
```

### Agregar archivos de la aplicación Python (main.py, requirements.txt, Dockerfile, cloudbuild.yaml)
Se crean manualmente en el directorio clonado. El `Dockerfile` usa Python 3.13 con gunicorn:
```dockerfile
FROM python:3.13
WORKDIR /app
COPY . .
RUN pip install gunicorn
RUN pip install -r requirements.txt
ENV PORT=80
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 main:app
```

El `cloudbuild.yaml` construye y pushea la imagen usando `$COMMIT_SHA` como tag:
```yaml
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', '$REGION-docker.pkg.dev/$PROJECT_ID/devops-repo/devops-image:$COMMIT_SHA', '.']
images:
  - '$REGION-docker.pkg.dev/$PROJECT_ID/devops-repo/devops-image:$COMMIT_SHA'
options:
  logging: CLOUD_LOGGING_ONLY
```

### Primer commit y push
```bash
git add --all
git commit -a -m "Initial Commit"
git push origin main
```

### Build manual inicial (antes del trigger)
```bash
gcloud builds submit \
  --tag $REGION-docker.pkg.dev/$DEVSHELL_PROJECT_ID/devops-repo/devops-image:v0.1 .
```

### Commit con el Dockerfile (agrega soporte Docker)
```bash
git add Dockerfile
git commit -m "Added Docker Support"
git push origin main
```

### Crear el build trigger (devops-trigger) desde Cloud Console
El trigger conecta el repositorio GitHub con Cloud Build usando `cloudbuild.yaml`.
Se configura en: Cloud Build → Triggers → Create Trigger → GitHub (App).

### Probar que el trigger funciona
```bash
git commit -a -m "Testing Build Trigger"
git push origin main
```
