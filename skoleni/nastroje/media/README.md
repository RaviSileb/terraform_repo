# Generátory médií

Podcast i videa vznikají ze **textových zdrojů v repozitáři** – opravit chybu znamená upravit text a znovu spustit generátor.

| Skript | Vstup | Výstup |
|---|---|---|
| [`generuj_podcast.py`](generuj_podcast.py) | `skoleni/podcast/ep*.md` (řádky `**Petra:**` / `**Tomáš:**`) | `podcast/epizody/*.mp3`, `epizody.json` |
| [`generuj_feed.py`](generuj_feed.py) | `epizody.json` | `podcast/feed.xml` (RSS 2.0 + iTunes + Podcasting 2.0 transcript) |
| [`generuj_videa.py`](generuj_videa.py) | [`video_lekce.py`](video_lekce.py) (slidy + narace), `skoleni/obrazky/*.svg` | `video/lekce/*.mp4`, `*.srt`, náhledy `*.png` |
| [`ukazky/nahraj_ukazky.sh`](ukazky/nahraj_ukazky.sh) | ukázkové skripty `ukazky/lab*.sh` + skutečný Terraform a Docker | `video/terminal/*.gif`, `*.mp4`, `*.cast` |

Sdílené moduly: [`cestina.py`](cestina.py) (normalizace textu: markdown, čísla slovy, výslovnost podle [`vyslovnost.tsv`](vyslovnost.tsv)), [`zvuk.py`](zvuk.py) (TTS backendy, znělka, ffmpeg), [`slidy.js`](slidy.js) (render HTML slidů přes Playwright).

## Závislosti
- `ffmpeg` (s libmp3lame, libx264, rubberband, loudnorm), Python 3.10+
- TTS – jeden z backendů:
  - `edge`: `pip install edge-tts` (online, nejlepší kvalita – hlasy *cs-CZ-VlastaNeural* a *cs-CZ-AntoninNeural*)
  - `coqui`: `pip install "coqui-tts[codec]" torch torchaudio` + model `tts_models/cs/cv/vits`; cesta k modelu v `COQUI_CS_MODEL`
  - `espeak`: `apt install espeak-ng`
- videa: Node.js + `npm install playwright` + `npx playwright install chromium`
- záznamy terminálu: [asciinema](https://asciinema.org) a [agg](https://github.com/asciinema/agg)

## Příklady
```bash
cd skoleni/nastroje/media
python3 generuj_podcast.py --backend edge             # všechny epizody
python3 generuj_podcast.py --backend edge ep05        # jedna epizoda
python3 generuj_feed.py --zaklad https://raw.githubusercontent.com/<vlastnik>/<repo>/main/skoleni/podcast/
python3 generuj_videa.py --backend edge 04            # jedna video lekce
./ukazky/nahraj_ukazky.sh lab03-docker                # jeden záznam terminálu
```

## Výslovnost
Model čte podle českého pravopisu, takže anglické termíny se pro syntézu přepisují: `apply` → „eplaj“, `state` → „stejt“, `provider*` → „provajdr*“ (hvězdička zachová českou koncovku: *providerů* → „provajdrů“). Přepisy v Markdownu zůstávají beze změny. Když narazíte na špatnou výslovnost, přidejte řádek do `vyslovnost.tsv`.
