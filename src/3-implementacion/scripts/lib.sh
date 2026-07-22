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
    # Limpiar referencias a worktrees huérfanos (de ejecuciones anteriores
    # que pudieron fallar antes del trap EXIT)
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    for bare in "$script_dir"/../.bare/*.git; do
        [[ -d "$bare" ]] && git -C "$bare" worktree prune 2>/dev/null || true
    done
    [[ -n "$API_BASE" ]] && info "API base: $API_BASE"
}

# ── Inicializar entorno de ejecución ──
#   Crea el directorio de salida con timestamp y subdirs, aísla HOME para opencode
#   Uso: OUTPUT_DIR=$(init_output_dir <base-dir>)
init_output_dir() {
    local base="$1"
    local ts_dir
    ts_dir="$base/$(date +%Y-%m-%d)/$(date +%H%M%S)"
    mkdir -p "$ts_dir/env/.local/share/opencode" \
             "$ts_dir/trace" \
             "$ts_dir/metrics"
    # Copiar auth al entorno aislado
    local auth_dir="$ts_dir/env/.local/share/opencode"
    local auth_file="$auth_dir/auth.json"
    if [[ -n "${OPENCODE_API_KEY:-}" ]]; then
        # Opción 1: key vía env var
        mkdir -p "$auth_dir"
        cat > "$auth_file" << EOF
{
  "deepseek": {
    "type": "api",
    "key": "$OPENCODE_API_KEY"
  }
}
EOF
    else
        # Opción 2: copiar desde ~/.local/share/opencode/auth.json
        local auth_src="$HOME/.local/share/opencode/auth.json"
        [[ -f "$auth_src" ]] && cp "$auth_src" "$auth_file"
    fi
    echo "$ts_dir"
}

# ── Crear worktree temporal ──
#   Crea un worktree desde el bare repo en el directorio indicado.
#   Uso: oc_create_worktree <repo> <commit> [dest-dir]
#   Retorna: ruta del worktree (stdout)
oc_create_worktree() {
    local repo="$1"
    local commit="$2"
    local dest="${3:-}"
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local bare="$script_dir/../.bare/${repo}.git"

    [[ -z "$dest" ]] && dest="$script_dir/../.bare/${repo}-worktree"
    mkdir -p "$(dirname "$dest")"

    # Redirect git output to stderr so it doesn't contaminate the returned path
    git -C "$bare" worktree add --force "$dest" "$commit" >/dev/null 2>&1 || {
        git -C "$bare" worktree remove --force "$dest" >/dev/null 2>&1 || true
        rm -rf "$dest"
        git -C "$bare" worktree add "$dest" "$commit" >/dev/null 2>&1
    }
    echo "$dest"
}

# ── Eliminar worktree temporal ──
#   Uso: oc_remove_worktree <ruta>
oc_remove_worktree() {
    local dest="$1"
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local repo
    repo=$(basename "$(git -C "$dest" rev-parse --git-common-dir 2>/dev/null)" .git 2>/dev/null)
    local bare="$script_dir/../.bare/${repo}.git"
    [[ -d "$bare" ]] && git -C "$bare" worktree remove --force "$dest" 2>/dev/null || true
    rm -rf "$dest" 2>/dev/null || true
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
#   Retorna: 0 = OK, 1 = fallo (timeout, vacío, error)
oc_run() {
    local step_id="$1"
    local prompt="$2"
    local context="$3"
    local out_dir="$4"
    local repo_dir="${5:-}"

    local terminal_log="$out_dir/trace/terminal.log"

    # Aislar opencode: usar HOME temporal dentro del output
    if [[ -d "$out_dir/env" ]]; then
        export HOME="$out_dir/env"
    fi
    local oc="$OPENCODE_BIN"

    # Montar prompt completo anotado con el paso + directriz anti-gates
    local preamble="## AUTOMATED PIPELINE — RULES

You are running in an automated pipeline. Strictly follow these rules:

1. **Never ask questions.** Never prompt the user for input, confirmation, or decisions.
2. **Never stop for gates.** If a checklist is incomplete, proceed anyway. If something is ambiguous, make a reasonable choice and continue.
3. **Always produce output.** Generate the best possible result with the information available.
4. **No interactive prompts.** Do not write \"(yes/no)\" or wait for answers. Assume affirmative answer to any question.
5. **Execute and produce.** Your job is to execute the step and produce artifacts. Do not stall.

FAILURE MODE: If you ask a question, the pipeline will hang until timeout and fail.
"
    local full_prompt="$preamble

[step $step_id]
$context

=== INSTRUCCIÓN ACTUAL ===
$prompt"

    info "Ejecutando: $step_id"

    # Ejecutar en el repo para que el modelo pueda leer archivos
    if [[ -n "$repo_dir" ]]; then
        cd "$repo_dir"
    fi

    local ec=0
    if [[ -n "$API_BASE" ]]; then
        OPENAI_API_BASE="$API_BASE" timeout "$TIMEOUT" $oc run "$full_prompt" --model "$MODEL" \
            >> "$terminal_log" 2>&1 || ec=$?
    else
        timeout "$TIMEOUT" $oc run "$full_prompt" --model "$MODEL" \
            >> "$terminal_log" 2>&1 || ec=$?
    fi

    # Diagnosticar
    if [[ "$ec" -eq 124 ]]; then
        warn "$step_id: TIMEOUT (${TIMEOUT}s)"
        return 1
    elif [[ "$ec" -ne 0 ]]; then
        warn "$step_id: opencode exit code $ec"
        return 1
    fi

    ok "$step_id"
    return 0
}

# ── Extraer bloques de código de un markdown ──
# Uso: oc_extract_code <markdown-file> <repo-dir>
#   stdout: número de archivos extraídos (SOLO el número)
#   stderr: logs de progreso
#   Efecto: escribe archivos en <repo-dir>
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
# ── Limpiar repo a un estado conocido ──
# Uso: oc_clean_repo <repo-dir> [commit-ref]
#   Si se pasa commit-ref, hace checkout (resetea a ese commit).
#   Siempre limpia archivos modificados/no trackeados y artefactos SpecKit.
oc_clean_repo() {
    local repo_dir="$1"
    local commit="${2:-}"
    if [[ -n "$commit" ]]; then
        git -C "$repo_dir" checkout "$commit" 2>/dev/null || true
    fi
    git -C "$repo_dir" checkout . 2>/dev/null || true
    git -C "$repo_dir" clean -fd 2>/dev/null || true
    rm -rf "$repo_dir/.specify" "$repo_dir/specs" 2>/dev/null || true
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
    if [[ -f "$out_dir/metrics/metrics.json" ]]; then
        python3 -c "
import json
s=json.load(open('$out_dir/summary.json'))
m=json.load(open('$out_dir/metrics/metrics.json'))
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
s['diff_lines']=$(wc -l < $out_dir/diff.patch)
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

# ── Sanitizar auth.json (eliminar credenciales) ──
#   Se llama al final de cada pipeline. Sustituye todo el contenido del
#   auth.json por un placeholder, eliminando cualquier key/c secreta
#   independientemente del proveedor o formato.
oc_sanitize_auth() {
    local out_dir="$1"
    local auth_file="$out_dir/env/.local/share/opencode/auth.json"
    if [[ -f "$auth_file" ]]; then
        cat > "$auth_file" << 'EOF'
{
  "SANITIZADO": "La key real se elimina al finalizar cada pipeline para no persistir credenciales en los resultados"
}
EOF
    fi
    # También sanitizar logs que pudieran contener trazas de la key
    local log_file="$out_dir/env/.local/share/opencode/log/opencode.log"
    [[ -f "$log_file" ]] && : > "$log_file" 2>/dev/null || true
}

# ── Capturar métricas (tokens/coste) ──
oc_capture_metrics() {
    local out_dir="$1"

    # Usar HOME aislado si existe
    [[ -d "$out_dir/env" ]] && export HOME="$out_dir/env"

    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    info "Extrayendo métricas..."
    mkdir -p "$out_dir/metrics"
    "$script_dir/capturar-metricas.sh" "$out_dir/metrics" 2>/dev/null || warn "No se pudieron extraer métricas"

    # Exportar transcripciones a trace/
    if [[ -f "$out_dir/metrics/costs.csv" ]]; then
        mkdir -p "$out_dir/trace"
        local sids
        sids=$(tail -n +2 "$out_dir/metrics/costs.csv" 2>/dev/null | cut -d, -f1)
        for sid in $sids; do
            [[ -z "$sid" || "$sid" == "session_id" ]] && continue
            info "  Exportando transcripción: $sid"
            "$OPENCODE_BIN" export "$sid" > "$out_dir/trace/transcript.json" 2>/dev/null || true
        done
    fi
}

# ── Guardar generated/ (todos los archivos generados) ──
#   Copia archivos modificados + nuevos (untracked) del worktree a
#   $OUTPUT_DIR/generated/ antes de que se elimine el worktree.
#   Uso: oc_save_generated <repo-dir> <output-dir>
oc_save_generated() {
    local repo_dir="$1"
    local out_dir="$2"
    local gen_dir="$out_dir/generated"
    local count=0

    [[ ! -d "$repo_dir" ]] && { warn "Worktree no encontrado: $repo_dir"; return 1; }

    rm -rf "$gen_dir"
    mkdir -p "$gen_dir"

    cd "$repo_dir"

    # Archivos modificados (tracked)
    while IFS= read -r f; do
        [[ -z "$f" ]] && continue
        mkdir -p "$gen_dir/$(dirname "$f")"
        cp "$repo_dir/$f" "$gen_dir/$f" 2>/dev/null && count=$((count + 1))
    done < <(git diff --name-only 2>/dev/null || true)

    # Archivos nuevos (untracked)
    while IFS= read -r f; do
        [[ -z "$f" ]] && continue
        mkdir -p "$gen_dir/$(dirname "$f")"
        cp "$repo_dir/$f" "$gen_dir/$f" 2>/dev/null && count=$((count + 1))
    done < <(git ls-files --others --exclude-standard 2>/dev/null || true)

    cd - >/dev/null

    # También input y summary
    cp "$out_dir"/00-input-* "$gen_dir/input.md" 2>/dev/null || true
    cp "$out_dir/summary.json" "$gen_dir/summary.json" 2>/dev/null || true
    cp "$out_dir/diff.patch" "$gen_dir/diff.patch" 2>/dev/null || true

    info "✅ generated/ — $count archivos guardados"
}
