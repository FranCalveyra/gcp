provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  image_base = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repo_id}/${var.image_name}"
}

resource "google_project_service" "enabled" {
  for_each           = var.enabled_services
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "devops_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = var.artifact_registry_repo_id
  format        = "DOCKER"
  labels        = var.labels

  depends_on = [google_project_service.enabled]
}

# Permite a Cloud Build pushear imagenes al repositorio de Artifact Registry.
resource "google_artifact_registry_repository_iam_member" "cloudbuild_writer" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.devops_repo.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${data.google_project.current.number}@cloudbuild.gserviceaccount.com"
}

data "google_project" "current" {
  project_id = var.project_id
}

# Trigger conectado a GitHub via Cloud Build GitHub App.
# Pre-requisito: conectar el repositorio GitHub en Cloud Build > Triggers > Manage repositories.
resource "google_cloudbuild_trigger" "devops_trigger" {
  project  = var.project_id
  name     = var.trigger_name
  location = var.region

  github {
    owner = var.github_owner
    name  = var.github_repo_name

    push {
      branch = var.branch_pattern
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _REGION = var.region
  }

  depends_on = [
    google_project_service.enabled,
    google_artifact_registry_repository.devops_repo,
  ]
}
