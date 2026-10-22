# Ep. 00 – Jak se v kurzu učit (a proč ne tak, jak jsme zvyklí)

> 🎧 [Poslechnout MP3](epizody/ep00-jak-se-ucit.mp3) · Modul: [00 – Příprava](../moduly/00-priprava/README.md) · Mluví: **Petra** (platformní inženýrka) a **Tomáš** (vývojář, s Terraformem začíná)

---

**Tomáš:** Ahoj, tady Tomáš a vítejte u podcastu ke kurzu Terraform od nuly k produkci. Se mnou je Petra, která infrastrukturu jako kód dělá roky. Petro, než se pustíme do Terraformu, chtěla jsi mluvit o tom, jak se učit. Není to zbytečné? Prostě si to přečtu a vyzkouším.

**Petra:** Ahoj Tomáši. Právě tohle „prostě si to přečtu“ je past. Když text čteš podruhé, připadá ti povědomý a mozek si to splete s tím, že ho umíš. Psychologové tomu říkají iluze plynulosti. Za týden zjistíš, že si z toho skoro nic nevybavíš.

**Tomáš:** To znám. Na tutoriál se dívám, kývám hlavou, a pak před prázdným editorem nevím, kde začít.

**Petra:** Přesně. Takže kurz stavíme na několika technikách, které mají v kognitivní psychologii dobrou oporu. První je vybavování, anglicky retrieval practice. Místo dalšího čtení si zkusíš odpověď vytáhnout z hlavy. Proto každá lekce začíná rozcvičkou: tři otázky z minulých modulů, bez poznámek.

**Tomáš:** A když to nevím?

**Petra:** Tak je to vlastně dobře. Snaha si vzpomenout, i neúspěšná, a pak oprava, posílí paměť víc než pasivní čtení. Velká přehledová studie Dunloskyho a kolegů z roku 2013 hodnotila deset populárních technik učení a vybavování spolu s rozloženým opakováním dopadlo nejlépe. Zvýrazňování textu a opakované čtení naopak skončily na chvostu.

**Tomáš:** Rozložené opakování, to jsou ty kartičky?

**Petra:** Ano. V repozitáři je přes devadesát kartiček pro aplikaci Anki. Pět minut denně. Algoritmus ti kartičku ukáže těsně předtím, než bys ji zapomněl. Efekt rozložení v čase je jeden z nejlépe replikovaných jevů v psychologii učení, popsaný už v devatenáctém století.

**Tomáš:** Dobře. A co ty laby? Tam je nějaká zkratka PRIMM.

**Petra:** PRIMM je postup z výuky programování: Predict, Run, Investigate, Modify, Make. Česky předpověz, spusť, prozkoumej, uprav a nakonec vytvoř něco vlastního. Nejdůležitější je to první písmeno. Než spustíš terraform plán, napíšeš si, co čekáš. Kolik zdrojů se vytvoří, co se nahradí.

**Tomáš:** Proč? Stejně to za vteřinu uvidím.

**Petra:** Protože když se předpověď nepotká s realitou, mozek zbystří. To překvapení je přesně ten okamžik, kdy se opravují mylné představy. A u Terraformu je jich spousta. Třeba že přejmenování zdroje v kódu je neškodné. Není. Uvidíš v labu čtyři.

**Tomáš:** Zní to, jako bys mě chtěla nechat chybovat.

**Petra:** Do jisté míry ano. Proto máme Opravárnu, deset rozbitých konfigurací se skutečnými chybovými hláškami. Nejdřív napíšeš hypotézu, co je špatně, a teprve pak otevíráš nápovědy. Jsou tři a každá prozradí o něco víc. Tomu se říká postupné ubírání opory.

**Tomáš:** A jak poznám, že mám lab hotový? Nerad čtu řešení.

**Petra:** A to je dobře, řešení si nečti předem. Každý lab má automatické testy. Spustíš terraform test nebo skript zkontroluj a dostaneš okamžitou zpětnou vazbu. A když si repozitář forkneš na GitHub, po každém pushi se ti v Actions ukáže tabulka splněných labů.

**Tomáš:** Ještě mě zajímá, proč podcast. Upřímně, učit se z poslechu mi nepřijde efektivní.

**Petra:** Máš pravdu, že samotný poslech není nejsilnější forma učení a výzkum podcastů ve výuce je zatím spíš omezený. Proto podcast není náhrada labu. Je to příprava. Pojmy, analogie a typické chyby uslyšíš dopředu, třeba cestou do práce, a na lekci pak nezačínáš od nuly. K tomu jsou krátká videa, kde je obraz a výklad dohromady. Kombinace slova a obrazu má v teorii multimediálního učení Richarda Mayera dobrou podporu.

**Tomáš:** A co styly učení? Já jsem prý vizuální typ.

**Petra:** Tady tě zklamu. Představa, že výuka přizpůsobená vizuálním nebo sluchovým typům funguje lépe, se v kontrolovaných studiích nepotvrdila. Pashler a kolegové to v roce 2008 shrnuli dost jednoznačně. Lepší je, když každé téma dostane víc forem, obraz, slovo i praxi, pro všechny.

**Tomáš:** Takže shrnuto: před lekcí podcast a video, na začátku rozcvička, v labu předpovídat, po lekci kartičky.

**Petra:** Přesně tak. A ještě jedna rada: učte se ve dvojicích. Kdo musí druhému vysvětlit, proč plán ukazuje nahrazení, ten to pochopí nejlíp.

**Tomáš:** Než skončíme, otázka k zamyšlení na příště. Co si myslíte, že by se stalo, kdybyste stejnou konfiguraci aplikovali dvakrát po sobě? Zkuste si odpověď napsat. V další epizodě si řekneme, proč vůbec infrastrukturu psát jako kód.

**Petra:** Mějte se a uvidíme se v labu.

---

### Poznámky k epizodě
- Dunlosky, J. a kol. (2013). Improving Students' Learning With Effective Learning Techniques. *Psychological Science in the Public Interest*, 14(1).
- Pashler, H. a kol. (2008). Learning Styles: Concepts and Evidence. *Psychological Science in the Public Interest*, 9(3).
- Mayer, R. E. (2021). *Multimedia Learning*, 3. vyd. Cambridge University Press.
- Sentance, S., Waite, J., Kallia, M. (2019). Teaching computer programming with PRIMM. *Computer Science Education*, 29(2–3).
- Podrobně: [METODIKA.md](../METODIKA.md)
