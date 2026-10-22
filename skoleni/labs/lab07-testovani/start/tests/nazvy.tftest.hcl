# Vaše testy modulu nazvy. Spuštění: terraform init && terraform test
# Kvalitu testů ověříte mutačním testováním: python3 ../mutace.py

variables {
  projekt    = "eshop"
  prostredi  = "dev"
  komponenta = "web"
}

run "nazev_dev" {
  command = plan

  assert {
    condition     = output.nazev == "eshop-d-web-01"
    error_message = "Očekáván název eshop-d-web-01, je ${output.nazev}."
  }
}

# TODO: přidejte další run bloky – viz README, část B.
