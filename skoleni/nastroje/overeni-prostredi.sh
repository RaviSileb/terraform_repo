#!/usr/bin/env bash
# Ověří, že máte vše potřebné pro školení. Spusťte z kořene repozitáře.
set -uo pipefail
ok=0; warn=0; fail=0
pass() { echo "✅ $1"; ok=$((ok+1)); }
miss() { echo "❌ $1"; fail=$((fail+1)); }
opt()  { echo "⚠️  $1"; warn=$((warn+1)); }

if command -v terraform >/dev/null; then
  v=$(terraform version -json 2>/dev/null | python3 -c 'import json,sys; print(json.load(sys.stdin)["terraform_version"])' 2>/dev/null || terraform version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
  if printf '%s\n%s\n' "1.10.0" "$v" | sort -V -C; then pass "Terraform $v"; else miss "Terraform $v je starší než 1.10 – aktualizujte"; fi
elif command -v tofu >/dev/null; then
  opt "Nalezen OpenTofu $(tofu version | head -1) – kurz je psán pro Terraform, většina labů funguje i v OpenTofu (viz modul 01)"
else
  miss "Terraform není nainstalován – https://developer.hashicorp.com/terraform/install"
fi

if command -v docker >/dev/null && docker info >/dev/null 2>&1; then
  pass "Docker $(docker version --format '{{.Server.Version}}' 2>/dev/null) běží (laby 03–06, capstone)"
elif command -v docker >/dev/null; then
  miss "Docker CLI je nainstalován, ale démon neběží nebo k němu nemáte přístup"
else
  miss "Docker není nainstalován (potřeba od labu 03) – https://docs.docker.com/get-docker/"
fi

command -v git     >/dev/null && pass "Git $(git --version | awk '{print $3}')" || miss "Git není nainstalován"
command -v python3 >/dev/null && pass "Python $(python3 --version | awk '{print $2}') (mutační testy v labu 07)" || opt "Python 3 chybí – potřeba jen pro lab 07"
command -v tflint  >/dev/null && pass "TFLint $(tflint --version | head -1 | awk '{print $3}')" || opt "TFLint chybí – doporučeno pro lab 07 (https://github.com/terraform-linters/tflint)"
command -v curl    >/dev/null && pass "curl" || opt "curl chybí – hodí se pro ověření webů v labech"

echo
echo "Výsledek: $ok OK, $warn doporučení, $fail chybí"
[ "$fail" -eq 0 ]
