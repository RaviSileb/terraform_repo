# Krok 4: převzetí ručně vytvořených zdrojů pod správu Terraformu.
# Import bloky jsou idempotentní; po úspěšném importu je můžete smazat.
import {
  to = docker_network.legacy
  id = "lab04-legacy-sit"
}

# Vyčištěná verze konfigurace vygenerované příkazem
#   terraform plan -generate-config-out=generated.tf
resource "docker_network" "legacy" {
  name = "lab04-legacy-sit"

  labels {
    label = "tym"
    value = "platforma"
  }
}

# Krok 6: volume předáváme jinému týmu – Terraform ho přestane spravovat, ale nesmaže.
removed {
  from = docker_volume.data

  lifecycle {
    destroy = false
  }
}
