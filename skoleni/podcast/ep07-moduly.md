# Ep. 07 – Moduly: stavebnice, ne kopírka

> 🎧 [Poslechnout MP3](epizody/ep07-moduly.mp3) · Modul: [07 – Moduly](../moduly/07-moduly/README.md) · Lab: [06](../labs/lab06-moduly/README.md) · Mluví: **Petra** a **Tomáš**

---

**Tomáš:** Sedmá epizoda. Odpověď z minula je jasná: modul.

**Petra:** Správně. A dobrá zpráva je, že moduly už vlastně znáš. Každý adresář se soubory tf je modul. Ten, ve kterém spouštíš terraform, je kořenový. A ostatní, které volá blokem module, jsou podřízené.

**Tomáš:** Takže modul je funkce.

**Petra:** Přesně tak. Vstupy jsou proměnné, tělo jsou zdroje a návratové hodnoty jsou výstupy. Volající vidí jen vstupy a výstupy. Vnitřek můžeš předělat, a dokud držíš rozhraní, nikoho to nerozbije. Tomu se říká zapouzdření.

**Tomáš:** V labu šest bylo rozhraní hotové a já psal jen vnitřek.

**Petra:** Schválně. Nejdřív se domluvíš, co modul přijímá a co vrací, a máš na to testy. Pak píšeš implementaci, dokud testy neprojdou. Ve světě software se tomu říká test first a u modulů to funguje skvěle.

**Tomáš:** Odkud se moduly berou?

**Petra:** Z lokální složky, z Terraform Registry, z Gitu nebo z privátní registry. A tady je první pravidlo: vždycky pevná verze. U registry napíšeš version, u Gitu ref s tagem. Nikdy ne větev main. Větev se mění, takže by stejný kód dnes a zítra nasadil něco jiného.

**Tomáš:** Sémantické verzování?

**Petra:** Ano. Hlavní číslo zvyšuješ, když měníš rozhraní nekompatibilně. Třeba když přejmenuješ vstup. Uživatelé modulu pak vědí, že musí číst changelog.

**Tomáš:** Jak je to s providery uvnitř modulu?

**Petra:** Modul říká, jaké providery potřebuje, v required providers, ale sám je nekonfiguruje. Konfiguraci dostane od kořenového modulu. Kdyby si modul provider nakonfiguroval sám, nešel by volat s for each ani count a nešel by bezpečně odstranit. V Opravárně je na to úloha číslo deset.

**Tomáš:** Co dělá modul dobrým?

**Petra:** Řeší jednu věc na úrovni, které rozumí uživatel. Webová aplikace, síť, databáze. Má málo povinných vstupů a rozumné výchozí hodnoty. Každý vstup má typ, popis a validaci. Má výstupy pro všechno, co bude navazující kód potřebovat. A má README s příkladem a testy.

**Tomáš:** A co dělá modul špatným?

**Petra:** Nejčastěji je to modul, který jen obalí jeden zdroj a přepošle všech jeho padesát argumentů. Uživatel se musí naučit totéž co u zdroje a nedostane nic navíc. Tomu se říká děravá abstrakce. Modul s jedním zdrojem má smysl jen tehdy, když přidává hodnotu, třeba firemní bezpečné výchozí nastavení.

**Tomáš:** A cizí moduly z registry?

**Petra:** Jsou skvělé na start, komunita má ověřené vzory. Ale zacházej s nimi jako s jakoukoli závislostí. Pinuj verzi, přečti si kód, než ho nasadíš, a sleduj změny. Jsou to cizí lidé, kteří ti budou vytvářet infrastrukturu.

**Tomáš:** Jak se moduly skládají?

**Petra:** Doporučuju malé moduly a tenké kořeny. Pro každé prostředí máš malý kořenový modul, který nastaví providera a stav a zavolá moduly pro síť, databázi a aplikaci. Hluboké vnořování, kdy modul volá modul a ten zase modul, se špatně ladí.

**Tomáš:** Co když v modulu přejmenuju zdroj?

**Petra:** Moved funguje i uvnitř modulů. Přidáš ho do modulu a všichni jeho uživatelé dostanou přejmenování bez výpadku při dalším apply. To je velký rozdíl oproti ručním příkazům ve stavu, které by musel udělat každý uživatel zvlášť.

**Tomáš:** Shrnu. Modul je funkce se vstupy a výstupy. Verze pinuju tagem. Providery konfiguruje jen kořen. Dobrý modul je malý, popsaný, otestovaný a přidává hodnotu. Skládám malé moduly v tenkých kořenech.

**Petra:** Výborně. Otázka do příště: jak byste ověřili, že váš modul pořád funguje, když ho za půl roku někdo upraví? A jak poznáte, že vaše testy za něco stojí? Osmá epizoda je o testování.

**Tomáš:** Na slyšenou.

---

### Poznámky k epizodě
- [Modules](https://developer.hashicorp.com/terraform/language/modules) · [Module composition](https://developer.hashicorp.com/terraform/language/modules/develop/composition)
- Obrázek: [Kompozice modulů](../obrazky/moduly-kompozice.svg)
