#!/bin/sh
set -e

sqlx database create && echo "Banco de dados criado com sucesso."
sqlx migrate run && echo "Migrations aplicadas com sucesso."
cargo sqlx prepare && echo "Informações do banco geradas para o SQLx"

git config --global user.email "sqlx-migrate-run@bot.com"
git config --global user.name "sqlx-migrate-run"
git add .
git commit -m "sqlx prepare"
git push
echo "Informações do banco enviadas para a branch"
