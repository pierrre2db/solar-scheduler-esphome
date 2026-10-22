# 🌞 Solar Scheduler - ESPHome

Contrôleur solaire pour ESP32-C3 : commande un relais selon le lever ou le coucher du soleil, ou à heures fixes.

[![ESPHome](https://img.shields.io/badge/ESPHome-2026.10-blue)](https://esphome.io)
[![ESP32-C3](https://img.shields.io/badge/ESP32--C3-Supported-green)](https://www.espressif.com/en/products/socs/esp32-c3)

> ⚠️ **Version V2 beta** : validée avec `esphome config` (2026.10.0) uniquement. Compilation et test sur carte non faits. À valider avant tout usage sur une charge réelle.

## ✨ Fonctionnalités

- 4 modes : Horaire Fixe, Sunrise, Sunset, Manuel
- Offsets de ±120 minutes pour le lever et le coucher, réglables sans recompiler
- Position (latitude/longitude) configurable
- Interface web et intégration Home Assistant (API chiffrée)

## 🚀 Installation

Prérequis : ESPHome 2026.10 (version de validation), carte ESP32-C3, module relais.

```bash
git clone https://github.com/pierrre2db/solar-scheduler-esphome.git
cd solar-scheduler-esphome
cp secrets.yaml.example secrets.yaml
# Éditer secrets.yaml (clé API : openssl rand -base64 32)
esphome run solar_scheduler.yaml
```

Réglages à faire dans la section `substitutions` en tête de `solar_scheduler.yaml` (recompilation nécessaire) :

| Réglage | Défaut | Rôle |
|---|---|---|
| `latitude`, `longitude` | 50.4674, 4.8675 | Position pour le calcul solaire |
| `relay_pin` | `GPIO4` | Broche du relais (éviter GPIO2/8/9, broches de strapping) |
| `relay_inverted` | `"false"` | `"true"` pour un module relais actif à l'état bas |

Accès : interface web sur le port 80 (utilisateur `admin`, mot de passe `web_password`) ; point d'accès de secours `Solar-Scheduler-AP`.

## ⚙️ Modes

Entité **Mode** (select). Tous les réglages sont des entités modifiables à chaud.

| Mode | Relais ON | Relais OFF |
|---|---|---|
| `Horaire Fixe` | *Heure Fixe (ON)* | *Heure Fixe (OFF)* |
| `Sunrise` | *Heure Fixe (ON)* | Lever du soleil + *Offset Sunrise (min)* |
| `Sunset` | Coucher du soleil + *Offset Sunset (min)* | *Heure Fixe (OFF)* |
| `Manuel` | Commande manuelle | Commande manuelle |

- **Horaire Fixe** : si ON et OFF sont identiques, le relais reste OFF. Une plage qui passe minuit est gérée.
- **Sunrise / Sunset** : une heure fixe est associée à un événement solaire qui se déplace. La durée allumée varie donc avec la saison. Exemple : Sunrise avec ON à 08:00 garde le relais ON jusqu'à environ 23 h par jour en été. Ajuster *Heure Fixe* et les offsets selon la saison.
- **Manuel** : aucune automatisation. Le relais se commande depuis Home Assistant ou l'interface web.

## 🔁 Comportement

- L'état voulu est recalculé au démarrage, après chaque synchronisation horaire, à chaque changement de réglage et toutes les 30 s. Un événement manqué est donc rattrapé.
- **Dans tous les modes sauf Manuel, un changement manuel du relais est annulé en 30 s au plus.** Pour garder le relais dans l'état voulu, passer en `Manuel`.
- Quitter `Manuel` applique le planning **immédiatement** : le relais peut changer d'état tout de suite.
- Le mode et le dernier état du relais sont restaurés après une coupure de courant (`RESTORE_DEFAULT_OFF`). Un relais laissé ON en `Manuel` redevient ON après un redémarrage, sans délai de retour.
- Sans heure valide (Wi-Fi ou SNTP indisponible), le relais garde son dernier état, aucun planning n'est appliqué et un avertissement est écrit dans le journal. Il n'y a pas de repli sur un état sûr.
- Un redémarrage n'est plus déclenché par l'absence de Home Assistant (`api: reboot_timeout: 0s`).

## ⚠️ Limites connues

- **Changement d'heure (été/hiver)** : l'événement à heure fixe peut être décalé d'1 h, au plus jusqu'à son prochain passage (environ 24 h). Concerne Sunrise et Sunset.
- **Latitudes polaires** : sans lever ni coucher, le côté à heure fixe l'emporte (Sunrise reste ON, Sunset reste OFF). Sans effet aux latitudes tempérées.
- **Interface web** : authentification basique en clair sur le port 80. À réserver à un réseau de confiance. Elle permet de commander le relais.
- **Pas de coupe-circuit matériel** : si le firmware se bloque, le relais garde son dernier état.

## 🔌 Sécurité matérielle

- Vérifier la polarité du module relais (`relay_inverted`) à vide, charge débranchée.
- Prévoir une résistance de rappel sur la broche de commande (GPIO4 flotte pendant le reset), pour garder le relais OFF au démarrage.
- Tension secteur : relais dimensionné pour la charge, isolation, fusible et boîtier adaptés. Ce projet ne remplace pas un thermostat ou une sécurité matérielle pour une charge dangereuse si elle reste allumée.

## 🔄 Migration depuis la v1.0.0

- `Sunrise` et `Sunset` ne font plus le cycle jour/nuit complet : voir le tableau des modes.
- Le capteur binaire « État Relais » est supprimé (il doublait le switch « Contrôle Relais »). Mettre à jour les automatisations et tableaux de bord Home Assistant qui l'utilisent.
- Nouveau mode `Manuel`.

Détails dans [`CHANGELOG.md`](CHANGELOG.md).

## 🛠️ Développement

Revue par sous-agents (`/council`) : voir [`.claude/README.md`](.claude/README.md).

## 👤 Auteur

**Pierre De Dobbeleer**
- GitHub: [@pierrre2db](https://github.com/pierrre2db)
- Email: pierre2db@gmail.com

## 📄 Licence

MIT
