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