#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
from datetime import datetime

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTPUT_DIR = os.path.join(REPO_ROOT, "BUILD_OUTPUT")
SLIDES_DIR = os.path.join(OUTPUT_DIR, "slides")
ASSETS_DIR = os.path.join(OUTPUT_DIR, "assets")
PACKAGES_DIR = os.path.join(OUTPUT_DIR, "packages")

def ensure_dirs():
    """Gerekli klasörleri oluşturur."""
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    os.makedirs(SLIDES_DIR, exist_ok=True)
    os.makedirs(ASSETS_DIR, exist_ok=True)
    os.makedirs(PACKAGES_DIR, exist_ok=True)

def main():
    print("Investor module running...")

    ensure_dirs()

    # Buraya fonksiyonlar eklenecek
    # split_ppt()
    # generate_pdf_cover()
    # generate_metadata()
    # create_zip_package()

    print("Investor module finished.")

if __name__ == "__main__":
    main()

