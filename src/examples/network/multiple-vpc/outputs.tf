output "network_names" {
  description = "Nombres de las VPCs creadas por el ejemplo."
  value = {
    managementnet = google_compute_network.managementnet.name
    privatenet    = google_compute_network.privatenet.name
    mynetwork     = google_compute_network.mynetwork.name
  }
}

output "subnetwork_names" {
  description = "Subredes creadas o usadas por el ejemplo."
  value = {
    managementsubnet_1 = google_compute_subnetwork.managementsubnet_1.name
    privatesubnet_1    = google_compute_subnetwork.privatesubnet_1.name
    privatesubnet_2    = google_compute_subnetwork.privatesubnet_2.name
    mynetwork_region_1 = data.google_compute_subnetwork.mynetwork_region_1.name
    mynetwork_region_2 = data.google_compute_subnetwork.mynetwork_region_2.name
  }
}

output "vm_internal_ips" {
  description = "IPs internas principales de las VMs."
  value = {
    managementnet_vm_1 = google_compute_instance.managementnet_vm_1.network_interface[0].network_ip
    privatenet_vm_1    = google_compute_instance.privatenet_vm_1.network_interface[0].network_ip
    mynet_vm_1         = google_compute_instance.mynet_vm_1.network_interface[0].network_ip
    mynet_vm_2         = google_compute_instance.mynet_vm_2.network_interface[0].network_ip
    vm_appliance_nic0  = google_compute_instance.vm_appliance.network_interface[0].network_ip
    vm_appliance_nic1  = google_compute_instance.vm_appliance.network_interface[1].network_ip
    vm_appliance_nic2  = google_compute_instance.vm_appliance.network_interface[2].network_ip
  }
}

output "vm_external_ips" {
  description = "IPs externas de las VMs con salida pública."
  value = {
    managementnet_vm_1 = google_compute_instance.managementnet_vm_1.network_interface[0].access_config[0].nat_ip
    privatenet_vm_1    = google_compute_instance.privatenet_vm_1.network_interface[0].access_config[0].nat_ip
    mynet_vm_1         = google_compute_instance.mynet_vm_1.network_interface[0].access_config[0].nat_ip
    mynet_vm_2         = google_compute_instance.mynet_vm_2.network_interface[0].access_config[0].nat_ip
    vm_appliance       = google_compute_instance.vm_appliance.network_interface[0].access_config[0].nat_ip
  }
}

output "firewall_rule_names" {
  description = "Nombres de las firewall rules creadas."
  value = [
    google_compute_firewall.managementnet_allow_icmp_ssh_rdp.name,
    google_compute_firewall.privatenet_allow_icmp_ssh_rdp.name,
    google_compute_firewall.mynetwork_allow_icmp_ssh_rdp.name,
    google_compute_firewall.mynetwork_allow_icmp_internal.name,
  ]
}
