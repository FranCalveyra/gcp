provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "random_id" "bucket_suffix" {
  byte_length = 3
}

locals {
  bucket_name = "${var.bucket_name_prefix}-${var.project_id}-${random_id.bucket_suffix.hex}"

  common_labels = merge(var.labels, {
    bucket = var.bucket_name_prefix
  })
}

resource "google_project_service" "enabled" {
  for_each = var.enabled_services

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_storage_bucket" "lab_bucket" {
  name                        = local.bucket_name
  project                     = var.project_id
  location                    = var.bucket_location
  force_destroy               = true
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  labels                      = local.common_labels

  depends_on = [google_project_service.enabled]
}

resource "google_storage_bucket_object" "sample" {
  bucket       = google_storage_bucket.lab_bucket.name
  name         = var.sample_object_name
  content      = var.sample_object_content
  content_type = "text/plain"
}

resource "google_storage_bucket_iam_member" "limited_storage_viewer" {
  count = var.limited_storage_member == null ? 0 : 1

  bucket = google_storage_bucket.lab_bucket.name
  role   = "roles/storage.objectViewer"
  member = var.limited_storage_member
}

resource "google_service_account" "read_bucket_objects" {
  account_id   = var.service_account_id
  display_name = "Read bucket objects"

  depends_on = [google_project_service.enabled]
}

resource "google_storage_bucket_iam_member" "service_account_bucket_access" {
  for_each = var.service_account_bucket_roles

  bucket = google_storage_bucket.lab_bucket.name
  role   = each.value
  member = "serviceAccount:${google_service_account.read_bucket_objects.email}"
}

resource "google_service_account_iam_member" "service_account_user" {
  count = var.service_account_user_member == null ? 0 : 1

  service_account_id = google_service_account.read_bucket_objects.name
  role               = "roles/iam.serviceAccountUser"
  member             = var.service_account_user_member
}

resource "google_project_iam_member" "compute_instance_admin" {
  count = var.compute_instance_admin_member == null ? 0 : 1

  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = var.compute_instance_admin_member
}

resource "google_compute_instance" "demoiam" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  labels       = local.common_labels

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnetwork_name

    access_config {}
  }

  service_account {
    email = google_service_account.read_bucket_objects.email
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_write",
    ]
  }

  depends_on = [
    google_project_service.enabled,
    google_storage_bucket_object.sample,
    google_storage_bucket_iam_member.service_account_bucket_access,
  ]
}
