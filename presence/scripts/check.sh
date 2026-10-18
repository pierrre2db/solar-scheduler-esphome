#!/usr/bin/env bash
# Vérifie le projet : tests Python, puis validation ESPHome des deux configurations.
# Usage : scripts/check.sh            (tests + esphome config)
#         scripts/check.sh --compile  (ajoute esphome compile, nécessite internet pour PlatformIO)
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== Tests Python =="
python3 -m unittest discover -s tests -v

echo "== Validation ESPHome =="
command -v esphome >/dev/null || { echo "esphome absent : pip install esphome==2026.9.1"; exit 1; }
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
cp esphome/*.yaml "$tmp"/
# la clé d'API de l'exemple n'est pas du base64 valide : on en génère une pour le test
sed "s|^api_key:.*|api_key: \"$(openssl rand -base64 32)\"|" esphome/secrets.yaml.example > "$tmp/secrets.yaml"

for cfg in presence_node lamp_sonoff_basic_r4; do
  esphome config "$tmp/$cfg.yaml" >/dev/null
  echo "OK config $cfg"
done

if [ "${1:-}" = "--compile" ]; then
  for cfg in presence_node lamp_sonoff_basic_r4; do
    esphome compile "$tmp/$cfg.yaml"
    echo "OK compile $cfg"
  done
fi
