#!/usr/bin/env python3
"""reflift.py: lift single elements out of a reference recording into textures (replicate mode, optional).

    python3 -I kit/reflift.py REF --at 0.42 --box 0.40,0.30,0.20,0.20 --name crackle [--out tex]
    python3 -I kit/reflift.py REF --at 0.42 --auto 6                       the 6 biggest separate pieces at 0.42 s
    python3 -I kit/reflift.py REF --flipbook 0.30,0.90 --grid 4 --box ...  16 frames of one region as a Grid4x4 sheet

Hand-drawn guesses at a texture tend to come out too clean: a neat star where the reference has a torn flame, string
where it has a crackle. The reference itself already has the real edges, grain and taper. On a dark (or plain) stage
the effect can be keyed out of a frame: the difference from the empty stage becomes the picture and its alpha.

REF is a video (needs ffmpeg) or a still image. --at is seconds into the video.
Base (the empty stage, keyed away): --base first (default for video: the first frame) | min (per-pixel minimum of
  frames spread over the video) | black | <image>. A still needs --base <empty stage image> or black.
Modes (--mode):
  light  (default) the element ADDS light (fire, sparks, glow, crackle on a dark stage). Writes the added colour with
         alpha = its strength; use it additive (LightEmission 1) or with normal blend on dark scenes.
  dark   the element HIDES the stage (smoke or debris in daylight): alpha = how much darker it is than the stage.
  diff   either way (absolute difference); fine for smoke lit on a dark stage.
--grey writes a white/grey picture (shape and grain only) so Color / ColorSequence tints it in Roblox. Default keeps
  the reference's colours (then set Color to white).
--feather (default 0.12 of the box) fades the box edges so no hard square shows; --floor (default 12, 0-255) drops
  faint noise; --gain scales the alpha (default 1.0; above 1 for a thin element that comes out too faint).
--size N: the output is N x N (default 256; flipbook cells too). The box keeps its own aspect, padded square.
--auto N finds the N biggest separate bright (or dark) pieces in the frame and cuts a square around each.
--sheet PNG writes a preview of everything lifted, over a checkerboard and over black.
Install into Studio with maketex.py:  python3 -I kit/maketex.py --install my_fx --files tex/*.png

RIGHTS: this copies pixels from the recording. Use it only on effects the user made, owns, or may copy (open-source,
licensed, their own). For someone else's protected effect, use the frames as a guide and draw textures yourself.
Pure Python + Pillow + numpy.
"""
import argparse
import io
import math
import os
import subprocess
import sys

try:
    import numpy as np
    from PIL import Image, ImageDraw
except ImportError:
    sys.exit("reflift.py needs numpy and Pillow (pip install numpy pillow)")

VIDEO = (".mp4", ".mov", ".webm", ".mkv", ".avi", ".gif")


def floats(s):
    return [float(v) for v in str(s).replace(" ", ",").split(",") if v != ""]


def duration(path):
    r = subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", path],
                       capture_output=True, text=True)
    try:
        return float(r.stdout.strip())
    except ValueError:
        sys.exit("cannot read %s (is ffmpeg installed?)" % path)


def frame(path, t):
    r = subprocess.run(["ffmpeg", "-v", "error", "-ss", "%.4f" % max(0.0, t), "-i", path, "-frames:v", "1",
                        "-f", "image2pipe", "-vcodec", "png", "-"], capture_output=True)
    if not r.stdout:
        sys.exit("ffmpeg could not cut %s at %.3f s" % (path, t))
    return np.asarray(Image.open(io.BytesIO(r.stdout)).convert("RGB"), np.float32)


def load(path, t):
    if path.lower().endswith(VIDEO):
        return frame(path, t)
    return np.asarray(Image.open(path).convert("RGB"), np.float32)


def make_base(a, shape):
    if a.base == "black":
        return np.zeros(shape, np.float32)
    is_video = a.ref.lower().endswith(VIDEO)
    if a.base in (None, "first"):
        if not is_video:
            sys.exit("a still needs --base <empty stage image> or --base black")
        return frame(a.ref, 0.0)
    if a.base == "min":
        if not is_video:
            sys.exit("--base min needs a video")
        d = duration(a.ref)
        fr = [frame(a.ref, d * k / 12) for k in range(12)]
        return np.minimum.reduce(fr)
    return np.asarray(Image.open(a.base).convert("RGB"), np.float32)


def blur(x, s):
    if s <= 0:
        return x
    r = max(1, int(math.ceil(3 * s)))
    k = np.exp(-0.5 * (np.arange(-r, r + 1) / s) ** 2)
    k /= k.sum()
    p = np.pad(x, ((0, 0), (r, r)), mode="edge")
    y = sum(k[i] * p[:, i:i + x.shape[1]] for i in range(2 * r + 1))
    p = np.pad(y, ((r, r), (0, 0)), mode="edge")
    return sum(k[i] * p[i:i + x.shape[0], :] for i in range(2 * r + 1))


def key(img, base, mode, floor, gain):
    """-> rgb (0..1, HxWx3), alpha (0..1, HxW)"""
    d = img - base
    if mode == "light":
        add = np.clip(d, 0, None)
        al = add.max(axis=2)
        rgb = add / np.maximum(al, 1e-3)[..., None]       # the added colour at full strength
    elif mode == "dark":
        lb = base.mean(axis=2)
        dark = np.clip(lb - img.mean(axis=2), 0, None)
        al = 255 * dark / np.maximum(lb, 24)
        rgb = img / 255.0                                  # what covers the stage: its own colour
    else:
        al = np.abs(d).max(axis=2)
        rgb = img / 255.0
    al = np.clip((al - floor) / max(1.0, 255 - floor), 0, 1) * gain
    return np.clip(rgb, 0, 1), np.clip(al, 0, 1)


def parse_box(s, W, H):
    v = floats(s)
    if len(v) != 4:
        sys.exit("--box x,y,w,h (fractions of the frame, or pixels)")
    if max(v) <= 1.0:
        v = [v[0] * W, v[1] * H, v[2] * W, v[3] * H]
    x, y, w, h = (int(round(c)) for c in v)
    return max(0, x), max(0, y), min(W - max(0, x), w), min(H - max(0, y), h)


def auto_boxes(img, base, mode, n):
    """boxes (x, y, w, h px) around the n biggest separate pieces of the element mask."""
    d = img - base
    if mode == "light":
        m = np.clip(d, 0, None).max(axis=2)
    elif mode == "dark":
        m = np.clip(base.mean(axis=2) - img.mean(axis=2), 0, None)
    else:
        m = np.abs(d).max(axis=2)
    H, W = m.shape
    sc = max(1, int(W // 480))                           # work small, it only finds the boxes
    small = m[::sc, ::sc]
    sm = blur(small, 1.0)
    pk = float(np.percentile(sm, 99.8))
    tot = sm.size
    found = []
    # from a high threshold down: keep pieces that are separate (not the whole effect) and not specks
    best = []
    for frac in (0.7, 0.5, 0.35, 0.22):
        allp = pieces(sm > max(30.0, frac * pk))
        found = [c for c in allp if 0.0004 * tot <= c[0] <= 0.12 * tot]
        if len(found) > len(best):
            best = found
        if len(found) >= n:
            break
    found = best or sorted(pieces(sm > max(30.0, 0.5 * pk)), reverse=True)[:1]  # one big piece: take it whole
    return [box_of(c, sc, W, H) for c in sorted(found, reverse=True)[:n]]


def box_of(c, sc, W, H):
    area, x0, y0, x1, y1 = c
    cx, cy = (x0 + x1 + 1) / 2 * sc, (y0 + y1 + 1) / 2 * sc
    s = max(24, 1.3 * max(x1 - x0 + 1, y1 - y0 + 1) * sc)
    bx, by = int(max(0, cx - s / 2)), int(max(0, cy - s / 2))
    return (bx, by, int(min(W - bx, s)), int(min(H - by, s)))


def pieces(mask):
    """connected pieces of a small bool mask: [(area, x0, y0, x1, y1)]"""
    lab = np.full(mask.shape, -1, np.int64)
    comps, cur = [], 0
    h, w = mask.shape
    for y0 in range(h):                                   # flood fill (small images, so plain Python is fine)
        for x0 in range(w):
            if not mask[y0, x0] or lab[y0, x0] >= 0:
                continue
            st, pts = [(y0, x0)], []
            lab[y0, x0] = cur
            while st:
                y, x = st.pop()
                pts.append((y, x))
                for yy in (y - 1, y, y + 1):
                    for xx in (x - 1, x, x + 1):
                        if 0 <= yy < h and 0 <= xx < w and mask[yy, xx] and lab[yy, xx] < 0:
                            lab[yy, xx] = cur
                            st.append((yy, xx))
            ys, xs = zip(*pts)
            comps.append((len(pts), min(xs), min(ys), max(xs), max(ys)))
            cur += 1
    return comps


def feather_mask(h, w, f):
    if f <= 0:
        return np.ones((h, w), np.float32)
    def ramp(n):
        e = max(1.0, f * n)
        i = np.arange(n, dtype=np.float32)
        return np.clip(np.minimum(i + 0.5, n - i - 0.5) / e, 0, 1)
    r = np.outer(ramp(h), ramp(w))
    return (r * r * (3 - 2 * r)).astype(np.float32)


def to_square(rgb, al, size):
    """pad the box to a square (centred), resize to size x size."""
    h, w = al.shape
    s = max(h, w)
    R = np.zeros((s, s, 3), np.float32)
    A = np.zeros((s, s), np.float32)
    y, x = (s - h) // 2, (s - w) // 2
    R[y:y + h, x:x + w], A[y:y + h, x:x + w] = rgb, al
    img = np.concatenate([R, A[..., None]], -1)
    im = Image.fromarray((np.clip(img, 0, 1) * 255).astype(np.uint8), "RGBA")
    return im.resize((size, size), Image.LANCZOS)


def lift(img, base, box, a):
    x, y, w, h = box
    rgb, al = key(img[y:y + h, x:x + w], base[y:y + h, x:x + w], a.mode, a.floor, a.gain)
    al = al * feather_mask(h, w, a.feather)
    if a.grey:
        lum = rgb @ np.array([0.299, 0.587, 0.114], np.float32)
        rgb = np.repeat((0.35 + 0.65 * lum / max(1e-3, lum.max()))[..., None], 3, axis=2)
    return to_square(rgb, al, a.size)


def checker(size, n=8):
    im = Image.new("RGB", (size, size), (200, 200, 200))
    d = ImageDraw.Draw(im)
    c = size // n
    for i in range(n):
        for j in range(n):
            if (i + j) % 2:
                d.rectangle([i * c, j * c, i * c + c - 1, j * c + c - 1], fill=(150, 150, 150))
    return im


def sheet(paths, out, cell=180):
    rows = len(paths)
    im = Image.new("RGB", (2 * cell + 260, rows * (cell + 6) + 6), (24, 24, 28))
    d = ImageDraw.Draw(im)
    for r, p in enumerate(paths):
        t = Image.open(p).convert("RGBA").resize((cell, cell), Image.LANCZOS)
        y = 6 + r * (cell + 6)
        bg = checker(cell)
        bg.paste(t, (0, 0), t)
        im.paste(bg, (6, y))
        blk = Image.new("RGB", (cell, cell), (0, 0, 0))
        blk.paste(t, (0, 0), t)
        im.paste(blk, (12 + cell, y))
        d.text((20 + 2 * cell, y + 6), os.path.basename(p), fill=(230, 230, 230))
    im.save(out)
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("ref")
    ap.add_argument("--at", type=float, default=0.0, help="seconds into the video")
    ap.add_argument("--box", action="append", default=[], help="x,y,w,h (fractions or px); repeat for several")
    ap.add_argument("--auto", type=int, help="cut the N biggest separate pieces")
    ap.add_argument("--flipbook", help="t0,t1: a flipbook of the (first) box from t0 to t1 s")
    ap.add_argument("--grid", type=int, default=4, choices=(2, 4, 8), help="flipbook grid (2, 4 or 8)")
    ap.add_argument("--base")
    ap.add_argument("--mode", default="light", choices=("light", "dark", "diff"))
    ap.add_argument("--grey", action="store_true")
    ap.add_argument("--feather", type=float, default=0.12)
    ap.add_argument("--floor", type=float, default=12)
    ap.add_argument("--gain", type=float, default=1.0)
    ap.add_argument("--size", type=int, default=256)
    ap.add_argument("--name", default="lift")
    ap.add_argument("--out", default="tex")
    ap.add_argument("--sheet")
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)
    img = load(a.ref, a.at)
    base = make_base(a, img.shape)
    if base.shape != img.shape:
        base = np.asarray(Image.fromarray(base.astype(np.uint8)).resize((img.shape[1], img.shape[0])), np.float32)
    H, W = img.shape[:2]
    boxes = [parse_box(b, W, H) for b in a.box]
    if a.auto:
        boxes += auto_boxes(img, base, a.mode, a.auto)
    if not boxes:
        sys.exit("nothing to cut: give --box x,y,w,h, or --auto N found no element at this time (try another --at)")
    written = []
    if a.flipbook:
        t0, t1 = floats(a.flipbook)[:2]
        n = a.grid * a.grid
        cells = []
        for k in range(n):
            t = t0 + (t1 - t0) * k / max(1, n - 1)
            cells.append(lift(load(a.ref, t), base, boxes[0], a))
        cs = a.size
        book = Image.new("RGBA", (cs * a.grid, cs * a.grid), (0, 0, 0, 0))
        for k, c in enumerate(cells):
            book.paste(c, ((k % a.grid) * cs, (k // a.grid) * cs))
        p = os.path.join(a.out, "%s_grid%dx%d.png" % (a.name, a.grid, a.grid))
        book.save(p)
        written.append(p)
        print("wrote", p, "(FlipbookLayout = Grid%dx%d, %d frames from %.2f to %.2f s)" % (a.grid, a.grid, n, t0, t1))
    else:
        for i, b in enumerate(boxes):
            p = os.path.join(a.out, ("%s.png" % a.name) if len(boxes) == 1 else ("%s_%d.png" % (a.name, i + 1)))
            lift(img, base, b, a).save(p)
            written.append(p)
            print("wrote %s  (box x %.3f y %.3f w %.3f h %.3f of the frame)" % (p, b[0] / W, b[1] / H, b[2] / W,
                                                                                b[3] / H))
    if a.sheet:
        print("wrote", sheet(written, a.sheet))
    print("RIGHTS: lifted from the reference; only for effects the user owns or may copy.")


if __name__ == "__main__":
    main()
