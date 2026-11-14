#!/usr/bin/env python3
"""Measures where each effect sits on screen from a framing pass (VFXLibPlayer.batch with times {0, peak1, peak2, ...}
captured by stills.py --follow): t0.000.png is the empty stage, the others show the effect. For each effect it writes the
effect's box in viewport fractions (cx, cy, w, h; union of the peak frames, 2nd-98th percentile of changed pixels) for
VFXLibPlayer.calibrate, and a review sheet with the box drawn.

    python3 -I framing.py <framing dir> --out framing.json --sheet framing.png [--viewport 366,206,2279,1213]
"""
import argparse
import glob
import json
import os

import numpy as np
from PIL import Image, ImageDraw, ImageFont


def load(p, vp):
    return np.asarray(Image.open(p).convert("RGB").crop(vp)).astype(np.int16)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("dir")
    ap.add_argument("--out", required=True)
    ap.add_argument("--sheet")
    ap.add_argument("--viewport", default="366,206,2279,1213")
    ap.add_argument("--cols", type=int, default=6)
    a = ap.parse_args()
    vp = tuple(int(v) for v in a.viewport.split(","))
    W, H = vp[2] - vp[0], vp[3] - vp[1]
    ignore = np.zeros((H, W), bool)
    ignore[:130, :420] = True       # marker cubes
    ignore[:, :40] = True           # plugin strip on the left edge
    ignore[:130, W - 140:] = True   # view cube
    res, cells = {}, []
    for d in sorted(glob.glob(os.path.join(a.dir, "*"))):
        name = os.path.basename(d)
        base_p = os.path.join(d, "t0.000.png")
        peaks = sorted(p for p in glob.glob(os.path.join(d, "t*.png")) if p != base_p)
        if not os.path.exists(base_p) or not peaks:
            res[name] = {"status": "missing"}
            continue
        base = load(base_p, vp)
        mask = np.zeros((H, W), bool)
        for p in peaks:
            diff = np.abs(load(p, vp) - base).max(axis=2)
            # bloom/glow lifts the whole background a little: remove that global shift, keep clear changes only
            diff = diff - np.median(diff[~ignore])
            mask |= diff > 45
        mask &= ~ignore
        cov = float(mask.mean())
        if cov < 0.001:
            res[name] = {"status": "empty", "coverage": round(cov, 4)}
            box = None
        else:
            ys, xs = np.nonzero(mask)
            x0, x1 = np.percentile(xs, 3) / W, np.percentile(xs, 97) / W
            y0, y1 = np.percentile(ys, 3) / H, np.percentile(ys, 97) / H
            box = (x0, y0, x1, y1)
            res[name] = {"status": "ok", "coverage": round(cov, 4), "cx": round((x0 + x1) / 2, 3),
                         "cy": round((y0 + y1) / 2, 3), "w": round(x1 - x0, 3), "h": round(y1 - y0, 3),
                         "touches_edge": bool(x0 < 0.03 or x1 > 0.97 or y0 < 0.03 or y1 > 0.97)}
        if a.sheet:
            im = Image.open(peaks[0]).convert("RGB").crop(vp).resize((360, 190))
            dr = ImageDraw.Draw(im)
            if box:
                dr.rectangle((box[0] * 360, box[1] * 190, box[2] * 360, box[3] * 190), outline=(0, 255, 0), width=2)
            r = res[name]
            dr.rectangle((0, 0, 360, 14), fill=(0, 0, 0))
            dr.text((3, 1), "%s %s %s" % (name[3:], r["status"], "h%.2f c%.2f,%.2f" % (r["h"], r["cx"], r["cy"]) if box else ""),
                    fill=(255, 255, 0), font=ImageFont.load_default())
            cells.append(im)
    json.dump(res, open(a.out, "w"), indent=1)
    if a.sheet and cells:
        rows = (len(cells) + a.cols - 1) // a.cols
        sh = Image.new("RGB", (a.cols * 362, rows * 192), (20, 20, 20))
        for i, im in enumerate(cells):
            sh.paste(im, ((i % a.cols) * 362, (i // a.cols) * 192))
        sh.save(a.sheet)
    from collections import Counter
    print(Counter(r["status"] for r in res.values()), "edge-touching:", sum(1 for r in res.values() if r.get("touches_edge")))


if __name__ == "__main__":
    main()
