terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.0"
    }
  }
}

provider "docker" {
  # host = "unix:///var/run/docker.sock"   # výchozí hodnota, případně DOCKER_HOST
}

module "site" {
  source   = "./modul"
  for_each = toset(["dev", "prod"])

  prostredi = each.key
}
