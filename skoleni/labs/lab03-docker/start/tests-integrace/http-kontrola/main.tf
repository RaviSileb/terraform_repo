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

data "http" "web" {
  url = var.url

  retry {
    attempts     = 10
    min_delay_ms = 500
  }
}

output "status_code" {
  value = data.http.web.status_code
}

output "telo" {
  value = data.http.web.response_body
}
