output "nazev" {
  description = "Název zdroje podle firemní konvence <projekt>-<d|t|p>-<komponenta>-<NN>."
  value       = local.nazev

  precondition {
    condition     = length(local.nazev) <= 30
    error_message = "Název ${local.nazev} je delší než 30 znaků."
  }
}

output "stitky" {
  description = "Povinné štítky."
  value       = local.stitky
}

output "je_produkce" {
  value = local.je_produkce
}
