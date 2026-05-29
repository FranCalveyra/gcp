provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

locals {
  log_bucket_destination = "logging.googleapis.com/projects/${var.project_id}/locations/${var.log_bucket_location}/buckets/${var.log_bucket_id}"
}

resource "google_project_service" "enabled" {
  for_each           = var.enabled_services
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_container_cluster" "day2_ops" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  remove_default_node_pool = true
  initial_node_count       = 1

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  deletion_protection = false

  depends_on = [google_project_service.enabled]
}

resource "google_container_node_pool" "primary" {
  name       = var.node_pool_name
  cluster    = google_container_cluster.day2_ops.name
  location   = google_container_cluster.day2_ops.location
  project    = var.project_id
  node_count = var.node_count

  node_config {
    machine_type = var.node_machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  depends_on = [google_container_cluster.day2_ops]
}

resource "google_logging_project_bucket_config" "log_analytics" {
  project          = var.project_id
  location         = var.log_bucket_location
  bucket_id        = var.log_bucket_id
  retention_days   = var.log_bucket_retention_days
  enable_analytics = true

  depends_on = [google_project_service.enabled]
}

resource "google_logging_linked_dataset" "log_analytics" {
  bucket  = google_logging_project_bucket_config.log_analytics.id
  link_id = var.linked_dataset_id

  depends_on = [google_logging_project_bucket_config.log_analytics]
}

resource "google_logging_project_sink" "k8s_to_bucket" {
  name        = var.sink_name
  destination = local.log_bucket_destination
  filter      = var.sink_filter

  depends_on = [google_logging_project_bucket_config.log_analytics]
}

resource "google_project_iam_member" "sink_bucket_writer" {
  project = var.project_id
  role    = "roles/logging.bucketWriter"
  member  = google_logging_project_sink.k8s_to_bucket.writer_identity

  depends_on = [google_logging_project_sink.k8s_to_bucket]
}

