# Ep. 02 – HCL a workflow: init, plán, apply

> 🎧 [Poslechnout MP3](epizody/ep02-hcl-a-workflow.mp3) · Modul: [02 – HCL a workflow](../moduly/02-hcl-a-workflow/README.md) · Lab: [01](../labs/lab01-prvni-kroky/README.md) · Mluví: **Petra** a **Tomáš**

---

**Tomáš:** Ahoj, druhá epizoda. Petro, odpověď na otázku z minula: Terraform ví, co existuje, ze stavu. A při plánu se ještě zeptá providera, jak to vypadá doopravdy.

**Petra:** Správně. Tomu druhému kroku se říká refresh. Dnes se podíváme, jak se Terraform píše a jak vypadá každodenní práce s ním.

**Tomáš:** Jazyk se jmenuje HCL, že?

**Petra:** HashiCorp Configuration Language. Je to deklarativní jazyk z bloků. Blok má typ, třeba resource, pak dva názvy v uvozovkách, typ zdroje a tvoje lokální jméno, a ve složených závorkách argumenty. Třeba resource local file pozdrav, a uvnitř filename a content.

**Tomáš:** Na co si mám dát pozor?

**Petra:** Na tři věci. Zaprvé, pořadí bloků a souborů je jedno. Terraform načte všechny soubory s koncovkou tf v adresáři jako jeden celek. Zadruhé, reference. Když v obsahu souboru použiješ jméno z jiného zdroje, napíšeš typ, jméno a atribut, třeba random pet jméno id. A tím vznikne závislost. Terraform pozná, že jméno musí vzniknout dřív než soubor.

**Tomáš:** A zatřetí?

**Petra:** Konvence. Zdroje dávej do main tf, vstupy do variables tf, výstupy do outputs tf a verze do versions tf. Terraform to nevyžaduje, ale kolegové ti poděkují.

**Tomáš:** Teď workflow. Init, plán, apply.

**Petra:** Init připraví pracovní adresář. Stáhne providery a moduly a vytvoří soubor terraform lock hcl, kam zapíše přesné verze a kontrolní součty providerů.

**Tomáš:** Ten soubor patří do Gitu?

**Petra:** Ano, vždycky. Představ si recept, kde je napsáno nejen mouka, ale přesně která značka a šarže. Kolega pak upeče přesně stejný dort. Kdežto soubor se stavem do Gitu nepatří nikdy. Ten je spíš jako inventura skladu, a navíc v něm můžou být hesla.

**Tomáš:** Dobře. Plán.

**Petra:** Plán je moje oblíbená část Terraformu. Je to zkouška nanečisto. Terraform ti ukáže, co by udělal, ale nic neudělá. Plus znamená vytvořit. Vlnovka znamená změnit za běhu. Mínus znamená smazat. A pozor na kombinaci mínus lomeno plus.

**Tomáš:** To je co?

**Petra:** Nahrazení. Zdroj se smaže a vytvoří znovu. U souboru v labu je to jedno. U databáze to znamená ztrátu dat. V plánu u toho uvidíš poznámku forces replacement, tedy který argument náhradu vynutil.

**Tomáš:** Takže plán čtu odshora dolů?

**Petra:** Já to dělám obráceně. Nejdřív se podívám na poslední řádek, kolik se přidá, změní a smaže. Pak najdu všechna nahrazení a smazání. A až potom čtu detaily. Když v plánu, který měl jen změnit popisek, vidím jedno smazání, zbystřím.

**Tomáš:** V plánu jsem viděl text known after apply.

**Petra:** To jsou hodnoty, které zná až provider po vytvoření. Třeba identifikátor, IP adresa nebo náhodné jméno. Terraform je předem neví, tak to poctivě přizná.

**Tomáš:** A apply plán provede.

**Petra:** Ano, po potvrzení napíšeš yes. V automatizaci se plán ukládá do souboru přepínačem out a apply pak provede přesně ten uložený plán. Žádná překvapení mezi tím, co jsi schválil, a tím, co se stalo.

**Tomáš:** Ještě jsem v labu potkal fmt a validate.

**Petra:** Fmt sjednotí formátování, odsazení a zarovnání rovnítek. Validate zkontroluje syntaxi, typy a jestli atributy, na které odkazuješ, opravdu existují. Bez volání jakéhokoli API, takže je to rychlé a levné. Spouští se jako první krok v každé pipeline.

**Tomáš:** Poslední věc. Verze providerů. Viděl jsem zápis vlnovka větší než tři celá šest.

**Petra:** Pesimistický operátor. Znamená verzi tři celá šest nebo vyšší, ale pořád trojku. Nepustí tě na čtyřku, kde můžou být nekompatibilní změny. Verze pinuj vždycky, jinak ti jednoho rána nová verze providera změní chování bez varování.

**Tomáš:** Shrnu. HCL jsou bloky a reference, pořadí je jedno. Init připraví adresář, plán ukáže rozdíl, apply ho provede. V plánu hledám nejdřív nahrazení a smazání. Lock soubor do Gitu, stav nikdy.

**Petra:** Výborně. A otázka do příště. V labu jedna změníte text pozdravu. Bude to změna za běhu, nebo nahrazení? Napište si předpověď, než to spustíte. A pak se poslechněte třetí epizodu o proměnných.

**Tomáš:** Na slyšenou.

---

### Poznámky k epizodě
- [Syntax HCL](https://developer.hashicorp.com/terraform/language/syntax/configuration) · [Dependency lock file](https://developer.hashicorp.com/terraform/language/files/dependency-lock)
- Video: [Lekce 02 – Workflow a plán](../video/README.md#lekce-02)
