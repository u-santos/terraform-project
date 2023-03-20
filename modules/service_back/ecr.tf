resource "aws_ecr_repository" "ecr_repository" {
  name                 = "${var.product}-${var.service_name}-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "foopolicy" {
  repository = aws_ecr_repository.ecr_repository.name
  policy = <<EOF
    {
        "rules": [
            {
                "rulePriority": 1,
                "description": "Remove old images",
                "selection": {
                    "tagStatus": "any",
                    "countType": "imageCountMoreThan",
                    "countNumber": ${var.image_count}
                },
                "action": {
                    "type": "expire"
                }
            }
        ]
    }
  EOF
}
