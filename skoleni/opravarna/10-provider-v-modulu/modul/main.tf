terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

variable "prostredi" {
  type = string
}

resource "docker_network" "sit" {
  name = "opravarna-${var.prostredi}"
}
