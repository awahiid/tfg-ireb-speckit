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

# ── Leer reqs.json ──
CASE_DATA=$(python3 -c "
import json
with open('$CASES_FILE') as f:
    d = json.load(f)
case = d['$REPO_NAME']['reqs']['$REQ_ID']
print(f\"{case['pre_pr']}|{case['summary']}\")
")
IFS='|' read -r PRE_PR SUMMARY <<< "$CASE_DATA"
[[ -z "$PRE_PR" ]] && { error "Req ID '$REQ_ID' no encontrado en $CASES_FILE para '$REPO_NAME'"; exit 1; }

CASE_ID="${REPO_NAME}-${REQ_ID}"
OUTPUT_DIR="$OUTPUT_DIR_BASE/C1/$CASE_ID"
OUTPUT_DIR=$(init_output_dir "$OUTPUT_DIR")

init_pipeline

# Crear worktree aislado
WORKTREE=$(oc_create_worktree "$REPO_NAME" "$PRE_PR" "$OUTPUT_DIR/repo")
[[ -d "$WORKTREE" ]] || { error "Worktree no creado: $WORKTREE"; exit 1; }
trap "oc_remove_worktree '$WORKTREE'" EXIT
REPO_DIR="$WORKTREE"
START_TIME=$(date +%s)

# Leer MRS
MRS_FILE="$PROMPTS_DIR/$REPO_NAME/REQ-${REPO_NAME^^}-${REQ_ID}.md"
[[ -f "$MRS_FILE" ]] || { error "No encontrado: $MRS_FILE"; exit 1; }
MRS_CONTENT=$(cat "$MRS_FILE")

echo ""
echo "=============================================="
echo "  🚀 C1 — SPECKIT + IREB v1"
echo "=============================================="
echo "  Caso:       $CASE_ID"
echo "  Resumen:    $SUMMARY"
echo "  Modelo:     $MODEL"
echo ""

# ── Setup ──
step "Setup — specify init + IREB v1"
oc_speckit_init "$REPO_DIR" || { error "specify init falló"; exit 1; }
oc_apply_kit "$REPO_DIR" "$KIT_V1_DIR" "IREB v1"

echo "$MRS_CONTENT" > "$OUTPUT_DIR/00-input-original.md"

# ═══════════════════════════════════════
# 1+2. /speckit.constitution + /speckit.specify
# ═══════════════════════════════════════
step "1/8 — /speckit.constitution"
CONST=$(cat "$KIT_V1_DIR/constitution.md")
PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "constitution" "$CONST")
oc_run "01-constitution" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR" || warn "constitution falló"

step "2/8 — /speckit.specify"
SPEC_TPL=$(cat "$KIT_V1_DIR/spec-template.md")
PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "specify" "${MRS_CONTENT}

${SPEC_TPL}")
oc_run "02-specify" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR" || warn "specify falló"

# ═══════════════════════════════════════
# 3-6. clarify → checklist → plan → tasks
# Cada paso recibe su template del kit como input
# ═══════════════════════════════════════

step "3/8 — /speckit.clarify"
CLARIFY_TPL=$(cat "$KIT_V1_DIR/clarify-template.md")
PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "clarify" "$CLARIFY_TPL")
oc_run "03-clarify" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR" || warn "clarify falló"

step "4/8 — /speckit.checklist"
CHECKLIST_TPL=$(cat "$KIT_V1_DIR/checklist-template.md")
PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "checklist" "$CHECKLIST_TPL")
oc_run "04-checklist" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR" || warn "checklist falló"

step "5/8 — /speckit.plan"
PLAN_TPL=$(cat "$KIT_V1_DIR/plan-template.md")
PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "plan" "${MRS_CONTENT}

${PLAN_TPL}")
oc_run "05-plan" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR" || warn "plan falló"

step "6/8 — /speckit.tasks"
TASKS_TPL=$(cat "$KIT_V1_DIR/tasks-template.md")
PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "tasks" "$TASKS_TPL")
oc_run "06-tasks" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR" || warn "tasks falló"

# ═══════════════════════════════════════
# 7. /speckit.implement
# ═══════════════════════════════════════
step "7/8 — /speckit.implement"
PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "implement" "")
oc_run "07-implement" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR" || {
    error "implement falló"
    exit 1
}

# ═══════════════════════════════════════
# 8. /speckit.analyze
# ═══════════════════════════════════════
step "8/8 — /speckit.analyze"
ANALYZE_TPL=$(cat "$KIT_V1_DIR/analyze-template.md")
PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "analyze" "$ANALYZE_TPL")
oc_run "08-analyze" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR" || warn "analyze falló"

# ── Diff + Métricas ──
step "Diff"
oc_capture_diff "$REPO_DIR" "$OUTPUT_DIR" || true
oc_capture_metrics "$OUTPUT_DIR"
oc_save_generated "$REPO_DIR" "$OUTPUT_DIR"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
oc_summary "$OUTPUT_DIR" "$CASE_ID" "C1 (SpecKit + IREB v1)" "$MODEL" "$ELAPSED" 0

echo ""
echo "=============================================="
echo "  ✅ C1 COMPLETADO en ${ELAPSED}s"
echo "=============================================="
