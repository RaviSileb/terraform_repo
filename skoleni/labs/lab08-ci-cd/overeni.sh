#!/usr/bin/env bash
# Kontrola vašeho workflow. Použití: ./overeni.sh [cesta k workflow]
set -uo pipefail
WF="${1:-$(git rev-parse --show-toplevel)/.github/workflows/lab08-terraform.yml}"
[ -f "$WF" ] || { echo "❌ Soubor $WF neexistuje – zkopírujte workflow do .github/workflows/"; exit 1; }

ok=0; fail=0
BEZ_KOMENTARU=$(grep -Ev '^\s*#' "$WF")
check() { if grep -Eq -- "$2" <<<"$BEZ_KOMENTARU"; then echo "✅ $1"; ok=$((ok+1)); else echo "❌ $1"; fail=$((fail+1)); fi; }

if command -v actionlint >/dev/null; then
  if actionlint "$WF"; then echo "✅ actionlint bez chyb"; ok=$((ok+1)); else echo "❌ actionlint hlásí chyby"; fail=$((fail+1)); fi
else
  echo "ℹ️  actionlint není nainstalován – syntaktická kontrola přeskočena"
fi
check "spouští se na pull request"            "^\s*pull_request:"
check "spouští se po pushi do main"           "branches:\s*\[\s*main\s*\]|^\s*-\s*main\s*$"
check "omezená oprávnění tokenu"              "^\s*contents:\s*read"
check "concurrency bez přerušování"           "cancel-in-progress:\s*false"
check "kontrola formátu"                      "terraform fmt -check"
check "validace"                              "terraform validate"
check "testy"                                 "terraform test"
check "plán do souboru"                       "terraform plan .*-out"
check "souhrn běhu (GITHUB_STEP_SUMMARY)"      "GITHUB_STEP_SUMMARY"
check "artefakt s plánem"                     "actions/upload-artifact@"
check "schvalovací environment"               "environment:\s*\S+"
check "apply uloženého plánu"                 "terraform apply .*tfplan"
echo "Výsledek: $ok/$((ok+fail))"
[ "$fail" -eq 0 ]
