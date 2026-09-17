resource "google_artifact_registry_repository" "apps" {
  location      = var.primary_region
  repository_id = "sre-apps"
  description   = "Assessment application container images"
  format        = "DOCKER"
  depends_on    = [google_project_service.required]
}

resource "google_bigquery_dataset" "logs" {
  dataset_id                 = "sre_observability"
  location                   = "US"
  description                = "GKE and application logs routed from Cloud Logging"
  delete_contents_on_destroy = true
  default_table_expiration_ms = 2592000000
  labels                     = var.labels
}

resource "google_logging_project_sink" "bigquery" {
  name                   = "gke-logs-to-bigquery"
  destination            = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.logs.dataset_id}"
  unique_writer_identity = true
  filter = <<-EOT
    resource.type="k8s_container"
    resource.labels.namespace_name="sre-demo"
  EOT
}

resource "google_bigquery_dataset_iam_member" "sink_writer" {
  dataset_id = google_bigquery_dataset.logs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.bigquery.writer_identity
}

