# Ep. 01 – Proč infrastruktura jako kód

> 🎧 [Poslechnout MP3](epizody/ep01-proc-infrastruktura-jako-kod.mp3) · Modul: [01 – Proč IaC](../moduly/01-proc-iac/README.md) · Mluví: **Petra** a **Tomáš**

---

**Tomáš:** Vítejte u první epizody. Petro, začnu otázkou z minula. Co se stane, když stejnou konfiguraci aplikuju dvakrát?

**Petra:** U Terraformu nic. Podruhé ti řekne, že žádné změny nejsou potřeba. Tomu se říká idempotence a je to jeden z hlavních důvodů, proč infrastrukturu píšeme jako kód. Ale vezmu to od začátku příběhem.

**Tomáš:** Sem s ním.

**Petra:** Pátek, šest večer. Aplikace v produkci přestane přijímat platby. Po hodině hledání zjistíme, že někdo ve středu ručně v konzoli upravil pravidlo firewallu. Kvůli testu. A zapomněl to vrátit. Nikdo nevěděl kdo, kdy ani proč, protože to nikde nebylo zapsané.

**Tomáš:** To zní jako běžný provoz.

**Petra:** Bohužel ano. A teď si představ, že firewall je popsaný v textovém souboru v Gitu. Každá změna prochází pull requestem, kolega se na ni podívá, a historie ti řekne, kdo ji udělal a s jakým zdůvodněním. To je infrastruktura jako kód.

**Tomáš:** Takže hlavní přínos je audit?

**Petra:** Audit je jeden. Další je opakovatelnost. Když umíš prostředí vytvořit z kódu, umíš ho vytvořit znovu. Pro test, pro nového zákazníka, po havárii. A třetí je konzistence. Ručně udržovaná prostředí se postupně rozcházejí, testovací server je trochu jiný než produkční a nikdo neví proč. Tomu se říká sněhová vločka. Každá je originál, a to u serverů nechceš.

**Tomáš:** Dobře, ale skripty v bashi jsou taky kód. Proč Terraform?

**Petra:** Skvělá otázka. Skript je imperativní, popisuje kroky. Vytvoř síť, spusť tři kontejnery. Co když síť už existuje? Co když běží dva kontejnery ze tří? Každý takový případ musíš ve skriptu ošetřit. Terraform je deklarativní. Napíšeš, jaký stav chceš, a on si spočítá, co udělat.

**Tomáš:** Jako navigace v autě?

**Petra:** Přesně jako navigace. Řekneš cíl, ne každé odbočení. A když sjedeš z trasy, navigace přepočítá cestu. Terraform taky porovná, co chceš, s tím, co existuje, a naplánuje rozdíl.

**Tomáš:** A ta idempotence?

**Petra:** Představ si tlačítko ve výtahu. Zmáčkneš pětku jednou, nebo desetkrát, výtah stejně jede do pátého patra. Ne do padesátého. Deklarativní přístup se chová stejně. Proto je bezpečné spustit apply znovu.

**Tomáš:** Jak to uvnitř funguje?

**Petra:** Terraform má dvě hlavní části. Jádro, Terraform Core, načte tvoje soubory, sestaví graf závislostí a spočítá plán. Ale samo neumí mluvit s žádným cloudem. Na to jsou providery, pluginy. Provider pro AWS ví, jak vytvořit virtuální stroj, provider pro Docker umí kontejnery. V registry jich jsou tisíce, od velkých cloudů po GitHub nebo DNS.

**Tomáš:** Takže Core je dirigent a providery muzikanti.

**Petra:** To se mi líbí. A třetí důležitá věc je stav, state. Terraform si v něm pamatuje, které skutečné objekty patří ke kterým řádkům tvého kódu. Bez něj by nevěděl, co spravuje. O stavu bude celá pátá epizoda, protože tam vzniká nejvíc problémů.

**Tomáš:** Slyšel jsem, že kolem Terraformu byl nějaký rozruch s licencí.

**Petra:** Ano. V roce dvacet dvacet tři změnil HashiCorp licenci Terraformu z otevřené licence MPL na Business Source License. Komunita na to reagovala forkem jménem OpenTofu, který spravuje Linux Foundation. A v roce dvacet dvacet pět HashiCorp koupilo IBM. Pro běžné použití, kdy si spravuješ vlastní infrastrukturu, se v praxi skoro nic nemění. Ale pokud by tvoje firma chtěla Terraform nabízet jako službu, je dobré si licenci nechat posoudit právníkem.

**Tomáš:** A co se v kurzu naučím, platí i pro OpenTofu?

**Petra:** Základ ano. Jazyk i postup jsou stejné. V nejnovějších funkcích se projekty postupně rozcházejí, takže u nich vždycky kontroluj dokumentaci.

**Tomáš:** Kdy Terraform nepoužívat?

**Petra:** Na konfiguraci uvnitř operačního systému jsou lepší nástroje jako Ansible nebo hotové image. Na objekty, které žijí pár sekund, třeba pody v Kubernetes, je orchestrátor. A na data aplikací, uživatele v databázi a podobně, Terraform taky není. Spravuje infrastrukturu, ne její obsah.

**Tomáš:** Shrnu to. Infrastruktura jako kód dává audit, opakovatelnost a konzistenci. Terraform je deklarativní a idempotentní. Core plánuje, providery mluví s API a stav páruje kód s realitou.

**Petra:** Výborně. A otázka k zamyšlení do příště: když Terraform porovnává kód se skutečností, kde podle vás bere informaci o tom, co už existuje? Napište si odpověď. V další epizodě se podíváme na jazyk HCL a na workflow init, plán, apply.

**Tomáš:** Díky a na slyšenou.

---

### Poznámky k epizodě
- Forsgren, N., Humble, J., Kim, G. (2018). *Accelerate.* IT Revolution.
- Morris, K. (2020). *Infrastructure as Code*, 2. vyd. O'Reilly.
- [OpenTofu](https://opentofu.org) · [HashiCorp – licence BSL](https://www.hashicorp.com/bsl)
