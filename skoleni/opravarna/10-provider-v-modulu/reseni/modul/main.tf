terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.0"
    }
  }
}

variable "prostredi" {
  type = string
}

resource "docker_network" "sit" {
  name = "opravarna-${var.prostredi}"
}
