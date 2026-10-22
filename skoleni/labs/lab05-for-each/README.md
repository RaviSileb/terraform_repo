# Lab 05 – `count` vs. `for_each`, `dynamic`, výrazy `for` a `precondition`

| Modul | Čas | Obtížnost | Potřebujete |
|---|---|---|---|
| [06 – Meta-argumenty a výrazy](../../moduly/06-meta-argumenty/README.md) | 75 min | ★★★ | Terraform ≥ 1.10, Docker (testy běží i bez něj) |

![count vs for_each](../../obrazky/count-vs-for-each.svg)

## Cíle
1. **Předpovědět**, proč `count` nad seznamem vede k nechtěným náhradám, když odeberete prvek uprostřed.
2. **Refaktorovat** `count` → `for_each` bez výpadku pomocí bloků `moved`.
3. **Použít** výrazy `for`, `merge(...)` se zploštěním a blok `dynamic`.
4. **Chránit** konfiguraci pomocí `precondition`.

---

## Část A – past jménem `count`
```bash
cd skoleni/labs/lab05-for-each/start
terraform init && terraform apply
terraform output
```
**Predict (zapište si!):** Tým ruší službu `api` – prostřední prvek seznamu `["web", "api", "docs"]`. Co udělá plán?

```bash
terraform plan -var 'sluzby_seznam=["web","docs"]'
```
**Investigate:**
- Kolik kontejnerů se zničí a kolik vytvoří? Proč se dotkne i `docs`, která se neměnila?
- Jak vypadají adresy zdrojů ve stavu? (`terraform state list`)

Plán **neaplikujte**.

<details>
<summary>🎬 Záznam části A v terminálu (otevřete až po vlastním plánu)</summary>

![count: odebrání prvku ze středu](../../video/terminal/lab05-count.gif)
</details>

## Část B – refaktoring na `for_each` bez výpadku
1. Ve `variables.tf` nahraďte `sluzby_seznam` proměnnou:
   ```hcl
   variable "sluzby" {
     type = map(object({
       port    = number
       repliky = optional(number, 1)
       env     = optional(map(string), {})
       stitky  = optional(map(string), {})
     }))
     default = {
       web  = { port = 8050 }
       api  = { port = 8051 }
       docs = { port = 8052 }
     }
   }
   ```
2. V `main.tf` změňte `count` na `for_each = var.sluzby`, `name = "lab05-${each.key}"`, `external = each.value.port`.
3. Ve výstupu `url` použijte výraz pro mapu: `{ for k, c in docker_container.sluzba : k => "http://localhost:${c.ports[0].external}" }`.
4. **Predict:** co teď ukáže plán? Ověřte `terraform plan`.
5. Přidejte tři bloky `moved` (`sluzba[0]` → `sluzba["web"]` atd.). Cíl: **`Plan: 0 to add, 0 to change, 0 to destroy`** a tři řádky `has moved to`. Pak `terraform apply`.
6. **Ověřte stabilitu klíčů:** `terraform plan -var 'sluzby={web={port=8050},docs={port=8052}}'` → zničí se **jen** `api`.

## Část C – repliky, `dynamic`, výrazy `for`
Upravte konfiguraci tak, aby:
1. každá služba mohla mít `repliky` (výchozí 1); první replika se jmenuje `lab05-<služba>`, další `lab05-<služba>-1`, `-2` …, port repliky `i` je `port + i`,
2. mapa `env` se převedla na seznam `"KLIC=hodnota"` (argument `env` kontejneru),
3. každý kontejner měl štítek `sluzba=<název>` plus štítky ze `stitky` – blok `dynamic "labels"`,
4. všechny kontejnery byly v síti `lab05-sit` s DNS aliasem = název služby.

<details>
<summary>Nápověda – zploštění map (flatten pattern)</summary>

```hcl
locals {
  instance = merge([
    for nazev, s in var.sluzby : {
      for i in range(s.repliky) : (i == 0 ? nazev : "${nazev}-${i}") => {
        sluzba = nazev
        port   = s.port + i
        env    = s.env
        stitky = s.stitky
      }
    }
  ]...)
}
```
Vnější `for` vrací seznam map, `merge(...)` s trojtečkou ho „rozbalí“ do jedné mapy. Výsledek použijte ve `for_each = local.instance`.
</details>

<details>
<summary>Nápověda – dynamic</summary>

```hcl
dynamic "labels" {
  for_each = merge(each.value.stitky, { sluzba = each.value.sluzba })
  content {
    label = labels.key
    value = labels.value
  }
}
```
</details>

## Část D – `precondition`
**Predict:** nastavíte `web = { port = 8050, repliky = 2 }` a `api = { port = 8051 }`. Co se stane?

Přidejte do kontejneru:
```hcl
lifecycle {
  precondition {
    condition     = length(distinct(local.vsechny_porty)) == length(local.vsechny_porty)
    error_message = "Kolize portů: ..."
  }
}
```
kde `local.vsechny_porty = [for i in values(local.instance) : i.port]`.

**Investigate:** Proč se chyba vypíše vícekrát? Kam byste kontrolu přesunuli, aby se vypsala jednou a dřív?

## Ověření
```bash
terraform test     # 5 testů, mock provider – Docker není potřeba
```
Ověření v Dockeru: `docker exec lab05-web wget -qO- http://api` (DNS alias v síti).

## Úklid
```bash
terraform destroy
```

## Reflexe
1. Formulujte pravidlo: kdy `count`, kdy `for_each`?
2. Proč musí být klíče `for_each` známé už při plánu?
3. Kde ve vaší práci by `moved` ušetřil výpadek?

---

<details>
<summary>Diskuse k předpovědím</summary>

- **Část A:** `Plan: 1 to add, 0 to change, 2 to destroy`. Zdroje s `count` jsou adresované indexem: `sluzba[0]`, `[1]`, `[2]`. Po odebrání `api` se `docs` posune z indexu 2 na 1 → `sluzba[1]` se nahradí (jméno `lab05-api` → `lab05-docs`) a `sluzba[2]` se zničí.
- **Část B krok 4:** bez `moved` Terraform zničí 3 kontejnery (`sluzba[0..2]`) a vytvoří 3 nové (`sluzba["web"]`…).
- **Část D:** `web-1` dostane port 8051, který už má `api` → precondition selže ještě při plánu, nic se nezmění.
- **Investigate D:** precondition se vyhodnocuje pro každou instanci. Lepší je validace proměnné `sluzby`, která porty spočítá přímo z `var.sluzby` – chyba je jedna a objeví se před plánováním zdrojů.
- **Reflexe 1:** `count` pro „0 nebo 1“ (podmíněný zdroj: `count = var.zapnuto ? 1 : 0`) nebo pro N identických kusů; `for_each` pro kolekce s identitou (jména, prostředí, služby).
</details>

Referenční řešení: [`reseni/`](reseni/)
