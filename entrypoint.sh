#!/bin/sh
set -e

sqlx database create && echo "Banco de dados criado com sucesso."
sqlx migrate run && echo "Migrations aplicadas com sucesso."
