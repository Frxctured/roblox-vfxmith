#!/usr/bin/env python3
"""Side-by-side reference vs capture for the VFX review loop (see README.md in this folder).

    python3 tools/vfx/pipeline/compare.py --ref REF.mp4 --ref-t0 17.70 --ours OURS.mp4|STILLS_DIR [--ours-t0 auto]
        [--ref-crop x,y,w,h] [--ours-crop x,y,w,h] [--times 0.03,0.1,...] [--out DIR] [--label v3]

--ours may be a folder of freeze-frame stills (t<time>.png or .jpg, e.g. MCP screen_capture files renamed; base.png =
the empty stage, optional) from stills.py or VFXCapture.hold (already cut at the effect
start): then the sheet uses the still nearest each time and the curves use every still.

Both clips are cut at their effect start (t0; "auto" = first frame that differs from the clip's first frame), cropped
(ours is centre-cropped to the reference's aspect unless --ours-crop is given) and sampled at the same effect times.
Writes into DIR:
  compare.png   2 rows (REF / OURS) x one column per time, labelled
  curves.png    coverage, brightness and dominant hue over time for both, so timing differences are visible
  metrics.json  per time: coverage (share of pixels that differ from the clip's first frame), bright share
                (luma > 200), mean colour of the effect pixels, effect bounding box (fractions of the frame)
and prints a short table. Reviewers get compare.png + curves.png + metrics.json (+ the reference analysis).
"""
import argparse
import colorsys
import glob
import json
import os
import subprocess
import sys

import numpy as np
from PIL import Image, ImageDraw, ImageFont

FONT = "/usr/share/fonts/TTF/DejaVuSans-Bold.ttf"


def probe(path):
    out = subprocess.run(["ffprobe", "-v", "error", "-select_streams", "v:0", "-show_entries",
                          "stream=width,height,r_frame_rate:format=duration", "-of", "json", path],
                         capture_output=True, text=True, check=True).stdout
    d = json.loads(out)
    s = d["streams"][0]
    num, den = s["r_frame_rate"].split("/")
    return int(s["width"]), int(s["height"]), float(num) / float(den), float(d["format"]["duration"])


def frames(path, fps, crop, scale_w):
    """All frames of `path` resampled to `fps`, cropped, scaled to width scale_w, as uint8 arrays."""
    w, h, _, _ = probe(path)
    x, y, cw, ch = crop
    sh = round(ch * scale_w / cw / 2) * 2
    vf = f"fps={fps},crop={cw}:{ch}:{x}:{y},scale={scale_w}:{sh}"
    raw = subprocess.run(["ffmpeg", "-v", "error", "-i", path, "-vf", vf, "-f", "rawvideo", "-pix_fmt", "rgb24", "-"],
                         capture_output=True, check=True).stdout
    n = len(raw) // (scale_w * sh * 3)
    return np.frombuffer(raw[: n * scale_w * sh * 3], np.uint8).reshape(n, sh, scale_w, 3)


def effect_mask(img, base):
    diff = np.abs(img.astype(np.int16) - base.astype(np.int16)).max(axis=2)
    return diff > 28


def onset(fr, thresh=0.0008):
    base = fr[0]
    for i in range(1, len(fr)):
        if effect_mask(fr[i], base).mean() > thresh:
            return i
    return 0


def metrics(img, base):
    m = effect_mask(img, base)
    cov = float(m.mean())
    luma = img.astype(np.float32) @ np.array([0.299, 0.587, 0.114], np.float32)
    bright = float(((luma > 200) & m).mean())
    out = {"coverage": round(cov, 4), "bright": round(bright, 4)}
    if m.sum() > 20:
        px = img[m].astype(np.float32)
        mean = px.mean(axis=0)
        out["mean_rgb"] = [int(v) for v in mean]
        hh, ss, vv = colorsys.rgb_to_hsv(*(mean / 255))
        out["hue_deg"], out["sat"], out["val"] = round(float(hh) * 360), round(float(ss), 2), round(float(vv), 2)
        ys, xs = np.nonzero(m)
        H, W = m.shape
        # robust box: 2nd-98th percentile so lone sparks don't stretch it
        out["box"] = [round(float(np.percentile(xs, 2)) / W, 3), round(float(np.percentile(ys, 2)) / H, 3),
                      round(float(np.percentile(xs, 98)) / W, 3), round(float(np.percentile(ys, 98)) / H, 3)]
        out["dark_share"] = round(float((luma[m] < 40).mean()), 3)  # ink inside the effect area
    return out


def label(img, text, size=20, fill=(255, 230, 80)):
    d = ImageDraw.Draw(img)
    f = ImageFont.truetype(FONT, size) if os.path.exists(FONT) else ImageFont.load_default()
    d.text((6, 4), text, font=f, fill=fill, stroke_width=3, stroke_fill=(0, 0, 0))
    return img


def curves(times, ref_series, our_series, path):
    W, H, pad = 1200, 520, 50
    img = Image.new("RGB", (W, H), (18, 18, 24))
    d = ImageDraw.Draw(img)
    f = ImageFont.truetype(FONT, 14) if os.path.exists(FONT) else ImageFont.load_default()
    tmax = times[-1]
    rows = [("coverage", 0, 160), ("bright", 180, 160), ("val", 360, 140)]
    for key, y0, hh in rows:
        vals = [s.get(key, 0) for s in ref_series] + [s.get(key, 0) for s in our_series]
        vmax = max(max(vals), 1e-6)
        d.text((8, y0 + 4), key, font=f, fill=(200, 200, 200))
        d.line([(pad, y0 + hh), (W - 10, y0 + hh)], fill=(70, 70, 80))
        for series, col in ((ref_series, (255, 200, 60)), (our_series, (90, 200, 255))):
            pts = [(pad + (W - pad - 10) * t / tmax, y0 + hh - (hh - 20) * s.get(key, 0) / vmax) for t, s in zip(times, series)]
            d.line(pts, fill=col, width=2)
    for k in range(int(tmax * 4) + 1):
        x = pad + (W - pad - 10) * (k / 4) / tmax
        d.line([(x, H - 22), (x, H - 16)], fill=(150, 150, 150))
        d.text((x - 8, H - 16), f"{k / 4:.2f}", font=f, fill=(150, 150, 150))
    d.text((W - 260, 6), "REF (yellow)  OURS (blue)", font=f, fill=(230, 230, 230))
    img.save(path)


def parse_crop(s, w, h):
    if not s:
        return (0, 0, w, h)
    return tuple(int(v) for v in s.split(","))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--ref", required=True)
    ap.add_argument("--ref-t0", default="auto")
    ap.add_argument("--ref-crop")
    ap.add_argument("--ours", required=True)
    ap.add_argument("--ours-t0", default="auto")
    ap.add_argument("--ours-crop")
    ap.add_argument("--ours-speed", type=float, default=1.0, help="capture was played at this timeline speed")
    ap.add_argument("--times", default="0.03,0.1,0.2,0.35,0.55,0.8,0.97,1.05,1.15,1.3,1.6,2.2")
    ap.add_argument("--span", type=float, default=3.4, help="seconds of effect for curves")
    ap.add_argument("--fps", type=float, default=30)
    ap.add_argument("--cell", type=int, default=300)
    ap.add_argument("--out", required=True)
    ap.add_argument("--label", default="")
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)
    times = [float(t) for t in a.times.split(",")]

    ref_stills = os.path.isdir(a.ref)
    if ref_stills:  # a folder of reference frames t<time>.jpg/png (e.g. gallery_frames.py output), already at effect time
        rfiles = sorted(glob.glob(os.path.join(a.ref, "t*.png")) + glob.glob(os.path.join(a.ref, "t*.jpg")),
                        key=lambda f: float(os.path.splitext(os.path.basename(f))[0][1:]))
        ref_t = [float(os.path.splitext(os.path.basename(f))[0][1:]) for f in rfiles]
        rw, rh = Image.open(rfiles[0]).size
    else:
        rw, rh, _, _ = probe(a.ref)
    rcrop = parse_crop(a.ref_crop, rw, rh)
    aspect = rcrop[2] / rcrop[3]
    stills = os.path.isdir(a.ours)
    if stills:
        files = sorted(glob.glob(os.path.join(a.ours, "t*.png")) + glob.glob(os.path.join(a.ours, "t*.jpg")),
                       key=lambda f: float(os.path.splitext(os.path.basename(f))[0][1:]))
        still_t = [float(os.path.splitext(os.path.basename(f))[0][1:]) for f in files]
        ow, oh = Image.open(files[0]).size
    else:
        ow, oh, _, _ = probe(a.ours)
    if a.ours_crop:
        ocrop = parse_crop(a.ours_crop, ow, oh)
    else:  # centre-crop to the reference aspect
        if ow / oh > aspect:
            cw = round(oh * aspect)
            ocrop = ((ow - cw) // 2, 0, cw, oh)
        else:
            ch = round(ow / aspect)
            ocrop = (0, (oh - ch) // 2, ow, ch)
    W = 480
    if ref_stills:
        def _load_ref(p):
            x, y, cw, ch = rcrop
            im = Image.open(p).convert("RGB").crop((x, y, x + cw, y + ch))
            return np.array(im.resize((W, round(ch * W / cw / 2) * 2), Image.LANCZOS))
        ref = np.stack([_load_ref(f) for f in rfiles])
    else:
        ref = frames(a.ref, a.fps, rcrop, W)
    # slow-motion captures: sample at fps * (1/speed) real frames per effect second
    def load_still(path):
        x, y, cw, ch = ocrop
        im = Image.open(path).convert("RGB").crop((x, y, x + cw, y + ch))
        sh = round(ch * W / cw / 2) * 2
        return np.array(im.resize((W, sh), Image.LANCZOS))

    if ref_stills:
        r0 = 0
        rbase = np.minimum.reduce(list(ref))
    else:
        r0 = None if a.ref_t0 == "auto" else round(float(a.ref_t0) * a.fps)
        if r0 is None:
            r0 = onset(ref)
        rbase = ref[max(r0 - 2, 0)]
    if stills:
        ours_st = [load_still(f) for f in files]
        bp = next((os.path.join(a.ours, n) for n in ("base.png", "base.jpg") if os.path.exists(os.path.join(a.ours, n))), None)
        # no empty-stage frame (e.g. MCP screenshots): the per-pixel darkest of the stills stands in for the background
        obase = load_still(bp) if bp else np.minimum.reduce(ours_st)
        o0 = 0
    else:
        ours = frames(a.ours, a.fps / a.ours_speed, ocrop, W)
        o0 = onset(ours) if a.ours_t0 == "auto" else round(float(a.ours_t0) * a.fps / a.ours_speed)
        obase = ours[max(o0 - 2, 0)] if a.ours_t0 != "auto" else ours[0]
    print(("ref stills" if ref_stills else f"ref onset frame {r0} ({r0 / a.fps:.2f}s)") + ", ours " + ("stills" if stills else f"onset frame {o0}"))

    def at(fr, start, t):
        if ref_stills and fr is ref:
            return ref[min(range(len(ref_t)), key=lambda i: abs(ref_t[i] - t))]
        i = start + round(t * a.fps)
        return fr[min(max(i, 0), len(fr) - 1)]

    def ours_at(t):
        if stills:
            k = min(range(len(still_t)), key=lambda i: abs(still_t[i] - t))
            return ours_st[k]
        return at(ours, o0, t)

    cell_h = round(a.cell * ref.shape[1] / ref.shape[2])
    sheet = Image.new("RGB", (a.cell * len(times), cell_h * 2 + 4), (40, 40, 40))
    rows = []
    for k, t in enumerate(times):
        rimg, oimg = at(ref, r0, t), ours_at(t)
        rm, om = metrics(rimg, rbase), metrics(oimg, obase)
        rows.append({"t": t, "ref": rm, "ours": om})
        ri = label(Image.fromarray(rimg).resize((a.cell, cell_h)), f"REF {t:.2f}s")
        oi = label(Image.fromarray(oimg).resize((a.cell, cell_h)), f"OURS {a.label} {t:.2f}s", fill=(120, 210, 255))
        sheet.paste(ri, (k * a.cell, 0))
        sheet.paste(oi, (k * a.cell, cell_h + 4))
    sheet.save(os.path.join(a.out, "compare.png"))
    # big sheet for reviewers: 2 cells per row pair, larger (REF left, OURS right)
    big_w = 760
    big_h = round(big_w * ref.shape[1] / ref.shape[2])
    pairs = Image.new("RGB", (big_w * 2 + 6, (big_h + 6) * len(times)), (40, 40, 40))
    for k, t in enumerate(times):
        ri = label(Image.fromarray(at(ref, r0, t)).resize((big_w, big_h)), f"REF {t:.2f}s", 24)
        oi = label(Image.fromarray(ours_at(t)).resize((big_w, big_h)), f"OURS {a.label} {t:.2f}s", 24, (120, 210, 255))
        pairs.paste(ri, (0, k * (big_h + 6)))
        pairs.paste(oi, (big_w + 6, k * (big_h + 6)))
    pairs.save(os.path.join(a.out, "pairs.png"))

    ts = still_t if stills else [k / a.fps for k in range(int(a.span * a.fps))]
    rs = [metrics(at(ref, r0, t), rbase) for t in ts]
    os_ = [metrics(ours_at(t), obase) for t in ts]
    curves(ts, rs, os_, os.path.join(a.out, "curves.png"))

    def peak(series):
        c = [s["coverage"] for s in series]
        i = int(np.argmax(c))
        return {"t": round(ts[i], 2), "coverage": c[i]}

    def end(series, frac=0.1):
        c = [s["coverage"] for s in series]
        top = max(c)
        last = max((i for i, v in enumerate(c) if v > top * frac), default=0)
        return round(ts[last], 2)

    summary = {"ref_peak": peak(rs), "ours_peak": peak(os_), "ref_end_10pct": end(rs), "ours_end_10pct": end(os_)}
    json.dump({"label": a.label, "ref_crop": rcrop, "ours_crop": ocrop, "onsets": [r0, o0], "summary": summary,
               "samples": rows}, open(os.path.join(a.out, "metrics.json"), "w"), indent=1)
    print(f"{'t':>5} | {'ref cov':>7} {'our cov':>7} | {'ref hue':>7} {'our hue':>7} | {'ref box':>23} | {'our box':>23}")
    for r in rows:
        rr, oo = r["ref"], r["ours"]
        print(f"{r['t']:5.2f} | {rr['coverage']:7.3f} {oo['coverage']:7.3f} | {rr.get('hue_deg', '-'):>7} {oo.get('hue_deg', '-'):>7} | "
              f"{str(rr.get('box', '-')):>23} | {str(oo.get('box', '-')):>23}")
    print("summary", summary)
    print("wrote", os.path.join(a.out, "compare.png"), os.path.join(a.out, "curves.png"))


if __name__ == "__main__":
    sys.exit(main())
