# for_each se seznamem

**Obtížnost:** ★☆☆ · **Soubory:** `main.tf`

## Situace
Chcete vytvořit soubor pro každého člena týmu. Seznam jmen máte v proměnné.

## Příznak
Po `terraform init` a `terraform plan`:
```text
Error: Invalid for_each argument

  on main.tf line 20, in resource "local_file" "uvitani":
  20:   for_each = var.tym
    ├────────────────
    │ var.tym is a list of string

The given "for_each" argument value is unsuitable: the "for_each" argument
must be a map, or set of strings, and you have provided a value of type list
of string.
```

## Úkol
1. **Než cokoli změníte**, napište jednou větou, co si myslíte, že je příčina.
2. Opravte konfiguraci tak, aby prošly `terraform validate` i `terraform plan`.
3. Porovnejte svou hypotézu se skutečnou příčinou.

Nápovědy otevírejte postupně – každá prozradí o něco víc.

<details>
<summary>Nápověda 1</summary>

Přečtěte si, jaké typy `for_each` přijímá.
</details>

<details>
<summary>Nápověda 2</summary>

Seznam může obsahovat duplicity a jeho prvky jsou adresované indexem. `for_each` potřebuje jednoznačné klíče.
</details>

<details>
<summary>Nápověda 3</summary>

Převeďte seznam na množinu funkcí `toset()` (nebo změňte typ proměnné na `set(string)`).
</details>

<details>
<summary>Řešení a vysvětlení</summary>

Opravená konfigurace: [`reseni/`](reseni/)

`for_each` přijímá **mapu** nebo **množinu řetězců** – obě mají jednoznačné klíče, které se stanou součástí adresy zdroje (`local_file.uvitani["alena"]`). U seznamu by klíčem byl index a vrátili bychom se k problémům `count` (lab 05).
</details>
