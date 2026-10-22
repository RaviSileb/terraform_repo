mock_provider "docker" {}

variables {
  prostredi = "test"
  sit       = "test-sit"
}

run "vychozi_dve_repliky" {
  command = plan

  assert {
    condition     = length(docker_container.backend) == 2
    error_message = "Výchozí počet replik je 2."
  }

  assert {
    condition     = docker_container.backend[1].name == "cap-test-backend-1"
    error_message = "Repliky se jmenují cap-<prostredi>-backend-<index>."
  }
}

run "vystup_nazvy" {
  command = apply

  variables {
    pocet = 3
  }

  assert {
    condition     = output.nazvy == ["cap-test-backend-0", "cap-test-backend-1", "cap-test-backend-2"]
    error_message = "Výstup nazvy musí obsahovat názvy všech replik v pořadí."
  }
}

run "prilis_mnoho" {
  command = plan

  variables {
    pocet = 6
  }

  expect_failures = [var.pocet]
}
