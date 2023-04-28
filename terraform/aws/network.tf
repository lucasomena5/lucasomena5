data "aws_availability_zones" "available" {
  state = "available"
}

######################################### FIRST VPC #########################################
resource "aws_vpc" "vpc_1" {
  cidr_block                       = cidrsubnet(var.cidr_block, 4, 2)
  assign_generated_ipv6_cidr_block = false
  enable_dns_support               = true
  enable_dns_hostnames             = true
  instance_tenancy                 = "default"

  tags = merge(
    {"Name" = "tf-vpc-1-a"}, 
    var.default_tags
  )
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.vpc_a.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  
  tags = merge(
    {"Name" = "tf-subnet-1-a"}, 
    var.default_tags
  )
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.vpc_a.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  
  tags = merge(
    {"Name" = "tf-subnet-1-b"}, 
    var.default_tags
  )
}

######################################### SECOND VPC #########################################

resource "aws_vpc" "vpc_2" {
  cidr_block                       = var.cidr_block
  assign_generated_ipv6_cidr_block = false
  enable_dns_support               = true
  enable_dns_hostnames             = true
  instance_tenancy                 = "default"

  tags = merge(
    {"Name" = "tf-vpc-2-a"}, 
    var.default_tags
  )
}

resource "aws_subnet" "subnet_2_a" {
  vpc_id     = aws_vpc.vpc_2.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  
  tags = merge(
    {"Name" = "tf-subnet-2-a"}, 
    var.default_tags
  )
}

resource "aws_subnet" "subnet_2_b" {
  vpc_id     = aws_vpc.vpc_2.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  
  tags = merge(
    {"Name" = "tf-subnet-2-b"}, 
    var.default_tags
  )
}