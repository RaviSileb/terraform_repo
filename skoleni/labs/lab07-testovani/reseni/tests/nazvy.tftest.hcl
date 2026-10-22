# Referenční testy modulu nazvy. Spuštění: terraform init && terraform test

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

run "nazev_prod_a_instance" {
  command = plan

  variables {
    prostredi = "prod"
    instance  = 7
  }

  assert {
    condition     = output.nazev == "eshop-p-web-07"
    error_message = "Očekáván název eshop-p-web-07, je ${output.nazev}."
  }
}

run "nazev_test_dvouciferna_instance" {
  command = plan

  variables {
    prostredi = "test"
    instance  = 42
  }

  assert {
    condition     = output.nazev == "eshop-t-web-42"
    error_message = "Očekáván název eshop-t-web-42, je ${output.nazev}."
  }
}

run "komponenta_malymi_pismeny" {
  command = plan

  variables {
    komponenta = "API"
  }

  assert {
    condition     = output.nazev == "eshop-d-api-01"
    error_message = "Název musí být malými písmeny."
  }
}

run "stitky_prod" {
  command = plan

  variables {
    prostredi = "prod"
  }

  assert {
    condition     = output.stitky.kriticnost == "vysoka" && output.je_produkce
    error_message = "Produkce má mít kriticnost vysoka."
  }

  assert {
    condition     = output.stitky.spravuje == "terraform"
    error_message = "Štítek spravuje musí být terraform."
  }
}

run "stitky_dev" {
  command = plan

  assert {
    condition     = output.stitky.kriticnost == "nizka" && !output.je_produkce
    error_message = "Neprodukční prostředí má mít kriticnost nizka."
  }

  assert {
    condition     = length(output.stitky) == 5
    error_message = "Očekáváno přesně 5 povinných štítků."
  }
}

run "neplatne_prostredi" {
  command = plan

  variables {
    prostredi = "staging"
  }

  expect_failures = [var.prostredi]
}

run "neplatny_projekt" {
  command = plan

  variables {
    projekt = "Es-Shop"
  }

  expect_failures = [var.projekt]
}

run "prilis_dlouhy_projekt" {
  command = plan

  variables {
    projekt = "abcdefghijk"
  }

  expect_failures = [var.projekt]
}

run "instance_mimo_rozsah" {
  command = plan

  variables {
    instance = 100
  }

  expect_failures = [var.instance]
}

run "instance_neni_cele_cislo" {
  command = plan

  variables {
    instance = 1.5
  }

  expect_failures = [var.instance]
}

run "prilis_dlouhy_nazev" {
  command = plan

  variables {
    komponenta = "velmi-dlouha-komponenta"
  }

  expect_failures = [output.nazev]
}
