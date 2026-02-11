#!/bin/bash

echo "📻 Radio Gurbet Schweiz – Build Pipeline Başladı"

# Versiyon numarası
VERSION=$(date +"%Y.%m.%d_%H%M")
echo "📌 Version: $VERSION"

# Script path
SCRIPT_DIR="09_YATIRIMCI/scripts"

# Scriptleri çalıştır
python3 $SCRIPT_DIR/01_generate_json.py
python3 $SCRIPT_DIR/02_generate_covers.py
python3 $SCRIPT_DIR/03_generate_readme.py
python3 $SCRIPT_DIR/04_generate_social_posts.py
python3 $SCRIPT_DIR/generate_web_banners.py
python3 $SCRIPT_DIR/logo.py
python3 $SCRIPT_DIR/opt_cover.py
python3 $SCRIPT_DIR/split.ppt.py

# Versiyon dosyası
echo "Version: $VERSION" > $SCRIPT_DIR/VERSION.txt

# Git işlemleri
git add .
git commit -m "Build: $VERSION – Otomatik Üretim tamamlandı"
git tag "v$VERSION"
git push origin main --tags

echo "✅ Build tamamlandı ve Github'a yüklendi"

