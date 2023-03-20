region = "sa-east-1"

product      = "lms"
service_name = "leve"
environment  = "prod"

# ECR Configure
ecr_image_count = 5

# RDS Configure
rds_instance_class                        = "db.t3.medium"
rds_client_instance_class                 = "db.t3.medium"
rds_engine                                = "aurora-postgresql"
rds_engine_version                        = "12.8"
rds_password                              = "RGB0j34n1nx1hkBc"
rds_client_password                       = "dW2Zcs34FxvddrX1"
rds_allocated_storage                     = 5 # remove this later
rds_skip_final_snapshot                   = false
rds_count                                 = 1
backup_retention_period                   = 30
backup_window                             = "02:00-03:00"
rds_instance_preferred_maintenance_window = "tue:08:00-tue:10:00"
db_parameter_group_name                   = "db-parameter-group"

# Liste as portas necessárias para serem liberadas no grupo de segurança do loadbalancer
list_port_service_container = [
  3000
  # 3001,
  # 3002,
  # 3003
]

## Backend Hosts
host_api_course = {
  domain_name : "teste-api-course.leveducacao.sambatech.dev"
  subject_alternative_names : []
}

# host_api_file = {
#   domain_name : "teste-api-file.leveducacao.sambatech.dev"
#   subject_alternative_names : []
# }

# host_api_support = {
#   domain_name : "teste-api-support.leveducacao.sambatech.dev"
#   subject_alternative_names : []
# }

# host_api_exam = {
#   domain_name : "teste-api-exam.leveducacao.sambatech.dev"
#   subject_alternative_names : []
# }

# host_api_leve_client = {
#   domain_name : "teste-api.leveducacao.sambatech.dev"
#   subject_alternative_names : []
# }

# # Frontend Hosts

# host_leve_front = {
#   domain_name : "testeleveducacao.sambatech.dev"
#   subject_alternative_names : ["www.testeleveducacao.sambatech.dev"]
# }

# host_leve_admin = {
#   domain_name : "teste-admin.leveducacao.sambatech.dev"
#   subject_alternative_names : []
# }

# ## ECS Configure

# max_capacity_api_leve_client = 4
# cpu_api_leve_client          = 1024
# memory_api_leve_client       = 2048

max_capacity_api_course = 4
cpu_api_course          = 1024
memory_api_course       = 2048