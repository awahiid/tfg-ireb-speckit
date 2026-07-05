#!/usr/bin/env bash
# ============================================
# Batch: run all Appwrite cases
# ============================================
# Prepares all 10 Appwrite cases for SpecKit
# execution. Run each case individually.
#
# Usage:
#   ./preparar-lote.sh appwrite
#
# Then open each case dir and run SpecKit manually.
# ============================================

set -euo pipefail

REPO="${1:-appwrite}"
WORKSPACE_BASE="/home/awahiid/cloud/mega/proyectos/tfg"
EVIDENCE_DIR="$WORKSPACE_BASE/src/1-evidencia/datos-pr"
REQS_DIR="$WORKSPACE_BASE/src/2.5-prompts/$REPO"
SCRIPT_DIR="$(dirname "$0")"

if [ ! -d "$EVIDENCE_DIR" ]; then
    echo "ERROR: Evidence dir not found: $EVIDENCE_DIR"
    exit 1
fi

echo "=========================================="
echo "  Batch prepare: $REPO"
echo "=========================================="

for bundle_file in "$EVIDENCE_DIR"/"$REPO"-e*.json; do
    # Extract case ID and merge commit SHA
    CASE_ID=$(basename "$bundle_file" .json)
    
    # Find matching requirement
    PR_NUM=$(python3 -c "import json; d=json.load(open('$bundle_file')); print(d.get('pr',{}).get('number',''))")
    REQ_FILE=$(find "$REQS_DIR" -name "*$PR_NUM*" -type f 2>/dev/null | head -1 || echo "")
    
    MERGE_COMMIT=$(python3 -c "
import json
d=json.load(open('$bundle_file'))
m=d.get('pr',{}).get('merge_commit_sha','')
print(m)
")

    if [ -z "$MERGE_COMMIT" ]; then
        echo "[SKIP] $CASE_ID: no merge_commit_sha found"
        continue
    fi

    echo ""
    echo "--- Preparing $CASE_ID (PR #$PR_NUM, merge SHA: $MERGE_COMMIT) ---"
    
    if [ -n "$REQ_FILE" ]; then
        echo "  Requirement: $REQ_FILE"
        bash "$SCRIPT_DIR/preparar-caso.sh" "$REPO" "$CASE_ID" "$MERGE_COMMIT" "$REQ_FILE"
    else
        echo "  No requirement file found for PR #$PR_NUM"
        bash "$SCRIPT_DIR/preparar-caso.sh" "$REPO" "$CASE_ID" "$MERGE_COMMIT"
    fi
    
    echo ""
    echo "=== $CASE_ID ready ==="
done

echo ""
echo "=========================================="
echo "  All $REPO cases prepared!"
echo "=========================================="
echo ""
echo "  Repos are in: $WORKSPACE_BASE/src/3-implementacion/repos/"
echo ""
echo "  For each case, cd into the directory and run:"
echo "    1. code ."
echo "    2. Copilot Chat Agent → run SpecKit commands"
echo "    3. ./capturar-resultado.sh <case-id>"
