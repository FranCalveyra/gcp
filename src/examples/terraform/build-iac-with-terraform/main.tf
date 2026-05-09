provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

locals {
  instance_base_name = "tf-instance"
  subnet_01_name     = "subnet-01"
  subnet_02_name     = "subnet-02"
  vm_names = {
    primary   = "${local.instance_base_name}-1"
    secondary = "${local.instance_base_name}-2"
  }
}

resource "google_project_service" "enabled" {
  for_each = toset([
    "compute.googleapis.com",
    "storage.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_storage_bucket" "tf_state" {
  name                        = var.bucket_name
  location                    = "US"
  uniform_bucket_level_access = true
  force_destroy               = true
  labels                      = var.labels

  depends_on = [google_project_service.enabled]
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 10.0"

  project_id   = var.project_id
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = local.subnet_01_name
      subnet_ip             = var.subnet_01_cidr
      subnet_region         = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name           = local.subnet_02_name
      subnet_ip             = var.subnet_02_cidr
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
      description           = "Subnet secundaria para práctica Build IaC"
    },
  ]

  depends_on = [google_project_service.enabled]
}

resource "google_service_account" "lab_vm_sa" {
  account_id   = "tf-build-iac-vm-sa"
  display_name = "Service Account for Build IaC Terraform example"
  project      = var.project_id
}

resource "google_project_iam_member" "vm_sa_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.lab_vm_sa.email}"
}

resource "google_compute_instance" "tf_instance_1" {
  name                      = local.vm_names.primary
  machine_type              = var.machine_type
  zone                      = var.zone
  allow_stopping_for_update = true
  tags                      = ["web"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-12"
      size  = 10
    }
  }

  network_interface {
    network    = module.vpc.network_name
    subnetwork = local.subnet_01_name
    access_config {}
  }

  service_account {
    email  = google_service_account.lab_vm_sa.email
    scopes = ["cloud-platform"]
  }

  depends_on = [
    module.vpc,
    google_project_iam_member.vm_sa_logging,
  ]
}

resource "google_compute_instance" "tf_instance_2" {
  name                      = local.vm_names.secondary
  machine_type              = var.machine_type
  zone                      = var.zone
  allow_stopping_for_update = true
  tags                      = ["web"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-12"
      size  = 10
    }
  }

  network_interface {
    network    = module.vpc.network_name
    subnetwork = local.subnet_02_name
    access_config {}
  }

  service_account {
    email  = google_service_account.lab_vm_sa.email
    scopes = ["cloud-platform"]
  }

  depends_on = [
    module.vpc,
    google_project_iam_member.vm_sa_logging,
  ]
}

resource "google_compute_instance" "tf_instance_3" {
  count                     = var.create_third_instance ? 1 : 0
  name                      = var.third_instance_name
  machine_type              = var.machine_type
  zone                      = var.zone
  allow_stopping_for_update = true
  tags                      = ["web"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-12"
      size  = 10
    }
  }

  network_interface {
    network    = module.vpc.network_name
    subnetwork = local.subnet_01_name
    access_config {}
  }

  service_account {
    email  = google_service_account.lab_vm_sa.email
    scopes = ["cloud-platform"]
  }

  depends_on = [
    module.vpc,
    google_project_iam_member.vm_sa_logging,
  ]
}

resource "google_compute_firewall" "tf_firewall" {
  name    = "tf-firewall"
  network = module.vpc.network_name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}
