resource "google_compute_network" "vpc" {
  name                    = "lab-vpc"
  auto_create_subnetworks = false
}
