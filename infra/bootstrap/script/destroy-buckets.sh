#!/usr/bin/env bash
set -euo pipefail

# A linha que lia o arquivo foi removida.
# O loop 'for' agora itera diretamente sobre os argumentos de linha de comando ("$@").

if [ "$#" -eq 0 ]; then
    echo "Nenhum bucket fornecido para exclusão. Encerrando."
    exit 0
fi

for BUCKET in "$@"; do
  echo "🔍 Verificando bucket: $BUCKET"
  
  if aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
    echo "🗑️  Apagando bucket: $BUCKET"

    # Caso tenha versionamento habilitado, remove todas as versões
    versions=$(aws s3api list-object-versions --bucket "$BUCKET" --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}' --output json)
    if [[ $versions != "{\"Objects\":[]}" ]]; then
      echo "   ↳ Removendo versões..."
      aws s3api delete-objects --bucket "$BUCKET" --delete "$versions" || true
    fi

    # Remove todos os objetos normais (sem versão)
    aws s3 rm "s3://$BUCKET" --recursive || true
    
    # Remove o bucket
    aws s3 rb "s3://$BUCKET" --force || true
    echo "✅ Bucket $BUCKET removido com sucesso!"
  else
    echo "⚠️  Bucket $BUCKET não existe no ambiente, ignorando..."
  fi
done