# Changelog

## [Unreleased]

### Ajouté
- `presence/` : nœud ESP32-C3 + radar LD2410 pilotant des lampes via Home Assistant, avec calibrage automatique par porte (pièce vide, pic + marge)
- Pilotage direct des lampes en HTTP (API REST `web_server`), sans Home Assistant, avec sélecteur de mode, jusqu'à 3 lampes par nœud
- `presence/lamp_sonoff_basic_r4.yaml` : récepteur de lampe (Sonoff BASIC R4, interrupteur mural conservé)
- Hotspot de secours (60 s) avec portail captif pour reconfigurer le WiFi sans reflasher (nœud radar et lampe), forçable par bouton ou appui long de 8 s sur le Sonoff
- Page web de configuration du nœud radar (entités groupées) ; URL des lampes et entité Home Assistant modifiables sans recompiler
- `presence/pico_w_timesync/` : serveur SNTP MicroPython pour Pico W (temps local des nœuds)

### Corrigé
- Configuration valide ESPHome : remplacement des `input_*` (Home Assistant) par `select`, `number` et `datetime` template
- `on_sunrise`/`on_sunset` remplacés par une évaluation chaque minute (offsets négatifs possibles)
- Relais replacé dans le bon état au démarrage
- GPIO2 dupliqué supprimé, relais sur GPIO4, `restore_mode` défini
- Secrets (AP, OTA, API, web) déplacés dans `secrets.yaml`, `web_server` protégé

### Modifié
- Fonctionnement sans Home Assistant : `api.reboot_timeout: 0s` (nœud et lampe), *Nuit seulement* échoue en allumant si l'heure est inconnue
- Scripts de pilotage des lampes fusionnés en un seul (`piloter_lampes`)

### À venir
- Support multi-relais
- Interface de configuration avancée
- Amélioration de l'interface web

## [1.0.0] - 2025-11-02

### Ajouté
- Mode Sunrise/Sunset/Fixe
- Offsets ajustables ±120 min
- Interface Web complète
- Intégration Home Assistant
- Documentation complète
