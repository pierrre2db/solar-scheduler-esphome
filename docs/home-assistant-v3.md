# Intégration Home Assistant pour la v3 (carte en deep sleep)

> **Statut : proposition, non testée.** Les noms d'entités et les actions ESPHome ci-dessous sont à vérifier sur votre installation et dans la documentation ESPHome de votre version.

## Contexte

- Home Assistant est déjà installé. Le téléphone (USB-C) n'a qu'à avoir l'appli **Home Assistant Companion** : aucun matériel particulier.
- En v3, la carte dort la plupart du temps. Elle ne se connecte à l'API qu'aux réveils (marge avant un événement, événement, fenêtre de configuration).

## Comportement attendu dans Home Assistant

- Les entités de l'appareil (Mode, offsets, heures fixes, relais, tension batterie) apparaissent **« indisponibles »** pendant le sommeil. C'est normal.
- Au réveil, la carte se reconnecte à l'API ; les entités redeviennent disponibles quelques secondes.
- Le relais lui-même reste dans son dernier état (relais bistable) : pas de consommation, pas d'action nécessaire.

## Réglages poussés par Home Assistant

Les réglages voulus (mode, offsets, heures) vivent dans des **entités d'aide** de Home Assistant (`input_select`, `input_number`, `input_datetime`). Une automatisation les envoie à la carte dès qu'elle se reconnecte.

Principe (noms à adapter) :

```yaml
automation:
  - alias: "Solar scheduler : pousser les réglages au réveil"
    trigger:
      - platform: state
        entity_id: sensor.solar_scheduler_tension_batterie   # devient disponible au réveil
        from: "unavailable"
    action:
      - service: select.select_option
        target: { entity_id: select.solar_scheduler_mode }
        data: { option: "{{ states('input_select.solar_mode') }}" }
      - service: number.set_value
        target: { entity_id: number.solar_scheduler_offset_sunrise_min }
        data: { value: "{{ states('input_number.solar_offset_sunrise') }}" }
      - service: number.set_value
        target: { entity_id: number.solar_scheduler_offset_sunset_min }
        data: { value: "{{ states('input_number.solar_offset_sunset') }}" }
```

- Le réglage s'applique **au prochain réveil**, pas tout de suite.
- Côté firmware : les valeurs sont conservées en mémoire (`restore_value`) pour survivre aux réveils.

## Fenêtre de configuration

- Déclenchée par un **bouton** (GPIO3, réveil du deep sleep) ou périodiquement (par exemple toutes les 6 ou 12 h).
- Pendant la fenêtre, Home Assistant peut **garder la carte éveillée** : ESPHome offre une action pour empêcher le deep sleep (`deep_sleep.prevent`) et une pour le relancer (`deep_sleep.allow`), exposables en commutateur via l'API. À confirmer pour votre version d'ESPHome.
- La carte se rendort à la fin de la fenêtre ou quand le commutateur « garder éveillé » repasse à OFF. Prévoir un délai maximal pour éviter de vider la batterie.

## Notifications sur le téléphone

Exemples d'automatisations (à créer dans Home Assistant) :
- **Batterie basse** : tension < 3,6 V au dernier réveil → notification sur l'appli Companion.
- **Pas de réveil** : la carte ne s'est pas connectée depuis plus de X heures → notification.
- **Relais non commuté** : événement prévu passé sans mise à jour de l'état → notification.

## Réseau

- Wi-Fi de la carte en **2,4 GHz**, sur le même réseau que Home Assistant (ou route vers lui).
- Le téléphone peut être sur un autre réseau si Home Assistant est accessible à distance (Nabu Casa, VPN).
- Clé API chiffrée (`api_key`) inchangée par rapport à la v2.

## Limites

- Pas de commande en direct du relais : la carte dort. Pour une commande immédiate, ouvrir la fenêtre de configuration (bouton ou « garder éveillé »).
- Le mode `Manuel` garde la carte éveillée tant qu'il est actif : **consommation élevée**. À utiliser brièvement.
- Entités « indisponibles » = comportement normal, pas une panne. Les tableaux de bord peuvent afficher « dernier état connu » via des capteurs de type horodatage.
