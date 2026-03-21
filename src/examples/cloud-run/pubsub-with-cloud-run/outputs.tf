output "store_service_url" {
  description = "URL publica de store-service."
  value       = google_cloud_run_v2_service.store.uri
}

output "order_service_url" {
  description = "URL privada de order-service."
  value       = google_cloud_run_v2_service.order.uri
}

output "pubsub_topic" {
  description = "Nombre del topic de Pub/Sub."
  value       = google_pubsub_topic.order_placed.name
}

output "pubsub_subscription" {
  description = "Nombre de la suscripcion push."
  value       = google_pubsub_subscription.order_service_push.name
}

output "invoker_service_account_email" {
  description = "Email de la service account usada para invocar order-service."
  value       = google_service_account.pubsub_cloud_run_invoker.email
}
