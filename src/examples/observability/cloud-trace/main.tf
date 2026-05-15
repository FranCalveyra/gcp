provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "enabled" {
  for_each = toset([
    "container.googleapis.com",
    "cloudtrace.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_container_cluster" "cloud_trace_demo" {
  name     = var.cluster_name
  location = var.zone

  # Eliminar el node pool por defecto para usar uno administrado
  remove_default_node_pool = true
  initial_node_count       = 1

  resource_labels = var.labels

  depends_on = [google_project_service.enabled]
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "${var.cluster_name}-nodes"
  location = var.zone
  cluster  = google_container_cluster.cloud_trace_demo.name

  node_count = var.node_count

  node_config {
    machine_type = var.machine_type

    # El scope cloudtrace.append permite que la app exporte spans a Cloud Trace
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = var.labels
  }
}
