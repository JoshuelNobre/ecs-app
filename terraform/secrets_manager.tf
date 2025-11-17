resource "aws_secretsmanager_secret" "teste" {
  name = format("%s-secret-exemplo", var.service_name)
}

resource "aws_secretsmanager_secret_version" "teste" {
  secret_id     = aws_secretsmanager_secret.teste.id
  secret_string = "Vim lá do secrets manager"
}