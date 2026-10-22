#!/usr/bin/env python3
"""Vygeneruje video lekce (MP4 + SRT + náhled PNG) z video_lekce.py.

  python3 generuj_videa.py --backend edge          # nejlepší hlas (online)
  python3 generuj_videa.py --backend coqui 04      # offline, jen lekce 04
Potřebuje: ffmpeg, Node.js + Playwright (Chromium), TTS backend jako generuj_podcast.py.
"""
import argparse
import html
import json
import re
import subprocess
import tempfile
from pathlib import Path

from cestina import nacti_slovnik, normalizuj
from video_lekce import LEKCE
from zvuk import Syntetizator, delka, ffmpeg, ticho

TU = Path(__file__).resolve().parent
SKOLENI = TU.parents[1]
OBRAZKY = SKOLENI / "obrazky"
VYSTUP = SKOLENI / "video" / "lekce"
PAD_PRED, PAD_PO = 0.4, 0.9

CSS = """
*{box-sizing:border-box}
body{margin:0;width:1280px;height:720px;font-family:Inter,'Noto Sans','DejaVu Sans',sans-serif;background:#F8FAFC;color:#0F172A;position:relative;overflow:hidden}
.hlava{position:absolute;left:0;top:0;right:0;height:96px;background:#0F172A;color:#fff;display:flex;align-items:center;padding:0 56px;font-size:38px;font-weight:800}
.hlava small{margin-left:auto;font-size:18px;font-weight:600;color:#A78BFA;letter-spacing:2px}
.obsah{position:absolute;left:56px;right:56px;top:120px;bottom:70px;display:flex;align-items:center;justify-content:center}
.obr{top:108px;bottom:52px}
.obsah img{max-width:100%;max-height:100%;border-radius:14px;box-shadow:0 8px 30px rgba(15,23,42,.18)}
ul{list-style:none;margin:0;padding:0;width:100%}
li{font-size:38px;line-height:1.35;margin:18px 0;padding-left:56px;position:relative}
li:before{content:"";position:absolute;left:8px;top:18px;width:22px;height:22px;border-radius:6px;background:#7B42BC}
pre{margin:0;width:100%;background:#1E293B;color:#E2E8F0;border-radius:16px;padding:30px 36px;font:26px/1.45 'JetBrains Mono','DejaVu Sans Mono',monospace;font-variant-ligatures:none;white-space:pre;overflow:hidden}
.k{color:#C4B5FD;font-weight:700}.s{color:#86EFAC}.c{color:#94A3B8;font-style:italic}.n{color:#FCD34D}
.pata{position:absolute;left:56px;right:56px;bottom:22px;display:flex;font-size:18px;color:#64748B}
.pata span:last-child{margin-left:auto}
.prubeh{position:absolute;left:0;bottom:0;height:8px;background:#7B42BC}
.titul{background:radial-gradient(circle at 20% 15%,#7B42BC 0%,#3B1A70 45%,#0F172A 100%);color:#fff}
.titul .cislo{position:absolute;left:96px;top:120px;font-size:30px;font-weight:700;color:#34D399;letter-spacing:4px}
.titul h1{position:absolute;left:96px;top:190px;right:96px;font-size:86px;line-height:1.05;margin:0;font-weight:800}
.titul p{position:absolute;left:96px;top:430px;right:96px;font-size:36px;color:#E9D5FF;margin:0}
.titul .pata{color:#CBD5E1}
.otazka{background:#0F172A;color:#fff}
.otazka .stit{position:absolute;left:96px;top:130px;font-size:28px;font-weight:800;color:#0F172A;background:#FBBF24;padding:10px 24px;border-radius:999px}
.otazka h2{position:absolute;left:96px;right:96px;top:230px;font-size:56px;line-height:1.2;margin:0}
.otazka p{position:absolute;left:96px;top:560px;font-size:28px;color:#94A3B8;margin:0}
"""
KLICOVA = r"^(\s*)(resource|variable|output|module|data|terraform|provider|locals|moved|import|removed|run|assert|mock_provider|variables|validation|lifecycle|dynamic|check|ports|permissions|concurrency|jobs|environment|nasazeni)\b"


def zvyrazni(kod: str) -> str:
    radky = []
    for radek in kod.split("\n"):
        casti = re.split(r'("(?:[^"\\]|\\.)*")', radek)
        out, komentar = [], False
        for i, c in enumerate(casti):
            if komentar:
                out.append(html.escape(c))
            elif i % 2 == 1:
                out.append(f'<span class="s">{html.escape(c)}</span>')
            else:
                if "#" in c:
                    pred, po = c.split("#", 1)
                    out.append(re.sub(KLICOVA, r'\1<span class="k">\2</span>', html.escape(pred)) if i == 0 else html.escape(pred))
                    out.append(f'<span class="c">#{html.escape(po)}')
                    komentar = True
                else:
                    t = html.escape(c)
                    if i == 0:
                        t = re.sub(KLICOVA, r'\1<span class="k">\2</span>', t)
                    t = re.sub(r"\b(\d+)\b", r'<span class="n">\1</span>', t)
                    out.append(t)
        radky.append("".join(out) + ("</span>" if komentar else ""))
    return "\n".join(radky)


def slide_html(lekce, i, s) -> str:
    n = len(lekce["slidy"])
    pata = f'<div class="pata"><span>Lekce {lekce["cislo"]} · {html.escape(lekce["nazev"])}</span><span>{i + 1} / {n}</span></div>'
    prubeh = f'<div class="prubeh" style="width:{(i + 1) / n * 100:.1f}%"></div>'
    if s["typ"] == "titul":
        telo = (f'<body class="titul"><div class="cislo">VIDEO LEKCE {lekce["cislo"]}</div>'
                f'<h1>{html.escape(lekce["nazev"])}</h1><p>{html.escape(s["podtitul"])}</p>{pata}{prubeh}</body>')
    elif s["typ"] == "otazka":
        telo = (f'<body class="otazka"><div class="stit">ZASTAVTE VIDEO A ODPOVĚZTE</div>'
                f'<h2>{html.escape(s["otazka"])}</h2><p>Vybavení z paměti posiluje učení víc než opakované sledování.</p>{pata}{prubeh}</body>')
    else:
        if s["typ"] == "obrazek":
            obsah = f'<img src="{(OBRAZKY / s["obrazek"]).as_uri()}">'
        elif s["typ"] == "body":
            obsah = "<ul>" + "".join(f"<li>{html.escape(b)}</li>" for b in s["body"]) + "</ul>"
        else:
            radku = s["kod"].count("\n") + 1
            velikost = min(26, int(440 / (radku * 1.45)))
            obsah = f'<pre style="font-size:{velikost}px">{zvyrazni(s["kod"])}</pre>'
        telo = (f'<body><div class="hlava">{html.escape(s["nadpis"])}<small>TERRAFORM ŠKOLENÍ</small></div>'
                f'<div class="obsah{" obr" if s["typ"] == "obrazek" else ""}">{obsah}</div>{pata}{prubeh}</body>')
    return f'<!doctype html><html lang="cs"><head><meta charset="utf-8"><style>{CSS}</style></head>{telo}</html>'


def cas(t: float) -> str:
    ms = int(round(t * 1000))
    return f"{ms // 3600000:02d}:{ms // 60000 % 60:02d}:{ms // 1000 % 60:02d},{ms % 1000:03d}"


def titulky(narace: str, start: float, trvani: float):
    vety = [v.strip() for v in re.split(r"(?<=[.!?])\s+", narace) if v.strip()]
    celkem = sum(len(v) for v in vety)
    t, out = start, []
    for v in vety:
        d = trvani * len(v) / celkem
        out.append((t, t + d, v))
        t += d
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("lekce", nargs="*", help="čísla lekcí, např. 01 04 (výchozí: všechny)")
    ap.add_argument("--backend", default="edge", choices=["coqui", "edge", "espeak"])
    ap.add_argument("--coqui-model")
    args = ap.parse_args()
    VYSTUP.mkdir(parents=True, exist_ok=True)
    slovnik = nacti_slovnik(TU / "vyslovnost.tsv")
    tts = Syntetizator(args.backend, args.coqui_model)
    meta_soubor = VYSTUP / "lekce.json"
    meta = json.loads(meta_soubor.read_text()) if meta_soubor.exists() else {}

    for lekce in LEKCE:
        if args.lekce and lekce["cislo"] not in args.lekce:
            continue
        jmeno = f"lekce-{lekce['cislo']}-{lekce['slug']}"
        print(f"▶ {jmeno}")
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            seznam = []
            for i, s in enumerate(lekce["slidy"]):
                h = tmp / f"s{i}.html"
                h.write_text(slide_html(lekce, i, s), encoding="utf-8")
                seznam.append({"html": str(h), "png": str(tmp / f"s{i}.png")})
            (tmp / "seznam.json").write_text(json.dumps(seznam))
            subprocess.run(["node", str(TU / "slidy.js"), str(tmp / "seznam.json")], check=True)

            segmenty, srt, t = [], [], 0.0
            for i, s in enumerate(lekce["slidy"]):
                rec = tmp / f"r{i}.wav"
                tts.rekni(normalizuj(s["narace"], slovnik), "Petra", rec)
                d_rec = delka(rec)
                pred, po = tmp / "pred.wav", tmp / "po.wav"
                ticho(pred, PAD_PRED)
                ticho(po, PAD_PO)
                audio = tmp / f"a{i}.wav"
                ffmpeg("-i", str(pred), "-i", str(rec), "-i", str(po), "-filter_complex", "[0][1][2]concat=n=3:v=0:a=1", str(audio))
                d = delka(audio)
                seg = tmp / f"seg{i}.mp4"
                ffmpeg("-loop", "1", "-framerate", "10", "-i", str(tmp / f"s{i}.png"), "-i", str(audio),
                       "-c:v", "libx264", "-tune", "stillimage", "-preset", "medium", "-crf", "26", "-pix_fmt", "yuv420p", "-r", "10",
                       "-c:a", "aac", "-b:a", "64k", "-ar", "44100", "-ac", "1", "-t", f"{d:.3f}", str(seg))
                segmenty.append(seg)
                srt += titulky(s["narace"], t + PAD_PRED, d_rec)
                t += delka(seg)

            seznam_seg = tmp / "segmenty.txt"
            seznam_seg.write_text("".join(f"file '{p}'\n" for p in segmenty))
            spojene = tmp / "spojene.mp4"
            ffmpeg("-f", "concat", "-safe", "0", "-i", str(seznam_seg), "-c", "copy", str(spojene))
            mp4 = VYSTUP / f"{jmeno}.mp4"
            ffmpeg("-i", str(spojene), "-c:v", "copy", "-af", "loudnorm=I=-16:TP=-1.5:LRA=11", "-c:a", "aac", "-b:a", "64k", "-ar", "44100",
                   "-movflags", "+faststart", "-metadata", f"title=Lekce {lekce['cislo']} – {lekce['nazev']}",
                   "-metadata", "language=ces", str(mp4))
            (VYSTUP / f"{jmeno}.srt").write_text(
                "\n".join(f"{k + 1}\n{cas(a)} --> {cas(b)}\n{v}\n" for k, (a, b, v) in enumerate(srt)), encoding="utf-8")
            plakat = lekce.get("plakat", 0)
            ffmpeg("-i", str(tmp / f"s{plakat}.png"), "-vf", "scale=640:360", str(VYSTUP / f"{jmeno}.png"))

        meta[jmeno] = {"cislo": lekce["cislo"], "nazev": lekce["nazev"], "modul": lekce["modul"],
                       "delka_s": round(delka(mp4), 1), "velikost_b": mp4.stat().st_size, "backend": args.backend}
        print(f"  ✅ {mp4.name}: {meta[jmeno]['delka_s'] / 60:.1f} min, {mp4.stat().st_size / 1e6:.1f} MB")
    meta_soubor.write_text(json.dumps(dict(sorted(meta.items())), ensure_ascii=False, indent=2) + "\n")


if __name__ == "__main__":
    main()
