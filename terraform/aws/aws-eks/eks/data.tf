// GET AWS REGION
data "aws_region" "region" {}

// CURRENT AWS ACCOUNT INFORMATION
data "aws_partition" "current" {}

data "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
}

data "aws_subnets" "private_subnets" {
  
}