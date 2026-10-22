variable "projekt" {
  description = "Zkratka projektu, 2–10 malých písmen."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2,10}$", var.projekt))
    error_message = "projekt: 2–10 malých písmen bez diakritiky."
  }
}

variable "prostredi" {
  description = "dev, test nebo prod."
  type        = string

  validation {
    condition     = contains(["dev", "test", "prod"], var.prostredi)
    error_message = "prostredi musí být dev, test nebo prod."
  }
}

variable "komponenta" {
  description = "Název komponenty, např. web, api, db."
  type        = string
}

variable "instance" {
  description = "Pořadové číslo instance (1–99)."
  type        = number
  default     = 1

  validation {
    condition     = var.instance >= 1 && var.instance <= 99 && floor(var.instance) == var.instance
    error_message = "instance musí být celé číslo 1–99."
  }
}
