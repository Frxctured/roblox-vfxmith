#!/usr/bin/env python3
"""Collects freeze-frame captures into a version folder and makes ONE small contact sheet of them, so the builder
looks at a single image per version instead of every frame (most of a build's token cost was frames kept in context).

    python3 -I shot_sheet.py --out <effect>/v2_day t0.10=<capture file> t0.40=<file> ... [base=<file>]
    python3 -I shot_sheet.py --out <effect>/v2_day --list shots.txt        # lines: "0.40 <file>" or "base <file>"

Options: --crop x,y,w,h (source pixels) or --center W,H (a W x H box around the frame centre), --cols 4,
--w 400 (cell width), --title "v2 daylight", --focus 3.1,3.2,3.3,3.45 (the payoff moments).
Writes <out>/t<time>.jpg (full frames, for reviewers and compare.py), <out>/base.jpg if given, <out>/sheet.jpg (all
times, cells cropped and labelled with the effect time) and, with --focus, <out>/focus.jpg: those times only, two per
row at 640 px, so the builder sees the payoff's detail and size without opening single frames. Prints one line.
"""
import argparse
import os

from PIL import Image, ImageDraw, ImageFont


def font(size):
    for p in ("/usr/share/fonts/TTF/DejaVuSans-Bold.ttf", "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
              "/Library/Fonts/Arial Bold.ttf", "C:/Windows/Fonts/arialbd.ttf"):
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()


def parse_pairs(args):
    pairs = []
    for a in args.shots:
        k, _, p = a.partition("=")
        pairs.append((k.lstrip("t"), p))
    if args.list:
        for line in open(args.list):
            parts = line.split(None, 1)
            if len(parts) == 2:
                pairs.append((parts[0].lstrip("t"), parts[1].strip()))
    return pairs


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("shots", nargs="*", help="t<time>=<file> or base=<file>")
    ap.add_argument("--out", required=True)
    ap.add_argument("--list")
    ap.add_argument("--crop")
    ap.add_argument("--center")
    ap.add_argument("--cols", type=int, default=4)
    ap.add_argument("--w", type=int, default=400)
    ap.add_argument("--title", default="")
    ap.add_argument("--focus", default="", help="comma-separated times for focus.jpg (2 per row, 640 px)")
    a = ap.parse_args()
    pairs = parse_pairs(a)
    if not pairs:
        raise SystemExit("no shots given")
    os.makedirs(a.out, exist_ok=True)
    frames = []
    for key, path in pairs:
        if not os.path.isfile(path):
            raise SystemExit("missing capture file: " + path)
        im = Image.open(path).convert("RGB")
        if key == "base":
            im.save(os.path.join(a.out, "base.jpg"), quality=92)
            continue
        t = float(key)
        im.save(os.path.join(a.out, "t%.2f.jpg" % t), quality=92)
        frames.append((t, im))
    frames.sort(key=lambda f: f[0])
    if not frames:
        raise SystemExit("only a base frame given")
    W, H = frames[0][1].size
    if a.crop:
        x, y, w, h = (int(v) for v in a.crop.split(","))
    elif a.center:
        w, h = (int(v) for v in a.center.split(","))
        x, y = (W - w) // 2, (H - h) // 2
    else:
        x, y, w, h = 0, 0, W, H
    def make(items, cols, cw, name, title):
        ch = round(cw * h / w)
        cols = min(cols, len(items))
        rows = (len(items) + cols - 1) // cols
        head = 30 if title else 0
        sheet = Image.new("RGB", (cols * cw, head + rows * ch), (12, 12, 16))
        d = ImageDraw.Draw(sheet)
        f = font(16)
        if title:
            d.text((8, 6), title[:120], fill=(255, 255, 255), font=f)
        for i, (t, im) in enumerate(items):
            cell = im.crop((x, y, x + w, y + h)).resize((cw, ch), Image.LANCZOS)
            px, py = (i % cols) * cw, head + (i // cols) * ch
            sheet.paste(cell, (px, py))
            label = "%.2f s" % t
            tw = d.textlength(label, font=f)
            d.rectangle((px, py, px + tw + 10, py + 22), fill=(0, 0, 0))
            d.text((px + 5, py + 2), label, fill=(255, 220, 120), font=f)
        path = os.path.join(a.out, name)
        sheet.save(path, quality=88)
        return path, sheet.size

    out, size = make(frames, a.cols, a.w, "sheet.jpg", a.title)
    msg = "%s: %d frames, sheet %dx%d" % (out, len(frames), size[0], size[1])
    if a.focus:
        want = [float(v) for v in a.focus.split(",") if v.strip()]
        pick = [fr for fr in frames if any(abs(fr[0] - t) < 0.006 for t in want)]
        if pick:
            fout, fsize = make(pick, 2, 640, "focus.jpg", (a.title + " - focus").strip(" -"))
            msg += "; focus %s: %d frames %dx%d" % (fout, len(pick), fsize[0], fsize[1])
        else:
            msg += "; focus: none of those times were captured"
    print(msg)


if __name__ == "__main__":
    main()
