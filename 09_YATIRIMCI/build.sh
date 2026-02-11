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

