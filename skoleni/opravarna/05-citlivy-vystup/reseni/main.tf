terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "random_password" "db" {
  length = 20
}

output "heslo_db" {
  value     = random_password.db.result
  sensitive = true
}
