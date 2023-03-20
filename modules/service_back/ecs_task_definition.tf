resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.product}-${var.service_name}-${var.environment}"
  retention_in_days = 90
  tags              = var.tags
}

data "template_file" "logging" {
  template = <<EOF
{
  "logDriver": "awslogs",
  "options": {
    "awslogs-region": "$${LogRegion}",
    "awslogs-group": "$${LogGroup}",
    "awslogs-stream-prefix": "$${LogPrefix}"
  }
}
EOF
  vars = {
    LogGroup  = "/ecs/${var.product}-${var.service_name}-${var.environment}"
    LogRegion = "sa-east-1"
    LogPrefix = "ecs"
  }
}

data "template_file" "task_definition" {
  template = <<EOF
[
  {
    "name": "$${ServiceName}",
    "image": "$${ServiceImage}",
    "essential": true,
    "cpu": $${ServiceCPU},
    "memory": $${ServiceMemory}
    $${Ports}$${Logging}$${Environment}$${Secret}
  }
]
EOF
  vars = {
    ServiceName   = "${var.product}-${var.service_name}-${var.environment}"
    ServiceImage  = join(":", [aws_ecr_repository.ecr_repository.repository_url, var.image_tag])
    ServiceCPU    = var.cpu
    ServiceMemory = var.memory
    Ports         = ",\n\"portMappings\": [\n\t ${data.template_file.port.rendered} ]"
    Logging       = ",\n\"logConfiguration\": ${data.template_file.logging.rendered}"
    Environment   = length(var.task_environment) > 0 ? ",\n\"environment\": [\n\t ${join(",\n", local.rendered_environment)} ]" : ""
    Secret        = length(var.task_secret) > 0 ? ",\n\"secrets\": [\n\t ${join(",\n", local.rendered_secret)} ]" : ""
  }
}

resource "aws_ecs_task_definition" "main" {
  container_definitions     = data.template_file.task_definition.rendered
  family                    = "${var.product}-${var.service_name}-${var.environment}"
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = var.cpu
  memory                    = var.memory
  execution_role_arn        = var.aws_iam_role_arn
  task_role_arn             = var.aws_iam_role_arn
}
