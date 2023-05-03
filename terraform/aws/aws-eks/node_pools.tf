// LOCAL VARIABLES TO CREATE NODE GROUP LABELS, DEFINY NUMBER OF NODES, INTANCE TYPE, AND CONFIGURE ON_DEMAND OR SPOT
locals {
  node_pool_labels = {
    type = "test-forgerock"
  }

  nodes_number = range(0, var.node_pool_max_size + 1)
  spot_kubernetes_label = {
    "intent"              = "apps"
    "aws.amazon.com/spot" = "true"
    "lifecycle"           = "Ec2Spot"
  }

  instance_type_per_environment = {
    lab = var.instance_type_per_environment[*]
    dev = var.instance_type_per_environment[*]
    pre = var.instance_type_per_environment[*]
    pro = var.instance_type_per_environment[*]
  }

  types_per_environment = {
    lab = "ON_DEMAND"
  }

  capacity_type = local.types_per_environment[var.environment]

  tags_kubernets_spot_node_group = {
    "lifecycle"           = "Ec2Spot"
    "aws.amazon.com/spot" = "true"
    "intent"              = "apps"
  }

  tags_spot_node_group = {
    "k8s.io/cluster-autoscaler/node-template/label/intent"    = "apps"
    "k8s.io/cluster-autoscaler/${local.naming_eks}"           = "owned"
    "k8s.io/cluster-autoscaler/node-template/label/lifecycle" = "Ec2Spot"
  }
}

// NODE GROUP INSTANCES
resource "aws_eks_node_group" "test_node_pool" {
  cluster_name    = local.naming_eks
  node_group_name = "node-pool-${local.naming_eks}"
  node_role_arn   = aws_iam_role.nodegroup_role.arn
  subnet_ids      = aws_subnet.public_subnet[*].id
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
    aws_subnet.public_subnet,
    aws_iam_role.cluster_role,
    aws_iam_role.nodegroup_role,
    aws_eks_cluster.eks
  ]
}
