# Špatný typ proměnné

**Obtížnost:** ★☆☆ · **Soubory:** `main.tf`, `terraform.tfvars`

## Situace
Kolega připravil `terraform.tfvars`. Plán spadne hned na začátku.

## Příznak
Po `terraform init` a `terraform plan`:
```text
Error: Invalid value for input variable

  on terraform.tfvars line 1:
   1: pocet_souboru = "tri"

The given value is not suitable for var.pocet_souboru declared at
main.tf:14,1-25: a number is required.
```

## Úkol
1. **Než cokoli změníte**, napište jednou větou, co si myslíte, že je příčina.
2. Opravte konfiguraci tak, aby prošly `terraform validate` i `terraform plan`.
3. Porovnejte svou hypotézu se skutečnou příčinou.

Nápovědy otevírejte postupně – každá prozradí o něco víc.

<details>
<summary>Nápověda 1</summary>

Chyba ukazuje přímo na soubor a řádek, odkud hodnota přišla.
</details>

<details>
<summary>Nápověda 2</summary>

Terraform umí automaticky převést řetězec `"3"` na číslo. Umí převést `"tri"`?
</details>

<details>
<summary>Nápověda 3</summary>

V `terraform.tfvars` použijte číslo: `pocet_souboru = 3`.
</details>

<details>
<summary>Řešení a vysvětlení</summary>

Opravená konfigurace: [`reseni/`](reseni/)

Typový systém Terraformu provádí **automatické konverze** (`"3"` → `3`, `true` → `"true"`), ale jen tam, kde jsou jednoznačné. Explicitní `type` u proměnných zachytí chybu na vstupu – co nejblíž jejímu původu – místo kdesi hluboko v konfiguraci.
</details>
