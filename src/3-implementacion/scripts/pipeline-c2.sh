#!/usr/bin/env bash
# ===========================================================================
# pipeline-c2.sh — C2: SpecKit + IREB Kit v2 (anti-scope-creep)
#
# specify init → apply kit v2 → constitution → specify → clarify →
# checklist → plan → tasks → scope-contract → analyze → implement
# ===========================================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

[[ $# -lt 3 ]] && { echo "Uso: $0 <repo-dir> <req-file.md> <case-id> [output-dir]"; exit 1; }

REPO_DIR="$(cd "$1" && pwd)"
REQ_FILE="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"
CASE_ID="$3"
OUTPUT_DIR="${4:-$REPO_DIR/.specify/memory/c2-output}"
[[ "$OUTPUT_DIR" != /* ]] && OUTPUT_DIR="$PWD/$OUTPUT_DIR"
OUTPUT_DIR=$(init_output_dir "$OUTPUT_DIR")
KIT_DIR="$SCRIPT_DIR/../ireb-kit-v2"

init_pipeline
START_TIME=$(date +%s)
CONTEXT=""
REQ_CONTENT=$(cat "$REQ_FILE")

echo ""
echo "=============================================="
echo "  🚀 C2 — SPECKIT + IREB v2 (anti-scope)"
echo "=============================================="
echo "  Caso:       $CASE_ID"
echo "  Requisito:  $(basename "$REQ_FILE")"
echo "  Modelo:     $MODEL"
echo ""

cp "$REQ_FILE" "$OUTPUT_DIR/00-input-original.md"
oc_clean_repo "$REPO_DIR"

# ── Setup ──
step "Setup — specify init + IREB v2"
oc_speckit_init "$REPO_DIR" || { error "specify init falló"; exit 1; }
oc_apply_kit "$REPO_DIR" "$KIT_DIR" "IREB v2"

# ═══════════════════════════════════════
# 1+2. constitution + specify
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
    sid="0${label%%/*}-$cmd"
    if oc_run "$sid" "$PROMPT" "$CONTEXT" "$OUTPUT_DIR" "$REPO_DIR"; then
        CONTEXT="$CONTEXT
=== $cmd ===
$(cat "$OUTPUT_DIR/$sid.md")"
    else
        warn "$cmd falló"
    fi
done

# ═══════════════════════════════════════
# 7.5. Scope contract (específico de v2)
# ═══════════════════════════════════════
step "7.5/9 — Scope Contract (v2)"
SCOPE_PROMPT="A partir del plan y las tareas generados, produce un CONTRATO DE ALCANCE:
ARCHIVOS A TOCAR: ... ARCHIVOS PROHIBIDOS: ... COMPORTAMIENTO EXACTO: ...
NO: refactorizar, añadir features, borrar código, modificar configs, añadir dependencias"
oc_run "07-scope-contract" "$SCOPE_PROMPT" "$CONTEXT" "$OUTPUT_DIR" "$REPO_DIR" || warn "scope contract falló"

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
oc_summary "$OUTPUT_DIR" "$CASE_ID" "C2 (SpecKit + IREB v2)" "$MODEL" "$ELAPSED" "$FILES_CREATED"

echo ""
echo "=============================================="
echo "  ✅ C2 COMPLETADO en ${ELAPSED}s"
echo "=============================================="
