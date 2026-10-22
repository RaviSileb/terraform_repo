# 🔧 Opravárna – break-fix úlohy

Deset rozbitých konfigurací. Každá selže se **skutečnou chybovou hláškou Terraformu** (zachycenou z běhu Terraformu 1.17). Vaším úkolem je ji opravit.

## Proč takhle?
Číst chybové hlášky a hledat příčinu je dovednost, kterou v práci s Terraformem používáte nejčastěji – a v tutoriálech se skoro necvičí. Úlohy jsou postavené na třech principech:
1. **Nejdřív hypotéza, pak oprava.** Než cokoli změníte, napište, co si myslíte, že je příčina. Porovnání hypotézy s realitou je to, co se zapamatuje.
2. **Postupné nápovědy (scaffolding).** Každá úloha má tři nápovědy od nejobecnější po téměř řešení. Otevírejte je až po minutě vlastního přemýšlení.
3. **Vysvětlení „proč“.** Po opravě si přečtěte, jaký princip za chybou stojí – oprava bez pochopení se nepřenese na další problém.

## Úlohy
| # | Úloha | Obtížnost | Téma (modul) |
|---|---|---|---|
| 01 | [Překlep v atributu](01-preklep-v-atributu/) | ★☆☆ | reference, schéma providera (02) |
| 02 | [Cyklická závislost](02-cyklus/) | ★★☆ | graf závislostí (04) |
| 03 | [for_each se seznamem](03-for-each-se-seznamem/) | ★☆☆ | `for_each`, typy (06) |
| 04 | [Klíče for_each známé až po apply](04-nezname-klice-for-each/) | ★★★ | plan vs. apply, neznámé hodnoty (06) |
| 05 | [Citlivá hodnota ve výstupu](05-citlivy-vystup/) | ★☆☆ | `sensitive` (03) |
| 06 | [Špatný typ proměnné](06-spatny-typ-promenne/) | ★☆☆ | typy, tfvars (03) |
| 07 | [Duplicitní zdroj](07-duplicitni-zdroj/) | ★☆☆ | struktura modulu (02) |
| 08 | [count a for_each zároveň](08-count-i-for-each/) | ★☆☆ | meta-argumenty (06) |
| 09 | [Podmíněný výraz s různými typy](09-nekonzistentni-podminka/) | ★★☆ | typový systém (03) |
| 10 | [Provider uvnitř modulu s for_each](10-provider-v-modulu/) | ★★★ | moduly a providery (07), vyžaduje Docker provider |

## Jak pracovat
```bash
cd skoleni/opravarna/01-preklep-v-atributu
terraform init
terraform validate      # nebo příkaz uvedený v zadání
# … oprava …
terraform validate && terraform plan
```
Kontrola všech úloh najednou: `./skoleni/nastroje/zkontroluj.sh opravarna`

## Varianta pro skupinu: „Debugging relay“
Dvojice dostanou stejnou úlohu. Každé 3 minuty si předají klávesnici a ten, kdo nepíše, **nahlas** popisuje, co vidí v chybové hlášce. Po opravě dvojice napíše na tabuli jednu větu: „Chyba vznikla, protože…“. Lektor na konci porovná formulace – rozdíly bývají poučné.
