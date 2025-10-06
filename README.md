# ECS Service Application

Este repositório contém a configuração Terraform para deployar uma aplicação containerizada no Amazon ECS (Elastic Container Service), incluindo todas as configurações necessárias para integração com Application Load Balancer, Security Groups e CloudWatch Logs.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Arquitetura](#arquitetura)
- [Pré-requisitos](#pré-requisitos)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Configuração](#configuração)
- [Deploy](#deploy)
- [Monitoramento](#monitoramento)
- [Troubleshooting](#troubleshooting)
- [Limpeza](#limpeza)

## 🔍 Visão Geral

Este projeto provisiona:

- **Serviço ECS** com task definition configurada
- **IAM Roles** com permissões mínimas necessárias
- **Target Group** para integração com Application Load Balancer
- **Security Groups** para controle de acesso
- **CloudWatch Log Groups** para logs da aplicação
- **ECR Repository** para armazenamento de imagens Docker

## 🏗️ Arquitetura

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Internet      │────│  Application     │────│   ECS Service   │
│   Gateway       │    │  Load Balancer   │    │   (3 tasks)     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                 │                        │
                                 │                        │
                       ┌──────────────────┐    ┌─────────────────┐
                       │   Target Group   │    │  Private Subnets │
                       │  Health Checks   │    │   (3 AZs)       │
                       └──────────────────┘    └─────────────────┘
```

### Componentes da Arquitetura:

- **VPC**: Rede privada virtual (criada pela infraestrutura base)
- **Subnets Privadas**: 3 subnets em diferentes AZs para alta disponibilidade
- **Application Load Balancer**: Distribui tráfego entre as tasks ECS
- **ECS Cluster**: Grupo de recursos de computação para executar containers
- **ECS Service**: Gerencia o número desejado de tasks rodando
- **Tasks**: Instâncias individuais dos containers

## ✅ Pré-requisitos

### Infraestrutura Base

Este projeto requer que a infraestrutura base já esteja criada, incluindo:

1. **VPC e Subnets**
2. **ECS Cluster**
3. **Application Load Balancer**
4. **Parâmetros SSM** com as seguintes informações:
   - `/linuxtips-vpc/vpc/vpc_id`
   - `/linuxtips/ecs/lb/listener`
   - `/linuxtips-vpc/vpc/private_subnet_1a`
   - `/linuxtips-vpc/vpc/private_subnet_1b`
   - `/linuxtips-vpc/vpc/private_subnet_1c`

### Ferramentas Necessárias

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado
- Acesso à conta AWS com as permissões necessárias
- Imagem Docker no ECR (se aplicável)

### Permissões AWS Necessárias

O usuário/role executando o Terraform precisa das seguintes permissões:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*",
        "iam:*",
        "logs:*",
        "ecr:*",
        "ssm:GetParameter",
        "elasticloadbalancing:*",
        "ec2:*"
      ],
      "Resource": "*"
    }
  ]
}
```

## 📁 Estrutura do Projeto

```
ecs-app/
├── app/
│   └── Dockerfile                    # Dockerfile da aplicação (se aplicável)
├── terraform/
│   ├── backend.tf                    # Configuração do backend S3
│   ├── data.tf                       # Data sources (SSM parameters)
│   ├── iam.tf                        # IAM roles e policies
│   ├── main.tf                       # Módulo principal ECS
│   ├── output.tf                     # Outputs do Terraform
│   ├── providers.tf                  # Configuração dos providers
│   ├── variables.tf                  # Definição das variáveis
│   └── environment/
│       └── dev/
│           ├── backend.tfvars        # Config do backend para dev
│           └── terraform.tfvars      # Valores das variáveis para dev
├── LICENSE                           # Licença do projeto
└── README.md                         # Este arquivo
```

## ⚙️ Configuração

### 1. Configurar Backend S3

Edite o arquivo `terraform/environment/dev/backend.tfvars`:

```hcl
bucket = "seu-bucket-terraform-state"
key    = "services/seu-servico/dev"
region = "us-east-1"
```

### 2. Configurar Variáveis

Edite o arquivo `terraform/environment/dev/terraform.tfvars`:

```hcl
# Configurações básicas
region       = "us-east-1"
cluster_name = "seu-cluster-ecs"
service_name = "seu-servico"

# Configurações do container
service_port   = 8080
service_cpu    = 256
service_memory = 512

# Configurações ECS
service_launch_type = "EC2"  # ou "FARGATE"
service_task_count  = 3

# Hosts para roteamento
service_hosts = [
  "seu-dominio.com"
]

# Health check
service_healthcheck = {
  health_threshold   = 3
  unhealth_threshold = 10
  timeout            = 10
  interval           = 60
  matcher            = "200-399"
  path               = "/healthcheck"
  port               = 8080
}
```

### 3. Configurar Variáveis de Ambiente

Adicione suas variáveis de ambiente no arquivo `terraform.tfvars`:

```hcl
environment_variables = [
  {
    name  = "NODE_ENV",
    value = "development"
  },
  {
    name  = "DATABASE_URL",
    value = "postgresql://..."
  }
]
```

## 🚀 Deploy

### 1. Inicializar Terraform

```bash
cd terraform
terraform init -backend-config=environment/dev/backend.tfvars
```

### 2. Validar Configuração

```bash
terraform validate
terraform fmt
```

### 3. Planejar Deploy

```bash
terraform plan -var-file=environment/dev/terraform.tfvars
```

### 4. Aplicar Configuração

```bash
terraform apply -var-file=environment/dev/terraform.tfvars
```

### 5. Confirmar Deploy

Digite `yes` quando solicitado para confirmar a criação dos recursos.

## 📊 Monitoramento

### CloudWatch Logs

Os logs da aplicação são automaticamente enviados para o CloudWatch Logs:

- **Log Group**: `/ecs/{cluster_name}/{service_name}`
- **Log Stream**: `{service_name}/{task_id}`

### Health Checks

O Application Load Balancer realiza health checks automaticamente:

- **Endpoint**: `/healthcheck`
- **Interval**: 60 segundos
- **Timeout**: 10 segundos
- **Healthy Threshold**: 3 checks consecutivos
- **Unhealthy Threshold**: 10 checks consecutivos

### Métricas ECS

Monitore as seguintes métricas no CloudWatch:

- `CPUUtilization`
- `MemoryUtilization`
- `TaskCount`
- `HealthyHostCount`

## 🔧 Troubleshooting

### Problema: Task Failed to Start

**Possíveis Causas:**
1. Imagem Docker não encontrada no ECR
2. Recursos insuficientes (CPU/Memory)
3. Problemas de rede/security groups
4. Falha no health check

**Soluções:**
1. Verificar se a imagem existe no ECR com a tag correta
2. Verificar logs no CloudWatch
3. Verificar security groups e conectividade de rede
4. Ajustar configurações do health check

### Problema: Health Check Falhando

**Soluções:**
1. Verificar se a aplicação está respondendo no endpoint `/healthcheck`
2. Verificar se a porta está correta
3. Ajustar timeout e intervalo do health check
4. Verificar logs da aplicação

### Comandos Úteis para Debug

```bash
# Verificar estado do serviço
aws ecs describe-services --cluster {cluster_name} --services {service_name}

# Verificar tasks em execução
aws ecs list-tasks --cluster {cluster_name} --service-name {service_name}

# Verificar logs
aws logs describe-log-groups --log-group-name-prefix "/ecs/"

# Verificar imagens no ECR
aws ecr describe-repositories
aws ecr list-images --repository-name {repository_name}
```

## 🧹 Limpeza

Para remover todos os recursos criados:

```bash
cd terraform
terraform destroy -var-file=environment/dev/terraform.tfvars
```

⚠️ **Atenção**: Este comando removerá permanentemente todos os recursos. Use com cuidado em ambientes de produção.

## 📝 Variáveis de Configuração

### Variáveis Obrigatórias

| Variável | Tipo | Descrição |
|----------|------|-----------|
| `region` | string | Região AWS |
| `cluster_name` | string | Nome do cluster ECS |
| `service_name` | string | Nome do serviço |
| `service_port` | number | Porta da aplicação |
| `service_cpu` | number | CPU da task |
| `service_memory` | number | Memória da task |

### Variáveis Opcionais

| Variável | Tipo | Padrão | Descrição |
|----------|------|--------|-----------|
| `service_task_count` | number | 1 | Número de tasks |
| `service_launch_type` | string | "EC2" | Tipo de launch |
| `environment_variables` | list | [] | Variáveis de ambiente |

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📞 Suporte

Se você encontrar problemas ou tiver dúvidas:

1. Verifique a seção [Troubleshooting](#troubleshooting)
2. Consulte a documentação oficial da AWS
3. Abra uma issue neste repositório

---

**Desenvolvido com ❤️ para a comunidade LinuxTips**