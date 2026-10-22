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

variable "tym" {
  type    = list(string)
  default = ["alena", "boris", "cyril"]
}

resource "local_file" "uvitani" {
  for_each = toset(var.tym)

  filename = "${path.module}/vystup/${each.key}.txt"
  content  = "Vítej, ${each.value}!"
}
