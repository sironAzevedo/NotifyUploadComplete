#!/usr/bin/env bash
set -euo pipefail

# Declara uma variável para armazenar a saída JSON final.
JSON_OUTPUT=""
BUCKET_NAME=$1

# Tenta executar o comando e verifica o código de saída ($?).
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  # Se o comando for bem-sucedido, define a variável com o JSON de sucesso.
  JSON_OUTPUT="{\"exists\": \"true\", \"bucket_name\": \"${BUCKET_NAME}\"}"
else
  # Se o comando falhar, define a variável com o JSON de falha.
  JSON_OUTPUT="{\"exists\": \"false\", \"bucket_name\": \"${BUCKET_NAME}\"}"
fi

# Imprime o conteúdo final da variável.
# Esta é a única linha que enviará dados para o Terraform.
echo "$JSON_OUTPUT"