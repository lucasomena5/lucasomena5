locals {
  range_public_subnet  = range(50, sum([50, var.number_public_subnet]))
  range_private_subnet = range(60, sum([60, var.number_private_subnet]))
}

// DATA 
data "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
}

data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_internet_gateway" "igw" {
  filter {
    name   = "tag:Project"
    values = ["ForgeRock"]
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(local.range_public_subnet)
  vpc_id                  = data.aws_vpc.vpc.id
  cidr_block              = cidrsubnet(data.aws_vpc.vpc.cidr_block, 8, local.range_public_subnet[count.index])
  availability_zone       = data.aws_availability_zones.azs.names[local.range_public_subnet[count.index] == 50 ? 0 : 1]
  map_public_ip_on_launch = var.assign_public_ip
  
  ipv6_cidr_block = count.index == 1 ? cidrsubnet(data.aws_vpc.vpc.ipv6_cidr_block, 8, sum([count.index,60])) : cidrsubnet(data.aws_vpc.vpc.ipv6_cidr_block, 8, sum([count.index,70]))
  assign_ipv6_address_on_creation = true

  tags = {
    "Name"                      = join("-", ["subnet", "public", var.purpose, var.environment, format("%02d", sum([count.index, 1]))]),
    "Environment"               = "${local.environment}"
    "kubernetes.io/cluster/elb" = 1
  }
}

// ROUTE TABLES
resource "aws_route_table" "rt_public" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    "Name"        = join("-", ["rt", "public", var.purpose, var.environment, format("%02d", var.number_of_sequence)]),
    "Environment" = "${local.environment}"
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    "Name"        = join("-", ["rt", "private", var.purpose, var.environment, format("%02d", var.number_of_sequence)]),
    "Environment" = "${local.environment}"
  }
}

// PUBLIC ASSOCIATION
resource "aws_route_table_association" "rt_public_association" {
  count          = length(aws_subnet.public_subnet)
  route_table_id = aws_route_table.rt_public.id
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.rt_public.id
  gateway_id             = data.aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}


