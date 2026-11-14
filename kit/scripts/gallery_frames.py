#!/usr/bin/env python3
"""Splits a gallery sheet (gallery/effects/<category>/<id>.jpg) back into its frames t<time>.jpg, so a library effect
can be the reference for compare.py (--ref <that folder>) when there is no reference video.

    python3 -I gallery_frames.py <gallery>/effects/explosion/d0bab8f5b533.jpg --out ref_frames/

Times come from gallery/effects/index.csv (column stills_at_seconds); the layout is still_sheet.py's (title band 26 px,
4 columns, cell width 400).
"""
import argparse
import csv
import os

from PIL import Image


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("sheet")
    ap.add_argument("--out", required=True)
    ap.add_argument("--index", help="index.csv (default: gallery/effects/index.csv next to the sheet)")
    ap.add_argument("--cols", type=int, default=4)
    ap.add_argument("--w", type=int, default=400)
    ap.add_argument("--head", type=int, default=26)
    a = ap.parse_args()
    eid = os.path.splitext(os.path.basename(a.sheet))[0]
    idx = a.index or os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(a.sheet))), "index.csv")
    times = None
    for row in csv.DictReader(open(idx)):
        if row["id"] == eid:
            times = [float(t) for t in row["stills_at_seconds"].split()]
    if not times:
        raise SystemExit("id %s not in %s" % (eid, idx))
    im = Image.open(a.sheet).convert("RGB")
    rows = (len(times) + a.cols - 1) // a.cols
    h = (im.height - a.head) // rows
    os.makedirs(a.out, exist_ok=True)
    for i, t in enumerate(times):
        x, y = (i % a.cols) * a.w, a.head + (i // a.cols) * h
        im.crop((x, y, x + a.w, y + h)).save(os.path.join(a.out, "t%.3f.jpg" % t), quality=92)
    print(len(times), "frames ->", a.out)


if __name__ == "__main__":
    main()
