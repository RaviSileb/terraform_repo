#!/usr/bin/env bash
# Ukázka: lab 03 – nginx v Dockeru, drift
source "$(dirname "$0")/spolecne.sh"
cd "$1"
komentar "Lab 03: provider Docker – nginx kontejner (výstupy zkráceny)"
spust "terraform init" "terraform init | grep -E 'Installing|Installed|initialized'"
spust "terraform apply -auto-approve" "terraform apply -auto-approve | grep -E 'Creation complete|Apply complete|url'" 2
spust "curl -s localhost:8080 | grep h1"
spust "docker ps --filter name=lab03 --format '{{.Names}}  {{.Image}}  {{.Ports}}'"
komentar "Změna titulku = nový obsah index.html → kontejner se nahradí"
spust "terraform plan -var titulek=Nazdar" "terraform plan -var titulek=Nazdar | grep -E 'must be|forces replacement|Plan:'" 2.5
komentar "Drift: někdo kontejner ručně smaže"
spust "docker rm -f lab03-web"
spust "terraform plan" "terraform plan | grep -E 'will be|Plan:'" 2.5
spust "terraform apply -auto-approve" "terraform apply -auto-approve | grep -E 'Apply complete'"
spust "terraform destroy -auto-approve" "terraform destroy -auto-approve | grep -E 'Destroy complete'" 2.5
