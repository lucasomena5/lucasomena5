// ssh-keygen -t rsa -f ~/.ssh/aws_cloud_key -C ec2_user
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "key_pair" {
  key_name   = "tf-${var.purpose}"
  //public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNu0XIZuVlJb5GkAyR7dsqEF3W70sPUZOl3V9Hcm1rpgRkcerfUyanUdiW07C2ZR871M4N2ltJnpdfLbZ7wSoRB/3wqlD8MLR3zx6r8dWQoawkyNEuDPNjSucvNsHflqf0nF0Ux+ldvSdA1ywkai2o3xQD36quLsOV49rwleWKPXSChjchaUMAMnsRvtHf34UtnXJZ1NtekSCfE8vUDVr4XWx5rCouCcYnZkd5b+WMzqkgasyn1mVSz3rIFHRmSups8EZ47NQ7kCTBzMwSWCubyk/SvnpUBINfoza0G528G8dqGuR+oXoaaIzihovzNCYUSCxaPUksMUwlrmNEMYF5C2UyJ9rzSNQgMKD1g8j6dj32x49zv61icx63SMzBstyQ6ijKQLsR6sYH31J+40AZ9rC3pb/aaTtkXvJukiWSIj+j4Frrjt/NVezyzbxP9fBkeN3CNnE5+/MpPGL0Ff811edKVZl9haegDAmvlYzcH8obeBzZu+Pq3m/8mOXtQT8= ec2_user"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_ssh_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "tf-${var.purpose}.pem"
  file_permission = "0400"
}
