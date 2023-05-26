// EKS CLUSTER
resource "aws_eks_cluster" "eks" {
  name     = local.naming_eks
  role_arn = aws_iam_role.cluster_role.arn
  version  = var.kubernetes_version

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  kubernetes_network_config {
    ip_family = "ipv6"
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.cmk.arn
    }
  }

  vpc_config {
    security_group_ids      = aws_security_group.sg[*].id
    subnet_ids              = aws_subnet.private_subnet[*].id
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [
    aws_cloudwatch_log_group.log_group,
  ]
}
