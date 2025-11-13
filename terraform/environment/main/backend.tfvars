# =========================================
# CONFIGURAÇÃO DO BACKEND S3 - DESENVOLVIMENTO
# =========================================
# Este arquivo contém as configurações do backend S3 para o ambiente
# de desenvolvimento. É usado com o comando:
# terraform init -backend-config=environment/dev/backend.tfvars

# Nome do bucket S3 onde o state file será armazenado
# Este bucket deve existir previamente e ter versionamento habilitado
bucket = "meu-bucket-linuxtips-statefiles"

# Caminho (key) dentro do bucket onde o state file será salvo
# Padrão: services/{service_name}/{environment}
key = "services/chip/dev"

# Região AWS onde o bucket S3 está localizado
region = "us-east-1"