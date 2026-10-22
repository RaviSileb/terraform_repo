output "plny_nazev" {
  value = local.plny_nazev
}

output "cesta_ke_konfiguraci" {
  value = local_file.konfigurace.filename
}

output "stitky" {
  value = local.stitky
}

output "heslo_db" {
  value     = var.heslo_db
  sensitive = true
}
