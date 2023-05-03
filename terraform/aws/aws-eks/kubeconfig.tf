locals {
  no_verify_ssl = var.no_verify_ssl ? " --no-verify-ssl " : ""
}

resource "null_resource" "initialize_kubectl" {
    provisioner "local-exec" {
    command = "aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME $NO_VERIFY_SSL --profile $AWS_PROFILE"
    environment = {
      REGION        = data.aws_region.region.name
      CLUSTER_NAME  = aws_eks_cluster.eks.name
      NO_VERIFY_SSL = local.no_verify_ssl
      AWS_PROFILE   = var.profile
    }
  }

  depends_on = [ 
    aws_eks_cluster.eks 
  ]
}