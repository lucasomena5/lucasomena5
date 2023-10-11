resource "aws_acm_certificate" "cert" {
  private_key      = sensitive(file("${path.module}/scripts/ssl/app-ssl-selfsigned.key"))
  certificate_body = sensitive(file("${path.module}/scripts/ssl/app-ssl.crt"))
}