// EKS ADDONS 
// aws eks describe-addon-versions --profile forgerock
// aws configure sso
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "vpc-cni"
  addon_version = "v1.10.1-eksbuild.1"

  depends_on = [
    aws_eks_cluster.eks
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.eks.name
  addon_name   = "kube-proxy"
  addon_version = "v1.22.6-eksbuild.1"

  depends_on = [
    aws_eks_cluster.eks
  ]
}

// INSTALL ADDONS USING AWS CLI
resource "null_resource" "addon_coredns" {
    provisioner "local-exec" {
    command = "aws eks create-addon --cluster-name $CLUSTER_NAME --addon-name coredns --resolve-conflicts OVERWRITE --profile $AWS_PROFILE"
    environment = {
      CLUSTER_NAME  = aws_eks_cluster.eks.name
      AWS_PROFILE   = var.profile
    }
  }

  depends_on = [ 
    aws_eks_cluster.eks 
  ]
}


