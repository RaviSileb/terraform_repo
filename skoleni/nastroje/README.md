# Nástroje kurzu

| Soubor | K čemu |
|---|---|
| [`overeni-prostredi.sh`](overeni-prostredi.sh) | kontrola, že máte Terraform ≥ 1.10, Docker, Git, Python, TFLint |
| [`zkontroluj.sh`](zkontroluj.sh) | autograder: `zkontroluj.sh <lab01…lab08\|capstone\|opravarna\|vse> [start\|reseni] [--integrace]` |
| [`media/`](media/README.md) | generátory podcastu, video lekcí a záznamů terminálu |

Autograder spouští pro každý lab `terraform fmt -check`, `init`, `validate` a `terraform test`; navíc kontrolu stavu (lab 04), mutační testování (lab 07) a kontrolu workflow (lab 08). V GitHub Actions zapisuje souhrnnou tabulku do *Summary* běhu.
