#!/usr/bin/env bash
# ===========================================================================
# pipeline-c3.sh — C3: Vibe Coding PURO (1 prompt, sin SpecKit, sin IREB)
#
# Uso: ./pipeline-c3.sh <repo> <req-id>
#   repo   = nombre del directorio en repos/ (ej: appwrite)
#   req-id = número del requisito (ej: 10832)
# ===========================================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

[[ $# -lt 2 ]] && { echo "Uso: $0 <repo> <req-id>"; exit 1; }

REPO_NAME="$1"
REQ_ID="$2"
REQS_FILE="$SCRIPT_DIR/../reqs.json"

# ── Leer caso ──
CASE_DATA=$(python3 -c "
import json
with open('$REQS_FILE') as f:
    reqs = json.load(f)
case = reqs['$REPO_NAME']['reqs']['$REQ_ID']
print(f"{case['pre_pr']}|{case['summary']}")
")
IFS='|' read -r PRE_PR SUMMARY <<< "$CASE_DATA"
PROMPTS_BASE="${PIPELINE_PROMPTS_DIR:-../../2.5-prompts}"

CASE_ID="${REPO_NAME}-${REQ_ID}"
OUTPUT_DIR="$SCRIPT_DIR/../resultados/C3/$CASE_ID"
OUTPUT_DIR=$(init_output_dir "$OUTPUT_DIR")

# ── Leer MRS desde 2.5-prompts ──
MRS_FILE="$SCRIPT_DIR/$PROMPTS_BASE/$REPO_NAME/REQ-${REPO_NAME^^}-${REQ_ID}.md"
if [[ ! -f "$MRS_FILE" ]]; then
    error "MRS no encontrado: $MRS_FILE"
    exit 1
fi

MRS_PROMPT=$(oc_extract_mrs "$MRS_FILE")
[[ -z "$MRS_PROMPT" ]] && { error "MRS vacío en $MRS_FILE"; exit 1; }

init_pipeline

# Crear worktree aislado
WORKTREE=$(oc_create_worktree "$REPO_NAME" "$PRE_PR" "$OUTPUT_DIR/repo")
trap "oc_remove_worktree '$WORKTREE'" EXIT
REPO_DIR="$WORKTREE"
START_TIME=$(date +%s)

echo ""
echo "=============================================="
echo "  🔥 C3 — VIBE CODING PURO"
echo "=============================================="
echo "  Caso:     $CASE_ID"
echo "  Resumen:  $SUMMARY"
echo "  MRS:      $(basename "$MRS_FILE")"
echo "  Modelo:   $MODEL"
echo ""

echo "$MRS_PROMPT" > "$OUTPUT_DIR/00-input-mrs.txt"
ok "Input guardado"

oc_clean_repo "$REPO_DIR" "$PRE_PR"

# ═══════════════════════════════════════════════════════════
# ÚNICO PROMPT
# ═══════════════════════════════════════════════════════════
step "Prompt único"
cd "$REPO_DIR"
oc_run "01-output" "$MRS_PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR" || {
    error "C3: el modelo no generó output — abortando"
    exit 1
}

# ── Diff + Métricas + Resumen ──
step "Diff"
oc_capture_diff "$REPO_DIR" "$OUTPUT_DIR" || true
oc_capture_metrics "$OUTPUT_DIR"
oc_save_generated "$REPO_DIR" "$OUTPUT_DIR"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
oc_summary "$OUTPUT_DIR" "$CASE_ID" "C3 (Vibe Coding)" "$MODEL" "$ELAPSED" 0
oc_sanitize_auth "$OUTPUT_DIR"

echo ""
echo "=============================================="
echo "  ✅ C3 COMPLETADO en ${ELAPSED}s"
echo "  Output: $OUTPUT_DIR"
echo "=============================================="
