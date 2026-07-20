#!/usr/bin/env bash
# ===========================================================================
# lib.sh — Helpers compartidos para los 4 pipelines (C0, C1, C2, C3)
#
# Principios:
#   - Sin set -e. Cada paso decide si un fallo es crítico o no.
#   - stdout = datos. stderr = logs.
#   - Los prompts se leen de .github/agents/speckit.*.agent.md (oficiales SpecKit)
# ===========================================================================

# ── Colores ──
ROJO='\033[0;31m'; VERDE='\033[0;32m'; AMARILLO='\033[1;33m'; AZUL='\033[0;34m'; RESET='\033[0m'
info()  { echo -e "${AZUL}[INFO]${RESET}  $*" >&2; }
ok()    { echo -e "${VERDE}[OK]${RESET}    $*" >&2; }
warn()  { echo -e "${AMARILLO}[WARN]${RESET}  $*" >&2; }
error() { echo -e "${ROJO}[ERROR]${RESET} $*" >&2; }
step()  { echo "" >&2; echo -e "${AZUL}──────────────────────────────────────────────${RESET}" >&2; echo -e "${AZUL}  $*${RESET}" >&2; echo -e "${AZUL}──────────────────────────────────────────────${RESET}" >&2; }

# ── Configuración común ──
init_pipeline() {
    OPENCODE_BIN="${OPENCODE_BIN:-opencode}"
    MODEL="${OPENCODE_MODEL:-${OPENAI_MODEL:-deepseek/deepseek-v4-flash}}"
    # Normalizar modelo (deepseek-chat → deepseek/deepseek-chat)
    case "$MODEL" in
        deepseek/*) ;;
        deepseek-*)  MODEL="deepseek/$MODEL" ;;
    esac
    API_BASE="${OPENAI_API_BASE:-}"
    TIMEOUT="${PIPELINE_TIMEOUT:-300}"
    info "Modelo: $MODEL  |  Timeout: ${TIMEOUT}s"
    [[ -n "$API_BASE" ]] && info "API base: $API_BASE"

    # Aislar sesiones opencode: cada pipeline usa su propia DB
    export XDG_DATA_HOME="${XDG_DATA_HOME:-$(mktemp -d /tmp/opencode-XXXXXX)}"
    mkdir -p "$XDG_DATA_HOME"
}

# ── Inicializar directorio de salida con timestamp ──
# Uso: OUTPUT_DIR=$(init_output_dir <base-dir>)
#   Crea: <base-dir>/YYYY-MM-DD/HHMMSS/  y retorna la ruta por stdout
init_output_dir() {
    local base="$1"
    local ts_dir
    ts_dir="$base/$(date +%Y-%m-%d)/$(date +%H%M%S)"
    mkdir -p "$ts_dir"
    echo "$ts_dir"
}

# ── Ejecutar opencode ──
# Uso: oc_run <step-id> <prompt> <contexto> <output-dir>
#   $1: step-id (ej: "01-specify")
#   $2: prompt (instrucción actual)
#   $3: contexto acumulado (puede ser "")
#   $4: output dir
# Salida:
#   stdout: nada
#   stderr: logs
#   Archivos: $4/<step-id>.md, $4/<step-id>-prompt.txt, $4/<step-id>-stderr.log
#   Añade session IDs a $4/session-ids.txt
#   Retorna: 0 = OK, 1 = fallo (timeout, vacío, error)
oc_run() {
    local step_id="$1"
    local prompt="$2"
    local context="$3"
    local out_dir="$4"
    local repo_dir="${5:-}"

    local output_file="$out_dir/$step_id.md"
    local stderr_file="$out_dir/$step_id-stderr.log"

    # Montar prompt completo
    local full_prompt="$context

=== INSTRUCCIÓN ACTUAL ===
$prompt

=== FORMATO DE SALIDA ===
Responde en Markdown. Sé específico y detallado."

    echo "$full_prompt" > "$out_dir/${step_id}-prompt.txt"

    info "Ejecutando: $step_id"

    # Ejecutar en el repo para que el modelo pueda leer archivos
    if [[ -n "$repo_dir" ]]; then
        cd "$repo_dir"
    fi

    local ec=0
    if [[ -n "$API_BASE" ]]; then
        OPENAI_API_BASE="$API_BASE" timeout "$TIMEOUT" "$OPENCODE_BIN" run "$full_prompt" --model "$MODEL" \
            > "$output_file" 2>"$stderr_file" || ec=$?
    else
        timeout "$TIMEOUT" "$OPENCODE_BIN" run "$full_prompt" --model "$MODEL" \
            > "$output_file" 2>"$stderr_file" || ec=$?
    fi

    # Capturar session ID más reciente (la nuestra, ya que opencode acaba de terminar)
    local sid
    sid=$("$OPENCODE_BIN" session list 2>/dev/null | grep '^ses_' | head -1 | awk '{print $1}')
    [[ -n "$sid" ]] && echo "$sid" >> "$out_dir/session-ids.txt"

    # Diagnosticar
    if [[ "$ec" -eq 124 ]]; then
        warn "$step_id: TIMEOUT (${TIMEOUT}s)"
        return 1
    elif [[ "$ec" -ne 0 ]]; then
        warn "$step_id: opencode exit code $ec"
        # Si hay output, no es fallo crítico; si no hay, sí.
        if [[ ! -s "$output_file" ]]; then
            error "$step_id: sin output y exit code $ec — fallo crítico"
            return 1
        fi
        warn "$step_id: continuando con output parcial (${ec})"
    fi

    if [[ ! -s "$output_file" ]]; then
        error "$step_id: salida vacía"
        return 1
    fi

    local lines=$(wc -l < "$output_file")
    ok "$step_id: $lines líneas"
    return 0
}

# ── Extraer bloques de código de un markdown ──
# Uso: oc_extract_code <markdown-file> <repo-dir>
#   stdout: número de archivos extraídos (SOLO el número)
#   stderr: logs de progreso
#   Efecto: escribe archivos en <repo-dir>
oc_extract_code() {
    local input_file="$1"
    local repo_dir="$2"
    local counter=0

    while IFS= read -r line; do
        # Detecta: ```lenguaje ruta/archivo
        if echo "$line" | grep -qE '^```[a-zA-Z]+.*[/\\]'; then
            local file_path
            file_path=$(echo "$line" | sed -n 's/^```[^ ]* *\(.*\)/\1/p' | xargs)
            [[ -z "$file_path" ]] && continue

            local abs_path="$repo_dir/$file_path"
            mkdir -p "$(dirname "$abs_path")"

            local code_content=""
            while IFS= read -r code_line; do
                [[ "$code_line" == '```' ]] && break
                code_content="${code_content}${code_line}
"
            done

            echo -n "$code_content" > "$abs_path"
            info "  + $file_path"
            counter=$((counter + 1))
        fi
    done < "$input_file"

    # SOLO el número a stdout (nada más)
    echo "$counter"
}

# ── Generar diff ──
# Uso: oc_capture_diff <repo-dir> <output-dir>
#   Retorna: 0 = diff generado, 1 = sin cambios
oc_capture_diff() {
    local repo_dir="$1"
    local out_dir="$2"

    cd "$repo_dir"

    # Stage todo (incluye archivos nuevos)
    git add -A 2>/dev/null || true

    if git diff --cached --quiet 2>/dev/null; then
        warn "Sin cambios en el repositorio"
        git reset HEAD 2>/dev/null || true
        return 1
    fi

    git diff --cached > "$out_dir/diff.patch"
    local diff_lines
    diff_lines=$(wc -l < "$out_dir/diff.patch")
    git diff --cached --stat > "$out_dir/changed-files.txt"
    local files_changed
    files_changed=$(wc -l < "$out_dir/changed-files.txt")

    git reset HEAD 2>/dev/null || true

    ok "Diff: $diff_lines líneas, $files_changed archivos"
    return 0
}

# ── Limpiar repo para empezar fresco ──
oc_clean_repo() {
    local repo_dir="$1"
    git -C "$repo_dir" checkout . 2>/dev/null || true
    git -C "$repo_dir" clean -fd 2>/dev/null || true
}

# ── Extraer MRS de un .md de 2.5-prompts ──
# Busca el bloque "> Como usuario..." y lo devuelve limpio
oc_extract_mrs() {
    local md_file="$1"
    if [[ ! -f "$md_file" ]]; then
        error "Fichero no encontrado: $md_file"
        return 1
    fi
    # Extrae el bloque MRS: desde "**MRS:**" hasta la siguiente sección
    # Soporta blockquote markdown con lazy continuation (solo primer > tiene "> ")
    awk '
        /^\*\*MRS:\*\*$/ { found=1; next }
        !found { next }
        /^$/ { if (started) exit; next }
        /^##/ || /^\*\*Notas/ { if (started) exit; next }
        {
            started=1
            sub(/^> /, "")
            print
        }
    ' "$md_file"
}

# ═══════════════════════════════════════════════════════════════
# Funciones SpecKit — usan .github/agents/speckit.*.agent.md
# ═══════════════════════════════════════════════════════════════

# Inicializar SpecKit en el repo
oc_speckit_init() {
    local repo_dir="$1"
    if [[ -d "$repo_dir/.specify" ]]; then
        info "SpecKit ya inicializado en $repo_dir"
        return 0
    fi
    info "Ejecutando: specify init --here --force --integration copilot --script sh"
    cd "$repo_dir"
    uvx --from git+https://github.com/github/spec-kit.git specify init \
        --here --force --integration copilot --script sh 2>&1 | tail -3
    local ec=$?
    cd - > /dev/null
    if [[ $ec -ne 0 ]]; then
        warn "specify init falló (exit $ec)"
        return 1
    fi
    ok "SpecKit inicializado (.specify/ + .github/agents/)"
}

# Aplicar un kit IREB: copia templates como overrides + constitution
oc_apply_kit() {
    local repo_dir="$1"
    local kit_dir="$2"
    local kit_name="$3"

    info "Aplicando kit: $kit_name"

    # Constitution → .specify/memory/
    if [[ -f "$kit_dir/constitution.md" ]]; then
        cp "$kit_dir/constitution.md" "$repo_dir/.specify/memory/constitution.md"
        ok "  constitution.md → .specify/memory/"
    fi

    # Templates → .specify/templates/overrides/
    local overrides="$repo_dir/.specify/templates/overrides"
    mkdir -p "$overrides"
    for tpl in "$kit_dir"/*.template.md; do
        [[ -f "$tpl" ]] || continue
        local name
        name=$(basename "$tpl" .template.md)
        # Mapear nombres: spec.template → spec-template
        name="${name//./-}"
        cp "$tpl" "$overrides/$name.md"
        ok "  $name.md → overrides/"
    done
}

# Cargar un prompt de agente oficial de SpecKit, sustituyendo $ARGUMENTS
oc_load_agent_prompt() {
    local repo_dir="$1"
    local command="$2"      # ej: specify, plan, tasks, implement, clarify...
    local args="${3:-}"     # sustituye $ARGUMENTS

    local agent_file="$repo_dir/.github/agents/speckit.$command.agent.md"
    if [[ ! -f "$agent_file" ]]; then
        error "Agent prompt no encontrado: $agent_file"
        return 1
    fi

    # Usar python para sustitución segura (sed se rompe con caracteres especiales)
    python3 -c "
import sys
args = sys.argv[1]
with open('$agent_file') as f:
    content = f.read()
content = content.replace('\$ARGUMENTS', args)
print(content)
" "$args"
}

# Recolectar artefactos SpecKit generados por el agente (spec.md, plan.md, etc.)
# El modelo escribe a specs/XXX/spec.md en vez de stdout. Esto copia el último.
oc_collect_speckit_artifacts() {
    local repo_dir="$1"
    local out_dir="$2"
    local step_id="$3"

    # Buscar specs/ en el repo (creado por /speckit.specify)
    local specs_dir
    specs_dir=$(ls -dt "$repo_dir"/specs/*/ 2>/dev/null | head -1)
    if [[ -z "$specs_dir" ]]; then
        return 0
    fi

    local collected=0
    for artifact in spec.md plan.md tasks.md research.md data-model.md quickstart.md; do
        local src="$specs_dir/$artifact"
        if [[ -f "$src" ]]; then
            cp "$src" "$out_dir/${step_id}-${artifact}"
            info "  📋 $artifact (SpecKit → ${step_id}-${artifact})"
            collected=$((collected + 1))
        fi
    done

    # Checklist files
    local checklists=()
    if [[ -d "$specs_dir/checklists" ]]; then
        checklists=("$specs_dir"/checklists/*.md)
    fi
    for checklist in "${checklists[@]}"; do
        [[ -f "$checklist" ]] || continue
        local name
        name=$(basename "$checklist")
        cp "$checklist" "$out_dir/${step_id}-$name"
        info "  ✅ $name (checklist → ${step_id}-$name)"
        collected=$((collected + 1))
    done

    # Contracts
    if [[ -d "$specs_dir/contracts" ]]; then
        cp -r "$specs_dir/contracts" "$out_dir/${step_id}-contracts" 2>/dev/null && collected=$((collected + 1))
    fi

    return 0
}

# ── Resumen final ──
oc_summary() {
    local out_dir="$1"
    local case_id="$2"
    local flow="$3"
    local model="$4"
    local elapsed="$5"
    local files_created="${6:-0}"

    cat > "$out_dir/summary.json" << EOF
{
  "case": "$case_id",
  "flow": "$flow",
  "model": "$model",
  "date": "$(date -Iseconds)",
  "elapsed_seconds": $elapsed,
  "files_created": $files_created
}
EOF

    # Merge métricas si existen
    if [[ -f "$out_dir/metrics.json" ]]; then
        python3 -c "
import json
s=json.load(open('$out_dir/summary.json'))
m=json.load(open('$out_dir/metrics.json'))
s['tokens']=m.get('total_tokens',0)
s['input_tokens']=m.get('input_tokens',0)
s['output_tokens']=m.get('output_tokens',0)
s['cost_usd']=m.get('total_cost_usd',0)
s['sessions']=m.get('sessions_analyzed',0)
json.dump(s,open('$out_dir/summary.json','w'),indent=2)
print(f'  Tokens: {s[\"tokens\"]:,}  |  Coste: \${s[\"cost_usd\"]}')
" 2>/dev/null || true
    fi

    # Si files_created=0 pero hay diff, contar archivos del diff
    if [[ "$files_created" -eq 0 ]] && [[ -f "$out_dir/diff.patch" ]]; then
        local diff_files
        diff_files=$(grep -c '^diff --git' "$out_dir/diff.patch" 2>/dev/null || echo 0)
        if [[ "$diff_files" -gt 0 ]]; then
            python3 -c "
import json
s=json.load(open('$out_dir/summary.json'))
s['files_created']=$diff_files
s['diff_lines']=$(wc -l < '$out_dir/diff.patch')
json.dump(s,open('$out_dir/summary.json','w'),indent=2)
" 2>/dev/null || true
        fi
    fi

    # README
    cat > "$out_dir/README.md" << EOF
# $flow — Resumen

**Caso**: $case_id
**Modelo**: $model
**Fecha**: $(date -Iseconds)
**Duración**: ${elapsed}s

## Artefactos
$(for f in "$out_dir"/*.md "$out_dir"/*.txt; do
    [[ -f "$f" ]] && echo "- $(basename "$f"): $(wc -l < "$f") líneas"
done)

## Código
$(if [[ -f "$out_dir/diff.patch" ]]; then
    echo "- diff.patch: $(wc -l < "$out_dir/diff.patch") líneas"
    echo "- changed-files.txt: $(wc -l < "$out_dir/changed-files.txt") archivos"
else
    echo "- Sin cambios"
fi)
EOF
}

# ── Capturar métricas (tokens/coste) ──
oc_capture_metrics() {
    local out_dir="$1"
    local session_ids_file="$out_dir/session-ids.txt"

    local session_ids=""
    if [[ -f "$session_ids_file" ]]; then
        session_ids=$(sort -u "$session_ids_file" 2>/dev/null | tr '\n' ' ')
        session_ids="${session_ids// /}"
    fi

    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    if [[ -n "$session_ids" ]]; then
        info "Extrayendo métricas de $(echo "$session_ids" | wc -w) sesiones (desde session-ids.txt)..."
        "$script_dir/capturar-metricas.sh" "$out_dir" $session_ids || warn "Fallo al extraer métricas con IDs"
    else
        info "Buscando sesiones recientes de opencode..."
        "$script_dir/capturar-metricas.sh" "$out_dir" || warn "No se pudieron extraer métricas"
    fi

    # Exportar transcripciones completas de cada sesión
    if [[ -f "$out_dir/costs.csv" ]]; then
        local transcript_dir="$out_dir/transcripts"
        mkdir -p "$transcript_dir"
        local sids
        sids=$(tail -n +2 "$out_dir/costs.csv" 2>/dev/null | cut -d, -f1)
        for sid in $sids; do
            [[ -z "$sid" || "$sid" == "session_id" ]] && continue
            info "  Exportando transcripción: $sid"
            "$OPENCODE_BIN" export "$sid" > "$transcript_dir/$sid.json" 2>/dev/null || true
        done
    fi
}
