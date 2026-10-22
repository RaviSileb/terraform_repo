# Podmíněný výraz s různými typy

**Obtížnost:** ★★☆ · **Soubory:** `main.tf`

## Situace
Seznam portů se má lišit podle prostředí. Výraz vypadá logicky, ale Terraform ho odmítá.

## Příznak
Po `terraform init` a `terraform validate`:
```text
Error: Inconsistent conditional result types

  on main.tf line 20, in locals:
  20:   porty = var.prostredi == "prod" ? [80, 443] : "8080"
    ├────────────────
    │ var.prostredi is a string

The true and false result expressions must have consistent types. The 'true'
value is tuple, but the 'false' value is string.
```

## Úkol
1. **Než cokoli změníte**, napište jednou větou, co si myslíte, že je příčina.
2. Opravte konfiguraci tak, aby prošly `terraform validate` i `terraform plan`.
3. Porovnejte svou hypotézu se skutečnou příčinou.

Nápovědy otevírejte postupně – každá prozradí o něco víc.

<details>
<summary>Nápověda 1</summary>

Jaký typ má větev „pravda“ a jaký větev „nepravda“?
</details>

<details>
<summary>Nápověda 2</summary>

Terraform musí znát typ výsledku podmíněného výrazu bez ohledu na to, která větev se vybere.
</details>

<details>
<summary>Nápověda 3</summary>

Obě větve musí mít stejný typ: `[80, 443] : [8080]`.
</details>

<details>
<summary>Řešení a vysvětlení</summary>

Opravená konfigurace: [`reseni/`](reseni/)

Terraform je **staticky typovaný** jazyk s odvozováním typů. Výsledek výrazu `c ? a : b` musí mít jeden typ, jinak by navazující kód (`join`) nemohl být typově zkontrolován. Některé kombinace Terraform sjednotí automaticky (např. číslo a řetězec na řetězec), seznam a řetězec ne.
</details>
