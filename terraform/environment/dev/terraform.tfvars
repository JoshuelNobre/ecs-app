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
  health_threshold = 3
  # Número de checks consecutivos falhados para considerar unhealthy
  unhealth_threshold = 10
  # Timeout em segundos para cada health check
  timeout = 10
  # Intervalo em segundos entre health checks
  interval = 60
  # Códigos de resposta HTTP considerados como success
  matcher = "200-399"
  # Caminho da API que será chamada para o health check
  path = "/healthcheck"
  # Porta onde o health check será feito (mesma porta da aplicação)
  port = 8080
}

# ========== CONFIGURAÇÕES DE AUTOSCALING ==========
# Configurações para escalonamento automático do serviço ECS
# O autoscaling permite que o número de tasks varie automaticamente
# baseado em métricas como CPU, memória ou custom metrics

# Tipo de escalonamento automático
# Opções: "cpu_tracking", "cpu"
scale_type = "cpu_tracking"

# ========== LIMITES DE ESCALONAMENTO ==========

# Número mínimo de tasks que devem estar sempre rodando
# Garante disponibilidade mínima mesmo com baixa utilização
task_minimum = 3

# Número máximo de tasks que podem ser criadas
# Evita custos excessivos e limita o crescimento do serviço
task_maximum = 12

# ========== CONFIGURAÇÕES DE SCALE OUT (EXPANSÃO) ==========
# Parâmetros para quando o serviço precisa aumentar o número de tasks

# Threshold de CPU em % que dispara o scale out
# Quando a CPU média passar de 50%, novas tasks serão criadas
scale_out_cpu_threshold = 50

# Número de tasks a serem adicionadas quando o scale out é acionado
# Valor positivo indica quantas tasks serão adicionadas
scale_out_adjustment = 2

# Operador de comparação para o threshold de scale out
# "GreaterThanOrEqualToThreshold" = maior ou igual ao threshold
scale_out_comparison_operator = "GreaterThanOrEqualToThreshold"

# Tipo de estatística usada para calcular a métrica
# "Average" = média da CPU durante o período
scale_out_statistic = "Average"

# Período em segundos para avaliar a métrica
# 60 segundos = avalia a CPU média a cada 1 minuto
scale_out_period = 60

# Número de períodos consecutivos que a condição deve ser verdadeira
# 2 períodos = a condição deve ser verdadeira por 2 minutos consecutivos
scale_out_evaluation_periods = 2

# Tempo de cooldown em segundos após um scale out
# 60 segundos = aguarda 1 minuto antes de permitir outro scale out
scale_out_cooldown = 60

# ========== CONFIGURAÇÕES DE SCALE IN (REDUÇÃO) ==========
# Parâmetros para quando o serviço precisa diminuir o número de tasks

# Threshold de CPU em % que dispara o scale in
# Quando a CPU média ficar abaixo de 30%, tasks serão removidas
scale_in_cpu_threshold = 30

# Número de tasks a serem removidas quando o scale in é acionado
# Valor negativo indica quantas tasks serão removidas
scale_in_adjustment = -1

# Operador de comparação para o threshold de scale in
# "LessThanOrEqualToThreshold" = menor ou igual ao threshold
scale_in_comparison_operator = "LessThanOrEqualToThreshold"

# Tipo de estatística usada para calcular a métrica
# "Average" = média da CPU durante o período
scale_in_statistic = "Average"

# Período em segundos para avaliar a métrica
# 60 segundos = avalia a CPU média a cada 1 minuto
scale_in_period = 60

# Número de períodos consecutivos que a condição deve ser verdadeira
# 2 períodos = a condição deve ser verdadeira por 2 minutos consecutivos
scale_in_evaluation_periods = 2

# Tempo de cooldown em segundos após um scale in
# 60 segundos = aguarda 1 minuto antes de permitir outro scale in
scale_in_cooldown = 60

# ========== CONFIGURAÇÃO DE TARGET TRACKING ==========
# Configuração para Target Tracking Scaling Policy
# Mantém automaticamente a utilização de CPU próxima ao valor alvo

# Valor alvo de utilização de CPU em %
# O autoscaling tentará manter a CPU média próxima a 50%
scale_tracking_cpu = 50