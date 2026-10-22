# Rozhraní modulu (vstupy) je hotové ve variables.tf – „kontrakt“ modulu.
# Vaším úkolem je implementace.

# TODO 1: resource "docker_image" "nginx" – tag z var.nginx_verze, keep_locally = true

# TODO 2: resource "docker_container" "web"
#   - name, port a obsah index.html (šablona index.html.tftpl: titulek, barva, nazev) ze vstupů
#   - štítek (labels) modul = "webapp"
#   - připojení k síti var.sit, ale jen pokud není null:
#       dynamic "networks_advanced" {
#         for_each = var.sit == null ? [] : [var.sit]
#         content { name = networks_advanced.value }
#       }
