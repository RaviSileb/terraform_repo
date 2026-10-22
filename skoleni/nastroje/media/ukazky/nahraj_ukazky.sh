#!/usr/bin/env bash
# Nahraje terminálové ukázky ze skutečných běhů Terraformu a převede je na GIF a MP4.
# Potřebuje: terraform, docker, asciinema, agg (https://github.com/asciinema/agg), ffmpeg.
#   skoleni/nastroje/media/ukazky/nahraj_ukazky.sh [lab01-workflow lab03-docker ...]
set -euo pipefail
TU="$(cd "$(dirname "$0")" && pwd)"
SKOLENI="$(cd "$TU/../../.." && pwd)"
VYSTUP="$SKOLENI/video/terminal"
mkdir -p "$VYSTUP"
ASCIINEMA="${ASCIINEMA:-asciinema}"

priprav() {
  local ukazka="$1" d
  d="$(mktemp -d)/lab"
  case "$ukazka" in
    lab01-workflow) cp -r "$SKOLENI/labs/lab01-prvni-kroky/reseni" "$d" ;;
    lab03-docker)   cp -r "$SKOLENI/labs/lab03-docker/reseni" "$d" ;;
    lab04-state)
      cp -r "$SKOLENI/labs/lab04-state/start" "$d"
      printf 'import {\n  to = docker_network.legacy\n  id = "lab04-legacy-sit"\n}\n' > "$d/import.tf.pripraveny"
      printf 'moved {\n  from = docker_container.web\n  to   = docker_container.frontend\n}\n' > "$d/moved.tf.pripraveny" ;;
    lab05-count)    cp -r "$SKOLENI/labs/lab05-for-each/start" "$d" ;;
  esac
  rm -rf "$d/.terraform" "$d"/terraform.tfstate* "$d/tests"
  echo "$d"
}

uklid() {
  docker rm -f lab03-web lab04-web lab05-web lab05-api lab05-docs >/dev/null 2>&1 || true
  docker network rm lab04-legacy-sit >/dev/null 2>&1 || true
}

for u in "${@:-lab01-workflow lab03-docker lab04-state lab05-count}"; do
  for ukazka in $u; do
    echo "▶ $ukazka"
    uklid
    d="$(priprav "$ukazka")"
    (cd "$d" && terraform init -input=false >/dev/null)   # stažení providerů mimo záznam
    cast="$(mktemp --suffix=.cast)"
    "$ASCIINEMA" rec --overwrite -q --cols 100 --rows 28 -c "bash $TU/$ukazka.sh $d" "$cast"
    agg --font-family "JetBrains Mono" --font-size 18 --theme monokai --idle-time-limit 2.5 --last-frame-duration 5 "$cast" "$VYSTUP/$ukazka.gif"
    ffmpeg -hide_banner -loglevel error -y -i "$VYSTUP/$ukazka.gif" -movflags faststart -pix_fmt yuv420p \
      -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" -c:v libx264 -crf 28 -preset slow "$VYSTUP/$ukazka.mp4"
    (cd "$d" && terraform destroy -auto-approve >/dev/null 2>&1 || true)
    uklid
    cp "$cast" "$VYSTUP/$ukazka.cast"
    ls -la "$VYSTUP/$ukazka".*
  done
done
