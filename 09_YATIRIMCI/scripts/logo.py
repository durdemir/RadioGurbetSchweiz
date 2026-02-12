from PIL import Image, ImageDraw, ImageFont

def generate_logo(output_path=None):
    img = Image.new("RGB", (800, 800), "#111111")
    draw = ImageDraw.Draw(img)

    draw.ellipse((150, 150, 650, 650), fill="#E63946")
    draw.text((260, 360), "GRS", fill="white")

    import os
    out_dir = os.path.join(os.path.dirname(__file__), "..", "..", "BUILD_OUTPUT", "assets")
    os.makedirs(out_dir, exist_ok=True)
    output_path = output_path or os.path.join(out_dir, "logo.png")
    img.save(output_path)

if __name__ == "__main__":
    generate_logo()


