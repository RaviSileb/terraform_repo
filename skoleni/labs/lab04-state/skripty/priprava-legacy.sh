#!/usr/bin/env bash
# Simuluje „ruční“ zásah kolegy: síť a volume vytvořené mimo Terraform.
set -euo pipefail
docker network create --label tym=platforma lab04-legacy-sit
docker volume create --label tym=platforma lab04-data
echo "Hotovo. Ručně vytvořené zdroje:"
docker network ls --filter name=lab04-legacy-sit
docker volume ls --filter name=lab04-data
