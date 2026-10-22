# Spuštění: terraform init && terraform test

variables {
  nazev_aplikace = "eshop"
  heslo_db       = "testovaci-heslo"
}

run "vychozi_dev" {
  assert {
    condition     = output.plny_nazev == "eshop-dev"
    error_message = "plny_nazev má mít tvar <nazev_aplikace>-<prostredi>, tj. eshop-dev."
  }

  assert {
    condition     = strcontains(local_file.konfigurace.content, "replicas = 1")
    error_message = "Konfigurace musí obsahovat řádek 'replicas = 1'."
  }

  assert {
    condition     = endswith(local_file.konfigurace.filename, "vystup/dev/app.conf")
    error_message = "Konfigurace se má zapsat do vystup/<prostredi>/app.conf."
  }
}

run "vice_portu_v_sablone" {
  variables {
    porty = [80, 443]
  }

  assert {
    condition     = strcontains(local_file.konfigurace.content, "listen   = 0.0.0.0:80\n") && strcontains(local_file.konfigurace.content, "listen   = 0.0.0.0:443\n")
    error_message = "Šablona musí vygenerovat jeden řádek 'listen' pro každý port."
  }
}

run "povinne_stitky_nelze_prepsat" {
  variables {
    stitky = {
      spravuje = "rucne"
      tym      = "platforma"
    }
  }

  assert {
    condition     = output.stitky["spravuje"] == "terraform" && output.stitky["tym"] == "platforma"
    error_message = "Štítek 'spravuje' musí být vždy 'terraform', uživatelské štítky se mají zachovat."
  }
}

run "tajemstvi_je_citlive" {
  assert {
    condition     = local_sensitive_file.tajemstvi.file_permission == "0600"
    error_message = "Soubor s heslem musí mít práva 0600."
  }
}

run "neplatne_prostredi" {
  command = plan

  variables {
    prostredi = "staging"
  }

  expect_failures = [var.prostredi]
}

run "neplatny_nazev" {
  command = plan

  variables {
    nazev_aplikace = "Moje_Aplikace"
  }

  expect_failures = [var.nazev_aplikace]
}

run "prod_vyzaduje_dve_repliky" {
  command = plan

  variables {
    prostredi    = "prod"
    pocet_replik = 1
  }

  expect_failures = [var.pocet_replik]
}
