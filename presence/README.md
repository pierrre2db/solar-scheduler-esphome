# Presence Radar ESPHome

Capteurs de présence radar mmWave qui allument et éteignent des lampes standard par WiFi, sans cloud et sans Home Assistant obligatoire.

- **Nœud radar** : ESP32-C3 + LD2410, calibrage automatique par porte, page web de configuration.
- **Récepteur de lampe** : Sonoff BASIC R4 monté au point lumineux, interrupteur mural conservé.
- **Serveur de temps** : Raspberry Pi Pico W (MicroPython), SNTP local.
- Documentation produit complète : [`docs/REFERENCE.md`](docs/REFERENCE.md).

```
LD2410 ──UART──> ESP32-C3 ──HTTP POST──> Sonoff BASIC R4 ──> lampe
                    │   └─ (option) API ──> Home Assistant ──> lampe
                    └── SNTP ── Pico W (ou pool.ntp.org)
```

## Contenu

```
esphome/              presence_node.yaml, lamp_sonoff_basic_r4.yaml, secrets.yaml.example
pico_w_timesync/      serveur SNTP MicroPython (main.py, ntp_packet.py)
docs/                 REFERENCE.md (document produit), maquettes/ (interfaces)
tests/                tests du module SNTP
scripts/check.sh      tests + validation ESPHome
.github/workflows/    intégration continue (tests, config, compilation)
```

## Mise en service

1. `cd esphome && cp secrets.yaml.example secrets.yaml`, puis remplir (clé API : `openssl rand -base64 32`).
2. **Pico W** : flasher MicroPython, copier `main.py`, `ntp_packet.py` et `secrets.py` (depuis l'exemple). Lui donner une IP fixe et la mettre dans `ntp_server` du nœud.
3. **Lampe** : flasher le Sonoff BASIC R4 avec `lamp_sonoff_basic_r4.yaml` (adaptateur série 3,3 V, bouton maintenu à la mise sous tension), puis OTA.
4. **Nœud radar** : `esphome run presence_node.yaml`.
5. Ouvrir la page web du nœud (`http://<ip>/`) et saisir l'URL de la lampe dans **Lampe 1 URL** : `http://<ip lampe>/light/lampe`.
6. Fixer le capteur à sa place définitive, vider la pièce, lancer **Calibrer (pièce vide)**.

Un fichier nœud par pièce : copier `presence_node.yaml`, changer `name` et `friendly_name`.

## Câblage LD2410 → ESP32-C3

| LD2410 | ESP32-C3 |
|---|---|
| VCC | 5V (4,5 à 6 V, **pas 3,3 V**) |
| GND | GND |
| TX | GPIO6 (`radar_rx_pin`) |
| RX | GPIO5 (`radar_tx_pin`) |

Le LD2410 est en 256000 baud ; UART0 reste au logger.

## Pilotage des lampes

Entité **Mode pilotage lampe** (réglable sans recompiler) :
- `HTTP direct` (défaut) : `POST http://<ip lampe>/light/<id>/turn_on|turn_off` sur l'API REST de `web_server`. Un nouvel essai après 500 ms en cas d'échec.
- `Home Assistant` : action `homeassistant.turn_on|turn_off` sur **Lampe entité Home Assistant** (à autoriser dans HA : *Appareils → le nœud → Configurer → Autoriser l'appareil à effectuer des actions Home Assistant*).
- `Les deux` : utile en transition.

**Plusieurs lampes** : jusqu'à 3 par nœud (**Lampe 1/2/3 URL**, vide = inutilisée). Envois l'un après l'autre : une lampe hors ligne retarde les suivantes de 5 s au plus.

**Nuit seulement** : n'allume que lorsque le soleil est sous l'horizon (élévation < −0,833°). Position par défaut : Namur (`latitude` 50.4674, `longitude` 4.8675, dans `substitutions`). L'extinction n'est jamais bloquée. Sans heure valide, la lampe s'allume.

### Lampe sur interrupteur sans neutre : Sonoff BASIC R4

Pas de neutre dans la boîte de l'interrupteur : monter le module **au point lumineux ou dans la boîte de dérivation** où phase et neutre sont permanents, et câbler l'interrupteur mural sur l'entrée SW. Le « magic switch » inverse la lampe à chaque changement d'état (simple ou va-et-vient), sans conflit avec le radar. Vérifier sur la fiche Sonoff le niveau de tension de l'entrée SW avant de câbler.

- Brochage : relais `GPIO4`, entrée SW `GPIO5`, bouton `GPIO9`, LED `GPIO6` ([fiche ESPHome](https://devices.esphome.io/devices/sonoff-basic-r4-v1.0)).
- Bouton : appui court = bascule la lampe, appui long de 8 s = hotspot WiFi.
- Le secret `lamp_http_basic` du nœud doit correspondre à `web_server.auth` de la lampe (`printf 'Basic %s' "$(printf 'admin:MotDePasse' | base64)"`). L'authentification HTTP Basic passe en clair sur le réseau local : à réserver à un réseau de confiance. Un récepteur autre qu'un appareil ESPHome peut convenir s'il accepte ces requêtes.

> Le montage 230 V se fait disjoncteur coupé et absence de tension vérifiée, idéalement par un électricien.

## Calibrage

Objectif : ignorer ventilateurs, rideaux et plantes, tout en restant sensible.

1. Placer le capteur définitivement : fixe, orienté vers la zone utile, loin d'un mur métallique, pas collé à l'antenne WiFi.
2. Vider la pièce (animaux compris) ; laisser chauffage et ventilateurs dans leur état habituel.
3. Régler **Calibrage durée** (60 s) et **Calibrage marge** (10).
4. Appuyer sur **Calibrer (pièce vide)** et sortir. **Calibrage statut** indique l'avancement.
5. Pour chaque porte (G0 à G8, 0,75 m), le nœud relève le pic d'énergie mouvement et statique, puis règle **seuil = pic + marge** (plafonné à 100). Les seuils sont stockés dans le radar.
6. Valider : entrer, bouger, puis s'asseoir immobile. Présence perdue → baisser la marge (5). Fausses détections → l'augmenter (15 à 20) ou réduire **Porte max mouvement/statique**.

Recalibrer après tout changement de position ou de meubles. **Délai de maintien** (120 s) évite le clignotement.

## Config WiFi sans reflasher (hotspot de secours)

- Sans WiFi pendant 60 s (box changée, nouveau mot de passe), le module ouvre le hotspot **« \<friendly_name\> AP »** (mot de passe `ap_password`). Le portail captif s'ouvre (sinon `http://192.168.4.1`) : choisir le réseau et saisir le mot de passe. Il est mémorisé en flash et prime sur `secrets.yaml`.
- **Forcer le hotspot** : bouton **Hotspot WiFi (reset)** (nœud et lampe) ou appui long de 8 s sur le Sonoff. Le module enregistre un réseau bidon (`hotspot-reset`), redémarre et ouvre son hotspot après 60 s. Il reste hors ligne tant que le vrai réseau n'est pas saisi (l'interrupteur mural de la lampe fonctionne). Pour revenir aux valeurs de `secrets.yaml` : reflasher.

## Si Home Assistant disparaît

Le système tourne sans lui en mode `HTTP direct` : radar, lampes, calibrage, page web, hotspot et OTA n'en dépendent pas.
- `api.reboot_timeout: 0s` : sans client API, ESPHome redémarrerait sinon l'appareil toutes les 15 min.
- Prévoir des **réservations DHCP** (IP fixes) et des URL de lampes en IP, pas en `.local`.
- Perdus : historique, automatisations, notifications ; le mode `Home Assistant` ne fonctionne plus.

## Page web de configuration

`http://<ip du nœud>/` (identifiants `admin` / `web_password`, authentification digest), entités groupées : **Présence**, **Lampes**, **Calibrage**, **Seuils par porte**, **Énergies par porte**, **Système**. Les URL des lampes et l'entité Home Assistant se modifient sans recompiler (les substitutions ne servent que de valeur initiale). Restent à recompiler : `name`, `friendly_name`, `ntp_server`, position. Aperçu : [`docs/maquettes/`](docs/maquettes/).

## Vérification

```bash
pip install esphome==2026.9.1
scripts/check.sh              # tests + esphome config
scripts/check.sh --compile    # + compilation (internet requis pour PlatformIO)
```

La CI GitHub (`.github/workflows/ci.yml`) exécute les mêmes contrôles et **compile** les deux firmwares.

**Statut** : les configurations passent `esphome config` (ESPHome 2026.9.1) et les tests SNTP passent sous CPython. La compilation n'a pas pu être exécutée dans l'environnement de développement (registre PlatformIO inaccessible) : première compilation attendue en CI. Rien n'a été testé sur du matériel.

## Auteur

**Pierre De Dobbeleer** · [@pierrre2db](https://github.com/pierrre2db)

## Licence

MIT
