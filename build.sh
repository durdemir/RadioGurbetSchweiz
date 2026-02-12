#!/bin/bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_DIR="$REPO_ROOT/09_YATIRIMCI/scripts"
OUT_ROOT="$REPO_ROOT/BUILD_OUTPUT"
LOG="$REPO_ROOT/build-run.log"
: > "$LOG"
echo "Build started: $(date)" | tee -a "$LOG"

run_if_nonempty() {
  if [ -s "$1" ]; then
    echo "RUN: $1" | tee -a "$LOG"
    if command -v python3 >/dev/null 2>&1; then
      python3 "$1" >>"$LOG" 2>&1 || echo "ERROR: $1 failed" | tee -a "$LOG"
    else
      echo "ERROR: python3 not found" | tee -a "$LOG"
      return 1
    fi
  else
    echo "SKIP (missing or empty): $1" | tee -a "$LOG"
  fi
}

# Known scripts (use actual filenames present in repo)
run_if_nonempty "$SCRIPTS_DIR/generate_metadata_json.py"
run_if_nonempty "$SCRIPTS_DIR/generate_podcast_covers.py"
run_if_nonempty "$SCRIPTS_DIR/generate_readme.py"
run_if_nonempty "$SCRIPTS_DIR/generate_social_posts.py"
run_if_nonempty "$SCRIPTS_DIR/generate_web_banners.py"
run_if_nonempty "$SCRIPTS_DIR/logo.py"
run_if_nonempty "$SCRIPTS_DIR/pdf_cover.py"
run_if_nonempty "$SCRIPTS_DIR/split_ppt.py"
run_if_nonempty "$SCRIPTS_DIR/versioning.py"

# Fallback: run any other non-empty .py files not listed above
while IFS= read -r f; do
  run_if_nonempty "$f"
done < <(find "$SCRIPTS_DIR" -maxdepth 1 -type f -iname "*.py" -print | grep -v -E "generate_metadata_json.py|generate_podcast_covers.py|generate_readme.py|generate_social_posts.py|generate_web_banners.py|logo.py|pdf_cover.py|split_ppt.py|versioning.py" || true)

# Ensure VERSION.txt
mkdir -p "$SCRIPTS_DIR"
echo "Version: $(date +%Y.%m.%d_%H%M)" > "$SCRIPTS_DIR/VERSION.txt"
echo "Wrote VERSION.txt" | tee -a "$LOG"

# Git: add, commit, push (best-effort)
git add . >>"$LOG" 2>&1 || true
git commit -m "Build: automated $(date +%Y.%m.%d_%H%M)" >>"$LOG" 2>&1 || echo "No changes to commit" | tee -a "$LOG"
git push origin main --tags >>"$LOG" 2>&1 || echo "Push failed (check network/auth)" | tee -a "$LOG"

echo "Build finished: $(date)" | tee -a "$LOG"

# --- Command router (simple) ---
CMD="${1:-all}"

case "$CMD" in
  all)
    ;;
  branding)
    ;;
  investor)
    ;;
  deploy)
    echo "DEPLOY: packaging + git push"
    mkdir -p "$REPO_ROOT/BUILD_OUTPUT/packages"
    PKG="/BUILD_OUTPUT/packages/RadioGurbetSchweiz_20 20 12 61 79 80 81 701 33 98 100 204 250 395 398 399 400date +%Y%m%d_%H%M%S).zip"
    (cd "" && zip -r "" BUILD_OUTPUT 00_ADMIN 01_ADMIN 01_FINANS 02_YAYIN 03_MUZIK_TELIF 04_MARKETING 05_BRANDING 06_STUDYO 07_TEKNIK 08_SATIS 09_YATIRIMCI 10_ARSIV README.md 2>/dev/null || true)
    echo "ZIP: "
    git add -A
    git commit -m "deploy: 20 20 12 61 79 80 81 701 33 98 100 204 250 395 398 399 400date +%Y-%m-%d_%H%M)" || true
    git push origin main || true
    ;;

  *)
    echo "Usage: ./build.sh {all|branding|investor|deploy}"
    exit 2
    ;;
esac
