mock_provider "docker" {}

variables {
  prostredi = "test"
  port      = 9100
  sit       = "test-sit"
  backendy  = ["b0", "b1"]
}

run "konfigurace_upstreamu" {
  command = plan

  assert {
    condition = anytrue([
      for u in docker_container.proxy.upload :
      strcontains(u.content, "server b0:80;") && strcontains(u.content, "server b1:80;")
    ])
    error_message = "nginx.conf musí obsahovat řádek server <backend>:80; pro každý backend."
  }
}

run "bez_backendu" {
  command = plan

  variables {
    backendy = []
  }

  expect_failures = [var.backendy]
}
