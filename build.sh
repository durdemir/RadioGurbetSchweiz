#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_DIR="$REPO_ROOT/scripts"
LOG="$REPO_ROOT/build-run.log"

echo "Build started: $(date)" | tee "$LOG"

run() {
  local script="$1"
  if [[ -s "$script" ]]; then
    echo "RUN: $script" | tee -a "$LOG"
    python3 "$script" >>"$LOG" 2>&1 || {
      echo "ERROR in $script" | tee -a "$LOG"
      exit 1
    }
  else
    echo "SKIP (missing or empty): $script" | tee -a "$LOG"
  fi
}

# === MASTER PIPELINE ===
run "$SCRIPTS_DIR/admin.py"
run "$SCRIPTS_DIR/finans.py"
run "$SCRIPTS_DIR/yayin.py"
run "$SCRIPTS_DIR/muzik_telif.py"
run "$SCRIPTS_DIR/marketing.py"
run "$SCRIPTS_DIR/branding.py"
run "$SCRIPTS_DIR/studyo.py"
run "$SCRIPTS_DIR/teknik.py"
run "$SCRIPTS_DIR/satis.py"
run "$SCRIPTS_DIR/investor.py"
run "$SCRIPTS_DIR/arsiv.py"

# === VERSION ===
echo "Version: $(date +%Y.%m.%d_%H%M)" > "$REPO_ROOT/VERSION.txt"

# === GIT ===
git add . >>"$LOG" 2>&1 || true
git commit -m "Auto build $(date +%Y.%m.%d_%H%M)" >>"$LOG" 2>&1 || true
git push origin main >>"$LOG" 2>&1 || true

echo "Build finished: $(date)" | tee -a "$LOG"

