resource "docker_network" "lab06" {
  name = "lab06-sit"
}

module "web" {
  source   = "./moduly/webapp"
  for_each = var.prostredi

  nazev   = "lab06-${each.key}"
  port    = each.value.port
  titulek = each.value.titulek
  barva   = each.value.barva
  sit     = docker_network.lab06.name
}
