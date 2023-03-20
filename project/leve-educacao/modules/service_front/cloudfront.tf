locals {
  s3_origin_id = "S3-${var.service_name}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  origin {
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
  }

  dynamic "origin" {
    for_each = var.extra_origins
    content {
      domain_name = origin.value["domain_name"]
      origin_id   = origin.value["origin_id"]
    }
  }

  aliases             = concat(var.domains_name.subject_alternative_names, [var.domains_name.domain_name])
  comment             = var.service_name
  enabled             = true
  default_root_object = var.default_root_object

  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = true
      headers      = var.headers

      cookies {
        forward = "all"
      }
    }

    dynamic function_association {
      for_each = try(var.default_function_association, [])
      content {
        event_type   = function_association.value["event_type"]
        function_arn = function_association.value["function_arn"]
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.extra_origins
    content {
      path_pattern     = ordered_cache_behavior.value["path_pattern"]
      allowed_methods  = ["GET", "HEAD", "OPTIONS"]
      cached_methods   = ["GET", "HEAD", "OPTIONS"]
      target_origin_id = ordered_cache_behavior.value["origin_id"]
      forwarded_values {
        query_string = false
        headers      = ["Origin"]
        cookies {
          forward = "none"
        }
      }

      dynamic function_association {
        for_each = try(ordered_cache_behavior.value["function_association"], [])
        content {
          event_type   = function_association.value["event_type"]
          function_arn = function_association.value["function_arn"]
        }
      }

      min_ttl                = 0
      default_ttl            = 86400
      max_ttl                = 31536000
      compress               = true
      viewer_protocol_policy = "redirect-to-https"
    }
  }

  custom_error_response {
    response_page_path = "/index.html"
    error_code         = 404
    response_code      = 200
  }

  custom_error_response {
    response_page_path = "/index.html"
    error_code         = 403
    response_code      = 200
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

  tags = {
    billing = var.tags_distribution
  }

}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.service_name
}
