terraform {
  required_version = ">= 1.10"

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

resource "random_pet" "jmeno" {
  length    = 2
  separator = "-"
}

resource "local_file" "pozdrav" {
  filename = "${path.module}/vystup/pozdrav.txt"
  content  = "Ahoj, jsem ${random_pet.jmeno.id}!\n"
}

output "jmeno_mazlicka" {
  description = "Náhodně vygenerované jméno."
  value       = random_pet.jmeno.id
}

output "cesta_k_souboru" {
  value = local_file.pozdrav.filename
}
