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