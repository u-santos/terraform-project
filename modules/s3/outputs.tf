output "bucket_name" {
  value       = aws_s3_bucket.default.id
  description = "The ID of the S3 bucket."
}

output "bucket" {
  value       = aws_s3_bucket.default
  description = "The S3 bucket resource."
}

output "arn_role" {
  value = aws_iam_role.ecs_s3_access_role.arn
}

output "domain_bucket" {
  value = aws_s3_bucket.default.bucket_domain_name
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com"
}
