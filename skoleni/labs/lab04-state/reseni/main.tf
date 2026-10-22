resource "docker_image" "nginx" {
  name         = "nginx:${var.nginx_verze}"
  keep_locally = true
}

# Krok 5: přejmenování web -> frontend bez zničení kontejneru
moved {
  from = docker_container.web
  to   = docker_container.frontend
}

resource "docker_container" "frontend" {
  name  = "lab04-web"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 8040
  }

  # Krok 4c: připojení k importované síti
  networks_advanced {
    name = docker_network.legacy.name
  }
}
