from reportlab.pdfgen import canvas


def create_cover(output_path=None, title="Gurbet Radio Schweiz"):
    import os
    out_dir = os.path.join(os.path.dirname(__file__), "..", "..", "BUILD_OUTPUT", "assets")
    os.makedirs(out_dir, exist_ok=True)
    output_path = output_path or os.path.join(out_dir, "cover.pdf")
    c = canvas.Canvas(output_path)
    c.setFont("Helvetica-Bold", 36)
    c.drawString(100, 750, title)
    c.setFont("Helvetica", 18)
    c.drawString(100, 700, "Kurumsal Başvuru Dosyası")
    c.save()

if __name__ == "__main__":
    create_cover()

