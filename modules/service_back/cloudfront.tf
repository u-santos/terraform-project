locals {
  aws_lb_id = var.aws_lb_id
}

resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = var.aws_lb_dns
    origin_id   = local.aws_lb_id
    custom_origin_config {
      http_port              = var.port
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
    custom_header {
      name  = "X-Validate-CLF-request"
      value = "${var.service_name}-${var.environment}-ZYICDSvu6eT92CtW8do3vOC1RBR-${var.rds_sg_id}"
    }
  }

  aliases             = concat(var.domains_name.subject_alternative_names,[var.domains_name.domain_name])
  enabled             = true
  default_root_object = var.default_root_object
  comment             = var.service_name
  web_acl_id          = var.web_acl_id

  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = local.aws_lb_id

    forwarded_values {
      query_string = var.query_string
      headers      = var.headers

      cookies {
        forward = var.cookies_forward
      }
    }
    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.extra_behaviors

    content {
      path_pattern     = ordered_cache_behavior.value.path_pattern
      allowed_methods  = var.allowed_methods
      cached_methods   = var.cached_methods
      target_origin_id = local.aws_lb_id

      forwarded_values {
        query_string = ordered_cache_behavior.value.query_string
        headers      = ordered_cache_behavior.value.headers

        cookies {
          forward = ordered_cache_behavior.value.cookies_forward
        }
      }

      viewer_protocol_policy = "redirect-to-https"
      min_ttl                = ordered_cache_behavior.value.min_ttl
      default_ttl            = ordered_cache_behavior.value.default_ttl
      max_ttl                = ordered_cache_behavior.value.max_ttl
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
}
