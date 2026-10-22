output "url" {
  value = "http://localhost:${var.port}"
}

output "nazev" {
  value = docker_container.proxy.name
}
