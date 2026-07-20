#!/usr/bin/env bash
# ===========================================================================
# pipeline-c1.sh — C1: SpecKit + IREB Kit v1
#
# specify init → apply kit v1 → constitution → specify → clarify →
# checklist → plan → tasks → analyze → implement
# ===========================================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

[[ $# -lt 3 ]] && { echo "Uso: $0 <repo-dir> <req-file.md> <case-id> [output-dir]"; exit 1; }

REPO_DIR="$(cd "$1" && pwd)"
REQ_FILE="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"
CASE_ID="$3"
OUTPUT_DIR="${4:-$REPO_DIR/.specify/memory/c1-output}"
[[ "$OUTPUT_DIR" != /* ]] && OUTPUT_DIR="$PWD/$OUTPUT_DIR"
OUTPUT_DIR=$(init_output_dir "$OUTPUT_DIR")
KIT_DIR="$SCRIPT_DIR/../ireb-kit-v1"

init_pipeline
START_TIME=$(date +%s)
CONTEXT=""
REQ_CONTENT=$(cat "$REQ_FILE")

echo ""
echo "=============================================="
echo "  🚀 C1 — SPECKIT + IREB v1"
echo "=============================================="
echo "  Caso:       $CASE_ID"
echo "  Requisito:  $(basename "$REQ_FILE")"
echo "  Modelo:     $MODEL"
echo ""

cp "$REQ_FILE" "$OUTPUT_DIR/00-input-original.md"
oc_clean_repo "$REPO_DIR"

# ── Setup: SpecKit init + aplicar kit v1 ──
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
if oc_run "02-specify" "$PROMPT" "$CONTEXT" "$OUTPUT_DIR" "$REPO_DIR"; then
    CONTEXT="=== specify ===
$(cat "$OUTPUT_DIR/02-specify.md")"
else
    warn "specify falló"
fi

# ═══════════════════════════════════════
# 3-7. clarify → checklist → plan → tasks → analyze
# ═══════════════════════════════════════
for pair in \
    "3/9 — /speckit.clarify|clarify|" \
    "4/9 — /speckit.checklist|checklist|" \
    "5/9 — /speckit.plan|plan|$REQ_CONTENT" \
    "6/9 — /speckit.tasks|tasks|" \
    "7/9 — /speckit.analyze|analyze|"; do

    IFS='|' read -r label cmd args <<< "$pair"
    step "$label"
    PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "$cmd" "$args")
    if oc_run "0${cmd%%/*}-$cmd" "$PROMPT" "$CONTEXT" "$OUTPUT_DIR" "$REPO_DIR"; then
        CONTEXT="$CONTEXT
=== $cmd ===
$(cat "$OUTPUT_DIR/0${cmd%%/*}-$cmd.md")"
    else
        warn "$cmd falló"
    fi
done

# ═══════════════════════════════════════
# 8. /speckit.implement
# ═══════════════════════════════════════
step "8/9 — /speckit.implement"
PROMPT=$(oc_load_agent_prompt "$REPO_DIR" "implement" "")
oc_run "08-implement" "$PROMPT" "$CONTEXT" "$OUTPUT_DIR" "$REPO_DIR" || {
    error "implement falló"
    exit 1
}

# ── Extraer, diff, métricas ──
step "Extrayendo código"
FILES_CREATED=$(oc_extract_code "$OUTPUT_DIR/08-implement.md" "$REPO_DIR")
[[ "$FILES_CREATED" =~ ^[0-9]+$ ]] || FILES_CREATED=0
[[ "$FILES_CREATED" -gt 0 ]] && ok "Archivos: $FILES_CREATED" || warn "0 archivos"

step "Diff"
oc_capture_diff "$REPO_DIR" "$OUTPUT_DIR" || true
oc_capture_metrics "$OUTPUT_DIR"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
oc_summary "$OUTPUT_DIR" "$CASE_ID" "C1 (SpecKit + IREB v1)" "$MODEL" "$ELAPSED" "$FILES_CREATED"

echo ""
echo "=============================================="
echo "  ✅ C1 COMPLETADO en ${ELAPSED}s"
echo "=============================================="
