# Conception matérielle v3 (batterie + relais bistable)

> **Statut : proposition de conception, rien n'est monté ni testé.** Les valeurs viennent de recherches web (extraits de fiches et d'annonces) et de calculs approximatifs. **Les fiches PDF n'ont pas pu être ouvertes** (accès réseau bloqué). Vérifier chaque point dans la fiche du fabricant avant de commander ou de câbler.
> **Sécurité secteur** : ce document ne remplace pas une revue par une personne compétente. Distances d'isolement, fusible, boîtier et conformité sont à votre charge.

## Choix retenus

- **Relais** : Hongfa **HFE20 bistable à 2 bobines en 5 V** (achetable à l'unité sur Amazon.fr), bobines alimentées par un **élévateur 5 V commuté pendant les impulsions**. Voir « Décision relais ». Le Same Sky PRL3-3V-DC-1C (bobines 3 V, sans élévateur) reste la cible idéale mais est introuvable à l'unité.
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
- Tension de la cellule : 3,0 à 4,2 V. Les bobines ne sont **pas** branchées sur la batterie (tension variable, 3,0 à 4,2 V). Elles sont alimentées par l'élévateur 5 V commuté (voir « Décision relais »). L'ESP et le Wi-Fi sont à l'arrêt pendant l'impulsion.
- Le **diviseur de mesure de la batterie** se branche sur la **cellule** (BAT+), pas sur `3V3` : 2 × 1 MΩ donne au plus 2,1 V à 4,2 V sur l'ADC. Mesurer BAT+ via GPIO1.
- Seuils logiciels : sous environ **3,5 V**, plus d'impulsion ni de Wi-Fi (le régulateur ne tient plus 3,3 V en dessous de ~3,5 V d'après son fonctionnement standard). Alerte à environ 3,6 V. La protection de la cellule coupe vers 2,5 V : le firmware doit agir bien avant.
- Zone de coupure du régulateur de la carte : à lire dans sa fiche (régulateur de type LDO ; non vérifié sur votre modèle).

## Décision relais (à confirmer sur fiche)

**Constat** : les relais bistables 3 V pour le secteur sont introuvables à l'unité en France.
- PRL3-3V-DC-1C : seul listing trouvé = Farnell, minimum 2000 pièces, environ 9 semaines (valeurs 15 A / 250 mW qui contredisent les 10 A / 800 mW trouvés ailleurs).
- [Hongfa HFE20-1/3-1HD-L2(257)](https://www.futureelectronics.com/p/4021461) : stock 0, délai 24 semaines, minimum 10 pièces (34,10 USD les 10).
- Panasonic DE2A-L2-3V : listing indien, **8 A seulement** ; DE1A-L2-3V (10 A) sans stock confirmé ; [DK1A-L2-3V-F chez RS](https://uk.rs-online.com/web/p/signal-relays/2474304) en rupture temporaire.

**Choix** : **relais Hongfa HFE20 bistable à 2 bobines en 5 V** (Amazon.fr, 16 à 20 A selon la variante), avec une **alimentation 5 V commutée uniquement pendant les impulsions**.
- Pourquoi : c'est la seule piste achetable à l'unité aujourd'hui sans délai de plusieurs mois.
- Variante à privilégier : HFE20-1/005-1HD-L2 (5 V, 2 bobines). L'annonce [HFE20-3-5…L2](https://www.amazon.fr/Magnetic-Latching-HFE20-3-5-24-1HST-L2-MQXFCZUX/dp/B0DBD2CWR3) a un titre ambigu (5 V, 12 V et 24 V mélangés) : **vérifier la variante exacte** choisie et la fiche Hongfa avant achat.
- Repli : variante 12 V ([HFE20-1/012-1HD-L2](https://www.amazon.fr/Relais-circuits-imprim%C3%A9s-HFE20-1-012-1HD-L2/dp/B07121WYJY)), avec un élévateur vers 12 V.

**Conséquences sur le circuit**
- Un élévateur Li-ion (3,0 à 4,2 V) → 5 V alimente les bobines. Il reste **éteint** hors impulsion : un élévateur allumé en permanence consomme souvent plusieurs centaines de µA à quelques mA, ce qui ruinerait l'autonomie.
- Mise en marche de l'élévateur : GPIO10 → MOSFET inverseur → interrupteur côté batterie (ou broche EN du module si elle existe). **Module précis à choisir sur fiche** ; les modules « MT3608 » courants n'ont pas de broche EN.
- Séquence d'une impulsion : élévateur ON → attendre la stabilisation de la tension → impulsion SET ou RESET (Q1 ou Q2) → élévateur OFF. Jamais en même temps que le Wi-Fi.
- Courant et tension d'impulsion de la bobine 5 V, tension de SET minimale : à lire dans la fiche (**non lus**). Q1, Q2 et D1, D2 se dimensionnent avec ce courant.
- Les diodes de roue libre D1, D2 se branchent sur le rail +5 V commuté (cathode côté +5 V).
- Fuite à l'état éteint (diode de corps de l'élévateur, MOSFET) : à mesurer.
- Le pic de courant sur le régulateur de la carte disparaît : les bobines ne sont plus alimentées par `3V3`.

## Relais : impulsion de commande (valeurs PRL3, à titre de référence)

- Pour le PRL3 3 V (non retenu) : courant par bobine ≈ tension / 11,5 Ω : environ **280 mA à 3,2 V**, environ 313 mA à 3,6 V. Cohérent avec 800 mW typiques.
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
   │        3V3 ─┬── (rien d'autre : pas de RTC)
   │             ├── C1 470 µF + C2 100 nF
   │             └── (bobines : voir « Pilotage », alimentées en +5 V commuté)
  GND ───────────┴──────────────── GND

 Panneau 5-6 V ──[diode]── chargeur Li-ion 1S ── BAT+ / GND
```

Pilotage des bobines :

```
       +5V (élévateur commuté, GPIO10 → ON pendant l'impulsion)
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
| K1 | Hongfa HFE20 bistable 2 bobines 5 V (ex. HFE20-1/005-1HD-L2) | Variante, brochage, courant de bobine : fiche |
| Q1, Q2 | MOSFET canal N, seuil bas, ≥ 1 A, Rds(on) faible à 2,5 V (ex. AO3400A, **à vérifier**) | Courant de bobine 5 V : fiche (non lu) |
| D1, D2 | Diode Schottky 1 A (ex. SS14) | Roue libre, cathode côté +5 V |
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
| U3 | Élévateur Li-ion → 5 V, avec broche d'arrêt (EN) ou interrupteur côté batterie | **À choisir sur fiche**, courant de repos à l'arrêt à mesurer |
| Q3 | MOSFET de commande de l'élévateur | Piloté par GPIO10 |

## Mesure de la batterie

- Diviseur 2 × 1 MΩ de **BAT+** vers GND, milieu sur **GPIO1** (ADC), 100 nF en parallèle de la résistance basse. Environ 2 µA à 4,2 V.
- Seuils : voir « Alimentation retenue ». Alerte publiée pendant la fenêtre de configuration ; aucune impulsion ni Wi-Fi sous le seuil bas.

## Affectation des broches (proposée)

| GPIO | Rôle |
|---|---|
| 6 | SET relais (via Q1) |
| 7 | RESET relais (via Q2) |
| 1 | ADC batterie |
| 10 | Marche/arrêt de l'élévateur 5 V |
| 3 | Bouton de réveil (RTC) |
| 2, 8, 9 | Évitées (strapping, LED, BOOT) |

## Horloge (pas de RTC)

- Décision : **pas de RTC externe**. L'heure vient du SNTP, recalée à chaque réveil avec Wi-Fi.
- Le C3 compte le temps de sommeil avec une horloge RC interne **peu précise**. Sur un long sommeil la dérive peut atteindre plusieurs minutes (valeur non mesurée) ; un événement raté de quelques minutes n'est pas dramatique pour un lever/coucher, mais l'est pour une heure fixe stricte.
- Stratégie proposée, **deux réveils par événement** :
  1. Réveil de marge : environ 10 % de la durée de sommeil avant l'événement, plus quelques minutes. Connexion Wi-Fi, SNTP, calcul de la durée restante.
  2. Court sommeil jusqu'à l'événement (marge de dérive très réduite), puis impulsion SET ou RESET.
- Avec un ON et un OFF par jour : 4 réveils Wi-Fi par jour.
- Si le Wi-Fi est absent au réveil de marge, le firmware garde l'heure estimée et applique l'événement à l'heure estimée.
- À mesurer sur la carte réelle : dérive du sommeil sur 12 h, durée de connexion Wi-Fi.

## Estimation de consommation (à mesurer)

| Poste | Courant moyen |
|---|---|
| Carte Mini en deep sleep | ~43 µA (une source, à vérifier) |
| Diviseur batterie | ~2 µA |
| **Total en sommeil** | **~45 µA, soit ~1,1 mAh/jour** |
| Réveils Wi-Fi (4 × 5 s × 100 mA, voir « Horloge ») | ~0,6 mAh/jour |
| Impulsions relais | négligeable |

Total estimé : environ 1,7 mAh/jour, soit environ 900 jours théoriques sur 1500 mAh avant autodécharge. **Si la carte garde une LED allumée, le courant monte à plusieurs mA et l'autonomie s'effondre** : mesurer d'abord.

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
- Dérive de l'horloge RC entre deux synchronisations SNTP (compensée par un réveil de marge, voir « Horloge »).
- Heure système d'ESPHome après un réveil de deep sleep : non vérifié.
- Tenue diélectrique, distances d'isolement et brochage du PRL3 : non lus.
- Protection contre l'inversion de polarité de la batterie.
- Sécurité secteur (isolation, fusible, boîtier) : non couverte.

## Questions ouvertes

1. Charge exacte : tension, courant, type (résistive ou inductive). Le contact est annoncé 10 A / 277 VAC ; une charge inductive demande une marge.
2. ~~Batterie et recharge~~ : panneau 5 à 6 V / 0,5 à 1 W + Li-ion 1S protégée retenus. Reste à choisir le module chargeur précis (coupure basse température).
3. Modèle exact de la carte Mini (variante, présence d'une LED d'alimentation).
4. ~~RTC externe ?~~ **Pas de RTC** : resynchronisation SNTP à chaque réveil (voir « Horloge »).
5. Fiche officielle du PRL3 : brochage, impulsion minimale, tenue diélectrique, distances d'isolement.

## Disponibilité en France (recherches Amazon.fr, à vérifier sur les fiches en direct)

Les prix et les stocks changent : vérifier chaque annonce avant d'acheter. Rien n'a été commandé ni testé.

| Pièce | Amazon.fr | Remarque |
|---|---|---|
| Carte ESP32-C3 Super Mini | [oui](https://www.amazon.fr/TECNOULAB-d%C3%A9veloppement-Supermini-Bluetooth-ESP32-C3/dp/B0CLY3TTKN) (aussi [lots de 2 à 5](https://www.amazon.fr/Youmile-JK-YM-735-P-carte-d%C3%A9veloppement-ESP32-C3/dp/B0D89YXMN3)) | Environ 6 à 10 € l'unité. Cartes de marques variées : même modèle sur le papier, **LED et régulateur à vérifier** sur la carte reçue. |
| **Relais PRL3-3V-DC-1C** | **Non trouvé** | Seul un listing [Farnell via agrégateur](https://www.findchips.com/search/3vdc) : **minimum 2000 pièces, délai ~9 semaines**, et avec des caractéristiques (15 A, 250 mW) qui **contredisent** les 10 A / 800 mW trouvés ailleurs. Vérifier sur Farnell, Mouser, RS ou DigiKey en direct, quantité unitaire. |
| Relais bistables 2 bobines sur Amazon.fr | [Hongfa HFE20-1/012-1HD-L2](https://www.amazon.fr/Relais-circuits-imprim%C3%A9s-HFE20-1-012-1HD-L2/dp/B07121WYJY) (**12 V**, 20 A) ; [HFE20-3-5…L2](https://www.amazon.fr/Magnetic-Latching-HFE20-3-5-24-1HST-L2-MQXFCZUX/dp/B0DBD2CWR3) (**5 V**, 16 A) | **Aucun en 3 V trouvé.** Une bobine 5 V ou 12 V exige un élévateur de tension pour les impulsions : la consommation et la complexité montent. |
| Module chargeur solaire CN3791 | [oui](https://www.amazon.fr/Uadme-Contr%C3%B4leur-Chargeur-Batterie-Fonction/dp/B0CW9V7WW6) (aussi [ECSiNG, 2 pièces](https://www.amazon.fr/ECSiNG-Compatible-CN3791-Chargeur-Monocellule/dp/B0H12SYN5S)) | 4 à 15 €. Prendre la version **6 V** pour un panneau 6 V. **Coupure sous 0 °C non confirmée** : vérifier la présence d'une sonde NTC sur le module. |
| Panneau solaire 6 V 1 W | [oui](https://www.amazon.fr/Panneau-Solaire-Polysilicium-Chargeur-Bricolage/dp/B08THTGHG6) (lots de 3, environ 17 €) | Annoncé ~166 mA à 6 V. |
| Cellule Li-ion 18650 protégée | Beaucoup d'annonces, qualité très variable | Les capacités annoncées sont souvent gonflées ; une annonce vue indique « 597 Volts ». Préférer une marque connue, **vérifier la protection (PCB) et la coupure basse**, avec support. |
| MOSFET AO3400A | [oui](https://www.amazon.fr/20PCS-AO3400A-MOSFET-SOT23-AO3400/dp/B01CCU0TVK) (SOT-23, lots) | Soudure SMD. Vérifier la fiche pour Vgs de seuil et Rds(on) à 2,5 V. |
| Condensateur 470 µF 10 V | [oui](https://www.amazon.fr/5x-Condensateur-470uf-6-3x12mm-Chengxing/dp/B0793V75XK) (lot de 5, ~2 €) | Choisir faible ESR si possible. |
| Diodes SS14, PTC, support 18650, bouton, résistances | **Non recherché** | À chercher. |

**Point d'attention** : le PRL3-3V-DC-1C n'est pas disponible à l'unité sur Amazon.fr. Le choix retenu est un HFE20 5 V (voir « Décision relais »).
