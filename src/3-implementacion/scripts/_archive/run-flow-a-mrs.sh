#!/usr/bin/env bash
# run-flow-a-mrs.sh — Flow A con MRS de 2.5-prompts (input correcto)
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHON="/home/awahiid/cloud/mega/proyectos/tfg/.venv/bin/python"
SCRIPT="scripts/pipeline-flow-a.py"
MRS="mrs-inputs"
OUT="resultados/flujo-no-kit"
API="https://api.deepseek.com/v1"
echo "=== FLOW A (MRS) — $(date) ==="

for case in appwrite-e3:REQ-APPWRITE-10832 authentik-e1:REQ-AUTHENTIK-10110 cal-e1:REQ-CALCOM-26801 directus-e9:REQ-DIRECTUS-26646 medusa-e5:REQ-MEDUSA-13930 n8n-e5:REQ-N8N-30375; do
  repo="${case%%:*}"
  req="${case##*:}"
  mrs_text=$(cat "$MRS/$req.txt")
  echo "### $repo ###"
  rm -rf "$OUT/$repo-flow-a" && mkdir -p "$OUT/$repo-flow-a"
  OPENAI_API_BASE="$API" $PYTHON $SCRIPT "repos/$repo" "$mrs_text" "$repo" "$OUT/$repo-flow-a" || echo "FAIL: $repo"
  echo ""
done
echo "=== DONE — $(date) ==="
