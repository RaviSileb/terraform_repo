locals {
  # TODO 7: plny_nazev = "<nazev_aplikace>-<prostredi>"

  # TODO 8: stitky = sloučení var.stitky s povinnými štítky
  #         aplikace, prostredi a spravuje = "terraform".
  #         Povinné štítky nesmí jít přepsat – záleží na pořadí argumentů merge().
}

resource "local_file" "konfigurace" {
  filename = "${path.module}/vystup/${var.prostredi}/app.conf"
  content = templatefile("${path.module}/sablony/app.conf.tftpl", {
    nazev   = local.plny_nazev
    repliky = var.pocet_replik
    porty   = var.porty
    stitky  = local.stitky
  })
}

# TODO 9: resource "local_sensitive_file" "tajemstvi"
#         filename        = "${path.module}/vystup/${var.prostredi}/.env"
#         content         = "DB_PASSWORD=<heslo>\n"
#         file_permission = "0600"
