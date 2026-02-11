#!/usr/bin/env bash

YEAR=$(date +"%Y")
TARGET="YILLIK_ARSIV_$YEAR.zip"

echo "📦 $YEAR yılı arşivleniyor..."

zip -r "$TARGET" ../01_FINANS/$YEAR ../02_YAYIN ../03_MUZIK_TELIF ../04_MARKETING ../08_SATIS

mv "$TARGET" ../10_ARSIV/

echo "✅ Arşiv oluşturuldu: $TARGET"
