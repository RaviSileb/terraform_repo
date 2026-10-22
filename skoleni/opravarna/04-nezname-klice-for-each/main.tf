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

resource "random_pet" "server" {
  count = 3
}

resource "local_file" "server" {
  for_each = toset(random_pet.server[*].id)

  filename = "${path.module}/vystup/${each.key}.txt"
  content  = each.key
}
