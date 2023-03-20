# Get Parameter from variable
data "aws_caller_identity" "current" {}

data "template_file" "service_policy" {
  template = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3Policy",
      "Effect": "Allow",
      "Action": [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:DeleteObject"
      ],
      "Resource": [
         "arn:aws:s3:::${var.service_name}-${var.environment}",
         "arn:aws:s3:::${var.service_name}-${var.environment}/*"
     ]
    },
    {
      "Sid": "ClodFrontInvalidationCache",
      "Effect": "Allow",
      "Action": "cloudfront:CreateInvalidation",
      "Resource": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
    }
  ]
}
POLICY
}
