#!/usr/bin/env bash
# obtener-ultimos-resultados.sh — Busca el resultado mas reciente de cada caso
# y escribe las rutas en obtener-ultimos-resultados.txt
#
# Uso: bash scripts/obtener-ultimos-resultados.sh
# Salida: scripts/obtener-ultimos-resultados.txt (una ruta por linea)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RES_DIR="$SCRIPT_DIR/../../3-implementacion/resultados"
OUT="$SCRIPT_DIR/obtener-ultimos-resultados.txt"

FLOWS=(C0 C1 C2 C3)
REPOS=(appwrite authentik calcom directus medusa n8n)

: > "$OUT"

for flow in "${FLOWS[@]}"; do
    for repo in "${REPOS[@]}"; do
        dir="$RES_DIR/$flow/$repo"
        [ ! -d "$dir" ] && continue
        latest=""; latest_path=""
        for datedir in "$dir"/*/; do
            [ ! -d "$datedir" ] && continue
            for timedir in "$datedir"*/; do
                [ ! -d "$timedir" ] && continue
                ts="$(basename "$datedir")-$(basename "$timedir")"
                if [ "$ts" \> "$latest" ] || [ -z "$latest" ]; then
                    latest="$ts"; latest_path="$timedir"
                fi
            done
        done
        if [ -n "$latest_path" ]; then
            echo "${latest_path%/}" >> "$OUT"
        fi
    done
done

echo "OK: $(wc -l < "$OUT") rutas escritas en $OUT"
