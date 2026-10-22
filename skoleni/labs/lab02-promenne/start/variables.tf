variable "nazev_aplikace" {
  description = "Krátký název aplikace (malá písmena, číslice, pomlčky)."
  type        = string

  # TODO 1: validace – regulární výraz ^[a-z][a-z0-9-]{2,20}$
  #         nápověda: can(regex(...))
}

variable "prostredi" {
  description = "Cílové prostředí."
  type        = string
  default     = "dev"

  # TODO 2: validace – povolené hodnoty dev, test, prod (funkce contains)
}

variable "pocet_replik" {
  description = "Počet instancí aplikace."
  type        = number
  default     = 1

  validation {
    condition     = var.pocet_replik >= 1 && var.pocet_replik <= 10
    error_message = "pocet_replik musí být v rozsahu 1–10."
  }

  # TODO 3: druhá validace – v prostředí "prod" musí být pocet_replik >= 2
}

# TODO 4: proměnná "porty" – seznam čísel, výchozí [8080]

# TODO 5: proměnná "stitky" – mapa řetězců, výchozí {}

# TODO 6: proměnná "heslo_db" – řetězec bez výchozí hodnoty, označený jako citlivý
