#!/bin/sh
set -e

export RUSTC_WRAPPER="/usr/local/bin/sccache"
export SCCACHE_REGION="auto"
export SCCACHE_ENDPOINT="$MINIO_URL"
export SCCACHE_BUCKET="$MINIO_BUCKET"
export AWS_ACCESS_KEY_ID="$MINIO_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="$MINIO_SECRET_ACCESS_KEY"

sqlx database create && echo "Banco de dados criado com sucesso."
sqlx migrate run && echo "Migrations aplicadas com sucesso."
cargo sqlx prepare && sccache --show-stats && echo "Pré-compilação de queries realizada com sucesso."

echo "Compactando pasta .sqlx para upload..."
tar -czf /tmp/sqlx_cache.tar.gz .sqlx

echo "Enviando arquivo .sqlx para o MinIO..."
aws s3 cp /tmp/sqlx_cache.tar.gz "s3://$MINIO_BUCKET/$PROJECT_NAME/sqlx_cache.tar.gz" --endpoint-url "$MINIO_URL"

echo "Upload da pasta .sqlx para o MinIO concluído com sucesso."
