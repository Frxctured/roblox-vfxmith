#!/usr/bin/env python3
"""Contact sheet from labelled stills (the directed loop's self-check: several cameras, day and night).

    python3 -I kit_sheet.py --out <effect>/v2 --list <effect>/v2/shots.txt --title "ember fist v2" [--cols 4] [--w 480]

shots.txt: one line per still, "<label> <image file>", in the order they were taken. The label is what
fx:NextShot() returned without the counter, e.g. "03 player_0.14_day": number, camera, effect time, light.
Copies every still to <out>/<label>.jpg (full size, for the director) and writes <out>/sheet.jpg (cells labelled
"player  t=0.14s  day"). --group cam also writes one sheet per camera (<out>/sheet_<cam>.jpg): use it for dense strips.
"""
import argparse
import os

from PIL import Image, ImageDraw, ImageFont


def font(size):
    for p in ("/usr/share/fonts/TTF/DejaVuSans-Bold.ttf", "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
              "/Library/Fonts/Arial Bold.ttf", "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
              "C:/Windows/Fonts/arialbd.ttf"):
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()


def sheet(items, cols, cw, path, title):
    w, h = items[0][1].size
    ch = round(cw * h / w)
    cols = min(cols, len(items))
    rows = (len(items) + cols - 1) // cols
    head = 34 if title else 0
    out = Image.new("RGB", (cols * cw, head + rows * ch), (18, 18, 22))
    d = ImageDraw.Draw(out)
    f = font(17)
    if title:
        d.text((8, 7), title[:140], fill=(255, 255, 255), font=f)
    for i, (label, im) in enumerate(items):
        px, py = (i % cols) * cw, head + (i // cols) * ch
        out.paste(im.resize((cw, ch), Image.LANCZOS), (px, py))
        tw = d.textlength(label, font=f)
        d.rectangle((px, py, px + tw + 10, py + 24), fill=(0, 0, 0))
        d.text((px + 5, py + 3), label, fill=(255, 220, 120), font=f)
    out.save(path, quality=88)
    return path


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--out", required=True)
    ap.add_argument("--list", required=True)
    ap.add_argument("--title", default="")
    ap.add_argument("--cols", type=int, default=4)
    ap.add_argument("--w", type=int, default=480)
    ap.add_argument("--group", choices=["cam"])
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)
    items = []
    for line in open(a.list, encoding="utf-8"):
        line = line.strip()
        if not line:
            continue
        head, _, rest = line.partition(" ")
        if "_" not in head and rest:  # "03 player_0.14_day <file>"
            tag, _, path = rest.partition(" ")
            num = head
        else:  # "player_0.14_day <file>"
            tag, path, num = head, rest, "%02d" % (len(items) + 1)
        path = path.strip()
        if not os.path.isfile(path):
            raise SystemExit("missing still: " + path)
        parts = tag.split("_")
        cam = parts[0]
        label = "%s  t=%ss  %s" % (cam, parts[1], parts[2]) if len(parts) >= 3 else tag
        im = Image.open(path).convert("RGB")
        im.save(os.path.join(a.out, "%s_%s.jpg" % (num, tag)), quality=92)
        items.append((label, im, cam))
    if not items:
        raise SystemExit("no stills listed")
    made = [sheet([(l, im) for l, im, _ in items], a.cols, a.w, os.path.join(a.out, "sheet.jpg"), a.title)]
    if a.group:
        for cam in dict.fromkeys(c for _, _, c in items):
            sub = [(l, im) for l, im, c in items if c == cam]
            made.append(sheet(sub, 8, 320, os.path.join(a.out, "sheet_%s.jpg" % cam), (a.title + " " + cam).strip()))
    print("%d stills -> %s" % (len(items), ", ".join(made)))


if __name__ == "__main__":
    main()
