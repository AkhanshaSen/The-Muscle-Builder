#!/usr/bin/env python3
"""Generate a 1024x1024 app icon: orange circle + white M."""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

SIZE = 1024
ORANGE = (255, 107, 53, 255)  # #FF6B35
WHITE = (255, 255, 255, 255)

OUT = Path(__file__).resolve().parents[1] / "assets" / "icon" / "app_icon.png"


def main() -> None:
    img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Full-bleed orange circle (slight inset so adaptive icons keep the edge)
    pad = 48
    draw.ellipse([pad, pad, SIZE - pad - 1, SIZE - pad - 1], fill=ORANGE)

    # Bold white "M" centred
    font = None
    for path in (
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
        "/Library/Fonts/Arial Bold.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    ):
        try:
            font = ImageFont.truetype(path, 520)
            break
        except OSError:
            continue
    if font is None:
        font = ImageFont.load_default()

    text = "M"
    bbox = draw.textbbox((0, 0), text, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    x = (SIZE - tw) / 2 - bbox[0]
    y = (SIZE - th) / 2 - bbox[1] - 20
    draw.text((x, y), text, font=font, fill=WHITE)

    OUT.parent.mkdir(parents=True, exist_ok=True)
    img.save(OUT, "PNG")
    print(f"Wrote {OUT}")


if __name__ == "__main__":
    main()
