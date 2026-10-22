# Pomocné funkce pro nahrávání terminálových ukázek (source z ukázkových skriptů).
export CHECKPOINT_DISABLE=1 TF_IN_AUTOMATION=1
PROMPT=$'\e[1;35mlab\e[0m \e[1;34m$\e[0m '

pis() {
  printf '%s' "$PROMPT"
  local s="$1" i
  for ((i = 0; i < ${#s}; i++)); do printf '%s' "${s:i:1}"; sleep 0.03; done
  sleep 0.35
  printf '\n'
}

komentar() { printf '\e[2;3m# %s\e[0m\n' "$1"; sleep 1.4; }

# spust "<zobrazený příkaz>" ["<skutečně spuštěný příkaz, např. se zkráceným výstupem>"] [pauza]
spust() {
  pis "$1"
  eval "${2:-$1}"
  sleep "${3:-1.6}"
}
