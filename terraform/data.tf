# =========================================
# DATA SOURCES - PARÂMETROS DO SSM
# =========================================
# Este arquivo contém os data sources que buscam informações
# dos parâmetros armazenados no AWS Systems Manager (SSM).
# Estes parâmetros foram criados pela infraestrutura de rede
# e são reutilizados aqui para conectar o serviço à rede existente.

# Busca o VPC ID armazenado no SSM Parameter Store
# Este VPC foi criado pela infraestrutura de rede
data "aws_ssm_parameter" "vpc_id" {
  name = var.ssm_vpc_id
}

# Busca o ARN do listener do Application Load Balancer
# O ALB foi criado pela infraestrutura de rede/cluster
data "aws_ssm_parameter" "alb" {
  name = var.ssm_alb
}

# Busca o ARN do listener do Application Load Balancer
# O ALB foi criado pela infraestrutura de rede/cluster
data "aws_ssm_parameter" "listener" {
  name = var.ssm_listener
}

# Busca o ID da primeira subnet privada
# As subnets foram criadas pela infraestrutura de rede
data "aws_ssm_parameter" "private_subnet_1" {
  name = var.ssm_private_subnet_1
}

# Busca o ID da segunda subnet privada
# Utilizada para alta disponibilidade em múltiplas AZs
data "aws_ssm_parameter" "private_subnet_2" {
  name = var.ssm_private_subnet_2
}

# Busca o ID da terceira subnet privada
# Garante distribuição em três AZs para maior resiliência
data "aws_ssm_parameter" "private_subnet_3" {
  name = var.ssm_private_subnet_3
}