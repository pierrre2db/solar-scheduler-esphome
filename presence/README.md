# Capteurs de présence radar → lampes (WiFi)

Nœuds **ESP32-C3 + radar mmWave LD2410** qui détectent la présence et pilotent des lampes,
soit **en direct en HTTP** (sans Home Assistant), soit via Home Assistant. Un **Pico W** sert de serveur de temps local (SNTP) pour caler les nœuds.

```
 LD2410 ──UART──> ESP32-C3 ──WiFi, HTTP POST──────────> lampe ESPHome (web_server)
                     │                      └─ ou API ──> Home Assistant ──> lampe
                     ^
                     └── SNTP ── Pico W (serveur de temps local)
```

## Fichiers
- `lamp_sonoff_basic_r4.yaml` : module relais Sonoff BASIC R4 qui reçoit les ordres HTTP du radar.
- `presence_node.yaml` : un nœud par pièce (copier, changer `name`, `friendly_name`, `lamp_entity`).
- `pico_w_timesync/` : serveur SNTP MicroPython (`main.py`, `ntp_packet.py`, `secrets.py.example`).
- Les secrets WiFi/API/OTA sont ceux de `../secrets.yaml.example`.

## Câblage LD2410 → ESP32-C3
| LD2410 | ESP32-C3 |
|---|---|
| VCC | 5V (4,5–6 V, **pas 3,3 V**) |
| GND | GND |
| TX | GPIO6 (`radar_rx_pin`) |
| RX | GPIO5 (`radar_tx_pin`) |

Le LD2410 est en 256000 baud ; UART0 reste au logger.

## Mise en route
1. `cp ../secrets.yaml.example ../secrets.yaml` puis remplir (clé API : `openssl rand -base64 32`).
2. Pico W : flasher MicroPython, copier `main.py`, `ntp_packet.py` et `secrets.py` (depuis l'exemple). Réserver une IP fixe, la mettre dans `ntp_server`.
3. `esphome run presence_node.yaml`.
4. Seulement pour le mode `Home Assistant` : autoriser les actions de l'appareil (*Paramètres → Appareils → le nœud → Configurer → Autoriser l'appareil à effectuer des actions Home Assistant*), sinon la lampe ne s'allume pas.

## Config WiFi sans reflasher (hotspot de secours)
Valable pour le nœud radar et la lampe Sonoff.
1. Si le WiFi est introuvable pendant 60 s (box changée, nouveau mot de passe), le module ouvre un hotspot **« <friendly_name> AP »** protégé par `ap_password`.
2. Se connecter dessus avec un téléphone : le portail captif s'ouvre (sinon `http://192.168.4.1`).
3. Choisir le réseau et saisir le mot de passe : ils sont enregistrés en mémoire flash et utilisés en priorité aux démarrages suivants, même si `secrets.yaml` contient d'autres valeurs.
4. Le module redémarre et se reconnecte ; le hotspot se ferme.

**Forcer le hotspot** : bouton **Hotspot WiFi (reset)** (nœud et lampe) ou, sur la lampe Sonoff, appui long de 8 s sur le bouton du module (appui court = bascule la lampe). Le module enregistre un réseau bidon (`hotspot-reset`), redémarre, ne le trouve pas et ouvre son hotspot après 60 s. Tant que tu n'as pas saisi ton vrai réseau dans le portail, il reste hors ligne (l'interrupteur mural de la lampe fonctionne quand même). Pour revenir aux valeurs de `secrets.yaml`, reflasher.

## Si Home Assistant disparaît
Le système tourne sans lui (mode `HTTP direct`, défaut) :
- Radar → lampe en HTTP direct, calibrage, page web, hotspot WiFi et OTA (`esphome run` en ligne de commande) ne dépendent pas de HA.
- `api: reboot_timeout: 0s` : sans client API, ESPHome redémarrerait sinon l'appareil toutes les 15 min (la lampe se rééteindrait).
- L'heure vient du Pico W ou de `pool.ntp.org`. Si aucun n'est joignable après un redémarrage, *Nuit seulement* laisse la lampe s'allumer (échec sûr) au lieu de rester éteinte.
- À prévoir : **réservations DHCP** (IP fixes) pour lampes, Pico W et nœuds, et URL de lampes en IP (pas en `.local`).
- Perdus avec HA : historique, automatisations et notifications. Le mode `Home Assistant` ne fonctionne évidemment plus (garder `HTTP direct` ou `Les deux`).

## Page web de configuration
Le nœud radar sert une page à `http://<ip du nœud>/` (identifiants `admin` / `web_password`), avec les entités regroupées :
- **Présence** : distances, énergies, cibles, état *Présence*.
- **Lampes** : *Pilotage lampe*, *Mode pilotage lampe*, *Nuit seulement*, *Délai de maintien*, les trois champs **Lampe N URL** et **Lampe entité Home Assistant**.
- **Calibrage** : durée, marge, bouton *Calibrer*, statut, mode ingénierie.
- **Seuils par porte** / **Énergies par porte** : réglage fin G0–G8.
- **Système** : signal WiFi, firmware radar, resets, *Hotspot WiFi (reset)*.

Les URL des lampes et l'entité Home Assistant se modifient dans cette page, sans recompiler : les substitutions `lamp_http_base*` et `lamp_entity` ne servent que de valeur initiale au premier démarrage, ensuite la valeur enregistrée prime.

Reste à recompiler (OTA) : `name`, `friendly_name`, `ntp_server`, position du soleil. Le serveur de temps n'est pas modifiable à chaud : le composant SNTP d'ESPHome fixe ses serveurs à la compilation, et le changer à l'exécution passerait par l'API ESP-IDF interne, que je n'ai pas pu compiler ni tester ici. `pool.ntp.org` reste de toute façon en secours.

## Pilotage de la lampe
Entité **Mode pilotage lampe** (réglable sans recompiler) :
- `HTTP direct` (défaut) : le nœud envoie `POST http://<ip lampe>/light/<id>/turn_on|turn_off` à l'API REST de `web_server`. Fonctionne sans Home Assistant. 1 nouvel essai après 500 ms en cas d'échec.
- `Home Assistant` : action `homeassistant.turn_on|turn_off` sur `lamp_entity`.
- `Les deux` : les deux chemins, utile en transition.

Côté nœud : URL de la lampe dans le champ **Lampe 1 URL** de la page web (valeur initiale : `lamp_http_base`, ex. `http://192.168.1.60/light/lampe`), et le secret `lamp_http_basic` (voir `../secrets.yaml.example`).

**Lampe sur interrupteur sans neutre : Sonoff BASIC R4** (ESP32-C3), monté au point lumineux ou dans la boîte de dérivation où L et N sont permanents, interrupteur mural sur l'entrée SW. Config prête : `lamp_sonoff_basic_r4.yaml` (relais GPIO4, entrée SW GPIO5, bouton GPIO9, `web_server` avec auth, entité `lampe`). Le mode « magic switch » inverse la lampe à chaque changement de l'interrupteur (simple ou va-et-vient) : pas de conflit avec le radar. Le premier flash se fait par adaptateur série 3,3 V (bouton maintenu à la mise sous tension), puis OTA. Avec ce fichier : `lamp_http_base: http://<ip lampe>/light/lampe`.

Côté lampe (appareil ESPHome), il faut `web_server` et une entité dont l'`id` correspond à `lamp_http_base` :
```yaml
web_server:
  port: 80
  version: 3
  auth:
    username: admin
    password: !secret web_password

light:   # ou switch: pour un relais
  - platform: binary
    name: "Lampe"
    id: lampe
    output: sortie_lampe
```
- `lamp_http_basic` = `Basic ` + base64(`utilisateur:motdepasse`), identique à `web_server.auth` de la lampe : `printf 'Basic %s' "$(printf 'admin:MotDePasse' | base64)"`.
- Pour un relais : mettre `switch` à la place de `light` dans `lamp_http_base`.
- L'authentification HTTP Basic passe en clair sur le réseau local : à réserver à un réseau de confiance.
- **Plusieurs lampes** : jusqu'à 3 par nœud via les champs **Lampe 1/2/3 URL** (vides = inutilisés ; valeurs initiales `lamp_http_base`, `lamp_http_base_2`, `lamp_http_base_3`). Elles partagent le même `lamp_http_basic`, donc le même mot de passe `web_server`. Les envois se font l'un après l'autre : une lampe hors ligne retarde les suivantes de ~5 s au plus. En mode `Home Assistant`, `lamp_entity` accepte plusieurs entités séparées par des virgules (`light.a, light.b`).

## Calibrage
Objectif : que le radar ne voie ni les ventilateurs, ni les rideaux, ni les plantes, tout en restant sensible.

1. **Placer** le capteur en dernier choix définitif : fixe, orienté vers la zone utile, loin d'un mur métallique, pas collé à l'antenne WiFi. Tout déplacement oblige à recalibrer.
2. **Vider la pièce** (personne, animaux compris), laisser le chauffage/ventilateurs dans leur état habituel.
3. Régler *Calibrage durée* (60 s par défaut) et *Calibrage marge* (10 par défaut).
4. Appuyer sur **Calibrer (pièce vide)** puis sortir. *Calibrage statut* indique l'avancement.
5. Le script relève, par porte (G0–G8, ~0,75 m chacune), le pic d'énergie mouvement/statique et règle **seuil = pic + marge** (plafonné à 100). Les seuils sont stockés dans le radar.
6. **Valider** : entrer, bouger, puis s'asseoir immobile (la détection statique est plus faible). Si la présence se perd, baisser la marge (5) ; si fausses détections, l'augmenter (15–20) ou réduire *Porte max mouvement/statique*.
7. Recalibrer en cas de changement de meuble ou de position. *Radar reset usine* remet les valeurs d'origine.

Autres réglages utiles :
- *Délai de maintien (s)* : durée sans cible avant d'éteindre (120 s par défaut, évite le clignotement).
- *Nuit seulement* : n'allume que sous le seuil du soleil (élévation < -0,833°, comme le planificateur solaire).
- *Pilotage lampe* : coupe l'automatisme sans toucher au reste.
- Désactiver *Bluetooth radar* après la mise en service.

## Synchronisation : limites réelles
- Pour allumer une lampe, **aucune synchro fine n'est nécessaire** : le radar rafraîchit à ~10 Hz et le WiFi ajoute 5–50 ms.
- Le serveur Pico W sert surtout à avoir des horodatages cohérents entre nœuds (fusion de plusieurs radars, logs). Précision attendue : quelques ms à dizaines de ms (jitter WiFi).
- `power_save_mode: none` est activé côté ESP32 pour réduire la latence.
- Si le Pico W tombe, les nœuds retombent sur `pool.ntp.org` (déclaré en secours dans `time:`).
- Plusieurs radars 24 GHz qui se font face peuvent se perturber : éviter de les orienter l'un vers l'autre.
