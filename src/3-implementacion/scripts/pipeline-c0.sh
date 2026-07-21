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
CASES_FILE="$SCRIPT_DIR/../casos.json"

# ── Leer casos.json ──
CASE_DATA=$(python3 -c "
import json, sys
with open('$CASES_FILE') as f:
    d = json.load(f)
paths = d['_paths']
case = d['$REPO_NAME']['reqs']['$REQ_ID']
print(f\"{case['pre_pr']}|{case['summary']}|{paths['repos']}|{paths['prompts']}|{paths['requisitos']}\")
")
IFS='|' read -r PRE_PR SUMMARY REPOS_BASE PROMPTS_BASE REQS_BASE <<< "$CASE_DATA"

REPO_DIR="$SCRIPT_DIR/../$REPOS_BASE/$REPO_NAME"
CASE_ID="${REPO_NAME}-${REQ_ID}"
OUTPUT_DIR="$SCRIPT_DIR/../resultados/C0/$CASE_ID"
OUTPUT_DIR=$(init_output_dir "$OUTPUT_DIR")

init_pipeline

# Crear worktree aislado
WORKTREE=$(oc_create_worktree "$REPO_NAME" "$PRE_PR" "$OUTPUT_DIR/repo")
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

# ── Helper: ejecuta un paso SpecKit y recolecta artefactos ──
run_speckit_step() {
    local step_label="$1" step_id="$2" command="$3" args="$4"
    step "$step_label"
    local prompt
    prompt=$(oc_load_agent_prompt "$REPO_DIR" "$command" "$args")
    if oc_run "$step_id" "$prompt" "" "$OUTPUT_DIR" "$REPO_DIR"; then
        oc_collect_speckit_artifacts "$REPO_DIR" "$OUTPUT_DIR" "$step_id"
    else
        warn "$command falló"
        oc_collect_speckit_artifacts "$REPO_DIR" "$OUTPUT_DIR" "$step_id"
    fi
}

run_speckit_step "1/4 — /speckit.specify" "01-specify" "specify" "$CHANGELOG_TEXT"
run_speckit_step "2/4 — /speckit.plan"     "02-plan"    "plan"    "$CHANGELOG_TEXT"
run_speckit_step "3/4 — /speckit.tasks"    "03-tasks"   "tasks"   ""
run_speckit_step "4/4 — /speckit.implement" "04-implement" "implement" ""

# ── Diff + Métricas ──
step "Diff"; oc_capture_diff "$REPO_DIR" "$OUTPUT_DIR" || true
oc_capture_metrics "$OUTPUT_DIR"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
oc_summary "$OUTPUT_DIR" "$CASE_ID" "C0 (SpecKit vanilla)" "$MODEL" "$ELAPSED" "$FILES_CREATED"
echo ""; echo "=============================================="
echo "  ✅ C0 COMPLETADO en ${ELAPSED}s"
echo "=============================================="
