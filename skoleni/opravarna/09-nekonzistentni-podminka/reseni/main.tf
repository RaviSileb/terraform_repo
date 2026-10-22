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

variable "prostredi" {
  type    = string
  default = "dev"
}

locals {
  porty = var.prostredi == "prod" ? [80, 443] : [8080]
}

resource "local_file" "porty" {
  filename = "${path.module}/vystup/porty.txt"
  content  = join(",", local.porty)
}
