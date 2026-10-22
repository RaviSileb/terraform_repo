# Ep. 08 – Testování infrastruktury a cvičný požár

> 🎧 [Poslechnout MP3](epizody/ep08-testovani.mp3) · Modul: [08 – Testování](../moduly/08-testovani/README.md) · Lab: [07](../labs/lab07-testovani/README.md) · Mluví: **Petra** a **Tomáš**

---

**Tomáš:** Osmá epizoda, testování. Odpověď z minula: modul ověřím testy. Ale jak poznat, že testy za něco stojí, nevím.

**Petra:** To je otázka, na kterou dnes odpovíme. Začnu ale obrázkem. Testovací pyramida. Dole jsou levné a rychlé kontroly, které spouštíš při každém commitu. Nahoře drahé a pomalé, ale nejvěrohodnější.

**Tomáš:** Co je úplně dole?

**Petra:** Formátování a validace. Terraform fmt a validate. Stojí vteřiny a zachytí překlepy, špatné typy a odkazy na neexistující atributy. O patro výš je lint, třeba TF lint, který zná pravidla konkrétních cloudů a pozná třeba neexistující typ virtuálního stroje. Vedle něj bezpečnostní skenery jako Trivy nebo Checkov, které najdou veřejně přístupné úložiště nebo nešifrovaný disk.

**Tomáš:** A pak terraform test.

**Petra:** Ano, od verze jedna šest. Píšeš soubory s koncovkou tftest hcl. Každý blok run spustí plán nebo apply a pak ověří podmínky v blocích assert. Výchozí je apply, takže pokud nechceš vytvářet skutečné zdroje, napíšeš command rovná se plan.

**Tomáš:** V labu tři byl mock provider.

**Petra:** Mock je letecký simulátor. Pilot si v něm natrénuje postupy, aniž by riskoval letadlo. Mock provider nevolá žádné API, hodnoty jako identifikátory si vymyslí. Takže testy běží za vteřinu, bez cloudu a bez peněz. Ověříš logiku konfigurace: jména, počty, porty, podmínky.

**Tomáš:** A co neověříš?

**Petra:** Skutečné chování API. Mock ti neřekne, že daný typ stroje v regionu není nebo že ti chybí oprávnění. Na to jsou integrační testy, které opravdu nasadí infrastrukturu, ověří ji a zase ji smažou. V labu tři takový test nasadí kontejner a zavolá ho přes HTTP. Jsou pomalejší a v cloudu stojí peníze, takže se spouští cíleně, třeba před vydáním nové verze modulu.

**Tomáš:** Negativní testy jsem psal přes expect failures.

**Petra:** To je podle mě nejpodceňovanější část. Testovat, že správný vstup funguje, je půlka práce. Druhá půlka je ověřit, že špatný vstup selže. Prostředí staging musí být odmítnuto. Dvě repliky v produkci musí být vynucené. Expect failures řekne: tento běh projde, jen když validace selže.

**Tomáš:** A teď ta slíbená otázka. Jak poznám, že testy jsou dobré?

**Petra:** Pokrytí řádků u Terraformu moc nedává smysl. Použijeme mutační testování. Znáš cvičný požární poplach? Hasiči schválně zapálí malý oheň, aby viděli, jestli hlásiče zareagují. My do modulu schválně vneseme malou chybu, třeba změníme zkratku prostředí, a spustíme testy. Pokud selžou, mutant je zabitý. Pokud projdou, máš díru.

**Tomáš:** V labu sedm na to je skript.

**Petra:** Ano, vnese dvanáct mutantů a spočítá skóre. Cíl je aspoň osmdesát procent. A přiznám se, při přípravě labu mi jeden mutant přežil i v mých vlastních testech. Testovala jsem neplatný název projektu, který byl zároveň příliš dlouhý. Takže selhal kvůli délce, ne kvůli znakům, a mutant ve znacích prošel.

**Tomáš:** Takže test se dvěma chybami najednou je slabý.

**Petra:** Přesně. Testuj hraniční hodnoty a vždy jen jednu chybu. Rozsah jedna až devadesát devět: testuj jedničku, devadesát devět a sto.

**Tomáš:** Na vrcholu pyramidy byly check bloky.

**Petra:** Check blok je kouřový hlásič. Při každém plánu a apply ověří, třeba že web odpovídá, a když ne, vypíše varování. Ale nasazení nezastaví. To je rozdíl oproti postcondition, která apply zastaví chybou. Check se hodí na průběžné hlídání běžícího systému.

**Tomáš:** Shrnu. Dole fmt, validate, lint a skenery. Uprostřed terraform test s plánem a mocky. Nahoře integrační testy a check bloky. Negativní testy přes expect failures. A kvalitu testů měřím mutacemi.

**Petra:** Výborně. Otázka do příště: proč je riskantní, když kolega spustí terraform apply do produkce ze svého notebooku, i když je opatrný? Devátá epizoda je o týmové práci a pipeline.

**Tomáš:** Na slyšenou.

---

### Poznámky k epizodě
- [Terraform tests](https://developer.hashicorp.com/terraform/language/tests) · [Mocks](https://developer.hashicorp.com/terraform/language/tests/mocking) · [Checks](https://developer.hashicorp.com/terraform/language/checks)
- Jia, Y., Harman, M. (2011). An Analysis and Survey of the Development of Mutation Testing. *IEEE Transactions on Software Engineering*, 37(5).
