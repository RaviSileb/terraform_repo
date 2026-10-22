# Spuštění: terraform init && terraform test   (mock – nepotřebuje Docker)

mock_provider "docker" {}

run "vychozi_tri_sluzby" {
  command = plan

  assert {
    condition     = toset(keys(docker_container.sluzba)) == toset(["web", "api", "docs"])
    error_message = "Použijte for_each s klíči web, api, docs (ne count)."
  }

  assert {
    condition     = docker_container.sluzba["api"].name == "lab05-api" && docker_container.sluzba["api"].ports[0].external == 8051
    error_message = "Kontejner služby api se má jmenovat lab05-api a poslouchat na portu 8051."
  }

  assert {
    condition     = contains(docker_container.sluzba["api"].env, "LOG_LEVEL=debug")
    error_message = "Proměnné prostředí se mají převést z mapy na seznam \"KLIC=hodnota\"."
  }
}

run "dynamicke_stitky" {
  command = plan

  assert {
    condition     = anytrue([for l in docker_container.sluzba["docs"].labels : l.label == "sluzba" && l.value == "docs"])
    error_message = "Každý kontejner musí mít štítek sluzba=<název služby> (blok dynamic \"labels\")."
  }

  assert {
    condition     = anytrue([for l in docker_container.sluzba["docs"].labels : l.label == "verejne" && l.value == "ano"])
    error_message = "Uživatelské štítky služby se musí propsat do labels."
  }
}

run "repliky" {
  command = plan

  variables {
    sluzby = {
      web = { port = 8050, repliky = 3 }
      api = { port = 8060 }
    }
  }

  assert {
    condition     = toset(keys(docker_container.sluzba)) == toset(["web", "web-1", "web-2", "api"])
    error_message = "Repliky mají klíče <sluzba>, <sluzba>-1, <sluzba>-2, …"
  }

  assert {
    condition     = docker_container.sluzba["web-2"].ports[0].external == 8052
    error_message = "Replika i má port = port služby + i."
  }
}

run "kolize_portu" {
  command = plan

  variables {
    sluzby = {
      web = { port = 8050, repliky = 2 }
      api = { port = 8051 }
    }
  }

  expect_failures = [docker_container.sluzba]
}

run "prilis_mnoho_replik" {
  command = plan

  variables {
    sluzby = {
      web = { port = 8050, repliky = 9 }
    }
  }

  expect_failures = [var.sluzby]
}
