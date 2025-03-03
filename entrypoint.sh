#!/bin/sh
set -e

sqlx database create && echo "Banco de dados criado com sucesso."
sqlx migrate run && echo "Migrations aplicadas com sucesso."
cargo sqlx prepare && echo "Pré-compilação de queries realizada com sucesso."

echo "Compactando pasta .sqlx para upload..."
tar -czf /tmp/sqlx_cache.tar.gz .sqlx

echo "Enviando arquivo .sqlx para o MinIO..."
curl -X PUT -T /tmp/sqlx_cache.tar.gz "$MINIO_URL/$MINIO_BUCKET/$PROJECT_NAME/sqlx_cache.tar.gz" \
  -H "Content-Type: application/octet-stream" \
  -H "x-amz-acl: private" \
  -u "$MINIO_ACCESS_KEY:$MINIO_SECRET_ACCESS_KEY"

echo "Upload da pasta .sqlx para o MinIO concluído com sucesso."
