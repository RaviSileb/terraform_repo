# Modul bez providerů: jmenná konvence a povinné štítky firmy.
# Čistá logika = ideální kandidát na rychlé jednotkové testy.

locals {
  zkratky_prostredi = {
    dev  = "d"
    test = "t"
    prod = "p"
  }

  je_produkce = var.prostredi == "prod"

  nazev = lower(join("-", [
    var.projekt,
    local.zkratky_prostredi[var.prostredi],
    var.komponenta,
    format("%02d", var.instance),
  ]))

  stitky = {
    projekt    = var.projekt
    prostredi  = var.prostredi
    komponenta = var.komponenta
    kriticnost = local.je_produkce ? "vysoka" : "nizka"
    spravuje   = "terraform"
  }
}
