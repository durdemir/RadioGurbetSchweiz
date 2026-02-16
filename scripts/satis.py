#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os, json, zipfile
from datetime import datetime

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTPUT_DIR = os.path.join(REPO_ROOT, "BUILD_OUTPUT")
SATIS_DIR = os.path.join(OUTPUT_DIR, "satis")
ASSETS_DIR = os.path.join(SATIS_DIR, "assets")
PACKAGES_DIR = os.path.join(SATIS_DIR, "packages")

def ensure_dirs():
    print("Satış klasörleri oluşturuluyor...")
    os.makedirs(ASSETS_DIR, exist_ok=True)
    os.makedirs(PACKAGES_DIR, exist_ok=True)

def generate_docs():
    path = os.path.join(ASSETS_DIR, "SATIS_PAKETLERI.txt")
    with open(path, "w", encoding="utf-8") as f:
        f.write("Gurbet Radio Schweiz\nSatış & Reklam Paketleri (placeholder)\n")
    print(f"Satış dokümanı → {path}")

def generate_metadata():
    meta = {
        "module": "satis",
        "generated_at": datetime.now().isoformat(timespec="seconds"),
        "assets": os.listdir(ASSETS_DIR)
    }
    path = os.path.join(ASSETS_DIR, "metadata.json")
    with open(path, "w", encoding="utf-8") as f:
        json.dump(meta, f, ensure_ascii=False, indent=4)
    print(f"Satış metadata → {path}")

def create_zip():
    zip_path = os.path.join(PACKAGES_DIR, "SATIS_PACKAGE.zip")
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
        for root, dirs, files in os.walk(ASSETS_DIR):
            for file in files:
                full = os.path.join(root, file)
                rel = os.path.relpath(full, SATIS_DIR)
                z.write(full, rel)
    print(f"Satış ZIP → {zip_path}")

def main():
    print("Satış module running...")
    ensure_dirs()
    generate_docs()
    generate_metadata()
    create_zip()
    print("Satış module finished.")

if __name__ == "__main__":
    main()

