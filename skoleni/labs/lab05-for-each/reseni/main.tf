moved {
  from = docker_container.sluzba[0]
  to   = docker_container.sluzba["web"]
}

moved {
  from = docker_container.sluzba[1]
  to   = docker_container.sluzba["api"]
}

moved {
  from = docker_container.sluzba[2]
  to   = docker_container.sluzba["docs"]
}

locals {
  # Zploštění map(služba) -> map(instance). První replika si nechává název služby,
  # další dostávají příponu -1, -2, … (stabilní klíče = žádné zbytečné náhrady).
  instance = merge([
    for nazev, s in var.sluzby : {
      for i in range(s.repliky) : (i == 0 ? nazev : "${nazev}-${i}") => {
        sluzba = nazev
        port   = s.port + i
        env    = s.env
        stitky = s.stitky
      }
    }
  ]...)

  vsechny_porty = [for i in values(local.instance) : i.port]
}

resource "docker_image" "nginx" {
  name         = "nginx:1.30-alpine"
  keep_locally = true
}

resource "docker_network" "lab05" {
  name = "lab05-sit"
}

resource "docker_container" "sluzba" {
  for_each = local.instance

  name  = "lab05-${each.key}"
  image = docker_image.nginx.image_id
  env   = [for k, v in each.value.env : "${k}=${v}"]

  ports {
    internal = 80
    external = each.value.port
  }

  networks_advanced {
    name    = docker_network.lab05.name
    aliases = [each.value.sluzba]
  }

  dynamic "labels" {
    for_each = merge(each.value.stitky, { sluzba = each.value.sluzba })

    content {
      label = labels.key
      value = labels.value
    }
  }

  lifecycle {
    precondition {
      condition     = length(distinct(local.vsechny_porty)) == length(local.vsechny_porty)
      error_message = "Kolize portů: repliky jedné služby obsazují porty port, port+1, … a překrývají se s jinou službou. Porty: ${join(", ", local.vsechny_porty)}"
    }
  }
}
