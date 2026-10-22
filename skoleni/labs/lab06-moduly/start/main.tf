resource "docker_network" "lab06" {
  name = "lab06-sit"
}

# TODO 4: module "web" se zdrojem ./moduly/webapp, volaný pro každé prostředí z var.prostredi
#         nazev = "lab06-<klíč prostředí>", sit = název sítě výše
