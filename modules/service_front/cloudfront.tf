locals {
  s3_origin_id = "S3-${var.service_name}"
}
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment   = var.service_name
}

resource "aws_cloudfront_response_headers_policy" "main" {
  name = "policy-${var.service_name}-${var.environment}-allow-origin"
  cors_config {
    access_control_allow_credentials = false

    access_control_allow_headers {
      items = ["authorization", "content-type"]
    }

    access_control_allow_methods {
      items = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    }

    access_control_expose_headers {
      items = ["*"]
    }

    access_control_max_age_sec = 300
    access_control_allow_origins {
      items = var.allow_origin_req
    }

    origin_override = true
  }

  security_headers_config {
    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "SAMEORIGIN"
      override     = false
    }

    referrer_policy {
      override        = false
      referrer_policy = "strict-origin-when-cross-origin"
    }

    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = false
      override                   = false
      preload                    = false
    }

    xss_protection {
      mode_block = true
      override   = false
      protection = true
    }

  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  origin {
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  dynamic "origin" {
    for_each = var.extra_origins
    content {
      domain_name = origin.value["domain_name"]
      origin_id = origin.value["origin_id"]
    }
  }
  aliases             = [var.domain_name]
  comment             = var.service_name
  enabled             = true
  default_root_object = var.default_root_object

  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = local.s3_origin_id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.main.id
    forwarded_values {
      query_string = true
      headers      = var.headers

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  custom_error_response {
    response_page_path = "/index.html"
    error_code = 404
    response_code = 200
  }

  custom_error_response {
    response_page_path = "/index.html"
    error_code = 403
    response_code = 200
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
