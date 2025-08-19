#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME=$1

if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "{\"exists\": \"true\", \"bucket_name\": \"${BUCKET_NAME}\"}"
else
  echo "{\"exists\": \"false\", \"bucket_name\": \"${BUCKET_NAME}\"}"
fi