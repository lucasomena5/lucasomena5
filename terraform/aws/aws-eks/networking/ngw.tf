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