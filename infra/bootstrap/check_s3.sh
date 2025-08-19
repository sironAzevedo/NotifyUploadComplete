#!/bin/bash
# check_s3.sh

# A AWS CLI precisa estar instalada e configurada no ambiente que roda o Terraform.
BUCKET_NAME=$1

# O comando 'head-bucket' é a forma mais rápida de checar a existência e permissão.
# Redirecionamos stderr para /dev/null para ignorar a saída de erro 404.
aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null

# Verificamos o código de saída do comando anterior. 0 = sucesso (existe), outro valor = erro (não existe ou sem permissão).
if [ $? -eq 0 ]; then
  # Se o bucket existe, retorna um JSON com exists=true
  echo "{\"exists\": \"true\"}"
else
  # Se não existe, retorna um JSON com exists=false
  echo "{\"exists\": \"false\"}"
fi