#!/usr/bin/env bash
# ===========================================================================
# pipeline-c1.sh — C1: SpecKit + IREB Kit v1
#
# Uso: ./pipeline-c1.sh <repo> <req-id>
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
REQS_BASE="${PIPELINE_REQUISITOS_DIR:-../../2-requisitos}"
REQS_DIR="$REPO_NAME"

CASE_ID="${REPO_NAME}-${REQ_ID}"
OUTPUT_DIR="$SCRIPT_DIR/../resultados/C1/$CASE_ID"
OUTPUT_DIR=$(init_output_dir "$OUTPUT_DIR")
KIT_DIR="$SCRIPT_DIR/../ireb-kit-v1"

init_pipeline

# Crear worktree aislado
WORKTREE=$(oc_create_worktree "$REPO_NAME" "$PRE_PR" "$OUTPUT_DIR/repo")
trap "oc_remove_worktree '$WORKTREE'" EXIT
REPO_DIR="$WORKTREE"
START_TIME=$(date +%s)

# Leer requisito
REQ_FILE="$SCRIPT_DIR/$REQS_BASE/$REQS_DIR/REQ-${REPO_NAME^^}-${REQ_ID}.md"
[[ -f "$REQ_FILE" ]] || { error "No encontrado: $REQ_FILE"; exit 1; }
REQ_CONTENT=$(cat "$REQ_FILE")

echo ""
echo "=============================================="
echo "  🚀 C1 — SPECKIT + IREB v1"
echo "=============================================="
echo "  Caso:       $CASE_ID"
echo "  Resumen:    $SUMMARY"
echo "  Modelo:     $MODEL"
echo ""

cp "$REQ_FILE" "$OUTPUT_DIR/00-input-original.md"

# ── Setup ──
step "Setup — specify init + IREB v1"
oc_speckit_init "$REPO_DIR" || { error "specify init falló"; exit 1; }
oc_apply_kit "$REPO_DIR" "$KIT_DIR" "IREB v1"

# ═══════════════════════════════════════
# 1+2. /speckit.constitution + /speckit.specify
# ═══════════════════════════════════════
step "1/9 — /speckit.constitution"
CONST=$(cat "$KIT_DIR/constitution.md")
PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "constitution" "$CONST")
oc_run "01-constitution" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR" || warn "constitution falló"

step "2/9 — /speckit.specify"
PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "specify" "$REQ_CONTENT")
if oc_run "02-specify" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR"; then
    :
else
    warn "specify falló"
fi

# ═══════════════════════════════════════
# 3-7. clarify → checklist → plan → tasks
# ═══════════════════════════════════════
for pair in \
    "3/9 — /speckit.clarify|clarify|" \
    "4/9 — /speckit.checklist|checklist|" \
    "5/9 — /speckit.plan|plan|$REQ_CONTENT" \
    "6/9 — /speckit.tasks|tasks|"; do

    IFS='|' read -r label cmd args <<< "$pair"
    step "$label"
    PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "$cmd" "$args")
    if oc_run "0${cmd%%/*}-$cmd" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR"; then
        :
    else
        warn "$cmd falló"
    fi
done

# ═══════════════════════════════════════
# 8. /speckit.implement
# ═══════════════════════════════════════
step "8/9 — /speckit.implement"
PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "implement" "")
oc_run "08-implement" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR" || {
    error "implement falló"
    exit 1
}

# ── Diff + Métricas ──
step "Diff"
oc_capture_diff "$REPO_DIR" "$OUTPUT_DIR" || true
oc_capture_metrics "$OUTPUT_DIR"
oc_save_generated "$REPO_DIR" "$OUTPUT_DIR"

# ── Analyze post-implement ──
step "7/9 — /speckit.analyze"
PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "analyze" "")
oc_run "07-analyze" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR" || warn "analyze falló"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
oc_summary "$OUTPUT_DIR" "$CASE_ID" "C1 (SpecKit + IREB v1)" "$MODEL" "$ELAPSED" 0
oc_sanitize_auth "$OUTPUT_DIR"

echo ""
echo "=============================================="
echo "  ✅ C1 COMPLETADO en ${ELAPSED}s"
echo "=============================================="
