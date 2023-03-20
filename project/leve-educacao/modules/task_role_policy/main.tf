# ECS Roles for Tasks 
data "aws_iam_policy_document" "ecs_task_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "ecsTaskRole-${var.service_name}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent_role" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ssm_policy" {
  name   = "ssm-${var.service_name}-policy"
  role   = aws_iam_role.ecs_task_role.id
  policy = file("${path.root}/resources/policies/ssm-policy.json")
}

resource "aws_iam_role_policy" "cognito_policy" {
  name   = "cognito-${var.service_name}-policy"
  role   = aws_iam_role.ecs_task_role.id
  policy = file("${path.root}/resources/policies/cognito-policy.json")
}

resource "aws_iam_role_policy" "ecs_policy" {
  name   = "ecs-${var.service_name}-policy"
  role   = aws_iam_role.ecs_task_role.id
  policy = file("${path.root}/resources/policies/ecs-policy.json")
}

resource "aws_iam_role_policy" "ses_policy" {
  name   = "ses-${var.service_name}-policy"
  role   = aws_iam_role.ecs_task_role.id
  policy = file("${path.root}/resources/policies/ses-policy.json")
}

resource "aws_iam_role_policy" "certificate_assets_policy" {
  name   = "s3-certificate-assets-${var.service_name}-policy"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.template_file.certificate_assets_policy.rendered
}

resource "aws_iam_instance_profile" "ecs_agent_role" {
  name = var.service_name
  role = aws_iam_role.ecs_task_role.name
}
