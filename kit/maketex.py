#!/usr/bin/env python3
"""maketex: draw textures in code (PNG with alpha) and put them where Studio can load them. Optional.

    python3 -I kit/maketex.py --list                          the ready shapes
    python3 -I kit/maketex.py glow ring face_scream --out tex  write PNGs into ./tex
    python3 -I kit/maketex.py glow ring --install my_fx        also copy into Studio's content folder and print
                                                              the rbxasset:// paths to use in Luau
    python3 -I kit/maketex.py --install my_fx --files a.png b.png   install PNGs you drew yourself

Your own shapes: write a small script that imports this file and uses the helpers (numpy arrays, values 0..1):

    import sys; sys.path.insert(0, "<this folder>"); from maketex import *
    u, v = grid(256)                      # coordinates -1..1 (v grows downward)
    r = np.hypot(u, v)
    a = ss(1.0, 0.6, r) * (0.7 + 0.3 * fbm(256, seed=3))
    save("blob.png", np.ones_like(a), a, out="tex")     # rgb (2-D grey or HxWx3) and alpha

Loading in Studio: an installed PNG is `rbxasset://<folder>/<name>_vN.png` (Texture of a ParticleEmitter, Beam,
Decal, ImageLabel ...). It loads in Edit mode in this Studio only (it is a local file, not an uploaded asset), so keep
the PNGs next to final.luau and say in its header how to install them. Studio caches a path for the whole session,
so every --install writes a new version number; use the printed paths. Beams map U across the width and V along the
length. White art tints cleanly with Color; LightEmission 1 adds light, 0 covers.
"""
import argparse
import glob
import math
import os
import re
import shutil
import sys

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

# ============================================================================================ helpers

def ss(e0, e1, x):
    """smoothstep from e0 to e1 (e0 > e1 gives a falling edge)."""
    t = np.clip((x - e0) / (e1 - e0), 0, 1)
    return t * t * (3 - 2 * t)


def grid(n, m=None):
    """u, v in -1..1 for an n x m image (v down)."""
    m = m or n
    v, u = np.mgrid[0:m, 0:n]
    return (u + 0.5) / n * 2 - 1, (v + 0.5) / m * 2 - 1


def value_noise(n, cells, seed):
    r = np.random.default_rng(seed)
    g = r.random((cells + 1, cells + 1))
    g[:, -1] = g[:, 0]
    g[-1, :] = g[0, :]
    img = Image.fromarray((g * 255).astype(np.uint8)).resize((n, n), Image.BICUBIC)
    return np.asarray(img).astype(np.float32) / 255


def fbm(n, seed=0, octaves=5, base=4):
    """soft cloudy noise 0..1 (tiles horizontally)."""
    out = np.zeros((n, n), np.float32)
    amp, tot = 1.0, 0.0
    for o in range(octaves):
        out += amp * value_noise(n, base * 2 ** o, seed + o)
        tot += amp
        amp *= 0.5
    return out / tot


def blur(a, px):
    img = Image.fromarray((np.clip(a, 0, 1) * 255).astype(np.uint8))
    return np.asarray(img.filter(ImageFilter.GaussianBlur(px))).astype(np.float32) / 255


def canvas(n, m=None):
    """a PIL 'L' image + ImageDraw for strokes (lines, polygons); turn it into an array with arr()."""
    img = Image.new("L", (n, m or n), 0)
    return img, ImageDraw.Draw(img)


def arr(img):
    return np.asarray(img).astype(np.float32) / 255


def save(name, rgb, a, out="."):
    """write name (PNG, RGBA). rgb: HxW grey or HxWx3; a: HxW alpha. Values 0..1."""
    os.makedirs(out, exist_ok=True)
    rgb = np.clip(rgb, 0, 1)
    a = np.clip(a, 0, 1)
    if rgb.ndim == 2:
        rgb = np.stack([rgb] * 3, -1)
    img = np.concatenate([rgb, a[..., None]], -1)
    p = os.path.join(out, name if name.endswith(".png") else name + ".png")
    Image.fromarray((img * 255).astype(np.uint8), "RGBA").save(p)
    return p


# ============================================================================================ ready shapes
def glow(out):
    """soft round glow."""
    u, v = grid(128)
    r = np.hypot(u, v)
    a = np.exp(-(r / 0.42) ** 2) * ss(1.0, 0.8, r)
    return save("glow", np.ones_like(a), a, out)


def dot(out):
    """bright dot with a soft halo (sparks, embers)."""
    u, v = grid(64)
    r = np.hypot(u, v)
    a = np.clip(np.exp(-(r / 0.12) ** 2) + 0.35 * np.exp(-(r / 0.4) ** 2), 0, 1) * ss(1, 0.8, r)
    return save("dot", np.ones_like(a), a, out)


def ring(out):
    """thin clean ring."""
    u, v = grid(256)
    r = np.hypot(u, v)
    a = np.exp(-((r - 0.8) / 0.06) ** 2) * ss(1.0, 0.93, r)
    return save("ring", np.ones_like(a), a, out)


def ring_soft(out):
    """thick soft noisy ring (shockwaves, ground glow)."""
    u, v = grid(256)
    r = np.hypot(u, v)
    n = fbm(256, 44, 4, 6)
    a = (np.exp(-((r - 0.75) / 0.14) ** 2) * (0.6 + 0.4 * n) + 0.05 * ss(0.8, 0.2, r)) * ss(1.0, 0.9, r)
    return save("ring_soft", np.ones_like(a), a, out)


def shock(out):
    """spiky starburst ring."""
    u, v = grid(256)
    r = np.hypot(u, v)
    th = np.arctan2(v, u)
    spikes = 0.5 + 0.5 * np.cos(th * 18) * (0.6 + 0.4 * np.cos(th * 7 + 1))
    edge = 0.62 + 0.3 * spikes
    a = ss(edge, edge - 0.12, r) * ss(0.25, 0.55, r)
    return save("shock", np.ones_like(a), a, out)


def star4(out):
    """four-point twinkle star."""
    u, v = grid(128)
    r = np.hypot(u, v)
    rays = np.exp(-(np.abs(u) / 0.035) ** 1.2) * ss(1, 0, np.abs(v)) + np.exp(-(np.abs(v) / 0.035) ** 1.2) * ss(1, 0, np.abs(u))
    a = np.clip(rays + np.exp(-(r / 0.12) ** 2), 0, 1) * ss(1.0, 0.85, r)
    return save("star4", np.ones_like(a), a, out)


def streak(out):
    """long thin soft streak along V (vertical): for speed lines or sparks stretched along motion."""
    u, v = grid(64, 256)
    a = np.exp(-(u / 0.22) ** 2) * ss(1.0, 0.2, np.abs(v)) ** 0.8
    return save("streak", np.ones_like(a), a, out)


def smoke(out):
    """cloudy puff with shading."""
    u, v = grid(256)
    r = np.hypot(u, v)
    n = fbm(256, 33, 5, 3)
    a = ss(0.95, 0.3, r + (n - 0.5) * 0.6) * (0.5 + 0.5 * n)
    lum = 0.55 + 0.45 * n
    return save("smoke", lum, a, out)


def wisp(out):
    """beam texture: soft flowing strands (U across the width, V along the length)."""
    W, H = 128, 256
    rng = np.random.default_rng(5)
    x = np.linspace(-1, 1, W)[None, :]
    y = np.linspace(0, 1, H, endpoint=False)[:, None]
    s = np.zeros((H, W))
    for k, (f, amp) in enumerate([(5, 0.5), (11, 0.3), (23, 0.2)]):
        s += amp * (0.5 + 0.5 * np.sin(x * f * math.pi + rng.random() * 6.28 + 1.3 * np.sin(2 * math.pi * y * (k + 1))))
    core = np.exp(-(x / 0.5) ** 2)
    a = np.clip(core * (0.5 + 0.6 * s), 0, 1)
    return save("wisp", np.ones_like(a), a, out)


def crack(out):
    """branching ground cracks (white: tint them)."""
    N = 512
    img, dr = canvas(N)
    rng = np.random.default_rng(11)
    c = N / 2

    def walk(x, y, ang, length, width, depth):
        steps = int(length / 5)
        base = ang
        for i in range(steps):
            ang += rng.normal(0, 0.35) + (base - ang) * 0.35
            nx, ny = x + math.cos(ang) * 5, y + math.sin(ang) * 5
            dr.line([(x, y), (nx, ny)], fill=255, width=max(1, int(round(width * (1 - i / steps) + 1))))
            x, y = nx, ny
            if math.hypot(x - c, y - c) > N * 0.47:
                break
            if depth < 2 and rng.random() < 0.06:
                walk(x, y, ang + rng.choice([-1, 1]) * rng.uniform(0.5, 1.0), length * 0.45, width * 0.6, depth + 1)

    for i in range(10):
        a0 = i / 10 * 2 * math.pi + rng.uniform(-0.2, 0.2)
        walk(c + math.cos(a0) * 16, c + math.sin(a0) * 16, a0, rng.uniform(150, 235), 5, 0)
    core = arr(img)
    a = np.clip(core + blur(core, 3) * 0.8, 0, 1)
    return save("crack", np.ones_like(a), a, out)


def scorch(out):
    """dark burnt ground mark."""
    u, v = grid(256)
    r = np.hypot(u, v)
    n = fbm(256, 21, 5, 4)
    edge = 0.72 + 0.28 * (n - 0.5) * 2
    a = ss(edge, edge - 0.35, r) * (0.7 + 0.3 * n)
    lum = 0.06 + 0.1 * n
    return save("scorch", lum, a, out)


def _face(out, name, mouth_open, brow):
    """a simple glowing spirit face: soft head, dark eyes and mouth (cut out of the glow)."""
    N = 256
    u, v = grid(N)
    d = np.hypot(u / 0.62, (v + 0.02) / 0.78)
    body = ss(1.0, 0.75, d)
    noise = fbm(N, 3, 4, 4)
    a = body * (0.8 + 0.2 * noise) + 0.35 * np.exp(-((d - 1.0) / 0.2) ** 2)

    def ell(cx, cy, rx, ry, ang):
        ca, sa = math.cos(ang), math.sin(ang)
        x, y = u - cx, v - cy
        return np.hypot((x * ca + y * sa) / rx, (-x * sa + y * ca) / ry)

    eyes = np.maximum(ss(1.05, 0.6, ell(-0.22, -0.18, 0.13, 0.09, brow)), ss(1.05, 0.6, ell(0.22, -0.18, 0.13, 0.09, -brow)))
    mouth = ss(1.05, 0.6, ell(0, 0.28, 0.12 + 0.05 * mouth_open, 0.05 + 0.2 * mouth_open, 0))
    dark = np.clip(eyes + mouth, 0, 1)
    lum = (0.6 + 0.4 * ss(0.4, 0.95, d)) * (1 - dark)
    a = np.maximum(a, dark * body)
    return save(name, lum, np.clip(a, 0, 1), out)


def face_scream(out):
    """glowing spirit face, mouth wide open."""
    return _face(out, "face_scream", 1.0, -0.4)


def face_calm(out):
    """glowing spirit face, calm."""
    return _face(out, "face_calm", 0.15, 0.15)


def petal(out):
    """single petal / leaf."""
    u, v = grid(128)
    w = 0.55 * np.sin(np.clip((v + 1) / 2, 0, 1) * math.pi) ** 0.8
    a = ss(1.0, 0.85, np.abs(u) / np.maximum(w, 1e-3)) * ss(1.0, 0.9, np.abs(v))
    lum = 0.75 + 0.25 * ss(0.8, 0.0, np.abs(u) / np.maximum(w, 1e-3))
    return save("petal", lum, a, out)


SHAPES = {f.__name__: f for f in (glow, dot, ring, ring_soft, shock, star4, streak, smoke, wisp, crack, scorch,
                                  face_scream, face_calm, petal)}


# ============================================================================================ Studio content folder
def content_dir():
    """Studio's local content folder (rbxasset://...): Vinegar (Linux), then Windows and macOS installs."""
    pats = [os.path.expanduser("~/.var/app/org.vinegarhq.Vinegar/data/vinegar/versions/*/content"),
            os.path.expanduser("~/.local/share/vinegar/versions/*/content"),
            os.path.expandvars(r"%LOCALAPPDATA%/Roblox Studio/Versions/*/content"),
            os.path.expandvars(r"%LOCALAPPDATA%/Roblox/Versions/*/content"),
            "/Applications/RobloxStudio.app/Contents/Resources/content"]
    found = [d for p in pats for d in glob.glob(p) if os.path.isdir(d)]
    if not found:
        sys.exit("Studio content folder not found (looked in Vinegar, %LOCALAPPDATA% and /Applications)")
    return max(found, key=os.path.getmtime)


def install(folder, files):
    """copy PNGs into <content>/<folder>/ with a new version suffix each time; returns rbxasset paths."""
    if not re.fullmatch(r"[A-Za-z0-9_\-]+", folder):
        sys.exit("folder name: letters, digits, _ and - only")
    dst = os.path.join(content_dir(), folder)
    os.makedirs(dst, exist_ok=True)
    out = []
    for f in files:
        base = os.path.splitext(os.path.basename(f))[0]
        ver = 1 + max([int(m.group(1)) for x in os.listdir(dst)
                       for m in [re.fullmatch(re.escape(base) + r"_v(\d+)\.png", x)] if m] or [0])
        name = f"{base}_v{ver}.png"
        shutil.copy(f, os.path.join(dst, name))
        out.append(f"rbxasset://{folder}/{name}")
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("shapes", nargs="*")
    ap.add_argument("--out", default="tex")
    ap.add_argument("--install", metavar="FOLDER")
    ap.add_argument("--files", nargs="+", default=[])
    ap.add_argument("--list", action="store_true")
    a = ap.parse_args()
    if a.list or (not a.shapes and not a.files):
        for k, f in SHAPES.items():
            print(f"{k:12s} {(f.__doc__ or '').strip()}")
        return
    files = list(a.files)
    for s in a.shapes:
        if s not in SHAPES:
            sys.exit(f"unknown shape {s}; --list shows them")
        files.append(SHAPES[s](a.out))
    for f in files:
        print("wrote", f) if f not in a.files else None
    if a.install:
        for p in install(a.install, files):
            print(p)


if __name__ == "__main__":
    main()
