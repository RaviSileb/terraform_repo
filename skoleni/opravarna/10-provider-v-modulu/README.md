# Provider uvnitř modulu s for_each

**Obtížnost:** ★★★ · **Soubory:** `main.tf`, `modul/main.tf`

## Situace
Modul převzatý ze starého projektu (vytváří Docker síť) chcete zavolat pro dvě prostředí. Vyžaduje provider Docker.

## Příznak
Po `terraform init`:
```text
Error: Module is incompatible with count, for_each, and depends_on

  on main.tf line 3, in module "site":
   3:   for_each = toset(["dev", "prod"])

The module at module.site is a legacy module which contains its own local
provider configurations, and so calls to it may not use the count, for_each,
or depends_on arguments.

If you also control the module "./modul", consider updating this module to
instead expect provider configurations to be passed by its caller.
```

## Úkol
1. **Než cokoli změníte**, napište jednou větou, co si myslíte, že je příčina.
2. Opravte konfiguraci tak, aby prošly `terraform validate` i `terraform plan`.
3. Porovnejte svou hypotézu se skutečnou příčinou.

Nápovědy otevírejte postupně – každá prozradí o něco víc.

<details>
<summary>Nápověda 1</summary>

Chyba mluví o *legacy module*, který obsahuje vlastní konfiguraci providera.
</details>

<details>
<summary>Nápověda 2</summary>

Kdo má konfigurovat providery – kořenový modul, nebo modul volaný?
</details>

<details>
<summary>Nápověda 3</summary>

Přesuňte blok `provider` z modulu do kořenového modulu. `required_providers` nechte v modulu **i** přidejte do kořene – jinak by kořen odvodil zdroj `hashicorp/docker`, který neexistuje.
</details>

<details>
<summary>Řešení a vysvětlení</summary>

Opravená konfigurace: [`reseni/`](reseni/)

Modul s vlastním blokem `provider` je tzv. *legacy module*: nejde volat s `count`, `for_each` ani `depends_on` a nejde ho bezpečně odstranit (zdroje by zůstaly bez providera). Moderní moduly pouze **deklarují**, co potřebují (`required_providers`), a konfiguraci dostanou od volajícího – implicitně, nebo explicitně argumentem `providers = { docker = docker.jiny }`. Prázdný blok `provider "docker" {}` v modulu Terraform toleruje jen s varováním (zastaralá *proxy configuration*).
</details>
