# Get Started with Vertex AI Studio

Práctica Terraform basada en el lab [Get Started with Vertex AI Studio (GSP1154)](https://www.skills.google/course_templates/552/labs/604755).

El lab es **UI-driven**: se trabaja en la consola de Vertex AI Studio para diseñar prompts, deployar una app con Cloud Run y explorar capacidades multimodales con Gemini. Esta práctica Terraform modela el estado de infraestructura previo al lab: APIs habilitadas y service account listo.

## Recursos creados

| Recurso | Tipo | Descripción |
|---|---|---|
| `aiplatform.googleapis.com` | API | Vertex AI API |
| `cloudbuild.googleapis.com` | API | Cloud Build API |
| `run.googleapis.com` | API | Cloud Run API |
| `texttospeech.googleapis.com` | API (opcional) | Cloud Text-to-Speech API |
| `insurance-risk-summary-sa` | `google_service_account` | SA para el servicio Cloud Run |
| IAM binding | `roles/aiplatform.user` | Permiso de SA para invocar Vertex AI |

## Uso

```bash
terraform init
terraform plan -var="project_id=<TU_PROYECTO>"
terraform apply -var="project_id=<TU_PROYECTO>"
```

Para habilitar también la Text-to-Speech API (tarea 5 opcional):

```bash
terraform apply -var="project_id=<TU_PROYECTO>" -var="enable_tts_api=true"
```

## Variables principales

| Variable | Default | Descripción |
|---|---|---|
| `project_id` | — | ID del proyecto GCP (obligatoria) |
| `region` | `us-central1` | Región de Cloud Run |
| `cloud_run_service_name` | `insurance-risk-summary` | Nombre del servicio Cloud Run |
| `allow_unauthenticated` | `true` | Acceso público al servicio (igual que el deploy desde Studio) |
| `enable_tts_api` | `false` | Habilitar Text-to-Speech API (tarea 5 opcional) |

## Flujo del lab (resumen)

1. **Tarea 1**: Crear prompt de chat → deployar como app Cloud Run.
2. **Tarea 2**: Zero-shot y few-shot prompting; ajustar temperatura, tokens, Top-P.
3. **Tarea 3**: Comparar variaciones de prompts con la feature Compare.
4. **Tarea 4**: Analizar imagen (`timetable.png`) desde Cloud Storage con Gemini multimodal.
5. **Tarea 5**: Generar imagen con Imagen 4; síntesis de voz con Chirp 3 (opcional).
