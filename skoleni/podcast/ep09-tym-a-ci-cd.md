# Ep. 09 – Tým, prostředí a pipeline

> 🎧 [Poslechnout MP3](epizody/ep09-tym-a-ci-cd.mp3) · Modul: [09 – Týmová práce a CI/CD](../moduly/09-tymova-prace-a-ci-cd/README.md) · Lab: [08](../labs/lab08-ci-cd/README.md) · Mluví: **Petra** a **Tomáš**

---

**Tomáš:** Devátá epizoda. Odpověď z minula: apply z notebooku je riskantní, protože ho nikdo nezkontroluje a nikde nezůstane záznam.

**Petra:** A ještě protože notebook má jiné verze nástrojů, jiné proměnné prostředí a možná přihlášení k jinému účtu, než si myslíš. I opatrný člověk je člověk. Proto se v týmech zavádí jednoduché pravidlo: do sdílených prostředí se aplikuje jen z pipeline.

**Tomáš:** Jak taková pipeline vypadá?

**Petra:** Na pull request se spustí kontroly: formát, validace, lint, bezpečnostní sken, testy a nakonec plán. Plán se zobrazí v pull requestu, takže reviewer čte nejen kód, ale i to, co se reálně stane. Po merge do hlavní větve se plán udělá znovu a uloží do souboru. A než se aplikuje, musí ho někdo schválit. V GitHub Actions se na to používá environment s povinnými schvalovateli.

**Tomáš:** Proč se plán dělá znovu? Už jsme ho viděli v pull requestu.

**Petra:** Mezi pull requestem a merge mohl někdo jiný změnit stav. Proto se po merge plánuje znovu a aplikuje se přesně ten uložený plán z téhož běhu. A kdyby se stav mezitím změnil, Terraform zastaralý plán odmítne.

**Tomáš:** V labu osm byla v pipeline položka concurrency.

**Petra:** Ta zajistí, že nad stejným stavem nepoběží dva běhy najednou, a že běžící apply se nepřeruší. Přerušený apply je jedna z nejnepříjemnějších věcí, protože část změn proběhne a část ne.

**Tomáš:** Jak se pipeline přihlásí do cloudu? Dám do secrets přístupový klíč?

**Petra:** Raději ne. Moderní cesta je OIDC. Představ si hotelovou kartu, která funguje jen na tvůj pokoj a jen do konce pobytu, oproti generálnímu klíči, který visí na háčku navždy. GitHub vystaví krátkodobý token a cloud ho vymění za dočasná oprávnění. A můžeš nastavit, že důvěřuje jen konkrétnímu repozitáři a větvi. V secrets pak není nic, co by mohl někdo ukrást.

**Tomáš:** Teď prostředí. Dev, test, produkce. Workspaces, nebo adresáře?

**Petra:** Tady se praxe trochu přou, ale většina týmů pro dlouhodobá prostředí volí oddělené adresáře nebo aspoň oddělené stavy. Každé prostředí má malý kořenový modul, který volá stejné moduly s jinými vstupy. Má vlastní backend a vlastní oprávnění, a rozdíly jsou vidět v kódu. Workspaces sdílí backend i práva a prostředí se liší jen jménem workspace, takže je snadné aplikovat do špatného. Hodí se spíš na dočasná prostředí, třeba náhled pro pull request.

**Tomáš:** Na co se dívat při review plánu?

**Petra:** Mám na to checklist. Odpovídá řádek plán tomu, co pull request slibuje? Je každé nahrazení a smazání vysvětlené? Nemění se oprávnění, sítě nebo šifrování, o kterých pull request nemluví? Nejsou v kódu tajemství? A změnily se verze providerů záměrně? Na to stačí podívat se na diff lock souboru.

**Tomáš:** A drift?

**Petra:** Naplánuj si pravidelný běh, třeba každou noc, s přepínačem detailed exitcode. Exit kód dva znamená, že realita neodpovídá kódu. Pipeline pak pošle upozornění. Tak se o ručním zásahu dozvíš ráno, a ne při příštím nasazení.

**Tomáš:** A co hotová řešení? HCP Terraform, Atlantis…

**Petra:** Těm se souhrnně říká TACOS, platformy pro běh Terraformu. HCP Terraform, Atlantis, Spacelift, env0 a další. Přidají zamykání, politiky, audit a uživatelské rozhraní. Vlastní pipeline v GitHub Actions je pro začátek úplně v pořádku a hlavně pochopíš, co ty platformy dělají za tebe.

**Tomáš:** Shrnu. Apply jen z pipeline. Kontroly a plán na pull request, po merge nový plán, schválení a apply uloženého plánu. OIDC místo klíčů. Concurrency proti souběhu. Oddělené stavy pro prostředí. A noční detekce driftu.

**Petra:** Výborně. Otázka do poslední epizody: kdybyste měli navrhnout platformu s load balancerem a několika replikami pro dvě prostředí, jaké moduly byste vytvořili a proč? Nakreslete si to. Desátá epizoda je o závěrečném projektu a cestě dál.

**Tomáš:** Na slyšenou.

---

### Poznámky k epizodě
- [GitHub Actions – OIDC](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/about-security-hardening-with-openid-connect)
- [Automate Terraform with GitHub Actions](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions)
- Obrázek: [CI/CD pipeline](../obrazky/ci-cd-pipeline.svg)
