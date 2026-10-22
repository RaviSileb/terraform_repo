#!/usr/bin/env bash
# Spustí PostgreSQL jako vzdálený backend se zamykáním stavu (bonus, krok 8).
set -euo pipefail
docker run -d --name lab04-tfstate-db \
  -e POSTGRES_USER=terraform -e POSTGRES_PASSWORD=terraform -e POSTGRES_DB=terraform_state \
  -p 55432:5432 postgres:17-alpine
echo "Čekám, až databáze začne přijímat spojení..."
until docker exec lab04-tfstate-db pg_isready -U terraform >/dev/null 2>&1; do sleep 1; done
echo 'Hotovo. Connection string: postgres://terraform:terraform@localhost:55432/terraform_state?sslmode=disable'
