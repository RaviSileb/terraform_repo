terraform {
  required_version = ">= 1.10"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.0"
    }
  }

  # V produkci: vzdálený backend, každé prostředí vlastní stav.
  # backend "s3" { ... }
}

provider "docker" {
  host = var.docker_host
}
