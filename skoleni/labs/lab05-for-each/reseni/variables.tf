variable "docker_host" {
  type    = string
  default = null
}

variable "sluzby" {
  description = "Služby k nasazení. Klíč = název služby."
  type = map(object({
    port    = number
    repliky = optional(number, 1)
    env     = optional(map(string), {})
    stitky  = optional(map(string), {})
  }))

  default = {
    web  = { port = 8050 }
    api  = { port = 8051, env = { LOG_LEVEL = "debug" } }
    docs = { port = 8052, stitky = { verejne = "ano" } }
  }

  validation {
    condition     = alltrue([for s in values(var.sluzby) : s.repliky >= 1 && s.repliky <= 5])
    error_message = "Počet replik každé služby musí být 1–5."
  }
}
