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
      "Purpose"   = "Autoscaling"
    }
  }
}