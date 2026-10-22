# Citlivá hodnota ve výstupu

**Obtížnost:** ★☆☆ · **Soubory:** `main.tf`

## Situace
Potřebujete předat vygenerované heslo dalšímu týmu přes výstup.

## Příznak
Po `terraform init` a `terraform plan`:
```text
Error: Output refers to sensitive values

  on main.tf line 18:
  18: output "heslo_db" {

To reduce the risk of accidentally exporting sensitive data that was intended
to be only internal, Terraform requires that any root module output
containing sensitive data be explicitly marked as sensitive, to confirm your
intent.

If you do intend to export this data, annotate the output value as sensitive
by adding the following argument:
    sensitive = true
```

## Úkol
1. **Než cokoli změníte**, napište jednou větou, co si myslíte, že je příčina.
2. Opravte konfiguraci tak, aby prošly `terraform validate` i `terraform plan`.
3. Porovnejte svou hypotézu se skutečnou příčinou.

Nápovědy otevírejte postupně – každá prozradí o něco víc.

<details>
<summary>Nápověda 1</summary>

Atribut `result` u `random_password` je v providerovi označen jako citlivý.
</details>

<details>
<summary>Nápověda 2</summary>

Terraform nedovolí, aby citlivá hodnota „unikla“ do výstupu bez vašeho výslovného souhlasu.
</details>

<details>
<summary>Nápověda 3</summary>

Přidejte do výstupu `sensitive = true`. Hodnotu pak získáte příkazem `terraform output -raw heslo_db`.
</details>

<details>
<summary>Řešení a vysvětlení</summary>

Opravená konfigurace: [`reseni/`](reseni/)

Citlivost se v Terraformu **šíří**: co je odvozené z citlivé hodnoty, je citlivé. Výstup musíte označit explicitně, aby bylo vidět, že víte, co děláte. Pozor: hodnota je dál ve stavu v čitelné podobě. Pro předávání tajemství mezi týmy je lepší správce tajemství (Vault, AWS Secrets Manager, Azure Key Vault).
</details>
