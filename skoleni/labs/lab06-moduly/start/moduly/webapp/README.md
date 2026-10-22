# Modul `webapp`

Nasadí statický web (nginx) do Docker kontejneru.

```hcl
module "web" {
  source  = "./moduly/webapp"
  nazev   = "muj-web"
  port    = 8080
  titulek = "Ahoj"
  sit     = docker_network.app.name # nepovinné
}
```

## Vstupy

| Název | Popis | Typ | Výchozí | Povinný |
|---|---|---|---|:-:|
| nazev | Název kontejneru. | `string` | – | ano |
| port | Port na hostiteli. | `number` | – | ano |
| titulek | Text nadpisu stránky. | `string` | – | ano |
| barva | Barva pozadí stránky (CSS). | `string` | `"#7B42BC"` | ne |
| sit | Název Docker sítě, `null` = bez sítě. | `string` | `null` | ne |
| nginx_verze | Tag image nginx. | `string` | `"1.30-alpine"` | ne |

## Výstupy

| Název | Popis |
|---|---|
| url | Adresa webu na hostiteli. |
| nazev_kontejneru | Název vytvořeného kontejneru. |
| id_kontejneru | ID kontejneru v Dockeru. |

Tabulky lze generovat automaticky nástrojem [terraform-docs](https://terraform-docs.io/): `terraform-docs markdown table .`
