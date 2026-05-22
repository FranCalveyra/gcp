provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_project" "current" {
  project_id = var.project_id
}

# Service agent de Pub/Sub — necesita crear tokens OIDC para el push autenticado.
# Service agent de GCS — necesita publicar en el topic de Pub/Sub.
data "google_storage_project_service_account" "gcs_agent" {
  project = var.project_id
}

locals {
  upload_bucket_name    = "${var.project_id}-${var.upload_bucket_suffix}"
  processed_bucket_name = "${var.project_id}-${var.processed_bucket_suffix}"
  pubsub_service_agent  = "service-${data.google_project.current.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

# ── APIs ──────────────────────────────────────────────────────────────────────

resource "google_project_service" "enabled" {
  for_each           = var.enabled_services
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

# ── Cloud Storage ─────────────────────────────────────────────────────────────

resource "google_storage_bucket" "upload" {
  name                        = local.upload_bucket_name
  location                    = var.region
  project                     = var.project_id
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = var.labels

  depends_on = [google_project_service.enabled]
}

resource "google_storage_bucket" "processed" {
  name                        = local.processed_bucket_name
  location                    = var.region
  project                     = var.project_id
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = var.labels

  depends_on = [google_project_service.enabled]
}

# ── Pub/Sub ───────────────────────────────────────────────────────────────────

resource "google_pubsub_topic" "new_doc" {
  name    = var.pubsub_topic_name
  project = var.project_id

  depends_on = [google_project_service.enabled]
}

# La service account de GCS necesita publicar en el topic para enviar notificaciones.
resource "google_pubsub_topic_iam_member" "gcs_publisher" {
  project = var.project_id
  topic   = google_pubsub_topic.new_doc.name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_agent.email_address}"
}

# Notificacion de Cloud Storage: dispara un mensaje en `new-doc` cuando un objeto finaliza su upload.
resource "google_storage_notification" "upload_trigger" {
  bucket         = google_storage_bucket.upload.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.new_doc.id
  event_types    = ["OBJECT_FINALIZE"]

  depends_on = [google_pubsub_topic_iam_member.gcs_publisher]
}

# ── IAM ───────────────────────────────────────────────────────────────────────

resource "google_service_account" "invoker" {
  project      = var.project_id
  account_id   = var.invoker_sa_id
  display_name = "PubSub Cloud Run Invoker"
}

# Permite a la service agent de Pub/Sub crear tokens OIDC para push autenticado.
resource "google_project_iam_member" "pubsub_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${local.pubsub_service_agent}"
}

# ── Cloud Run ─────────────────────────────────────────────────────────────────

resource "google_cloud_run_v2_service" "pdf_converter" {
  name     = var.cloud_run_service_name
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"
  labels   = var.labels

  template {
    containers {
      image = var.pdf_converter_image

      resources {
        limits = {
          memory = var.cloud_run_memory
        }
      }

      env {
        name  = "PDF_BUCKET"
        value = local.processed_bucket_name
      }
    }

    max_instance_request_concurrency = 1
  }

  depends_on = [google_project_service.enabled]
}

# Solo la service account invocadora puede llamar al servicio.
resource "google_cloud_run_v2_service_iam_member" "invoker_binding" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.pdf_converter.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.invoker.email}"
}

# ── Pub/Sub subscription ──────────────────────────────────────────────────────

resource "google_pubsub_subscription" "pdf_conv_sub" {
  name    = var.subscription_name
  topic   = google_pubsub_topic.new_doc.name
  project = var.project_id

  push_config {
    push_endpoint = google_cloud_run_v2_service.pdf_converter.uri

    oidc_token {
      service_account_email = google_service_account.invoker.email
    }
  }

  depends_on = [
    google_cloud_run_v2_service_iam_member.invoker_binding,
    google_project_iam_member.pubsub_token_creator,
  ]
}
