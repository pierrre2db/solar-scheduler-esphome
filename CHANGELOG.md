# Changelog

## [Unreleased]

### V2 beta (branche `v2-beta`, issue du /council)
- Évaluation **par niveau** : un seul script `appliquer_etat` calcule l'état voulu et ne commande le relais que s'il diffère. Appelé au boot, après chaque synchro SNTP, à chaque changement de Mode/offset/heure fixe, et toutes les 30 s
- Corrige le retry de démarrage (script qui s'appelait lui-même en `mode: single`, donc rejeté)
- Rattrape les événements manqués (tick sauté, saut d'horloge, changement d'heure été/hiver)
- Heure ON == OFF en Horaire Fixe : relais OFF (défini explicitement)
- `api: reboot_timeout: 0s` : plus de reboot (donc de glitch relais) quand Home Assistant est absent
- `restore_mode: RESTORE_DEFAULT_OFF` conservé : dernier état restauré jusqu'à l'évaluation
- Modes différenciés : Sunrise = ON à Heure Fixe (ON), OFF au lever + offset ; Sunset = ON au coucher + offset, OFF à Heure Fixe (OFF)
- Date de calcul solaire en heure locale (`from_epoch_local`)
- Mode `Manuel` ajouté : désactive l'automatisation (sinon le relais est recalculé toutes les 30 s et un changement manuel est annulé)
- Offset NaN avant restauration géré (`std::isnan`), variable renommée `off_sec`
- Journal d'avertissement quand l'heure n'est pas synchronisée
- Documenté : variation saisonnière de Sunrise/Sunset, décalage d'1 h possible lors du changement d'heure
- Supprimé : capteur binaire « État Relais » (doublon du switch, 60 s de retard)
- Validé avec `esphome config` (2026.10.0). Compilation et test sur carte : non faits

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
