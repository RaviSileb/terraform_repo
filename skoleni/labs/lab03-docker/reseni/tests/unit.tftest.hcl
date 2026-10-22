# Jednotkové testy s mock providerem – nepotřebují běžící Docker.
# Spuštění: terraform init && terraform test

mock_provider "docker" {}

variables {
  port = 8081
}

run "image_je_pinovany" {
  command = plan

  assert {
    condition     = startswith(docker_image.nginx.name, "nginx:") && !endswith(docker_image.nginx.name, ":latest")
    error_message = "Image musí být nginx s konkrétním tagem (ne latest)."
  }

  assert {
    condition     = docker_image.nginx.keep_locally
    error_message = "Nastavte keep_locally = true, ať destroy nemaže image z lokální cache."
  }
}

run "kontejner_a_porty" {
  command = plan

  assert {
    condition     = docker_container.web.name == "lab03-web"
    error_message = "Kontejner se musí jmenovat lab03-web."
  }

  assert {
    condition     = docker_container.web.ports[0].internal == 80 && docker_container.web.ports[0].external == 8081
    error_message = "Port 80 v kontejneru musí být mapován na var.port na hostiteli."
  }

  assert {
    condition     = anytrue([for u in docker_container.web.upload : u.file == "/usr/share/nginx/html/index.html" && strcontains(u.content, "<h1>Ahoj z Terraformu!</h1>")])
    error_message = "Do kontejneru se má nahrát index.html vygenerovaný ze šablony s titulkem v <h1>."
  }
}

run "vystup_url" {
  command = apply

  assert {
    condition     = output.url == "http://localhost:8081"
    error_message = "Výstup url musí mít tvar http://localhost:<port>."
  }
}

run "privilegovany_port_odmitnut" {
  command = plan

  variables {
    port = 80
  }

  expect_failures = [var.port]
}

run "latest_odmitnut" {
  command = plan

  variables {
    nginx_verze = "latest"
  }

  expect_failures = [var.nginx_verze]
}
