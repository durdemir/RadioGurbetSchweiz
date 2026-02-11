from reportlab.pdfgen import canvas


def create_cover(output_path="cover.pdf", title="Gurbet Radio Schweiz"):
    c = canvas.Canvas(output_path)
    c.setFont("Helvetica-Bold", 36)
    c.drawString(100, 750, title)
    c.setFont("Helvetica", 18)
    c.drawString(100, 700, "Kurumsal Başvuru Dosyası")
    c.save()

if __name__ == "__main__":
    create_cover()

