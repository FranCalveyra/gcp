provider "google" {
  project = var.project_id
  region  = var.region
}

# APIs requeridas por el lab
resource "google_project_service" "vertex_ai" {
  service            = "aiplatform.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloud_build" {
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloud_run" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "tts" {
  count              = var.enable_tts_api ? 1 : 0
  service            = "texttospeech.googleapis.com"
  disable_on_destroy = false
}

# Service account para la app Cloud Run deployada desde Vertex AI Studio
resource "google_service_account" "cloud_run_sa" {
  account_id   = "${var.cloud_run_service_name}-sa"
  display_name = "SA para ${var.cloud_run_service_name} (Vertex AI Studio deploy)"
  project      = var.project_id

  depends_on = [google_project_service.cloud_run]
}

resource "google_project_iam_member" "vertex_ai_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

locals {
  cloud_run_invoker = var.allow_unauthenticated ? "allUsers" : null
}

# IAM para acceso público al servicio Cloud Run (equivalente al deploy desde Studio)
resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  count = var.allow_unauthenticated ? 1 : 0

  project  = var.project_id
  location = var.region
  name     = var.cloud_run_service_name
  role     = "roles/run.invoker"
  member   = "allUsers"

  depends_on = [google_project_service.cloud_run]
}
