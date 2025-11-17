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
  # source = "github.com/JoshuelNobre/ecs-service-module?ref=v1.1.0"
  source = "/home/joshuel/estudo-ecs/ecs-service-module"

  # ========== CONFIGURAÇÕES BÁSICAS ==========
  # Região AWS onde os recursos serão criados
  region = var.region

  # Container image URI
  container_image = var.container_image

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

  secrets = [
    {
      name      = "VARIAVEL_COM_VALOR_DO_SSM"
      valueFrom = aws_ssm_parameter.teste.arn
    },
    {
      name      = "VARIAVEL_COM_VALOR_DO_SECRETS_MANAGER"
      valueFrom = aws_secretsmanager_secret.teste.arn
    },
    {
      name      = "VARIAVEL_PERSONALIZADA"
      valueFrom = "arn:aws:secretsmanager:us-east-1:550094086634:secret:prod/teste/credenciaisi-bblILI"
    },
    {
      name      = "VARIAVEL_PERSONALIZADA_DO_BANCO"
      valueFrom = "arn:aws:secretsmanager:us-east-1:550094086634:secret:prod/postgresql-DspohE"
    }
  ]

  # ========== CONFIGURAÇÕES DE REDE ==========
  # VPC ID onde os recursos serão criados (obtido do SSM)
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  # Subnets privadas onde as tasks serão executadas (obtidas do SSM)
  private_subnets = [
    data.aws_ssm_parameter.private_subnet_1.value,
    data.aws_ssm_parameter.private_subnet_2.value,
    data.aws_ssm_parameter.private_subnet_3.value,
  ]

  efs_volumes = [
    {
      volume_name      = "efs-volume"
      file_system_id   = aws_efs_file_system.main.id
      file_system_root = "/"
      mount_point      = "/mnt/efs"
      read_only        = false
    }
  ]

  # ========== CONFIGURAÇÕES DE AUTOSCALING ==========
  # Configurações para escalonamento automático do serviço ECS
  # Permite que o número de tasks varie automaticamente baseado em métricas

  # Tipo de escalonamento (cpu_tracking, memory_tracking, custom_tracking)
  scale_type = var.scale_type

  # ========== LIMITES DE ESCALONAMENTO ==========
  # Define os limites mínimo e máximo de tasks para o autoscaling
  task_minimum = var.task_minimum # Número mínimo de tasks sempre rodando
  task_maximum = var.task_maximum # Número máximo de tasks permitidas

  # ========== CONFIGURAÇÕES DE SCALE OUT (EXPANSÃO) ==========
  # Parâmetros para quando o serviço precisa aumentar o número de tasks
  scale_out_cpu_threshold       = var.scale_out_cpu_threshold       # Threshold de CPU em %
  scale_out_adjustment          = var.scale_out_adjustment          # Quantas tasks adicionar
  scale_out_comparison_operator = var.scale_out_comparison_operator # Operador de comparação
  scale_out_statistic           = var.scale_out_statistic           # Tipo de estatística
  scale_out_period              = var.scale_out_period              # Período de avaliação
  scale_out_evaluation_periods  = var.scale_out_evaluation_periods  # Períodos consecutivos
  scale_out_cooldown            = var.scale_out_cooldown            # Tempo de cooldown

  # ========== CONFIGURAÇÕES DE SCALE IN (REDUÇÃO) ==========
  # Parâmetros para quando o serviço precisa diminuir o número de tasks
  scale_in_cpu_threshold       = var.scale_in_cpu_threshold       # Threshold de CPU em %
  scale_in_adjustment          = var.scale_in_adjustment          # Quantas tasks remover
  scale_in_comparison_operator = var.scale_in_comparison_operator # Operador de comparação
  scale_in_statistic           = var.scale_in_statistic           # Tipo de estatística
  scale_in_period              = var.scale_in_period              # Período de avaliação
  scale_in_evaluation_periods  = var.scale_in_evaluation_periods  # Períodos consecutivos
  scale_in_cooldown            = var.scale_in_cooldown            # Tempo de cooldown

  # ========== TARGET TRACKING SCALING ==========
  # Configuração para manter a utilização de CPU próxima ao valor alvo
  scale_tracking_cpu = var.scale_tracking_cpu # CPU alvo em %

  #
  alb_arn                 = data.aws_ssm_parameter.alb.value
  scale_tracking_requests = var.scale_tracking_requests
}