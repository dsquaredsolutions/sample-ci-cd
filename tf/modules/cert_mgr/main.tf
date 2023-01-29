resource "aws_acm_certificate" "dsquared-cert" {
  private_key       = var.private_key
  certificate_body  = var.certificate_body
  certificate_chain = var.certificate_chain
}
