#!/usr/bin/env bash
# ============================================
# preparar-caso.sh — Fase 3: preparar un caso
# ============================================
# Prepara un repositorio en el estado pre-PR
# usando git worktree para ahorrar disco.
#
# Uso:
#   ./preparar-caso.sh <repo> <caso-id> <merge-commit-sha> [requisito]
#
# Ejemplo:
#   ./preparar-caso.sh n8n n8n-e5 439d2601815a72bf93ca185af1e5b49c520fa9af \
#     ../../2-requisitos/n8n/REQ-N8N-31371.md
#
# Pasos:
#   1. Crea/clona bare repo compartido + git worktree add
#   2. Instala dependencias del proyecto
#   3. Inicializa SpecKit
#   4. Guarda el requisito para pegarlo en /speckit.specify
#   5. Muestra las instrucciones para ejecutar SpecKit
# ============================================

set -euo pipefail

if [[ $# -lt 3 ]]; then
    echo "Uso: $0 <repo> <caso-id> <merge-commit-sha> [requisito]"
    echo ""
    echo "Argumentos:"
    echo "  repo             Nombre corto (n8n, calcom, directus, medusa, appwrite, authentik)"
    echo "  caso-id          ID de la entrada (ej. n8n-e5)"
    echo "  merge-commit-sha SHA del merge commit desde el PR bundle"
    echo "  requisito        Ruta al archivo REQ-*.md (opcional)"
    exit 1
fi

REPO="$1"
CASE_ID="$2"
MERGE_COMMIT="$3"
REQ_FILE="${4:-}"

# Rutas fijas del proyecto
WORKSPACE_BASE="/home/awahiid/cloud/mega/proyectos/tfg"
BARE_DIR="$WORKSPACE_BASE/src/3-implementacion/.bare"
CASE_DIR="$WORKSPACE_BASE/src/3-implementacion/repos/$CASE_ID"
SNAPSHOT_DIR="$WORKSPACE_BASE/src/3-implementacion/resultados/$CASE_ID"

# Mapa repositorio → URL
GIT_REMOTE=""
case "$REPO" in
    appwrite)   GIT_REMOTE="https://github.com/appwrite/appwrite.git" ;;
    authentik)  GIT_REMOTE="https://github.com/goauthentik/authentik.git" ;;
    calcom)     GIT_REMOTE="https://github.com/calcom/cal.com.git" ;;
    directus)   GIT_REMOTE="https://github.com/directus/directus.git" ;;
    medusa)     GIT_REMOTE="https://github.com/medusajs/medusa.git" ;;
    n8n)        GIT_REMOTE="https://github.com/n8n-io/n8n.git" ;;
    *)
        echo "Repo desconocido: $REPO"
        echo "Usar: appwrite, authentik, calcom, directus, medusa, n8n"
        exit 1
        ;;
esac

echo "=========================================="
echo "  Fase 3 — Caso: $CASE_ID"
echo "  Repo: $REPO ($GIT_REMOTE)"
echo "  Pre-PR: $MERGE_COMMIT~1"
echo "=========================================="

# ---- Paso 1: bare clone + worktree ----
mkdir -p "$WORKSPACE_BASE/src/3-implementacion/repos"

BARE_REPO_DIR="$BARE_DIR/$REPO.git"
if [ ! -d "$BARE_REPO_DIR" ]; then
    echo "[1] Creando bare clone compartido para $REPO..."
    mkdir -p "$BARE_DIR"
    git clone --bare "$GIT_REMOTE" "$BARE_REPO_DIR"
    echo "[1] Bare repo listo en $BARE_REPO_DIR"
else
    echo "[1] Bare repo ya existe, actualizando..."
    git --git-dir="$BARE_REPO_DIR" fetch --all --prune 2>&1 | tail -1
fi

# Limpiar worktree anterior si existe
if [ -d "$CASE_DIR" ]; then
    echo "[1] Worktree previo encontrado, reemplazando..."
    rm -rf "$CASE_DIR"
fi

echo "[1] Creando worktree en $CASE_DIR..."
git --git-dir="$BARE_REPO_DIR" worktree add --force "$CASE_DIR" "$MERGE_COMMIT~1"
echo "[1] Worktree listo. HEAD en $(git -C "$CASE_DIR" log --oneline -1)"

# ---- Paso 2: instalar dependencias ----
cd "$CASE_DIR"

echo "[2] Instalando dependencias..."
case "$REPO" in
    n8n|calcom|directus|medusa)
        if [ -f "package.json" ]; then
            npm ci --no-audit --no-fund 2>&1 | tail -3 || npm install --no-audit --no-fund 2>&1 | tail -3
        else
            echo "[2] No se encontró package.json"
        fi
        ;;
    appwrite)
        if command -v composer &>/dev/null; then
            composer install --no-interaction --quiet 2>&1 | tail -2
        else
            echo "[SKIP] composer no instalado. Instala PHP 8.3+ o ignora."
        fi
        ;;
    authentik)
        if [ -f "requirements.txt" ]; then
            pip install -r requirements.txt --quiet 2>&1 | tail -2 || true
        fi
        ;;
esac

# ---- Paso 3: inicializar SpecKit ----
echo "[3] Inicializando SpecKit..."
if [ ! -d ".specify" ]; then
    uvx --from git+https://github.com/github/spec-kit.git specify init "$CASE_ID" --ai copilot 2>&1 | tail -3 || {
        echo "[AVISO] SpecKit init falló. Puedes iniciarlo manualmente:"
        echo "    cd $CASE_DIR && uvx --from git+https://github.com/github/spec-kit.git specify init $CASE_ID"
    }
else
    echo "[3] SpecKit ya inicializado."
fi

# ---- Paso 4: guardar requisito ----
if [ -n "$REQ_FILE" ] && [ -f "$REQ_FILE" ]; then
    echo "[4] Guardando requisito en .specify/memory/..."
    mkdir -p ".specify/memory"
    cp "$REQ_FILE" ".specify/memory/requirement-input.md"
    echo "[4] Requisito copiado."
fi

# ---- Paso 5: escribir metadatos ----
cat > ".speckit-case.json" << EOF
{
    "case_id": "$CASE_ID",
    "repo": "$REPO",
    "merge_commit": "$MERGE_COMMIT",
    "pre_pr_commit": "$(git rev-parse HEAD)",
    "requirement_file": "$REQ_FILE",
    "prepared_at": "$(date -Iseconds)"
}
EOF

# ---- Instrucciones finales ----
echo ""
echo "=========================================="
echo "  CASO LISTO: $CASE_ID"
echo "=========================================="
echo ""
echo "  Repositorio: $CASE_DIR"
echo "  HEAD:        $(git -C "$CASE_DIR" log --oneline -1)"
echo "  Req guardado en: .specify/memory/requirement-input.md"
echo ""
echo "  🟢  ABRIR VS CODE:"
echo "      code $CASE_DIR"
echo ""
echo "  🟢  EJECUTAR EN COPILOT CHAT AGENT:"
echo "      (selecciona el agente, NO el chat normal)"
echo ""
echo "      --- CONSTITUTION ---"
echo "      1. /speckit.constitution"
echo "         Proporciona principios alineados con RE:"
echo "         'Verificabilidad obligatoria, minimalidad"
echo "          (implementar exactamente lo especificado),"
echo "          trazabilidad spec→code'"
echo ""
echo "      --- SPEC + CLARIFICACIÓN ---"
echo "      2. /speckit.specify      → pega el contenido de:"
echo "             $CASE_DIR/.specify/memory/requirement-input.md"
echo "      3. /speckit.clarify      ← NUEVO: detecta ambigüedades"
echo ""
echo "      --- VALIDACIÓN DE CALIDAD ---"
echo "      4. /speckit.checklist    ← NUEVO: checklist de calidad"
echo ""
echo "      --- PLANIFICACIÓN ---"
echo "      5. /speckit.plan"
echo "      6. /speckit.tasks"
echo ""
echo "      --- VERIFICACIÓN PRE-IMPLEMENTACIÓN ---"
echo "      7. /speckit.analyze      ← NUEVO: consistencia cruzada"
echo ""
echo "      --- IMPLEMENTACIÓN ---"
echo "      8. /speckit.implement    ← espera a que termine"
echo ""
echo "      --- VERIFICACIÓN POST-IMPLEMENTACIÓN ---"
echo "      9. /speckit.analyze      ← NUEVO: revisión post"
echo ""
echo "  🟢  TRAS IMPLEMENTAR:"
echo "      ./capturar-resultado.sh $CASE_ID"
echo ""
echo "  ⚠️  No modifiques el código manualmente."
echo "      SpecKit debe generar la implementación entera."
echo ""
echo "  📋  Orden resumido:"
echo "      constitution → specify → clarify → checklist"
echo "      → plan → tasks → analyze → implement → analyze"
echo "=========================================="
