#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
from datetime import datetime
from pptx import Presentation
from PIL import Image
import tempfile
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.utils import ImageReader
import json
import zipfile

# KÖK VE KLASÖRLER
REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTPUT_DIR = os.path.join(REPO_ROOT, "BUILD_OUTPUT")
SLIDES_DIR = os.path.join(OUTPUT_DIR, "slides")
ASSETS_DIR = os.path.join(OUTPUT_DIR, "assets")
PACKAGES_DIR = os.path.join(OUTPUT_DIR, "packages")

def ensure_dirs():
    print("Gerekli klasörleri oluşturuyor...")
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    os.makedirs(SLIDES_DIR, exist_ok=True)
    os.makedirs(ASSETS_DIR, exist_ok=True)
    os.makedirs(PACKAGES_DIR, exist_ok=True)

def split_ppt(ppt_path):
    """PPTX dosyasını slidelara ayırır ve PNG olarak kaydeder."""
    if not os.path.exists(ppt_path):
        print(f"PPT bulunamadı: {ppt_path}")
        return

    print("PPT split işlemi başladı...")

    prs = Presentation(ppt_path)

    for i, slide in enumerate(prs.slides, start=1):
        # Geçici PNG (placeholder mantık – gerçek render yerine)
        tmp = tempfile.NamedTemporaryFile(delete=False, suffix=".png")
        tmp_path = tmp.name
        tmp.close()

        # Şimdilik sadece boş bir PNG üretelim (pipeline için placeholder)
        img = Image.new("RGB", (1920, 1080), color="white")
        img.save(tmp_path)

        out_path = os.path.join(SLIDES_DIR, f"slide_{i:02d}.png")
        os.rename(tmp_path, out_path)

        print(f"Slide {i} kaydedildi → {out_path}")

    print("PPT split işlemi tamamlandı.")

def generate_pdf_cover():
    """İlk slide'dan PDF kapak oluşturur."""
    first_slide = os.path.join(SLIDES_DIR, "slide_01.png")

    if not os.path.exists(first_slide):
        print("Kapak oluşturulamadı: slide_01.png bulunamadı.")
        return

    print("PDF kapak oluşturuluyor...")

    output_pdf = os.path.join(ASSETS_DIR, "INVESTOR_COVER.pdf")
    c = canvas.Canvas(output_pdf, pagesize=A4)

    width, height = A4
    img = ImageReader(first_slide)
    c.drawImage(img, 0, 0, width=width, height=height)

    c.setFont("Helvetica-Bold", 22)
    c.drawString(40, height - 40, "Gurbet Radio Schweiz – Investor Package")

    c.setFont("Helvetica", 12)
    c.drawString(40, height - 60, f"Tarih: {datetime.now().strftime('%d.%m.%Y')}")

    c.save()

    print(f"PDF kapak oluşturuldu → {output_pdf}")

def generate_metadata():
    """Yatırımcı paketi için metadata.json oluşturur."""
    print("Metadata oluşturuluyor...")

    metadata = {
        "project": "Gurbet Radio Schweiz",
        "module": "investor",
        "generated_at": datetime.now().isoformat(timespec="seconds"),
        "output_dir": OUTPUT_DIR,
        "slides_dir": SLIDES_DIR,
        "assets_dir": ASSETS_DIR,
        "packages_dir": PACKAGES_DIR,
    }

    output_json = os.path.join(ASSETS_DIR, "metadata.json")
    with open(output_json, "w", encoding="utf-8") as f:
        json.dump(metadata, f, ensure_ascii=False, indent=4)

    print(f"Metadata oluşturuldu → {output_json}")

def create_zip_package():
    """Yatırımcı paketi için ZIP dosyası oluşturur."""
    print("ZIP paketi oluşturuluyor...")

    zip_path = os.path.join(PACKAGES_DIR, "INVESTOR_PACKAGE.zip")
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
        # ASSETS
        for root, dirs, files in os.walk(ASSETS_DIR):
            for file in files:
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, OUTPUT_DIR)
                z.write(full_path, rel_path)

        # SLIDES
        for root, dirs, files in os.walk(SLIDES_DIR):
            for file in files:
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, OUTPUT_DIR)
                z.write(full_path, rel_path)

    print(f"ZIP paketi oluşturuldu → {zip_path}")

def main():
    print("Investor module running...")

    ensure_dirs()
    split_ppt(os.path.join(REPO_ROOT, "pitch_deck.pptx"))
    generate_pdf_cover()
    generate_metadata()
    create_zip_package()

    print("Investor module finished.")

if __name__ == "__main__":
    main()

