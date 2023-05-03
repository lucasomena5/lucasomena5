// AWS PROVIDER CODE BLOCK
// aws configure --profile forgerock
provider "aws" {
  region  = var.region
  profile = var.profile

  default_tags {
    tags = {
      "Project"   = "ForgeRock"
      "ManagedBy" = "Terraform"
    }
  }
}