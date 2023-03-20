data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "template_file" "s3_role_policy" {
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
         "arn:aws:s3:::${var.resource}",
         "arn:aws:s3:::${var.resource}/*"
     ]
    }
  ]
}
POLICY
}


