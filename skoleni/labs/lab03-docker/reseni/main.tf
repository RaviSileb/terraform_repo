resource "docker_image" "nginx" {
  name         = "nginx:${var.nginx_verze}"
  keep_locally = true
}

resource "docker_container" "web" {
  name  = "lab03-web"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.port
  }

  upload {
    file = "/usr/share/nginx/html/index.html"
    content = templatefile("${path.module}/index.html.tftpl", {
      titulek = var.titulek
      barva   = var.barva
    })
  }
}
