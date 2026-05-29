# Ejemplo SDK: Cloud Storage en Python

A diferencia del resto de las prácticas de esta carpeta, **este ejemplo no es un lab ni Terraform**: es un módulo de Python que muestra cómo interactuar con Cloud Storage usando el SDK oficial (`google-cloud-storage`).

## Qué incluye

- `main.py` — funciones `upload_blob` y `download_blob` que suben y descargan objetos de un bucket usando `storage.Client()`.
- `pyproject.toml` / `uv.lock` — dependencias gestionadas con [uv](https://docs.astral.sh/uv/).

## Cómo correrlo

```bash
# Autenticación local (Application Default Credentials)
gcloud auth application-default login

# Instalar dependencias con uv
uv sync

# Usar las funciones desde un REPL o script
uv run python -c "from main import upload_blob; upload_blob('<BUCKET>', 'local.txt', 'remoto.txt')"
```

## Recomendaciones

- El SDK usa Application Default Credentials: asegurate de estar autenticado y con el proyecto correcto.
- `upload_blob` usa `if_generation_match=0`, por lo que falla si el objeto ya existe (subida idempotente de primera escritura).
