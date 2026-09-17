resource "google_compute_network" "sre" {
  name                    = "sre-assessment-vpc"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
  depends_on              = [google_project_service.required]
}

resource "google_compute_subnetwork" "primary" {
  name          = "gke-primary-subnet"
  region        = var.primary_region
  network       = google_compute_network.sre.id
  ip_cidr_range = "10.10.0.0/20"

  secondary_ip_range {
    range_name    = "primary-pods"
    ip_cidr_range = "10.20.0.0/16"
  }
  secondary_ip_range {
    range_name    = "primary-services"
    ip_cidr_range = "10.30.0.0/20"
  }
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "secondary" {
  name          = "gke-secondary-subnet"
  region        = var.secondary_region
  network       = google_compute_network.sre.id
  ip_cidr_range = "10.40.0.0/20"

  secondary_ip_range {
    range_name    = "secondary-pods"
    ip_cidr_range = "10.50.0.0/16"
  }
  secondary_ip_range {
    range_name    = "secondary-services"
    ip_cidr_range = "10.60.0.0/20"
  }
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_health_checks" {
  name    = "allow-google-health-checks"
  network = google_compute_network.sre.name
  direction = "INGRESS"
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  target_tags = ["gke-node"]
}

