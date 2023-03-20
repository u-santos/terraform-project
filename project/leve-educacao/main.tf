provider "aws" {
  region  = var.region
  profile = "default"
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = "default"
}

terraform {
  /*
  * OBS: Essa versão do terraform não deixa utilizar variáveis neste trecho de código.
  * Para utilizar o terraform nos diferentes ambientes (dev, prod) basta remover o diretório .terraform e
  * em seguida executar o seguinte comando, alternando apenas o bucket de acordo com o ambiente:
  * PROD terraform init -backend-config "bucket=project-leve-prod" 
  */

  backend "s3" {
    key    = "terraform/terraform.tfstate"
    region = "sa-east-1"
  }

  required_providers {
    aws = "~> 3.74.1"
  }

}

locals {
  resource    = "${var.product}-${var.service_name}-${var.environment}"
  log_prefix  = "logs/${var.environment}"
  environment = var.environment
  tags = {
    Name        = local.resource
    project     = var.product
    service     = var.service_name
    environment = var.environment
  }

  client_resource = "${var.product}-client-${var.service_name}-${var.environment}"
  client_tags = {
    Name        = local.client_resource
    project     = "client-${var.product}"
    service     = "client-${var.service_name}"
    environment = var.environment
  }
}

module "ecs_iam_police" {
  source       = "../../modules/iam_police"
  service_name = "ecs-agent-leve"
  environment  = var.environment
}

module "ecs_cluster" {
  source = "../../modules/ecs_cluster"
  name   = local.resource
  tags   = local.tags
}

module "ecs_cluster_client" {
  source = "../../modules/ecs_cluster"
  name   = local.client_resource
  tags   = local.client_tags
}

module "ecs_task_role_policy" {
  source       = "./modules/task_role_policy"
  service_name = "ecs-agent-role"
  environment  = var.environment
}

module "network" {
  source       = "./modules/network"
  service_name = var.service_name
  environment  = var.environment
  default_tags = local.tags

  //Liste os ids dos grupos de seguranças de cada service criado para atrela-lo ao grupo de segurança do RDS
  aws_service_security_group_ids = [
    module.api-course.aws_service_security_group_id
    # module.api-file.aws_service_security_group_id,
    # module.api-support.aws_service_security_group_id,
    # module.api-exam.aws_service_security_group_id,
    # module.api-client-leve.aws_service_security_group_id
  ]

  list_port_service_container = var.list_port_service_container
}

module "lb_application" {
  source = "../../modules/lb"

  vpc_id          = module.network.id_vpc
  security_groups = [module.network.vpc_security_group_ecs_ids]
  service_name    = local.resource
  subnets         = module.network.aws_all_subnets_id_public
  environment     = var.environment
}

module "lb_application_client" {
  source = "../../modules/lb"

  vpc_id          = module.network.id_vpc
  security_groups = [module.network.vpc_security_group_ecs_ids]
  service_name    = local.client_resource
  subnets         = module.network.aws_all_subnets_id_public
  environment     = var.environment
}

module "rds_client" {
  source         = "./modules/rds_aurora"
  instance_class = var.rds_client_instance_class
  engine         = var.rds_engine
  engine_version = var.rds_engine_version
  password       = var.rds_client_password

  preferred_maintenance_window = var.rds_instance_preferred_maintenance_window
  skip_final_snapshot          = var.rds_skip_final_snapshot
  instance_count               = var.rds_count
  cluster_name                 = local.client_resource
  db_parameter_group_name      = var.db_parameter_group_name
  aws_db_subnet_group_id       = module.network.aws_db_subnet_group_id
  vpc_security_group_ids       = module.network.vpc_security_group_ids
  tags                         = local.tags
}

module "rds_api" {
  source = "./modules/rds_aurora"

  instance_class               = var.rds_instance_class
  engine                       = var.rds_engine
  engine_version               = var.rds_engine_version
  password                     = var.rds_password
  preferred_maintenance_window = var.rds_instance_preferred_maintenance_window
  instance_count               = var.rds_count
  cluster_name                 = local.resource
  skip_final_snapshot          = var.rds_skip_final_snapshot
  db_parameter_group_name      = "${var.db_parameter_group_name}-api"

  aws_db_subnet_group_id = module.network.aws_db_subnet_group_id
  vpc_security_group_ids = module.network.vpc_security_group_ids
  tags                   = local.tags
}

module "asset-api-file" {
  source = "../../modules/s3"

  resource = "assets-api-file-${var.environment}-${var.product}-hxwezq"
  public   = false

  allowed_headers = ["*"]
  allowed_methods = ["PUT", "POST", "DELETE", "GET"]
  allowed_origins = ["*"]
  expose_headers  = []
  max_age_seconds = 0

  policy_path = "./resources/policies/bucket-policy-files.json"
  policy_variables = {
    bucket_name = "assets-api-file-${var.environment}-${var.product}-hxwezq"
  }

  tags = local.tags
}

/*
* ###########################################
* #         Modulos da Aplicação            #
* ###########################################
*/

module "api-course" {
  source                    = "../../modules/service_back"
  product                   = var.product
  environment               = var.environment
  tags                      = merge(local.tags, { billing = "api-course" })
  service_name              = "api-course"
  domains_name              = var.host_api_course
  port                      = "3000"
  memory                    = var.memory_api_course
  cpu                       = var.cpu_api_course
  max_capacity              = var.max_capacity_api_course
  aws_ecs_cluster_id        = module.ecs_cluster.aws_ecs_cluster_id
  aws_ecs_cluster_main_name = module.ecs_cluster.aws_ecs_cluster_name
  aws_all_subnet_ids        = module.network.aws_all_subnets_id_private
  aws_iam_role_arn          = module.ecs_iam_police.aws_iam_role_arn
  execution_role_arn        = module.ecs_task_role_policy.aws_iam_task_role_arn
  aws_vpc_main_id           = module.network.id_vpc
  image_count               = var.ecr_image_count

  aws_lb_arn = module.lb_application.aws_lb_main_arn
  vpc_id     = module.network.id_vpc
  aws_lb_dns = module.lb_application.aws_lb_main_dns
  aws_lb_id  = module.lb_application.aws_lb_main_id

  providers = {
    aws.acm_provider = aws.us_east_1
  }
}

# module "api-file" {
#   source                    = "../../modules/service_back"
#   product                   = var.product
#   environment               = var.environment
#   tags                      = merge(local.tags, { billing = "api-file" })
#   service_name              = "api-file"
#   domains_name              = var.host_api_file
#   port                      = "3001"
#   aws_ecs_cluster_id        = module.ecs_cluster.aws_ecs_cluster_id
#   aws_ecs_cluster_main_name = module.ecs_cluster.aws_ecs_cluster_name
#   aws_all_subnet_ids        = module.network.aws_all_subnets_id_private
#   aws_iam_role_arn          = module.ecs_iam_police.aws_iam_role_arn
#   execution_role_arn        = module.asset-api-file.arn_role
#   aws_vpc_main_id           = module.network.id_vpc
#   image_count               = var.ecr_image_count
#   memory                    = 1024

#   aws_lb_arn = module.lb_application.aws_lb_main_arn
#   vpc_id     = module.network.id_vpc
#   aws_lb_dns = module.lb_application.aws_lb_main_dns
#   aws_lb_id  = module.lb_application.aws_lb_main_id

#   providers = {
#     aws.acm_provider = aws.us_east_1
#   }
# }

# module "api-support" {
#   source                    = "../../modules/service_back"
#   product                   = var.product
#   environment               = var.environment
#   tags                      = merge(local.tags, { billing = "api-support" })
#   service_name              = "api-support"
#   domains_name              = var.host_api_support
#   port                      = "3002"
#   aws_ecs_cluster_id        = module.ecs_cluster.aws_ecs_cluster_id
#   aws_ecs_cluster_main_name = module.ecs_cluster.aws_ecs_cluster_name
#   aws_all_subnet_ids        = module.network.aws_all_subnets_id_private
#   aws_iam_role_arn          = module.ecs_iam_police.aws_iam_role_arn
#   execution_role_arn        = module.ecs_task_role_policy.aws_iam_task_role_arn
#   aws_vpc_main_id           = module.network.id_vpc
#   image_count               = var.ecr_image_count
#   memory                    = 2048
#   cpu                       = 512

#   aws_lb_arn = module.lb_application.aws_lb_main_arn
#   vpc_id     = module.network.id_vpc
#   aws_lb_dns = module.lb_application.aws_lb_main_dns
#   aws_lb_id  = module.lb_application.aws_lb_main_id

#   providers = {
#     aws.acm_provider = aws.us_east_1
#   }
# }

# module "api-exam" {
#   source                    = "../../modules/service_back"
#   product                   = var.product
#   environment               = var.environment
#   tags                      = merge(local.tags, { billing = "api-exam" })
#   service_name              = "api-exam"
#   domains_name              = var.host_api_exam
#   port                      = "3003"
#   aws_ecs_cluster_id        = module.ecs_cluster.aws_ecs_cluster_id
#   aws_ecs_cluster_main_name = module.ecs_cluster.aws_ecs_cluster_name
#   aws_all_subnet_ids        = module.network.aws_all_subnets_id_private
#   aws_iam_role_arn          = module.ecs_iam_police.aws_iam_role_arn
#   execution_role_arn        = module.ecs_task_role_policy.aws_iam_task_role_arn
#   aws_vpc_main_id           = module.network.id_vpc
#   image_count               = var.ecr_image_count
#   memory                    = 2048
#   cpu                       = 512

#   aws_lb_arn = module.lb_application.aws_lb_main_arn
#   vpc_id     = module.network.id_vpc
#   aws_lb_dns = module.lb_application.aws_lb_main_dns
#   aws_lb_id  = module.lb_application.aws_lb_main_id

#   providers = {
#     aws.acm_provider = aws.us_east_1
#   }
# }

# module "api-client-leve" {
#   source                    = "../../modules/service_back"
#   product                   = var.product
#   environment               = var.environment
#   tags                      = merge(local.client_tags, { billing = "api-client-leve" })
#   service_name              = "api-leve-client"
#   domains_name              = var.host_api_leve_client
#   port                      = "3000"
#   memory                    = var.memory_api_leve_client
#   cpu                       = var.cpu_api_leve_client
#   max_capacity              = var.max_capacity_api_leve_client
#   aws_ecs_cluster_id        = module.ecs_cluster_client.aws_ecs_cluster_id
#   aws_ecs_cluster_main_name = module.ecs_cluster_client.aws_ecs_cluster_name
#   aws_all_subnet_ids        = module.network.aws_all_subnets_id_private
#   aws_iam_role_arn          = module.ecs_iam_police.aws_iam_role_arn
#   execution_role_arn        = module.ecs_task_role_policy.aws_iam_task_role_arn
#   aws_vpc_main_id           = module.network.id_vpc
#   image_count               = var.ecr_image_count
#   aws_lb_arn                = module.lb_application_client.aws_lb_main_arn
#   vpc_id                    = module.network.id_vpc
#   aws_lb_dns                = module.lb_application_client.aws_lb_main_dns
#   aws_lb_id                 = module.lb_application_client.aws_lb_main_id

#   providers = {
#     aws.acm_provider = aws.us_east_1
#   }
# }

# resource "aws_cloudfront_function" "leve-redirect" {
#   name    = "leve-redirect-${var.environment}"
#   runtime = "cloudfront-js-1.0"
#   publish = true
#   code    = file("./resources/cloudfront-functions/leve-redirect-${var.environment}.js")
# }

# module "leve-front" {
#   source       = "./modules/service_front"
#   service_name = "cl0xz7-leve-front"
#   domains_name = var.host_leve_front
#   environment  = var.environment

#   extra_origins = [{
#     domain_name  = module.asset-api-file.domain_bucket
#     origin_id    = "S3-${module.asset-api-file.bucket_name}"
#     path_pattern = "scorm/*"
#     function_association = [{ "event_type" : "viewer-request",
#       "function_arn" : aws_cloudfront_function.leve-redirect.arn
#     }]
#   }]

#   default_function_association = [{ "event_type" : "viewer-request",
#     "function_arn" : aws_cloudfront_function.leve-redirect.arn
#   }]

#   #Setup Cloud Front
#   default_root_object    = "index.html"
#   allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#   cached_methods         = ["GET", "HEAD", "OPTIONS"]
#   viewer_protocol_policy = "redirect-to-https"

#   providers = {
#     aws.acm_provider = aws.us_east_1
#   }
# }

# module "leve-admin" {
#   source       = "./modules/service_front"
#   service_name = "nA3xwQ-leve-admin-client"
#   domains_name = var.host_leve_admin
#   environment  = var.environment

#   extra_origins = [{
#     domain_name  = module.asset-api-file.domain_bucket
#     origin_id    = "S3-${module.asset-api-file.bucket_name}"
#     path_pattern = "scorm/*"
#   }]

#   #Setup Cloud Front
#   default_root_object    = "index.html"
#   allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#   cached_methods         = ["GET", "HEAD"]
#   viewer_protocol_policy = "redirect-to-https"

#   providers = {
#     aws.acm_provider = aws.us_east_1
#   }
# }
