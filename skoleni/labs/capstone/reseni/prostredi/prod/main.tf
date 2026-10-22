locals {
  prostredi = "prod"
}

resource "docker_network" "sit" {
  name = "cap-${local.prostredi}"
}

module "backend" {
  source = "../../moduly/backend"

  prostredi = local.prostredi
  pocet     = var.pocet_backendu
  sit       = docker_network.sit.name
}

module "proxy" {
  source = "../../moduly/proxy"

  prostredi = local.prostredi
  port      = var.port
  sit       = docker_network.sit.name
  backendy  = module.backend.nazvy
}
