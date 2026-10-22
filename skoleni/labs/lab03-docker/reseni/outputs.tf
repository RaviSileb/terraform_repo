output "url" {
  value = "http://localhost:${var.port}"
}

output "id_kontejneru" {
  value = docker_container.web.id
}

output "image_id" {
  value = docker_image.nginx.image_id
}
