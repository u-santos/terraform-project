resource "aws_s3_bucket" "main" {
  bucket = "${var.service_name}-${var.environment}"
  acl = "private"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

}

resource "aws_s3_bucket_policy" "police" {
  bucket = aws_s3_bucket.main.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
          "Sid": "1",
          "Effect": "Allow",
          "Principal": {
              "AWS": "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.service_name}-${var.environment}/*"
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.main.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
