#!/usr/bin/env bash
# ===========================================================================
# pipeline-c0.sh — C0: SpecKit vanilla (specify → plan → tasks → implement)
# ===========================================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

[[ $# -lt 3 ]] && { echo "Uso: $0 <repo-dir> <changelog-text> <case-id> [output-dir]"; exit 1; }

REPO_DIR="$(cd "$1" && pwd)"
CHANGELOG_TEXT="$2"
CASE_ID="$3"
OUTPUT_DIR="${4:-$REPO_DIR/.specify/memory/c0-output}"
[[ "$OUTPUT_DIR" != /* ]] && OUTPUT_DIR="$PWD/$OUTPUT_DIR"
OUTPUT_DIR=$(init_output_dir "$OUTPUT_DIR")

init_pipeline
START_TIME=$(date +%s)
CONTEXT=""

echo ""
echo "=============================================="
echo "  🚀 C0 — SPECKIT VANILLA"
echo "=============================================="
echo "  Caso:      $CASE_ID"
echo "  Changelog: $CHANGELOG_TEXT"
echo "  Modelo:    $MODEL"
echo ""

echo "$CHANGELOG_TEXT" > "$OUTPUT_DIR/00-input-changelog.txt"
oc_clean_repo "$REPO_DIR"
step "Setup — specify init"
oc_speckit_init "$REPO_DIR" || { error "No se pudo inicializar SpecKit"; exit 1; }

# ── Helper: ejecuta un paso SpecKit y recolecta artefactos ──
run_speckit_step() {
    local step_label="$1" step_id="$2" command="$3" args="$4"
    step "$step_label"
    local prompt
    prompt=$(oc_load_agent_prompt "$REPO_DIR" "$command" "$args")
    if oc_run "$step_id" "$prompt" "$CONTEXT" "$OUTPUT_DIR" "$REPO_DIR"; then
        CONTEXT="$CONTEXT
=== $step_id ===
$(cat "$OUTPUT_DIR/$step_id.md")"
        # Recolectar artefactos generados por el agente
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

# ── Extraer ──
step "Extrayendo código"
FILES_CREATED=$(oc_extract_code "$OUTPUT_DIR/04-implement.md" "$REPO_DIR")
[[ "$FILES_CREATED" =~ ^[0-9]+$ ]] || FILES_CREATED=0
[[ "$FILES_CREATED" -gt 0 ]] && ok "Archivos: $FILES_CREATED" || warn "0 archivos"

step "Diff"; oc_capture_diff "$REPO_DIR" "$OUTPUT_DIR" || true
oc_capture_metrics "$OUTPUT_DIR"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
oc_summary "$OUTPUT_DIR" "$CASE_ID" "C0 (SpecKit vanilla)" "$MODEL" "$ELAPSED" "$FILES_CREATED"
echo ""; echo "=============================================="
echo "  ✅ C0 COMPLETADO en ${ELAPSED}s"
echo "=============================================="
