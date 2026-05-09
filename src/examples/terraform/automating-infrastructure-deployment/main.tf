locals {
  vm_definitions = {
    for idx, name in var.vm_names :
    name => {
      zone = var.zones[idx]
    }
  }
}

resource "google_project_service" "compute" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "mynetwork" {
  name                    = var.network_name
  auto_create_subnetworks = true

  depends_on = [google_project_service.compute]
}

resource "google_compute_firewall" "allow_http_ssh_rdp_icmp" {
  name    = var.firewall_name
  network = google_compute_network.mynetwork.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vms" {
  for_each     = local.vm_definitions
  name         = each.key
  zone         = each.value.zone
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  network_interface {
    network = google_compute_network.mynetwork.self_link

    access_config {}
  }
}
