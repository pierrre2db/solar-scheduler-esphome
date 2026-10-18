# Changelog : capteurs de présence radar

## [0.1.0] - 2026-10-18

### Ajouté
- Nœud ESP32-C3 + radar LD2410 pilotant des lampes, avec calibrage automatique par porte (pièce vide, pic + marge)
- Pilotage direct des lampes en HTTP (API REST `web_server`), sans Home Assistant, avec sélecteur de mode, jusqu'à 3 lampes par nœud
- `lamp_sonoff_basic_r4.yaml` : récepteur de lampe (Sonoff BASIC R4, interrupteur mural conservé)
- Hotspot de secours (60 s) avec portail captif pour reconfigurer le WiFi sans reflasher (nœud radar et lampe), forçable par bouton ou appui long de 8 s sur le Sonoff
- Page web de configuration du nœud radar (entités groupées) ; URL des lampes et entité Home Assistant modifiables sans recompiler
- `pico_w_timesync/` : serveur SNTP MicroPython pour Pico W (temps local des nœuds)
- `docs/REFERENCE.md` : document produit de référence
- `docs/maquettes/` : sources des maquettes des interfaces

### Modifié
- Fonctionnement sans Home Assistant : `api.reboot_timeout: 0s` (nœud et lampe), *Nuit seulement* échoue en allumant si l'heure est inconnue
- Scripts de pilotage des lampes fusionnés en un seul (`piloter_lampes`)
- Projet autonome dans son propre dépôt : `esphome/`, `pico_w_timesync/`, `docs/`, `tests/`, `scripts/`
- Authentification de la page web : digest sur le nœud, basic explicite sur la lampe (le nœud envoie un en-tête Basic)
- Avertissement de broche de strapping GPIO9 du Sonoff volontairement ignoré (broche du bouton)

### Ajouté (qualité)
- `tests/test_ntp_packet.py` : tests du module SNTP
- `scripts/check.sh` : tests + validation ESPHome (+ compilation avec `--compile`)
- `.github/workflows/ci.yml` : tests, `esphome config` et `esphome compile` des deux firmwares
