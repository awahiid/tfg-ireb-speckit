#!/usr/bin/env bash
# ===========================================================================
# pipeline-flow-a.sh — Pipeline Flow A (SpecKit sin marco IREB)
#
# Flow A = baseline: SpecKit con el texto LITERAL del changelog, sin
# constitution personalizado, sin clarify, sin checklist, sin analyze.
# Solo: specify → plan → tasks → implement
#
# Requisitos:
#   - opencode instalado (opencode run funciona)
#   - OPENAI_API_KEY o ANTHROPIC_API_KEY configurada
#   - Opcional: OPENAI_API_BASE, OPENCODE_MODEL
#
# Uso:
#   ./pipeline-flow-a.sh <repo-dir> "<changelog-text>" <case-id> [output-dir]
#
# Ejemplo:
#   ./pipeline-flow-a.sh ../repos/n8n-e5 \
#     "MongoDB Node: Validate update key value type" \
#     n8n-e5 ../resultados/n8n-e5-flow-a
# ===========================================================================
set -euo pipefail

# ---- Colores ----
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
AZUL='\033[0;34m'
RESET='\033[0m'

info()  { echo -e "${AZUL}[INFO]${RESET}  $*"; }
ok()    { echo -e "${VERDE}[OK]${RESET}    $*"; }
warn()  { echo -e "${AMARILLO}[WARN]${RESET}  $*"; }
error() { echo -e "${ROJO}[ERROR]${RESET} $*"; }
step()  { echo ""; echo -e "${AZUL}══════════════════════════════════════════════${RESET}"; echo -e "${AZUL}  PASO $1${RESET}"; echo -e "${AZUL}══════════════════════════════════════════════${RESET}"; }

# ---- Argumentos ----
if [[ $# -lt 3 ]]; then
    echo "Uso: $0 <repo-dir> <changelog-text> <case-id> [output-dir]"
    echo ""
    echo "Argumentos:"
    echo "  repo-dir         Ruta al repositorio destino"
    echo "  changelog-text   Texto literal del changelog (entre comillas)"
    echo "  case-id          Identificador del caso (ej: n8n-e5)"
    echo "  output-dir       Directorio para guardar resultados (opcional)"
    exit 1
fi

REPO_DIR="$(cd "$1" && pwd)"
CHANGELOG_TEXT="$2"
CASE_ID="$3"
OUTPUT_DIR="${4:-$REPO_DIR/.specify/memory/flow-a-output}"
[[ "$OUTPUT_DIR" != /* ]] && OUTPUT_DIR="$PWD/$OUTPUT_DIR"

mkdir -p "$OUTPUT_DIR"

# ---- Detectar configuración del modelo ----
normalize_model() {
    local model="$1"
    case "$model" in
        deepskip/*) echo "$model" ;;
        deepseek-chat|deepseek-reasoner|deepseek-v4-flash|deepseek-v4-pro)
            echo "deepseek/$model" ;;
        *) echo "$model" ;;
    esac
}

OPENCODE_BIN="${OPENCODE_BIN:-opencode}"
MODEL="$(normalize_model "${OPENCODE_MODEL:-${OPENAI_MODEL:-deepseek/deepseek-chat}}")"
API_BASE="${OPENAI_API_BASE:-}"
[[ -n "$API_BASE" ]] && info "Usando API base: $API_BASE"
info "Usando modelo: $MODEL"

echo ""
echo "=============================================="
echo "  🚀 PIPELINE FLOW A (BASELINE)"
echo "=============================================="
echo ""
echo "  Caso:        $CASE_ID"
echo "  Changelog:   $CHANGELOG_TEXT"
echo "  Repositorio: $REPO_DIR"
echo "  Modelo:      $MODEL"
echo "  Output:      $OUTPUT_DIR"
echo ""

# ---- Guardar input original ----
echo "$CHANGELOG_TEXT" > "$OUTPUT_DIR/00-input-changelog.txt"
ok "Input guardado en $OUTPUT_DIR/00-input-changelog.txt"

# Variable para acumular contexto entre pasos
CONTEXT=""
SPEC_OUTPUT=""

# ---- Helper para ejecutar un paso de opencode ----
run_opencode() {
    local step_id="$1"
    local prompt="$2"
    local output_file="$OUTPUT_DIR/$step_id.md"

    info "Ejecutando: $step_id"

    # Para el paso implement, añadir restricción anti-file-reading
    local extra=""
    if [[ "$step_id" == "04-implement" ]]; then
        extra="⚠️ CRÍTICO: NO leas archivos del repositorio. NO uses herramientas de lectura de archivos. Genera TODO el código directamente basándote solo en el contexto proporcionado arriba. NO explores el sistema de archivos."
    fi

    local full_prompt="$CONTEXT

=== INSTRUCCIÓN ACTUAL ===
$prompt
$extra

=== FORMATO DE SALIDA ===
Responde en Markdown. Sé específico y detallado."

    echo "$full_prompt" > "$OUTPUT_DIR/${step_id}-prompt.txt"

    if [[ -n "$API_BASE" ]]; then
        OPENAI_API_BASE="$API_BASE" timeout 300 "$OPENCODE_BIN" run "$full_prompt" --model "$MODEL" > "$output_file" 2>/dev/null || {
            local ec=$?
            warn "opencode exit code: $ec (timeout after 300s?)"
            [[ $ec -eq 124 ]] && warn "TIMEOUT: opencode tardó más de 5 min"
            return 1
        }
    else
        timeout 300 "$OPENCODE_BIN" run "$full_prompt" --model "$MODEL" > "$output_file" 2>/dev/null || {
            local ec=$?
            warn "opencode exit code: $ec"
            [[ $ec -eq 124 ]] && warn "TIMEOUT: opencode tardó más de 5 min"
            return 1
        }
    fi

    if [[ ! -s "$output_file" ]]; then
        warn "Paso $step_id generó salida vacía"
        return 1
    fi

    local output_content=$(cat "$output_file")
    CONTEXT="$CONTEXT

=== $step_id ===
$output_content"

    local line_count=$(wc -l < "$output_file")
    ok "$step_id completado ($line_count líneas)"
    return 0
}

# ---- Helper para extraer bloques de código ----
extract_code_blocks() {
    local input_file="$1"
    local counter=0

    while IFS= read -r line; do
        if echo "$line" | grep -qE '^```\w+.*[/\\]'; then
            local file_path=$(echo "$line" | sed -n 's/^```[^ ]* *\(.*\)/\1/p' | xargs)
            [[ -z "$file_path" ]] && continue
            local abs_path="$REPO_DIR/$file_path"
            mkdir -p "$(dirname "$abs_path")"

            local code_content=""
            while IFS= read -r code_line; do
                if echo "$code_line" | grep -q '^```'; then break; fi
                code_content="$code_content$code_line
"
            done

            echo -n "$code_content" > "$abs_path"
            info "  Archivo creado: $file_path"
            counter=$((counter + 1))
        fi
    done < "$input_file"

    echo "$counter"
}

# ===========================================================================
# FASE 1: Specify (a partir del changelog CRUDO)
# ===========================================================================
step "1/4 — Specify (desde changelog sin IREB)"
run_opencode "01-specify" "\
A partir de la siguiente descripción de un cambio en un changelog de software,
genera una especificación técnica para implementarlo:

«$CHANGELOG_TEXT»

Describe qué hay que construir, qué archivos podrían modificarse, y qué
comportamiento debe tener el sistema. NO uses ninguna plantilla IREB ni
estándar de requisitos. Simplemente describe el cambio como lo haría un
desarrollador senior."

# ===========================================================================
# FASE 2: Plan
# ===========================================================================
step "2/4 — Plan"
run_opencode "02-plan" "\
Genera un plan de implementación para la especificación anterior.

Incluye:
1. Enfoque técnico
2. Archivos a modificar o crear
3. Orden de implementación
4. Estrategia de verificación (tests)

Sé concreto y directo. No uses gates ni plantillas formales."

# ===========================================================================
# FASE 3: Tasks
# ===========================================================================
step "3/4 — Tasks"
run_opencode "03-tasks" "\
Descompón el plan anterior en tareas ejecutables y ordenadas.

Para cada tarea indica:
- Título descriptivo
- Archivos afectados
- Dependencias entre tareas (si las hay)

Marca tareas independientes como [P] (paralelizables)."

# ===========================================================================
# FASE 4: Implement
# ===========================================================================
step "4/4 — Implement"
info "Implementando en: $REPO_DIR"
cd "$REPO_DIR"

run_opencode "04-implement" "\
IMPLEMENTA el código necesario en EL REPOSITORIO en $REPO_DIR.

Genera el código completo para cada archivo usando bloques de código con
la sintaxis: \`\`\`lenguaje ruta/al/archivo

Por ejemplo:
\`\`\`typescript packages/editor/src/Component.ts
// CASO: $CASE_ID
export class Component { ...
\`\`\`

Reglas:
1. Implementa tests y código fuente
2. NO preguntes — genera TODO el código ahora
3. Usa el formato \`\`\`lenguaje ruta/al/archivo para cada archivo"

# Extraer bloques de código
info "Extrayendo archivos de código generados..."
IMPLEMENT_FILE="$OUTPUT_DIR/04-implement.md"
FILES_CREATED=$(extract_code_blocks "$IMPLEMENT_FILE")
if [[ "$FILES_CREATED" -gt 0 ]]; then
    ok "Archivos extraídos: $FILES_CREATED"
else
    warn "No se pudieron extraer archivos de código de la respuesta"
fi

# ===========================================================================
# Generar diff si hay cambios
# ===========================================================================
step "Final — Generando artefactos"
cd "$REPO_DIR"

if git diff --quiet 2>/dev/null; then
    warn "No hay cambios en el repositorio (git diff vacío)"
else
    git diff > "$OUTPUT_DIR/diff.patch"
    diff_lines=$(wc -l < "$OUTPUT_DIR/diff.patch")
    ok "Diff generado: $diff_lines líneas en $OUTPUT_DIR/diff.patch"

    git diff --stat > "$OUTPUT_DIR/changed-files.txt"
    files_changed=$(wc -l < "$OUTPUT_DIR/changed-files.txt")
    ok "Archivos cambiados: $files_changed"
fi

# ---- Generar resumen ----
{
    echo "# Pipeline Flow A (Baseline) — Resumen de ejecución"
    echo ""
    echo "**Caso**: $CASE_ID"
    echo "**Modelo**: $MODEL"
    echo "**Fecha**: $(date -Iseconds)"
    echo ""
    echo "## Input"
    echo ""
    echo "\`\`\`"
    echo "$CHANGELOG_TEXT"
    echo "\`\`\`"
    echo ""
    echo "## Artefactos generados"
    echo ""
    for f in "$OUTPUT_DIR"/*.md; do
        lines=$(wc -l < "$f" 2>/dev/null || echo "0")
        echo "- $(basename "$f"): $lines líneas"
    done
    echo ""
    if [[ -f "$OUTPUT_DIR/diff.patch" ]]; then
        echo "## Cambios en el código"
        echo "- \`diff.patch\`: $(wc -l < "$OUTPUT_DIR/diff.patch") líneas"
        echo "- \`changed-files.txt\`: disponible"
    else
        echo "## Cambios en el código"
        echo "- No se detectaron cambios"
    fi
} > "$OUTPUT_DIR/README.md"

echo ""
echo "=============================================="
echo "  ✅ PIPELINE FLOW A COMPLETADO"
echo "=============================================="
echo ""
echo "  Resultados en: $OUTPUT_DIR"
echo ""
ls -lh "$OUTPUT_DIR"/*.md "$OUTPUT_DIR"/*.patch "$OUTPUT_DIR"/*.txt 2>/dev/null | \
    awk '{printf "    📄 %s (%s)\n", $9, $5}'
echo ""
echo "=============================================="
