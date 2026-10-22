# Cyklická závislost

**Obtížnost:** ★★☆ · **Soubory:** `main.tf`

## Situace
Dva zdroje si navzájem potřebují předat informaci. Terraform odmítá konfiguraci zpracovat.

## Příznak
Po `terraform init` a `terraform validate`:
```text
Error: Cycle:
  terraform_data.klient
  terraform_data.server
```

## Úkol
1. **Než cokoli změníte**, napište jednou větou, co si myslíte, že je příčina.
2. Opravte konfiguraci tak, aby prošly `terraform validate` i `terraform plan`.
3. Porovnejte svou hypotézu se skutečnou příčinou.

Nápovědy otevírejte postupně – každá prozradí o něco víc.

<details>
<summary>Nápověda 1</summary>

Nakreslete si graf: kdo na koho odkazuje? Terraform potřebuje acyklický graf (DAG), aby věděl, co vytvořit dřív.
</details>

<details>
<summary>Nápověda 2</summary>

Potřebují zdroje opravdu hodnotu, kterou vytvoří ten druhý, nebo jen hodnotu, kterou znáte předem?
</details>

<details>
<summary>Nápověda 3</summary>

Hodnoty známé předem (jména) vytáhněte do `locals` a odkazujte na ně. Reálnou závislost nechte jen jedním směrem.
</details>

<details>
<summary>Řešení a vysvětlení</summary>

Opravená konfigurace: [`reseni/`](reseni/)

Terraform staví z referencí **orientovaný acyklický graf** a podle něj určuje pořadí a paralelismus. Cyklus znamená, že neexistuje pořadí, ve kterém by šlo zdroje vytvořit. V cloudu typicky vzniká u security group, které se navzájem povolují – řeší se samostatnými zdroji pravidel (např. `aws_vpc_security_group_ingress_rule`).
</details>
