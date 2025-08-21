#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="$1"

if aws s3api head-bucket --bucket "$BUCKET_NAME" >/dev/null 2>&1; then
  printf '{"exists":"true","bucket_name":"%s"}\n' "$BUCKET_NAME"
else
  printf '{"exists":"false","bucket_name":"%s"}\n' "$BUCKET_NAME"
fi