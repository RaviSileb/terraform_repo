# Průvodce lektora

Kurz lze vést **prezenčně / online za 2 dny** (doporučeno 8–16 účastníků) nebo jako **samostudium** (účastník jde podle [README](README.md), autograder nahrazuje kontrolu lektorem).

## Týden předem
- [ ] Pošlete účastníkům odkaz na repozitář, [modul 00](moduly/00-priprava/README.md) a epizody podcastu [00](podcast/ep00-jak-se-ucit.md) a [01](podcast/ep01-proc-infrastruktura-jako-kod.md).
- [ ] Požádejte o spuštění `./skoleni/nastroje/overeni-prostredi.sh` a screenshot výsledku. Kdo má ❌, řeší to **před** kurzem nebo použije Codespaces.
- [ ] Ověřte si sami: `./skoleni/nastroje/zkontroluj.sh vse reseni --integrace` a `zkontroluj.sh capstone reseni --integrace` (musí být vše ✅).
- [ ] Firemní síť: povolte `registry.terraform.io`, `releases.hashicorp.com`, `github.com` (provider Docker), Docker Hub. Při omezení stahování připravte [síťové zrcadlo providerů](https://developer.hashicorp.com/terraform/cli/config/config-file#provider-installation) nebo použijte Codespaces.
- [ ] Docker Hub omezuje anonymní stahování; u větší skupiny za jednou NAT adresou ať se účastníci přihlásí (`docker login`), nebo si image stáhnou předem: `docker pull nginx:1.30-alpine traefik/whoami:v1.11 postgres:17-alpine`.
- [ ] Vytiskněte nebo sdílejte [TAHAK.md](TAHAK.md).

## Rozvrh – 2 dny
| Čas | Den 1 – základy | Den 2 – tým a produkce |
|---|---|---|
| 9:00 | Úvod, očekávání, PRIMM ([modul 00](moduly/00-priprava/README.md)) | Rozcvička (míchané otázky z modulů 01–05) |
| 9:20 | [01 Proč IaC](moduly/01-proc-iac/README.md) + aktivita „Rekonstrukce“ | [06 Meta-argumenty](moduly/06-meta-argumenty/README.md) |
| 10:00 | [02 HCL a workflow](moduly/02-hcl-a-workflow/README.md) → [Lab 01](labs/lab01-prvni-kroky/README.md) | [Lab 05](labs/lab05-for-each/README.md) |
| 11:15 | přestávka | přestávka |
| 11:30 | [03 Proměnné](moduly/03-promenne-a-vystupy/README.md) → [Lab 02](labs/lab02-promenne/README.md) | [07 Moduly](moduly/07-moduly/README.md) → [Lab 06](labs/lab06-moduly/README.md) |
| 12:45 | oběd | oběd |
| 13:30 | [04 Providery](moduly/04-providery-a-zavislosti/README.md) → [Lab 03](labs/lab03-docker/README.md) | [08 Testování](moduly/08-testovani/README.md) → [Lab 07](labs/lab07-testovani/README.md) |
| 15:00 | [05 State](moduly/05-state/README.md) → [Lab 04](labs/lab04-state/README.md) | [09 CI/CD](moduly/09-tymova-prace-a-ci-cd/README.md) → [Lab 08](labs/lab08-ci-cd/README.md) (zkráceně) |
| 16:30 | [Opravárna](opravarna/README.md) – „debugging relay“ ve dvojicích | Zadání [závěrečného projektu](labs/capstone/README.md), návrh na papír |
| 17:00 | Exit ticket, úkol: podcast 06–07, kartičky | Exit ticket; projekt dokončit do týdne, review přes PR |

**Varianta 3 dny:** závěrečný projekt celý třetí den podle [modulu 10](moduly/10-zaverecny-projekt/README.md) (s peer review a retrospektivou).

## Jak vést jednotlivé části
### Rozcvička (5 min)
Tři otázky na plátně, odpovědi **na papír, bez poznámek a bez notebooku**. Pak porovnání ve dvojicích a teprve potom správná odpověď. Otázky berte z kvízů *dřívějších* modulů (ne z posledního) – rozložení a prokládání.

### Výklad (max. 20 min)
Ukažte diagram modulu a nechte účastníky **předpovídat** dřív, než řeknete odpověď („Co ukáže plán, když…?“). Hlasování rukou nebo přes chat. Vyhněte se čtení slajdů – videa lekcí slouží jako opakování, ne jako náhrada výkladu.

### Lab
- Na začátku zdůrazněte krok *Predict* a nechte 2 minuty na zápis předpovědí.
- Neprocházejte řešení frontálně. Choďte mezi lidmi a ptejte se: „Co jsi předpovídal? Co se stalo? Proč?“
- Rychlí účastníci: část *Make* a bonusy. Pomalí: nápovědy v `<details>`, případně párování s rychlejším kolegou.
- Na konci 5 minut: dva až tři lidé řeknou, co je **překvapilo**. To je nejcennější část labu.

### Opravárna – „debugging relay“
Dvojice, jedna úloha, předávání klávesnice po 3 minutách. Kdo nepíše, nahlas komentuje chybovou hlášku. Na konci každá dvojice napíše na tabuli jednu větu „Chyba vznikla, protože…“.

### Exit ticket (3 min)
1. Nejdůležitější věc, kterou si odnáším.
2. Co je mi pořád nejasné.

Odpovědi na bod 2 projděte na začátku dalšího dne.

## Časté problémy
| Problém | Řešení |
|---|---|
| `Error: Failed to query available provider packages` | síť/proxy – zkontrolujte přístup k `registry.terraform.io`, případně `HTTPS_PROXY` |
| Terraform se nepřipojí k Dockeru (macOS) | `export DOCKER_HOST=unix://$HOME/.docker/run/docker.sock` nebo v Docker Desktop povolit výchozí socket |
| `port is already allocated` | jiný kontejner nebo služba na portu: `docker ps`, změna `-var port=…` |
| `toomanyrequests` z Docker Hubu | `docker login`, předem stažené image |
| Lab 04: `overeni.sh` hlásí neprázdný plán | často zapomenutý import volume nebo ručně smazaný kontejner – `terraform plan` ukáže co |
| Lab 07: `mutace.py` hlásí, že mutanta nelze vložit | účastník změnil kód modulu – vrátit `main.tf`/`variables.tf`/`outputs.tf` z `reseni/` |
| Windows bez WSL | doporučte Codespaces; skripty `*.sh` vyžadují bash |

## Hodnocení kurzu
- **Před a po:** stejný 10otázkový test (výběr z kvízů modulů 01–09). Rozdíl skóre je hrubý, ale užitečný ukazatel.
- **Autograder:** ve forku účastníka tabulka splněných labů v GitHub Actions.
- **Závěrečný projekt:** [rubrika](labs/capstone/README.md#hodnoticí-kritéria-rubrika-100-bodů).
- **Zpětná vazba:** anonymní dotazník – co ponechat, co změnit, tempo (pomalé/přiměřené/rychlé).

## Úpravy kurzu
- **Jiný cloud místo Dockeru:** principy labů platí; ukázky pro AWS/Azure/GCP jsou v kořeni repozitáře. Počítejte s náklady a s časem na přístupy.
- **OpenTofu:** příkazy `tofu …`. Skripty kurzu volají `terraform`; alias se do skriptů nepřenese, použijte symlink: `mkdir -p ~/bin && ln -s "$(command -v tofu)" ~/bin/terraform` (a `~/bin` na začátek `PATH`).
- **Přegenerování médií:** úpravy textů podcastu a videí → [nastroje/media](nastroje/media/README.md).
