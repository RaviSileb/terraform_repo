# Lab 04 – State: drift, import, `moved`, `removed` a zamykání

| Modul | Čas | Obtížnost | Potřebujete |
|---|---|---|---|
| [05 – State](../../moduly/05-state/README.md) | 75 min | ★★★ | Terraform ≥ 1.10, běžící Docker |

## Scénář
Převzali jste malou „produkci“. Část infrastruktury spravuje Terraform, část vznikla ručně. Během labu:
1. zjistíte a opravíte **drift**,
2. **importujete** ručně vytvořenou síť,
3. **přejmenujete** zdroj v kódu bez jeho zničení (`moved`),
4. **předáte** volume jinému týmu, aniž byste ho smazali (`removed`),
5. bonus: přesunete stav do **vzdáleného backendu** (PostgreSQL) a uvidíte **zamykání** v akci.

## Cíle
1. **Vysvětlit**, co state obsahuje a proč je to jediný zdroj pravdy pro Terraform.
2. **Diagnostikovat** drift pomocí `plan` a rozhodnout, zda ho opravit, nebo přijmout.
3. **Importovat** existující zdroj blokem `import` a vygenerovat konfiguraci.
4. **Refaktorovat** kód bloky `moved` a `removed` místo ručních `terraform state mv/rm`.

```mermaid
flowchart LR
  K["Kód (*.tf)<br/>požadovaný stav"] -- plan porovná --> S["State<br/>poslední známý stav"]
  S -- refresh čte --> R["Realita<br/>(Docker API / cloud)"]
  R -. "ruční zásah = drift" .-> S
```

---

## 1. Výchozí nasazení
```bash
cd skoleni/labs/lab04-state/start
terraform init && terraform apply
terraform state list
terraform state show docker_container.web | head -20
```

## 2. Drift
**Predict:** Kolega „omylem“ smaže kontejner. Co ukáže `terraform plan`?
```bash
docker rm -f lab04-web
terraform plan
terraform apply
```
**Investigate:** Co dělá `terraform plan -refresh-only`? Kdy byste místo opravy *přijali* realitu do stavu (`terraform apply -refresh-only`)?

## 3. Import ručně vytvořených zdrojů
Kolega vytvořil síť a volume ručně:
```bash
../skripty/priprava-legacy.sh
```
**a)** Vytvořte soubor `import.tf`:
```hcl
import {
  to = docker_network.legacy
  id = "lab04-legacy-sit"
}
```
**b)** Nechte Terraform vygenerovat konfiguraci:
```bash
terraform plan -generate-config-out=generated.tf
```
**c)** Projděte `generated.tf`, přesuňte blok do `import.tf` a **vyčistěte ho**: odstraňte výchozí hodnoty a hodnoty, které přiděluje Docker (`ipam_config` s `gateway`/`subnet`). Ponechte `name` a `labels`.

**d)** Opakujte totéž pro volume (`docker_volume.data`, id `lab04-data`).

**e)** Cílový plán: `Plan: 2 to import, 0 to add, 0 to change, 0 to destroy.` – pokud vidíte `to add` nebo `to destroy`, konfigurace ještě neodpovídá realitě. Pak `terraform apply`.

> ⚠️ **Investigate – import není vždy bezeztrátový.** Zkuste stejným postupem importovat ručně spuštěný kontejner (`docker run -d --name x -p 8041:80 nginx:1.30-alpine`). Plán ukáže `1 to import, 1 to add, 1 to destroy`: provider Docker při importu nenačte `ports` a `env` a `image` uloží jako tag místo ID – Terraform by kontejner hned po importu nahradil. **Proto vždy čtěte plán importu, než ho potvrdíte.** Kontejner pak smažte (`docker rm -f x`) a import blok odstraňte.

## 4. Přejmenování bez zničení – `moved`
Tým se dohodl, že kontejner se v kódu bude jmenovat `frontend`.

**Predict:** Co udělá plán, když jen přejmenujete `resource "docker_container" "web"` na `"frontend"`? Vyzkoušejte `terraform plan` (nic nepotvrzujte).

Teď přidejte:
```hcl
moved {
  from = docker_container.web
  to   = docker_container.frontend
}
```
Očekávaný plán: `# docker_container.web has moved to docker_container.frontend` a `0 to add, 0 to change, 0 to destroy`.

> **Proč `moved` a ne `terraform state mv`?** Blok `moved` je součástí kódu – projde code review, aplikuje se ve všech prostředích stejně a funguje i pro uživatele vašeho modulu. `state mv` je ruční, neauditovaná operace nad jedním stavem.

## 5. Předání zdroje – `removed`
Volume `lab04-data` od teď spravuje jiný tým. Smažte blok `resource "docker_volume" "data"` a místo něj napište:
```hcl
removed {
  from = docker_volume.data

  lifecycle {
    destroy = false
  }
}
```
**Predict:** Co by se stalo, kdybyste blok `resource` jen smazali bez `removed`?

Po `terraform apply` ověřte, že volume pořád existuje: `docker volume ls`.

## 6. Make – připojení k importované síti
Připojte `docker_container.frontend` k síti `docker_network.legacy` (blok `networks_advanced`). **Predict:** bude změna in-place, nebo replace?

<details>
<summary>🎬 Záznam importu a moved v terminálu (otevřete až po vlastním spuštění)</summary>

![Drift a import v terminálu](../../video/terminal/lab04-state.gif)
</details>

## 7. Ověření
```bash
../overeni.sh
```
Očekávaný výsledek: `Výsledek: 8/8`.

## 8. Bonus – vzdálený backend a zamykání stavu
```bash
../skripty/postgres-backend.sh
```
Přidejte `backend.tf`:
```hcl
terraform {
  backend "pg" {
    conn_str = "postgres://terraform:terraform@localhost:55432/terraform_state?sslmode=disable"
  }
}
```
```bash
terraform init -migrate-state      # přesune lokální stav do PostgreSQL
terraform state list               # stav se teď čte z databáze
ls terraform.tfstate*              # lokální soubor už se nepoužívá
```
**Zamykání:** otevřete dva terminály.
- Terminál A: `terraform apply -replace=docker_container.frontend` – **nepotvrzujte**, nechte čekat na `yes`.
- Terminál B: `terraform plan` → `Error acquiring the state lock` s informací, kdo zámek drží.

Ukončete A (`Ctrl+C` nebo `no`). Zámek se uvolní.

> V produkci se používá S3 (nativní zamykání `use_lockfile = true` bez DynamoDB: zavedeno v 1.10, stabilní od 1.11), Azure Blob Storage, Google Cloud Storage nebo HCP Terraform. Connection string s heslem nepatří do kódu – použijte proměnnou prostředí `PG_CONN_STR` nebo `-backend-config`.

## 9. Úklid
```bash
terraform destroy
../skripty/uklid.sh
```

## 10. Reflexe
1. Co je ve stavu navíc oproti kódu a proč to Terraform potřebuje?
2. Kdy je drift chyba a kdy legitimní změna, kterou máte převzít?
3. Proč je `moved`/`removed`/`import` v kódu lepší než příkazy `terraform state …`?

---

<details>
<summary>Diskuse k předpovědím</summary>

- **Drift:** `Plan: 1 to add` – kontejner je ve stavu, ale refresh zjistí, že v Dockeru neexistuje.
- **Přejmenování bez `moved`:** `1 to add, 1 to destroy` – pro Terraform je to jiná adresa, tedy jiný zdroj. V produkci by to u databáze znamenalo ztrátu dat.
- **Smazání bez `removed`:** Terraform by volume **zničil** (`1 to destroy`). `removed` s `destroy = false` je obdoba `terraform state rm`, ale v kódu.
- **Make:** replace – `networks_advanced` u kontejneru vynucuje náhradu.
</details>

Referenční řešení (konečný stav kódu): [`reseni/`](reseni/)
