#!/usr/bin/env bash
# run-kit-v2-mrs.sh — Kit v2 con MRS de 2.5-prompts (input correcto)
set -euo pipefail
cd "$(dirname "$0")/.."
KIT="ireb-kit/pipeline.sh"
MRS="mrs-inputs"
OUT="resultados/flujo-kit-2"
echo "=== KIT v2 (MRS) — $(date) ==="

for case in appwrite-e3:REQ-APPWRITE-10832 authentik-e1:REQ-AUTHENTIK-10110 cal-e1:REQ-CALCOM-26801 directus-e9:REQ-DIRECTUS-26646 medusa-e5:REQ-MEDUSA-13930 n8n-e5:REQ-N8N-30375; do
  repo="${case%%:*}"
  req="${case##*:}"
  mrs_file="$MRS/$req.txt"
  echo "### $repo ###"
  rm -rf "$OUT/$repo" && mkdir -p "$OUT/$repo"
  "$KIT" "repos/$repo" "$mrs_file" "$OUT/$repo" || echo "FAIL: $repo"
  echo ""
done
echo "=== DONE — $(date) ==="
