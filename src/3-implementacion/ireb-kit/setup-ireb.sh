#!/usr/bin/env bash
# ===================================================
# setup-ireb.sh — Aplica el IREB Kit a un proyecto
# Uso: ./setup-ireb.sh /ruta/al/repo
# ===================================================
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Uso: $0 <ruta-al-repo>"
    echo "Ejemplo: $0 ~/repos/n8n"
    exit 1
fi

REPO_DIR="$1"
KIT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=========================================="
echo "  Aplicando IREB Kit a: $REPO_DIR"
echo "=========================================="

# ---- 1. Verificar que el repo tiene SpecKit inicializado ----
if [[ ! -d "$REPO_DIR/.specify" ]]; then
    echo "[1] SpecKit no inicializado. Inicializando..."
    cd "$REPO_DIR"
    specify init ireb-project --integration copilot
    echo "[1] SpecKit init OK"
else
    echo "[1] SpecKit ya inicializado"
fi

# ---- 2. Copiar constitution activo ----
echo "[2] Copiando constitution IREB..."
mkdir -p "$REPO_DIR/.specify/memory"
cp "$KIT_DIR/constitution.md" "$REPO_DIR/.specify/memory/constitution.md"
echo "[2] Constitution copiado"

# ---- 3. Copiar overrides de templates ----
echo "[3] Copiando templates IREB..."
mkdir -p "$REPO_DIR/.specify/templates/overrides"
cp "$KIT_DIR/spec-template-ireb.md" "$REPO_DIR/.specify/templates/overrides/spec-template.md" 2>/dev/null || true
cp "$KIT_DIR/plan-template-ireb.md" "$REPO_DIR/.specify/templates/overrides/plan-template.md" 2>/dev/null || true
cp "$KIT_DIR/checklist-ireb.md"     "$REPO_DIR/.specify/templates/overrides/checklist-template.md" 2>/dev/null || true
echo "[3] Templates copiados"

# ---- 4. Copiar workflow ----
echo "[4] Copiando workflow IREB..."
mkdir -p "$REPO_DIR/.specify/workflows/ireb"
cp "$KIT_DIR/workflow-ireb.yml" "$REPO_DIR/.specify/workflows/ireb/workflow.yml" 2>/dev/null || true
echo "[4] Workflow copiado"

# ---- 5. Resumen ----
echo ""
echo "=========================================="
echo "  IREB Kit aplicado correctamente"
echo "=========================================="
echo ""
echo "  Para usar el flujo IREB completo:"
echo ""
echo "  Con comandos manuales:"
echo "    1. /speckit.constitution  (ya precargado)"  
echo "    2. /speckit.specify      → pega el REQ-*.md"
echo "    3. /speckit.clarify"
echo "    4. /speckit.checklist"
echo "    5. /speckit.plan"
echo "    6. /speckit.tasks"
echo "    7. /speckit.analyze"
echo "    8. /speckit.implement"
echo "    9. /speckit.analyze"
echo ""
echo "  Con workflow automatizado:"
echo "    specify workflow run ireb --input spec='...'"
echo ""
echo "  Archivos instalados:"
echo "    .specify/memory/constitution.md"
echo "    .specify/templates/overrides/"
echo "    .specify/workflows/ireb/workflow.yml"
echo "=========================================="
