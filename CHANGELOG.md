# Changelog

## [Unreleased]

### V2 beta (branche `v2-beta`)

Validée avec `esphome config` (2026.10.0). Compilation et test sur carte : non faits.

#### ⚠️ Changements incompatibles
- `Sunrise` et `Sunset` changent de comportement : Sunrise = ON à *Heure Fixe (ON)*, OFF au lever + offset ; Sunset = ON au coucher + offset, OFF à *Heure Fixe (OFF)*. Le cycle jour/nuit complet n'existe plus.
- Capteur binaire « État Relais » supprimé (doublon du switch, 60 s de retard). Les automatisations Home Assistant qui l'utilisent sont à mettre à jour.

#### Pour l'utilisateur
- Nouveau mode `Manuel` : désactive l'automatisation. Dans les autres modes, un changement manuel du relais est annulé en 30 s au plus.
- Un événement manqué est rattrapé (tick sauté, saut d'horloge, changement d'heure) et un changement de Mode, d'offset ou d'heure fixe s'applique immédiatement.
- Plus de redémarrage quand Home Assistant est absent (`api: reboot_timeout: 0s`).
- Heure ON == OFF en Horaire Fixe : relais OFF.
- Documenté : variation saisonnière de Sunrise/Sunset, décalage d'1 h possible au changement d'heure, comportement de Manuel, sécurité matérielle, migration depuis la v1.

#### Interne
- Évaluation par niveau : un seul script `appliquer_etat` calcule l'état voulu et ne commande le relais que s'il diffère. Appelé au boot, après chaque synchro SNTP, par les `on_value` des réglages et par un `interval` de 30 s.
- Corrige le retry de démarrage (script qui s'appelait lui-même en `mode: single`, donc rejeté).
- Date du calcul solaire en heure locale (`from_epoch_local`) ; offset NaN avant restauration géré (`std::isnan`).
- Avertissement dans le journal quand l'heure n'est pas synchronisée (répété toutes les 30 s).
- `restore_mode: RESTORE_DEFAULT_OFF` conservé.
- Revue par sous-agents : skill `/council` et agents dans `.claude/`.

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
