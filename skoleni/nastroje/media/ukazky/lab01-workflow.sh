#!/usr/bin/env bash
# Ukázka: lab 01 – init, plan, apply, idempotence, replace, destroy
source "$(dirname "$0")/spolecne.sh"
cd "$1"
komentar "Lab 01: workflow init → plan → apply (výstupy zkráceny)"
spust "sed -n '16,24p' main.tf"
spust "terraform init" "terraform init | grep -E 'Installing|Installed|initialized'"
spust "terraform plan" "terraform plan | grep -E '^  #|^  \+ resource|Plan:|known after'" 2.5
spust "terraform apply -auto-approve" "terraform apply -auto-approve | grep -E 'Creation complete|Apply complete|jmeno_'"
spust "cat vystup/pozdrav.txt"
komentar "Idempotence: druhý apply bez změny kódu nic nezmění"
spust "terraform apply -auto-approve" "terraform apply -auto-approve | grep -E 'No changes|Apply complete'"
komentar "Změna obsahu souboru: in-place, nebo replace?"
spust "sed -i 's/Ahoj, jsem/Čau, já jsem/' main.tf"
spust "terraform plan" "terraform plan | grep -E 'must be|forces replacement|Plan:'" 3
spust "terraform destroy -auto-approve" "terraform destroy -auto-approve | grep -E 'Destroy complete'" 2.5
