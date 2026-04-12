provider "google" {
  project = var.project_id
  region  = var.region_1
  zone    = var.zone_1
}

locals {
  common_labels = var.labels
}

resource "google_project_service" "enabled" {
  for_each = toset([
    "compute.googleapis.com",
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_compute_network" "managementnet" {
  name                    = var.managementnet_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"

  depends_on = [google_project_service.enabled]
}

resource "google_compute_subnetwork" "managementsubnet_1" {
  name          = "managementsubnet-1"
  ip_cidr_range = var.management_subnet_cidr
  region        = var.region_1
  network       = google_compute_network.managementnet.id
}

resource "google_compute_network" "privatenet" {
  name                    = var.privatenet_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"

  depends_on = [google_project_service.enabled]
}

resource "google_compute_subnetwork" "privatesubnet_1" {
  name          = "privatesubnet-1"
  ip_cidr_range = var.private_subnet_1_cidr
  region        = var.region_1
  network       = google_compute_network.privatenet.id
}

resource "google_compute_subnetwork" "privatesubnet_2" {
  name          = "privatesubnet-2"
  ip_cidr_range = var.private_subnet_2_cidr
  region        = var.region_2
  network       = google_compute_network.privatenet.id
}

resource "google_compute_network" "mynetwork" {
  name                    = var.mynetwork_name
  auto_create_subnetworks = true
  routing_mode            = "REGIONAL"

  depends_on = [google_project_service.enabled]
}

data "google_compute_subnetwork" "mynetwork_region_1" {
  name   = var.region_1
  region = var.region_1

  depends_on = [google_compute_network.mynetwork]
}

data "google_compute_subnetwork" "mynetwork_region_2" {
  name   = var.region_2
  region = var.region_2

  depends_on = [google_compute_network.mynetwork]
}

resource "google_compute_firewall" "managementnet_allow_icmp_ssh_rdp" {
  name    = "managementnet-allow-icmp-ssh-rdp"
  network = google_compute_network.managementnet.name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }
}

resource "google_compute_firewall" "privatenet_allow_icmp_ssh_rdp" {
  name    = "privatenet-allow-icmp-ssh-rdp"
  network = google_compute_network.privatenet.name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }
}

resource "google_compute_firewall" "mynetwork_allow_icmp_ssh_rdp" {
  name    = "mynetwork-allow-icmp-ssh-rdp"
  network = google_compute_network.mynetwork.name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }
}

resource "google_compute_firewall" "mynetwork_allow_icmp_internal" {
  name    = "mynetwork-allow-icmp-internal"
  network = google_compute_network.mynetwork.name

  direction = "INGRESS"
  priority  = 1000

  source_ranges = [var.mynet_internal_source_range]

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_instance" "managementnet_vm_1" {
  name         = "managementnet-vm-1"
  machine_type = var.standard_machine_type
  zone         = var.zone_1
  labels       = merge(local.common_labels, { role = "management" })

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.managementsubnet_1.id

    access_config {}
  }
}

resource "google_compute_instance" "privatenet_vm_1" {
  name         = "privatenet-vm-1"
  machine_type = var.standard_machine_type
  zone         = var.zone_1
  labels       = merge(local.common_labels, { role = "private" })

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.privatesubnet_1.id

    access_config {}
  }
}

resource "google_compute_instance" "mynet_vm_1" {
  name         = "mynet-vm-1"
  machine_type = var.standard_machine_type
  zone         = var.zone_1
  labels       = merge(local.common_labels, { role = "mynet-1" })

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.mynetwork_region_1.id

    access_config {}
  }

  depends_on = [google_compute_firewall.mynetwork_allow_icmp_internal]
}

resource "google_compute_instance" "mynet_vm_2" {
  name         = "mynet-vm-2"
  machine_type = var.standard_machine_type
  zone         = var.zone_2
  labels       = merge(local.common_labels, { role = "mynet-2" })

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.mynetwork_region_2.id

    access_config {}
  }

  depends_on = [google_compute_firewall.mynetwork_allow_icmp_internal]
}

resource "google_compute_instance" "vm_appliance" {
  name         = "vm-appliance"
  machine_type = var.appliance_machine_type
  zone         = var.zone_1
  labels       = merge(local.common_labels, { role = "appliance" })

  boot_disk {
    initialize_params {
      image = var.instance_image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.privatesubnet_1.id

    access_config {}
  }

  network_interface {
    subnetwork = google_compute_subnetwork.managementsubnet_1.id
  }

  network_interface {
    subnetwork = data.google_compute_subnetwork.mynetwork_region_1.id
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y net-tools
  EOT

  depends_on = [
    google_compute_firewall.managementnet_allow_icmp_ssh_rdp,
    google_compute_firewall.privatenet_allow_icmp_ssh_rdp,
    google_compute_firewall.mynetwork_allow_icmp_internal,
  ]
}
