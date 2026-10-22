output "url" {
  description = "Adresa webu na hostiteli."
  value       = "http://localhost:${var.port}"
}

output "nazev_kontejneru" {
  description = "Název vytvořeného kontejneru."
  value       = docker_container.web.name
}

output "id_kontejneru" {
  description = "ID kontejneru v Dockeru."
  value       = docker_container.web.id
}
