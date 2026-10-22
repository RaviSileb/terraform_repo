resource "docker_image" "nginx" {
  name         = "nginx:${var.nginx_verze}"
  keep_locally = true
}

resource "docker_container" "web" {
  name  = "lab04-web"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 8040
  }
}
