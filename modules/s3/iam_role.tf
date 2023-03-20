resource "aws_iam_role" "ecs_s3_access_role" {
  name               = "S3Access-${var.resource}"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_execution_role.json
}

resource "aws_iam_policy" "s3_policy" {
  name        = var.resource
  description = "Politica de acesso aos serviços de clientes."

  policy = data.template_file.s3_role_policy.rendered
}

resource "aws_iam_role_policy_attachment" "s3_agent" {
  role       =  aws_iam_role.ecs_s3_access_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy" "s3_policy" {
  name      = "s3-${var.resource}-policy"
  role      = aws_iam_role.ecs_s3_access_role.id
  policy    = data.template_file.s3_role_policy.rendered
}

resource "aws_iam_instance_profile" "s3_agent" {
  name = var.resource
  role = aws_iam_role.ecs_s3_access_role.name
}
