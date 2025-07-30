
provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key

  # assume_role {
  #   role_arn     = "arn:aws:iam::767397831600:role/lab-terraform-assume-role"
  #   session_name = "terraform-eks-session"
  #   external_id  = "test-terraform"
  # }

  default_tags {
    tags = {
      "Project"   = "Jenkins"
      "ManagedBy" = "Terraform"
    }
  }
}
