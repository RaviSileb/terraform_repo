output "url" {
  value = [for c in docker_container.sluzba : "http://localhost:${c.ports[0].external}"]
}

output "pocet_kontejneru" {
  value = length(docker_container.sluzba)
}
