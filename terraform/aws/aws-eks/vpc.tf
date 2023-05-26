locals {
  range_public_subnet  = range(10, sum([10, var.number_public_subnet]))
  range_private_subnet = range(20, sum([20, var.number_private_subnet]))
}

data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  // forgerock
  assign_generated_ipv6_cidr_block = true

  tags = {
    "Name"        = join("-", ["vpc", var.purpose, var.environment, format("%02d", var.number_of_sequence)]),
    "Environment" = "${local.environment}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name"        = join("-", ["igw", var.purpose, var.environment, format("%02d", var.number_of_sequence)]),
    "Environment" = "${local.environment}"
  }

  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_eip" "eip" {
  domain = "vpc"

  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id     = aws_eip.eip.id
  connectivity_type = var.connectivity_type
  subnet_id         = aws_subnet.public_subnet[0].id

  tags = {
    "Name"        = join("-", ["ngw", var.purpose, var.environment, format("%02d", var.number_of_sequence)]),
    "Environment" = "${local.environment}"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_subnet" "public_subnet" {
  count                   = length(local.range_public_subnet)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, local.range_public_subnet[count.index])
  availability_zone       = data.aws_availability_zones.azs.names[local.range_public_subnet[count.index] == 10 ? 0 : 1]
  map_public_ip_on_launch = var.assign_public_ip

  ipv6_cidr_block                 = count.index == 1 ? cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, sum([count.index, 40])) : cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, sum([count.index, 50]))
  assign_ipv6_address_on_creation = true

  tags = {
    "Name"                                       = join("-", ["subnet", "public", var.purpose, var.environment, format("%02d", sum([count.index, 1]))]),
    "Environment"                                = "${local.environment}"
    "kubernetes.io/cluster/elb"                  = 1,
    "kubernetes.io/role/elb"                     = "1",
    "kubernetes.io/cluster/eks-forgerock-lab-01" = "owned"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(local.range_private_subnet)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, local.range_private_subnet[count.index])
  availability_zone = data.aws_availability_zones.azs.names[local.range_private_subnet[count.index] == 20 ? 0 : 1]

  ipv6_cidr_block                 = count.index == 1 ? cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, sum([count.index, 20])) : cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, sum([count.index, 30]))
  assign_ipv6_address_on_creation = true
  tags = {
    "Name"                                       = join("-", ["subnet", "private", var.purpose, var.environment, format("%02d", sum([count.index, 1]))]),
    "Environment"                                = "${local.environment}"
    "kubernetes.io/cluster/internal-elb"         = 1,
    "kubernetes.io/role/elb"                     = "1",
    "kubernetes.io/cluster/eks-forgerock-lab-01" = "owned"
  }
}

// ROUTE TABLES
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name"        = join("-", ["rt", "public", var.purpose, var.environment, format("%02d", var.number_of_sequence)]),
    "Environment" = "${local.environment}"
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc.id

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

// PRIVATE ASSOCIATION
resource "aws_route_table_association" "rt_private_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.rt_public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.rt_private.id
  gateway_id             = aws_nat_gateway.nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

