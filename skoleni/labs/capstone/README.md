# Závěrečný projekt – Mini platforma s load balancerem

| Modul | Čas | Obtížnost | Forma |
|---|---|---|---|
| [10 – Závěrečný projekt](../../moduly/10-zaverecny-projekt/README.md) | 3–4 h | ★★★ | Ve dvojicích (pair programming), odevzdání pull requestem |

![Architektura závěrečného projektu](../../obrazky/capstone-architektura.svg)

## Zadání
Postavte lokální „platformu“, která pro každé prostředí nasadí:
- **reverse proxy** (nginx), která na portu hostitele rozkládá požadavky mezi backendy (round robin) a má endpoint `/zdravi` vracející `ok`,
- **N replik backendu** z image `traefik/whoami:v1.11` (vrací mimo jiné `Hostname:` – podle něj poznáte, která replika odpověděla),
- **vlastní Docker síť** pro každé prostředí.

Prostředí jsou dvě: `dev` (2 backendy, port 8100) a `prod` (3 backendy, port 8200). Každé má **vlastní stav**.

## Povinné rozhraní
Akceptační test spoléhá na tyto výstupy kořenového modulu každého prostředí:

| Výstup | Typ | Význam |
|---|---|---|
| `url` | `string` | adresa proxy, např. `http://localhost:8100` |
| `pocet_backendu` | `number` | počet běžících replik backendu |

Doporučená struktura (není povinná):
```
capstone/<vas-tym>/
├── moduly/
│   ├── backend/   # repliky + výstup nazvy
│   └── proxy/     # nginx + šablona nginx.conf
└── prostredi/
    ├── dev/       # tenký kořenový modul: provider, síť, volání modulů
    └── prod/
```

## Akceptační kritéria (musí projít)
```bash
cd capstone/<vas-tym>/prostredi/dev
cp -r ../../../akceptace .
terraform init -test-directory=akceptace
terraform test -test-directory=akceptace
```
Test nasadí prostředí, zavolá `/zdravi`, pošle 12 požadavků a ověří, že všechny vrátily HTTP 200 a že odpověděly **všechny** backendy. Totéž pro `prod`.

## Hodnoticí kritéria (rubrika, 100 bodů)
| Oblast | Body | Plný počet bodů, když… |
|---|---:|---|
| Funkčnost | 25 | akceptační test prochází pro `dev` i `prod` |
| Moduly a rozhraní | 15 | moduly mají popsané vstupy/výstupy (`description`), žádný modul nekonfiguruje provider, kořenové moduly jsou tenké |
| Meta-argumenty | 10 | vhodná volba `count` vs. `for_each` je zdůvodněná v README týmu |
| Validace a podmínky | 10 | vstupy mají validace (port, počet replik, neprázdný seznam backendů), alespoň jedna `precondition` nebo `check` |
| Testy | 15 | jednotkové testy modulů s `mock_provider`, alespoň jeden negativní test (`expect_failures`) |
| Kvalita kódu | 10 | `terraform fmt`, `validate` a `tflint` bez nálezů |
| CI | 10 | workflow v `.github/workflows/` spouští fmt/validate/tflint/test pro váš projekt |
| Dokumentace a reflexe | 5 | README týmu: architektura, jak spustit, 3 rozhodnutí a jejich alternativy |

## Postup (doporučený)
1. **Návrh (30 min):** nakreslete architekturu a rozhraní modulů. Teprve pak kód.
2. **Backend modul + testy (45 min)** – test-first jako v labu 06.
3. **Proxy modul + testy (45 min)** – šablona `nginx.conf` s cyklem přes backendy.
4. **Prostředí dev (30 min)** → akceptační test.
5. **Prostředí prod (15 min)** → akceptační test.
6. **CI + README (30 min).**

Během párového programování se po 25 minutách střídejte v roli *driver* (píše) a *navigator* (čte, kontroluje, myslí dopředu).

<details>
<summary>Nápověda – šablona nginx.conf</summary>

```nginx
upstream backend {
%{ for b in backendy ~}
    server ${b}:80;
%{ endfor ~}
}

server {
    listen 80;
    location = /zdravi { return 200 "ok\n"; }
    location / { proxy_pass http://backend; }
}
```
Šablonu nahrajte do kontejneru blokem `upload` jako `/etc/nginx/conf.d/default.conf`. Názvy backendů musí být DNS jména kontejnerů ve stejné síti.
</details>

<details>
<summary>Nápověda – proč proxy občas nenastartuje?</summary>

nginx při startu překládá jména v `upstream`. Pokud backendy ještě neexistují, kontejner skončí chybou `host not found in upstream`. Řešení: předejte do proxy **výstup** modulu backend (`module.backend.nazvy`) – vznikne implicitní závislost a Terraform vytvoří backendy dřív.
</details>

## Rozšíření (pro rychlé týmy)
- `/zdravi` přes Docker `healthcheck` a `wait = true` u kontejneru proxy.
- Třetí prostředí bez kopírování kódu (tfvars nebo `for_each` přes mapu prostředí) – a diskuse, proč to může být horší než oddělené adresáře.
- Vzdálený backend z labu 04 (PostgreSQL) se samostatným stavem pro každé prostředí.
- Blok `check`, který po nasazení ověří `/zdravi`.

Referenční řešení pro lektory: [`reseni/`](reseni/) – doporučujeme otevřít až po odevzdání.
