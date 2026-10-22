variable "nazev" {
  description = "Název kontejneru."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,40}$", var.nazev))
    error_message = "nazev: malá písmena, číslice a pomlčky, 2–41 znaků."
  }
}

variable "port" {
  description = "Port na hostiteli."
  type        = number

  validation {
    condition     = var.port >= 1024 && var.port <= 65535
    error_message = "port musí být 1024–65535."
  }
}

variable "titulek" {
  description = "Text nadpisu stránky."
  type        = string
}

variable "barva" {
  description = "Barva pozadí stránky (CSS)."
  type        = string
  default     = "#7B42BC"
}

variable "sit" {
  description = "Název Docker sítě, ke které se kontejner připojí. null = bez sítě."
  type        = string
  default     = null
}

variable "nginx_verze" {
  description = "Tag image nginx."
  type        = string
  default     = "1.30-alpine"
}
