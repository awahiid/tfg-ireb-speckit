#!/usr/bin/env bash
# ===========================================================================
# capturar-metricas.sh — Extrae tokens, coste y tiempo de sesiones opencode
#
# Uso:
#   ./capturar-metricas.sh <output-dir> [session-id-1 session-id-2 ...]
#
# Si no se pasan IDs, busca sesiones recientes con 'opencode session list'.
# Genera: metrics.json + costs.csv en <output-dir>
# ===========================================================================
# Sin set -e: opencode session list puede fallar sin ser crítico

OUTPUT_DIR="${1:-.}"
shift 2>/dev/null || true
SESSION_IDS=("$@")

# ── Si no se pasan IDs, listar sesiones recientes ──
if [[ ${#SESSION_IDS[@]} -eq 0 ]]; then
    echo "[INFO] Buscando sesiones recientes..."
    mapfile -t SESSION_IDS < <(opencode session list 2>/dev/null | grep '^ses_' | head -20 | awk '{print $1}')
    echo "[INFO] Encontradas ${#SESSION_IDS[@]} sesiones"
fi

TOTAL_INPUT=0
TOTAL_OUTPUT=0
TOTAL_TOKENS=0
TOTAL_COST=0
TOTAL_MESSAGES=0
MODEL=""
PROVIDER=""

echo "" > "$OUTPUT_DIR/costs.csv"
echo "session_id,messages,input_tokens,output_tokens,total_tokens,cost_usd,model" > "$OUTPUT_DIR/costs.csv"

for sid in "${SESSION_IDS[@]}"; do
    echo -n "[INFO] $sid ... "
    
    TMPFILE=$(mktemp)
    opencode export "$sid" > "$TMPFILE" 2>/dev/null || { echo "vacío"; rm -f "$TMPFILE"; continue; }
    [[ ! -s "$TMPFILE" ]] && { echo "vacío"; rm -f "$TMPFILE"; continue; }
    
    METRICS=$(python3 -c "
import json
with open('$TMPFILE') as f:
    data = json.load(f)
    msgs = data.get('messages', [])
    total_in = 0
    total_out = 0
    total_tok = 0
    total_cost = 0.0
    model = ''
    provider = ''
    for m in msgs:
        info = m.get('info', {})
        tok = info.get('tokens', {})
        if tok:
            total_in += tok.get('input', 0)
            total_out += tok.get('output', 0)
            total_tok += tok.get('total', 0)
        total_cost += info.get('cost', 0.0)
        if not model:
            model = info.get('model', {}).get('modelID', '')
            provider = info.get('model', {}).get('providerID', '')
    print(f'{len(msgs)}|{total_in}|{total_out}|{total_tok}|{total_cost}|{model}|{provider}')
" 2>/dev/null)
    rm -f "$TMPFILE"
    
    [[ -z "$METRICS" ]] && { echo "sin datos"; continue; }
    
    IFS='|' read -r msgs inp out tok cost model provider <<< "$METRICS"
    
    TOTAL_MESSAGES=$((TOTAL_MESSAGES + msgs))
    TOTAL_INPUT=$((TOTAL_INPUT + inp))
    TOTAL_OUTPUT=$((TOTAL_OUTPUT + out))
    TOTAL_TOKENS=$((TOTAL_TOKENS + tok))
    TOTAL_COST=$(python3 -c "print(f'{float($TOTAL_COST) + float($cost):.6f}')")
    [[ -z "$MODEL" && "$model" != "unknown" ]] && { MODEL="$model"; PROVIDER="$provider"; }
    
    echo "$msgs msgs, ${inp} in, ${out} out, ${tok} tot, \$$cost"
    echo "$sid,$msgs,$inp,$out,$tok,$cost,$provider/$model" >> "$OUTPUT_DIR/costs.csv"
done

# ── Generar metrics.json ──
cat > "$OUTPUT_DIR/metrics.json" << JSONEOF
{
  "sessions_analyzed": ${#SESSION_IDS[@]},
  "total_messages": $TOTAL_MESSAGES,
  "total_tokens": $TOTAL_TOKENS,
  "input_tokens": $TOTAL_INPUT,
  "output_tokens": $TOTAL_OUTPUT,
  "total_cost_usd": $TOTAL_COST,
  "model": "${PROVIDER}/${MODEL}",
  "date": "$(date -Iseconds)"
}
JSONEOF

echo ""
echo "══════════════════════════════════════════════════"
echo "  📊 MÉTRICAS AGREGADAS"
echo "══════════════════════════════════════════════════"
echo "  Sesiones:     ${#SESSION_IDS[@]}"
echo "  Mensajes:     $TOTAL_MESSAGES"
echo "  Input tokens: $(printf "%'d" $TOTAL_INPUT)"
echo "  Output tokens:$(printf "%'d" $TOTAL_OUTPUT)"
echo "  Total tokens: $(printf "%'d" $TOTAL_TOKENS)"
echo "  Coste:        \$$TOTAL_COST"
echo "  Modelo:       ${PROVIDER}/${MODEL}"
echo "══════════════════════════════════════════════════"
echo ""
echo "  Detalle: $OUTPUT_DIR/costs.csv"
echo "  Resumen: $OUTPUT_DIR/metrics.json"
