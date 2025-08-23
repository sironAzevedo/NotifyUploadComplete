#!/usr/bin/env bash
set -euo pipefail

# Obtém os buckets definidos em locals
BUCKETS=$(terraform output -json buckets_to_destroy | jq -r '.[]')

for BUCKET in $BUCKETS; do
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
