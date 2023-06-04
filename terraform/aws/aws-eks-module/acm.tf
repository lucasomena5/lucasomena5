resource "aws_acm_certificate" "cert" {
  private_key      = sensitive(file("${path.module}/forgerock/ssl/ig-ssl-selfsigned.key"))
  certificate_body = sensitive(file("${path.module}/forgerock/ssl/ig-ssl.crt"))
}