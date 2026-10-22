output "url" {
  value = { for k, c in docker_container.sluzba : k => "http://localhost:${c.ports[0].external}" }
}

output "pocet_kontejneru" {
  value = length(docker_container.sluzba)
}
