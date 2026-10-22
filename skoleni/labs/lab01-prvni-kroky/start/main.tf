terraform {
  required_version = ">= 1.10"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    # TODO 1: přidejte provider "local" (source hashicorp/local, verze ~> 2.5)
  }
}

# TODO 2: resource "random_pet" "jmeno" – dvě slova oddělená pomlčkou
#         (argumenty length a separator)

# TODO 3: resource "local_file" "pozdrav"
#         filename = "${path.module}/vystup/pozdrav.txt"
#         content  = "Ahoj, jsem <jméno z random_pet>!\n"

# TODO 4: output "jmeno_mazlicka" – vrací id z random_pet.jmeno
# TODO 5: output "cesta_k_souboru" – vrací filename z local_file.pozdrav
