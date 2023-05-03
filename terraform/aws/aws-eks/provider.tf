// AWS PROVIDER CODE BLOCK
// aws configure --profile translucent
provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      "Project"   = "Translucent DevOps Test"
      "ManagedBy" = "Terraform"
    }
  }
}