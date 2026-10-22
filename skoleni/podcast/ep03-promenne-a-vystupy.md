# Ep. 03 – Proměnné, výstupy a mýtus jménem sensitive

> 🎧 [Poslechnout MP3](epizody/ep03-promenne-a-vystupy.mp3) · Modul: [03 – Proměnné a výstupy](../moduly/03-promenne-a-vystupy/README.md) · Lab: [02](../labs/lab02-promenne/README.md) · Mluví: **Petra** a **Tomáš**

---

**Tomáš:** Třetí epizoda. Petro, předpověď z minula: změna textu pozdravu bude změna za běhu.

**Petra:** A realita?

**Tomáš:** Nahrazení. Soubor se smazal a vytvořil znovu.

**Petra:** Přesně kvůli takovým momentům předpovídáme. U souboru provider nahrazuje celý objekt, takže změna obsahu znamená náhradu. Dobře, dnes proměnné.

**Tomáš:** Proč vůbec? Můžu hodnoty napsat rovnou do kódu.

**Petra:** Můžeš, dokud máš jedno prostředí. Jakmile chceš dev a produkci ze stejného kódu, potřebuješ vstupy. Představ si modul jako funkci. Proměnné jsou parametry, lokální hodnoty jsou pomocné proměnné uvnitř funkce a výstupy jsou to, co funkce vrací.

**Tomáš:** Co by měla mít dobrá proměnná?

**Petra:** Popis, typ, případně výchozí hodnotu a validaci. Typ je důležitější, než se zdá. Když řekneš, že port je číslo, a někdo pošle slovo osm, Terraform chybu zachytí hned na vstupu. Ne až hluboko v konfiguraci, kde by byla hláška nesrozumitelná.

**Tomáš:** A validace?

**Petra:** Validace je vyhazovač u dveří. Podmínka, která musí platit, jinak Terraform skončí s tvojí chybovou hláškou. Třeba prostředí musí být dev, test nebo prod. Od verze jedna devět navíc může validace odkazovat na jinou proměnnou. Takže umíš říct: v produkci musí běžet aspoň dvě repliky.

**Tomáš:** To jsem v labu potkal. Soubor prod tfvars měl jednu repliku a plán neprošel.

**Petra:** Přesně tak, a to je nejlevnější místo, kde chybu chytit. Ještě před tím, než se cokoli naplánuje.

**Tomáš:** Odkud se hodnoty berou? Je jich víc zdrojů.

**Petra:** Pořadí od nejslabšího: výchozí hodnota v bloku variable, pak proměnná prostředí začínající TF podtržítko VAR, pak soubor terraform tfvars, pak soubory auto tfvars a nakonec přepínače na příkazové řádce. Co přijde později, vyhrává.

**Tomáš:** A lokální hodnoty?

**Petra:** Pro mezivýpočty. Třeba celé jméno aplikace složené z názvu a prostředí. Napíšeš ho jednou v locals a používáš všude. Méně opakování, méně překlepů.

**Tomáš:** Teď ta slibovaná citlivá data. Když dám proměnné sensitive true, je heslo v bezpečí, ne?

**Petra:** To je nejčastější mýtus, který slýchám. Sensitive je závěs na okně. Ve výpisu plánu uvidíš místo hesla nápis sensitive value. Ale ve stavu, v tom souboru tfstate, je heslo dál v čitelné podobě.

**Tomáš:** Vážně?

**Petra:** Vyzkoušíš si to v labu dvě. Spustíš grep na slovo heslo ve stavu a najdeš ho. Proto se stav ukládá šifrovaně a přístup k němu má jen pár lidí a pipeline.

**Tomáš:** Dá se tomu vyhnout úplně?

**Petra:** Od verze jedna deset existují ephemeral hodnoty. Proměnná s ephemeral true existuje jen během běhu a do stavu ani plánu se neuloží. A od verze jedna jedenáct jsou write only argumenty. Provider od tebe heslo přijme, nastaví ho třeba databázi, ale do stavu si ho nezapíše. Musí to ale podporovat konkrétní provider a zdroj.

**Tomáš:** A když to nepodporuje?

**Petra:** Pak platí staré pravidlo: dokud tajemství prochází běžným argumentem, je ve stavu. A stav chraň jako tajemství.

**Tomáš:** Ještě výrazy. Viděl jsem for uvnitř hranatých závorek.

**Petra:** Výrazy for jsou jako list comprehension v Pythonu. Projdeš seznam a vytvoříš nový seznam nebo mapu. Třeba z portů uděláš řádky listen. Na hraní doporučuju terraform console. Napíšeš výraz a hned vidíš výsledek. Pro šablony konfiguračních souborů je funkce templatefile, která umí cykly i podmínky.

**Tomáš:** Shrnu. Proměnné jsou vstupy s typem a validací, locals mezivýpočty, outputy výstupy. Pořadí přednosti končí příkazovou řádkou. Sensitive jen skrývá výpis. Ephemeral a write only drží tajemství mimo stav.

**Petra:** Výborně. A otázka do příště: když Terraform potřebuje vytvořit kontejner z image, jak pozná, že image musí stáhnout dřív? Napište si odpověď a pusťte si čtvrtou epizodu o providerech a závislostech.

**Tomáš:** Na slyšenou.

---

### Poznámky k epizodě
- [Input variables](https://developer.hashicorp.com/terraform/language/values/variables) · [Ephemeral values in Terraform](https://www.hashicorp.com/blog/ephemeral-values-in-terraform) · [Write-only arguments](https://developer.hashicorp.com/terraform/language/resources/ephemeral/write-only)
