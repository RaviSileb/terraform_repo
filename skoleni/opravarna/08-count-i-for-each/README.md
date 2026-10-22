# count a for_each zároveň

**Obtížnost:** ★☆☆ · **Soubory:** `main.tf`

## Situace
Někdo chtěl soubory „zapínat a vypínat“ a zároveň je vytvářet pro každé prostředí.

## Příznak
Po `terraform init` a `terraform validate`:
```text
Error: Invalid combination of "count" and "for_each"

  on main.tf line 21, in resource "local_file" "konfigurace":
  21:   for_each = toset(["dev", "prod"])

The "count" and "for_each" meta-arguments are mutually-exclusive, only one
should be used to be explicit about the number of resources to be created.
```

## Úkol
1. **Než cokoli změníte**, napište jednou větou, co si myslíte, že je příčina.
2. Opravte konfiguraci tak, aby prošly `terraform validate` i `terraform plan`.
3. Porovnejte svou hypotézu se skutečnou příčinou.

Nápovědy otevírejte postupně – každá prozradí o něco víc.

<details>
<summary>Nápověda 1</summary>

Zdroj může mít buď `count`, nebo `for_each` – ne obojí.
</details>

<details>
<summary>Nápověda 2</summary>

Jak vyjádřit „žádná instance“ pomocí `for_each`?
</details>

<details>
<summary>Nápověda 3</summary>

Podmínku přesuňte do výrazu: `for_each = var.zapnuto ? toset([...]) : toset([])`.
</details>

<details>
<summary>Řešení a vysvětlení</summary>

Opravená konfigurace: [`reseni/`](reseni/)

Podmíněné vytváření zdrojů se v Terraformu vyjadřuje **počtem instancí**: `count = podmínka ? 1 : 0` nebo `for_each` s prázdnou kolekcí. Obě hodnoty se musí dát vyhodnotit při plánu.
</details>
