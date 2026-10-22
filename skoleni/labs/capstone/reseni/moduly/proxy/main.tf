resource "docker_image" "nginx" {
  name         = "nginx:${var.nginx_verze}"
  keep_locally = true
}

resource "docker_container" "proxy" {
  name  = "cap-${var.prostredi}-proxy"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.port
  }

  networks_advanced {
    name = var.sit
  }

  upload {
    file    = "/etc/nginx/conf.d/default.conf"
    content = templatefile("${path.module}/nginx.conf.tftpl", { backendy = var.backendy })
  }
}
