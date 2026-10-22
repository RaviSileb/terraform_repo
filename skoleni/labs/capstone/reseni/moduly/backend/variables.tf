variable "prostredi" {
  description = "Název prostředí, použije se v názvech kontejnerů."
  type        = string
}

variable "pocet" {
  description = "Počet identických replik backendu."
  type        = number
  default     = 2

  validation {
    condition     = var.pocet >= 1 && var.pocet <= 5
    error_message = "pocet musí být 1–5."
  }
}

variable "sit" {
  description = "Docker síť, ve které repliky poběží."
  type        = string
}

variable "image" {
  description = "Image backendu."
  type        = string
  default     = "traefik/whoami:v1.11"
}
