provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "bigquery" {
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
}

resource "google_bigquery_dataset" "nyctaxi" {
  dataset_id    = var.dataset_id
  project       = var.project_id
  location      = var.region
  friendly_name = "NYC Taxi Trips"
  description   = "Dataset de viajes en taxi NYC — lab Loading Data into BigQuery."
  labels        = var.labels

  depends_on = [google_project_service.bigquery]
}

resource "google_bigquery_table" "trips_2018" {
  dataset_id          = google_bigquery_dataset.nyctaxi.dataset_id
  table_id            = "2018trips"
  project             = var.project_id
  deletion_protection = false
  labels              = var.labels

  external_data_configuration {
    autodetect    = true
    source_format = "CSV"
    source_uris   = [var.gcs_source_uri]

    csv_options {
      skip_leading_rows = 1
      quote             = "\""
    }
  }
}

locals {
  january_query = <<-EOT
    SELECT * FROM `${var.project_id}.${var.dataset_id}.2018trips`
    WHERE EXTRACT(Month FROM pickup_datetime) = 1
  EOT
}

resource "google_bigquery_table" "january_trips" {
  dataset_id          = google_bigquery_dataset.nyctaxi.dataset_id
  table_id            = "january_trips"
  project             = var.project_id
  deletion_protection = false
  labels              = var.labels

  view {
    query          = local.january_query
    use_legacy_sql = false
  }

  depends_on = [google_bigquery_table.trips_2018]
}
