resource "docker_image" "backend" {
  name         = var.image
  keep_locally = true
}

# Repliky jsou identické a zaměnitelné – tady je count na místě.
resource "docker_container" "backend" {
  count = var.pocet

  name  = "cap-${var.prostredi}-backend-${count.index}"
  image = docker_image.backend.image_id

  networks_advanced {
    name = var.sit
  }

  labels {
    label = "prostredi"
    value = var.prostredi
  }
}
