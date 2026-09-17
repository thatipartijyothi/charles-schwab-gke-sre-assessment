locals {
  clusters = {
    primary = {
      location       = var.primary_zone
      subnet         = google_compute_subnetwork.primary.name
      pods_range     = "primary-pods"
      services_range = "primary-services"
    }
    secondary = {
      location       = var.secondary_zone
      subnet         = google_compute_subnetwork.secondary.name
      pods_range     = "secondary-pods"
      services_range = "secondary-services"
    }
  }
}

resource "google_container_cluster" "clusters" {
  for_each = local.clusters

  name     = "sre-${each.key}"
  location = each.value.location
  network  = google_compute_network.sre.name
  subnetwork = each.value.subnet

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_secondary_range_name  = each.value.pods_range
    services_secondary_range_name = each.value.services_range
  }

  release_channel { channel = "REGULAR" }
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS", "APISERVER", "SCHEDULER", "CONTROLLER_MANAGER"]
    managed_prometheus { enabled = true }
  }
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS", "API_SERVER", "SCHEDULER", "CONTROLLER_MANAGER"]
  }
  addons_config {
    horizontal_pod_autoscaling { disabled = false }
    http_load_balancing        { disabled = false }
  }
  resource_labels = var.labels

  depends_on = [google_project_service.required]
}

resource "google_container_node_pool" "general" {
  for_each = local.clusters

  name       = "general-purpose"
  location   = each.value.location
  cluster    = google_container_cluster.clusters[each.key].name
  node_count = var.nodes_per_cluster

  node_config {
    machine_type = var.machine_type
    disk_type    = "pd-balanced"
    disk_size_gb = 50
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    labels       = merge(var.labels, { workload = "web" })
    tags         = ["gke-node"]
    metadata     = { disable-legacy-endpoints = "true" }
    workload_metadata_config { mode = "GKE_METADATA" }
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

