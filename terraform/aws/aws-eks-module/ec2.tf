locals {
  //naming_eks = join("-", ["eks", var.purpose, var.environment, format("%02d", var.number_of_sequence)])

  environments = {
    "lab" = "LAB"
  }

  environment = local.environments[var.environment]
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"] # Canonical
}

resource "aws_instance" "ec2" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t3.small"
  subnet_id            = aws_subnet.public_subnet[0].id
  security_groups      = [aws_security_group.sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name             = aws_key_pair.key_pair.key_name

  tags = {
    "Name" = "bastion"
  }
}
