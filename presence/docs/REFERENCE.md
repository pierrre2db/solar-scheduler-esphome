# Document produit de référence : Presence Radar ESPHome

Version du document : 0.1 (non publiée) · Auteur : Pierre De Dobbeleer · Langue : français

## 1. Objet

Système de détection de présence par radar mmWave qui allume et éteint des lampes standard par WiFi, sans cloud. Il fonctionne seul (HTTP direct entre appareils) et s'intègre à Home Assistant en option.

Public visé : particulier bricoleur à l'aise avec ESPHome. Le raccordement 230 V est à confier à un électricien si besoin.

## 2. Composition du système

| Élément | Référence | Rôle | Fichier |
|---|---|---|---|
| Nœud radar | ESP32-C3 (carte `esp32-c3-devkitm-1`) + radar LD2410 | Détecte la présence, calibre le radar, commande les lampes | `esphome/presence_node.yaml` |
| Récepteur de lampe | Sonoff BASIC R4 (ESP32-C3) | Commute la lampe, garde l'interrupteur mural | `esphome/lamp_sonoff_basic_r4.yaml` |
| Serveur de temps | Raspberry Pi Pico W (MicroPython) | Sert l'heure en SNTP au réseau local | `pico_w_timesync/` |
| Maquettes | Canvas de design | Aperçu des interfaces | `docs/maquettes/` |

Un nœud radar par pièce, de 1 à 3 lampes par nœud. Le Pico W est facultatif : les nœuds retombent sur `pool.ntp.org`.

## 3. Architecture

```
LD2410 ──UART──> ESP32-C3 ──HTTP POST──> Sonoff BASIC R4 ──> lampe
                    │   └─ (option) API ──> Home Assistant ──> lampe
                    └── SNTP ── Pico W (ou pool.ntp.org)
```

- Radar vers lampe : `POST http://<ip lampe>/light/<id>/turn_on|turn_off` sur l'API REST de `web_server` d'ESPHome, authentification HTTP Basic.
- Trois modes (entité *Mode pilotage lampe*) : `HTTP direct` (défaut), `Home Assistant`, `Les deux`.

## 4. Caractéristiques

### 4.1 Nœud radar

| Paramètre | Valeur |
|---|---|
| Microcontrôleur | ESP32-C3, framework ESP-IDF |
| Liaison radar | UART 256000 baud, 8N1 ; TX `GPIO5`, RX `GPIO6` (substitutions `radar_tx_pin`, `radar_rx_pin`) |
| Alimentation du radar | 5 V (4,5 à 6 V, à confirmer sur la fiche du fabricant) |
| Portes du radar | 9 portes G0 à G8, 0,75 m chacune par défaut (*Résolution distance* réglable) |
| Page web | `http://<ip>/`, version 3, identifiants `admin` et `web_password`, authentification digest |
| Hotspot de secours | SSID `<friendly_name> AP`, ouvert après 60 s sans WiFi |
| Fuseau et position | `Europe/Brussels` ; latitude `50.4674`, longitude `4.8675` (Namur), modifiables dans `substitutions` |

### 4.2 Récepteur Sonoff BASIC R4

| Paramètre | Valeur |
|---|---|
| Relais | `GPIO4` |
| Entrée interrupteur mural (SW) | `GPIO5`, mode « magic switch » : chaque changement d'état inverse la lampe |
| Bouton en façade | `GPIO9` : appui court (50 ms à 1 s) bascule la lampe, appui long (8 à 30 s) force le hotspot |
| LED d'état | `GPIO6` |
| Entité exposée | `light` d'`id` `lampe` |
| État au démarrage | `RESTORE_DEFAULT_OFF` |

### 4.3 Serveur de temps Pico W

| Paramètre | Valeur |
|---|---|
| Protocole | SNTP serveur, UDP 123, stratum 2 |
| Source amont | `pool.ntp.org`, recalage toutes les 60 s |
| Péremption | Cesse de répondre si le dernier calage date de plus de 300 s |
| Précision attendue | Quelques ms à quelques dizaines de ms (gigue WiFi), non mesurée |

## 5. Entités du nœud radar

Regroupées dans la page web.

| Groupe | Entités |
|---|---|
| Présence | *Présence*, *Cible radar*, *Cible en mouvement*, *Cible statique*, *Distance mouvement*, *Distance statique*, *Distance détection*, *Énergie mouvement*, *Énergie statique* |
| Lampes | *Pilotage lampe*, *Mode pilotage lampe*, *Nuit seulement*, *Délai de maintien (s)*, *Lampe 1 URL*, *Lampe 2 URL*, *Lampe 3 URL*, *Lampe entité Home Assistant* |
| Calibrage | *Calibrer (pièce vide)*, *Calibrage durée (s)*, *Calibrage marge*, *Calibrage statut*, *Mode ingénierie* |
| Seuils par porte | *Timeout radar*, *Porte max mouvement*, *Porte max statique*, *Résolution distance*, *G0 à G8 Seuil mouvement*, *G0 à G8 Seuil statique* |
| Énergies par porte | *G0 à G8 Énergie mouvement*, *G0 à G8 Énergie statique* (publiées en mode ingénierie seulement) |
| Système | *Signal WiFi*, *Firmware radar*, *Baud rate radar*, *Bluetooth radar*, *Radar relire paramètres*, *Radar redémarrer*, *Radar reset usine*, *Hotspot WiFi (reset)* |

### Valeurs par défaut

| Entité | Défaut |
|---|---|
| Mode pilotage lampe | `HTTP direct` |
| Pilotage lampe | Activé |
| Nuit seulement | Activé |
| Délai de maintien | 120 s (5 à 1800, pas de 5) |
| Calibrage durée | 60 s (15 à 300) |
| Calibrage marge | 10 (0 à 50) |
| Lampe 1 URL | Valeur de la substitution `lamp_http_base` |
| Lampes 2 et 3 URL | Vides (inutilisées) |
| Lampe entité Home Assistant | Valeur de la substitution `lamp_entity` |

Les champs texte et les nombres sont conservés en mémoire flash : la valeur modifiée dans la page prime ensuite sur les substitutions.

## 6. Comportement

### 6.1 Présence et lampes
1. Le radar signale une cible : *Présence* passe à ON immédiatement.
2. Si *Pilotage lampe* est actif, que le mode n'est pas `Home Assistant` seul, et que la nuit est tombée (ou *Nuit seulement* désactivé), un `turn_on` est envoyé à chaque lampe configurée.
3. Plus de cible : *Présence* repasse à OFF après *Délai de maintien*, et un `turn_off` est envoyé. L'extinction n'est jamais bloquée par *Nuit seulement*.
4. Une requête HTTP échouée est renvoyée une fois après 500 ms (délai d'attente 2 s). Les lampes sont servies l'une après l'autre.

Seuil de nuit : élévation du soleil inférieure à −0,833°. Si l'heure est inconnue, la lampe s'allume (échec sûr).

### 6.2 Calibrage
Pièce vide, pendant *Calibrage durée* : le nœud passe en mode ingénierie, relève le pic d'énergie de chaque porte (mouvement et statique), puis règle chaque seuil à `min(100, pic + marge)`. Les seuils sont écrits dans le radar avec une pause de 300 ms entre chaque commande.

### 6.3 Reconfiguration du WiFi
Sans WiFi pendant 60 s, ou après *Hotspot WiFi (reset)* (ou appui long de 8 s sur le Sonoff), le module ouvre son hotspot. Le portail captif (`http://192.168.4.1`) enregistre le nouveau réseau en flash, prioritaire sur `secrets.yaml`. Le reset enregistre un réseau bidon `hotspot-reset` puis redémarre ; revenir aux valeurs de `secrets.yaml` demande un reflash.

### 6.4 Sans Home Assistant
`api.reboot_timeout: 0s` sur le nœud et sur la lampe, pour éviter un redémarrage toutes les 15 min sans client API.

## 7. Secrets et sécurité

Fichier `esphome/secrets.yaml` (non versionné), modèle `esphome/secrets.yaml.example` :

| Clé | Usage |
|---|---|
| `wifi_ssid`, `wifi_password` | Réseau WiFi |
| `ap_password` | Hotspot de secours (8 caractères minimum) |
| `ota_password` | Mises à jour OTA |
| `web_password` | Page web (`admin`) |
| `api_key` | Chiffrement de l'API (`openssl rand -base64 32`) |
| `lamp_http_basic` | En-tête `Authorization` envoyé aux lampes, identique à `web_server.auth` de la lampe |

Points d'attention :
- Page web du nœud : authentification digest. Page web de la lampe : HTTP Basic imposé (`type: basic`), car le nœud envoie un en-tête `Authorization: Basic`. Il transite en clair sur le réseau local : à réserver à un réseau de confiance.
- Toutes les lampes d'un nœud partagent le même `lamp_http_basic`.
- Réserver des adresses IP fixes (DHCP) et utiliser des IP dans les URL des lampes, pas des noms `.local`.
- Le montage 230 V se fait disjoncteur coupé, tension vérifiée absente, et idéalement par un électricien. Le module est monté au point lumineux ou dans la boîte de dérivation où phase et neutre sont permanents.

## 8. Mise en service

1. `cd esphome && cp secrets.yaml.example secrets.yaml` et remplir.
2. Flasher le Pico W (MicroPython) avec `../pico_w_timesync/`, lui donner une IP fixe, la reporter dans `ntp_server`.
3. Flasher le Sonoff BASIC R4 par adaptateur série 3,3 V (bouton maintenu à la mise sous tension) avec `esphome/lamp_sonoff_basic_r4.yaml`, puis OTA.
4. Flasher le nœud radar avec `esphome run esphome/presence_node.yaml`.
5. Saisir l'URL de chaque lampe dans la page web du nœud (`http://<ip lampe>/light/lampe`).
6. Fixer le capteur à sa place définitive, vider la pièce, lancer *Calibrer (pièce vide)*, puis valider en bougeant et en restant assis immobile.

## 9. Dépannage

| Symptôme | Piste |
|---|---|
| La lampe ne réagit pas | Vérifier l'URL, l'`id` de l'entité côté lampe, et que `lamp_http_basic` correspond à `web_server.auth` de la lampe ; lire le journal du nœud (avertissement « Lampe HTTP … échec ») |
| Lampe qui s'éteint avec quelqu'un d'immobile | Baisser *Calibrage marge* (5) puis recalibrer, ou augmenter *Délai de maintien* |
| Fausses détections | Augmenter la marge (15 à 20), réduire *Porte max mouvement/statique*, éloigner ventilateurs et rideaux |
| La lampe ne s'allume pas de jour | *Nuit seulement* est actif : le désactiver ou attendre la nuit |
| Module hors ligne après un reset | Se connecter à son hotspot et saisir le réseau |
| Heure fausse | Vérifier le Pico W et `ntp_server` ; `pool.ntp.org` sert de secours |

## 10. Statut de validation

| Élément | État |
|---|---|
| `presence_node.yaml`, `lamp_sonoff_basic_r4.yaml` | Validés par `esphome config` (ESPHome 2026.9.1, `scripts/check.sh`) ; **jamais compilés ni flashés** dans l'environnement de développement (registre PlatformIO inaccessible). La CI GitHub les compile à chaque push |
| Lambdas C++ (calibrage, reset WiFi) | Relues, non compilées localement ; couvertes par la compilation en CI |
| Module SNTP du Pico W (`ntp_packet.py`) | 7 tests unitaires sous CPython (`tests/`) ; `main.py` non testé sur Pico W |
| Câblage et brochages | Brochages du Sonoff BASIC R4 d'après la fiche ESPHome ; polarité et niveau de tension de l'entrée SW à vérifier sur le matériel |
| Montage matériel complet | Non testé |

Avertissements ESPHome connus : le mot de passe OTA est déconseillé au profit d'un chiffrement OTA basé sur la clé d'API (choix conservé pour la compatibilité des outils).

## 11. Limites connues

- Une lampe hors ligne retarde les suivantes de 5 s au plus (envois en file d'attente).
- Maximum de 3 lampes par nœud ; une seule entité Home Assistant (ou liste séparée par des virgules).
- Le serveur de temps (`ntp_server`), le nom du nœud et la position se changent par recompilation.
- Le reset du hotspot n'est pas annulable sans reflash ni saisie du WiFi dans le portail.
- Pas de fusion de plusieurs radars dans une même pièce.

## 12. Références

- Fiche ESPHome du Sonoff BASIC R4 : https://devices.esphome.io/devices/sonoff-basic-r4-v1.0
- Composants ESPHome utilisés : `ld2410`, `uart`, `web_server`, `http_request`, `sntp`, `sun`, `captive_portal`, `text`, `number`, `select`, `switch`, `button`
- Historique : `../CHANGELOG.md` · Interfaces : `maquettes/` · Contrôles : `../scripts/check.sh` et `../.github/workflows/ci.yml`
