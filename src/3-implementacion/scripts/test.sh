#!/usr/bin/env bash
# Test: 1 caso × 4 flujos — ejecuta secuencial, continúa tras fallos
cd "$(dirname "$0")/.."

REPO="repos/appwrite"
CHANGELOG="Cached document lists — Document list queries can be cached with configurable TTL (#10832)."
REQ="../2-requisitos/appwrite/REQ-APPWRITE-10832.md"
CASE="appwrite-e3"
LOG="resultados/test-$(date +%H%M%S).log"
now() { date +%H:%M:%S; }

log() { echo "$1" | tee -a "$LOG"; }

run() {
  local flow="$1"; shift
  log "======== [$flow] $CASE — $(now) ========"
  if "$@" >> "$LOG" 2>&1; then
    log "✅ $flow OK — $(now)"
  else
    log "❌ $flow FAIL (exit $?) — $(now)"
  fi
}

log "🧪 TEST: $CASE × 4 flujos — $(now)"

# ── Garantizar commit pre-PR ──
MERGE_COMMIT="8368a28ff5"  # PR #10832
PRE_PR="${MERGE_COMMIT}~1"
log "🔧 Reset a commit pre-PR: $PRE_PR"
git -C "$REPO" checkout "$PRE_PR" 2>/dev/null || log "⚠️  checkout falló, usando HEAD"
git -C "$REPO" clean -fd 2>/dev/null

run "C3" ./scripts/pipeline-c3.sh "$REPO" "$CASE" resultados/C3/"$CASE"
run "C0" ./scripts/pipeline-c0.sh "$REPO" "$CHANGELOG" "$CASE" resultados/C0/"$CASE"
run "C1" ./scripts/pipeline-c1.sh "$REPO" "$REQ" "$CASE" resultados/C1/"$CASE"
run "C2" ./scripts/pipeline-c2.sh "$REPO" "$REQ" "$CASE" resultados/C2/"$CASE"

log "🏁 TEST COMPLETADO — $(now)"
log "   Log: $LOG"
