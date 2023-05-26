// NODE GROUP INSTANCES
resource "aws_eks_node_group" "node_pool" {
  cluster_name    = local.naming_eks
  node_group_name = "node-pool-${local.naming_eks}"
  node_role_arn   = aws_iam_role.nodegroup_role.arn
  subnet_ids      = data.aws_subnets.private_subnets[*].id
  instance_types  = local.instance_type_per_environment[var.environment]
  capacity_type   = local.capacity_type
  disk_size       = var.disk_size_node
  labels          = local.capacity_type == "ON_DEMAND" ? merge(local.node_pool_labels) : merge(local.node_pool_labels, local.spot_kubernetes_label)
  ami_type        = var.ami_type

  scaling_config {
    desired_size = var.node_pool_desired_size
    min_size     = var.node_pool_min_size
    max_size     = var.node_pool_max_size
  }

  remote_access {
    ec2_ssh_key               = var.ec2_ssh_key
    source_security_group_ids = aws_security_group.sg[*].id
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size, scaling_config[0].max_size]
  }

  tags = merge(local.tags_spot_node_group)

  depends_on = [
    aws_eks_cluster.eks
  ]
}
