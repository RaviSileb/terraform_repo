variable "docker_host" {
  type    = string
  default = null
}

variable "prostredi" {
  description = "Prostředí, pro která se nasadí instance modulu webapp."
  type = map(object({
    port    = number
    titulek = string
    barva   = optional(string, "#7B42BC")
  }))

  default = {
    dev  = { port = 8061, titulek = "Vývoj", barva = "#2E7D32" }
    prod = { port = 8062, titulek = "Produkce", barva = "#C62828" }
  }
}
