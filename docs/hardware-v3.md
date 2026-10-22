# Conception matérielle v3 (batterie + relais bistable)

> **Statut : proposition de conception, rien n'est monté ni testé.** Les valeurs viennent de recherches web (extraits de fiches et d'annonces) et de calculs approximatifs. **Les fiches PDF n'ont pas pu être ouvertes** (accès réseau bloqué). Vérifier chaque point dans la fiche du fabricant avant de commander ou de câbler.
> **Sécurité secteur** : ce document ne remplace pas une revue par une personne compétente. Distances d'isolement, fusible, boîtier et conformité sont à votre charge.

## Choix retenus

- **Relais** : Same Sky **PRL3-3V-DC-1C** — bistable à 2 bobines, inverseur (SPDT). Annoncé : [10 A à 277 VAC, 30 VDC max](https://www.sameskydevices.com/product/relays/power-relays/prl3-3v-dc-1c), bobines de 11,5 Ω chacune, tension de SET/RESET minimale 2,4 V, puissance de bobine typique 800 mW ([fiche](https://www.sameskydevices.com/product/resource/prl3.pdf), valeurs d'après un extrait de recherche). **Tension de tenue diélectrique et distances d'isolement non trouvées** : à lire dans la fiche. La fiche indique que le relais part en usine à l'état RESET mais peut arriver à l'état SET après transport.
- **Carte** : ESP32-C3 Mini du commerce (type « Super Mini »). Une source mesure environ [43 µA en deep sleep pour la version standard](https://mischianti.org/esp32-c3-supermini-plus-v2-high-resolution-pinout-datasheet-and-specs/) ; la version « Plus » avec LED RGB sur GPIO8 consomme 0,6 à 1,5 mA. **Mesure unique d'une source, sur une autre variante de carte** : à vérifier sur la carte réelle.
- **Alimentation** : panneau solaire + cellule **Li-ion 1S** (voir « Alimentation retenue »).

## Cartes « Mini » : points d'attention

- Elles ont un **régulateur 3,3 V** et au moins une **LED** (puissance et/ou GPIO8) : ce sont les fuites en deep sleep. Mesurer le courant de repos réel avant tout, et retirer ou couper la LED d'alimentation si elle existe.
- Le régulateur est sur la broche `5V`/`VCC` (entrée 3,3 à 6 V annoncée, sortie `3V3`, environ 400 mA max annoncés par la source ci-dessus).
- Broches exposées (type Super Mini) : GPIO0 à 10, 20 (RX), 21 (TX). **GPIO2** (strapping), **GPIO8** (LED sur certaines cartes) et **GPIO9** (bouton BOOT) à éviter.
- Réveil de deep sleep par broche : seulement GPIO0 à 5 (domaine RTC) sur l'ESP32-C3.

### Deux façons d'alimenter la carte

| | Option A : LiFePO4 → broche `3V3` | Option B : Li-ion/LiPo → broche `5V`/`VCC` |
|---|---|---|
| Principe | On injecte la batterie (3,0 à 3,6 V) directement sur `3V3`, le régulateur est contourné. | Le régulateur de la carte fait 3,3 V à partir de 3,5 à 4,2 V. |
| Avantage | Pas de perte ni de courant de repos du régulateur. | Cas d'usage standard de la carte. |
| Risque | **Courant inverse dans le régulateur de la carte** (non vérifié) : retirer le régulateur ou ajouter une diode d'isolement, selon sa fiche. | Courant de repos du régulateur ; en dessous d'environ 3,5 V la sortie chute. |
| Bobine | Alimentée directement par la batterie (3,0 à 3,6 V). | Alimentée par `3V3` (400 mA max annoncés, pic de bobine ≈ 280 mA + ESP) : à tester ; sinon bobine sur la batterie avec résistance série (à calculer). |

**Retenu : option B** (Li-ion 1S sur `5V`/`VCC`), car les chargeurs solaires du commerce visent le Li-ion. L'option A reste documentée mais n'est plus la base.

## Alimentation retenue : panneau solaire + Li-ion 1S

**Dimensionnement** (estimations)
- Besoin : environ 1,5 mAh/jour à 3,7 V, soit environ 6 mWh/jour (voir « Estimation de consommation »).
- Panneau : **5 à 6 V, 0,5 à 1 W**, monocristallin ou polycristallin, étanche. Même en hiver en Belgique (rendement très réduit), une telle puissance fournit largement plus que 6 mWh/jour. Un panneau plus gros n'apporte rien.
- Batterie : **une cellule Li-ion 18650 protégée (circuit de protection intégré), 1S, environ 2000 à 3000 mAh**, avec support. En théorie plus d'un an d'autonomie sans soleil ; le surdimensionnement sert de marge pour l'hiver et l'autodécharge.

**Chargeur solaire** : module pour Li-ion 1S (4,2 V) acceptant une entrée de panneau 5 à 6 V. Critères :
- **Coupure de charge sous 0 °C** (NTC ou module intégré). Charger un Li-ion sous 0 °C l'abîme ; l'hiver belge le permet. Placer la cellule à l'intérieur du boîtier, à l'abri du gel.
- Diode anti-retour sur le panneau, protection contre l'inversion de polarité.
- Idéalement un chemin d'alimentation (la charge n'alimente pas directement le circuit).
- Exemples de familles à comparer (**non vérifiés ici**) : circuits type CN3065 ou CN3791 (conçus pour le solaire), modules TP4056 (simples, sans MPPT ni coupure basse température selon le module). Lire la fiche du module précis.

**Conséquences sur le circuit**
- Tension de la cellule : 3,0 à 4,2 V. Les bobines 3 V ne doivent **pas** être branchées sur la batterie (4,2 V = 140 % de la tension nominale). Elles sont alimentées par la sortie `3V3` du régulateur de la carte, avec C1 près des bobines ; pic de 280 mA, régulateur annoncé à environ 400 mA. L'ESP et le Wi-Fi sont à l'arrêt pendant l'impulsion.
- Le **diviseur de mesure de la batterie** se branche sur la **cellule** (BAT+), pas sur `3V3` : 2 × 1 MΩ donne au plus 2,1 V à 4,2 V sur l'ADC. Mesurer BAT+ via GPIO1.
- Seuils logiciels : sous environ **3,5 V**, plus d'impulsion ni de Wi-Fi (le régulateur ne tient plus 3,3 V en dessous de ~3,5 V d'après son fonctionnement standard). Alerte à environ 3,6 V. La protection de la cellule coupe vers 2,5 V : le firmware doit agir bien avant.
- Zone de coupure du régulateur de la carte : à lire dans sa fiche (régulateur de type LDO ; non vérifié sur votre modèle).

## Relais : impulsion de commande

- Courant par bobine ≈ tension / 11,5 Ω : environ **280 mA à 3,2 V**, environ 313 mA à 3,6 V. Cohérent avec 800 mW typiques.
- Marge de tension : SET/RESET garantis à 2,4 V minimum. Arrêt de l'impulsion si la batterie passe sous environ 3,0 V.
- Durée de l'impulsion : la valeur minimale est dans la fiche (non lue) ; prévoir environ 20 à 50 ms.
- Énergie par impulsion : environ 0,003 mAh, négligeable. Le pic de 280 mA ne doit pas coïncider avec le Wi-Fi : firmware séquentiel.
- Au premier démarrage : envoyer une impulsion RESET pour partir d'un état connu (le relais peut être en SET après transport).

## Schéma

```
 Batterie (Li-ion 1S, 3,0 à 4,2 V)
   │
   ├── F1 PTC ──┬──────────────── BAT+ ──┬── ESP32-C3 Mini (broche 5V/VCC)
   │            │                        └── diviseur batterie (GPIO1)
   │      (régulateur de la carte)
   │            │
   │        3V3 ─┬── RTC (option), pull-ups
   │             ├── C1 470 µF + C2 100 nF
   │             └── bobines PRL3 (SET / RESET)
  GND ───────────┴──────────────── GND

 Panneau 5-6 V ──[diode]── chargeur Li-ion 1S ── BAT+ / GND
```

Pilotage des bobines :

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

## Liste de composants (provisoire)

| Réf. | Composant | Remarque |
|---|---|---|
| K1 | Same Sky PRL3-3V-DC-1C | Brochage SET/RESET/COM/NO/NC : fiche |
| Q1, Q2 | MOSFET canal N, seuil bas, ≥ 1 A, Rds(on) faible à 2,5 V (ex. AO3400A, **à vérifier**) | Courant 280 mA par bobine |
| D1, D2 | Diode Schottky 1 A (ex. SS14) | Roue libre, cathode côté 3V3 |
| R1, R2 | 1 kΩ | Gate |
| R3, R4 | 100 kΩ | Gate vers masse, **indispensable** |
| C1 | 470 µF, faible ESR, ≥ 6,3 V | Pics Wi-Fi et bobine |
| C2 | 100 nF | Découplage |
| F1 | PTC 750 mA tenue (à calculer) | Protection |
| R5, R6 | 2 × 1 MΩ | Diviseur batterie |
| C3 | 100 nF | ADC |
| SW1 | Bouton poussoir + 100 kΩ rappel + 100 nF | Réveil |
| BT1 | Cellule Li-ion 18650 protégée, 1S, 2000 à 3000 mAh + support | Voir « Alimentation retenue » |
| PV1 | Panneau solaire 5 à 6 V, 0,5 à 1 W | + diode anti-retour |
| U1 | Module chargeur solaire Li-ion 1S avec coupure sous 0 °C | **À choisir sur fiche** |
| U2 | RTC RV-3028-C7 ou PCF8563 (option) | Compatibilité ESPHome à vérifier |

## Mesure de la batterie

- Diviseur 2 × 1 MΩ de **BAT+** vers GND, milieu sur **GPIO1** (ADC), 100 nF en parallèle de la résistance basse. Environ 2 µA à 4,2 V.
- Seuils : voir « Alimentation retenue ». Alerte publiée pendant la fenêtre de configuration ; aucune impulsion ni Wi-Fi sous le seuil bas.

## Affectation des broches (proposée)

| GPIO | Rôle |
|---|---|
| 6 | SET relais (via Q1) |
| 7 | RESET relais (via Q2) |
| 1 | ADC batterie |
| 3 | Bouton de réveil (RTC) |
| 4 / 5 | I2C RTC (option) : SDA / SCL |
| 2, 8, 9 | Évitées (strapping, LED, BOOT) |

## Horloge

- Le C3 garde l'heure en deep sleep avec une horloge RC interne **peu précise** : dérive possible de plusieurs minutes sur des sommeils de plusieurs heures.
- Option A : resynchronisation SNTP à chaque réveil (quelques secondes de Wi-Fi).
- Option B : RTC externe à très faible consommation (RV-3028-C7, PCF8563, RV-8803). **À éviter : DS3231** sur VCC (de l'ordre de 150 à 200 µA).

## Estimation de consommation (à mesurer)

| Poste | Courant moyen |
|---|---|
| Carte Mini en deep sleep | ~43 µA (une source, à vérifier) |
| Diviseur batterie | ~2 µA |
| RTC | ~0,3 µA |
| **Total en sommeil** | **~45 µA, soit ~1,1 mAh/jour** |
| Réveils Wi-Fi (3 × 5 s × 100 mA) | ~0,4 mAh/jour |
| Impulsions relais | négligeable |

Total estimé : environ 1,5 mAh/jour, soit environ 1000 jours théoriques sur 1500 mAh avant autodécharge. **Si la carte garde une LED allumée, le courant monte à plusieurs mA et l'autonomie s'effondre** : mesurer d'abord.

## Changements firmware prévus

- Supprimer l'`interval` de 30 s et le Wi-Fi permanent.
- Script « prochain événement » : calcule l'instant du prochain ON/OFF et la durée de sommeil.
- `deep_sleep` avec réveil par minuteur et par broche.
- Pilotage par impulsions SET/RESET (une seule bobine à la fois), état mémorisé, RESET au premier démarrage.
- Capteur de tension batterie, impulsion refusée sous le seuil.
- Retrait de `web_server`.
- Mode Manuel : garde la carte éveillée (consommation élevée tant qu'il est actif).

## Risques ouverts

- Courant inverse dans le régulateur de la carte si on injecte la batterie sur `3V3` (option A).
- Chute de tension de la batterie pendant les pics Wi-Fi ou l'impulsion de 280 mA.
- Dérive de l'horloge RC sans RTC externe.
- Heure système d'ESPHome après un réveil de deep sleep : non vérifié.
- Tenue diélectrique, distances d'isolement et brochage du PRL3 : non lus.
- Protection contre l'inversion de polarité de la batterie.
- Sécurité secteur (isolation, fusible, boîtier) : non couverte.

## Questions ouvertes

1. Charge exacte : tension, courant, type (résistive ou inductive). Le contact est annoncé 10 A / 277 VAC ; une charge inductive demande une marge.
2. ~~Batterie et recharge~~ : panneau 5 à 6 V / 0,5 à 1 W + Li-ion 1S protégée retenus. Reste à choisir le module chargeur précis (coupure basse température).
3. Modèle exact de la carte Mini (variante, présence d'une LED d'alimentation).
4. RTC externe, ou resynchronisation SNTP à chaque réveil ?
5. Fiche officielle du PRL3 : brochage, impulsion minimale, tenue diélectrique, distances d'isolement.
