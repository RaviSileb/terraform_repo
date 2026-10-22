locals {
  plny_nazev = "${var.nazev_aplikace}-${var.prostredi}"

  # Pozdější mapa v merge() přepisuje dřívější – uživatel nemůže přepsat povinné štítky.
  stitky = merge(var.stitky, {
    aplikace  = var.nazev_aplikace
    prostredi = var.prostredi
    spravuje  = "terraform"
  })
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

resource "local_sensitive_file" "tajemstvi" {
  filename        = "${path.module}/vystup/${var.prostredi}/.env"
  content         = "DB_PASSWORD=${var.heslo_db}\n"
  file_permission = "0600"
}
