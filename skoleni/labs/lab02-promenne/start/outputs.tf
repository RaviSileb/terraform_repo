output "plny_nazev" {
  value = local.plny_nazev
}

output "cesta_ke_konfiguraci" {
  value = local_file.konfigurace.filename
}

# TODO 10: output "stitky" – vrací local.stitky

# TODO 11: output "heslo_db" – vrací heslo; co se stane, když zapomenete na sensitive = true?
