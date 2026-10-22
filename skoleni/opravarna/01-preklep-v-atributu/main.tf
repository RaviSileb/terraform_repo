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

resource "random_pet" "jmeno" {}

resource "local_file" "pozdrav" {
  filename = "${path.module}/pozdrav.txt"
  content  = "Ahoj ${random_pet.jmeno.name}!"
}
