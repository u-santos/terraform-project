resource "aws_ecs_cluster" "main" {
  name = var.name


  setting {
    name  = "containerInsights"
    value = var.container_insights
  }
  tags = var.tags
}
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 1
    capacity_provider = "FARGATE"
  }
  default_capacity_provider_strategy {
    base              = 0
    weight            = 4
    capacity_provider = "FARGATE_SPOT"
  }

}
