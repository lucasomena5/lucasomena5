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
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
  }
  required_version = ">= 0.15"
}
