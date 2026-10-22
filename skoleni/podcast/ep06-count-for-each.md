# Ep. 06 – count, for_each a past jménem index

> 🎧 [Poslechnout MP3](epizody/ep06-count-for-each.mp3) · Modul: [06 – Meta-argumenty](../moduly/06-meta-argumenty/README.md) · Lab: [05](../labs/lab05-for-each/README.md) · Mluví: **Petra** a **Tomáš**

---

**Tomáš:** Šestá epizoda. Moje předpověď z minula: když z web, api a docs odeberu api, zmizí jeden kontejner.

**Petra:** To je nejčastější odpověď. A u count je špatně. Plán řekne: jeden přidat a dva smazat.

**Tomáš:** Dva smazat? Vždyť jsem odebral jeden.

**Petra:** Count adresuje instance pořadovým číslem. Web je nula, api jedna, docs dva. Když api zmizí, docs se posune na místo jedna. Terraform vidí, že na pozici jedna má teď být docs místo api, takže ho nahradí. A pozice dva už v seznamu není, takže ji smaže. Kontejner docs, který jsi vůbec neměnil, se zničí a vytvoří znovu.

**Tomáš:** To je jako divadlo, kde sedíš podle čísla sedadla.

**Petra:** Přesně. Když jeden divák odejde a všichni se posunou o místo, uvaděčka musí přesadit půl řady. For each funguje jako jmenovky na sedadlech. Divák odejde, jeho sedadlo se uvolní a ostatní sedí, kde seděli.

**Tomáš:** Takže count nikdy?

**Petra:** Count má dvě dobrá použití. Zaprvé podmíněný zdroj: count rovná se zapnuto, otazník, jedna, dvojtečka, nula. Buď existuje, nebo ne. Zadruhé identické a zaměnitelné kusy, kde je ti jedno, který je který. Třeba repliky backendu v závěrečném projektu. Pro všechno, co má jméno nebo identitu, používej for each.

**Tomáš:** A co když už mám count v produkci a chci přejít na for each?

**Petra:** Pak přijdou na řadu bloky moved, které znáš z minula. Řekneš, že pozice nula se teď jmenuje web, pozice jedna api a tak dále. Plán pak ukáže tři přesuny a nula změn. Žádný výpadek. V labu pět si to projdeš krok za krokem.

**Tomáš:** Narazil jsem na chybu, že klíče for each nejsou známé.

**Petra:** To je klasika. Klíče for each, stejně jako počet u count, musí Terraform znát už při plánu, protože z nich skládá adresy zdrojů. Když jako klíče použiješ něco, co vznikne až při apply, třeba náhodné jméno, plán to odmítne. Klíče odvozuj ze vstupů a konstant, a hodnoty, které vznikají až při apply, dávej dovnitř zdroje.

**Tomáš:** Dál je tu lifecycle. Co z něj používáš?

**Petra:** Prevent destroy u věcí s daty. Když by plán chtěl databázi smazat, skončí chybou. Ale pozor, chrání jen tak dlouho, dokud ten blok v kódu je. Create before destroy pro věci, kde nechceš výpadek: nejdřív se postaví nová instance a pak se zruší stará. Nefunguje ale, když má zdroj pevné jméno nebo port, protože na chvíli musí existovat obě verze.

**Tomáš:** A ignore changes?

**Petra:** Pro atributy, které legitimně mění někdo jiný, třeba automatické škálování. Ale střídmě. Každá ignorovaná vlastnost je drift, o kterém se nedozvíš.

**Tomáš:** V labu jsem psal i precondition.

**Petra:** Podmínky jsou skvělé na předpoklady. V labu hlídají, aby se porty replik nepřekrývaly s jinou službou. Všimni si ale, že se chyba vypíše pro každou instanci zvlášť. Pokud kontroluješ jen vstupy, je lepší validace proměnné. Proběhne dřív a vypíše se jednou.

**Tomáš:** Poslední: dynamic.

**Petra:** Dynamic generuje opakované vnořené bloky, třeba štítky nebo pravidla firewallu, z mapy či seznamu. Je to užitečné, ale když máš v jednom zdroji tři vnořené dynamic bloky, kód se špatně čte. Pak je čas zvážit modul.

**Tomáš:** A ještě ten zvláštní zápis merge se třemi tečkami.

**Petra:** To je zploštění. Máš mapu služeb a každá má několik replik. Vnější for vrátí seznam map, a tři tečky ten seznam rozbalí do argumentů funkce merge, takže vznikne jedna velká mapa instancí. Vypadá to krypticky, ale je to vzor, který budeš potkávat pořád. Doporučuju si ho rozebrat v terraform console.

**Tomáš:** Shrnu. Count adresuje indexem a při odebírání ze středu posouvá. For each adresuje klíčem. Klíče musí být známé při plánu. Přechod mezi nimi bez výpadku řeší moved. Lifecycle a podmínky používám vědomě.

**Petra:** Výborně. Otázka do příště: chcete stejný webový kontejner pro pět týmů a dvě prostředí. Kopírovat kód desetkrát asi nebudete. Co uděláte? Sedmá epizoda je o modulech.

**Tomáš:** Na slyšenou.

---

### Poznámky k epizodě
- [count](https://developer.hashicorp.com/terraform/language/meta-arguments/count) · [for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each) · [lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
- Obrázek: [count vs. for_each](../obrazky/count-vs-for-each.svg)
