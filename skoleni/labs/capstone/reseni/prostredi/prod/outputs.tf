output "url" {
  value = module.proxy.url
}

output "pocet_backendu" {
  value = length(module.backend.nazvy)
}
