data "template_file" "policy" {
  template = file(var.policy_path)
  vars     = var.policy_variables
}

resource "aws_s3_bucket" "default" {
  bucket = var.resource

  cors_rule {
    allowed_headers = var.allowed_headers
    allowed_methods = var.allowed_methods
    allowed_origins = var.allowed_origins
    expose_headers  = var.expose_headers
    max_age_seconds = var.max_age_seconds
  }

  acl    = var.public == true ? "public" : "private"
  policy = data.template_file.policy.rendered

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  force_destroy = true

  tags = merge(var.tags, { Name = var.resource })
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.default.id
  
  block_public_acls       = var.block_public_acls   == true ? "true" : "false"
  block_public_policy     = var.block_public_policy == true ? "true" : "false"
  ignore_public_acls      = var.ignore_public_acls  == true ? "true" : "false"
  restrict_public_buckets = var.restrict_acess      == true ? "true" : "false"

}
