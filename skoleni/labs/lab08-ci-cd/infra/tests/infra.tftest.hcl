run "manifest" {
  variables {
    verze_aplikace = "2.3.4"
  }

  assert {
    condition     = jsondecode(local_file.manifest.content).verze == "2.3.4"
    error_message = "Manifest musí obsahovat verzi aplikace."
  }
}

run "spatna_verze" {
  command = plan

  variables {
    verze_aplikace = "v2"
  }

  expect_failures = [var.verze_aplikace]
}
