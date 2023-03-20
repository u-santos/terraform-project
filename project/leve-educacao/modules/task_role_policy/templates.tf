
data "template_file" "certificate_assets_policy" {
  template = <<POLICY
{
    "Statement": [
        {
            "Action": [
                "s3:ListBucket",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:DeleteObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::certificate-assets-${var.environment}",
                "arn:aws:s3:::certificate-assets-${var.environment}/*"
            ],
            "Sid": "S3Policy"
        }
    ],
    "Version": "2012-10-17"
}
POLICY
}
