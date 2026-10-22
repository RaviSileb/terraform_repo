resource "docker_image" "nginx" {
  name         = "nginx:1.30-alpine"
  keep_locally = true
}

# Část A: jeden kontejner pro každou položku seznamu – pomocí count.
resource "docker_container" "sluzba" {
  count = length(var.sluzby_seznam)

  name  = "lab05-${var.sluzby_seznam[count.index]}"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 8050 + count.index
  }
}
