resource "terraform_data" "server" {
  input = {
    nazev  = "server"
    klient = terraform_data.klient.output.nazev
  }
}

resource "terraform_data" "klient" {
  input = {
    nazev  = "klient"
    server = terraform_data.server.output.nazev
  }
}
