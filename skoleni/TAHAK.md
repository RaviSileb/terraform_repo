# Tahák – Terraform na jednu stránku

## Příkazy
```bash
terraform init [-upgrade] [-migrate-state] [-backend-config=soubor]
terraform fmt [-check] [-recursive] [-diff]
terraform validate
terraform plan [-out=tfplan] [-var x=y] [-var-file=prod.tfvars] [-target=ADRESA] [-refresh-only] [-detailed-exitcode]
terraform plan -generate-config-out=generated.tf      # s import bloky
terraform apply [tfplan] [-auto-approve] [-replace=ADRESA] [-refresh-only]
terraform destroy
terraform output [-raw|-json] [JMÉNO]
terraform show [-json] [tfplan]
terraform state list | show ADRESA | mv | rm         # raději bloky moved/removed
terraform console
terraform graph | dot -Tsvg > graf.svg
terraform providers lock -platform=linux_amd64 -platform=darwin_arm64 -platform=windows_amd64
terraform test [-filter=tests/x.tftest.hcl] [-test-directory=tests] [-verbose]
terraform workspace list | new | select JMÉNO
terraform login                                       # HCP Terraform
```
Proměnné prostředí: `TF_VAR_jmeno`, `TF_LOG=DEBUG`, `TF_INPUT=false`, `TF_IN_AUTOMATION=true`, `TF_CLI_ARGS_plan="-parallelism=20"`.

## Bloky
```hcl
terraform {
  required_version = ">= 1.10"
  required_providers {
    docker = { source = "kreuzwerker/docker", version = "~> 4.0" }
  }
  backend "s3" {
    bucket       = "firma-tfstate"
    key          = "app/prod/terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
  }
}

provider "docker" { host = var.docker_host }

variable "port" {
  type        = number
  default     = 8080
  description = "…"
  sensitive   = false
  ephemeral   = false
  validation {
    condition     = var.port >= 1024
    error_message = "…"
  }
}

locals { nazev = "${var.app}-${var.env}" }

data "docker_registry_image" "nginx" { name = "nginx:1.30-alpine" }

resource "docker_container" "web" {
  for_each   = var.sluzby          # nebo count = 3
  name       = "web-${each.key}"
  image      = docker_image.nginx.image_id
  depends_on = []
  lifecycle {
    create_before_destroy = false
    prevent_destroy       = false
    ignore_changes        = []
    replace_triggered_by  = []
    precondition {
      condition     = true
      error_message = "…"
    }
  }
}

module "web" {
  source    = "./moduly/webapp"     # git::https://…//cesta?ref=v1.0.0 | org/jmeno/provider + version
  for_each  = var.prostredi
  providers = { docker = docker }
  nazev     = each.key
}

output "url" {
  value     = module.web["dev"].url
  sensitive = false
}

import {
  to = docker_network.x
  id = "nazev-site"
}

moved {
  from = docker_container.web
  to   = docker_container.frontend
}

removed {
  from = docker_volume.data
  lifecycle {
    destroy = false
  }
}

check "web" {
  data "http" "w" { url = "http://localhost:8080" }
  assert {
    condition     = data.http.w.status_code == 200
    error_message = "…"
  }
}
```

## Výrazy
| Co | Jak |
|---|---|
| šablona | `"${var.a}-${var.b}"`, `templatefile("x.tftpl", { … })` |
| podmínka | `var.prod ? 3 : 1` |
| for → seznam / mapa | `[for x in l : upper(x)]` · `{ for k, v in m : k => v.port }` |
| filtr | `[for k, s in m : k if s.zapnuto]` |
| splat | `docker_container.x[*].name` |
| zploštění | `merge([for … : { for … : k => v }]...)`, `flatten([...])` |
| bezpečný přístup | `try(var.cfg.port, 80)`, `lookup(m, k, výchozí)`, `coalesce(a, b)` |
| typy | `toset()`, `tolist()`, `tomap()`, `tonumber()`, `jsonencode()`, `yamldecode()` |

## Plán
`+` create · `~` update in-place · `-/+` replace (`# forces replacement`) · `-` destroy · `<=` read · `(known after apply)`

## Test
```hcl
mock_provider "docker" {}
variables { port = 8081 }
run "jmeno" {
  command = plan                     # výchozí apply
  variables { port = 9000 }
  override_resource {
    target = docker_container.web
    values = { id = "abc" }
  }
  assert {
    condition     = output.url == "http://localhost:9000"
    error_message = "…"
  }
}
run "spatny_vstup" {
  command         = plan
  variables { port = 80 }
  expect_failures = [var.port]
}
```

## Soubory
`main.tf` · `variables.tf` · `outputs.tf` · `versions.tf` · `terraform.tfvars` · `*.auto.tfvars` · `tests/*.tftest.hcl` · `.terraform.lock.hcl` (✅ Git) · `terraform.tfstate` (❌ Git) · `.terraform/` (❌ Git)
