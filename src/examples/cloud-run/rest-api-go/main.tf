provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "enabled" {
  for_each           = var.enabled_services
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_storage_bucket" "customer_data" {
  name          = "${var.project_id}-customer"
  location      = var.region
  storage_class = "STANDARD"
  project       = var.project_id
  labels        = var.labels

  uniform_bucket_level_access = true

  depends_on = [google_project_service.enabled]
}

resource "google_firestore_database" "default" {
  project     = var.project_id
  name        = "(default)"
  location_id = var.firestore_location
  type        = "FIRESTORE_NATIVE"

  depends_on = [google_project_service.enabled]
}

resource "google_cloud_run_v2_service" "rest_api" {
  name     = var.service_name
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"
  labels   = var.labels

  template {
    scaling {
      max_instance_count = var.max_instances
    }

    containers {
      image = var.rest_api_image

      env {
        name  = "PROJECT_ID"
        value = var.project_id
      }
    }
  }

  depends_on = [
    google_project_service.enabled,
    google_firestore_database.default,
  ]
}

resource "google_cloud_run_v2_service_iam_member" "rest_api_public" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.rest_api.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
