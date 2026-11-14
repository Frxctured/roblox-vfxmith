#!/usr/bin/env python3
"""Contact sheet of freeze-frame stills (stills.py output: DIR/t<time>.png) cropped to the Studio viewport, labelled
with the effect time, 4 per row. The marker cubes in the viewport's top-left corner are painted over.

    python3 -I still_sheet.py <stills dir> --out sheet.png [--title "..."] [--viewport 430,208,2240,1212] [--w 480]
"""
import argparse
import glob
import os
import re

from PIL import Image, ImageDraw, ImageFont


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("dir")
    ap.add_argument("--out", required=True)
    ap.add_argument("--title", default="")
    ap.add_argument("--viewport", default="430,208,2240,1212")
    ap.add_argument("--w", type=int, default=480)
    ap.add_argument("--cols", type=int, default=4)
    a = ap.parse_args()
    x0, y0, x1, y1 = (int(v) for v in a.viewport.split(","))
    files = sorted(glob.glob(os.path.join(a.dir, "t*.png")), key=lambda p: float(re.findall(r"t([\d.]+)\.png", p)[0]))
    if not files:
        raise SystemExit("no stills in " + a.dir)
    w = a.w
    h = round(w * (y1 - y0) / (x1 - x0))
    rows = (len(files) + a.cols - 1) // a.cols
    head = 26 if a.title else 0
    sheet = Image.new("RGB", (a.cols * w, head + rows * h), (12, 12, 14))
    dr = ImageDraw.Draw(sheet)
    font = ImageFont.load_default()
    if a.title:
        dr.text((6, 6), a.title[:200], fill=(255, 255, 255), font=font)
    for i, p in enumerate(files):
        im = Image.open(p).convert("RGB").crop((x0, y0, x1, y1))
        d = ImageDraw.Draw(im)
        d.rectangle((0, 0, 420, 120), fill=im.getpixel((430, 60)))  # marker band
        im = im.resize((w, h))
        x, y = (i % a.cols) * w, head + (i // a.cols) * h
        sheet.paste(im, (x, y))
        t = re.findall(r"t([\d.]+)\.png", p)[0]
        dr.rectangle((x, y, x + 64, y + 16), fill=(0, 0, 0))
        dr.text((x + 4, y + 3), "t=%.2fs" % float(t), fill=(255, 255, 0), font=font)
    sheet.save(a.out)
    print(a.out, len(files), "stills")


if __name__ == "__main__":
    main()
