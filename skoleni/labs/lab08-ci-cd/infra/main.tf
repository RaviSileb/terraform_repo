# Zástupná infrastruktura pro pipeline: v reálném projektu by tu byly
# zdroje v cloudu a stav ve vzdáleném backendu (viz README).

resource "random_id" "nasazeni" {
  byte_length = 4

  keepers = {
    verze = var.verze_aplikace
  }
}

resource "local_file" "manifest" {
  filename = "${path.module}/vystup/manifest.json"
  content = jsonencode({
    verze     = var.verze_aplikace
    nasazeni  = random_id.nasazeni.hex
    spravuje  = "terraform"
    repozitar = "skoleni/labs/lab08-ci-cd"
  })
}
