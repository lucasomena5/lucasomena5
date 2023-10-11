// ssh-keygen -t rsa -f ~/.ssh/aws_cloud_key -C ec2_user
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "key_pair" {
  key_name = "tf-${var.purpose}"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_ssh_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "tf-${var.purpose}.pem"
  file_permission = "0400"
}
