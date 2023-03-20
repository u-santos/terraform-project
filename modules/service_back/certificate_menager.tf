provider "aws" {
  alias = "acm_provider"
}

resource "aws_acm_certificate" "cert" {
  provider          = aws.acm_provider
  domain_name       = var.domains_name.domain_name
  validation_method = "DNS"
  subject_alternative_names = var.domains_name.subject_alternative_names

  lifecycle {
    create_before_destroy = true
  }
}
