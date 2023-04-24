terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">=4.60.0"
    }
  }
  
  /* backend "s3" {
    profile = "lab-aws"
    region  = "us-east-1"
    bucket  = "tf-lab-866167496273"
    key     = "terraform/aws/lab.tfstate"
  } */

  required_version = ">=1.4"
}

provider "aws" {
  profile = var.profile
  region  = var.region
}
