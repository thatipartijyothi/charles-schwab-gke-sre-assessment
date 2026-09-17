resource "google_compute_router" "primary" {
  name    = "gke-primary-router"
  region  = var.primary_region
  network = google_compute_network.sre.id
}

resource "google_compute_router_nat" "primary" {
  name                               = "gke-primary-nat"
  router                             = google_compute_router.primary.name
  region                             = var.primary_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.primary.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_router" "secondary" {
  name    = "gke-secondary-router"
  region  = var.secondary_region
  network = google_compute_network.sre.id
}

resource "google_compute_router_nat" "secondary" {
  name                               = "gke-secondary-nat"
  router                             = google_compute_router.secondary.name
  region                             = var.secondary_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.secondary.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

