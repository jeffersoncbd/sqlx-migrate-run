#!/bin/sh
set -e

sqlx database create && echo "Banco de dados criado com sucesso."
sqlx migrate run && echo "Migrations aplicadas com sucesso."
cargo sqlx prepare && echo "Informações do banco geradas para o SQLx"
git add .
git commit -m "sqlx prepare"
git push
