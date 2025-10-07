# =========================================
# IAM ROLES E POLICIES PARA ECS
# =========================================
# Este arquivo define as permissões IAM necessárias para que
# as tasks do ECS possam executar corretamente, incluindo
# acesso ao ECR, CloudWatch Logs e outros serviços AWS

# IAM Role principal para execução das tasks ECS
# Esta role é assumida pelo serviço ECS para executar as tasks
resource "aws_iam_role" "main" {
  # Nome da role seguindo padrão: {service_name}-role
  name = format("%s-role", var.service_name)

  # Policy que permite ao ECS assumir esta role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Ação permitida: assumir role
        Action = "sts:AssumeRole"
        # Principal: serviço ECS pode assumir esta role
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

# Policy anexada à role com as permissões específicas necessárias
# para as tasks ECS executarem corretamente
resource "aws_iam_role_policy" "ecs_task_execution_policy" {
  # Nome da policy seguindo padrão: {service_name}-policy
  name = format("%s-policy", var.service_name)
  # Anexa a policy à role criada acima
  role = aws_iam_role.main.id

  # Definição das permissões em formato JSON
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Lista de ações permitidas para a role
        Action = [
          # ========== CLOUDWATCH LOGS ==========
          # Permissões para criar e escrever logs no CloudWatch
          "logs:CreateLogStream", # Criar stream de logs
          "logs:PutLogEvents",    # Enviar eventos de log
          "logs:CreateLogGroup",  # Criar grupo de logs

          # ========== ELASTIC CONTAINER REGISTRY (ECR) ==========
          # Permissões para acessar imagens Docker no ECR
          "ecr:GetAuthorizationToken",       # Obter token de autenticação
          "ecr:BatchCheckLayerAvailability", # Verificar disponibilidade de layers
          "ecr:GetDownloadUrlForLayer",      # Obter URL para download de layers
          "ecr:BatchGetImage",               # Baixar imagens do repositório

          # ========== AMAZON S3 ==========
          # Permissão para ler objetos do S3 (se necessário)
          "s3:GetObject",

          # ========== AMAZON SQS ==========
          # Permissões completas para SQS (se a aplicação usar filas)
          "sqs:*",
        ],
        # Aplica as permissões a todos os recursos
        # Em produção, considere restringir a recursos específicos
        Resource = "*",
        Effect   = "Allow"
      },
    ]
  })
}