// AWS PROVIDER CODE BLOCK
provider "aws" {
  region  = var.region
  profile = var.profile
  /* assume_role {
    role_arn = "arn:aws:iam::111222333444:role/tf-acn-role"
  } */

  default_tags {
    tags = {
      "Project"   = "LAB Container Security"
      "ManagedBy" = "Terraform"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "tls" {}