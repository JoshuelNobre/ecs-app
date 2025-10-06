# =========================================
# CONFIGURAÇÃO DO AMBIENTE DE DESENVOLVIMENTO
# =========================================
# Este arquivo contém os valores das variáveis para o ambiente
# de desenvolvimento. Cada ambiente (dev, staging, prod) deve
# ter seu próprio arquivo terraform.tfvars

# ========== CONFIGURAÇÕES BÁSICAS ==========

# Região AWS onde os recursos serão criados
region = "us-east-1"

# Nome do cluster ECS existente (criado pela infraestrutura base)
cluster_name = "linux-tips-ecs-cluster"

# Nome do serviço que será criado
# Este nome será usado para nomear todos os recursos relacionados
service_name = "chip"

# ========== CONFIGURAÇÕES DO CONTAINER ==========

# Porta onde a aplicação escuta dentro do container
service_port = 8080

# CPU alocada para cada task (em unidades de CPU)
# 256 = 0.25 vCPU, 512 = 0.5 vCPU, 1024 = 1 vCPU
service_cpu = 256

# Memória alocada para cada task em MB
# Deve ser compatível com o valor de CPU escolhido
service_memory = 512

# ========== CONFIGURAÇÕES DO ECS ==========

# Tipo de launch para as tasks
# EC2: executa em instâncias EC2 gerenciadas por você
# FARGATE: serverless, AWS gerencia a infraestrutura
service_launch_type = "EC2"

# Número de tasks que devem estar rodando simultaneamente
# Para desenvolvimento, 3 tasks oferecem boa disponibilidade
service_task_count = 3

# ========== PARÂMETROS DO SSM ==========
# Estes parâmetros foram criados pela infraestrutura de rede
# e contêm informações sobre VPC, subnets e load balancer

# Parâmetro que contém o ID da VPC
ssm_vpc_id = "/linuxtips-vpc/vpc/vpc_id"

# Parâmetro que contém o ARN do listener do Application Load Balancer
ssm_listener = "/linuxtips/ecs/lb/listener"

# Parâmetros que contêm os IDs das subnets privadas
# As tasks serão distribuídas entre essas 3 subnets para alta disponibilidade
ssm_private_subnet_1 = "/linuxtips-vpc/vpc/private_subnet_1a"
ssm_private_subnet_2 = "/linuxtips-vpc/vpc/private_subnet_1b"
ssm_private_subnet_3 = "/linuxtips-vpc/vpc/private_subnet_1c"

# ========== CONFIGURAÇÕES DO LOAD BALANCER ==========

# Lista de hosts/domínios que serão roteados para este serviço
# O Application Load Balancer usará esses hosts para routing
service_hosts = [
  "joshuel.com.br"
]

# ========== VARIÁVEIS DE AMBIENTE ==========
# Variáveis de ambiente que serão injetadas no container
# Útil para configurações específicas do ambiente

environment_variables = [
  {
    name  = "FOO",
    value = "BAR"
  },
  {
    name  = "PING",
    value = "PONG"
  }
]

# ========== CAPACIDADES DA TASK DEFINITION ==========
# Define em que tipo de infraestrutura a task pode executar
capabilities = ["EC2"]

# ========== CONFIGURAÇÕES DO HEALTH CHECK ==========
# Configurações para o health check do Target Group do ALB
# O ALB usará essas configurações para verificar se o serviço está saudável

service_healthcheck = {
  # Número de checks consecutivos bem-sucedidos para considerar healthy
  health_threshold   = 3
  # Número de checks consecutivos falhados para considerar unhealthy
  unhealth_threshold = 10
  # Timeout em segundos para cada health check
  timeout            = 10
  # Intervalo em segundos entre health checks
  interval           = 60
  # Códigos de resposta HTTP considerados como success
  matcher            = "200-399"
  # Caminho da API que será chamada para o health check
  path               = "/healthcheck"
  # Porta onde o health check será feito (mesma porta da aplicação)
  port               = 8080
}