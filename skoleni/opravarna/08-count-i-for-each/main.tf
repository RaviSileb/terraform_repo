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

variable "zapnuto" {
  type    = bool
  default = true
}

resource "local_file" "konfigurace" {
  count    = var.zapnuto ? 1 : 0
  for_each = toset(["dev", "prod"])

  filename = "${path.module}/vystup/${each.key}.conf"
  content  = "prostredi = ${each.key}"
}
