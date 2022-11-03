#################### Custom VPC ####################

resource "google_compute_network" "vpc_network" {
  project                 = var.project
  name                    = "custom-vpc-network"
  auto_create_subnetworks = false
  mtu                     = 1460  ## Maximun Transmission Unit in Bytes (Max Value = 1500)
}

#################### Application Public Subnets ####################

resource "google_compute_subnetwork" "application-public-subnet1" {
  name          = "application-public-subnet1"
  ip_cidr_range = var.app-public-subnet1-cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "application-public-subnet2" {
  name          = "application-public-subnet2"
  ip_cidr_range = var.app-public-subnet2-cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

#################### Application Private Subnets ####################

resource "google_compute_subnetwork" "application-private-subnet1" {
  name          = "application-private-subnet1"
  ip_cidr_range = var.app-private-subnet1-cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "application-private-subnet2" {
  name          = "application-private-subnet2"
  ip_cidr_range = var.app-private-subnet2-cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

#################### Database Private Subnets ####################

resource "google_compute_subnetwork" "database-private-subnet1" {
  name          = "database-private-subnet1"
  ip_cidr_range = var.db-private-subnet1-cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "database-private-subnet2" {
  name          = "database-private-subnet2"
  ip_cidr_range = var.db-private-subnet2-cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

#################### Firewall for Application Public Subnets ####################

resource "google_compute_firewall" "public-firewall" {
  name    = "public-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = var.public-firewall-ports
  }

  source_ranges = [ var.app-public-subnet1-cidr, var.app-public-subnet2-cidr, var.app-private-subnet1-cidr, var.app-private-subnet2-cidr, var.db-private-subnet1-cidr, var.db-private-subnet2-cidr ]  ## Allowing traffic only from defined subnet cidrs
  target_tags = [ "web-public" ]  ## Remember to add this tag to VMs in Public Subnet
}

#################### Firewall for Application Private Subnets ####################

resource "google_compute_firewall" "private-firewall" {
  name    = "private-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = var.private-firewall-ports
  }

  source_ranges = [ var.app-public-subnet1-cidr, var.app-public-subnet2-cidr, var.app-private-subnet1-cidr, var.app-private-subnet2-cidr, var.db-private-subnet1-cidr, var.db-private-subnet2-cidr ]  ## Allowing traffic only from defined subnet cidrs
  target_tags = [ "web-private" ]  ## Remember to add this tag to VMs in Private Subnet
}

#################### Firewall for Database Public Subnets ####################

resource "google_compute_firewall" "db-firewall" {
  name    = "db-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = var.db-firewall-ports
  }

  source_ranges = [ var.app-public-subnet1-cidr, var.app-public-subnet2-cidr, var.app-private-subnet1-cidr, var.app-private-subnet2-cidr, var.db-private-subnet1-cidr, var.db-private-subnet2-cidr ]  ## Allowing traffic only from defined subnet cidrs
  target_tags = [ "db-private" ]  ## Remember to add this tag to DBs in Private Subnet
}
