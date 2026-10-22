# Conception matérielle v3 (batterie + relais bistable)

> **Statut : proposition de conception, rien n'est monté ni testé.** Les valeurs viennent de recherches web (annonces de distributeurs) et de mon estimation. Vérifier chaque point dans la fiche technique du fabricant avant de commander ou de câbler.
> **Sécurité secteur** : ce document ne remplace pas une revue par une personne compétente. Distances d'isolement, fusible, boîtier et conformité sont à votre charge.

## Hypothèses

- Alimentation par batterie 1S LiFePO4 (2,8 à 3,6 V), sans régulateur.
- Module ESP32-C3 nu (pas de carte de développement : LED et régulateur consomment trop).
- Relais bistable à 2 bobines (SET / RESET), bobine 3 V.
- Un événement ON et un événement OFF par jour. Réveil par minuteur, plus un bouton pour ouvrir une fenêtre de configuration (Wi-Fi + API + OTA).
- Charge supposée sur le secteur : à préciser (tension, courant, type).

## Choix du relais

Critères : bistable (aucun courant de maintien), bobine 3 V, contact calibré pour la charge avec marge, isolation bobine-contact adaptée au secteur.

| Candidat | Bobine | Contact annoncé | État de la vérification |
|---|---|---|---|
| [Hongfa HFE20-1/3-1HD-L2(257)](https://www.futureelectronics.com/p/6100989) | 3 VDC, 30 Ω annoncés | 20 A, SPST | Annonce de distributeur seulement. « L2 » = 2 bobines **non confirmé**. Tension de contact (250 VAC) non confirmée. Lien exact de l'annonce non vérifié. |
| [Same Sky PRL3-3V-DC-1C](https://www.sameskydevices.com/product/relays/power-relays/prl3-3v-dc-1c) | 3 VDC, 2 bobines, 11,5 Ω chacune annoncés | 10 A à 277 VAC annoncés | Page et fiche annoncées par la recherche, **pages non lisibles ici** (accès réseau bloqué). |
| [Panasonic DE2a-L2-3V](https://manualmachine.com/nais/de1al45v/3917643-datasheet) | 3 VDC, 2 bobines | 10 A 250 VAC pour la famille ; **variante 3 V non confirmée** | Fiche non lisible ici. |
| [Panasonic série DK](https://uk.rs-online.com/web/p/signal-relays/2474304?gb=s) | 3 VDC, 2 bobines | 10 A annoncés, **tension de contact non précisée** | Annonce RS Components seulement. |

À éviter :
- **Module DFRobot « Gravity Magnetic Latching Relay »** ([annonce](https://core-electronics.com.au/gravity-magnetic-latching-relay-for-esp32-arduino.html)) : courant statique annoncé d'environ 0,75 mA. Sur batterie, cela représente environ 18 mAh par jour, soit plus de 30 fois le budget visé. Contact non annoncé pour le secteur. Utiliser un relais nu, pas ce module.
- Relais Omron G2R bistables à 2 bobines trouvés en 5 V ou 12 V seulement, pas en 3 V ([exemple](https://novapart.co/products/G2RK1A%20DC12/general-purpose-relay-g2r-series-power-latching/)) : il faudrait un élévateur de tension.

**Choix provisoire** : HFE20-1/3-1HD-L2 si sa fiche confirme 2 bobines, 250 VAC et l'isolation bobine-contact ; sinon PRL3-3V-DC-1C ou DE2a-L2-3V. **Aucun n'est validé.**

### Impulsion de commande (ordre de grandeur)

- Courant de bobine ≈ tension de batterie / résistance. Avec 3,2 V :
  - 30 Ω → environ 107 mA
  - 11,5 Ω → environ 280 mA
- Durée de l'impulsion : minimale donnée par la fiche (prévoir environ 20 à 50 ms). Énergie par impulsion : de l'ordre de 0,002 à 0,004 mAh, négligeable.
- Le pic de 280 mA du PRL3 pèse sur la batterie et le MOSFET, mais ne coïncide pas avec le Wi-Fi si le firmware sépare les deux.

## Architecture

```
 LiFePO4 1S (2,8 à 3,6 V)
   │
   ├── F1 fusible/PTC ──┬────────────── 3V3 ──┬── ESP32-C3 (module nu)
   │                    │                     ├── RTC (option)
   │               C1 470 µF + C2 100 nF      ├── diviseur batterie
   │                    │                     └── bobines relais (SET / RESET)
  GND ──────────────────┴────────────── GND
```

- Pas de régulateur : l'ESP32-C3 accepte environ 3,0 à 3,6 V. Aucun courant de repos de régulateur.
- Variante Li-ion 1S : régulateur 3,3 V à très faible courant de repos et ≥ 500 mA. On perd le bas de la plage de la batterie.
- C1 près de l'ESP : absorbe les pics Wi-Fi (jusqu'à environ 350 mA).

## Pilotage du relais (2 bobines)

```
        3V3 ─────────┬───────────────┬───────────
                     │               │
                 [Bobine SET]    [Bobine RESET]
                     │ D1 ◄─┐        │ D2 ◄─┐
                     ├──────┘        ├──────┘
                     │               │
                  Drain Q1        Drain Q2
 GPIO6 ──[1 kΩ]── Gate Q1   GPIO7 ──[1 kΩ]── Gate Q2
                  │ [100 kΩ]          │ [100 kΩ]
                  GND                 GND
```

- Q1, Q2 : MOSFET canal N à seuil bas (bien passant à 3 V), courant de drain ≥ 3 fois celui d'une bobine (≥ 1 A si PRL3).
- D1, D2 : diodes de roue libre sur chaque bobine, cathode côté 3V3.
- 100 kΩ gate-masse **indispensable** : les GPIO du C3 flottent au reset et en deep sleep.
- Interverrouillage logiciel : jamais les deux bobines ensemble ; impulsion de 20 à 50 ms (selon la fiche) ; les deux GPIO à 0 avant de dormir.
- Variante une bobine : pilote en pont en H à veille ultra-basse, broches de veille à zéro en sommeil.

## Mesure de la batterie

- Diviseur 2 × 1 MΩ du 3V3 vers GND, point milieu sur **GPIO1** (ADC), 100 nF en parallèle de la résistance basse. Courant ≈ 1,6 µA.
- Seuil d'alerte (par exemple 3,1 V) publié pendant la fenêtre de configuration.

## Réveil et bouton

- Bouton vers GND sur **GPIO3** (broche RTC, réveil du deep sleep), rappel de 100 kΩ vers 3V3, 100 nF anti-rebond.
- Un appui ouvre la fenêtre de configuration (1 à 2 min).

## Horloge

- Le C3 garde l'heure en deep sleep avec une horloge RC interne **peu précise** : risque de dérive de plusieurs minutes sur des sommeils de plusieurs heures.
- Option A : resynchronisation SNTP à chaque réveil (quelques secondes de Wi-Fi).
- Option B : RTC externe à très faible consommation (RV-3028-C7, PCF8563 ou RV-8803), I2C sur **GPIO10** (SDA) et **GPIO5** (SCL), rappels de 4,7 kΩ. Compatibilité ESPHome à vérifier pour chaque puce.
- **À éviter : DS3231** sur VCC. Il consomme de l'ordre de 150 à 200 µA hors pile de secours, soit environ 4 mAh par jour.

## Affectation des broches (proposée)

| GPIO | Rôle |
|---|---|
| 6 | SET relais (via Q1) |
| 7 | RESET relais (via Q2) |
| 1 | ADC batterie |
| 3 | Bouton de réveil |
| 10 / 5 | I2C RTC (option) |
| 2, 8, 9 | Évitées (strapping) |

## Estimation de consommation (à mesurer)

| Poste | Courant moyen |
|---|---|
| ESP32-C3 en deep sleep | ~5 µA |
| RTC | ~0,3 µA |
| Diviseur batterie | ~1,6 µA |
| **Total en sommeil** | **~7 µA, soit ~0,17 mAh/jour** |
| Réveils Wi-Fi (3 × 5 s × 100 mA) | ~0,4 mAh/jour |
| Impulsions relais | négligeable |

Total estimé : environ 0,6 mAh/jour. Hypothèse : module nu, sans LED ni régulateur. L'autodécharge de la cellule domine en pratique.

## Changements firmware prévus

- Supprimer l'`interval` de 30 s et le Wi-Fi permanent.
- Nouveau script « prochain événement » : calcule l'instant du prochain ON/OFF et la durée de sommeil.
- `deep_sleep` avec réveil par minuteur et par broche.
- Pilotage du relais par impulsions (SET / RESET), état mémorisé, impulsion de remise à un état connu au premier démarrage.
- Capteur de tension batterie.
- Retrait de `web_server`.
- Le mode Manuel garde la carte éveillée (consommation élevée tant qu'il est actif).

## Risques ouverts

- Chute de tension de la batterie pendant les pics Wi-Fi ou l'impulsion (brownout).
- Dérive de l'horloge RC sans RTC externe.
- Comportement de l'heure système d'ESPHome après un réveil de deep sleep : non vérifié.
- État du relais inconnu après une panne en pleine impulsion ; un contact auxiliaire permet de le relire.
- Protection contre l'inversion de polarité de la batterie (diode Schottky avec chute de tension, ou MOSFET canal P).
- Sécurité secteur (isolation, fusible, boîtier) : non couverte.

## Questions ouvertes

1. Charge exacte : tension, courant, type (résistive, inductive).
2. Batterie : LiFePO4 ou Li-ion, capacité.
3. RTC externe, ou resynchronisation SNTP à chaque réveil ?
4. Fiche officielle du relais retenu : coils, tension de contact, résistance de bobine, impulsion minimale, isolation bobine-contact.
