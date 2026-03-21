provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_project" "current" {
  project_id = var.project_id
}

locals {
  pubsub_service_agent = "service-${data.google_project.current.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_project_service" "enabled" {
  for_each           = var.enabled_services
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_service_account" "pubsub_cloud_run_invoker" {
  project      = var.project_id
  account_id   = var.invoker_service_account_id
  display_name = "Order Initiator"
}

resource "google_cloud_run_v2_service" "store" {
  name     = var.store_service_name
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"
  labels   = var.labels

  template {
    containers {
      image = var.store_service_image
    }
  }

  depends_on = [google_project_service.enabled]
}

resource "google_cloud_run_v2_service" "order" {
  name     = var.order_service_name
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"
  labels   = var.labels

  template {
    containers {
      image = var.order_service_image
    }
  }

  depends_on = [google_project_service.enabled]
}

resource "google_cloud_run_v2_service_iam_member" "store_public_invoker" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.store.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_v2_service_iam_member" "order_invoker_sa" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.order.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.pubsub_cloud_run_invoker.email}"
}

resource "google_pubsub_topic" "order_placed" {
  name = var.topic_name

  depends_on = [google_project_service.enabled]
}

resource "google_project_iam_member" "pubsub_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${local.pubsub_service_agent}"
}

resource "google_pubsub_subscription" "order_service_push" {
  name  = var.subscription_name
  topic = google_pubsub_topic.order_placed.name

  push_config {
    push_endpoint = google_cloud_run_v2_service.order.uri

    oidc_token {
      service_account_email = google_service_account.pubsub_cloud_run_invoker.email
    }
  }

  depends_on = [
    google_cloud_run_v2_service_iam_member.order_invoker_sa,
    google_project_iam_member.pubsub_token_creator,
  ]
}
