#!/usr/bin/env python3
"""Vytvoří RSS feed podcastu (skoleni/podcast/feed.xml) z epizody.json a scénářů.

  python3 generuj_feed.py --zaklad https://raw.githubusercontent.com/<vlastnik>/<repo>/main/skoleni/podcast/
"""
import argparse
import json
import re
from datetime import datetime, timedelta, timezone
from email.utils import format_datetime
from pathlib import Path
from xml.sax.saxutils import escape

PODCAST = Path(__file__).resolve().parents[2] / "podcast"


def popis(scenar: Path) -> str:
    text = scenar.read_text(encoding="utf-8")
    prvni = re.search(r"^\*\*(?:Petra|Tomáš):\*\*\s*(.+)$", text, re.M).group(1)
    return re.sub(r"\s+", " ", prvni)[:400]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--zaklad", default="https://raw.githubusercontent.com/ravisileb/terraform_repo/main/skoleni/podcast/")
    ap.add_argument("--web", default="https://github.com/ravisileb/terraform_repo/tree/main/skoleni")
    ap.add_argument("--datum", default="2026-10-22")
    args = ap.parse_args()
    zaklad = args.zaklad.rstrip("/") + "/"
    meta = json.loads((PODCAST / "epizody" / "epizody.json").read_text())
    start = datetime.fromisoformat(args.datum).replace(hour=6, tzinfo=timezone.utc)

    soubory = args.web.replace("/tree/", "/blob/")
    polozky = []
    for i, (klic, m) in enumerate(sorted(meta.items())):
        d = int(m["delka_s"])
        polozky.append(f"""    <item>
      <title>{escape(m['titulek'])}</title>
      <description>{escape(popis(PODCAST / m['scenar']))}</description>
      <link>{escape(soubory)}/podcast/{m['scenar']}</link>
      <guid isPermaLink="false">terraform-skoleni-{klic}</guid>
      <pubDate>{format_datetime(start + timedelta(hours=i))}</pubDate>
      <enclosure url="{escape(zaklad + m['soubor'])}" length="{m['velikost_b']}" type="audio/mpeg"/>
      <itunes:duration>{d // 60:02d}:{d % 60:02d}</itunes:duration>
      <itunes:episode>{i + 1}</itunes:episode>
      <itunes:explicit>false</itunes:explicit>
      <podcast:transcript url="{escape(soubory)}/podcast/{m['scenar']}" type="text/html" language="cs"/>
    </item>""")

    feed = f"""<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:podcast="https://podcastindex.org/namespace/1.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>Terraform: od nuly k produkci</title>
    <link>{escape(args.web)}</link>
    <atom:link href="{escape(zaklad)}feed.xml" rel="self" type="application/rss+xml"/>
    <language>cs</language>
    <description>Podcast ke kurzu infrastruktury jako kódu s Terraformem. Petra a Tomáš probírají pojmy, analogie a typické chyby, které pak procvičíte v labech. Hlasy jsou syntetické.</description>
    <itunes:author>Terraform školení</itunes:author>
    <itunes:image href="{escape(zaklad)}obal.png"/>
    <itunes:category text="Technology"/>
    <itunes:explicit>false</itunes:explicit>
    <itunes:type>serial</itunes:type>
{chr(10).join(polozky)}
  </channel>
</rss>
"""
    (PODCAST / "feed.xml").write_text(feed, encoding="utf-8")
    print(f"feed.xml: {len(polozky)} epizod")


if __name__ == "__main__":
    main()
