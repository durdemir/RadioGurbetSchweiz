#!/bin/bash
set -euo pipefail

# === PATHS ===
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_DIR="$REPO_ROOT/09_YATIRIMCI/scripts"
OUT_ROOT="$REPO_ROOT/BUILD_OUTPUT"
LOG="$REPO_ROOT/build-run.log"

mkdir -p "$OUT_ROOT/logs" "$OUT_ROOT/assets" "$OUT_ROOT/slides" "$OUT_ROOT/packages"
> "$LOG"

echo "Build started: $(date)" | tee -a "$LOG"

# === FUNCTION: run_if_nonempty ===
run_if_nonempty() {
  local script="$1"
  if [[ -s "$script" ]]; then
    echo "RUN: $script" | tee -a "$LOG"
    if command -v python3 >/dev/null 2>&1; then
      python3 "$script" >>"$LOG" 2>&1 || {
        echo "ERROR: $script failed" | tee -a "$LOG"
        return 1
      }
    else
      echo "ERROR: python3 not found" | tee -a "$LOG"
      return 1
    fi
  else
    echo "SKIP (missing or empty): $script" | tee -a "$LOG"
  fi
}

# === RUN SCRIPTS IN ORDER ===
run_if_nonempty "$SCRIPTS_DIR/generate_metadata_json.py"
run_if_nonempty "$SCRIPTS_DIR/generate_podcast_covers.py"
run_if_nonempty "$SCRIPTS_DIR/generate_readme.py"
run_if_nonempty "$SCRIPTS_DIR/generate_social_posts.py"
run_if_nonempty "$SCRIPTS_DIR/generate_web_banners.py"
run_if_nonempty "$SCRIPTS_DIR/logo.py"
run_if_nonempty "$SCRIPTS_DIR/pdf_cover.py"
run_if_nonempty "$SCRIPTS_DIR/split_ppt.py"
run_if_nonempty "$SCRIPTS_DIR/versioning.py"

# === FALLBACK: run any other .py files ===
while IFS= read -r f; do
  run_if_nonempty "$f"
done < <(find "$SCRIPTS_DIR" -maxdepth 1 -type f -iname '*.py')

# === VERSION FILE ===
echo "Version: $(date +%Y.%m.%d_%H%M)" > "$SCRIPTS_DIR/VERSION.txt"
echo "Wrote VERSION.txt" | tee -a "$LOG"

# === GIT COMMIT + PUSH ===
git add . >>"$LOG" 2>&1 || true
git commit -m "Build automated $(date +%Y.%m.%d_%H%M)" >>"$LOG" 2>&1 || echo "No changes to commit" | tee -a "$LOG"
git push origin main >>"$LOG" 2>&1 || echo "Push failed (check network/auth)" | tee -a "$LOG"

echo "Build finished: $(date)" | tee -a "$LOG"

