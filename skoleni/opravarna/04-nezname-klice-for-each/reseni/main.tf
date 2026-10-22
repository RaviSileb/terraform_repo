terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

locals {
  servery = toset(["web", "api", "db"])
}

resource "random_pet" "server" {
  for_each = local.servery
}

resource "local_file" "server" {
  for_each = local.servery

  filename = "${path.module}/vystup/${each.key}.txt"
  content  = random_pet.server[each.key].id
}
