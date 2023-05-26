// SECURITY GROUPS
resource "aws_security_group" "sg" {
  name        = join("-", [lower(var.purpose), "security", "group"])
  description = join(" ", [lower(var.purpose), "security", "group", "${local.environment}"])
  vpc_id      = data.aws_vpc.vpc.id
  
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  tags = {
    "Name"        = join("-", ["sg", var.purpose, var.environment, format("%02d", var.number_of_sequence)]),
    "Environment" = "${var.environment}",
    "Purpose"     = "${var.purpose}"
  }

  depends_on = [
    data.aws_vpc.vpc
  ]
}

// SECURITY GROUP RULES
resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

// INGRESS ICMP RULES
resource "aws_security_group_rule" "icmp" {
  type              = "ingress"
  description       = "Allow ICMP protocol"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.sg.id
}
