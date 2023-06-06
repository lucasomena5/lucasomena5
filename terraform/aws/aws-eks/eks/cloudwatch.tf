// CLOUDWATCH LOG GROUP FOR EKS
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/eks/${local.naming_eks}/cluster"
  retention_in_days = 30
}