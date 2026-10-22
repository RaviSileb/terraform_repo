# Testy kořenového modulu. Spuštění: terraform init && terraform test

mock_provider "docker" {}

run "dve_prostredi" {
  command = plan

  assert {
    condition     = toset(keys(module.web)) == toset(["dev", "prod"])
    error_message = "Modul webapp se má volat pro každé prostředí (for_each = var.prostredi)."
  }
}

run "vystupy_z_modulu" {
  command = apply

  assert {
    condition     = output.url["prod"] == "http://localhost:8062"
    error_message = "Výstup url má být mapa prostředí -> URL z výstupu modulu."
  }

  assert {
    condition     = contains(output.kontejnery, "lab06-dev")
    error_message = "Kontejner pro dev se má jmenovat lab06-dev."
  }
}

run "treti_prostredi" {
  command = plan

  variables {
    prostredi = {
      dev  = { port = 8061, titulek = "Vývoj" }
      test = { port = 8063, titulek = "Test" }
      prod = { port = 8062, titulek = "Produkce" }
    }
  }

  assert {
    condition     = length(module.web) == 3
    error_message = "Přidání prostředí do mapy má vytvořit další instanci modulu."
  }
}
