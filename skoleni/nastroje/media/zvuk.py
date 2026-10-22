"""Společné zvukové nástroje: TTS backendy, ticho, znělka, ffmpeg."""
import array
import json
import math
import os
import shutil
import subprocess
import tempfile
import wave
from pathlib import Path

VZORKOVANI = 22050

# Hlasy: Petra (výchozí hlas modelu), Tomáš (posunutá výška u offline backendů).
HLASY = {
    "edge": {"Petra": "cs-CZ-VlastaNeural", "Tomáš": "cs-CZ-AntoninNeural"},
    "espeak": {"Petra": ["-v", "cs+f3"], "Tomáš": ["-v", "cs+m3"]},
}
POSUN_VYSKY = {"Petra": 1.0, "Tomáš": 0.84}


def ffmpeg(*args):
    subprocess.run(["ffmpeg", "-hide_banner", "-loglevel", "error", "-y", *args], check=True)


def delka(soubor: Path) -> float:
    r = subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "json", str(soubor)],
                       capture_output=True, text=True, check=True)
    return float(json.loads(r.stdout)["format"]["duration"])


def zapis_wav(cesta: Path, vzorky, rate=VZORKOVANI):
    data = array.array("h", (max(-32767, min(32767, int(v * 32767))) for v in vzorky))
    with wave.open(str(cesta), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(rate)
        w.writeframes(data.tobytes())


def ticho(cesta: Path, sekundy: float):
    zapis_wav(cesta, [0.0] * int(VZORKOVANI * sekundy))


def znelka(cesta: Path):
    """Krátká znělka: arpeggio C dur + doznívající akord, generované syntézou."""
    noty = [523.25, 659.25, 783.99, 1046.5]
    celkem = 2.6
    out = [0.0] * int(VZORKOVANI * celkem)
    def ton(f, start, trvani, hlasitost):
        for i in range(int(trvani * VZORKOVANI)):
            t = i / VZORKOVANI
            obalka = min(1.0, t / 0.01) * math.exp(-3.2 * t)
            v = math.sin(2 * math.pi * f * t) + 0.35 * math.sin(4 * math.pi * f * t) + 0.12 * math.sin(6 * math.pi * f * t)
            j = int(start * VZORKOVANI) + i
            if j < len(out):
                out[j] += hlasitost * obalka * v
    for k, f in enumerate(noty):
        ton(f, k * 0.16, 1.2, 0.22)
    for f in (261.63, 392.0, 523.25, 659.25):
        ton(f, 0.75, 1.85, 0.12)
    n = len(out)
    for i in range(int(0.3 * VZORKOVANI)):
        out[n - 1 - i] *= i / (0.3 * VZORKOVANI)
    zapis_wav(cesta, out)


class Syntetizator:
    def __init__(self, backend: str, coqui_model: str | None = None):
        self.backend = backend
        if backend == "coqui":
            from TTS.utils.synthesizer import Synthesizer
            import torch
            torch.set_num_threads(os.cpu_count() or 4)
            m = Path(coqui_model or os.environ.get("COQUI_CS_MODEL", "tts_models--cs--cv--vits"))
            self.synth = Synthesizer(tts_checkpoint=str(m / "model_file.pth.tar"), tts_config_path=str(m / "config.json"),
                                     tts_speakers_file=str(m / "speaker_ids.json"), use_cuda=False)
        elif backend == "edge":
            import edge_tts  # noqa: F401  (pip install edge-tts)
        elif backend == "espeak":
            if not shutil.which("espeak-ng"):
                raise SystemExit("Chybí espeak-ng (apt install espeak-ng).")
        else:
            raise SystemExit(f"Neznámý backend {backend}")

    def rekni(self, text: str, mluvci: str, cil: Path):
        """Vytvoří WAV 22,05 kHz mono s promluvou."""
        with tempfile.TemporaryDirectory() as tmp:
            surovy = Path(tmp) / "surovy.wav"
            if self.backend == "coqui":
                vzorky = self.synth.tts(text, speaker_name="female")
                zapis_wav(surovy, vzorky, self.synth.output_sample_rate)
            elif self.backend == "edge":
                import asyncio
                import edge_tts
                mp3 = Path(tmp) / "a.mp3"
                asyncio.run(edge_tts.Communicate(text, HLASY["edge"][mluvci]).save(str(mp3)))
                ffmpeg("-i", str(mp3), str(surovy))
            else:
                subprocess.run(["espeak-ng", *HLASY["espeak"][mluvci], "-s", "155", "-w", str(surovy), text], check=True)
            filtr = f"aresample={VZORKOVANI}"
            if self.backend == "coqui" and POSUN_VYSKY[mluvci] != 1.0:
                filtr = f"rubberband=pitch={POSUN_VYSKY[mluvci]}," + filtr
            ffmpeg("-i", str(surovy), "-af", filtr, "-ac", "1", "-ar", str(VZORKOVANI), "-sample_fmt", "s16", str(cil))


def spoj_wav(segmenty, cil: Path):
    with tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False) as f:
        for s in segmenty:
            f.write(f"file '{Path(s).resolve()}'\n")
        seznam = f.name
    ffmpeg("-f", "concat", "-safe", "0", "-i", seznam, "-c", "copy", str(cil))
    os.unlink(seznam)
