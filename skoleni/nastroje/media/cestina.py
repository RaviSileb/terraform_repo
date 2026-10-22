"""Normalizace textu pro českou syntézu řeči: markdown, čísla, výslovnost anglických termínů."""
import re
from pathlib import Path

JEDNOTKY = ["nula", "jedna", "dva", "tři", "čtyři", "pět", "šest", "sedm", "osm", "devět",
            "deset", "jedenáct", "dvanáct", "třináct", "čtrnáct", "patnáct", "šestnáct",
            "sedmnáct", "osmnáct", "devatenáct"]
DESITKY = ["", "", "dvacet", "třicet", "čtyřicet", "padesát", "šedesát", "sedmdesát", "osmdesát", "devadesát"]
STOVKY = ["", "sto", "dvě stě", "tři sta", "čtyři sta", "pět set", "šest set", "sedm set", "osm set", "devět set"]


def cislo(n: int) -> str:
    if n < 20:
        return JEDNOTKY[n]
    if n < 100:
        d, j = divmod(n, 10)
        return DESITKY[d] + ("" if j == 0 else " " + JEDNOTKY[j])
    if n < 1000:
        s, z = divmod(n, 100)
        return STOVKY[s] + ("" if z == 0 else " " + cislo(z))
    if n < 1_000_000:
        t, z = divmod(n, 1000)
        tisice = "tisíc" if t == 1 else (cislo(t) + (" tisíce" if 2 <= t <= 4 else " tisíc"))
        return tisice + ("" if z == 0 else " " + cislo(z))
    return " ".join(JEDNOTKY[int(c)] for c in str(n))


def nacti_slovnik(cesta: Path):
    pravidla = []
    for radek in cesta.read_text(encoding="utf-8").splitlines():
        if not radek.strip() or radek.startswith("#"):
            continue
        vyraz, vyslovnost = radek.split("\t", 1)
        prefix = vyraz.endswith("*")
        vyraz = vyraz.rstrip("*")
        konec = r"(\w*)" if prefix else r"(?!\w)"
        vzor = re.compile(r"(?<!\w)" + re.escape(vyraz) + konec, re.IGNORECASE)
        pravidla.append((len(vyraz), vzor, vyslovnost, prefix))
    pravidla.sort(key=lambda p: -p[0])
    return pravidla


def odstran_markdown(text: str) -> str:
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)
    text = re.sub(r"[`*_#>]", " ", text)
    return re.sub(r"\s+", " ", text).strip()


def normalizuj(text: str, pravidla) -> str:
    text = text.replace("for_each", "for each").replace("depends_on", "depends on").replace("required_providers", "required providers")
    text = odstran_markdown(text)
    # Chráněné úseky (\x00…\x01), aby jedno pravidlo nepřepsalo výsledek jiného.
    for _, vzor, vyslovnost, prefix in pravidla:
        if prefix:
            text = vzor.sub(lambda m: "\x00" + vyslovnost + m.group(1) + "\x01", text)
        else:
            text = vzor.sub("\x00" + vyslovnost + "\x01", text)
    text = text.replace("\x00", "").replace("\x01", "")
    text = re.sub(r"(\d+)\s*%", lambda m: cislo(int(m.group(1))) + " procent", text)
    text = re.sub(r"(\d+)\.(\d+)", lambda m: cislo(int(m.group(1))) + " " + cislo(int(m.group(2))), text)
    text = re.sub(r"\d+", lambda m: cislo(int(m.group(0))), text)
    text = text.replace("–", ",").replace("—", ",").replace("/", " ").replace("…", ".")
    text = re.sub(r"[„“\"'()]", "", text)
    return re.sub(r"\s+", " ", text).strip()
