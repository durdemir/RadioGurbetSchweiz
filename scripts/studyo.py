#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os, json, zipfile
from datetime import datetime

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTPUT_DIR = os.path.join(REPO_ROOT, "BUILD_OUTPUT")
STUDYO_DIR = os.path.join(OUTPUT_DIR, "studyo")
ASSETS_DIR = os.path.join(STUDYO_DIR, "assets")
PACKAGES_DIR = os.path.join(STUDYO_DIR, "packages")

def ensure_dirs():
    print("Stüdyo klasörleri oluşturuluyor...")
    os.makedirs(ASSETS_DIR, exist_ok=True)
    os.makedirs(PACKAGES_DIR, exist_ok=True)

def generate_docs():
    path = os.path.join(ASSETS_DIR, "STUDYO_DOKUMANLARI.txt")
    with open(path, "w", encoding="utf-8") as f:
        f.write("Gurbet Radio Schweiz\nStüdyo dokümanları (placeholder)\n")
    print(f"Stüdyo dokümanı → {path}")

def generate_metadata():
    meta = {
        "module": "studyo",
        "generated_at": datetime.now().isoformat(timespec="seconds"),
        "assets": os.listdir(ASSETS_DIR)
    }
    path = os.path.join(ASSETS_DIR, "metadata.json")
    with open(path, "w", encoding="utf-8") as f:
        json.dump(meta, f, ensure_ascii=False, indent=4)
    print(f"Stüdyo metadata → {path}")

def create_zip():
    zip_path = os.path.join(PACKAGES_DIR, "STUDYO_PACKAGE.zip")
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
        for root, dirs, files in os.walk(ASSETS_DIR):
            for file in files:
                full = os.path.join(root, file)
                rel = os.path.relpath(full, STUDYO_DIR)
                z.write(full, rel)
    print(f"Stüdyo ZIP → {zip_path}")

def main():
    print("Stüdyo module running...")
    ensure_dirs()
    generate_docs()
    generate_metadata()
    create_zip()
    print("Stüdyo module finished.")

if __name__ == "__main__":
    main()

