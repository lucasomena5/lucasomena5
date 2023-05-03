// LOCAL VARIABLE TO CREATE NAME OF RESOURCE AND ENVIRONMENT PARAMETER
locals {
  naming_eks = join("-", ["eks", var.purpose, var.environment, format("%02d", var.number_of_sequence)])

  environments = {
    "lab" = "LAB"
  }

  environment = local.environments[var.environment]
}

// GET AWS REGION
data "aws_region" "region" {}

// CURRENT AWS ACCOUNT INFORMATION
data "aws_partition" "current" {}

// CLOUDWATCH LOG GROUP FOR EKS
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/eks/${local.naming_eks}/cluster"
  retention_in_days = 30
}

// EKS CLUSTER
resource "aws_eks_cluster" "eks" {
  name     = local.naming_eks
  role_arn = aws_iam_role.cluster_role.arn
  version  = var.kubernetes_version

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  kubernetes_network_config {
    service_ipv4_cidr = "172.31.0.0/16"
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.cmk.arn
    }
  }

  vpc_config {
    security_group_ids      = aws_security_group.sg[*].id
    subnet_ids              = aws_subnet.public_subnet[*].id
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_security_group.sg,
    aws_iam_role.cluster_role,
    aws_cloudwatch_log_group.log_group,
    aws_vpc.vpc,
    aws_subnet.public_subnet,
    aws_subnet.private_subnet
  ]
}
