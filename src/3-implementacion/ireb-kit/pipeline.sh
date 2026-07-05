#!/usr/bin/env bash
# ===========================================================================
# pipeline-ireb-v2.sh — Pipeline IREB-SpecKit MEJORADO (anti-scope-creep)
#
# Misma documentación IREB completa (8 pasos), PERO:
# 1. El paso IMPLEMENT recibe contexto DESTILADO, no los 7 pasos completos
# 2. Se genera un "scope contract" que acota EXACTAMENTE qué tocar
# 3. Restricciones duras anti-scope-creep en el prompt de implement
# 4. Post-implement: verificación de que el diff no excede lo planeado
#
# vs v1: mismo output documental, implementación más enfocada
# ===========================================================================
set -euo pipefail

ROJO='\033[0;31m'; VERDE='\033[0;32m'; AMARILLO='\033[1;33m'; AZUL='\033[0;34m'; RESET='\033[0m'
info()  { echo -e "${AZUL}[INFO]${RESET}  $*"; }
ok()    { echo -e "${VERDE}[OK]${RESET}    $*"; }
warn()  { echo -e "${AMARILLO}[WARN]${RESET}  $*"; }
error() { echo -e "${ROJO}[ERROR]${RESET} $*"; }
step()  { echo ""; echo -e "${AZUL}══════════════════════════════════════════════${RESET}"; echo -e "${AZUL}  PASO $1${RESET}"; echo -e "${AZUL}══════════════════════════════════════════════${RESET}"; }

[[ $# -lt 2 ]] && { echo "Uso: $0 <repo-dir> <requisito.md> [output-dir]"; exit 1; }

REPO_DIR="$(cd "$1" && pwd)"
REQ_FILE="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"
OUTPUT_DIR="${3:-$REPO_DIR/.specify/memory/pipeline-output}"
[[ "$OUTPUT_DIR" != /* ]] && OUTPUT_DIR="$PWD/$OUTPUT_DIR"
KIT_DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$OUTPUT_DIR"

normalize_model() {
    case "$1" in
        deepseek/*) echo "$1" ;;
        deepseek-chat|deepseek-reasoner|deepseek-v4-*) echo "deepseek/$1" ;;
        *) echo "$1" ;;
    esac
}

OPENCODE_BIN="${OPENCODE_BIN:-opencode}"
MODEL="$(normalize_model "${OPENCODE_MODEL:-${OPENAI_MODEL:-deepseek/deepseek-chat}}")"
API_BASE="${OPENAI_API_BASE:-}"
[[ -n "$API_BASE" ]] && info "API base: $API_BASE"
info "Modelo: $MODEL"

REQ_BASENAME="$(basename "$REQ_FILE" .md)"
CONSTITUTION_CONTENT=$(cat "$KIT_DIR/constitution.md")
REQ_CONTENT=$(cat "$REQ_FILE")

echo ""
echo "=============================================="
echo "  🚀 PIPELINE IREB v2 (ANTI-SCOPE-CREEP)"
echo "=============================================="
echo "  Requisito:   $REQ_BASENAME"
echo "  Repositorio: $REPO_DIR"
echo "  Modelo:      $MODEL"
echo ""

# ---- Setup ----
step "0/8 — Setup"
# Limpiar repo de ejecuciones anteriores
cd "$REPO_DIR"
git checkout . 2>/dev/null || true
git clean -fd 2>/dev/null || true
cd - > /dev/null
mkdir -p "$REPO_DIR/.specify/memory"
cp "$KIT_DIR/constitution.md" "$REPO_DIR/.specify/memory/constitution.md"
echo "$REQ_CONTENT" > "$OUTPUT_DIR/00-input-original.md"
ok "Setup listo (repo limpio)"

CONTEXT="$CONSTITUTION_CONTENT"
SCOPE_CONTRACT=""   # ← NUEVO: scope contract para el paso implement

# ---- run_opencode (igual que v1) ----
run_opencode() {
    local step_id="$1"; local prompt="$2"
    local output_file="$OUTPUT_DIR/$step_id.md"
    info "Ejecutando: $step_id"
    local full_prompt="$CONTEXT

=== INSTRUCCIÓN ACTUAL ===
$prompt"
    echo "$full_prompt" > "$OUTPUT_DIR/${step_id}-prompt.txt"
    if [[ -n "$API_BASE" ]]; then
        OPENAI_API_BASE="$API_BASE" timeout 300 "$OPENCODE_BIN" run "$full_prompt" --model "$MODEL" > "$output_file" 2>/dev/null || { warn "opencode exit: $?"; return 1; }
    else
        timeout 300 "$OPENCODE_BIN" run "$full_prompt" --model "$MODEL" > "$output_file" 2>/dev/null || { warn "opencode exit: $?"; return 1; }
    fi
    [[ ! -s "$output_file" ]] && { warn "$step_id vacío"; return 1; }
    local output_content=$(cat "$output_file")
    CONTEXT="$CONTEXT

=== $step_id ===
$output_content"
    ok "$step_id: $(wc -l < "$output_file") líneas"
}

extract_code_blocks() {
    local input_file="$1"; local counter=0
    while IFS= read -r line; do
        if echo "$line" | grep -qE '^```\w+.*[/\\]'; then
            local file_path=$(echo "$line" | sed -n 's/^```[^ ]* *\(.*\)/\1/p' | xargs)
            [[ -z "$file_path" ]] && continue
            local abs_path="$REPO_DIR/$file_path"
            mkdir -p "$(dirname "$abs_path")"
            local code_content=""
            while IFS= read -r code_line; do
                [[ "$code_line" == '```' ]] && break
                code_content="$code_content$code_line
"
            done
            echo -n "$code_content" > "$abs_path"
            info "  📄 $file_path"
            counter=$((counter + 1))
        fi
    done < "$input_file"
    echo "$counter"
}

# ===========================================================================
# PASOS 1-7: Documentación IREB completa (idéntico a v1)
# ===========================================================================

step "1/8 — Constitution"
run_opencode "01-constitution" "\
Actúa como ingeniero de requisitos IREB. Carga los siguientes principios:
$CONSTITUTION_CONTENT

⚠️  Principio CRÍTICO adicional — NO ALUCINAR CONTEXTO:
- NUNCA inventes stakeholders, fuentes, orígenes u objetivos que no estén
  explícitamente en el documento de requisitos de entrada.
- Si el input dice 'fix FIPS status schema', no inventes que viene de un
  'equipo de seguridad' o que 'mejora el cumplimiento normativo'.
- Puedes definir mejor CÓMO implementar (detalles técnicos, arquitectura),
  pero NUNCA inventes POR QUÉ, QUIÉN o DE DÓNDE surge el requisito.
- Si no hay suficiente información, indícalo. No la fabriques."
CONTEXT="$CONSTITUTION_CONTENT"

step "2/8 — Specify"
run_opencode "02-specify" "\
Formaliza este requisito con plantilla IREB (12 atributos: ID, Name, Type,
Description, Source, Rationale, Priority, Verification, Status, Version,
Dependencies, Module):

$REQ_CONTENT

Clasifícalo (Functional/Quality/Constraint). Usa verbos observables.

⚠️  REGLAS ANTI-ALUCINACIÓN DE CONTEXTO:
- SOURCE: solo usa la información literal del input. Si el input no especifica
  fuente, pon 'Changelog entry — sin fuente adicional documentada'. NO inventes
  issues, PRs, stakeholders ni documentos que no aparezcan en el input.
- RATIONALE: solo infiere motivación si el input la contiene explícitamente.
  Si no, pon 'No documentado en la fuente original'. NO inventes beneficios
  de negocio, métricas de mejora ni justificaciones.
- STAKEHOLDERS: NO los menciones a menos que aparezcan en el input original.
- Puedes expandir detalles técnicos de implementación (cómo), pero NUNCA el
  contexto organizacional (por qué, quién, de dónde)."

step "3/8 — Clarify"
run_opencode "03-clarify" "\
Detecta problemas en la especificación:
- Criterios de verificación faltantes
- Términos ambiguos (rápido, eficiente, robusto, intuitivo)
- Tipos sin clasificar, fuentes o justificaciones ausentes

⚠️  Añade verificación ANTI-ALUCINACIÓN:
- ¿La SOURCE menciona stakeholders, issues o documentos que NO están en el input?
- ¿El RATIONALE inventa beneficios de negocio u objetivos no declarados?
- ¿Se asume un 'usuario final', 'equipo de seguridad' o 'cliente' no mencionado?
Si detectas cualquiera de estos, márcalo como ❌ ALUCINACIÓN DE CONTEXTO.

Solo señala problemas. No los resuelvas."

step "4/8 — Checklist (ISO 29148)"
run_opencode "04-checklist" "\
Evalúa estos 13 criterios para la especificación generada:
R1(ID único) | R2(Tipo correcto) | R3(Fuente documentada) |
R4(Prioridad) | R5(Estructura formal) | R6(Singularidad) |
R7(Verbo observable) | R8(Sin ambigüedad) | R9(Verificabilidad) |
R10(Autosuficiencia) | R11(Dependencias) | R12(Módulo) |
R13(NO ALUCINACIÓN DE CONTEXTO) ← NUEVO:
  ¿La fuente y el rationale se limitan a lo que aparece en el input original?
  ¿No se han inventado stakeholders, objetivos de negocio ni orígenes?

Para cada criterio: ✅ PASA / ⚠️ REVISAR / ❌ FALLA + recomendaciones.
R13 es BLOQUEANTE: si falla, el requisito debe reescribirse."

step "5/8 — Plan"
run_opencode "05-plan" "Plan técnico con gates IREB: Verificabilidad, Trazabilidad, Anti-Ambigueedad, Clasificacion. Incluye: enfoque tech, archivos a modificar/crear, orden test-first, estrategia de verificacion."

step "6/8 — Tasks"
run_opencode "06-tasks" "\
Descompón en tareas. Formato: [REQ-ID] Título | Prioridad | Archivos | Dependencias.
Marca independientes con [P]."

step "7/8 — Analyze (pre-implement)"
run_opencode "07-analyze" "\
Consistencia spec↔plan↔tasks. Matriz de trazabilidad. Reporta brechas."

# ===========================================================================
# 🆕 NUEVO: Scope Contract (anti-scope-creep)
# ===========================================================================
step "7.5/8 — Scope Contract"
info "Generando scope contract a partir del plan y las tareas..."

# Extraer del plan y tasks solo la info esencial para el implement
SCOPE_PROMPT="\
A partir del plan y las tareas generados, produce un CONTRATO DE ALCANCE conciso.
Formato EXACTO:

ARCHIVOS A TOCAR:
- ruta/archivo1 (MODIFICAR | CREAR)
- ruta/archivo2 (MODIFICAR | CREAR)

ARCHIVOS PROHIBIDOS (NO TOCAR bajo ninguna circunstancia):
- Cualquier archivo NO listado arriba

COMPORTAMIENTO EXACTO A IMPLEMENTAR:
- (1-3 bullets, solo lo esencial)

LO QUE NO DEBE HACER EL CÓDIGO:
- No refactorizar código existente no relacionado
- No añadir features nuevas fuera del scope
- No borrar código existente salvo que sea estrictamente necesario
- No modificar configuraciones globales
- No añadir dependencias nuevas
- ⚠️  NO inventar comentarios sobre stakeholders, objetivos de negocio o
  motivaciones. Los comentarios // REQ: ID son suficientes. Nada de
  'Solicitado por el equipo de...' o 'Para mejorar la experiencia de...'"

run_opencode "07.5-scope-contract" "$SCOPE_PROMPT"
SCOPE_CONTRACT=$(cat "$OUTPUT_DIR/07.5-scope-contract.md")
ok "Scope contract generado"

# ===========================================================================
# 🆕 FASE 8: Implement CON scope contract (contexto destilado)
# ===========================================================================
step "8/8 — Implement (CON scope contract)"

# CONTEXTO DESTILADO: solo spec + scope contract + tareas, NO los 7 pasos completos
SPEC_CONTENT=$(cat "$OUTPUT_DIR/02-specify.md")
TASKS_CONTENT=$(cat "$OUTPUT_DIR/06-tasks.md")

DISTILLED_CONTEXT="\
=== ESPECIFICACIÓN IREB ===
$SPEC_CONTENT

=== SCOPE CONTRACT (CONTRATO DE ALCANCE VINCULANTE) ===
$SCOPE_CONTRACT

=== TAREAS ===
$TASKS_CONTENT"

IMPLEMENT_PROMPT="\
⚠️ LEE PRIMERO EL SCOPE CONTRACT. Es vinculante. No lo violes.

IMPLEMENTA el código en $REPO_DIR. Genera cada archivo con:
\`\`\`lenguaje ruta/al/archivo
// REQ: $REQ_BASENAME
...código...
\`\`\`

REGLAS ESTRICTAS:
1. SOLO toca archivos listados en ARCHIVOS A TOCAR del scope contract
2. NO toques ningún archivo listado en ARCHIVOS PROHIBIDOS
3. NO refactorices código existente no relacionado
4. NO añadas features, dependencias ni configuraciones nuevas
5. NO borres código existente salvo que el scope contract lo autorice
6. Cada archivo DEBE tener // REQ: $REQ_BASENAME en su cabecera
7. Tests: solo para el comportamiento nuevo, no reescribas tests existentes
8. Si el cambio es pequeño (< 50 líneas estimadas), NO generes más de 200 líneas totales
9. Si el cambio es medio (50-200 líneas), NO generes más de 500 líneas totales
10. Prioriza MINIMALIDAD sobre completitud. Menos código = mejor."

info "Implementando con scope contract (contexto destilado)..."
echo "$IMPLEMENT_PROMPT" > "$OUTPUT_DIR/08-implement-prompt.txt"

cd "$REPO_DIR"
if [[ -n "$API_BASE" ]]; then
    OPENAI_API_BASE="$API_BASE" timeout 300 "$OPENCODE_BIN" run "$DISTILLED_CONTEXT

=== INSTRUCCIÓN ===
$IMPLEMENT_PROMPT" --model "$MODEL" > "$OUTPUT_DIR/08-implement.md" 2>/dev/null || {
        warn "opencode exit: $?"
    }
else
    timeout 300 "$OPENCODE_BIN" run "$DISTILLED_CONTEXT

=== INSTRUCCIÓN ===
$IMPLEMENT_PROMPT" --model "$MODEL" > "$OUTPUT_DIR/08-implement.md" 2>/dev/null || {
        warn "opencode exit: $?"
    }
fi

if [[ -s "$OUTPUT_DIR/08-implement.md" ]]; then
    ok "Implement: $(wc -l < "$OUTPUT_DIR/08-implement.md") líneas"
else
    warn "Implement generó salida vacía"
fi

# Extraer código
info "Extrayendo archivos..."
FILES_CREATED=$(extract_code_blocks "$OUTPUT_DIR/08-implement.md")
[[ "$FILES_CREATED" -gt 0 ]] && ok "Archivos: $FILES_CREATED" || warn "0 archivos extraídos"

# ===========================================================================
# POST: Analyze + diff + validación anti-scope-creep
# ===========================================================================
step "Post — Analyze"
run_opencode "09-post-analyze" "\
Verificación post-implementación:
- ¿Se respetó el scope contract?
- ¿Hay código huérfano o enlaces rotos?
- ¿Tests faltantes?
- ¿Desviaciones respecto a la especificación?" || warn "Post-analyze falló (timeout?), continuando con diff..."

# Diff
step "Final — Artefactos"
cd "$REPO_DIR"
git add -A 2>/dev/null
if git diff --cached --quiet 2>/dev/null; then
    warn "Diff vacío"
else
    git diff --cached > "$OUTPUT_DIR/diff.patch"
    diff_lines=$(wc -l < "$OUTPUT_DIR/diff.patch")
    git diff --cached --stat > "$OUTPUT_DIR/changed-files.txt"
    files_changed=$(wc -l < "$OUTPUT_DIR/changed-files.txt")
    
    # 🆕 Alerta de scope creep
    if [[ "$diff_lines" -gt 1000 ]]; then
        warn "⚠️  DIFF EXCESIVO: $diff_lines líneas. Posible scope creep. Revisa el diff."
    elif [[ "$diff_lines" -gt 500 ]]; then
        warn "⚠️  Diff elevado: $diff_lines líneas. Verifica que todo sea necesario."
    else
        ok "Diff: $diff_lines líneas, $files_changed archivos"
    fi
fi
git reset HEAD 2>/dev/null

# 🆕 Limpiar repo para la próxima ejecución
git checkout . 2>/dev/null || true
git clean -fd 2>/dev/null || true

# README
{
    echo "# Pipeline IREB v2 (anti-scope-creep) — Resumen"
    echo ""
    echo "**Requisito**: $REQ_BASENAME"
    echo "**Modelo**: $MODEL"
    echo "**Fecha**: $(date -Iseconds)"
    echo ""
    echo "## Artefactos"
    for f in "$OUTPUT_DIR"/*.md; do
        echo "- $(basename "$f"): $(wc -l < "$f") líneas"
    done
    echo ""
    if [[ -f "$OUTPUT_DIR/diff.patch" ]]; then
        echo "## Código"
        echo "- diff.patch: $(wc -l < "$OUTPUT_DIR/diff.patch") líneas"
        echo "- changed-files.txt: $(wc -l < "$OUTPUT_DIR/changed-files.txt") archivos"
    fi
} > "$OUTPUT_DIR/README.md"

echo ""
echo "=============================================="
echo "  ✅ PIPELINE IREB v2 COMPLETADO"
echo "=============================================="
echo "  Resultados: $OUTPUT_DIR"
echo "  Diff: $(wc -l < "$OUTPUT_DIR/diff.patch" 2>/dev/null || echo 0) líneas"
echo ""
