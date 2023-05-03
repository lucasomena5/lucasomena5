resource "aws_key_pair" "key_pair" {
  key_name   = "tf-translucent"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYVfstXIL0E0Vy18L8By2X8c/KmcEP89+Xjk8mGaRDw ec2-user"
}