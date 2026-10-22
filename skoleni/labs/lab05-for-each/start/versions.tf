terraform {
  required_version = ">= 1.10"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.0"
    }
  }
}

provider "docker" {
  # null = použije se DOCKER_HOST nebo výchozí unix:///var/run/docker.sock
  host = var.docker_host
}
