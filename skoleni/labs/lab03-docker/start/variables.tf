variable "docker_host" {
  description = "Adresa Docker démona, např. unix:///Users/<vy>/.docker/run/docker.sock. null = výchozí."
  type        = string
  default     = null
}

variable "nginx_verze" {
  description = "Tag image nginx. Nikdy nepoužívejte 'latest' – nasazení by nebylo reprodukovatelné."
  type        = string
  default     = "1.30-alpine"

  validation {
    condition     = var.nginx_verze != "latest"
    error_message = "Tag 'latest' není povolen, uveďte konkrétní verzi."
  }
}

variable "port" {
  description = "Port na hostiteli, na kterém bude web dostupný."
  type        = number
  default     = 8080

  validation {
    condition     = var.port >= 1024 && var.port <= 65535
    error_message = "Použijte neprivilegovaný port 1024–65535."
  }
}

variable "titulek" {
  type    = string
  default = "Ahoj z Terraformu!"
}

variable "barva" {
  description = "Barva pozadí stránky (CSS)."
  type        = string
  default     = "#7B42BC"
}
