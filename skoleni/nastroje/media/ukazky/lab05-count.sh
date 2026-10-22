#!/usr/bin/env bash
# Ukázka: lab 05 – past jménem count
source "$(dirname "$0")/spolecne.sh"
cd "$1"
komentar "Lab 05: count adresuje indexem (výstupy zkráceny)"
spust "terraform apply -auto-approve" "terraform init >/dev/null && terraform apply -auto-approve | grep -E 'Apply complete'"
spust "terraform state list" "terraform state list | grep container"
komentar "Odebereme prostřední službu api…"
spust "terraform plan -var 'sluzby_seznam=[\"web\",\"docs\"]'" "terraform plan -var 'sluzby_seznam=[\"web\",\"docs\"]' | grep -E 'must be|will be|forces replacement|Plan:'" 4
komentar "docs se nezměnila, přesto by se nahradila. Řešení: for_each + moved (lab 05, část B)"
spust "terraform destroy -auto-approve" "terraform destroy -auto-approve | grep -E 'Destroy complete'" 2.5
