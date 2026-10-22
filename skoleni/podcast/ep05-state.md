# Ep. 05 – State: paměť Terraformu

> 🎧 [Poslechnout MP3](epizody/ep05-state.mp3) · Modul: [05 – State](../moduly/05-state/README.md) · Lab: [04](../labs/lab04-state/README.md) · Mluví: **Petra** a **Tomáš**

---

**Tomáš:** Pátá epizoda, a podle Petry nejdůležitější. Odpověď z minula: identifikátor kontejneru je ve stavu. A kdyby se ztratil, Terraform by nevěděl, že kontejner existuje, a zkusil by vytvořit nový.

**Petra:** A narazil by na konflikt jména, nebo by v cloudu vznikla kopie a za tu původní bys dál platil, aniž by o ní kdokoli věděl. Proto je stav tak důležitý.

**Tomáš:** Co přesně v něm je?

**Petra:** Je to dokument ve formátu JSON. Pro každý zdroj z kódu obsahuje identifikátor skutečného objektu, jeho poslední známé atributy a závislosti. Je to jako evidence majetku ve firmě. Kód říká, co chceš mít, evidence říká, co máš a kde to je.

**Tomáš:** A realita?

**Petra:** Realita je sklad. Při plánu Terraform projde evidenci a u každé položky se providera zeptá, jestli ve skladu opravdu je a jak vypadá. Pak porovná s kódem.

**Tomáš:** Kde má stav být?

**Petra:** Na učení stačí lokální soubor. V týmu nikdy. Zkus si představit, že s kolegou upravujete stejný dokument a posíláte si ho e-mailem. Dřív nebo později jeden přepíše změny druhého. Proto se stav ukládá do vzdáleného úložiště, třeba S3, Azure Storage, Google Cloud Storage nebo HCP Terraform. A to úložiště musí umět zamykání.

**Tomáš:** Zamykání?

**Petra:** Cedulka obsazeno na dveřích. Když kolega spustí apply, stav se zamkne a ty počkáš. V labu čtyři si to vyzkoušíš s databází PostgreSQL. V jednom terminálu necháš apply čekat na potvrzení a ve druhém uvidíš chybu, že zámek drží někdo jiný, i s tím, kdo a od kdy.

**Tomáš:** Co dalšího má backend umět?

**Petra:** Verzování, abys se mohl vrátit k předchozí verzi stavu. Šifrování, protože ve stavu bývají hesla. A přístup jen pro pipeline a pár lidí. A ještě jedna rada: dělej menší stavy. Jeden pro každé prostředí a oblast. Když se něco pokazí, dopad je menší a plány jsou rychlejší.

**Tomáš:** Teď drift. To slovo mi pořád uniká.

**Petra:** Drift je, když se realita změní mimo Terraform. Někdo něco upraví v konzoli, smaže kontejner, automatika zvětší disk. Při dalším plánu Terraform rozdíl uvidí a navrhne ho vrátit podle kódu.

**Tomáš:** A to je vždycky dobře?

**Petra:** Ne vždycky. Když kolega zvětšil disk databáze během incidentu, protože docházelo místo, nechceš ho zmenšit zpátky. Pak změnu přijmeš: upravíš kód. Nebo pokud se nějaký atribut legitimně mění sám, třeba počet instancí při automatickém škálování, řekneš Terraformu, ať ho ignoruje. A když se drift opakuje, je to signál, že lidé mají v konzoli příliš velká práva.

**Tomáš:** V labu jsem importoval ručně vytvořenou síť.

**Petra:** Blok import, od verze jedna pět. Řekneš, na kterou adresu v kódu má objekt patřit a jaký má identifikátor. Terraform ti dokonce umí vygenerovat konfiguraci. Ale ta je jen koncept. Musíš ji vyčistit a cílem je plán, který říká jen import, nic nepřidává a nic nemaže.

**Tomáš:** U kontejneru mi to nevyšlo, plán chtěl kontejner hned nahradit.

**Petra:** To je dobré poučení. Import není vždycky bezeztrátový. Provider Docker u kontejneru některé vlastnosti zpětně nenačte, takže si myslí, že kontejner neodpovídá kódu. Proto plán importu vždycky čti, než ho potvrdíš.

**Tomáš:** A moved a removed?

**Petra:** Moved použiješ, když v kódu přejmenuješ zdroj. Bez něj by Terraform starý zdroj smazal a vytvořil nový, protože pro něj je to jiná adresa. S moved jen přepíše evidenci. Removed je opak importu: Terraform přestane zdroj spravovat, ale nesmaže ho. Třeba když volume předáváš jinému týmu.

**Tomáš:** Dřív se na to používaly příkazy terraform state.

**Petra:** A pořád fungují. Ale bloky v kódu jsou lepší: projdou review, uvidíš je v plánu, aplikují se stejně ve všech prostředích a fungují i pro uživatele tvých modulů. Ruční zásah do stavu nemá v Gitu žádnou stopu.

**Tomáš:** Shrnu. Stav je evidence, co Terraform spravuje. V týmu vzdáleně, se zamykáním, verzováním a šifrováním. Drift buď opravím, nebo vědomě přijmu. Import, moved a removed píšu do kódu.

**Petra:** Výborně. Otázka do příště: máte tři kontejnery vytvořené pomocí count ze seznamu web, api a docs. Odeberete api. Kolik kontejnerů se změní? Napište si předpověď. Šestá epizoda vám ukáže, proč je to záludnější, než vypadá.

**Tomáš:** Na slyšenou.

---

### Poznámky k epizodě
- [State](https://developer.hashicorp.com/terraform/language/state) · [Import](https://developer.hashicorp.com/terraform/language/import)
- Video: [Lekce 05 – State a drift](../video/README.md#lekce-05)
