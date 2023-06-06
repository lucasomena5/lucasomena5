// AWS PROVIDER CODE BLOCK
// aws configure --profile forgerock
// aws configure sso
provider "aws" {
  region  = var.region
  profile = var.profile
  /* assume_role {
    role_arn = "arn:aws:iam::600908795746:role/tf-acn-role"
  } */

  default_tags {
    tags = {
      "Project"   = "ForgeRock"
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

locals {
  environments = {
    "lab" = "LAB"
  }

  environment = local.environments[var.environment]

  range_public_subnet  = range(10, sum([10, var.number_public_subnet]))
  range_private_subnet = range(20, sum([20, var.number_private_subnet]))
}