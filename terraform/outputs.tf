output "cluster_commands" {
  value = {
    primary   = "gcloud container clusters get-credentials ${google_container_cluster.clusters["primary"].name} --zone ${var.primary_zone} --project ${var.project_id}"
    secondary = "gcloud container clusters get-credentials ${google_container_cluster.clusters["secondary"].name} --zone ${var.secondary_zone} --project ${var.project_id}"
  }
}

output "artifact_registry" {
  value = "${var.primary_region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.apps.repository_id}"
}

output "bigquery_dataset" {
  value = "${var.project_id}.${google_bigquery_dataset.logs.dataset_id}"
}

