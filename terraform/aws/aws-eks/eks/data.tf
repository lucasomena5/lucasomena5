// GET AWS REGION
data "aws_region" "region" {}

// CURRENT AWS ACCOUNT INFORMATION
data "aws_partition" "current" {}

data "aws_security_group" "sg_eks" {
  
}