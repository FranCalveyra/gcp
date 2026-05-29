output "load_balancer_ip" {
  description = "External IPv4 address of the Network Load Balancer."
  value       = google_compute_address.network_lb_ip_1.address
}
