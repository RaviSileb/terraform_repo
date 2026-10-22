# Testy modulu. Spuštění z adresáře modulu: terraform init && terraform test

mock_provider "docker" {}

variables {
  nazev   = "test-web"
  port    = 9000
  titulek = "Test"
}

run "zakladni_pouziti" {
  command = plan

  assert {
    condition     = docker_container.web.name == "test-web" && docker_container.web.ports[0].external == 9000
    error_message = "Kontejner musí převzít nazev a port ze vstupů."
  }

  assert {
    condition     = length(docker_container.web.networks_advanced) == 0
    error_message = "Bez vstupu sit se kontejner nesmí připojovat k žádné síti."
  }
}

run "se_siti" {
  command = plan

  variables {
    sit = "moje-sit"
  }

  assert {
    condition     = anytrue([for n in docker_container.web.networks_advanced : n.name == "moje-sit"])
    error_message = "Se vstupem sit se kontejner musí připojit k dané síti."
  }
}

run "vystupy" {
  command = apply

  assert {
    condition     = output.url == "http://localhost:9000" && output.nazev_kontejneru == "test-web"
    error_message = "Výstupy url a nazev_kontejneru neodpovídají vstupům."
  }
}

run "spatny_nazev" {
  command = plan

  variables {
    nazev = "Spatny_Nazev"
  }

  expect_failures = [var.nazev]
}
