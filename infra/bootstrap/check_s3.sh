#!/usr/bin/env bash
set -e

BUCKET_NAME=$(jq -r .bucket_name <<< "$1")

if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "{\"exists\": true}"
else
  echo "{\"exists\": false}"
fi