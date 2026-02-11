from PIL import Image, ImageDraw, ImageFont

def generate_logo(output_path="logo.png"):
    img = Image.new("RGB", (800, 800), "#111111")
    draw = ImageDraw.Draw(img)

    draw.ellipse((150, 150, 650, 650), fill="#E63946")
    draw.text((260, 360), "GRS", fill="white")

    img.save(output_path)

if __name__ == "__main__":
    generate_logo()


