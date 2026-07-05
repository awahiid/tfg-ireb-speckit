#!/usr/bin/env bash
# run-all-flow-a.sh — Ejecuta Flow A (baseline, sin IREB) para los 6 casos
# Usa DeepSeek v4-pro vía API directa (Python + openai SDK)
set -euo pipefail

cd "$(dirname "$0")/.."

PYTHON="/home/awahiid/cloud/mega/proyectos/tfg/.venv/bin/python"
SCRIPT="scripts/pipeline-flow-a.py"
API_BASE="https://api.deepseek.com/v1"

echo "============================================"
echo "  FLOW A — 6 casos con DeepSeek v4-pro"
echo "  Inicio: $(date)"
echo "============================================"
echo ""

# Case 1: appwrite-e3
echo "### [1/6] appwrite-e3 ###"
OPENAI_API_BASE="$API_BASE" $PYTHON $SCRIPT \
  repos/appwrite-e3 \
  "Cached document lists — Document list queries can be cached with configurable TTL (#10832)." \
  appwrite-e3 resultados/appwrite-e3-flow-a || echo "FAILED: appwrite-e3"

# Case 2: authentik-e1
echo ""
echo "### [2/6] authentik-e1 ###"
OPENAI_API_BASE="$API_BASE" $PYTHON $SCRIPT \
  repos/authentik-e1 \
  "admin: system api: fix FIPS status schema by @rissson in #10110" \
  authentik-e1 resultados/authentik-e1-flow-a || echo "FAILED: authentik-e1"

# Case 3: cal-e1
echo ""
echo "### [3/6] cal-e1 ###"
OPENAI_API_BASE="$API_BASE" $PYTHON $SCRIPT \
  repos/cal-e1 \
  "fix(api): use cal.com for bookingUrl in platform organizations by @dhairyashiil in #26812" \
  cal-e1 resultados/cal-e1-flow-a || echo "FAILED: cal-e1"

# Case 4: directus-e9
echo ""
echo "### [4/6] directus-e9 ###"
OPENAI_API_BASE="$API_BASE" $PYTHON $SCRIPT \
  repos/directus-e9 \
  "Added restriction of allowed MIME types to the system file upload interface (#26646 by @AlexGaillard)" \
  directus-e9 resultados/directus-e9-flow-a || echo "FAILED: directus-e9"

# Case 5: medusa-e5
echo ""
echo "### [5/6] medusa-e5 ###"
OPENAI_API_BASE="$API_BASE" $PYTHON $SCRIPT \
  repos/medusa-e5 \
  "feat(product): add SKU search support to admin API by @bqst in #13930" \
  medusa-e5 resultados/medusa-e5-flow-a || echo "FAILED: medusa-e5"

# Case 6: n8n-e5
echo ""
echo "### [6/6] n8n-e5 ###"
OPENAI_API_BASE="$API_BASE" $PYTHON $SCRIPT \
  repos/n8n-e5 \
  "MongoDB Node: Validate update key value type" \
  n8n-e5 resultados/n8n-e5-flow-a || echo "FAILED: n8n-e5"

echo ""
echo "============================================"
echo "  FLOW A COMPLETADO"
echo "  Fin: $(date)"
echo "============================================"
echo ""
echo "Resultados:"
for d in resultados/*-flow-a; do
  count=$(ls "$d"/*.md "$d"/*.patch "$d"/*.txt 2>/dev/null | wc -l)
  echo "  $d: $count artefactos"
done
