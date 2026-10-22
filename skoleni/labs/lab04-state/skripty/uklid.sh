#!/usr/bin/env bash
# Odstraní vše, co lab vytvořil mimo Terraform.
docker rm -f -v lab04-web lab04-tfstate-db 2>/dev/null || true
docker network rm lab04-legacy-sit 2>/dev/null || true
docker volume rm lab04-data 2>/dev/null || true
