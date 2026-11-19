#!/usr/bin/env python3
"""refcompare.py: reference vs your effect, frame by frame, for the replicate mode (skills/vfx-replicate).

    python3 -I kit/refcompare.py --ref REF... --ours OURS... [--times 0.03,0.1,...] [--out DIR]

REF and OURS can each be:
  - a frame sheet image (a gallery sheet: 4 columns, 26 px title band; or any grid with --ref-grid 4x2 --ref-head 26).
    Times come from --ref-times, else from gallery/effects/index.csv when the file name holds the effect id, else the
    gallery's standard times 0.03 0.1 0.2 0.35 0.55 0.8 1.2 1.8 (printed as an assumption);
  - a video file (.mp4 .mov .webm .mkv .avi .gif; frames are cut with ffmpeg);
  - a folder of stills whose names hold their time (t0.10.png, f_ref_0.35.png, ...; base.png = the empty stage);
  - several still images, with --ref-times giving one time each;
  - a gallery id (e.g. ea2342503619): its sheet in this plugin's gallery/effects/.
  (the same options exist as --ours-*.)

Alignment: --times are seconds after the ANCHOR (e.g. the ground hit). --ref-at / --ours-at say where the anchor is in
each source's own time: seconds into the video, or the still/sheet time of the anchor (default 0). For videos "auto"
= the first frame that differs from the first frame, "flash" = the biggest frame-to-frame jump.

Base (what the empty stage looks like, so the effect can be measured): --ref-base / --ours-base =
  first | last | min | black | <image path>. Default: base.png in a still folder; the first video frame; otherwise
  "min" (per-pixel minimum over the frames: right on a dark stage, rough in daylight).

Writes into --out (default ./refcompare):
  sheet.png     reference row over ours, same crop and size, one column per time (actual frame times in the labels)
  curves.png    energy (how much the frame differs from the empty stage), added light and coverage over time, both
  metrics.json  every number below
  detail.png    (numpy) ZOOMED: the same box cut from both sides at 3 key moments, large, with a "fine detail" row
                under each (only the high-frequency part: sparks, thin lines, ragged outlines, grain show up white).
                --crop x,y,w,h (fractions of the frame, or reference pixels) | auto (default: around the reference's
                brightest region) | none;  --detail-at 0.03,0.1,0.35 picks the moments (default: first, peak, middle)
and prints a table per time plus a short list of the biggest measured differences. The numbers inform the eye; they
are not a pass/fail gate. Look at sheet.png first, then detail.png.

Small details (numpy; both sides measured at the same width, the smaller source's, max 960 px; a 400 px gallery sheet
loses most fine detail, so use a video or big stills of the reference when the details matter):
  specks    small bright specks that stand out from their surroundings (sparks, embers, glints): count, median
            diameter (1/1000 of the frame width), size spread (p90 / p10), streaked = share stretched 2.5:1 or more
  dark      small dark specks (debris chips)
  lines     thin-line pixels (Hessian ridge filter: long thin bright ridges = swirl arcs, cracks, glint rays) as a
            share of the effect area, and the number of separate line pieces
  grain     high-frequency energy inside the effect (texture inside smoke, a dome, a burst); edges = share of the
            effect area on a sharp edge
  ragged    outline of the brightest blob at half its peak vs a round disc (1.0 = round; flame shards ~3)
  edgew     edge width of that blob (1/1000 of the frame width): small = crisp, large = soft

Per frame:
  effect%   share of the frame that differs from the empty stage
  light+%   share that got clearly brighter (additive light, flashes, glow)
  cover%    share that changed without getting brighter (dark or grey mass; mostly useful in daylight)
  opaque%   share of the stage's detailed area (grid, horizon, stars) that the effect hides without being blown out
            to white: solid fire, thick smoke, rock. Additive and thin layers let the detail through. Needs numpy and a
            stage with visible detail (a daylight grid works best; on a near-black stage it reads "-")
  energy    mean difference from the empty stage (0-255); its fall over time is the fade
  centre    centroid of the effect area (x, y as fractions of the frame), spread = 2 x std (w, h fractions)
  warm      mean (R - B) of the effect pixels (-1 blue ... +1 orange/red); white% = unsaturated share of the effect
  hues      the two main hues of the coloured effect pixels with their shares
Pure Python + Pillow (+ numpy, used when present). Videos need ffmpeg.
"""
import argparse
import colorsys
import csv
import glob
import io
import json
import math
import os
import re
import subprocess
import sys
import textwrap

from PIL import Image, ImageDraw, ImageFont

try:
    import numpy as np
    if os.environ.get("REFCOMPARE_NO_NUMPY"):  # test the plain-Python path
        raise ImportError
except ImportError:  # pragma: no cover - the plain-Python path is slower but gives the same numbers
    np = None

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
GALLERY_TIMES = [0.03, 0.1, 0.2, 0.35, 0.55, 0.8, 1.2, 1.8]
VIDEO_EXT = {".mp4", ".mov", ".webm", ".mkv", ".avi", ".gif", ".m4v"}
IMAGE_EXT = {".png", ".jpg", ".jpeg", ".webp", ".bmp"}
AW = 480  # analysis width (px); both sides are measured at the same size
HUES = [(15, "red"), (45, "orange"), (70, "yellow"), (160, "green"), (200, "cyan"), (255, "blue"), (290, "purple"),
        (335, "magenta"), (361, "red")]


def font(size, bold=True):
    for p in ("/usr/share/fonts/TTF/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/TTF/DejaVuSans.ttf",
              "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", "/Library/Fonts/Arial Bold.ttf",
              "C:/Windows/Fonts/arialbd.ttf"):
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()


def floats(s):
    return [float(x) for x in re.split(r"[,\s]+", s.strip()) if x]


# ----------------------------------------------------------------------------------------------------- sources
class Source:
    """Frames by source time. kind: video | stills | sheet."""

    def __init__(self, paths, times=None, grid=None, head=None, at="0", base=None, crop=None, name="ref"):
        self.name, self.mask, self.notes = name, [], []
        self.crop = [int(v) for v in crop.split(",")] if crop else None
        paths = [resolve_gallery(p) for p in paths]
        first = paths[0]
        ext = os.path.splitext(first)[1].lower()
        if len(paths) == 1 and os.path.isdir(first):
            self.kind = "stills"
            self.frames = {}
            for f in sorted(glob.glob(os.path.join(first, "*"))):
                stem, e = os.path.splitext(os.path.basename(f))
                if e.lower() not in IMAGE_EXT:
                    continue
                if stem.lower() == "base":
                    base = base or f
                    continue
                m = re.findall(r"-?\d+(?:\.\d+)?", stem)
                if m and "sheet" not in stem.lower():
                    self.frames[float(m[-1])] = f
            if not self.frames:
                raise SystemExit("%s: no stills with a time in their name in %s" % (name, first))
        elif len(paths) == 1 and ext in VIDEO_EXT:
            self.kind, self.video = "video", first
            self.duration = probe_duration(first)
        elif len(paths) == 1 and ext in IMAGE_EXT and (grid or is_sheet(first)):
            self.kind = "sheet"
            self.frames = split_sheet(first, times, grid, head, self)
        else:
            self.kind = "stills"
            if not times or len(floats(times)) != len(paths):
                raise SystemExit("%s: %d still images need --%s-times with one time each" % (name, len(paths), name))
            self.frames = dict(zip(floats(times), paths))
        self.at = self.find_at(at)
        self.base = self.make_base(base)

    # the anchor in source time
    def find_at(self, at):
        if at in ("auto", "flash"):
            if self.kind != "video":
                raise SystemExit("--%s-at %s only works on a video" % (self.name, at))
            return video_onset(self.video, at)
        return float(at)

    def frame(self, src_t):
        """(image, actual source time) for the frame nearest src_t, or (None, None)."""
        if self.kind == "video":
            t = min(max(0.0, src_t), max(0.0, self.duration - 0.02))
            return video_frame(self.video, t), t
        if not self.frames:
            return None, None
        t = min(self.frames, key=lambda k: abs(k - src_t))
        im = self.frames[t]
        return (Image.open(im).convert("RGB") if isinstance(im, str) else im), t

    def make_base(self, base):
        if base is None:
            base = "first" if self.kind == "video" else "min"
        if base == "black":
            return "black"
        if base == "first":
            return self.frame(0.0)[0] if self.kind == "video" else self.frame(min(self.frames))[0]
        if base == "last":
            return self.frame(self.duration if self.kind == "video" else max(self.frames))[0]
        if base == "min":
            self.notes.append("base = per-pixel minimum of the frames (no empty-stage frame given); opaque% needs a real "
                              "empty-stage frame, so it is left out for this side")
            return None  # filled in later from the sampled frames
        return Image.open(base).convert("RGB")


def resolve_gallery(p):
    if os.path.exists(p) or not re.fullmatch(r"[0-9a-f]{12}", p):
        return p
    hits = glob.glob(os.path.join(ROOT, "gallery", "effects", "*", p + ".jpg"))
    if not hits:
        raise SystemExit("gallery id %s: no sheet in %s/gallery/effects" % (p, ROOT))
    return hits[0]


def is_sheet(path):
    w, h = Image.open(path).size
    return w / h > 2.2


def gallery_times(path):
    stem = os.path.basename(path)
    ids = re.findall(r"[0-9a-f]{12}", stem)
    for idx in glob.glob(os.path.join(ROOT, "gallery", "effects", "index.csv")):
        for row in csv.DictReader(open(idx)):
            if row["id"] in ids:
                return [float(t) for t in row["stills_at_seconds"].split()]
    return None


def split_sheet(path, times, grid, head, src):
    im = Image.open(path).convert("RGB")
    if times:
        ts = floats(times)
    else:
        ts = gallery_times(path)
        if ts:
            src.notes.append("times from gallery/effects/index.csv")
        else:
            ts = GALLERY_TIMES
            src.notes.append("times assumed = the gallery's standard %s (pass --%s-times if the labels differ)"
                             % (" ".join("%g" % t for t in ts), src.name))
    if grid:
        cols, rows = (int(v) for v in grid.lower().split("x"))
    else:
        cols = 4
        rows = (len(ts) + cols - 1) // cols
    head = 26 if head is None else head
    cw, ch = im.width // cols, (im.height - head) // rows
    # gallery cells: time label top-left, a small icon top-right; leave them out of the numbers
    sx = cw / 400.0
    src.mask = [(0, 0, int(70 * sx), int(19 * sx)), (cw - int(30 * sx), 0, cw, int(30 * sx))]
    out = {}
    for i, t in enumerate(ts[: cols * rows]):
        x, y = (i % cols) * cw, head + (i // cols) * ch
        out[t] = im.crop((x, y, x + cw, y + ch))
    return out


def probe_duration(path):
    r = subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", path],
                       capture_output=True, text=True)
    try:
        return float(r.stdout.strip())
    except ValueError:
        raise SystemExit("cannot read %s (is ffmpeg installed?)" % path)


def video_frame(path, t):
    r = subprocess.run(["ffmpeg", "-v", "error", "-ss", "%.4f" % t, "-i", path, "-frames:v", "1", "-f", "image2pipe",
                        "-vcodec", "png", "-"], capture_output=True)
    if not r.stdout:
        raise SystemExit("ffmpeg could not cut %s at %.3f s: %s" % (path, t, r.stderr.decode()[-300:]))
    return Image.open(io.BytesIO(r.stdout)).convert("RGB")


def video_onset(path, mode):
    raw = subprocess.run(["ffmpeg", "-v", "error", "-t", "6", "-i", path, "-vf", "fps=60,scale=160:90,format=gray",
                          "-f", "rawvideo", "-"], capture_output=True).stdout
    n = len(raw) // (160 * 90)
    fr = [raw[i * 14400:(i + 1) * 14400] for i in range(n)]

    def mad(a, b):
        return sum(abs(x - y) for x, y in zip(a[::7], b[::7])) / len(a[::7])

    if mode == "flash":
        steps = [mad(fr[i], fr[i + 1]) for i in range(n - 1)]
        return (steps.index(max(steps)) + 1) / 60.0
    for i in range(1, n):
        if mad(fr[i], fr[0]) > 2.0:
            return i / 60.0
    return 0.0


# ----------------------------------------------------------------------------------------------------- geometry
def fit(im, aspect, crop):
    if crop:
        x, y, w, h = crop
        im = im.crop((x, y, x + w, y + h))
    w, h = im.size
    if abs(w / h - aspect) > 0.01:
        if w / h > aspect:
            nw = int(round(h * aspect))
            im = im.crop(((w - nw) // 2, 0, (w - nw) // 2 + nw, h))
        else:
            nh = int(round(w / aspect))
            im = im.crop((0, (h - nh) // 2, w, (h - nh) // 2 + nh))
    return im


# ----------------------------------------------------------------------------------------------------- metrics
def hue_name(h):
    for top, n in HUES:
        if h < top:
            return n
    return "red"


def measure(im, base, mask_rects, real_base=True):
    """im, base: same-size RGB images (analysis size). Returns a dict of numbers."""
    w, h = im.size
    if np is not None:
        a = np.asarray(im, dtype=np.float32)
        b = np.asarray(base, dtype=np.float32)
        valid = np.ones((h, w), bool)
        for x0, y0, x1, y1 in mask_rects:
            valid[y0:y1, x0:x1] = False
        diff = np.abs(a - b).max(axis=2)
        la = a @ np.array([0.299, 0.587, 0.114], np.float32)
        lb = b @ np.array([0.299, 0.587, 0.114], np.float32)
        dl = la - lb
        eff = (diff > 30) & valid
        n = valid.sum()
        out = {"effect": eff.sum() / n, "light": ((dl > 40) & valid).sum() / n,
               "cover": (eff & (dl <= 10)).sum() / n,
               "energy": float(np.abs(a - b).mean(axis=2)[valid].mean()),
               "glow": float(np.clip(dl, 0, None)[valid].mean())}
        out["opaque"] = hidden_share(la, lb, eff, valid) if real_base else None
        ys, xs = np.nonzero(eff)
        px = a[eff] / 255.0
    else:
        A, B = im.load(), base.load()
        masked = set()
        for x0, y0, x1, y1 in mask_rects:
            for y in range(y0, min(y1, h)):
                for x in range(x0, min(x1, w)):
                    masked.add((x, y))
        n = w * h - len(masked)
        ne = nl = nc = 0
        en = gl = 0.0
        xs, ys, px = [], [], []
        for y in range(h):
            for x in range(w):
                if (x, y) in masked:
                    continue
                p, q = A[x, y], B[x, y]
                d = max(abs(p[i] - q[i]) for i in range(3))
                dl = (0.299 * (p[0] - q[0]) + 0.587 * (p[1] - q[1]) + 0.114 * (p[2] - q[2]))
                en += sum(abs(p[i] - q[i]) for i in range(3)) / 3
                gl += max(0.0, dl)
                if dl > 40:
                    nl += 1
                if d > 30:
                    ne += 1
                    if dl <= 10:
                        nc += 1
                    xs.append(x), ys.append(y), px.append([c / 255.0 for c in p])
        out = {"effect": ne / n, "light": nl / n, "cover": nc / n, "energy": en / n, "glow": gl / n, "opaque": None}
    cnt = len(xs)
    if cnt >= 20:
        if np is not None:
            out.update(cx=float(xs.mean() / w), cy=float(ys.mean() / h), sw=float(2 * xs.std() / w),
                       sh=float(2 * ys.std() / h))
            rgb = px
            out["warm"] = float((rgb[:, 0] - rgb[:, 2]).mean())
            mx, mn = rgb.max(axis=1), rgb.min(axis=1)
            sat = np.where(mx > 0, (mx - mn) / np.maximum(mx, 1e-6), 0)
            out["white"] = float((sat < 0.2).mean())
            col = rgb[(sat >= 0.25) & (mx >= 0.25)]
            out["mean_rgb"] = [int(v * 255) for v in rgb.mean(axis=0)]
            hues = [colorsys.rgb_to_hsv(*c)[0] * 360 for c in col[:: max(1, len(col) // 4000)]]
        else:
            mxs, mys = sum(xs) / cnt, sum(ys) / cnt
            out.update(cx=mxs / w, cy=mys / h, sw=2 * math.sqrt(sum((x - mxs) ** 2 for x in xs) / cnt) / w,
                       sh=2 * math.sqrt(sum((y - mys) ** 2 for y in ys) / cnt) / h)
            out["warm"] = sum(p[0] - p[2] for p in px) / cnt
            sats = [colorsys.rgb_to_hsv(*p) for p in px]
            out["white"] = sum(1 for s in sats if s[1] < 0.2) / cnt
            out["mean_rgb"] = [int(sum(p[i] for p in px) / cnt * 255) for i in range(3)]
            hues = [s[0] * 360 for s in sats if s[1] >= 0.25 and s[2] >= 0.25]
        tally = {}
        for hh in hues:
            k = hue_name(hh)
            tally[k] = tally.get(k, 0) + 1
        tot = sum(tally.values()) or 1
        out["hues"] = [[k, round(v / tot, 2)] for k, v in sorted(tally.items(), key=lambda kv: -kv[1])[:2]]
    else:
        out.update(cx=None, cy=None, sw=0.0, sh=0.0, warm=None, white=None, mean_rgb=None, hues=[])
    return out


def hidden_share(la, lb, eff, valid, k=8):
    """Opaque area from the stage's own detail (grid lines, horizon, stars): 8 x 8 blocks where the empty stage has
    detail and the effect covers the block. If that detail no longer shows through and the block is not simply blown
    out to white, something solid sits in front of it (solid fire, thick smoke, rock). Additive and thin layers keep
    the detail. Returns the share of the stage's detailed area that is hidden this way."""
    def hp(x):  # luma minus a 5 x 5 box blur
        p = np.pad(x, 2, mode="edge")
        c = np.cumsum(np.cumsum(p, 0), 1)
        c = np.pad(c, ((1, 0), (1, 0)))
        blur = (c[5:, 5:] - c[:-5, 5:] - c[5:, :-5] + c[:-5, :-5]) / 25.0
        return x - blur
    hf, hb = hp(la), hp(lb)
    H, W = la.shape
    H, W = H - H % k, W - W % k
    sh = (H // k, k, W // k, k)

    def blocks(x):
        return x[:H, :W].reshape(sh).transpose(0, 2, 1, 3).reshape(H // k, W // k, -1)
    f, b = blocks(hf), blocks(hb)
    e = blocks((eff & valid).astype(np.float32)).mean(axis=2)
    ok = blocks(valid.astype(np.float32)).mean(axis=2) > 0.99
    detail = (b.std(axis=2) > 2.0) & ok
    if detail.sum() < 20:
        return None
    lit = blocks(la).mean(axis=2) > 225  # blown out: hides detail by clipping, not by being solid
    fc, bc = f - f.mean(axis=2, keepdims=True), b - b.mean(axis=2, keepdims=True)
    corr = (fc * bc).sum(axis=2) / np.maximum(1e-6, np.sqrt((fc ** 2).sum(axis=2) * (bc ** 2).sum(axis=2)))
    hidden = detail & (e > 0.5) & ~lit & (corr < 0.35)
    return float(hidden.sum() / detail.sum())


def min_base(images):
    if np is not None:
        return Image.fromarray(np.min(np.stack([np.asarray(i) for i in images]), axis=0).astype(np.uint8))
    out = images[0].copy()
    px = out.load()
    for im in images[1:]:
        q = im.load()
        for y in range(out.height):
            for x in range(out.width):
                a, b = px[x, y], q[x, y]
                px[x, y] = tuple(min(a[i], b[i]) for i in range(3))
    return out


def fade_points(times, energy):
    """peak time, and the times energy first falls under 50 / 25 / 10 % of the peak after it (linear between samples)."""
    if not energy or max(energy) <= 0:
        return {"peak_t": None, "t50": None, "t25": None, "t10": None, "end_share": None}
    i = max(range(len(energy)), key=lambda k: energy[k])
    pk = energy[i]
    out = {"peak_t": times[i], "end_share": energy[-1] / pk}
    for lab, f in (("t50", 0.5), ("t25", 0.25), ("t10", 0.10)):
        out[lab] = None
        for j in range(i, len(energy) - 1):
            if energy[j + 1] < f * pk <= energy[j]:
                u = (energy[j] - f * pk) / max(1e-9, energy[j] - energy[j + 1])
                out[lab] = times[j] + u * (times[j + 1] - times[j])
                break
        if out[lab] is None and energy[-1] >= f * pk:
            out[lab] = float("inf")  # still above at the last sample
    return out


# ----------------------------------------------------------------------------------------------------- output
def draw_sheet(path, cols, rows, labels, title, cw, ch):
    lw, top, gap = 190, 74, 8
    W = lw + len(cols) * (cw + gap)
    H = top + len(rows) * (ch + gap + 22) + 10
    sheet = Image.new("RGB", (W, H), (18, 20, 26))
    d = ImageDraw.Draw(sheet)
    d.text((W // 2, 24), title, font=font(22), fill=(240, 242, 246), anchor="mm")
    for i, t in enumerate(cols):
        d.text((lw + i * (cw + gap) + 6, top - 26), "+%.2f s" % t, font=font(18), fill=(255, 196, 64))
    for r, (lab, row) in enumerate(zip(labels, rows)):
        y = top + r * (ch + gap + 22)
        d.multiline_text((12, y + ch // 2 - 30), "\n".join(textwrap.wrap(lab, 15)), font=font(17), fill=(240, 242, 246))
        for i, (im, actual, note) in enumerate(row):
            x = lw + i * (cw + gap)
            if im is None:
                d.rectangle([x, y, x + cw, y + ch], outline=(90, 90, 90))
                d.text((x + cw // 2, y + ch // 2), "no frame", font=font(16), fill=(150, 150, 150), anchor="mm")
            else:
                sheet.paste(im, (x, y))
            d.text((x + 4, y + ch + 3), note, font=font(13, False), fill=(150, 156, 170))
    sheet.save(path)


def draw_curves(path, times, series, labels):
    W, H, pad = 1200, 760, 60
    im = Image.new("RGB", (W, H), (18, 20, 26))
    d = ImageDraw.Draw(im)
    plots = [("energy (difference from empty stage)", "energy"), ("light+ % (got brighter)", "light"),
             ("opaque % (stage detail hidden by solid mass)", "opaque")]
    ph = (H - pad) // len(plots)
    t0, t1 = min(times), max(times)
    colours = [(255, 196, 64), (120, 210, 255)]
    for k, (name, key) in enumerate(plots):
        y0 = pad // 2 + k * ph
        vals = [[(m[key] if m else None) for m in s] for s in series]
        flat = [v for row in vals for v in row if v is not None]
        vmax = max(flat) if flat and max(flat) > 0 else 1
        d.text((pad, y0), name, font=font(16), fill=(240, 242, 246))
        top, bot = y0 + 26, y0 + ph - 30
        d.line([(pad, bot), (W - 20, bot)], fill=(80, 84, 96))
        for t in times:
            x = pad + (t - t0) / max(1e-9, t1 - t0) * (W - 20 - pad)
            d.line([(x, bot), (x, bot + 4)], fill=(80, 84, 96))
            if k == len(plots) - 1:
                d.text((x, bot + 8), "%.2f" % t, font=font(12, False), fill=(150, 156, 170), anchor="mt")
        for c, row in enumerate(vals):
            pts = [(pad + (t - t0) / max(1e-9, t1 - t0) * (W - 20 - pad), bot - v / vmax * (bot - top))
                   for t, v in zip(times, row) if v is not None]
            if len(pts) > 1:
                d.line(pts, fill=colours[c], width=3)
            for p in pts:
                d.ellipse([p[0] - 4, p[1] - 4, p[0] + 4, p[1] + 4], fill=colours[c])
    for c, lab in enumerate(labels):
        d.text((W - 20, 14 + c * 20), lab, font=font(15), fill=colours[c], anchor="ra")
    im.save(path)


def pct(v):
    return "  -  " if v is None else "%4.1f%%" % (100 * v)


def num(v, f="%.2f"):
    return "-" if v is None else f % v


def differences(R, O, fr, fo, times):
    """The measured differences, biggest first: (size, text). Sizes are rough ratios, only for ordering."""
    out = []

    def avg(ms, k):
        v = [m[k] for m in ms if m and m.get(k) is not None]
        return sum(v) / len(v) if v else None

    def ratio(a, b):
        if a is None or b is None:
            return 0
        return abs(math.log((b + 1e-3) / (a + 1e-3)))

    # fade: compare t25 (or the energy still left at the end)
    a, b = fr.get("t25"), fo.get("t25")
    if a is not None and b is not None:
        if math.isinf(b) and not math.isinf(a):
            out.append((2.0, "FADE: ours is still above 25%% of its peak at +%.2f s; the reference falls under it by "
                             "+%.2f s. Shorten the tail (smoke, embers, lingering fire)." % (times[-1], a)))
        elif math.isinf(a) and not math.isinf(b):
            out.append((2.0, "FADE: the reference lingers past +%.2f s; ours is under 25%% of its peak by +%.2f s."
                        % (times[-1], b)))
        elif not math.isinf(a) and not math.isinf(b):
            r = ratio(a, b)
            out.append((r * 1.5, "FADE: falls under 25%% of its peak at +%.2f s (ref) vs +%.2f s (ours): ours fades %s."
                        % (a, b, "slower" if b > a else "faster")))
    if fr.get("end_share") is not None and fo.get("end_share") is not None:
        r = abs(fo["end_share"] - fr["end_share"])
        out.append((r * 3, "TAIL: at +%.2f s the energy left is %.0f%% of the peak (ref) vs %.0f%% (ours)."
                    % (times[-1], 100 * fr["end_share"], 100 * fo["end_share"])))
    for key, lab, hint in (("opaque", "OPAQUE MASS", "stage detail hidden by solid (non-additive) mass"),
                           ("cover", "DARK/GREY MASS", "changed-but-not-brighter area"),
                           ("light", "ADDED LIGHT", "clearly brighter area (additive glow, flash)"),
                           ("effect", "SIZE ON SCREEN", "share of the frame the effect touches")):
        a, b = avg(R, key), avg(O, key)
        if a is not None and b is not None:
            out.append((ratio(a, b), "%s: %s averages %s (ref) vs %s (ours), %s." % (
                lab, hint, pct(a), pct(b), "ours has more" if b > a else "ours has less")))
    def hue_mix(ms):
        tally, n = {}, 0
        for m in ms:
            if m and m.get("hues") and m["effect"] > 0.005:
                n += 1
                for k, v in m["hues"]:
                    tally[k] = tally.get(k, 0) + v
        return {k: v / n for k, v in tally.items()} if n else {}
    hr, ho = hue_mix(R), hue_mix(O)
    a, b = avg(R, "warm"), avg(O, "warm")
    if a is not None and b is not None:
        keys = set(hr) | set(ho)
        hk = max(keys, key=lambda k: abs(ho.get(k, 0) - hr.get(k, 0))) if keys else None
        hd = abs(ho.get(hk, 0) - hr.get(hk, 0)) if hk else 0
        hue_txt = (" Biggest hue gap: %s %.0f%% (ref) vs %.0f%% (ours) of the coloured pixels."
                   % (hk, 100 * hr.get(hk, 0), 100 * ho.get(hk, 0))) if hk else ""
        out.append((abs(b - a) * 4 + hd * 2, "COLOUR: warmth (R - B) %+.2f (ref) vs %+.2f (ours): ours is %s; "
                    "white/pale share %s vs %s.%s" % (a, b, "warmer" if b > a else "cooler", pct(avg(R, "white")),
                                                      pct(avg(O, "white")), hue_txt)))
    a, b = avg(R, "sh"), avg(O, "sh")
    a2, b2 = avg(R, "sw"), avg(O, "sw")
    if a is not None and b is not None:
        out.append(((ratio(a, b) + ratio(a2, b2)) / 2, "SPREAD: effect area spans %.2f x %.2f of the frame (ref) vs "
                    "%.2f x %.2f (ours)." % (a2, a, b2, b)))
    return sorted(out, key=lambda kv: -kv[0])

# ----------------------------------------------------------------------------------------------------- small details
# Everything below needs numpy. It looks at the SMALL elements the big numbers above miss: fine sparks and specks,
# thin lines (swirl arcs, cracks, glint rays), grain inside a mass, and how ragged and crisp the bright burst is.
# Both sides are measured at the same width DW = the smaller of the two sources' own widths (max 960 px), so a
# low-resolution reference sheet does not look "smoother" only because it has fewer pixels.

def gblur(x, s):
    """separable Gaussian blur of a 2-D float array (numpy only)."""
    if s <= 0:
        return x
    r = max(1, int(math.ceil(3 * s)))
    k = np.exp(-0.5 * (np.arange(-r, r + 1) / s) ** 2)
    k /= k.sum()
    p = np.pad(x, ((0, 0), (r, r)), mode="edge")
    y = sum(k[i] * p[:, i:i + x.shape[1]] for i in range(2 * r + 1))
    p = np.pad(y, ((r, r), (0, 0)), mode="edge")
    return sum(k[i] * p[i:i + x.shape[0], :] for i in range(2 * r + 1))


def dilate(m, n=1):
    for _ in range(n):
        p = np.pad(m, 1)
        m = p[1:-1, 1:-1] | p[:-2, 1:-1] | p[2:, 1:-1] | p[1:-1, :-2] | p[1:-1, 2:]
    return m


def erode(m):
    p = np.pad(m, 1)
    return p[1:-1, 1:-1] & p[:-2, 1:-1] & p[2:, 1:-1] & p[1:-1, :-2] & p[1:-1, 2:]


def label(mask):
    """connected components (8-neighbour) without scipy: min-label propagation with pointer jumping.
    Returns (labels HxW int, -1 = background; n)."""
    H, W = mask.shape
    big = H * W
    lab = np.where(mask, np.arange(big).reshape(H, W), big)
    while True:
        p = np.pad(lab, 1, constant_values=big)
        nb = np.minimum.reduce([p[1:-1, 1:-1], p[:-2, 1:-1], p[2:, 1:-1], p[1:-1, :-2], p[1:-1, 2:],
                                p[:-2, :-2], p[:-2, 2:], p[2:, :-2], p[2:, 2:]])
        nb = np.where(mask, nb, big)
        flat = np.append(nb.ravel(), big)
        for _ in range(6):  # pointer jumping: follow each label to its own label
            flat = flat[np.minimum(flat, big)]
        new = flat[:-1].reshape(H, W)
        if np.array_equal(new, lab):
            break
        lab = new
    ids, inv = np.unique(lab[mask], return_inverse=True)
    out = np.full((H, W), -1, np.int64)
    out[mask] = inv
    return out, len(ids)


def blob_stats(lab, n):
    """per component: area, elongation (major / minor axis), length (major axis, px)."""
    if n == 0:
        return np.zeros(0), np.zeros(0), np.zeros(0)
    ys, xs = np.nonzero(lab >= 0)
    L = lab[ys, xs]
    area = np.bincount(L, minlength=n).astype(np.float64)
    mx, my = np.bincount(L, xs, n) / area, np.bincount(L, ys, n) / area
    dx, dy = xs - mx[L], ys - my[L]
    cxx = np.bincount(L, dx * dx, n) / area + 1 / 12
    cyy = np.bincount(L, dy * dy, n) / area + 1 / 12
    cxy = np.bincount(L, dx * dy, n) / area
    tr, det = cxx + cyy, cxx * cyy - cxy ** 2
    disc = np.sqrt(np.maximum(tr * tr / 4 - det, 0))
    l1, l2 = tr / 2 + disc, np.maximum(tr / 2 - disc, 1e-6)
    return area, np.sqrt(l1 / l2), 4 * np.sqrt(l1)


def detail_measure(im, base):
    """Small-detail numbers for one frame (same-size RGB images at the detail width). See the module docstring."""
    a = np.asarray(im, dtype=np.float32)
    b = np.asarray(base, dtype=np.float32)
    H, W = a.shape[:2]
    lw = np.array([0.299, 0.587, 0.114], np.float32)
    la, lb = a @ lw, b @ lw
    d = la - lb
    eff = dilate(np.abs(a - b).max(axis=2) > 30, 2)
    ne = int(eff.sum())
    if ne < 0.005 * H * W:
        return None
    u = W / 1000.0  # 1 unit = 1/1000 of the frame width
    out = {"area": ne / (H * W)}
    # grain: high-frequency energy of the effect's own picture (its luma change) inside the effect area
    hp = d - gblur(d, max(0.8, 1.5 * u))
    out["grain"] = float(np.abs(hp)[eff].mean())
    g = gblur(d, max(0.6, 0.7 * u))
    gy, gx = np.gradient(g)
    out["edges"] = float(((np.hypot(gx, gy) > 12) & eff).sum() / ne)
    # specks: small bright (or dark) dots that stand out from their surroundings
    s_top = max(1.5, 5 * u)
    top = d - gblur(d, s_top)
    amax = max(6.0, (12 * u) ** 2)
    res = {}
    for kind, sg in (("bright", 1), ("dark", -1)):
        # hysteresis: a speck is a small island of the low threshold that holds a high-threshold pixel, so a crack
        # web or a flame outline (one big connected island) does not break up into "specks"
        low = (sg * top > 12) & (sg * d > 8) & eff
        lab, n = label(low)
        area, el, ln = blob_stats(lab, n)
        hi = (sg * top > 28) & (sg * d > 15) & low
        strong = np.bincount(lab[hi], minlength=n) > 0 if n else np.zeros(0, bool)
        keep = strong & (area >= (2 if W >= 700 else 1)) & (area <= amax)
        res[kind] = (area[keep], el[keep])
    ab, eb = res["bright"]
    out["specks"] = int(len(ab))
    out["dark_specks"] = int(len(res["dark"][0]))
    if len(ab):
        dia = 2 * np.sqrt(ab / math.pi) / u  # equivalent diameter in 1/1000 of the frame width
        out["speck_size"] = float(np.median(dia))
        out["speck_spread"] = float(np.percentile(dia, 90) / max(1e-6, np.percentile(dia, 10)))
        big_enough = ab >= max(4, (2.5 * u) ** 2)
        out["streaked"] = float((eb[big_enough] >= 2.5).mean()) if big_enough.any() else 0.0
    else:
        out.update(speck_size=None, speck_spread=None, streaked=None)
    # thin lines: Hessian ridge filter at a small scale; long, thin ridges only (arcs, cracks, glint rays)
    sr = max(1.0, 1.5 * u)
    gs = gblur(d, sr) * sr * sr
    dyy, dyx = np.gradient(np.gradient(gs, axis=0))
    dxy, dxx = np.gradient(np.gradient(gs, axis=1))
    half = (dxx + dyy) / 2
    root = np.sqrt(((dxx - dyy) / 2) ** 2 + dxy ** 2)
    l1, l2 = half - root, half + root  # l1 most negative = across a bright line
    ridge = (-l1 > 6) & (np.abs(l2) < 0.4 * np.abs(l1)) & eff
    lab, n = label(ridge)
    area, el, ln = blob_stats(lab, n)
    keep = (el >= 4) & (ln >= 12 * u)
    out["lines"] = float(area[keep].sum() / ne)
    out["line_count"] = int(keep.sum())
    # the bright burst: how ragged its outline is (1.0 = a round disc) and how crisp its edge is
    # the outline at half of the brightest change: a soft glow is round there, flame shards stay jagged
    pk = float(np.percentile(d[eff], 99.5))
    bright = (gblur(d, max(0.6, 0.7 * u)) > max(55.0, 0.5 * pk)) & eff
    lab, n = label(bright)
    if n:
        area = np.bincount(lab[lab >= 0], minlength=n)
        k = int(np.argmax(area))
        if area[k] >= 0.0015 * H * W:
            m = lab == k
            per = (m & ~erode(m)).sum()
            out["ragged"] = float(per / (2 * math.sqrt(math.pi * area[k])))
            ring = dilate(m, 1) & ~erode(m)
            gm = np.hypot(*np.gradient(gblur(d, 0.7)))
            contrast = max(1.0, float(d[m].mean() - d[dilate(m, 4) & ~m].mean()))
            out["edge_px"] = float(contrast / max(1e-3, gm[ring].mean()) / u)  # transition width, 1/1000 of width
            out["burst_area"] = float(area[k] / (H * W))
        else:
            out.update(ragged=None, edge_px=None, burst_area=None)
    else:
        out.update(ragged=None, edge_px=None, burst_area=None)
    return out


def detail_view(im, base):
    """grey picture of the fine detail only (high-pass of the effect's luma change), for the zoomed sheet."""
    a = np.asarray(im, dtype=np.float32) @ np.array([0.299, 0.587, 0.114], np.float32)
    b = np.asarray(base, dtype=np.float32) @ np.array([0.299, 0.587, 0.114], np.float32)
    d = a - b
    hp = np.abs(d - gblur(d, max(0.8, 1.5 * im.width / 1000.0)))
    return Image.fromarray(np.clip(hp * 6, 0, 255).astype(np.uint8)).convert("RGB")


def auto_crop(frames, bases):
    """box (fractions x, y, w, h) around where the reference is brightest, summed over its frames; frame aspect."""
    acc = None
    for im, b in zip(frames, bases):
        if im is None:
            continue
        a = np.asarray(im, dtype=np.float32).mean(axis=2) - np.asarray(b, dtype=np.float32).mean(axis=2)
        acc = np.clip(a, 0, None) if acc is None else acc + np.clip(a, 0, None)
    if acc is None or acc.sum() <= 0:
        return (0.25, 0.25, 0.5, 0.5)
    H, W = acc.shape
    acc = np.where(acc > 0.25 * acc.max(), acc, 0)
    ys, xs = np.mgrid[0:H, 0:W]
    tot = acc.sum()
    cx, cy = (acc * xs).sum() / tot / W, (acc * ys).sum() / tot / H
    sx = math.sqrt((acc * (xs / W - cx) ** 2).sum() / tot)
    sy = math.sqrt((acc * (ys / H - cy) ** 2).sum() / tot)
    w = h = min(1.0, max(0.3, 5 * sx, 5 * sy))  # same fraction both ways keeps the frame aspect
    x = min(max(0.0, cx - w / 2), 1 - w)
    y = min(max(0.0, cy - h / 2), 1 - h)
    return (x, y, w, h)


def parse_crop(s, ref_size):
    """'x,y,w,h' as fractions (all <= 1) or reference pixels -> fractions."""
    v = floats(s)
    if len(v) != 4:
        raise SystemExit("--crop needs x,y,w,h or auto")
    if max(v) > 1.0:
        W, H = ref_size
        v = [v[0] / W, v[1] / H, v[2] / W, v[3] / H]
    return tuple(v)


def crop_frac(im, box):
    x, y, w, h = box
    W, H = im.size
    return im.crop((int(x * W), int(y * H), int((x + w) * W), int((y + h) * H)))


def pick_detail_times(times, energy):
    """three key moments: the first frame, and the middle and end of the stretch above 25 % of the peak energy."""
    if not energy or max(energy) <= 0:
        return times[:3]
    pk = max(energy)
    ip = energy.index(pk)
    live = [t for t, e in zip(times, energy) if e >= 0.25 * pk] or times
    after = times[min(len(times) - 1, max(ip, 1))]  # the peak, or the frame after the first one
    picks = [times[0], after, live[len(live) // 2]]
    if len(set(picks)) < 3:
        picks.append(live[-1])
    out = []
    for t in picks:
        if t not in out:
            out.append(t)
    return sorted(out[:3])


def draw_detail_sheet(path, dts, cells, labels, notes, title, cw, ch):
    """cells[row][col] = image; rows: ref, ours, ref fine detail, ours fine detail."""
    lw, top, gap = 190, 74, 8
    names = [labels[0], labels[1], labels[0] + " fine detail", labels[1] + " fine detail"]
    W = lw + len(dts) * (cw + gap)
    H = top + len(cells) * (ch + gap + 22) + 10
    sheet = Image.new("RGB", (W, H), (18, 20, 26))
    d = ImageDraw.Draw(sheet)
    d.text((W // 2, 24), title, font=font(22), fill=(240, 242, 246), anchor="mm")
    for i, t in enumerate(dts):
        d.text((lw + i * (cw + gap) + 6, top - 26), "+%.2f s" % t, font=font(18), fill=(255, 196, 64))
    for r, row in enumerate(cells):
        y = top + r * (ch + gap + 22)
        d.multiline_text((12, y + ch // 2 - 30), "\n".join(textwrap.wrap(names[r], 15)), font=font(17),
                         fill=(240, 242, 246))
        for i, im in enumerate(row):
            x = lw + i * (cw + gap)
            if im is None:
                d.rectangle([x, y, x + cw, y + ch], outline=(90, 90, 90))
            else:
                sheet.paste(im.resize((cw, ch), Image.LANCZOS), (x, y))
            if r < 2:
                d.text((x + 4, y + ch + 3), notes[r][i], font=font(13, False), fill=(150, 156, 170))
    sheet.save(path)


def detail_note(m):
    if not m:
        return "-"
    return "specks %d (%s)  streaked %s  lines %s  grain %.1f  ragged %s" % (
        m["specks"], num(m["speck_size"], "%.1f"), pct(m["streaked"]), pct(m["lines"]), m["grain"],
        num(m["ragged"], "%.1f"))


DETAIL_KEYS = (("specks", "FINE SPARKS/SPECKS", "small bright specks per frame", "%.0f"),
               ("dark_specks", "DARK SPECKS", "small dark specks (debris) per frame", "%.0f"),
               ("streaked", "STREAKING", "share of the larger specks stretched 2.5:1 or more", None),
               ("speck_size", "SPECK SIZE", "median speck diameter (1/1000 of the frame width)", "%.1f"),
               ("lines", "THIN LINES", "thin-line pixels (arcs, cracks, glint rays) as a share of the effect area",
                None),
               ("line_count", "LINE COUNT", "separate thin line pieces per frame", "%.0f"),
               ("grain", "GRAIN", "fine texture inside the effect (high-frequency energy, 0-255)", "%.1f"),
               ("edges", "EDGE DENSITY", "share of the effect area on a sharp edge", None),
               ("ragged", "RAGGED BURST", "outline of the brightest blob vs a round disc (1.0 = round)", "%.2f"),
               ("edge_px", "EDGE SOFTNESS", "edge width of the bright blob (1/1000 of the frame width; small = crisp)",
                "%.1f"))


def detail_differences(DR, DO):
    """Small-detail gaps, biggest first: (size, text). Averaged over the reference's visible life (the frames where
    the reference shows something); where ours shows nothing then, counts and shares count as 0."""
    out = []
    live = [i for i, m in enumerate(DR) if m]
    for key, lab, hint, f in DETAIL_KEYS:
        additive = f == "%.0f" or f is None
        vr = [DR[i][key] for i in live if DR[i].get(key) is not None]
        vo = [DO[i][key] if DO[i] else 0 for i in live
              if (DO[i] and DO[i].get(key) is not None) or (not DO[i] and additive)]
        if not vr and not vo:
            continue
        a = sum(vr) / len(vr) if vr else None
        b = sum(vo) / len(vo) if vo else None
        if a is None or b is None:
            have = "the reference" if a is not None else "ours"
            out.append((1.0, "%s: only %s has it (%s)." % (lab, have, hint)))
            continue
        eps = 3.0 if f == "%.0f" else (0.005 if f is None else 0.1)
        r = abs(math.log((b + eps) / (a + eps)))
        fa = (lambda v: pct(v).strip()) if f is None else (lambda v: f % v)
        out.append((r, "%s: %s: %s (ref) vs %s (ours), ours has %s." % (
            lab, hint, fa(a), fa(b), "more" if b > a else "less")))
    return sorted(out, key=lambda kv: -kv[0])


def run_detail(a, srcs, fitted, times, series, labels, aspect):
    """small-detail measures for every frame + the zoomed detail sheet (detail.png)."""
    widths = [im.width for side in fitted for im, _ in fitted[side][0] if im is not None]
    DW = min(960, min(widths))
    DH = int(round(DW / aspect))
    per, small, bases = {}, {}, {}
    for side, s in srcs.items():
        imgs = fitted[side][0]
        sm = [im.resize((DW, DH), Image.LANCZOS) if im is not None else None for im, _ in imgs]
        if s.base == "black":
            base = Image.new("RGB", (DW, DH))
        elif s.base is not None:
            base = fit(s.base, aspect, s.crop).resize((DW, DH), Image.LANCZOS)
        else:
            base = min_base([im for im in sm if im is not None])
        if s.kind == "sheet" and s.mask:  # blank the gallery labels on both the frame and the base
            k = DW / (s.frames[next(iter(s.frames))].width)
            sm = [im if im is None else im.copy() for im in sm]
            for im in sm:
                if im is not None:
                    for r in s.mask:
                        im.paste(base.crop(tuple(int(v * k) for v in r)), (int(r[0] * k), int(r[1] * k)))
        small[side], bases[side] = sm, base
        per[side] = [detail_measure(im, base) if im is not None else None for im in sm]
    # the zoomed sheet: same box on both sides
    if a.crop != "none":
        if a.crop == "auto":
            box = auto_crop(small["ref"], [bases["ref"]] * len(small["ref"]))
        else:
            ref_im = next(im for im, _ in fitted["ref"][0] if im is not None)
            box = parse_crop(a.crop, ref_im.size)
        if a.detail_at:
            dts = floats(a.detail_at)
        else:
            dts = pick_detail_times(times, [m["energy"] if m else 0 for m in series[0]])
        cells, notes = [[], [], [], []], [[], []]
        for t in dts:
            i = min(range(len(times)), key=lambda k: abs(times[k] - t))
            for r, side in enumerate(("ref", "ours")):
                im = fitted[side][0][i][0]
                cells[r].append(crop_frac(im, box) if im is not None else None)
                sm = small[side][i]
                cells[r + 2].append(crop_frac(detail_view(sm, bases[side]), box) if sm is not None else None)
                notes[r].append(detail_note(per[side][i]))
        cw = 600
        ch = int(round(cw * (box[3] * DH) / max(1e-6, box[2] * DW)))
        draw_detail_sheet(os.path.join(a.out, "detail.png"), [times[min(range(len(times)),
                          key=lambda k: abs(times[k] - t))] for t in dts], cells, labels, notes,
                          "Zoomed: reference over ours, same box (x %.2f y %.2f w %.2f h %.2f of the frame)" % box,
                          cw, ch)
    else:
        box, dts = None, []
    diffs = detail_differences(per["ref"], per["ours"])
    return {"width": DW, "crop": box, "times": dts, "ref": per["ref"], "ours": per["ours"],
            "differences": [txt for _, txt in diffs]}


def print_detail(detail, times):
    print("\nsmall details (measured at %d px wide; specks: count (median diameter, 1/1000 of the width); lines and "
          "edges: share of the effect area; ragged: 1.0 = round)" % detail["width"])
    print("%-7s %-5s %6s %5s %5s %6s %7s %6s %6s %6s %6s %6s" % (
        "t", "side", "specks", "size", "dark", "streak", "lines", "pieces", "grain", "edges", "ragged", "edgew"))
    for i, t in enumerate(times):
        for side in ("ref", "ours"):
            m = detail[side][i]
            if not m:
                print("%+6.2f  %-5s (no effect)" % (t, side))
                continue
            print("%+6.2f  %-5s %6d %5s %5d %6s %7s %6d %6.1f %6s %6s %6s" % (
                t, side, m["specks"], num(m["speck_size"], "%.1f"), m["dark_specks"], pct(m["streaked"]),
                pct(m["lines"]), m["line_count"], m["grain"], pct(m["edges"]), num(m["ragged"], "%.2f"),
                num(m["edge_px"], "%.1f")))
    print("\nbiggest small-detail differences (inform, not a gate; check them on detail.png):")
    for k, txt in enumerate(detail["differences"][:6], 1):
        print(" %d. %s" % (k, txt))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    for side in ("ref", "ours"):
        ap.add_argument("--" + side, nargs="+", required=True)
        ap.add_argument("--%s-times" % side, help="times of the stills or sheet cells (their own clock)")
        ap.add_argument("--%s-at" % side, default="0", help="where the anchor is in this source's time (or auto/flash)")
        ap.add_argument("--%s-base" % side, help="first | last | min | black | <image>")
        ap.add_argument("--%s-crop" % side, help="x,y,w,h in source pixels")
        ap.add_argument("--%s-grid" % side, help="sheet grid, e.g. 4x2")
        ap.add_argument("--%s-head" % side, type=int, help="sheet title band height (px, default 26)")
    ap.add_argument("--times", help="seconds after the anchor (default: the reference's own times)")
    ap.add_argument("--labels", default="Reference,Ours")
    ap.add_argument("--title", default="Reference over ours, aligned on the anchor")
    ap.add_argument("--cell", type=int, default=400, help="cell width on the sheet (px)")
    ap.add_argument("--crop", default="auto",
                    help="zoomed detail sheet box: x,y,w,h (fractions, or reference pixels) | auto (around the "
                         "reference's brightest region) | none")
    ap.add_argument("--detail-at", help="times for the zoomed detail sheet (default: 3 key moments)")
    ap.add_argument("--out", default="refcompare")
    a = ap.parse_args()

    srcs = {}
    for side in ("ref", "ours"):
        g = lambda k: getattr(a, "%s_%s" % (side, k))
        srcs[side] = Source(getattr(a, side), times=g("times"), grid=g("grid"), head=g("head"), at=g("at"),
                            base=g("base"), crop=g("crop"), name=side)
    ref, ours = srcs["ref"], srcs["ours"]
    if a.times:
        times = floats(a.times)
    elif ref.kind != "video":
        times = [round(t - ref.at, 4) for t in sorted(ref.frames)]
    else:
        times = GALLERY_TIMES

    # pull frames; the reference's crop sets the aspect for both
    raw = {}
    for side, s in srcs.items():
        raw[side] = []
        for t in times:
            raw[side].append(s.frame(t + s.at))
    first_ref = next(im for im, _ in raw["ref"] if im is not None)
    first_ref = fit(first_ref, first_ref.width / first_ref.height, ref.crop)
    aspect = first_ref.width / first_ref.height
    cw, ch = a.cell, int(round(a.cell / aspect))
    ah = int(round(AW / aspect))

    os.makedirs(a.out, exist_ok=True)
    rows, metrics = [], {"times": times, "labels": a.labels.split(","), "sources": {}}
    series, fitted = [], {}
    for side, s in srcs.items():
        imgs = [(fit(im, aspect, s.crop) if im is not None else None, act) for im, act in raw[side]]
        small = [im.resize((AW, ah), Image.LANCZOS) if im is not None else None for im, _ in imgs]
        if s.base == "black":
            base = Image.new("RGB", (AW, ah))
        elif s.base is not None:
            base = fit(s.base, aspect, s.crop).resize((AW, ah), Image.LANCZOS)
        else:
            base = min_base([im for im in small if im is not None])
        sx = AW / (s.frames[next(iter(s.frames))].width if s.kind == "sheet" else 1)
        mask = [tuple(int(round(v * sx)) for v in r) for r in s.mask] if s.kind == "sheet" else []
        ms = [measure(im, base, mask, s.base not in (None, "black")) if im is not None else None for im in small]
        fitted[side] = (imgs, mask, sx)
        series.append(ms)
        row = []
        for t, (im, act) in zip(times, imgs):
            if im is None:
                row.append((None, None, ""))
                continue
            off = act - s.at - t
            note = "src %.2f s" % act + ("  (%+.2f off)" % off if abs(off) > 0.04 else "")
            row.append((im.resize((cw, ch), Image.LANCZOS), act, note))
        rows.append(row)
        metrics["sources"][side] = {"kind": s.kind, "at": s.at, "notes": s.notes,
                                    "actual_times": [act for _, act in imgs], "frames": ms,
                                    "fade": fade_points(times, [m["energy"] if m else 0 for m in ms])}

    labels = a.labels.split(",")
    detail = None
    if np is not None:
        detail = run_detail(a, srcs, fitted, times, series, labels, aspect)
        metrics["detail"] = detail
    draw_sheet(os.path.join(a.out, "sheet.png"), times, rows, labels, a.title, cw, ch)
    draw_curves(os.path.join(a.out, "curves.png"), times, series, labels)

    # report
    for side, s in srcs.items():
        for n in s.notes:
            print("note (%s): %s" % (side, n))
    print("anchor: ref at %.3f s, ours at %.3f s (their own clocks)" % (ref.at, ours.at))
    print("%-7s %-5s %6s %6s %6s %6s %6s  %-11s %-11s %6s %6s  %s" % (
        "t", "side", "effect", "light+", "cover", "opaque", "energy", "centre", "spread", "warm", "white", "hues"))
    for i, t in enumerate(times):
        for side, ms, lab in zip(("ref", "ours"), series, labels):
            m = ms[i]
            if m is None:
                print("%+6.2f  %-5s (no frame)" % (t, side))
                continue
            cen = "%.2f,%.2f" % (m["cx"], m["cy"]) if m["cx"] is not None else "-"
            spr = "%.2fx%.2f" % (m["sw"], m["sh"])
            hues = " ".join("%s %d%%" % (k, 100 * v) for k, v in m["hues"])
            print("%+6.2f  %-5s %6s %6s %6s %6s %6.1f  %-11s %-11s %6s %6s  %s" % (
                t, side, pct(m["effect"]), pct(m["light"]), pct(m["cover"]), pct(m["opaque"]), m["energy"], cen, spr,
                num(m["warm"], "%+.2f"), pct(m["white"]), hues))
    print()
    for side in ("ref", "ours"):
        f = metrics["sources"][side]["fade"]
        fmt = lambda v: "-" if v is None else ("after the last frame" if math.isinf(v) else "+%.2f s" % v)
        print("fade %-4s peak %s, under 50%% %s, 25%% %s, 10%% %s, left at the end %s" % (
            side, fmt(f["peak_t"]), fmt(f["t50"]), fmt(f["t25"]), fmt(f["t10"]),
            "-" if f["end_share"] is None else "%.0f%%" % (100 * f["end_share"])))
    diffs = differences(series[0], series[1], metrics["sources"]["ref"]["fade"], metrics["sources"]["ours"]["fade"],
                        times)
    metrics["differences"] = [txt for _, txt in diffs]
    print("\nbiggest measured differences (a hint for the eye, not a verdict):")
    for k, (_, txt) in enumerate(diffs[:5], 1):
        print(" %d. %s" % (k, txt))
    if detail:
        print_detail(detail, times)
    else:
        print("\n(small-detail measures and detail.png need numpy)")

    def clean(o):
        if isinstance(o, float) and (math.isinf(o) or math.isnan(o)):
            return None if math.isnan(o) else "after_last_frame"
        if isinstance(o, dict):
            return {k: clean(v) for k, v in o.items()}
        if isinstance(o, list):
            return [clean(v) for v in o]
        if np is not None and isinstance(o, np.generic):
            return clean(o.item())
        return o

    with open(os.path.join(a.out, "metrics.json"), "w") as f:
        json.dump(clean(metrics), f, indent=1)
    print("\nwrote", os.path.join(a.out, "sheet.png"), os.path.join(a.out, "curves.png"),
          os.path.join(a.out, "metrics.json"), *([os.path.join(a.out, "detail.png")] if detail and detail["crop"] else []))


if __name__ == "__main__":
    main()
