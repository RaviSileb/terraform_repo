#!/usr/bin/env python3
"""Mutační testování testů labu 07.

Do kopie modulu vnese vždy jednu záměrnou chybu (mutant) a spustí vaše testy.
Dobré testy mutanta „zabijí“ (selžou). Mutant, který testy přežije, ukazuje
chování, které vaše testy neověřují.

Použití:  python3 mutace.py [adresář]   (výchozí: start)
"""
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

MUTANTI = [
    ("main.tf", 'prod = "p"', 'prod = "x"', "zkratka prostředí prod"),
    ("main.tf", 'test = "t"', 'test = "d"', "zkratka prostředí test"),
    ("main.tf", 'format("%02d", var.instance)', 'format("%d", var.instance)', "doplnění čísla instance nulou"),
    ("main.tf", "lower(join(", "(join(", "převod názvu na malá písmena"),
    ("main.tf", 'var.prostredi == "prod"', 'var.prostredi != "prod"', "rozpoznání produkce / kritičnost"),
    ("main.tf", 'spravuje   = "terraform"', 'spravuje   = "rucne"', "štítek spravuje"),
    ("variables.tf", '"prod"], var.prostredi)', '"prod", "staging"], var.prostredi)', "validace prostředí"),
    ("variables.tf", "^[a-z]{2,10}$", "^[a-z]{2,20}$", "maximální délka projektu"),
    ("variables.tf", "^[a-z]{2,10}$", "^[a-zA-Z-]{2,10}$", "povolené znaky v projektu"),
    ("variables.tf", "var.instance <= 99", "var.instance <= 100", "horní mez instance"),
    ("variables.tf", " && floor(var.instance) == var.instance", "", "celočíselnost instance"),
    ("outputs.tf", "length(local.nazev) <= 30", "length(local.nazev) <= 60", "limit délky názvu"),
]
PRAH = 0.8


def terraform_test(adresar: Path) -> bool:
    r = subprocess.run(["terraform", "test", "-no-color"], cwd=adresar,
                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    return r.returncode == 0


def main() -> int:
    zdroj = Path(sys.argv[1] if len(sys.argv) > 1 else "start").resolve()
    if not list((zdroj / "tests").glob("*.tftest.hcl")):
        print(f"V {zdroj}/tests nejsou žádné soubory *.tftest.hcl.")
        return 2

    with tempfile.TemporaryDirectory() as tmp:
        prac = Path(tmp) / "modul"
        shutil.copytree(zdroj, prac, ignore=shutil.ignore_patterns(".terraform", "*.tfstate*"))
        subprocess.run(["terraform", "init", "-input=false", "-no-color"], cwd=prac,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)

        if not terraform_test(prac):
            print("❌ Vaše testy neprocházejí ani na správném modulu. Nejdřív opravte je.")
            return 1
        print("✅ Testy procházejí na správném modulu.\n")

        zabito = 0
        for soubor, stare, nove, popis in MUTANTI:
            cesta = prac / soubor
            puvodni = cesta.read_text(encoding="utf-8")
            if stare not in puvodni:
                print(f"⚠️  Mutant „{popis}“ nelze vložit – změnili jste {soubor}?")
                continue
            cesta.write_text(puvodni.replace(stare, nove, 1), encoding="utf-8")
            prezil = terraform_test(prac)
            cesta.write_text(puvodni, encoding="utf-8")
            if prezil:
                print(f"❌ přežil:  {popis:40}  ({soubor}: {stare!r} → {nove!r})")
            else:
                zabito += 1
                print(f"✅ zabit:   {popis}")

    skore = zabito / len(MUTANTI)
    print(f"\nMutační skóre: {zabito}/{len(MUTANTI)} = {skore:.0%} (požadováno ≥ {PRAH:.0%})")
    return 0 if skore >= PRAH else 1


if __name__ == "__main__":
    sys.exit(main())
