terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

variable "url" {
  type = string
}

variable "pocet_pozadavku" {
  type    = number
  default = 12
}

data "http" "zdravi" {
  url = "${var.url}/zdravi"

  retry {
    attempts     = 10
    min_delay_ms = 500
  }
}

data "http" "pozadavek" {
  count = var.pocet_pozadavku
  url   = var.url

  retry {
    attempts     = 5
    min_delay_ms = 300
  }

  depends_on = [data.http.zdravi]
}

output "zdravi" {
  value = data.http.zdravi.response_body
}

output "status_kody" {
  value = data.http.pozadavek[*].status_code
}

# whoami vrací v těle řádek "Hostname: <id kontejneru>"
output "ruzne_backendy" {
  value = length(distinct([for r in data.http.pozadavek : regex("Hostname: (\\S+)", r.response_body)[0]]))
}
