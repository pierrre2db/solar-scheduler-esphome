# Capteurs de présence radar → lampes (WiFi)

Nœuds **ESP32-C3 + radar mmWave LD2410** qui détectent la présence et pilotent des lampes
via Home Assistant. Un **Pico W** sert de serveur de temps local (SNTP) pour caler les nœuds.

```
 LD2410 ──UART──> ESP32-C3 ──WiFi/API──> Home Assistant ──> lampe (light.*)
                     ^
                     └── SNTP ── Pico W (serveur de temps local)
```

## Fichiers
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
4. Dans Home Assistant : autoriser les actions de l'appareil (*Paramètres → Appareils → le nœud → Configurer → Autoriser l'appareil à effectuer des actions Home Assistant*), sinon la lampe ne s'allume pas.

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
