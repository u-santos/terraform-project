# Get Parameter from variable
data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "main" {
  for_each = var.task_secret
  name     = each.value
}

data "template_file" "port" {
  template = <<EOF
{
  "containerPort": $${ContainerPort},
  "hostPort": $${HostPort}
}
EOF
  vars = {
    ContainerPort = var.port
    HostPort      = var.port
  }
}

data "template_file" "environment" {
  for_each = var.task_environment
  template = <<EOF
{
  "name": "$${Name}",
  "value": "$${Value}"
}
EOF
  vars = {
    Name  = each.key
    Value = each.value
  }
}

data "template_file" "secret" {
  for_each = var.task_secret
  template = <<EOF
{
  "name": "$${Name}",
  "valueFrom": "$${Value}"
}
EOF
  vars = {
    Name  = each.key
    Value = data.aws_ssm_parameter.main[each.key].arn
  }
}

locals {
  rendered_environment = [for v in data.template_file.environment : v.rendered]
  rendered_secret      = [for v in data.template_file.secret : v.rendered]
}

data "template_file" "service_policy" {
  template = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Global",
      "Effect": "Allow",
      "Action": [
        "ecs:RegisterTaskDefinition",
        "ecr:GetAuthorizationToken",
        "ses:*",
        "ecs:DescribeTaskDefinition",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Sid": "IamRoleGlobal",
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "iam:PassedToService": "ecs-tasks.amazonaws.com"
        }
      }
    },
    {
      "Sid": "PermisionEcsECr",
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecs:Submit*",
        "ecr:ListTagsForResource",
        "ecr:UploadLayerPart",
        "ecr:ListImages",
        "ecr:PutImage",
        "ecs:UpdateService",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeRepositories",
        "ecr:InitiateLayerUpload",
        "ecr:BatchCheckLayerAvailability",
        "sqs:DeleteMessage",
        "sqs:GetQueueUrl",
        "sqs:ChangeMessageVisibility",
        "sqs:ReceiveMessage",
        "sqs:SendMessage",
        "sqs:GetQueueAttributes",
        "sqs:PurgeQueue"
      ],
      "Resource": [
        "arn:aws:ecs:sa-east-1:${data.aws_caller_identity.current.account_id}:cluster/${var.service_name}-${var.environment}",
        "arn:aws:ecs:sa-east-1:${data.aws_caller_identity.current.account_id}:service/${var.aws_ecs_cluster_main_name}/${var.product}-${var.service_name}-${var.environment}",
        "arn:aws:ecr:sa-east-1:${data.aws_caller_identity.current.account_id}:repository/${aws_ecr_repository.ecr_repository.name}",
        "arn:aws:sqs:sa-east-1:${data.aws_caller_identity.current.account_id}:${var.service_name}-${var.environment}*"
      ]
    }
  ]
}
POLICY
}
