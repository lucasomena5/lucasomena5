########################################################## PROFILE ##########################################################
region = "us-east-1"
#profile = "AWSPowerUserAccess-612302207233"
profile = "lab-aws"

########################################################## VPC ##########################################################
vpc_cidr_block        = "10.100.0.0/16"
connectivity_type     = "public"
assign_public_ip      = true
enable_dns_support    = true
enable_dns_hostnames  = true
number_public_subnet  = 2
number_private_subnet = 2

########################################################## EKS ##########################################################
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
  },
  {
    description = "Allow IG ports"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}]

kubernetes_version  = "1.25"
enable_key_rotation = true

instance_type_per_environment = [
  "t3.medium"
]

ec2_ssh_key            = "tf-forgerock"
ami_type               = "AL2_x86_64"
disk_size_node         = 20
node_pool_desired_size = 2 // Default value is 2
node_pool_min_size     = 2
node_pool_max_size     = 2

########################################################## COMMON VARIABLES ##########################################################
purpose            = "forgerock-test"
environment        = "lab"
number_of_sequence = 1

