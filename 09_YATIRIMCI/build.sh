
#!/bin/zsh

LOCAL_SLIDES_DIR="$HOME/Documents/GurbetRadioBuild/SLIDES"


echo "🚀 Gurbet Radio Schweiz — Full Build Pipeline Başlıyor..."
PROJECT_NAME="Gurbet Radio Schweiz"

echo "📁 Klasörler hazırlanıyor..."
mkdir -p FINAL_OUTPUT/KURUMSAL_KIMLIK
mkdir -p FINAL_OUTPUT/PITCH_DECK
mkdir -p FINAL_OUTPUT/DIGRIS
mkdir -p FINAL_OUTPUT/LOGO
mkdir -p FINAL_OUTPUT/SLIDES

echo "🎨 Logo üretiliyor..."
python3 scripts/logo.py
mv logo.png FINAL_OUTPUT/LOGO/

echo "📄 PDF kapağı oluşturuluyor..."
python3 scripts/pdf_cover.py
mv cover.pdf FINAL_OUTPUT/DIGRIS/

echo "📄 Digris PDF birleştiriliyor..."
cd DIGRIS_BASVURU
pandoc *.md -o DIGRIS_CONTENT.pdf
cd ..

gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite \
   -sOutputFile=FINAL_OUTPUT/DIGRIS/DIGRIS_BASVURU_FINAL.pdf \
   FINAL_OUTPUT/DIGRIS/cover.pdf \
   DIGRIS_BASVURU/DIGRIS_CONTENT.pdf

echo "📊 Pitch Deck slide'lara bölünüyor..."
python3 scripts/split_ppt.py
python3 scripts/split_ppt.py
rm -rf "$LOCAL_SLIDES_DIR/slides"
mv slides "$LOCAL_SLIDES_DIR"
rm -rf FINAL_OUTPUT/SLIDES/slides
mv slides FINAL_OUTPUT/SLIDES/

# 🔥 Yeni modüller buraya geliyor
python3 scripts/generate_social_posts.py && \
python3 scripts/generate_web_banners.py && \
python3 scripts/generate_podcast_covers.py && \
python3 scripts/generate_metadata_json.py && \
python3 scripts/generate_readme.py && \
python3 scripts/versioning.py


echo "🎨 Kurumsal kimlik seti hazırlanıyor..."
cp assets/colors.txt FINAL_OUTPUT/KURUMSAL_KIMLIK/
cp -R assets/fonts FINAL_OUTPUT/KURUMSAL_KIMLIK/

echo "📦 Pitch Deck optimize ediliyor..."
cp GURBET_RADIO_PITCH_DECK.pdf FINAL_OUTPUT/PITCH_DECK/"${PROJECT_NAME}_PITCH_DECK.pdf"
cp GURBET_RADIO_PITCH_DECK.pptx FINAL_OUTPUT/PITCH_DECK/"${PROJECT_NAME}_PITCH_DECK.pptx"

echo "🗜 ZIP paketi oluşturuluyor..."
zip -r "${PROJECT_NAME}_FINAL.zip" FINAL_OUTPUT/

echo "🎉 Build tamamlandı!"
echo "📦 Final paket hazır: ${PROJECT_NAME}_FINAL.zip"

#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="$ROOT_DIR/build-run.log"

log() {
    echo "[INFO] $1"
    echo "[INFO] $1" >> "$LOG_FILE"
}

run_logo() {
    log "LOGO çalışıyor..."
    python3 "$ROOT_DIR../05_BRANDING/scripts/generate_logo.py"


run_pdf() {
    log "PDF COVER çalışıyor..."
    python3 "$ROOT_DIR/../05_BRANDING/scripts/generate_cover.py"
}

run_slides() {
    log "SLIDES çalışıyor..."
    python3 "$ROOT_DIR/09_YATIRIMCI/scripts/split_ppt.py"
}

run_zip() {
    log "ZIP paketleniyor..."
    cd "$ROOT_DIR"
    zip -r "GurbetRadio_Final.zip" FINAL_OUTPUT
}

run_push() {
    log "Git push..."
    cd "$ROOT_DIR"
    git add .
    git commit -m "Auto-build"
    git push
}

run_all() {
    log "FULL PIPELINE başlıyor..."
    run_logo
    run_pdf
    run_slides
    run_zip
    run_push
    log "FULL PIPELINE bitti."
}

case "$1" in
    logo) run_logo ;;
    pdf) run_pdf ;;
    slides) run_slides ;;
    zip) run_zip ;;
    push) run_push ;;
    all) run_all ;;
    *)
        echo "Kullanım:"
        echo "./build.sh all"
        echo "./build.sh logo"
        echo "./build.sh pdf"
        echo "./build.sh slides"
        echo "./build.sh zip"
        echo "./build.sh push"
        ;;
esac

