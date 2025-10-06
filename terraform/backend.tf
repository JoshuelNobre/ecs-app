# =========================================
# TERRAFORM BACKEND CONFIGURATION
# =========================================
# Configuração do backend remoto para armazenar o state file
# O state é armazenado no Amazon S3 para permitir colaboração
# em equipe e manter o estado da infraestrutura de forma segura

terraform {
  # Backend S3 - armazena o state file no Amazon S3
  # Os parâmetros (bucket, key, region) são definidos no
  # arquivo backend.tfvars e passados via linha de comando
  backend "s3" {
    # As configurações são definidas em:
    # terraform/environment/dev/backend.tfvars
  }
}