terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.60.2"
    }
  }

  backend "gcs" {
    bucket = "tf-state-playground-370411"
    prefix = "terraform/gcs/lab.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
