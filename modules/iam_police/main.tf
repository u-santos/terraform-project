# ECS Task Definition Role
data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "ecsTaskExecutionRole-${var.service_name}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       =  aws_iam_role.ecs_tasks_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ssm_policy" {
  name      = "ssm-${var.service_name}-${var.environment}-policy"
  role      = aws_iam_role.ecs_tasks_execution_role.id
  policy    = file("../../resources/polices/ssm-policy.json")
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "${var.service_name}-${var.environment}"
  role = aws_iam_role.ecs_tasks_execution_role.name
}
