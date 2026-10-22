#!/usr/bin/env python3
"""Vygeneruje epizody podcastu (MP3) ze scénářů skoleni/podcast/ep*.md.

Backendy:
  coqui  – offline, Coqui TTS + český model VITS (tts_models/cs/cv/vits), druhý hlas posunem výšky
  edge   – online, neuronové hlasy cs-CZ-VlastaNeural a cs-CZ-AntoninNeural (pip install edge-tts), nejlepší kvalita
  espeak – offline nouzovka (espeak-ng), robotický hlas

Příklady:
  python3 generuj_podcast.py --backend edge
  COQUI_CS_MODEL=/cesta/k/modelu python3 generuj_podcast.py --backend coqui ep03
"""
import argparse
import json
import re
import tempfile
from pathlib import Path

from cestina import nacti_slovnik, normalizuj
from zvuk import Syntetizator, delka, ffmpeg, spoj_wav, ticho, znelka

KOREN = Path(__file__).resolve().parents[2]
PODCAST = KOREN / "podcast"
NAZEV_PORADU = "Terraform: od nuly k produkci"
RADEK = re.compile(r"^\*\*(Petra|Tomáš):\*\*\s*(.+)$")


def nacti_scenar(soubor: Path):
    text = soubor.read_text(encoding="utf-8")
    titulek = re.search(r"^# (.+)$", text, re.M).group(1)
    repliky = [(m.group(1), m.group(2)) for m in map(RADEK.match, text.splitlines()) if m]
    return titulek, repliky


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("epizody", nargs="*", help="např. ep01 (výchozí: všechny)")
    ap.add_argument("--backend", default="edge", choices=["coqui", "edge", "espeak"])
    ap.add_argument("--coqui-model")
    ap.add_argument("--bitrate", default="48k")
    args = ap.parse_args()

    slovnik = nacti_slovnik(Path(__file__).with_name("vyslovnost.tsv"))
    tts = Syntetizator(args.backend, args.coqui_model)
    vystup = PODCAST / "epizody"
    vystup.mkdir(exist_ok=True)
    meta_soubor = vystup / "epizody.json"
    meta = json.loads(meta_soubor.read_text()) if meta_soubor.exists() else {}
    obal = PODCAST / "obal.jpg"

    for scenar in sorted(PODCAST.glob("ep*.md")):
        if args.epizody and not any(scenar.name.startswith(e) for e in args.epizody):
            continue
        titulek, repliky = nacti_scenar(scenar)
        print(f"▶ {scenar.name}: {len(repliky)} replik")
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            pauza, uvod_pauza = tmp / "pauza.wav", tmp / "uvod.wav"
            ticho(pauza, 0.45)
            ticho(uvod_pauza, 0.6)
            znelka(tmp / "znelka.wav")
            segmenty = [tmp / "znelka.wav", uvod_pauza]
            for i, (mluvci, text) in enumerate(repliky):
                wav = tmp / f"{i:03d}.wav"
                tts.rekni(normalizuj(text, slovnik), mluvci, wav)
                segmenty += [wav, pauza]
            segmenty += [uvod_pauza, tmp / "znelka.wav"]
            spojeno = tmp / "spojeno.wav"
            spoj_wav(segmenty, spojeno)

            mp3 = vystup / (scenar.stem + ".mp3")
            cislo = int(scenar.stem[2:4])
            vstupy = ["-i", str(spojeno)]
            mapovani = ["-map", "0:a"]
            if obal.exists():
                vstupy += ["-i", str(obal)]
                mapovani += ["-map", "1:v", "-c:v", "mjpeg", "-disposition:v", "attached_pic"]
            ffmpeg(*vstupy, *mapovani,
                   "-af", "loudnorm=I=-16:TP=-1.5:LRA=11", "-ar", "22050", "-ac", "1",
                   "-c:a", "libmp3lame", "-b:a", args.bitrate, "-id3v2_version", "3",
                   "-metadata", f"title={titulek}", "-metadata", f"album={NAZEV_PORADU}",
                   "-metadata", "artist=Terraform školení", "-metadata", f"track={cislo + 1}",
                   "-metadata", "genre=Podcast", "-metadata", "language=ces",
                   "-metadata", f"comment=Syntetická řeč ({args.backend}). Přepis: {scenar.name}",
                   str(mp3))
        meta[scenar.stem] = {"titulek": titulek, "soubor": f"epizody/{mp3.name}", "delka_s": round(delka(mp3), 1),
                             "velikost_b": mp3.stat().st_size, "backend": args.backend, "scenar": scenar.name}
        print(f"  ✅ {mp3.name}: {meta[scenar.stem]['delka_s'] / 60:.1f} min, {mp3.stat().st_size / 1e6:.1f} MB")
    meta_soubor.write_text(json.dumps(dict(sorted(meta.items())), ensure_ascii=False, indent=2) + "\n")


if __name__ == "__main__":
    main()
