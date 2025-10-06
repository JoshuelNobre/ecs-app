# =========================================
# ECS SERVICE MODULE
# =========================================
# Este módulo cria e configura um serviço ECS completo incluindo:
# - Task Definition
# - Service ECS
# - Target Group para Load Balancer
# - Security Groups
# - CloudWatch Logs
# - ECR Repository

module "service" {
  # Caminho para o módulo local do ECS Service
  source = "../../ecs-service-module"

  # ========== CONFIGURAÇÕES BÁSICAS ==========
  # Região AWS onde os recursos serão criados
  region = var.region
  
  # Nome do cluster ECS existente onde o serviço será deployed
  cluster_name = var.cluster_name
  
  # Nome do serviço (usado para nomear recursos)
  service_name = var.service_name

  # ========== CONFIGURAÇÕES DO CONTAINER ==========
  # Porta onde a aplicação escuta dentro do container
  service_port = var.service_port
  
  # CPU alocada para a task (256, 512, 1024, etc.)
  service_cpu = var.service_cpu
  
  # Memória alocada para a task em MB
  service_memory = var.service_memory

  # ========== CONFIGURAÇÕES DO LOAD BALANCER ==========
  # ARN do listener do Application Load Balancer (obtido do SSM)
  service_listener = data.aws_ssm_parameter.listener.value
  
  # Hosts/domínios que serão roteados para este serviço
  service_hosts = var.service_hosts

  # ========== CONFIGURAÇÕES DO ECS ==========
  # ARN da IAM Role para execução das tasks
  service_task_execution_role = aws_iam_role.main.arn
  
  # Configurações do health check do Target Group
  service_healthcheck = var.service_healthcheck
  
  # Tipo de launch (EC2 ou FARGATE)
  service_launch_type = var.service_launch_type
  
  # Número de tasks que devem estar rodando
  service_task_count = var.service_task_count
  
  # Capacidades requeridas para a task definition
  capabilities = var.capabilities

  # ========== VARIÁVEIS DE AMBIENTE ==========
  # Lista de variáveis de ambiente para o container
  environment_variables = var.environment_variables

  # ========== CONFIGURAÇÕES DE REDE ==========
  # VPC ID onde os recursos serão criados (obtido do SSM)
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  
  # Subnets privadas onde as tasks serão executadas (obtidas do SSM)
  private_subnets = [
    data.aws_ssm_parameter.private_subnet_1.value,
    data.aws_ssm_parameter.private_subnet_2.value,
    data.aws_ssm_parameter.private_subnet_3.value,
  ]
}