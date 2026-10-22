locals {
  nazev_serveru = "server"
  nazev_klienta = "klient"
}

resource "terraform_data" "server" {
  input = {
    nazev  = local.nazev_serveru
    klient = local.nazev_klienta
  }
}

resource "terraform_data" "klient" {
  input = {
    nazev  = local.nazev_klienta
    server = terraform_data.server.output.nazev
  }
}
