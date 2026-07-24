#!/usr/bin/env bash
# ===========================================================================
# pipeline-c0.sh — C0: SpecKit vanilla (specify → plan → tasks → implement)
#
# Uso: ./pipeline-c0.sh <repo> <req-id>
# ===========================================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

[[ $# -lt 2 ]] && { echo "Uso: $0 <repo> <req-id>"; exit 1; }

REPO_NAME="$1"
REQ_ID="$2"

# ── Leer reqs.json ──
CASE_DATA=$(python3 -c "
import json, sys
with open('$CASES_FILE') as f:
    d = json.load(f)
case = d['$REPO_NAME']['reqs']['$REQ_ID']
print(f\"{case['pre_pr']}|{case['summary']}\")
")
IFS='|' read -r PRE_PR SUMMARY <<< "$CASE_DATA"
[[ -z "$PRE_PR" ]] && { error "Req ID '$REQ_ID' no encontrado en $CASES_FILE para '$REPO_NAME'"; exit 1; }

CASE_ID="${REPO_NAME}-${REQ_ID}"
OUTPUT_DIR="$OUTPUT_DIR_BASE/C0/$CASE_ID"
OUTPUT_DIR=$(init_output_dir "$OUTPUT_DIR")

init_pipeline

# Crear worktree aislado
WORKTREE=$(oc_create_worktree "$REPO_NAME" "$PRE_PR" "$OUTPUT_DIR/repo")
[[ -d "$WORKTREE" ]] || { error "Worktree no creado: $WORKTREE"; exit 1; }
trap "oc_remove_worktree '$WORKTREE'" EXIT
REPO_DIR="$WORKTREE"
START_TIME=$(date +%s)

# ── Leer MRS ──
MRS_FILE="$PROMPTS_DIR/$REPO_NAME/REQ-${REPO_NAME^^}-${REQ_ID}.md"
if [[ -f "$MRS_FILE" ]]; then
    MRS_CONTENT=$(cat "$MRS_FILE")
else
    warn "MRS no encontrado: $MRS_FILE, usando summary como fallback"
    MRS_CONTENT="$SUMMARY"
fi

echo ""
echo "=============================================="
echo "  🚀 C0 — SPECKIT VANILLA"
echo "=============================================="
echo "  Caso:      $CASE_ID"
echo "  Resumen:   $SUMMARY"
echo "  Pre-PR:    $PRE_PR"
echo "  Modelo:    $MODEL"
echo ""

oc_clean_repo "$REPO_DIR" "$PRE_PR"
step "Setup — specify init"
oc_speckit_init "$REPO_DIR" || { error "No se pudo inicializar SpecKit"; exit 1; }

echo "$MRS_CONTENT" > "$OUTPUT_DIR/00-input-original.md"

FILES_CREATED=0

# ── Helper: ejecuta un paso SpecKit ──
run_speckit_step() {
    local step_label="$1" step_id="$2" command="$3" args="$4"
    step "$step_label"
    local prompt
    prompt=$(oc_load_agent_prompt "$REPO_DIR" "$command" "$args")
    oc_run "$step_id" "$prompt" "" "$OUTPUT_DIR" "$REPO_DIR" || warn "$command falló"
}

run_speckit_step "1/4 — /speckit.specify" "01-specify" "specify" "$MRS_CONTENT"
run_speckit_step "2/4 — /speckit.plan"     "02-plan"    "plan"    "$MRS_CONTENT"
run_speckit_step "3/5 — /speckit.tasks"    "03-tasks"   "tasks"   ""
run_speckit_step "4/5 — /speckit.implement" "04-implement" "implement" ""

# ── Diff + Métricas ──
step "Diff"; oc_capture_diff "$REPO_DIR" "$OUTPUT_DIR" || true
oc_capture_metrics "$OUTPUT_DIR"
oc_save_generated "$REPO_DIR" "$OUTPUT_DIR"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
oc_summary "$OUTPUT_DIR" "$CASE_ID" "C0 - SpecKit vanilla" "$MODEL" "$ELAPSED" "$FILES_CREATED"
echo ""; echo "=============================================="
echo "  ✅ C0 COMPLETADO en ${ELAPSED}s"
echo "=============================================="
