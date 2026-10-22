#!/usr/bin/env bash
# Automatická kontrola labů (autograder).
#
#   skoleni/nastroje/zkontroluj.sh <cil> [start|reseni] [--integrace]
#
#   <cil>       lab01 … lab08, capstone, opravarna, nebo vse
#   start       vaše práce (výchozí), reseni = referenční řešení
#   --integrace spustí i integrační testy proti Dockeru (lab03, capstone)
#
# Exit code 0 = vše prošlo. Souhrn se při běhu v GitHub Actions zapíše do $GITHUB_STEP_SUMMARY.
set -uo pipefail

KOREN="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LABS="$KOREN/labs"
CIL="${1:-}"
VARIANTA="start"
INTEGRACE=0
for a in "${@:2}"; do
  case "$a" in
    start|reseni) VARIANTA="$a" ;;
    --integrace)  INTEGRACE=1 ;;
    *) echo "Neznámý argument: $a" >&2; exit 2 ;;
  esac
done
[ -n "$CIL" ] || { sed -n '2,12p' "$0"; exit 2; }

export CHECKPOINT_DISABLE=1 TF_IN_AUTOMATION=1 TF_INPUT=0
LOG="$(mktemp -d)"
trap 'rm -rf "$LOG"' EXIT
VYSLEDKY=()

# krok <popis> <adresář> <příkaz...>
krok() {
  local popis="$1" dir="$2"; shift 2
  local log="$LOG/$(echo "$popis" | tr -c 'a-zA-Z0-9' '_').log"
  if (cd "$dir" && "$@") >"$log" 2>&1; then
    echo "  ✅ $popis"
    return 0
  fi
  echo "  ❌ $popis"
  sed 's/^/     │ /' "$log" | tail -25
  return 1
}

# Standardní sada: fmt, init, validate, test
zakladni() {
  local nazev="$1" dir="$2" r=0
  krok "$nazev: terraform fmt" "$dir" terraform fmt -check -recursive || r=1
  krok "$nazev: terraform init" "$dir" terraform init -input=false -no-color || return 1
  krok "$nazev: terraform validate" "$dir" terraform validate -no-color || r=1
  if compgen -G "$dir/tests/*.tftest.hcl" >/dev/null; then
    krok "$nazev: terraform test" "$dir" terraform test -no-color || r=1
  fi
  return $r
}

lab_adresar() { compgen -G "$LABS/$1-*" | head -1; }

zkontroluj_lab() {
  local lab="$1" base dir r=0
  base="$(lab_adresar "$lab")"
  [ -n "$base" ] || { echo "Lab $lab neexistuje" >&2; return 2; }
  dir="$base/$VARIANTA"
  echo "▶ $lab ($VARIANTA)"

  case "$lab" in
    lab01|lab02|lab05)
      zakladni "$lab" "$dir" || r=1 ;;
    lab03)
      zakladni "$lab" "$dir" || r=1
      if [ "$INTEGRACE" = 1 ]; then
        krok "$lab: init integračních testů" "$dir" terraform init -input=false -no-color -test-directory=tests-integrace &&
        krok "$lab: integrační test (Docker + HTTP)" "$dir" terraform test -no-color -test-directory=tests-integrace || r=1
      fi ;;
    lab04)
      if [ "$VARIANTA" = start ]; then
        krok "$lab: ověření stavu (overeni.sh)" "$dir" "$base/overeni.sh" || r=1
      else
        zakladni "$lab" "$dir" || r=1
      fi ;;
    lab06)
      zakladni "$lab" "$dir" || r=1
      zakladni "$lab/modul webapp" "$dir/moduly/webapp" || r=1 ;;
    lab07)
      zakladni "$lab" "$dir" || r=1
      krok "$lab: mutační testování (≥ 80 %)" "$base" python3 "$base/mutace.py" "$dir" || r=1 ;;
    lab08)
      zakladni "$lab/infra" "$base/infra" || r=1
      local wf
      if [ "$VARIANTA" = reseni ]; then wf="$dir/lab08-terraform.yml"; else wf="$KOREN/../.github/workflows/lab08-terraform.yml"; fi
      krok "$lab: kontrola workflow" "$base" "$base/overeni.sh" "$wf" || r=1 ;;
  esac
  return $r
}

zkontroluj_capstone() {
  local dir r=0
  if [ "$VARIANTA" = reseni ]; then dir="$LABS/capstone/reseni"; else dir="${CAPSTONE_DIR:-}"; fi
  if [ -z "$dir" ]; then
    echo "▶ capstone (start): nastavte CAPSTONE_DIR=<cesta k vašemu projektu>"; return 1
  fi
  echo "▶ capstone ($dir)"
  for m in "$dir"/moduly/*/; do zakladni "capstone/$(basename "$m")" "$m" || r=1; done
  for e in "$dir"/prostredi/*/; do
    local env; env="$(basename "$e")"
    zakladni "capstone/$env" "$e" || r=1
    if [ "$INTEGRACE" = 1 ]; then
      rm -rf "$e/akceptace" && cp -r "$LABS/capstone/akceptace" "$e/akceptace"
      krok "capstone/$env: init akceptace" "$e" terraform init -input=false -no-color -test-directory=akceptace &&
      krok "capstone/$env: akceptační test" "$e" terraform test -no-color -test-directory=akceptace || r=1
      rm -rf "$e/akceptace"
    fi
  done
  return $r
}

# start = úloha je opravená (prochází), reseni = referenční řešení prochází
zkontroluj_opravarnu() {
  local r=0 u dir
  echo "▶ opravarna ($VARIANTA)"
  for u in "$KOREN"/opravarna/[0-9]*/; do
    dir="$u"; [ "$VARIANTA" = reseni ] && dir="$u/reseni"
    local n; n="$(basename "$u")"
    krok "$n: init" "$dir" terraform init -input=false -no-color &&
    krok "$n: validate + plan" "$dir" sh -c 'terraform validate -no-color && terraform plan -no-color -input=false' || r=1
  done
  return $r
}

spust() {
  local cil="$1" rc
  case "$cil" in
    lab0[1-8]) zkontroluj_lab "$cil" ;;
    capstone)  zkontroluj_capstone ;;
    opravarna) zkontroluj_opravarnu ;;
    *) echo "Neznámý cíl: $cil" >&2; return 2 ;;
  esac
  rc=$?
  VYSLEDKY+=("$cil:$rc")
  return $rc
}

celkem=0
if [ "$CIL" = vse ]; then
  for c in lab01 lab02 lab03 lab04 lab05 lab06 lab07 lab08 opravarna; do spust "$c" || celkem=1; echo; done
else
  spust "$CIL" || celkem=1
fi

souhrn="| Úloha | Výsledek |\n|---|---|\n"
for v in "${VYSLEDKY[@]}"; do
  [ "${v#*:}" = 0 ] && stav="✅ splněno" || stav="❌ zatím ne"
  souhrn+="| ${v%%:*} | $stav |\n"
done
echo -e "\n$souhrn"
if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  echo -e "### Terraform školení – $VARIANTA\n\n$souhrn" >> "$GITHUB_STEP_SUMMARY"
fi
exit $celkem
