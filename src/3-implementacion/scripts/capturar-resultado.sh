#!/usr/bin/env bash
# ============================================
# Snapshot: capture SpecKit implementation
# ============================================
# Usage:
#   ./capturar-resultado.sh <case-id>
#
# Example:
#   ./capturar-resultado.sh appwrite-e8
#
# Creates:
#   results/<case-id>/diff.patch         — git diff of changes
#   results/<case-id>/changed-files.txt   — list of modified files
#   results/<case-id>/summary.json        — metadata
#   results/<case-id>/full-snapshot.zip   — full repo snapshot
# ============================================

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <case-id>"
    exit 1
fi

CASE_ID="$1"
WORKSPACE_BASE="/home/awahiid/cloud/mega/proyectos/tfg"
CASE_DIR="$WORKSPACE_BASE/src/3-implementacion/repos/$CASE_ID"
RESULTS_DIR="$WORKSPACE_BASE/src/3-implementacion/resultados"
SNAPSHOT_DIR="$RESULTS_DIR/$CASE_ID"

if [ ! -d "$CASE_DIR" ]; then
    echo "ERROR: Case directory not found: $CASE_DIR"
    echo "Did you run preparar-caso.sh first?"
    exit 1
fi

cd "$CASE_DIR"

echo "=========================================="
echo "  Snapshot: $CASE_ID"
echo "=========================================="

mkdir -p "$SNAPSHOT_DIR"

# 1. Git diff against initial state
INITIAL_COMMIT=$(cat .speckit-case.json 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('pre_pr_commit',''))" 2>/dev/null || echo "")

if [ -n "$INITIAL_COMMIT" ]; then
    echo "[1] Generating diff against $INITIAL_COMMIT..."
    git diff "$INITIAL_COMMIT" --diff-filter=ACMR > "$SNAPSHOT_DIR/diff.patch"
else
    echo "[1] No initial commit found, using diff with staged+unstaged..."
    git diff HEAD > "$SNAPSHOT_DIR/diff.patch"
fi

DIFF_LINES=$(wc -l < "$SNAPSHOT_DIR/diff.patch")
echo "      Patch: $DIFF_LINES lines"

# 2. List changed files
echo "[2] Listing changed files..."
git diff --name-status --diff-filter=ACMR > "$SNAPSHOT_DIR/changed-files.txt"
echo "      Files changed: $(wc -l < "$SNAPSHOT_DIR/changed-files.txt")"

# 3. Summary JSON
echo "[3] Creating summary..."
cat > "$SNAPSHOT_DIR/summary.json" << EOF
{
    "case_id": "$CASE_ID",
    "snapshot_time": "$(date -Iseconds)",
    "head_commit": "$(git rev-parse HEAD)",
    "head_message": "$(git log --oneline -1)",
    "diff_lines": $DIFF_LINES,
    "changed_files": $(wc -l < "$SNAPSHOT_DIR/changed-files.txt"),
    "specs_dir_exists": $(if [ -d "specs" ]; then echo "true"; else echo "false"; fi),
    "specify_dir_exists": $(if [ -d ".specify" ]; then echo "true"; else echo "false"; fi)
}
EOF

# 4. Full zip snapshot (exclude .git)
echo "[4] Creating full snapshot zip..."
cd "$CASE_DIR"
zip -r "$SNAPSHOT_DIR/full-snapshot.zip" . \
    -x ".git/*" ".git/**" "vendor/*" "node_modules/*" "__pycache__/*" "*.log" 2>&1 | tail -1

echo ""
echo "=========================================="
echo "  Snapshot saved to:"
echo "    $SNAPSHOT_DIR/"
echo "=========================================="
echo ""
echo "  Files:"
ls -lh "$SNAPSHOT_DIR/"
