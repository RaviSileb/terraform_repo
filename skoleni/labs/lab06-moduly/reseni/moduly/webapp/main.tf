resource "docker_image" "nginx" {
  name         = "nginx:${var.nginx_verze}"
  keep_locally = true
}

resource "docker_container" "web" {
  name  = var.nazev
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
      nazev   = var.nazev
    })
  }

  dynamic "networks_advanced" {
    for_each = var.sit == null ? [] : [var.sit]

    content {
      name = networks_advanced.value
    }
  }

  labels {
    label = "modul"
    value = "webapp"
  }
}
