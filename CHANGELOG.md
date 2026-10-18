# Changelog

## [Unreleased]

### Ajouté
- `presence/` : nœud ESP32-C3 + radar LD2410 pilotant des lampes via Home Assistant, avec calibrage automatique par porte (pièce vide, pic + marge)
- Pilotage direct des lampes en HTTP (API REST `web_server`), sans Home Assistant, avec sélecteur de mode
- `presence/pico_w_timesync/` : serveur SNTP MicroPython pour Pico W (temps local des nœuds)

### Corrigé
- Configuration valide ESPHome : remplacement des `input_*` (Home Assistant) par `select`, `number` et `datetime` template
- `on_sunrise`/`on_sunset` remplacés par une évaluation chaque minute (offsets négatifs possibles)
- Relais replacé dans le bon état au démarrage
- GPIO2 dupliqué supprimé, relais sur GPIO4, `restore_mode` défini
- Secrets (AP, OTA, API, web) déplacés dans `secrets.yaml`, `web_server` protégé

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
