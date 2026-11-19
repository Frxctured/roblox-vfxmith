#!/usr/bin/env python3
"""maketex: draw textures in code (PNG with alpha) and put them where Studio can load them. Optional.

    python3 -I kit/maketex.py --list                          the ready shapes
    python3 -I kit/maketex.py glow ring face_scream --out tex  write PNGs into ./tex
    python3 -I kit/maketex.py glow ring --install my_fx        also copy into Studio's content folder and print
                                                              the rbxasset:// paths to use in Luau
    python3 -I kit/maketex.py --install my_fx --files a.png b.png   install PNGs you drew yourself
    python3 -I kit/maketex.py flame_burst --set ragged=0.9 grain=0.4 --name burst2 --sheet tex/sheet.png
                                                              shape parameters, a variant name, a contact sheet

Detail shapes (for matching a reference's small elements; edges are hard on purpose): flame_burst, flame_shard, arc,
swoosh, spark_streak, smoke_wisp, glint, crack_line, glitter. --list shows each one's parameters (ragged, taper,
thickness, grain, wisp, length, ...).

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


# ---------------------------------------------------------------------------------- detail shapes (replicate mode)
# Small elements get their look from the texture: raggedness, taper, thinness and grain live in the PNG, not in the
# emitter. Each takes parameters (python3 -I maketex.py flame_burst --set ragged=0.9 grain=0.5 seed=4). Hard edges
# are drawn hard on purpose: a soft round blob never stands in for a ragged, streaky or thin element.

def _wrap(a):
    return (a + math.pi) % (2 * math.pi) - math.pi


def _grain(n, m, amount, seed, cell=1.5):
    """fine speckle noise 0..1 (1 = no change) for texture grain."""
    if amount <= 0:
        return 1.0
    r = np.random.default_rng(seed)
    g = r.random((max(2, int(m / cell)), max(2, int(n / cell))))
    g = np.asarray(Image.fromarray((g * 255).astype(np.uint8)).resize((n, m), Image.BILINEAR)).astype(np.float32) / 255
    return 1 - amount * g


def flame_burst(out, ragged=0.7, spikes=9, grain=0.3, seed=1, name="flame_burst"):
    """ragged flame burst: fat, notched flame shards fanning from a hot core, hard cartoon edge (additive, tint it)."""
    N = 512
    u, v = grid(N)
    r, th = np.hypot(u, v), np.arctan2(v, u)
    rng = np.random.default_rng(seed)
    edge = np.full_like(r, 0.3)
    k = int(spikes)
    for i in range(k):  # each shard: a pointed lobe with its own length, width and a little bend
        c = (i + rng.uniform(-0.3, 0.3)) / k * 2 * math.pi - math.pi
        L = rng.uniform(0.55, 0.97)
        w = rng.uniform(0.6, 1.3) * math.pi / k
        d = np.abs(_wrap(th - c - 0.35 * ragged * (r - 0.3) * rng.uniform(-1, 1)))
        edge = np.maximum(edge, 0.3 + (L - 0.3) * np.clip(1 - d / w, 0, 1) ** rng.uniform(1.0, 1.8))
    # notches: saw-tooth jaggies along the outline (bigger further out), plus a few bites out of the shards
    saw = sum(((th * f / (2 * math.pi) + rng.random()) % 1.0 - 0.5) / f * 8 for f in (17, 29, 47))
    edge = edge * (1 + 0.12 * ragged * saw * ss(0.3, 0.6, edge)) + 0.05 * ragged * (fbm(N, seed + 7, 3, 8) - 0.5)
    a = ss(edge, edge - 0.012, r)  # hard edge (about 3 px at 512)
    for _ in range(int(round(5 * ragged))):
        c = rng.uniform(-math.pi, math.pi)
        rr = rng.uniform(0.45, 0.75)
        bx, by = rr * math.cos(c), rr * math.sin(c)
        a = a * ss(0.0, 0.012, np.hypot(u - bx, v - by) - rng.uniform(0.04, 0.08))
    lum = 0.85 + 0.15 * ss(0.7, 0.0, r / np.maximum(edge, 1e-3))  # white-hot core, slightly darker tips
    a = a * _grain(N, N, grain * 0.4, seed + 3)
    return save(name, lum, np.clip(a, 0, 1), out)


def flame_shard(out, ragged=0.6, grain=0.2, seed=2, name="flame_shard"):
    """one sharp flame shard / tongue along V (point at the top), notched hard edge: for flung burst pieces."""
    W, H = 128, 512
    u, v = grid(W, H)
    t = (v + 1) / 2  # 0 = tip (top) .. 1 = base
    rng = np.random.default_rng(seed)
    width = 0.95 * t ** 0.7 * (1 - t ** 6)
    width = width * (1 + 0.25 * ragged * np.sin(t * 40 + rng.uniform(0, 6)) * (t < 0.8))
    bend = 0.15 * ragged * np.sin(t * 5 + seed)
    a = ss(1.0, 0.92, np.abs(u - bend) / np.maximum(width, 1e-3))
    lum = 0.6 + 0.4 * ss(0.8, 0.0, np.abs(u - bend) / np.maximum(width, 1e-3))
    a = a * _grain(W, H, grain * 0.5, seed)
    return save(name, lum, a, out)


def arc(out, sweep=200, thickness=0.05, taper=1.0, curl=0.0, grain=0.0, halo=0.25, seed=3, name="arc"):
    """thin arc / swoosh stroke with tapering ends (wind swirl arcs, slash trails). curl > 0 = spirals inward
    (a hook / claw swoosh). thickness = half width at the middle (fraction of the image), taper 0 = blunt ends."""
    N = 512
    u, v = grid(N)
    r, th = np.hypot(u, v), np.arctan2(-v, u)
    sw = math.radians(sweep)
    s = ((th + math.pi / 2 + sw / 2) % (2 * math.pi)) / sw  # 0..1 along the stroke where inside the sweep
    inside = (s >= 0) & (s <= 1)
    R = 0.82 * (1 - curl * np.clip(s, 0, 1))
    w = thickness * np.where(inside, np.sin(np.clip(s, 0, 1) * math.pi) ** max(taper, 1e-3), 0)
    dist = np.abs(r - R)
    core = ss(1.0, 0.75, dist / np.maximum(w, 1e-4)) * inside
    glow = halo * np.exp(-(dist / np.maximum(w * 3, 1e-4)) ** 2) * inside
    a = np.clip(core + glow, 0, 1)
    if grain > 0:  # streaks running along the stroke
        a = a * (1 - grain * fbm(N, seed, 3, 16) * ss(0.2, 1.0, dist / np.maximum(w, 1e-4) + 0.3))
    return save(name, np.ones_like(a), a, out)


def swoosh(out, sweep=150, thickness=0.12, taper=1.4, curl=0.35, grain=0.45, seed=4, name="swoosh"):
    """broad pale swoosh / claw stroke: thick middle, sharp tapered tips, streaky (wind cells, hook arcs)."""
    return arc(out, sweep=sweep, thickness=thickness, taper=taper, curl=curl, grain=grain, halo=0.15, seed=seed,
               name=name)


def spark_streak(out, length=6.0, head=0.7, taper=2.5, name="spark_streak"):
    """streaked spark along V: a hard bright head near the top and a thin tapering tail (sparks flung fast).
    length = how many times longer than wide; use with VelocityParallel orientation."""
    H = 256
    W = max(16, int(H / max(1.0, length)) * 2)
    u, v = grid(W, H)
    t = (v + 1) / 2  # 0 = head end .. 1 = tail end
    w = np.where(t < 0.1, np.sqrt(np.clip(t / 0.1, 0, 1)), np.clip(1 - (t - 0.1) / 0.9, 0, 1) ** taper) * 0.8
    a = ss(1.0, 0.7, np.abs(u) / np.maximum(w, 1e-3)) * (t <= 1)
    a = a * (head + (1 - head) * (1 - t))
    lum = 0.75 + 0.25 * ss(0.5, 0.0, np.abs(u) / np.maximum(w, 1e-3))
    return save(name, lum, a, out)


def smoke_wisp(out, wisp=0.7, grain=0.5, lumps=0.6, seed=5, name="smoke_wisp"):
    """smoke puff with wispy, torn edges and grain inside (not a solid ball): lumpy core, thin strands fraying
    outward at the rim, see-through gaps near the edge."""
    N = 256
    u, v = grid(N)
    r, th = np.hypot(u, v), np.arctan2(v, u)
    n1 = fbm(N, seed, 5, 3)
    n2 = fbm(N, seed + 10, 4, 6)
    # strands: a noise looked up in polar coordinates, fast around the puff and slow outward = radial fibres
    fn = fbm(N, seed + 20, 4, 8)
    xi = ((th / (2 * math.pi) + 0.5) * 2 * N + 40 * (n2 - 0.5)).astype(int) % N
    yi = np.clip((r * 0.12 + 0.3 * n1) * (N - 1), 0, N - 1).astype(int)
    fibre = ss(0.42, 0.7, fn[yi, xi])
    edge = 0.5 + lumps * 0.3 * (n1 - 0.5)
    body = ss(edge + 0.04, edge - 0.22, r)
    rim = ss(edge + 0.42 * wisp + 0.02, edge - 0.05, r) * (1 - body)
    a = body * (0.55 + 0.45 * n2) * (1 - wisp * 0.45 * ss(edge - 0.22, edge, r) * (1 - fibre))
    a = a + rim * fibre * 0.55
    a = a * ss(1.0, 0.9, r) * _grain(N, N, grain * 0.45, seed + 4, 1.2)
    lum = 0.55 + 0.45 * (0.6 * n1 + 0.4 * n2)
    return save(name, lum, np.clip(a, 0, 1), out)


def glint(out, rays=4, length=1.0, thin=0.02, diag=0.45, taper=1.5, name="glint"):
    """star-shaped flash glint: long, very thin rays that taper to points, short diagonal rays, small hot core."""
    N = 256
    u, v = grid(N)
    r, th = np.hypot(u, v), np.arctan2(v, u)
    a = np.exp(-(r / 0.06) ** 2)
    for k in range(int(rays) * 2):
        major = k % 2 == 0
        if not major and diag <= 0:
            continue
        ang = k * math.pi / int(rays)
        L = length * (1.0 if major else diag)
        along = u * math.cos(ang) + v * math.sin(ang)
        across = np.abs(-u * math.sin(ang) + v * math.cos(ang))
        w = thin * np.clip(1 - along / L, 0, 1) ** taper
        a = np.maximum(a, (along > 0) * ss(1.0, 0.4, across / np.maximum(w, 1e-4)) * np.clip(1 - along / L, 0, 1))
    return save(name, np.ones_like(a), np.clip(a, 0, 1), out)


def crack_line(out, width=1.5, branches=0.5, jag=0.5, glow=0.25, count=8, seed=11, name="crack_line"):
    """bright, thin, jagged crack lines (glowing ground cracks): hairline core, little glow, sharp kinks.
    width in px at 512; branches 0..1; jag 0..1 = how sharp the kinks are; count = main cracks from the centre."""
    N = 512
    img, dr = canvas(N)
    rng = np.random.default_rng(seed)
    c = N / 2

    def walk(x, y, ang, length, w, depth):
        base, step = ang, 7
        for i in range(int(length / step)):
            ang += rng.normal(0, 0.15 + 0.6 * jag) + (base - ang) * 0.4
            nx, ny = x + math.cos(ang) * step, y + math.sin(ang) * step
            dr.line([(x, y), (nx, ny)], fill=255, width=max(1, int(round(w * (1 - 0.6 * i * step / length)))))
            x, y = nx, ny
            if math.hypot(x - c, y - c) > N * 0.47:
                return
            if depth < 2 and rng.random() < 0.09 * branches:
                walk(x, y, ang + rng.choice([-1, 1]) * rng.uniform(0.5, 1.2), length * 0.4, w * 0.7, depth + 1)

    for i in range(int(count)):
        a0 = i / count * 2 * math.pi + rng.uniform(-0.3, 0.3)
        walk(c + math.cos(a0) * 10, c + math.sin(a0) * 10, a0, rng.uniform(140, 230), width, 0)
    core = arr(img)
    a = np.clip(core + glow * blur(core, 4) * 2, 0, 1)
    return save(name, np.ones_like(a), a, out)


def glitter(out, density=0.012, size=1.5, grain=0.35, seed=6, name="glitter"):
    """fine sparkly grain (tiny sharp specks over faint noise): the texture inside a glassy dome, dust or embers bed."""
    N = 256
    rng = np.random.default_rng(seed)
    img, dr = canvas(N)
    for _ in range(int(density * N * N / 4)):
        x, y = rng.uniform(0, N, 2)
        s = rng.uniform(0.4, 1.0) * size
        dr.ellipse([x - s, y - s, x + s, y + s], fill=int(rng.uniform(140, 255)))
    a = np.clip(arr(img) + grain * (fbm(N, seed, 3, 32) - 0.35), 0, 1)
    return save(name, np.ones_like(a), a, out)


def contact_sheet(files, path, cols=6, cell=200):
    """all PNGs on a dark and a mid-grey card, labelled: check the shapes at a glance."""
    rows = (len(files) + cols - 1) // cols
    sheet = Image.new("RGB", (cols * cell, rows * (cell + 22) * 2), (18, 20, 26))
    d = ImageDraw.Draw(sheet)
    for i, f in enumerate(files):
        im = Image.open(f).convert("RGBA")
        im.thumbnail((cell - 12, cell - 12))
        for k, bg in enumerate(((14, 16, 22), (120, 124, 132))):
            x = (i % cols) * cell
            y = ((i // cols) * 2 + k) * (cell + 22)
            card = Image.new("RGBA", (cell - 6, cell - 6), bg + (255,))
            card.alpha_composite(im, ((cell - 6 - im.width) // 2, (cell - 6 - im.height) // 2))
            sheet.paste(card.convert("RGB"), (x + 3, y + 3))
            d.text((x + 6, y + cell), os.path.basename(f), fill=(200, 204, 214))
    sheet.save(path)
    return path


SHAPES = {f.__name__: f for f in (glow, dot, ring, ring_soft, shock, star4, streak, smoke, wisp, crack, scorch,
                                  face_scream, face_calm, petal, flame_burst, flame_shard, arc, swoosh, spark_streak,
                                  smoke_wisp, glint, crack_line, glitter)}


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
    ap.add_argument("--set", nargs="+", default=[], metavar="KEY=VALUE",
                    help="shape parameters, e.g. ragged=0.9 taper=2 grain=0.5 seed=4 (each shape takes the ones it knows)")
    ap.add_argument("--name", help="file name for a single shape (to keep several variants)")
    ap.add_argument("--sheet", metavar="PNG", help="also write a contact sheet of everything written")
    a = ap.parse_args()
    if a.list or (not a.shapes and not a.files):
        import inspect
        for k, f in SHAPES.items():
            ps = [f"{p.name}={p.default}" for p in inspect.signature(f).parameters.values()
                  if p.default is not inspect.Parameter.empty and p.name != "name"]
            print(f"{k:12s} {' '.join((f.__doc__ or '').split())}" + (f"\n{'':12s} params: {' '.join(ps)}" if ps else ""))
        return
    import inspect
    params = {}
    for kv in a.set:
        k, _, v = kv.partition("=")
        params[k] = int(float(v)) if float(v).is_integer() else float(v)
    files = list(a.files)
    for s in a.shapes:
        if s not in SHAPES:
            sys.exit(f"unknown shape {s}; --list shows them")
        known = inspect.signature(SHAPES[s]).parameters
        kw = {k: v for k, v in params.items() if k in known}
        if a.name and len(a.shapes) == 1 and "name" in known:
            kw["name"] = a.name
        files.append(SHAPES[s](a.out, **kw))
    if a.sheet:
        print("wrote", contact_sheet(files, a.sheet))
    for f in files:
        print("wrote", f) if f not in a.files else None
    if a.install:
        for p in install(a.install, files):
            print(p)


if __name__ == "__main__":
    main()
