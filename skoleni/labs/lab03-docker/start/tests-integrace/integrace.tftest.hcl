# Integrační test – opravdu nasadí kontejner a zavolá ho přes HTTP.
# Vyžaduje běžící Docker. Spuštění:
#   terraform test -test-directory=tests-integrace

variables {
  port    = 18080
  titulek = "Integrační test"
}

run "nasazeni" {}

run "web_odpovida" {
  module {
    source = "./tests-integrace/http-kontrola"
  }

  variables {
    url = run.nasazeni.url
  }

  assert {
    condition     = output.status_code == 200
    error_message = "Web nevrací HTTP 200."
  }

  assert {
    condition     = strcontains(output.telo, "<h1>Integrační test</h1>")
    error_message = "Stránka neobsahuje titulek předaný proměnnou."
  }
}
