#!/usr/bin/env bash
# Ověří splnění kroků 4–6 labu. Spusťte z adresáře s vaší konfigurací (start/).
set -uo pipefail
ok=0; fail=0
check() { if eval "$2" >/dev/null 2>&1; then echo "✅ $1"; ok=$((ok+1)); else echo "❌ $1"; fail=$((fail+1)); fi; }

state=$(terraform state list 2>/dev/null)
check "kontejner je ve stavu jako docker_container.frontend" "grep -qx 'docker_container.frontend' <<<\"\$state\""
check "adresa docker_container.web už ve stavu není"         "! grep -qx 'docker_container.web' <<<\"\$state\""
check "síť lab04-legacy-sit je importovaná"                   "grep -qx 'docker_network.legacy' <<<\"\$state\""
check "volume už Terraform nespravuje"                         "! grep -q 'docker_volume' <<<\"\$state\""
check "volume lab04-data přitom pořád existuje"                "docker volume inspect lab04-data"
check "kontejner lab04-web běží"                                  "[ \"\$(docker inspect -f '{{.State.Running}}' lab04-web)\" = true ]"
check "kontejner je připojen k síti lab04-legacy-sit"          "docker inspect -f '{{json .NetworkSettings.Networks}}' lab04-web | grep -q lab04-legacy-sit"
terraform plan -detailed-exitcode -input=false >/dev/null 2>&1; rc=$?
check "plán je prázdný (žádný drift)"                          "[ $rc -eq 0 ]"

echo "Výsledek: $ok/$((ok+fail))"
[ "$fail" -eq 0 ]
