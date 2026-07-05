#!/usr/bin/env bash
# run-all-kit-v2.sh — Ejecuta los 6 casos con el nuevo kit IREB v2
set -euo pipefail
cd "$(dirname "$0")/.."

KIT="ireb-kit/pipeline.sh"
OUT="resultados/flujo-kit-2"
REQS="../2-requisitos"

echo "=== FLUJO KIT v2 — $(date) ==="

echo "[1/6] appwrite-e3"
"$KIT" repos/appwrite-e3 "$REQS/appwrite/REQ-APPWRITE-10832.md" "$OUT/appwrite-e3" || echo "FAIL"

echo "[2/6] authentik-e1"
"$KIT" repos/authentik-e1 "$REQS/authentik/REQ-AUTHENTIK-10110.md" "$OUT/authentik-e1" || echo "FAIL"

echo "[3/6] cal-e1"
"$KIT" repos/cal-e1 "$REQS/cal/REQ-CALCOM-26801.md" "$OUT/cal-e1" || echo "FAIL"

echo "[4/6] directus-e9"
"$KIT" repos/directus-e9 "$REQS/directus/REQ-DIRECTUS-26646.md" "$OUT/directus-e9" || echo "FAIL"

echo "[5/6] medusa-e5"
"$KIT" repos/medusa-e5 "$REQS/medusa/REQ-MEDUSA-13930.md" "$OUT/medusa-e5" || echo "FAIL"

echo "[6/6] n8n-e5"
"$KIT" repos/n8n-e5 "$REQS/n8n/REQ-N8N-30375.md" "$OUT/n8n-e5" || echo "FAIL"

echo "=== FLUJO KIT v2 COMPLETADO — $(date) ==="
for d in "$OUT"/*/; do
  echo "$(basename "$d"): $(ls "$d"/*.md "$d"/*.patch 2>/dev/null | wc -l) artefactos, diff=$(wc -l < "$d/diff.patch" 2>/dev/null || echo 0)L"
done
