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
- `Sunrise` : relais OFF au lever du soleil + offset.
- `Sunset` : relais ON au coucher du soleil + offset.
- Offsets en minutes (-120 à +120), réglables sans recompiler.
- Au démarrage, le relais est replacé dans l'état attendu pour l'heure courante.
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

## 👤 Auteur

**Pierre De Dobbeleer**
- GitHub: [@pierrre2db](https://github.com/pierrre2db)
- Email: pierre2db@gmail.com

## 📄 Licence

MIT
