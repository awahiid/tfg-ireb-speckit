#!/usr/bin/env bash
# setup.sh — Crea el entorno completo para analisis-automatico
# Uso: bash setup.sh
set -euo pipefail
cd "$(dirname "$0")"

echo "[SETUP] Instalando dependencias del sistema..."
sudo apt-get install -y -qq php-codesniffer shellcheck 2>/dev/null || echo "  (usa 'sudo apt-get install php-codesniffer shellcheck' si no tienes permisos)"

echo "[SETUP] Instalando ESLint (JS/TS)..."
if command -v npm &>/dev/null; then
    sudo npm install -g eslint --silent 2>/dev/null || echo "  (npm no disponible, eslint no se instalara)"
else
    echo "  (npm no encontrado, eslint no se instalara)"
fi

echo "[SETUP] Creando .venv Python..."
python3 -m venv .venv
echo "[SETUP] Instalando dependencias Python..."
.venv/bin/pip install -q -r requirements.txt

echo "[SETUP] OK. Activar con: source .venv/bin/activate"
echo "        Ejecutar: python3 atodo.py"
