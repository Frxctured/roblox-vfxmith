#!/usr/bin/env python3
"""Textures for the void ground explosion (reference: the reference video Styl_VoidRend_v2 (third-party, not included), frames f545 / f566 / f571),
drawn with numpy + PIL: crisp toon shapes with anti-aliased edges, straight alpha. Writes tools/vfx/out/voidrend/:

  VR_StarCrater  512x512  BLACK irregular spiky star "crater" (18 uneven spikes, inner radius ~0.30, tips at 0.55-0.95
                          of the half size) on transparent: the dark ink layer on the magenta ground disc.
  VR_Streaks     256x512  white vertical streak lines (1-10 px wide, varied brightness) on transparent, tileable
                          top-bottom: the pillar Beam's texture (a Beam runs the texture's HEIGHT along its length).
  VR_Curl        128x128  a small thin white crescent hook / curl stroke on transparent (the tiny curl particles).
  VR_SoftDisc    256x256  white filled circle with a soft edge over the outer 15% of its radius (flat ground discs).

White ones are tinted by ParticleEmitter / Beam Color; the star stays black (non-additive, LightEmission 0).
Run: python3 tools/vfx/make_voidrend_textures.py   (upload: python3 tools/vfx/upload_vfx_textures.py tools/vfx/out/voidrend
tools/assets/vfx_voidrend_texture_ids.json)
"""
import math
import os
import random

import numpy as np
from PIL import Image, ImageDraw

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "out")
SS = 4  # supersampling for drawn shapes


def save(name, alpha, rgb=(1.0, 1.0, 1.0)):
    a = np.clip(alpha, 0, 1)
    img = np.zeros(a.shape + (4,))
    img[..., :3] = rgb
    img[..., 3] = a
    Image.fromarray(np.round(img * 255).astype(np.uint8), "RGBA").save(os.path.join(OUT, name + ".png"))


def downsample(mask_img, size):
    """Supersampled L-mode mask -> float alpha at `size` (box filter = exact coverage, crisp AA edges)."""
    return np.asarray(mask_img.resize(size, Image.BOX), dtype=float) / 255.0


def smoothstep(e0, e1, x):
    t = np.clip((x - e0) / (e1 - e0), 0, 1)
    return t * t * (3 - 2 * t)


def star_crater(n=512, spikes=18, seed=11):
    rng = random.Random(seed)
    big = n * SS
    c = big / 2
    half = big / 2
    pts = []
    base = rng.uniform(0, 2 * math.pi)
    step = 2 * math.pi / spikes
    for i in range(spikes):
        # uneven tips: mostly long/short alternating with randomness, a few very long
        long_one = (i % 2 == 0) != (rng.random() < 0.2)
        r_tip = rng.uniform(0.74, 0.95) if long_one else rng.uniform(0.55, 0.72)
        a_tip = base + i * step + rng.uniform(-0.18, 0.18) * step
        a_in = base + (i + 0.5) * step + rng.uniform(-0.15, 0.15) * step
        r_in = rng.uniform(0.27, 0.34)
        pts.append((c + math.cos(a_tip) * r_tip * half, c + math.sin(a_tip) * r_tip * half))
        pts.append((c + math.cos(a_in) * r_in * half, c + math.sin(a_in) * r_in * half))
    m = Image.new("L", (big, big), 0)
    ImageDraw.Draw(m).polygon(pts, fill=255)
    save("VR_StarCrater", downsample(m, (n, n)), rgb=(0.0, 0.0, 0.0))


def streaks(w=256, h=512, seed=46):  # seed picked for an even left/right spread
    rng = random.Random(seed)
    xs = np.arange(w) + 0.5
    ys = np.arange(h) + 0.5
    keep = np.ones((h, w))  # product of (1 - a_i): alpha = 1 - keep

    def add(xc, width, alpha, y0=None, length=None, wobble=0.0):
        cov = np.clip(width / 2 + 0.5 - np.abs(xs - xc), 0, 1)          # 1-px anti-aliased edges
        if length is None:   # full height; brightness ripples with whole periods so it still tiles
            k = rng.choice([1, 2, 3])
            ph = rng.uniform(0, 2 * math.pi)
            along = 1 - wobble * (0.5 + 0.5 * np.sin(2 * math.pi * k * ys / h + ph))
        else:                # a segment with tapered ends, wrapped around top-bottom
            dy = (ys - y0) % h
            tap = length * 0.3
            along = np.where(dy < length, smoothstep(0, tap, dy) * smoothstep(0, tap, length - dy), 0.0)
        keep[:] *= 1 - alpha * along[:, None] * cov[None, :]

    def pick_x():
        x = rng.gauss(w / 2, w * 0.17) if rng.random() < 0.4 else rng.uniform(10, w - 10)
        return min(w - 10, max(10, x))

    for _ in range(9):    # hairlines, full height
        add(pick_x(), rng.uniform(1.0, 2.2), rng.uniform(0.55, 1.0), wobble=rng.uniform(0.2, 0.6))
    for _ in range(6):    # medium lines, full height
        add(pick_x(), rng.uniform(2.5, 5.0), rng.uniform(0.3, 0.7), wobble=rng.uniform(0.3, 0.7))
    for _ in range(14):   # segments of every width
        add(pick_x(), rng.uniform(1.0, 7.0), rng.uniform(0.35, 0.95), y0=rng.uniform(0, h), length=rng.uniform(90, 380))
    for _ in range(5):    # a few wide, faint bands
        add(pick_x(), rng.uniform(7.0, 10.0), rng.uniform(0.18, 0.4), y0=rng.uniform(0, h), length=rng.uniform(200, 460))
    save("VR_Streaks", 1 - keep)


def curl(n=128):
    big = n * SS
    m = Image.new("L", (big, big), 0)
    d = ImageDraw.Draw(m)
    cx, cy = big * 0.52, big * 0.5
    a0, span = math.radians(205), math.radians(290)   # hook: starts lower left, sweeps over the top, curls in
    r0, r1 = 0.36 * big, 0.13 * big                   # tightening spiral
    wmax = 9.0 * SS
    steps = 900
    for i in range(steps + 1):
        u = i / steps
        a = a0 - span * u
        r = r0 + (r1 - r0) * u ** 1.8
        width = wmax * math.sin(math.pi * u) ** 0.75 * (1 - 0.45 * u)   # thicker first half, sharp at both ends
        x, y = cx + r * math.cos(a), cy - r * math.sin(a)
        rad = max(width / 2, 0.6 * SS * (1 - abs(2 * u - 1)))
        d.ellipse((x - rad, y - rad, x + rad, y + rad), fill=255)
    save("VR_Curl", downsample(m, (n, n)))


def soft_disc(n=256, edge=0.15):
    y, x = np.mgrid[0:n, 0:n].astype(float) + 0.5
    r = np.hypot(x - n / 2, y - n / 2) / (n / 2 * 0.98)   # 0.98: keep a clear 1-2 px border
    save("VR_SoftDisc", 1 - smoothstep(1 - edge, 1.0, r))


def main():
    os.makedirs(OUT, exist_ok=True)
    star_crater()
    streaks()
    curl()
    soft_disc()
    print("wrote", sorted(os.listdir(OUT)))


if __name__ == "__main__":
    main()
