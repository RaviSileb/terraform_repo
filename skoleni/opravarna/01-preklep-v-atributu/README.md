# Překlep v atributu

**Obtížnost:** ★☆☆ · **Soubory:** `main.tf`

## Situace
Kolega přidal soubor s pozdravem. `terraform validate` ale neprojde.

## Příznak
Po `terraform init` a `terraform validate`:
```text
Error: Unsupported attribute

  on main.tf line 18, in resource "local_file" "pozdrav":
  18:   content  = "Ahoj ${random_pet.jmeno.name}!"

This object has no argument, nested block, or exported attribute named
"name".
```

## Úkol
1. **Než cokoli změníte**, napište jednou větou, co si myslíte, že je příčina.
2. Opravte konfiguraci tak, aby prošly `terraform validate` i `terraform plan`.
3. Porovnejte svou hypotézu se skutečnou příčinou.

Nápovědy otevírejte postupně – každá prozradí o něco víc.

<details>
<summary>Nápověda 1</summary>

Chyba říká, který atribut neexistuje. Kde zjistíte, jaké atributy zdroj `random_pet` má?
</details>

<details>
<summary>Nápověda 2</summary>

Dokumentace v registry má sekci *Attributes Reference*. Alternativa offline: `terraform providers schema -json`.
</details>

<details>
<summary>Nápověda 3</summary>

`random_pet` vrací vygenerované jméno v atributu `id`.
</details>

<details>
<summary>Řešení a vysvětlení</summary>

Opravená konfigurace: [`reseni/`](reseni/)

Terraform kontroluje reference proti **schématu providera** už při `validate`, bez volání API. Atributy zdroje = argumenty, které zadáváte, plus atributy, které vrací provider (*computed*). Proto je `validate` levná první linie obrany v CI.
</details>
