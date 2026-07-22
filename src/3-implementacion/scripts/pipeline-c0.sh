#!/usr/bin/env bash
# ===========================================================================
# pipeline-c0.sh — C0: SpecKit vanilla (specify → plan → tasks → implement)
#
# Uso: ./pipeline-c0.sh <repo> <req-id>
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
REQS_BASE="${PIPELINE_REQUISITOS_DIR:-../../2-requisitos}"

CASE_ID="${REPO_NAME}-${REQ_ID}"
OUTPUT_DIR="$SCRIPT_DIR/../resultados/C0/$CASE_ID"
OUTPUT_DIR=$(init_output_dir "$OUTPUT_DIR")

init_pipeline

# Crear worktree aislado
WORKTREE=$(oc_create_worktree "$REPO_NAME" "$PRE_PR" "$OUTPUT_DIR/repo")
trap "oc_remove_worktree '$WORKTREE'" EXIT
REPO_DIR="$WORKTREE"
START_TIME=$(date +%s)
CONTEXT=""

echo ""
echo "=============================================="
echo "  🚀 C0 — SPECKIT VANILLA"
echo "=============================================="
echo "  Caso:      $CASE_ID"
echo "  Resumen:   $SUMMARY"
echo "  Pre-PR:    $PRE_PR"
echo "  Modelo:    $MODEL"
echo ""

echo "$SUMMARY" > "$OUTPUT_DIR/00-input-changelog.txt"
oc_clean_repo "$REPO_DIR" "$PRE_PR"
step "Setup — specify init"
oc_speckit_init "$REPO_DIR" || { error "No se pudo inicializar SpecKit"; exit 1; }

FILES_CREATED=0

# ── Helper: ejecuta un paso SpecKit ──
run_speckit_step() {
    local step_label="$1" step_id="$2" command="$3" args="$4"
    step "$step_label"
    local prompt
    prompt=$(oc_load_agent_prompt "$REPO_DIR" "$command" "$args")
    oc_run "$step_id" "$prompt" "" "$OUTPUT_DIR" "$REPO_DIR" || warn "$command falló"
}

run_speckit_step "1/4 — /speckit.specify" "01-specify" "specify" "$CHANGELOG_TEXT"
run_speckit_step "2/4 — /speckit.plan"     "02-plan"    "plan"    "$CHANGELOG_TEXT"
run_speckit_step "3/4 — /speckit.tasks"    "03-tasks"   "tasks"   ""
run_speckit_step "4/4 — /speckit.implement" "04-implement" "implement" ""

# ── Diff + Métricas ──
step "Diff"; oc_capture_diff "$REPO_DIR" "$OUTPUT_DIR" || true
oc_capture_metrics "$OUTPUT_DIR"
oc_save_generated "$REPO_DIR" "$OUTPUT_DIR"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
oc_summary "$OUTPUT_DIR" "$CASE_ID" "C0 (SpecKit vanilla)" "$MODEL" "$ELAPSED" "$FILES_CREATED"
oc_sanitize_auth "$OUTPUT_DIR"
echo ""; echo "=============================================="
echo "  ✅ C0 COMPLETADO en ${ELAPSED}s"
echo "=============================================="
