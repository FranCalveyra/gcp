provider "google" {
  project = var.project_id
  region  = var.region
}

resource "random_id" "bucket_suffix" {
  byte_length = 3
}

locals {
  bucket_name = "${var.bucket_name_prefix}-${var.project_id}-${random_id.bucket_suffix.hex}"

  sample_objects = {
    "setup.html"  = "<html><body><h1>Cloud Storage Lab</h1><p>setup</p></body></html>"
    "setup2.html" = "<html><body><h1>Cloud Storage Lab</h1><p>setup2</p></body></html>"
    "setup3.html" = "<html><body><h1>Cloud Storage Lab</h1><p>setup3</p></body></html>"
  }
}

resource "google_storage_bucket" "lab_bucket" {
  name                        = local.bucket_name
  project                     = var.project_id
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
  public_access_prevention    = "inherited"
  labels                      = var.labels

  versioning {
    enabled = var.enable_versioning
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = var.lifecycle_delete_age_days
    }
  }
}

resource "google_storage_bucket_object" "samples" {
  for_each = var.upload_sample_objects ? local.sample_objects : {}

  bucket       = google_storage_bucket.lab_bucket.name
  name         = each.key
  content      = each.value
  content_type = "text/html"
}

resource "google_storage_bucket_iam_member" "public_read_setup" {
  count = var.make_sample_public ? 1 : 0

  bucket = google_storage_bucket.lab_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
