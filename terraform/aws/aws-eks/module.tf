module "networking" {
  source = "./networking"

  // AWS ACCOUNT VARIABLES
  region  = var.region
  profile = var.profile

  // NETWORK RESOURCES
  vpc_cidr_block        = var.vpc_cidr_block
  connectivity_type     = var.connectivity_type
  assign_public_ip      = var.assign_public_ip
  enable_dns_support    = var.enable_dns_support
  enable_dns_hostnames  = var.enable_dns_hostnames
  number_public_subnet  = var.number_public_subnet
  number_private_subnet = var.number_private_subnet

  // TAGGING NAMES
  purpose            = var.purpose
  environment        = var.environment
  number_of_sequence = var.number_of_sequence

}

module "eks" {
  source = "./eks"

  // AWS ACCOUNT VARIABLES
  region  = var.region
  profile = var.profile

  allowed_ports       = var.allowed_ports
  enable_key_rotation = var.enable_key_rotation
  vpc_cidr_block      = var.vpc_cidr_block

  // NODE GROUP EC2 INSTANCE TYPE 
  instance_type_per_environment = var.instance_type_per_environment

  // EC2 PARAMETERS AND AUTOSCALING FOR EKS CLUSTER
  ec2_ssh_key            = var.ec2_ssh_key
  ami_type               = var.ami_type
  disk_size_node         = var.disk_size_node
  node_pool_desired_size = var.node_pool_desired_size
  node_pool_min_size     = var.node_pool_min_size
  node_pool_max_size     = var.node_pool_max_size

  // TAGGING NAMES
  purpose            = var.purpose
  environment        = var.environment
  number_of_sequence = var.number_of_sequence
}
