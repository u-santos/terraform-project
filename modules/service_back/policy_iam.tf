resource "aws_iam_policy" "ecr" {
  name        = "${var.service_name}-${var.environment}"
  description = "Politica de acesso aos serviços de clientes."

  policy = data.template_file.service_policy.rendered
}
