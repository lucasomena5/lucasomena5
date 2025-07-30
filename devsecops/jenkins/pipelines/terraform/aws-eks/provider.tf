// AWS PROVIDER CODE BLOCK
// aws configure --profile <profile_name>
// aws configure sso
provider "aws" {
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::767397831600:role/lab-terraform-assume-role"
    session_name = "terraform-eks-session"
    external_id  = "test-terraform"
  }

  default_tags {
    tags = {
      "Project"   = "LAB k8s"
      "ManagedBy" = "Terraform"
    }
  }
}
