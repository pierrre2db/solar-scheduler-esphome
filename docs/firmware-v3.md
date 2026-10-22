# Firmware v3 (batterie + deep sleep)

> **Non compilé, non testé sur carte.** Validé : `esphome config` (2026.10.0) et tests PC de la logique de planification. La compilation du firmware n'a pas pu être faite dans cet environnement (téléchargements ESP-IDF bloqués).

## Fichiers

- [`solar_scheduler_v3.yaml`](../solar_scheduler_v3.yaml) : configuration ESPHome v3.
- [`solar_logic.h`](../solar_logic.h) : calcul de l'état voulu, du prochain événement et de la durée de sommeil (code C++ pur, sans ESPHome).
- [`tests/test_solar_logic.cpp`](../tests/test_solar_logic.cpp) : test sur PC de `solar_logic.h`.
- Secrets : mêmes clés que la v2 sauf `web_password` (plus d'interface web).

## Déroulement d'un réveil

1. Démarrage, connexion Wi-Fi, attente de la synchro SNTP (45 s max).
2. Mesure de la tension batterie.
3. `evaluer` : calcule l'état voulu (mode Horaire Fixe, Sunrise ou Sunset) et la durée de sommeil. Si l'état diffère du dernier état commandé, impulsion SET ou RESET (élévateur ON, impulsion, élévateur OFF). Pas d'impulsion sous 3,5 V.
4. Fenêtre de configuration : 20 s après un réveil minuteur, 120 s après un réveil par bouton. Home Assistant peut pousser des réglages (voir `docs/home-assistant-v3.md`).
5. Nouvelle évaluation, puis deep sleep.

## Sommeil sans RTC

- Deux réveils par événement : si l'événement est à plus de 2 × marge, la carte se réveille avant (marge = 5 min + 10 % de la durée), recale l'heure par SNTP, puis dort jusqu'à l'événement (+ 5 s).
- Réveil périodique maximal : 12 h.
- Dérive de l'horloge RC pendant le sommeil : **non mesurée**.

## Heures fixes et changement d'heure

- Les heures fixes sont reconstruites en **heure locale** (`mktime`, `tm_isdst = -1`) pour chaque jour, ce qui gère le changement d'heure. Cela corrige le défaut de la v2 signalé par le conseil.
- Testé sur PC (fuseau Europe/Brussels) : plage passant minuit, ON = OFF (relais OFF), jour polaire, changements d'heure de mars et d'octobre 2026, durées de sommeil.

## État du relais

- Un relais bistable ne relit pas son état : le dernier état commandé est stocké (`restore_value`, écriture immédiate en flash).
- Au premier démarrage (état inconnu), une impulsion RESET est envoyée.

## Entités Home Assistant

Mode (Horaire Fixe, Sunrise, Sunset, Manuel), offsets, heures fixes, tension batterie, état commandé du relais, commutateur « Garder éveillé ».

## Limites et risques

- Compilation non faite : `sunrise(ESPTime, double)`, `from_epoch_local`, `esp_sleep_get_wakeup_cause`, `deep_sleep.enter` avec durée calculée : à valider.
- Réveil par bouton : l'effet exact de `wakeup_pin` sur l'ESP32-C3 (niveau de réveil, pull-up) est à valider ; la conception prévoit un rappel externe de 100 kΩ.
- Heure système après un réveil de deep sleep : à vérifier. Le firmware attend un indicateur de synchro SNTP explicite (`synced`).
- Les impulsions ont lieu pendant que le Wi-Fi est actif : le pic de courant de la batterie est à mesurer.
- Durée d'impulsion (`pulse_ms`) et temps de démarrage de l'élévateur (`boost_settle_ms`) : valeurs par défaut, à régler d'après la fiche du relais.
- Mode Manuel ou « Garder éveillé » : la carte ne dort plus, consommation élevée.
