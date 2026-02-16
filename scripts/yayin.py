#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os, json, zipfile
from datetime import datetime

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUTPUT_DIR = os.path.join(REPO_ROOT, "BUILD_OUTPUT")
YAYIN_DIR = os.path.join(OUTPUT_DIR, "yayin")
ASSETS_DIR = os.path.join(YAYIN_DIR, "assets")
PACKAGES_DIR = os.path.join(YAYIN_DIR, "packages")

def ensure_dirs():
    print("Yayın klasörleri oluşturuluyor...")
    os.makedirs(ASSETS_DIR, exist_ok=True)
    os.makedirs(PACKAGES_DIR, exist_ok=True)

def generate_schedule():
    print("Yayın akışı oluşturuluyor...")
    path = os.path.join(ASSETS_DIR, "YAYIN_AKISI.txt")
    with open(path, "w", encoding="utf-8") as f:
        f.write("Gurbet Radio Schweiz\nHaftalık yayın akışı (placeholder)\n")
    print(f"Yayın akışı → {path}")

def generate_metadata():
    meta = {
        "module": "yayin",
        "generated_at": datetime.now().isoformat(timespec="seconds"),
        "assets": os.listdir(ASSETS_DIR)
    }
    path = os.path.join(ASSETS_DIR, "metadata.json")
    with open(path, "w", encoding="utf-8") as f:
        json.dump(meta, f, ensure_ascii=False, indent=4)
    print(f"Yayın metadata → {path}")

def create_zip():
    zip_path = os.path.join(PACKAGES_DIR, "YAYIN_PACKAGE.zip")
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
        for root, dirs, files in os.walk(ASSETS_DIR):
            for file in files:
                full = os.path.join(root, file)
                rel = os.path.relpath(full, YAYIN_DIR)
                z.write(full, rel)
    print(f"Yayın ZIP → {zip_path}")

def main():
    print("Yayın module running...")
    ensure_dirs()
    generate_schedule()
    generate_metadata()
    create_zip()
    print("Yayın module finished.")

if __name__ == "__main__":
    main()


