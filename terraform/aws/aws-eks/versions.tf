data "tf_remote_state" "tf_eks_state_file" {
  backend = "local"

  config = {
    path = "/mnt/c/Users/lucas.omena/Documents/REPO/eks.tfstate"
  }
}

terraform {
  /* backend "s3" {
    profile = ""
    region  = "us-east-1"
    bucket  = ""
    key     = "terraform/aws/lab.tfstate"
  } */
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.40.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
  }
  required_version = ">= 0.15"
}
