// AWS ACCOUNT VARIABLES
region  = "us-east-1"
profile = "translucent"

// NETWORK RESOURCES
vpc_cidr_block       = "10.100.0.0/16"
connectivity_type    = "public"
assign_public_ip     = true
enable_dns_support   = true
enable_dns_hostnames = true
qtd_public_subnet    = 2
qtd_private_subnet   = 2

allowed_ports = [{
  description = "Allow HTTP ports"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
},
{
  description = "Allow HTTPS ports"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}]

// CLUSTER
kubernetes_version  = "1.22"
enable_key_rotation = true

// NODE GROUP EC2 INSTANCE TYPE 
instance_type_per_environment = [
  "t3.medium"
]

// EC2 PARAMETERS AND AUTOSCALING FOR EKS CLUSTER
ec2_ssh_key            = "tf-translucent"
ami_type               = "AL2_x86_64"
disk_size_node         = 20
node_pool_desired_size = 4 // Default value is 2
node_pool_min_size     = 1
node_pool_max_size     = 4

// TAGGING NAMES
purpose            = "test"
environment        = "lab"
number_of_sequence = 1

