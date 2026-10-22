# Modul 08 – Testování a kvalita kódu

| Délka | Podcast | Video | Lab |
|---|---|---|---|
| 90 min | 🎧 [Ep. 08 – Testování](../../podcast/ep08-testovani.md) | 🎬 [Lekce 08 – Testovací pyramida](../../video/README.md#lekce-08) | 🧪 [Lab 07 – Testování](../../labs/lab07-testovani/README.md) |

## Cíle
1. **Zařadit** nástroje kvality do vrstev testovací pyramidy a **vysvětlit**, co která vrstva nezachytí.
2. **Napsat** testy v `terraform test`: `run`, `assert`, `expect_failures`, `variables`, `mock_provider`, `override_*`.
3. **Použít** `check` bloky pro průběžné ověřování.
4. **Vyhodnotit** kvalitu testů (mutační testování).

## Rozcvička
1. Co je rozhraní modulu?
2. Proč pinovat verzi modulu tagem?
3. Kdo konfiguruje providery – modul, nebo kořen?

---

## 1. Pyramida
![Testovací pyramida](../../obrazky/testovaci-pyramida.svg)

| Vrstva | Nástroj | Co zachytí | Co **ne** |
|---|---|---|---|
| formát, syntaxe | `terraform fmt -check`, `terraform validate` | překlepy, typy, reference | logické chyby, chování API |
| lint | [TFLint](https://github.com/terraform-linters/tflint) (+ pluginy pro AWS/Azure/GCP) | neplatné typy instancí, nepoužité proměnné, konvence | bezpečnost, chování |
| bezpečnost, politiky | [Trivy](https://trivy.dev) (dříve tfsec), [Checkov](https://www.checkov.io), OPA/Conftest, Sentinel | veřejné buckety, nešifrované disky, příliš široká IAM práva | funkčnost |
| jednotkové testy | `terraform test` s `command = plan` nebo `mock_provider` | logika modulu: názvy, počty, podmínky, validace | skutečné chování providera/API |
| integrační testy | `terraform test` s `command = apply` (reálné zdroje), Terratest (Go) | že to opravdu funguje | stojí čas a peníze |
| průběžně | `check` bloky, plánovaná detekce driftu | problémy běžícího systému | – |

## 2. `terraform test` (od 1.6)
Testy jsou soubory `*.tftest.hcl` v adresáři `tests/`. Každý `run` blok provede `plan` nebo `apply` a ověří podmínky. Po testu Terraform vše, co vytvořil, zase zničí.

```hcl
# tests/nazvy.tftest.hcl
variables {                       # společné pro všechny run bloky
  projekt   = "eshop"
  prostredi = "dev"
}

run "nazev_dev" {
  command = plan                  # výchozí je apply
  assert {
    condition     = output.nazev == "eshop-d-web-01"
    error_message = "Očekáván eshop-d-web-01, je ${output.nazev}."
  }
}

run "neplatne_prostredi" {
  command = plan
  variables {
    prostredi = "staging"
  }
  expect_failures = [var.prostredi]   # test projde, jen když validace selže
}
```

### Mocky a přepisy (od 1.7)
```hcl
mock_provider "docker" {}            # žádné volání API, computed hodnoty se vygenerují

run "s_konkretnim_id" {
  override_resource {
    target = docker_container.web
    values = { id = "abc123" }
  }
  assert {
    condition     = output.id_kontejneru == "abc123"
    error_message = "Výstup musí vracet ID kontejneru."
  }
}
```
Další možnosti: `module { source = "./tests/helper" }` (pomocný modul, např. HTTP kontrola v labu 03), reference na výstupy předchozích běhů `run.nasazeni.url`, `-filter`, `-test-directory`, `-verbose`.

## 3. `check` bloky (od 1.5)
```hcl
check "web_odpovida" {
  data "http" "web" {
    url = "http://localhost:${var.port}"
  }
  assert {
    condition     = data.http.web.status_code == 200
    error_message = "Web nevrací 200."
  }
}
```
Vyhodnocují se při každém `plan`/`apply`, **nezastaví** nasazení, jen vypíšou varování. Vhodné pro smoke testy a monitoring předpokladů.

## 4. Jak poznat dobré testy
Pokrytí řádků u Terraformu nedává smysl. Užitečné otázky:
- Testuji **chování** (výstupy, počty, názvy), nebo jen opakuji konfiguraci?
- Mám **negativní testy** (neplatné vstupy musí selhat)?
- Testuji **hraniční hodnoty** (0, 1, maximum, maximum + 1)?
- **Mutační testování:** záměrně rozbiju modul – selžou testy? V labu 07 to automatizuje skript `mutace.py`.

---

## Shrnutí
1. Levné kontroly (fmt, validate, lint, sken) při každém commitu, drahé (apply) cíleně.
2. `terraform test`: `run` + `assert`, `expect_failures` pro negativní testy.
3. `mock_provider` a `override_*` = rychlé testy bez cloudu.
4. `check` bloky hlídají běžící systém a jen varují.
5. Kvalitu testů měřte tím, kolik chyb zachytí (mutace), ne počtem řádků.

## Kvíz
1. Proč test s `mock_provider` neodhalí, že AWS daný typ instance v regionu nenabízí?
2. Co je špatně na testu `assert { condition = var.port == 8080 }`, když `port` je vstup testu?
3. Který nástroj zachytí veřejně čitelný S3 bucket?
4. Jaký je rozdíl mezi `check` blokem a `postcondition`?
5. Proč se integrační testy obvykle nespouštějí na každý commit?
6. Co znamená mutační skóre 50 %?

<details>
<summary>Odpovědi</summary>

1. Mock nevolá API – vrací vygenerované hodnoty. Omezení API ověří jen integrační test (nebo lint s pluginem providera, který zná platné typy).
2. Testuje jen sám sebe (vstup se rovná vstupu) – neověřuje chování modulu.
3. Bezpečnostní skener (Trivy, Checkov) nebo policy as code (OPA, Sentinel).
4. `postcondition` je součást zdroje a při nesplnění **zastaví** apply (chyba); `check` je samostatný a jen **varuje**.
5. Trvají dlouho, stojí peníze a mohou být nestabilní (síť, kvóty). Spouští se např. před vydáním verze modulu nebo v noci.
6. Testy zachytí jen polovinu záměrně vnesených chyb – polovina chování není otestovaná.
</details>

## Zdroje
- [Tests](https://developer.hashicorp.com/terraform/language/tests) · [Mocks](https://developer.hashicorp.com/terraform/language/tests/mocking)
- [Checks](https://developer.hashicorp.com/terraform/language/checks)
- Jia, Y., Harman, M. (2011). An Analysis and Survey of the Development of Mutation Testing. *IEEE TSE* 37(5).

➡️ Lab: [Lab 07 – Testování](../../labs/lab07-testovani/README.md) · Další modul: [09 – Týmová práce a CI/CD](../09-tymova-prace-a-ci-cd/README.md)
