# Ep. 04 – Providery, datové zdroje a graf závislostí

> 🎧 [Poslechnout MP3](epizody/ep04-providery-a-zavislosti.mp3) · Modul: [04 – Providery a závislosti](../moduly/04-providery-a-zavislosti/README.md) · Lab: [03](../labs/lab03-docker/README.md) · Mluví: **Petra** a **Tomáš**

---

**Tomáš:** Čtvrtá epizoda. Odpověď z minula: kontejner odkazuje na identifikátor image, a z té reference Terraform pozná, že image musí být první.

**Petra:** Přesně. A o tom je dnešní díl: providery, datové zdroje a graf.

**Tomáš:** Provider jsme už probírali. Plugin, který zná API.

**Petra:** Ano. V bloku required providers řekneš, odkud se stáhne a v jaké verzi. Třeba kreuzwerker lomeno docker ve verzi čtyři. A v bloku provider ho nastavíš, například adresu Docker démona. Jedna důležitá věc: přihlašovací údaje do kódu nepatří. Provider si je vezme z proměnných prostředí nebo v pipeline z krátkodobého tokenu.

**Tomáš:** Proč v kurzu Docker a ne rovnou cloud?

**Petra:** Protože Docker je cloud na tvém notebooku. Provider se chová úplně stejně jako ten pro AWS. Volá API, vytváří objekty a ukládá jejich identifikátory do stavu. Jen to nic nestojí a když něco rozbiješ, nikoho to nebolí. Principy jsou totožné.

**Tomáš:** Teď rozdíl mezi resource a data.

**Petra:** Resource je něco, co Terraform vlastní. Vytvoří to, mění, a když to z kódu odebereš, smaže. Data jen čte. Představ si to jako rozdíl mezi tím, že si koupíš auto, a tím, že si přečteš jízdní řád. Jízdní řád nevlastníš, jen z něj potřebuješ informaci. Typicky existující síť, kterou spravuje jiný tým, nebo nejnovější image podle filtru.

**Tomáš:** A graf závislostí?

**Petra:** Vezmi si vaření. Nemůžeš podávat omáčku, dokud ji neuvaříš. Ale zatímco se vaří těstoviny, můžeš krájet zeleninu. Terraform z referencí sestaví graf, co musí být dřív, a všechno, co na sobě nezávisí, dělá souběžně. Ve výchozím nastavení až deset věcí najednou.

**Tomáš:** A při mazání?

**Petra:** Obráceně. Nejdřív kontejner, pak síť a image. Kdyby smazal síť dřív, kontejner by visel ve vzduchu.

**Tomáš:** Kdy potřebuju depends on?

**Petra:** Skoro nikdy. Jen když závislost není vidět v datech. Třeba aplikace potřebuje, aby existovalo oprávnění, ale nikde na něj neodkazuje. Depends on je poslední možnost, protože zakrývá skutečný tok dat a dělá plán opatrnějším, než by musel být.

**Tomáš:** Co když vytvořím cyklus? Zdroj A odkazuje na B a B na A.

**Petra:** Pak Terraform skončí chybou cycle, protože neexistuje pořadí, ve kterém by to šlo vytvořit. V Opravárně je na to úloha. Obvykle pomůže vytáhnout hodnoty, které znáš předem, do lokálních hodnot a nechat závislost jen jedním směrem.

**Tomáš:** V labu tři jsem změnil titulek stránky a kontejner se nahradil. Proč?

**Petra:** Některé věci jdou přemalovat, jiné se musí postavit znovu. Barvu domu změníš za běhu, základy ne. U každého argumentu provider ve schématu určuje, jestli jde změnit na místě, nebo jestli vynutí náhradu. Kontejner v Dockeru je neměnný, takže skoro každá změna znamená nový kontejner. U virtuálního stroje v AWS můžeš změnit velikost na místě, ale změna image znamená nový stroj.

**Tomáš:** Takže před každým apply…

**Petra:** …se podíváš do plánu, co vynucuje náhradu. A pokud to opravdu nechceš, hledáš jinou cestu. O nástrojích jako create before destroy nebo prevent destroy si povíme v šesté epizodě.

**Tomáš:** Ještě více providerů téhož typu. Dva regiony.

**Petra:** Na to je alias. Nadefinuješ druhý blok provider se jménem, třeba usa, a u zdroje řekneš provider rovná se aws tečka usa. Typický příklad je certifikát pro CDN, který musí být v jednom konkrétním regionu.

**Tomáš:** Shrnu. Provider se pinuje a konfiguruje bez tajemství v kódu. Resource vlastní, data čte. Reference tvoří graf, nezávislé věci běží souběžně a maže se obráceně. Depends on jen výjimečně. A o náhradě rozhoduje schéma providera.

**Petra:** Skvělé. Otázka do příště: kde si Terraform pamatuje, že kontejner lab tři web má určitý identifikátor v Dockeru? A co by se stalo, kdyby tu informaci ztratil? Další epizoda je o stavu.

**Tomáš:** Na slyšenou.

---

### Poznámky k epizodě
- [Providers](https://developer.hashicorp.com/terraform/language/providers) · [Resource behavior](https://developer.hashicorp.com/terraform/language/resources/behavior)
- [Provider Docker](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)
