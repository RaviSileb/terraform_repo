output "url" {
  value = { for k, m in module.web : k => m.url }
}

output "kontejnery" {
  value = [for m in module.web : m.nazev_kontejneru]
}
