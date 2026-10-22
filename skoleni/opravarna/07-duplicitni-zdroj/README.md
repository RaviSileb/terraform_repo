# Duplicitní zdroj

**Obtížnost:** ★☆☆ · **Soubory:** `main.tf`, `dokumentace.tf`

## Situace
Dva lidé ve stejném PR přidali „stejnou“ věc do různých souborů.

## Příznak
Po `terraform init` a `terraform validate`:
```text
Error: Duplicate resource "local_file" configuration

  on main.tf line 14:
  14: resource "local_file" "readme" {

A local_file resource named "readme" was already declared at
dokumentace.tf:1,1-31. Resource names must be unique per type in each module.
```

## Úkol
1. **Než cokoli změníte**, napište jednou větou, co si myslíte, že je příčina.
2. Opravte konfiguraci tak, aby prošly `terraform validate` i `terraform plan`.
3. Porovnejte svou hypotézu se skutečnou příčinou.

Nápovědy otevírejte postupně – každá prozradí o něco víc.

<details>
<summary>Nápověda 1</summary>

Terraform načítá všechny soubory `*.tf` v adresáři jako jednu konfiguraci.
</details>

<details>
<summary>Nápověda 2</summary>

Adresa zdroje `<typ>.<jméno>` musí být v modulu jedinečná bez ohledu na soubor.
</details>

<details>
<summary>Nápověda 3</summary>

Rozhodněte, která verze platí, a druhou smažte (zde: smažte `dokumentace.tf` a sjednoťte obsah).
</details>

<details>
<summary>Řešení a vysvětlení</summary>

Opravená konfigurace: [`reseni/`](reseni/)

Rozdělení do souborů je jen pro lidi – pro Terraform je modul **jeden jmenný prostor**. Konvence `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf` pomáhá orientaci, ale nic nevynucuje.
</details>
