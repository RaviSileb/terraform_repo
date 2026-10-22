# TODO 1: resource "docker_image" "nginx"
#         name         = "nginx:<var.nginx_verze>"
#         keep_locally = true   (destroy nesmaže image z lokální cache)

resource "docker_container" "web" {
  name = "lab03-web"

  # TODO 2: image = ID image ze zdroje docker_image.nginx (atribut image_id)
  #         Tato reference vytvoří implicitní závislost: nejdřív image, pak kontejner.

  # TODO 3: blok ports – interní port 80, externí var.port

  # TODO 4: blok upload – soubor /usr/share/nginx/html/index.html
  #         s obsahem templatefile("${path.module}/index.html.tftpl", { titulek = ..., barva = ... })
}
