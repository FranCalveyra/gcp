provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

locals {
  required_services = toset([
    "compute.googleapis.com",
    "iam.googleapis.com",
  ])

  devops_permissions = [
    "compute.instances.create",
    "compute.instances.delete",
    "compute.instances.start",
    "compute.instances.stop",
    "compute.instances.update",
    "compute.disks.create",
    "compute.subnetworks.use",
    "compute.subnetworks.useExternalIp",
    "compute.instances.setMetadata",
    "compute.instances.setServiceAccount",
  ]

  user_roles = toset([
    "roles/viewer",
    "roles/iam.serviceAccountUser",
  ])

  service_account_roles = toset([
    "roles/iam.serviceAccountUser",
    "roles/compute.instanceAdmin",
  ])

  target_network    = "projects/${var.project_id}/global/networks/${var.network_name}"
  target_subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/${var.subnetwork_name}"
}

resource "google_project_service" "enabled" {
  for_each = local.required_services

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_project_iam_custom_role" "devops" {
  project     = var.project_id
  role_id     = var.custom_role_id
  title       = var.custom_role_title
  description = "Permisos inspirados en el lab Configuring IAM Permissions with gcloud."
  permissions = local.devops_permissions
  stage       = "GA"

  depends_on = [google_project_service.enabled]
}

resource "google_project_iam_member" "user_roles" {
  for_each = local.user_roles

  project = var.project_id
  role    = each.value
  member  = "user:${var.user2_email}"

  depends_on = [google_project_service.enabled]
}

resource "google_project_iam_member" "user_devops" {
  project = var.project_id
  role    = google_project_iam_custom_role.devops.name
  member  = "user:${var.user2_email}"

  depends_on = [google_project_iam_custom_role.devops]
}

resource "google_service_account" "devops" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name

  depends_on = [google_project_service.enabled]
}

resource "google_project_iam_member" "service_account_roles" {
  for_each = local.service_account_roles

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.devops.email}"

  depends_on = [google_service_account.devops]
}

resource "google_compute_instance" "lab_3" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.instance_tags
  labels       = merge(var.labels, { role = "iam-lab" })

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    network    = local.target_network
    subnetwork = local.target_subnetwork

    access_config {}
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  service_account {
    email  = google_service_account.devops.email
    scopes = var.service_account_scopes
  }

  depends_on = [
    google_project_service.enabled,
    google_project_iam_member.user_roles,
    google_project_iam_member.user_devops,
    google_project_iam_member.service_account_roles,
  ]
}
