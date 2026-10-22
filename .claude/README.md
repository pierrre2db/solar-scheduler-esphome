# Revue par conseil de sous-agents

Skill `/council` : 4 sous-agents lecture seule votent, se critiquent, et un verdict est rendu.

| Sous-agent | Rôle |
|---|---|
| `council-esphome` | YAML, lambdas, ordre de démarrage, entités Home Assistant |
| `council-hardware` | GPIO, polarité du relais, état au démarrage et à la coupure |
| `council-scheduling` | Lever/coucher, offsets, minuit, changement d'heure, heure non synchronisée |
| `council-skeptic` | Avocat du diable, périmètre, affirmations non prouvées |

## Usage

- Dans une session sur ce repo : `/council` suivi de la question, ou `/council` seul pour passer le diff en revue.
- Tour 1 : les 4 membres votent en parallèle. Tour 2 : chacun lit les réponses anonymisées des autres et critique la plus faible.
- Verdict : un REJECT à haute confiance de `council-hardware` bloque. Sinon, majorité APPROVE = approuvé, ou liste d'AMEND.
- Le skill est dans le repo, il marche aussi dans les sessions cloud.

Les sous-agents n'ont pas de shell : ils ne compilent rien et ne font pas `git diff`. Fournir le diff dans la demande.
