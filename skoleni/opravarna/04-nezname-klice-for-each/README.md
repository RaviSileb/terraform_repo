# Klíče for_each známé až po apply

**Obtížnost:** ★★★ · **Soubory:** `main.tf`

## Situace
Pro každé náhodné jméno chcete vytvořit soubor pojmenovaný podle něj. Plán ale selže.

## Příznak
Po `terraform init` a `terraform plan`:
```text
Error: Invalid for_each argument

  on main.tf line 19, in resource "local_file" "server":
  19:   for_each = toset(random_pet.server[*].id)
    ├────────────────
    │ random_pet.server is tuple with 3 elements

The "for_each" set includes values derived from resource attributes that
cannot be determined until apply, and so Terraform cannot determine the full
set of keys that will identify the instances of this resource.

When working with unknown values in for_each, it's better to use a map value
where the keys are defined statically in your configuration and where only
the values contain apply-time results.

Alternatively, you could use the -target planning option to first apply only
the resources that the for_each value depends on, and then apply a second
time to fully converge.
```

## Úkol
1. **Než cokoli změníte**, napište jednou větou, co si myslíte, že je příčina.
2. Opravte konfiguraci tak, aby prošly `terraform validate` i `terraform plan`.
3. Porovnejte svou hypotézu se skutečnou příčinou.

Nápovědy otevírejte postupně – každá prozradí o něco víc.

<details>
<summary>Nápověda 1</summary>

Kdy přesně vznikne hodnota `random_pet.server[0].id` – při plánu, nebo při apply?
</details>

<details>
<summary>Nápověda 2</summary>

Terraform musí znát **adresy** všech zdrojů už při plánu. Adresa `local_file.server["???"]` by obsahovala neznámou hodnotu.
</details>

<details>
<summary>Nápověda 3</summary>

Použijte jako klíče statické hodnoty, které znáte předem (např. role serverů), a náhodná jména dejte až do **hodnot** argumentů.
</details>

<details>
<summary>Řešení a vysvětlení</summary>

Opravená konfigurace: [`reseni/`](reseni/)

Klíče `for_each` (a hodnota `count`) určují **počet a adresy** zdrojů, a ty musí být známé ve fázi plánu. Hodnoty argumentů naopak mohou být `(known after apply)`. Obecné pravidlo: klíče odvozujte ze vstupů a konstant, ne z atributů jiných zdrojů. Nouzové řešení `-target` je jen obezlička.
</details>
