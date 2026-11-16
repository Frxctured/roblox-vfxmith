#!/usr/bin/env python3
"""Offline texture QUALITY index for find_textures.py. Run once by the maintainer, output committed:

    python3 -I kit/scripts/texture_quality.py [--cache DIR] [--procs 18] [--limit N] [--out gallery/textures/quality.json]

Writes gallery/textures/quality.json = {id: {"q": 0..1, "h": 64-bit dHash hex, "f": {measured features}}}.
Needs Pillow + numpy (maintainer only: the search itself never imports numpy). Reads the cached art
(~/.vfxmith/cache/textures: <id>.png originals, <id>.thumb.png thumbnails) and the trait files.

q = clamp(0.70 + sum of the terms below, 0, 1). A term only ever explains one visible fault, so q is readable:
  from traits (texture_traits.py)
    eff        smooth (<48) 0 | low-res sprite 48-127 -0.08 | 128-255 +0.03 | 256+ +0.08 | thumb source -0.03 (uncertain)
    bg         clear 0 | black -0.05 (additive only) | dark -0.12 | faint -0.12 | card -0.30 | unmeasured -0.15
    parts      "lines" or "scatter" -0.05
    fill       hairline (<3%) -0.05 | nearly full frame (>90%) -0.05
  measured here from the image (alpha = alpha channel, or luminance when the image is opaque = black background)
    clip       share of the frame's outer 2 px ring holding art (> 15% of the peak): cut-off art. -0.25 x min(share/0.15, 1)
    pixel      blocky: the 512 px native crop is a nearest-neighbour upscale by k (2..8; pixel art, "low-res sprite").
               -0.20 x clamp((k - 1) / 3) (originals only)
    jpeg       8x8 grid seams: boundary diff / other diff (originals only). -0.15 x clamp((ratio - 1.25) / 0.5)
    dim        weak art: the 99.5th percentile of alpha x (0.3 + 0.7 luma) is under 0.55 (reads faint even at full
               opacity). -0.15 x clamp((0.55 - p) / 0.35)
    colour     black or dark-coloured art (adds little when additive): -0.10
    hard       stair-stepped cut-out: alpha is almost binary (< 4% of the art pixels are partial) on art that is
               not tiny (fill >= 8%), originals under 600 px. -0.10
    band       banded gradient: soft art with only a handful (< 24) of distinct alpha levels. -0.08
    flat       a flat blob: luminance std inside the art < 0.04 and fill > 25%: -0.08; a solid opaque silhouette (80%+
               of the art at full alpha): -0.20
    cells      flipbooks: share of grid cells holding art < 0.6 -> -0.20 x (0.6 - share) / 0.6 (empty cells waste frames)
  The dHash (9x8, alpha-weighted luminance; flipbooks: mean of all cells) lets the search skip near-duplicates (Hamming <= 8).
"""
import argparse
import datetime
import json
import multiprocessing as mp
import os
import re
import time

import numpy as np
from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, "..", ".."))
TEX = os.path.join(ROOT, "gallery", "textures")


def clamp(x, lo=0.0, hi=1.0):
    return max(lo, min(hi, x))


def load_arrays(path):
    im = Image.open(path)
    im.load()
    if im.mode in ("P", "PA"):
        im = im.convert("RGBA")
    if im.mode in ("LA", "La"):
        im = im.convert("RGBA")
    if im.mode == "RGBA":
        a = np.asarray(im, dtype=np.float32) / 255.0
        lum = a[..., 0] * 0.3 + a[..., 1] * 0.59 + a[..., 2] * 0.11
        alpha = a[..., 3]
        if alpha.min() >= 0.98:  # opaque: black background = additive, alpha is the brightness
            alpha = lum
    else:
        a = np.asarray(im.convert("RGB"), dtype=np.float32) / 255.0
        lum = a[..., 0] * 0.3 + a[..., 1] * 0.59 + a[..., 2] * 0.11
        alpha = lum
    return lum, alpha, im.size


def dhash(lum, alpha, g=0):
    v = alpha * (0.3 + 0.7 * lum)
    if g:  # flipbook: hash the mean of all cells (the shape), not the grid layout every sheet shares
        H, W = v.shape
        ch, cw = H // g, W // g
        v = v[:ch * g, :cw * g].reshape(g, ch, g, cw).mean(axis=(0, 2))
    im = Image.fromarray((v * 255).astype(np.uint8)).resize((9, 8), Image.BOX)
    p = np.asarray(im, dtype=np.int32)
    bits = (p[:, :-1] > p[:, 1:]).flatten()
    n = 0
    for b in bits:
        n = (n << 1) | int(b)
    return f"{n:016x}"


def block_factor(v):
    """Largest k (2..8) for which the image is a nearest-neighbour upscale by k (block-replicated pixels), else 1."""
    h, w = v.shape
    best = 1
    for k in range(2, 9):
        hh, ww = h // k * k, w // k * k
        if hh < 64 or ww < 64:
            break
        c = v[:hh, :ww]
        small = c[::k, ::k]
        rep = np.repeat(np.repeat(small, k, 0), k, 1)
        err = float(np.abs(c - rep).mean())
        if err < 0.0015 and float(np.abs(np.diff(small, axis=1)).mean()) > 0.004:
            best = k
    return best


def jpeg_ratio(v):
    h, w = v.shape
    h8, w8 = h // 8 * 8, w // 8 * 8
    if h8 < 32 or w8 < 32:
        return 1.0
    v = v[:h8, :w8]
    rs = []
    for ax in (0, 1):
        d = np.abs(np.diff(v, axis=ax)).mean(axis=1 - ax)
        idx = np.arange(len(d))
        seam = d[idx % 8 == 7].mean()
        rest = d[idx % 8 != 7].mean()
        rs.append(seam / rest if rest > 1e-4 else 1.0)
    return max(rs)


def measure(args):
    tid, path, grid, tr = args
    try:
        lum, alpha, (W, H) = load_arrays(path)
    except Exception as e:
        return tid, None
    thumb = path.endswith(".thumb.png")
    f = {}
    peak = float(alpha.max()) or 1.0
    g = int(grid) if grid and str(grid).isdigit() else 0
    if g and (H < g * 8 or W < g * 8):
        g = 0
    h = dhash(lum, alpha, g)
    art = alpha > 0.15 * peak
    fill = float(art.mean())
    # clipping: outer 2 px ring of the whole image (or of each flipbook cell)
    def ring(a):
        hh, ww = a.shape
        if hh < 8 or ww < 8:
            return 0.0
        m = np.zeros_like(a, bool)
        m[:2], m[-2:], m[:, :2], m[:, -2:] = True, True, True, True
        return float(a[m].mean())
    cells_used = None
    if g:
        ch, cw = H // g, W // g
        rings, used = [], 0
        for r in range(g):
            for c in range(g):
                sub = art[r * ch:(r + 1) * ch, c * cw:(c + 1) * cw]
                if sub.mean() > 0.01:
                    used += 1
                    rings.append(ring(sub))
        cells_used = used / (g * g)
        clip = float(np.mean(rings)) if rings else 0.0
        f["cells"] = round(cells_used, 2)
    else:
        clip = ring(art)
    f["clip"] = round(clip, 3)
    # native crop for pixel/jpeg measures (originals only)
    v = alpha * (0.3 + 0.7 * lum)
    pix, jpg = 1, 1.0
    if not thumb:
        cy, cx = max(0, H // 2 - 256) // 8 * 8, max(0, W // 2 - 256) // 8 * 8
        crop = v[cy:cy + 512, cx:cx + 512]
        pix = block_factor(crop) if crop.std() > 0.02 else 1
        jpg = jpeg_ratio(crop) if crop.std() > 0.02 else 1.0
        f["pix"], f["jpg"] = int(pix), round(float(jpg), 2)
    vis = alpha[art]
    hard = 0.0
    if not thumb and vis.size > 200:
        part = float(((vis > 0.15 * peak) & (vis < 0.95 * peak)).mean())
        f["part"] = round(part, 2)
        if part < 0.04 and fill >= 0.08 and max(W, H) < 600 and alpha.min() < 0.05:
            hard = 1.0
    band = 0.0
    if vis.size > 200:
        lv = len(np.unique((vis * 255).astype(np.uint8)))
        mid = float(((alpha > 0.1 * peak) & (alpha < 0.8 * peak)).mean())
        if lv < 24 and mid > 0.25:
            band = 1.0
    flat = 0.0
    if vis.size > 200:
        sd = float(lum[art].std())
        f["sd"] = round(sd, 3)
        if sd < 0.04 and fill > 0.25:
            solid = float((alpha[art] > 0.9 * peak).mean())
            if solid > 0.8:
                flat = 2.5  # a solid white shape: an opaque silhouette, no gradient
            elif float(alpha[art].std()) < 0.08:
                flat = 1.0
    dim = 0.0
    if vis.size > 200:
        p95 = float(np.percentile(alpha * (0.3 + 0.7 * lum), 99.5))
        f["pk"] = round(p95, 2)
        dim = clamp((0.55 - p95) / 0.35)
    # --- score
    q = 0.70
    eff = tr.get("eff") or 0
    if isinstance(eff, str):
        m = re.search(r"\d+", eff)
        eff = int(m.group()) if m else 0
    if eff >= 256:
        q += 0.08
    elif eff >= 128:
        q += 0.03
    elif eff >= 48:
        q -= 0.08
    if tr.get("src") == "thumb" or thumb:
        q -= 0.03
    bg = str(tr.get("bg", ""))
    q += {"clear": 0.0, "black": -0.05, "dark": -0.12, "faint": -0.12, "card": -0.30}.get(bg, -0.15)
    parts = str(tr.get("parts", ""))
    if "lines" in parts or "scatter" in parts:
        q -= 0.05
    tf = tr.get("fill")
    if tf is not None:
        if tf < 3:
            q -= 0.05
        elif tf > 90:
            q -= 0.05
    q -= 0.25 * min(clip / 0.15, 1.0)
    q -= 0.20 * clamp((pix - 1) / 3.0)
    q -= 0.15 * clamp((jpg - 1.25) / 0.5)
    q -= 0.15 * dim
    if str(tr.get("colour", "")) == "black" or str(tr.get("colour", "")).startswith("dark"):
        q -= 0.10
    q -= 0.10 * hard
    q -= 0.08 * band
    q -= 0.08 * flat  # 1.0 flat blob, 2.5 solid silhouette (-0.20)
    if cells_used is not None and cells_used < 0.6:
        q -= 0.20 * (0.6 - cells_used) / 0.6
    return tid, {"q": round(float(clamp(q)), 3), "h": h, "f": f}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--cache", default=os.path.expanduser("~/.vfxmith/cache/textures"))
    ap.add_argument("--procs", type=int, default=18)
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--out", default=os.path.join(TEX, "quality.json"))
    a = ap.parse_args()
    traits, grids = {}, {}
    for fn in ("traits.json", "traits_vfxstudio.json"):
        for k, v in json.load(open(os.path.join(TEX, fn))).items():
            if isinstance(v, dict) and "fail" not in v and k != "_about":
                traits[k] = v
    for v in json.load(open(os.path.join(TEX, "index.json"))).values():
        if v.get("flip"):
            grids[str(v["id"])] = str(max(v["flip"], key=lambda x: x[1])[0]).replace("Grid", "").split("x")[0]
    for k, v in json.load(open(os.path.join(TEX, "vfxstudio_index.json"))).items():
        if v.get("Grid") and k not in grids:
            grids[k] = str(v["Grid"])
    jobs = []
    for k in set(traits) | set(grids):
        for nm in (f"{k}.png", f"{k}.thumb.png"):
            p = os.path.join(a.cache, nm)
            if os.path.exists(p):
                jobs.append((k, p, grids.get(k), traits.get(k, {})))
                break
    jobs.sort()
    if a.limit:
        jobs = jobs[:a.limit]
    t0 = time.time()
    out = {}
    with mp.Pool(a.procs) as pool:
        for tid, r in pool.imap_unordered(measure, jobs, chunksize=32):
            if r:
                out[tid] = r
    out = {"_about": {"made_by": "kit/scripts/texture_quality.py (terms in its docstring)",
                      "date": datetime.date.today().isoformat(), "count": len(out)}, **dict(sorted(out.items()))}
    json.dump(out, open(a.out, "w"), separators=(",", ":"))
    print(f"{len(out) - 1} textures in {time.time() - t0:.0f}s -> {a.out}")


if __name__ == "__main__":
    main()
