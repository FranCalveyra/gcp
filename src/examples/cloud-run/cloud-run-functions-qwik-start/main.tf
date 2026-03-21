provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_project" "current" {
  project_id = var.project_id
}

data "google_storage_project_service_account" "gcs_account" {
  project = var.project_id
}

locals {
  event_bucket_name  = coalesce(var.event_bucket_name, "gcf-gen2-storage-${var.project_id}")
  compute_default_sa = "${data.google_project.current.number}-compute@developer.gserviceaccount.com"

  functions = {
    nodejs_http = {
      name          = "nodejs-http-function"
      runtime       = "nodejs22"
      entry_point   = "helloWorld"
      source_object = var.source_objects["nodejs_http"]
      trigger_type  = "http"
      timeout       = 600
      min_instances = 0
      max_instances = 1
      concurrency   = 1
      env_vars      = {}
    }
    nodejs_storage = {
      name          = "nodejs-storage-function"
      runtime       = "nodejs22"
      entry_point   = "helloStorage"
      source_object = var.source_objects["nodejs_storage"]
      trigger_type  = "storage"
      timeout       = 60
      min_instances = 0
      max_instances = 1
      concurrency   = 1
      env_vars      = {}
    }
    gce_vm_labeler = {
      name          = "gce-vm-labeler"
      runtime       = "nodejs22"
      entry_point   = "labelVmCreation"
      source_object = var.source_objects["gce_vm_labeler"]
      trigger_type  = "audit"
      timeout       = 60
      min_instances = 0
      max_instances = 1
      concurrency   = 1
      env_vars      = {}
    }
    hello_world_colored = {
      name          = "hello-world-colored"
      runtime       = "python311"
      entry_point   = "hello_world"
      source_object = var.source_objects["hello_world_colored"]
      trigger_type  = "http"
      timeout       = 60
      min_instances = 0
      max_instances = 1
      concurrency   = 1
      env_vars = {
        COLOR = "orange"
      }
    }
    slow_function = {
      name          = "slow-function"
      runtime       = "go123"
      entry_point   = "HelloWorld"
      source_object = var.source_objects["slow_function"]
      trigger_type  = "http"
      timeout       = 60
      min_instances = 0
      max_instances = 4
      concurrency   = 1
      env_vars      = {}
    }
    slow_concurrent_function = {
      name          = "slow-concurrent-function"
      runtime       = "go123"
      entry_point   = "HelloWorld"
      source_object = var.source_objects["slow_concurrent_function"]
      trigger_type  = "http"
      timeout       = 60
      min_instances = 1
      max_instances = 4
      concurrency   = 100
      env_vars      = {}
    }
  }
}

resource "google_project_service" "enabled" {
  for_each           = var.enabled_services
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_storage_bucket" "events" {
  name                        = local.event_bucket_name
  location                    = var.region
  project                     = var.project_id
  uniform_bucket_level_access = true
  force_destroy               = true
  labels                      = var.labels

  depends_on = [google_project_service.enabled]
}

resource "google_project_iam_member" "storage_pubsub_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

resource "google_project_iam_member" "compute_eventarc_receiver" {
  project = var.project_id
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${local.compute_default_sa}"
}

resource "google_cloudfunctions2_function" "functions" {
  for_each = local.functions

  name     = each.value.name
  location = var.region
  project  = var.project_id

  build_config {
    runtime     = each.value.runtime
    entry_point = each.value.entry_point

    source {
      storage_source {
        bucket = var.source_bucket_name
        object = each.value.source_object
      }
    }
  }

  service_config {
    timeout_seconds                  = each.value.timeout
    available_memory                 = "256M"
    min_instance_count               = each.value.min_instances
    max_instance_count               = each.value.max_instances
    max_instance_request_concurrency = each.value.concurrency
    ingress_settings                 = "ALLOW_ALL"
    environment_variables            = each.value.env_vars
  }

  dynamic "event_trigger" {
    for_each = each.value.trigger_type == "storage" ? [1] : []
    content {
      trigger_region = var.region
      event_type     = "google.cloud.storage.object.v1.finalized"
      retry_policy   = "RETRY_POLICY_DO_NOT_RETRY"

      event_filters {
        attribute = "bucket"
        value     = google_storage_bucket.events.name
      }
    }
  }

  dynamic "event_trigger" {
    for_each = each.value.trigger_type == "audit" ? [1] : []
    content {
      trigger_region        = var.region
      event_type            = "google.cloud.audit.log.v1.written"
      retry_policy          = "RETRY_POLICY_DO_NOT_RETRY"
      service_account_email = local.compute_default_sa

      event_filters {
        attribute = "serviceName"
        value     = "compute.googleapis.com"
      }

      event_filters {
        attribute = "methodName"
        value     = "beta.compute.instances.insert"
      }
    }
  }

  depends_on = [
    google_project_service.enabled,
    google_project_iam_member.storage_pubsub_publisher,
    google_project_iam_member.compute_eventarc_receiver,
  ]
}
