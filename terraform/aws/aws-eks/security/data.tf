// DATA 
data "aws_vpc" "vpc" {
  cidr_block = var.vpc.cidr_block
}

data "aws_eks_cluster" "eks" {
  
}