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
  display_name = "PubSub Cloud Run Invoker"
}

# Productor: recibe reportes y los publica en Pub/Sub
resource "google_cloud_run_v2_service" "lab_report" {
  name     = var.lab_report_service_name
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"
  labels   = var.labels

  template {
    containers {
      image = var.lab_report_service_image
    }
  }

  depends_on = [google_project_service.enabled]
}

# Consumidor 1: notificaciones email
resource "google_cloud_run_v2_service" "email" {
  name     = var.email_service_name
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"
  labels   = var.labels

  template {
    containers {
      image = var.email_service_image
    }
  }

  depends_on = [google_project_service.enabled]
}

# Consumidor 2: notificaciones SMS
resource "google_cloud_run_v2_service" "sms" {
  name     = var.sms_service_name
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"
  labels   = var.labels

  template {
    containers {
      image = var.sms_service_image
    }
  }

  depends_on = [google_project_service.enabled]
}

resource "google_cloud_run_v2_service_iam_member" "lab_report_public" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.lab_report.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_v2_service_iam_member" "email_invoker_sa" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.email.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.pubsub_cloud_run_invoker.email}"
}

resource "google_cloud_run_v2_service_iam_member" "sms_invoker_sa" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.sms.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.pubsub_cloud_run_invoker.email}"
}

resource "google_pubsub_topic" "lab_report" {
  name    = var.topic_name
  project = var.project_id

  depends_on = [google_project_service.enabled]
}

# Permite al service agent de Pub/Sub firmar tokens OIDC para las push subscriptions
resource "google_project_iam_member" "pubsub_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${local.pubsub_service_agent}"
}

resource "google_pubsub_subscription" "email_service_push" {
  name    = "email-service-sub"
  topic   = google_pubsub_topic.lab_report.name
  project = var.project_id

  push_config {
    push_endpoint = google_cloud_run_v2_service.email.uri

    oidc_token {
      service_account_email = google_service_account.pubsub_cloud_run_invoker.email
    }
  }

  depends_on = [
    google_cloud_run_v2_service_iam_member.email_invoker_sa,
    google_project_iam_member.pubsub_token_creator,
  ]
}

resource "google_pubsub_subscription" "sms_service_push" {
  name    = "sms-service-sub"
  topic   = google_pubsub_topic.lab_report.name
  project = var.project_id

  push_config {
    push_endpoint = google_cloud_run_v2_service.sms.uri

    oidc_token {
      service_account_email = google_service_account.pubsub_cloud_run_invoker.email
    }
  }

  depends_on = [
    google_cloud_run_v2_service_iam_member.sms_invoker_sa,
    google_project_iam_member.pubsub_token_creator,
  ]
}
