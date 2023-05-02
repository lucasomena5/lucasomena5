terraform {
    backend "s3"{}
    
    required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~> 3.30.0"
      }
    }
    helm = {
        source = "hashicorp/helm"
        version = "~> 2.0.1"
    }
    kubernetes = {
        source = "hashicorp/kubernetes"
        version = "~> 2.0.0"
    }

    required_version = ">= 0.13"

}