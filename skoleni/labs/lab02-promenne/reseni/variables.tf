variable "nazev_aplikace" {
  description = "Krátký název aplikace (malá písmena, číslice, pomlčky)."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,20}$", var.nazev_aplikace))
    error_message = "nazev_aplikace: 3–21 znaků, začíná písmenem, povolena jsou malá písmena, číslice a pomlčka."
  }
}

variable "prostredi" {
  description = "Cílové prostředí."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.prostredi)
    error_message = "prostredi musí být jedno z: dev, test, prod."
  }
}

variable "pocet_replik" {
  description = "Počet instancí aplikace."
  type        = number
  default     = 1

  validation {
    condition     = var.pocet_replik >= 1 && var.pocet_replik <= 10
    error_message = "pocet_replik musí být v rozsahu 1–10."
  }

  # Validace odkazující na jinou proměnnou funguje od Terraformu 1.9.
  validation {
    condition     = var.prostredi != "prod" || var.pocet_replik >= 2
    error_message = "V prostředí prod musí běžet alespoň 2 repliky."
  }
}

variable "porty" {
  description = "Porty, na kterých aplikace naslouchá."
  type        = list(number)
  default     = [8080]
}

variable "stitky" {
  description = "Dodatečné štítky (tagy)."
  type        = map(string)
  default     = {}
}

variable "heslo_db" {
  description = "Heslo k databázi. Nikdy ho neukládejte do *.tfvars v gitu."
  type        = string
  sensitive   = true
}
