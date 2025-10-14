variable "region" {}

variable "cluster_name" {}

variable "service_name" {}

variable "service_port" {}

variable "service_cpu" {}

variable "service_memory" {}

variable "service_healthcheck" {}

variable "service_launch_type" {
  type    = list(object({
    capacity_provider = string
    weight            = number
  }))
}
variable "service_task_count" {}

variable "service_hosts" {}

variable "ssm_vpc_id" {}

variable "ssm_listener" {}

variable "ssm_private_subnet_1" {}

variable "ssm_private_subnet_2" {}

variable "ssm_private_subnet_3" {}

variable "ssm_alb" {}

variable "environment_variables" {}

# Capacidades requeridas para a task definition
variable "capabilities" {
  description = "Lista de capacidades requeridas (EC2, FARGATE, etc.)"
  type        = list(string)
}

# ========== CONFIGURAÇÕES DE AUTOSCALING ==========

# Tipo de escalonamento automático
variable "scale_type" {
  description = "Tipo de autoscaling (cpu_tracking, cpu)"
  type        = string
}

# ========== LIMITES DE ESCALONAMENTO ==========

# Número mínimo de tasks
variable "task_minimum" {
  description = "Número mínimo de tasks que devem estar sempre rodando"
  type        = number
}

# Número máximo de tasks
variable "task_maximum" {
  description = "Número máximo de tasks que podem ser criadas"
  type        = number
}

# ========== CONFIGURAÇÕES DE SCALE OUT (EXPANSÃO) ==========

# Threshold de CPU para scale out
variable "scale_out_cpu_threshold" {
  description = "Threshold de CPU em % que dispara o scale out"
  type        = number
}

# Ajuste do scale out
variable "scale_out_adjustment" {
  description = "Número de tasks a serem adicionadas no scale out"
  type        = number
}

# Operador de comparação para scale out
variable "scale_out_comparison_operator" {
  description = "Operador de comparação para o threshold de scale out"
  type        = string
}

# Estatística para scale out
variable "scale_out_statistic" {
  description = "Tipo de estatística usada para calcular a métrica (Average, Sum, etc.)"
  type        = string
}

# Período de avaliação para scale out
variable "scale_out_period" {
  description = "Período em segundos para avaliar a métrica de scale out"
  type        = number
}

# Períodos de avaliação para scale out
variable "scale_out_evaluation_periods" {
  description = "Número de períodos consecutivos para acionar scale out"
  type        = number
}

# Cooldown para scale out
variable "scale_out_cooldown" {
  description = "Tempo de cooldown em segundos após um scale out"
  type        = number
}

# ========== CONFIGURAÇÕES DE SCALE IN (REDUÇÃO) ==========

# Threshold de CPU para scale in
variable "scale_in_cpu_threshold" {
  description = "Threshold de CPU em % que dispara o scale in"
  type        = number
}

# Ajuste do scale in
variable "scale_in_adjustment" {
  description = "Número de tasks a serem removidas no scale in (valor negativo)"
  type        = number
}

# Operador de comparação para scale in
variable "scale_in_comparison_operator" {
  description = "Operador de comparação para o threshold de scale in"
  type        = string
}

# Estatística para scale in
variable "scale_in_statistic" {
  description = "Tipo de estatística usada para calcular a métrica (Average, Sum, etc.)"
  type        = string
}

# Período de avaliação para scale in
variable "scale_in_period" {
  description = "Período em segundos para avaliar a métrica de scale in"
  type        = number
}

# Períodos de avaliação para scale in
variable "scale_in_evaluation_periods" {
  description = "Número de períodos consecutivos para acionar scale in"
  type        = number
}

# Cooldown para scale in
variable "scale_in_cooldown" {
  description = "Tempo de cooldown em segundos após um scale in"
  type        = number
}

# ========== CONFIGURAÇÕES DE TARGET TRACKING ==========

# CPU alvo para target tracking
variable "scale_tracking_cpu" {
  description = "Valor alvo de utilização de CPU em % para target tracking scaling"
  type        = number
}


#Tracking Requests
variable "scale_tracking_requests" {}
