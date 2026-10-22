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

variable "pocet_souboru" {
  type = number
}

resource "local_file" "soubor" {
  count = var.pocet_souboru

  filename = "${path.module}/vystup/soubor-${count.index}.txt"
  content  = "Soubor ${count.index}"
}
