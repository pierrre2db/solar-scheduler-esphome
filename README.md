# 🌞 Solar Scheduler - ESPHome

Contrôleur solaire intelligent pour ESP32-C3.

[![ESPHome](https://img.shields.io/badge/ESPHome-Compatible-blue)](https://esphome.io)
[![ESP32-C3](https://img.shields.io/badge/ESP32--C3-Supported-green)](https://www.espressif.com/en/products/socs/esp32-c3)

## ✨ Fonctionnalités

- 🌅 Mode Sunrise
- 🌇 Mode Sunset
- ⏰ Mode Horaire Fixe
- 📍 Géolocalisation configurable
- ⚙️ Offsets ±120 minutes
- 🌐 Interface Web
- 🏠 Compatible Home Assistant

## ⚙️ Fonctionnement

- Entité **Mode** (select) : `Horaire Fixe`, `Sunrise` ou `Sunset`.
- `Horaire Fixe` : relais ON à *Heure Fixe (ON)*, OFF à *Heure Fixe (OFF)*.
- `Sunrise` : relais ON à *Heure Fixe (ON)*, OFF au lever du soleil + *Offset Sunrise*.
- `Sunset` : relais ON au coucher du soleil + *Offset Sunset*, OFF à *Heure Fixe (OFF)*.
- `Manuel` : aucune automatisation, le relais se commande à la main (Home Assistant ou interface web). Dans les autres modes, un changement manuel est annulé en 30 s.
- ⚠️ Sunrise et Sunset associent une heure fixe à un événement solaire mobile : la durée allumée varie avec la saison (ex. Sunrise avec ON 08:00 : relais ON jusqu'à ~23 h/jour en été). Ajuster *Heure Fixe* et les offsets selon la saison.
- Sans heure valide (SNTP jamais synchronisé), le relais garde son dernier état. Un changement d'heure (été/hiver) peut décaler d'1 h l'événement à heure fixe pendant une nuit.
- Testé avec `esphome config` 2026.10.0 ; compilation et test sur carte à faire par l'utilisateur.
- Offsets en minutes (-120 à +120), réglables sans recompiler.
- L'état voulu est recalculé au démarrage, après chaque synchro horaire, à chaque changement de réglage et toutes les 30 s : un événement manqué est rattrapé.
- Tant que l'heure n'est pas synchronisée, le relais garde son dernier état (`RESTORE_DEFAULT_OFF`). Vérifier la polarité du module relais (`relay_inverted`).
- Latitude/longitude, broche et polarité du relais : section `substitutions` en tête de `solar_scheduler.yaml` (recompilation nécessaire).
- Relais par défaut sur `GPIO4` (éviter GPIO2/8/9, broches de strapping de l'ESP32-C3).

## 🚀 Installation
```bash
git clone https://github.com/pierrre2db/solar-scheduler-esphome.git
cd solar-scheduler-esphome
cp secrets.yaml.example secrets.yaml
# Éditer secrets.yaml (clé API : openssl rand -base64 32)
esphome run solar_scheduler.yaml
```

## 🗳️ Conseil de revue

Skill `/council` : 4 sous-agents (`council-esphome`, `council-hardware`, `council-scheduling`, `council-skeptic`) votent puis se critiquent, et un verdict est rendu.

- Dans une session sur ce repo : `/council` suivi de la question, ou `/council` seul pour passer le diff en revue.
- Le skill est dans le repo (`.claude/`), il marche aussi dans les sessions cloud.
- Un plugin du catalogue reste possible plus tard avec `/plugin`.

## 👤 Auteur

**Pierre De Dobbeleer**
- GitHub: [@pierrre2db](https://github.com/pierrre2db)
- Email: pierre2db@gmail.com

## 📄 Licence

MIT
