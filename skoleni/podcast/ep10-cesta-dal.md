# Ep. 10 – Závěrečný projekt a cesta dál

> 🎧 [Poslechnout MP3](epizody/ep10-cesta-dal.mp3) · Modul: [10 – Závěrečný projekt](../moduly/10-zaverecny-projekt/README.md) · Lab: [Capstone](../labs/capstone/README.md) · Mluví: **Petra** a **Tomáš**

---

**Tomáš:** Poslední epizoda. Petro, nakreslil jsem si platformu z minulé otázky. Dva moduly: backend s replikami a proxy. A pro každé prostředí malý kořenový modul.

**Petra:** To je přesně zadání závěrečného projektu. Reverse proxy nginx, která rozkládá požadavky mezi repliky malé aplikace whoami. Ta v odpovědi vrací jméno kontejneru, takže na vlastní oči uvidíš, že odpovídají různé repliky. Dev má dvě repliky, produkce tři, každé prostředí vlastní síť a vlastní stav.

**Tomáš:** Count, nebo for each pro repliky?

**Petra:** Tady je count na místě. Repliky jsou identické a zaměnitelné. Je ti jedno, jestli zmizí ta třetí, nebo druhá. To je jedno z rozhodnutí, které budeš v projektu obhajovat.

**Tomáš:** Na co si dát pozor?

**Petra:** Nginx při startu překládá jména backendů. Když proxy vznikne dřív než repliky, spadne s chybou, že nenašel hostitele. Řešení znáš: předej do proxy výstup modulu backend se jmény kontejnerů. Vznikne implicitní závislost a Terraform vytvoří backendy dřív.

**Tomáš:** Jak poznám, že je hotovo?

**Petra:** Je k tomu akceptační test. Nasadí prostředí, zavolá endpoint zdraví a pošle dvanáct požadavků. Všechny musí vrátit kód dvě stě a musí odpovědět všechny repliky. K tomu hodnoticí rubrika: moduly, testy, validace, CI a dokumentace.

**Tomáš:** A forma?

**Petra:** Ve dvojicích, párové programování. Jeden píše, druhý čte, kontroluje a myslí dopředu. Po pětadvaceti minutách se vyměníte. Na konci si dvojice navzájem udělají code review přes pull request, podle checklistu z minulé epizody.

**Tomáš:** Kurz končí. Co dál?

**Petra:** Zaprvé reálný cloud. V repozitáři jsou ukázky pro AWS, Azure, Google Cloud, DigitalOcean nebo Oracle Cloud. Teď už jim budeš rozumět. Ale nastav si rozpočet a upozornění, používej bezplatné úrovně a po cvičení vždycky destroy. Cloud účtuje i za věci, na které jsi zapomněl.

**Tomáš:** Zadruhé?

**Petra:** Pokročilá témata. Politiky jako kód, třeba Open Policy Agent. Odhad nákladů z plánu. Tajemství přes ephemeral zdroje a Vault. Orchestrace víc stavů, třeba Terragrunt nebo Stacks v HCP Terraform. A pokud tě láká Go, napiš si vlastní provider. I na to je v repozitáři ukázka.

**Tomáš:** Certifikace má smysl?

**Petra:** HashiCorp Certified Terraform Associate pokrývá většinu toho, co jsme probrali. Pro někoho je to dobrá motivace a strukturovaný cíl. Aktuální osnovu najdeš na webu HashiCorpu. Ale praxe je víc než certifikát.

**Tomáš:** A poslední rada?

**Petra:** Pokračuj s kartičkami ještě pár týdnů. Rozložené opakování má největší efekt právě v delším horizontu. A při každém plánu si nejdřív napiš, co čekáš. Ten zvyk ti zůstane i v práci a ušetří ti nejeden pátek večer.

**Tomáš:** Takže shrnutí celého kurzu v jedné větě?

**Petra:** Popiš, co chceš, nech Terraform spočítat rozdíl, přečti plán dřív, než napíšeš yes, a chraň stav.

**Tomáš:** Díky, Petro. A díky vám všem, že jste poslouchali. Hodně štěstí v závěrečném projektu.

**Petra:** Mějte se a ať jsou vaše plány vždycky bez překvapení.

---

### Poznámky k epizodě
- Zadání: [Závěrečný projekt](../labs/capstone/README.md)
- Cepeda, N. J. a kol. (2006). Distributed practice in verbal recall tasks. *Psychological Bulletin*, 132(3).
- Hannay, J. E. a kol. (2009). The effectiveness of pair programming: A meta-analysis. *Information and Software Technology*, 51(7).
