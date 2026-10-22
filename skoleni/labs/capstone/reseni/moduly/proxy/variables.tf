variable "prostredi" {
  type = string
}

variable "port" {
  description = "Port proxy na hostiteli."
  type        = number

  validation {
    condition     = var.port >= 1024 && var.port <= 65535
    error_message = "port musí být 1024–65535."
  }
}

variable "sit" {
  type = string
}

variable "backendy" {
  description = "DNS jména backendů, mezi které proxy rozkládá zátěž."
  type        = list(string)

  validation {
    condition     = length(var.backendy) > 0
    error_message = "Proxy potřebuje alespoň jeden backend."
  }
}

variable "nginx_verze" {
  type    = string
  default = "1.30-alpine"
}
