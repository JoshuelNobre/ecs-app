# =========================================
# TERRAFORM PROVIDERS
# =========================================
# Configuração do provider AWS que será utilizado
# para criar e gerenciar os recursos na AWS

# Provider AWS - responsável por gerenciar recursos AWS
provider "aws" {
  # Região onde os recursos serão criados
  # Valor definido na variável 'region' no terraform.tfvars
  region = var.region
}