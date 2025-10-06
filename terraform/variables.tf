# =========================================
# VARIÁVEIS DE CONFIGURAÇÃO
# =========================================
# Este arquivo define todas as variáveis utilizadas na configuração
# do serviço ECS. Os valores são definidos no arquivo terraform.tfvars

# ========== CONFIGURAÇÕES BÁSICAS ==========

# Região AWS onde os recursos serão criados
variable "region" {
  description = "Região AWS (ex: us-east-1, us-west-2)"
  type        = string
}

# Nome do cluster ECS existente
variable "cluster_name" {
  description = "Nome do cluster ECS onde o serviço será deployed"
  type        = string
}

# Nome do serviço (usado para nomear recursos)
variable "service_name" {
  description = "Nome do serviço ECS (usado para nomear recursos)"
  type        = string
}

# ========== CONFIGURAÇÕES DO CONTAINER ==========

# Porta da aplicação dentro do container
variable "service_port" {
  description = "Porta onde a aplicação escuta dentro do container"
  type        = number
}

# CPU alocada para a task
variable "service_cpu" {
  description = "CPU alocada para a task (256, 512, 1024, 2048, 4096)"
  type        = number
}

# Memória alocada para a task
variable "service_memory" {
  description = "Memória alocada para a task em MB"
  type        = number
}

# ========== CONFIGURAÇÕES DO ECS ==========

# Configurações do health check
variable "service_healthcheck" {
  description = "Configurações do health check do Target Group"
  type = object({
    health_threshold   = number
    unhealth_threshold = number
    timeout            = number
    interval           = number
    matcher            = string
    path               = string
    port               = number
  })
}

# Tipo de launch da task
variable "service_launch_type" {
  description = "Tipo de launch para as tasks (EC2 ou FARGATE)"
  type        = string
}

# Número de tasks desejadas
variable "service_task_count" {
  description = "Número de tasks que devem estar rodando simultaneamente"
  type        = number
}

# ========== CONFIGURAÇÕES DO LOAD BALANCER ==========

# Hosts que serão roteados para este serviço
variable "service_hosts" {
  description = "Lista de hosts/domínios que serão roteados para este serviço"
  type        = list(string)
}

# ========== PARÂMETROS DO SSM ==========

# Parâmetro SSM com o VPC ID
variable "ssm_vpc_id" {
  description = "Nome do parâmetro SSM que contém o VPC ID"
  type        = string
}

# Parâmetro SSM com o ARN do listener do ALB
variable "ssm_listener" {
  description = "Nome do parâmetro SSM que contém o ARN do listener do ALB"
  type        = string
}

# Parâmetros SSM com os IDs das subnets privadas
variable "ssm_private_subnet_1" {
  description = "Nome do parâmetro SSM que contém o ID da primeira subnet privada"
  type        = string
}

variable "ssm_private_subnet_2" {
  description = "Nome do parâmetro SSM que contém o ID da segunda subnet privada"
  type        = string
}

variable "ssm_private_subnet_3" {
  description = "Nome do parâmetro SSM que contém o ID da terceira subnet privada"
  type        = string
}

# ========== CONFIGURAÇÕES AVANÇADAS ==========

# Variáveis de ambiente para o container
variable "environment_variables" {
  description = "Lista de variáveis de ambiente para o container"
  type = list(object({
    name  = string
    value = string
  }))
}

# Capacidades requeridas para a task definition
variable "capabilities" {
  description = "Lista de capacidades requeridas (EC2, FARGATE, etc.)"
  type        = list(string)
}