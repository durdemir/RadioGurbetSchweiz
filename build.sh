#!/bin/bash

echo "Build started: $(date)"

REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$REPO_ROOT/scripts"

MODULES=(
    "admin.py"
    "finans.py"
    "yayin.py"
    "muzik_telif.py"
    "marketing.py"
    "branding.py"
    "studyo.py"
    "teknik.py"
    "satis.py"
    "investor.py"
    "arsiv.py"
)

for module in "${MODULES[@]}"; do
    FILE="$SCRIPTS_DIR/$module"

    if [ ! -f "$FILE" ]; then
        echo "SKIP (missing): $FILE"
        continue
    fi

    if [ ! -s "$FILE" ]; then
        echo "SKIP (empty): $FILE"
        continue
    fi

    echo "RUN: $FILE"
    python3 "$FILE"
done

echo "Build finished: $(date)"

