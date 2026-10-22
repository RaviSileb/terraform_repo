# Spuštění: terraform init && terraform test

run "jmeno_ma_dve_slova" {
  assert {
    condition     = length(split("-", random_pet.jmeno.id)) == 2
    error_message = "random_pet.jmeno musí mít dvě slova oddělená pomlčkou (length = 2, separator = \"-\")."
  }
}

run "soubor_obsahuje_pozdrav" {
  assert {
    condition     = local_file.pozdrav.content == "Ahoj, jsem ${random_pet.jmeno.id}!\n"
    error_message = "Obsah souboru musí být přesně \"Ahoj, jsem <jméno>!\" a končit novým řádkem."
  }

  assert {
    condition     = endswith(local_file.pozdrav.filename, "vystup/pozdrav.txt")
    error_message = "Soubor se musí jmenovat vystup/pozdrav.txt."
  }
}

run "vystupy" {
  assert {
    condition     = output.jmeno_mazlicka == random_pet.jmeno.id
    error_message = "Výstup jmeno_mazlicka musí vracet random_pet.jmeno.id."
  }

  assert {
    condition     = output.cesta_k_souboru == local_file.pozdrav.filename
    error_message = "Výstup cesta_k_souboru musí vracet local_file.pozdrav.filename."
  }
}
