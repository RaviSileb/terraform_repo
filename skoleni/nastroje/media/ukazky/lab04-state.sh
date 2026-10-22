#!/usr/bin/env bash
# Ukázka: lab 04 – state, import a moved
source "$(dirname "$0")/spolecne.sh"
cd "$1"
komentar "Lab 04: state, import, moved (výstupy zkráceny)"
spust "terraform apply -auto-approve" "terraform init >/dev/null && terraform apply -auto-approve | grep -E 'Apply complete'"
spust "terraform state list"
komentar "Kolega ručně vytvořil síť – převezmeme ji blokem import"
spust "docker network create --label tym=platforma lab04-legacy-sit" "docker network create --label tym=platforma lab04-legacy-sit >/dev/null; echo hotovo"
spust "mv import.tf.pripraveny import.tf && cat import.tf"
spust "terraform plan -generate-config-out=generated.tf" "terraform plan -generate-config-out=generated.tf | grep -E 'imported|Plan:'" 2
spust "grep -A3 'resource' generated.tf"
spust "terraform apply -auto-approve" "terraform apply -auto-approve | grep -E 'Import complete|Apply complete'"
komentar "Přejmenování web → frontend: s blokem moved bez zničení"
spust "mv moved.tf.pripraveny moved.tf && cat moved.tf"
spust "sed -i 's/\"docker_container\" \"web\"/\"docker_container\" \"frontend\"/' main.tf"
spust "terraform plan" "terraform plan | grep -E 'moved|Plan:'" 3
spust "terraform apply -auto-approve" "terraform apply -auto-approve | grep -E 'Apply complete'"
spust "terraform state list" "terraform state list" 2.5
