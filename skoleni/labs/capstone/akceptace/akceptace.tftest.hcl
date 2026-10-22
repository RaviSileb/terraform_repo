# Akceptační test závěrečného projektu.
# Zkopírujte složku akceptace/ do svého prostředí (např. prostredi/dev/akceptace/) a spusťte:
#   terraform init -test-directory=akceptace
#   terraform test -test-directory=akceptace

run "nasazeni" {}

run "proxy_rozklada_zatez" {
  module {
    source = "./akceptace/rozlozeni"
  }

  variables {
    url = run.nasazeni.url
  }

  assert {
    condition     = trimspace(output.zdravi) == "ok"
    error_message = "Endpoint /zdravi musí vracet ok."
  }

  assert {
    condition     = alltrue([for s in output.status_kody : s == 200])
    error_message = "Všechny požadavky přes proxy musí vrátit HTTP 200."
  }

  assert {
    condition     = output.ruzne_backendy == run.nasazeni.pocet_backendu
    error_message = "Odpovědi mají přijít ze všech ${run.nasazeni.pocet_backendu} backendů, přišly z ${output.ruzne_backendy}."
  }
}
