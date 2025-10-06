# =========================================
# TERRAFORM OUTPUTS
# =========================================
# Este arquivo define os outputs que serão exibidos após
# a aplicação do Terraform e podem ser utilizados por
# outros módulos ou para referência

# TODO: Adicionar outputs úteis aqui, como:
# - ARN do serviço ECS criado
# - URL do Load Balancer
# - Nome do repositório ECR
# - ARN da IAM Role

# Exemplo de outputs que podem ser adicionados:
#
# output "service_arn" {
#   description = "ARN do serviço ECS criado"
#   value       = module.service.service_arn
# }
#
# output "ecr_repository_url" {
#   description = "URL do repositório ECR"
#   value       = module.service.ecr_repository_url
# }
#
# output "iam_role_arn" {
#   description = "ARN da IAM Role para execução das tasks"
#   value       = aws_iam_role.main.arn
# }