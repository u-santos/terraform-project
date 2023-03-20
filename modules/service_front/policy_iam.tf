resource "aws_iam_policy" "policy" {
  name        = "${var.service_name}-${var.environment}"
  description = "Politica de acesso aos serviços de clientes Front End."

  policy = data.template_file.service_policy.rendered
}
