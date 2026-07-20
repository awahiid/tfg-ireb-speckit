#!/usr/bin/env bash
# ===========================================================================
# pipeline-c3.sh — C3: Vibe Coding PURO (1 prompt, sin SpecKit, sin IREB)
#
# Uso: ./pipeline-c3.sh <repo-dir> <caso-id> [output-dir]
#
# El prompt MRS se lee de: ../../2.5-prompts/<repo>/REQ-<caso-id>.md
# donde <repo> se extrae de <caso-id> (ej: appwrite-e3 → appwrite).
# ===========================================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

[[ $# -lt 2 ]] && { echo "Uso: $0 <repo-dir> <caso-id> [output-dir]"; exit 1; }

REPO_DIR="$(cd "$1" && pwd)"
CASE_ID="$2"
OUTPUT_DIR="${3:-$REPO_DIR/.specify/memory/c3-output}"
[[ "$OUTPUT_DIR" != /* ]] && OUTPUT_DIR="$PWD/$OUTPUT_DIR"
OUTPUT_DIR=$(init_output_dir "$OUTPUT_DIR")

# ── Resolver prompt MRS desde 2.5-prompts ──
REPO_NAME=$(echo "$CASE_ID" | sed 's/-e[0-9]*$//')
MRS_FILE="$SCRIPT_DIR/../../2.5-prompts/$REPO_NAME/${CASE_ID}.md"
# Fallback: buscar REQ-*.md si el nombre exacto no existe
if [[ ! -f "$MRS_FILE" ]]; then
    MRS_FILE=$(ls "$SCRIPT_DIR/../../2.5-prompts/$REPO_NAME"/REQ-*.md 2>/dev/null | head -1)
fi
if [[ ! -f "$MRS_FILE" ]]; then
    error "No se encontró prompt MRS en 2.5-prompts/$REPO_NAME/ para $CASE_ID"
    exit 1
fi

MRS_PROMPT=$(oc_extract_mrs "$MRS_FILE")
if [[ -z "$MRS_PROMPT" ]]; then
    error "No se pudo extraer MRS de $MRS_FILE"
    exit 1
fi

init_pipeline
START_TIME=$(date +%s)

echo ""
echo "=============================================="
echo "  🔥 C3 — VIBE CODING PURO"
echo "=============================================="
echo "  Caso:     $CASE_ID"
echo "  MRS:      $(basename "$MRS_FILE")"
echo "  Modelo:   $MODEL"
echo ""

# ── Input ──
echo "$MRS_PROMPT" > "$OUTPUT_DIR/00-input-mrs.txt"
ok "Input guardado (MRS de $(basename "$MRS_FILE"))"

# ── Limpiar repo ──
oc_clean_repo "$REPO_DIR"

# ═══════════════════════════════════════════════════════════
# ÚNICO PROMPT
# ═══════════════════════════════════════════════════════════
PROMPT="$MRS_PROMPT"

echo "$PROMPT" > "$OUTPUT_DIR/01-prompt.txt"

step "Prompt único"
cd "$REPO_DIR"
if oc_run "01-output" "$PROMPT" "" "$OUTPUT_DIR" "$REPO_DIR"; then
    :
else
    error "C3: el modelo no generó output — abortando"
    exit 1
fi

# ── Extraer código ──
step "Extrayendo código"
FILES_CREATED=$(oc_extract_code "$OUTPUT_DIR/01-output.md" "$REPO_DIR")
if [[ "$FILES_CREATED" =~ ^[0-9]+$ ]]; then
    [[ "$FILES_CREATED" -gt 0 ]] && ok "Archivos extraídos: $FILES_CREATED" || warn "0 archivos extraídos"
else
    warn "Contador no numérico: '$FILES_CREATED' — posible error"
    FILES_CREATED=0
fi

# ── Diff ──
step "Diff"
oc_capture_diff "$REPO_DIR" "$OUTPUT_DIR" || true

# ── Métricas ──
oc_capture_metrics "$OUTPUT_DIR"

# ── Resumen ──
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))
oc_summary "$OUTPUT_DIR" "$CASE_ID" "C3 (Vibe Coding)" "$MODEL" "$ELAPSED" "$FILES_CREATED"

echo ""
echo "=============================================="
echo "  ✅ C3 COMPLETADO en ${ELAPSED}s"
echo "  Output: $OUTPUT_DIR"
echo "=============================================="
