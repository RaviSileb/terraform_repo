terraform {
  required_version = ">= 1.10"

  # Modul deklaruje, které providery potřebuje, ale NEkonfiguruje je (žádný blok provider).
  # Konfiguraci dodá kořenový modul.
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 4.0"
    }
  }
}
