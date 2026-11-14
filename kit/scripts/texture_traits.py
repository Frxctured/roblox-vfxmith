#!/usr/bin/env python3
"""Measure the hidden traits of Roblox texture ids (background, colour, parts, effective resolution, fill).

Measured on the ORIGINAL uploaded image, so you can tell before you use a texture whether it is coloured, sits on a
black or faint card, holds several shapes, or is low-res art uploaded big.

    python3 -I kit/scripts/texture_traits.py <id>[:4x4] [<id> ...] [--grid 4x4] [--json]
    python3 -I kit/scripts/texture_traits.py --index gallery/textures/index.json \\
        [--scan knowledge/texture-vocab.md knowledge/categories/*_recipe.luau] --out gallery/textures/traits.json
    common: [--cache DIR] (default ~/.vfxmith/cache/textures) [--threads 4] [--refetch]

One line per id, e.g.
    11187665050  420x420  clear  white  1 part  eff 110 px (soft above ~140 px on screen)  fill 22%

Traits (legend):
  px      stored size; for a flipbook the grid, cell size and how many cells hold art ("4x4, 256 px cells, 12/16
          used"). The grid comes from `id:4x4`, --grid, the texture index (`flip`, when most layers use one) or, with
          --scan, the grid column / FlipbookLayout next to the id.
  bg      clear = transparent background, usable at any LightEmission.
          black = no alpha, or an opaque dark border: ADDITIVE ONLY (LightEmission 1); below that you see a dark square.
          dark  = a dark semi-transparent haze round bright art (10%+ of the frame, 30%+ of the alpha; art that is
                  dark as a whole is ink by design and stays "clear", colour black): additive only; at
                  LightEmission < 1 it darkens a big area with the haze's outline.
          faint = most of the art is low-alpha haze (more 0-10% alpha area than 2x the 25%+ area, over 20%+ of the
                  frame) or low alpha reaches the frame edge: reads weak, and tinted dark it darkens a soft card round
                  the art.
          card  = opaque light background: a grey/white square in every mode.
  colour  white / grey / black: neutral, tints cleanly with Color ("black+white" = dark art with white parts: additive
          shows only the white parts). "pale <hue>" = slight tint, "<hue>" = coloured (tinting it another colour
          multiplies: blue x gold = olive), "dark <hue>" = dark coloured art (adds little when additive), multicolour =
          rainbow / chromatic: use untinted. From the alpha x luma weighted saturation
          and hue of the visible pixels (white < 0.08 < pale < 0.2 < coloured; multicolour when the hues disagree).
  parts   separate shapes in one image (median over the used cells of a flipbook), at 20% of the peak visibility,
          counting shapes with 2%+ of the art. "N lines" = N parallel streaks (within 12 degrees, 4:1 or longer):
          used as ONE streak (VelocityParallel, FacingCameraWorldUp) they read as a barcode comb. "scatter" = many
          tiny bits.
  eff     effective resolution: the smallest cell size (long side, px) the art survives being resampled to: the first
          size where downsampling and upsampling back adds less than 0.45 texels of edge blur (sum of the absolute
          change / sum of the gradient), log-interpolated. Calibration: a copy of the crisp 892 px rune 135141028133816
          upscaled from 128 px reads ~141, from 256 px ~216, a nearest-neighbour 128 px upscale ~120; the 64 px soft
          glow 867619398 reads 16. Below 48 the art is "smooth": a soft blur with no edges to lose, so drawing it
          bigger only enlarges the blur (right for glows and smoke; a spiky texture that measures smooth is already
          blurry, e.g. the 128 px spiky star 16892226410).
          Screen rule: bilinear magnification is invisible up to ~1.25x, so the art starts to look soft (blurry spikes,
          stair-stepped thin edges) once drawn larger than ~1.25 x eff pixels on screen. On a 1080p screen with the
          default 70 degree field of view, one stud at distance d is ~770 / d px; a particle is 2 x Size studs across
          (Size is a half-width, measured), so on-screen px ~= 1540 x Size / d: eff 110 is soft above Size ~2.7
          seen from 30 studs (a Beam or part: 770 x width / d).
          In the summary: "low-res" = single image with edges and eff 48-127 (soft above
          ~160 px); "upscaled" = eff under 0.3 x the stored size (a crisp upload reads ~0.5, so stored at 2x+).
  fill    % of the image (median used cell) covered at 10%+ of the peak: hairline ~1-5, soft glow card 40+.
  src     thumb = the original needs authentication (privacy-restricted upload), so the 700 px thumbnail was measured:
          px unknown (aspect given), eff rough (within ~2x of the original's on 11 public pairs; printed with ~,
          or ">=" when it reaches half the thumbnail's size, the most a thumbnail can show);
          bg, colour, parts and fill matched the originals on all 11.

Fetch: GET https://assetdelivery.roblox.com/v2/assetId/<id> (public, no key) -> locations[0].location (gzip
unwrapped); a Decal (type 13) is followed once to its image. Restricted ids fall back to the thumbnails API; a
placeholder thumbnail (UnknownImage, PrivateImage, Audio, Decal in its URL) counts as a failure.
Originals are cached as <cache>/<id>.png (thumbnails <id>.thumb.png, permanent failures <id>.missing). Downloads are
untrusted data: they stay in the cache directory, are only ever opened with Pillow (format whitelist, size caps) and
nothing in it is executed. A few threads, requests spaced 0.25 s apart, retries with backoff; failures are reported
and the run goes on. The image CDN answered 503 to everything after ~1,400 quick downloads (2026-11-14, cleared
within the hour): such ids fail "try again later" (not remembered); run the same command again and only the missing
ones are fetched.
"""
import argparse
import concurrent.futures
import glob
import gzip
import io
import json
import math
import os
import re
import sys
import threading
import time
import urllib.error
import urllib.request

from PIL import Image, ImageChops, ImageStat

UA = {"User-Agent": "vfxmith-texture-traits"}
DELIVERY = "https://assetdelivery.roblox.com/v2/assetId/{}"
THUMB = "https://thumbnails.roblox.com/v1/assets?assetIds={}&size={}&format=Png"
MAX_BYTES = 40 << 20
FORMATS = {"PNG", "JPEG", "BMP", "TGA", "GIF", "WEBP", "TIFF"}
Image.MAX_IMAGE_PIXELS = 4096 * 4096


# ------------------------------------------------------------------------------------------------------------- fetch
class FetchError(Exception):
    """A failed fetch. permanent = deleted / moderated / not an image (remembered in the cache); else retry later."""

    def __init__(self, msg, permanent=False):
        super().__init__(msg)
        self.permanent = permanent


_pace = threading.Lock()
_last = [0.0]


def http(url, retries=4):
    """GET url -> (status, bytes). Requests are spaced 0.25 s apart over all threads (the image CDN answers 503 to
    bursts); 429/5xx and network errors are retried with backoff; other HTTP errors return."""
    for attempt in range(retries):
        with _pace:
            wait = _last[0] + 0.25 - time.time()
            if wait > 0:
                time.sleep(wait)
            _last[0] = time.time()
        try:
            with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=45) as r:
                body = r.read(MAX_BYTES + 1)
                if len(body) > MAX_BYTES:
                    raise FetchError("file too big", True)
                return r.status, body
        except urllib.error.HTTPError as e:
            if e.code in (429, 500, 502, 503, 504) and attempt < retries - 1:
                time.sleep(2 ** attempt * 3)
                continue
            return e.code, e.read(65536)
        except (urllib.error.URLError, TimeoutError, ConnectionError, OSError):
            if attempt < retries - 1:
                time.sleep(2 ** attempt * 1.5)
                continue
            raise FetchError("network error")
    raise FetchError("retries exhausted")


def _gunzip(body):
    for _ in range(2):
        if body[:2] == b"\x1f\x8b":
            with gzip.GzipFile(fileobj=io.BytesIO(body)) as f:
                body = f.read(MAX_BYTES + 1)
            if len(body) > MAX_BYTES:
                raise FetchError("file too big", True)
    return body


def decode(body):
    """Untrusted bytes -> validated Pillow image (gzip unwrapped, format whitelisted, pixel count capped)."""
    try:
        im = Image.open(io.BytesIO(_gunzip(body)))
        if im.format not in FORMATS:
            raise FetchError(f"not an image file ({im.format})", True)
        im.load()
    except FetchError:
        raise
    except Exception as e:  # truncated, decompression bomb, unknown format
        raise FetchError(f"unreadable image ({type(e).__name__})", True)
    if im.mode not in ("1", "L", "LA", "P", "RGB", "RGBA", "I;16", "I", "F"):
        im = im.convert("RGBA")
    return im


def save_png(im, path):
    tmp = path + ".tmp"
    im.save(tmp, "PNG")
    os.replace(tmp, path)


def fetch(tid, cache, refetch=False):
    """-> (path, src) with src 'orig' (the uploaded image) or 'thumb' (700 px thumbnail: the original needs auth).
    Raises FetchError(reason)."""
    orig, thumb, miss = (os.path.join(cache, f"{tid}{x}") for x in (".png", ".thumb.png", ".missing"))
    if not refetch:
        if os.path.exists(orig):
            return orig, "orig"
        if os.path.exists(thumb):
            return thumb, "thumb"
        if os.path.exists(miss):
            raise FetchError(open(miss).read().strip() or "missing", True)
    try:
        return _fetch(tid, orig, thumb)
    except FetchError as e:
        if e.permanent:
            open(miss, "w").write(str(e))
        raise


def _fetch(tid, orig, thumb, follow=True):
    st, body = http(DELIVERY.format(tid))
    try:
        j = json.loads(body)
    except ValueError:
        j = {}
    locs = j.get("locations") or []
    if st == 200 and locs and locs[0].get("location"):
        atype = j.get("assetTypeId")
        st2, data = http(locs[0]["location"])
        if st2 != 200:  # the CDN throttles bursts (503, sometimes 403): retry later, never settle for the thumbnail
            raise FetchError(f"cdn HTTP {st2} (try again later)")
        if atype == 13 and follow:  # Decal: an XML wrapper that names the image id
            m = re.search(rb"(?:\?id=|rbxassetid://)(\d{3,20})", _gunzip(data))
            if not m:
                raise FetchError("decal without an image id", True)
            return _fetch(int(m.group(1)), orig, thumb, follow=False)
        if atype not in (1, None):
            raise FetchError(f"not an image (asset type {atype})", True)
        save_png(decode(data), orig)
        return orig, "orig"
    errs = j.get("errors") or [{}]
    code, msg = errs[0].get("code", st), (errs[0].get("message") or "").strip()
    if code in (401, 403) or "uthentic" in msg or "ermission" in msg:
        return _thumb(tid, thumb, "needs auth")
    if j.get("isArchived"):
        raise FetchError("archived", True)
    raise FetchError(f"{msg or 'HTTP ' + str(st)}"[:80], st in (400, 404, 409, 410) or code in (404, 409))


def _thumb(tid, thumb, why):
    last = "unavailable"
    for size in ("700x700", "420x420", "150x150"):
        for attempt in range(3):
            st, body = http(THUMB.format(tid, size))
            try:
                d = (json.loads(body).get("data") or [{}])[0]
            except ValueError:
                d = {}
            state = d.get("state")
            if state == "Completed" and d.get("imageUrl"):
                kind = re.search(r"/\d+/\d+/(\w+)/", d["imageUrl"])
                kind = kind.group(1) if kind else "?"
                if kind != "Image":  # UnknownImage / PrivateImage / Audio ...: a placeholder, not the texture
                    raise FetchError(f"original {why}; thumbnail is a placeholder ({kind})", True)
                st2, data = http(d["imageUrl"], retries=2)
                if st2 == 200:
                    save_png(decode(data), thumb)
                    return thumb, "thumb"
                last = f"thumbnail cdn HTTP {st2}"
                break  # try the next size
            if state in ("Blocked", "Error"):
                raise FetchError(f"original {why}; thumbnail {state}", True)
            last = f"thumbnail {state or 'unavailable'}"
            time.sleep(3)
    raise FetchError(f"original {why}; {last}")


# ------------------------------------------------------------------------------------------------------------ traits
LUMA = (0.299, 0.587, 0.114)
SIZES = [16, 24, 32, 48, 64, 96, 128, 160, 192, 256, 320, 384, 512, 640, 768, 1024]
TAU = 0.45  # edge-blur budget in texels, see effective_res()
SMOOTH = 48  # eff below this: a soft blur with no edges to lose (glows, smoke; or art that is already blurry)
HUES = [(15, "red"), (40, "orange"), (68, "yellow"), (160, "green"), (195, "cyan"), (255, "blue"), (290, "violet"),
        (335, "pink"), (361, "red")]


def _pixels(ch):
    return list(ch.get_flattened_data() if hasattr(ch, "get_flattened_data") else ch.getdata())


def _grad(X):
    w, h = X.size
    if w < 2 or h < 2:
        return 0.0
    dx = ImageChops.difference(X.crop((1, 0, w, h)), X.crop((0, 0, w - 1, h)))
    dy = ImageChops.difference(X.crop((0, 1, w, h)), X.crop((0, 0, w, h - 1)))
    return ImageStat.Stat(dx).sum[0] + ImageStat.Stat(dy).sum[0]


def _blur(X, size):
    """Sum |X - up(down(X))| for a smooth (Lanczos/bicubic) and a blocky (box/nearest) round trip, best of both."""
    up = X.resize(size, Image.LANCZOS).resize(X.size, Image.BICUBIC)
    e = ImageStat.Stat(ImageChops.difference(X, up)).sum[0]
    upn = X.resize(size, Image.BOX).resize(X.size, Image.NEAREST)
    return min(e, ImageStat.Stat(ImageChops.difference(X, upn)).sum[0])


def effective_res(chans, grid):
    """Smallest cell size (long side, px) the art survives: the first candidate size where resampling down and back
    adds less than TAU texels of blur per unit of edge (sum |X - up(down(X))| / sum |grad X|), log-interpolated
    between candidates. The worst (largest) of the given channels (alpha, premultiplied luma) wins."""
    cols, rows = grid
    best = 0.0
    for X in chans:
        g = _grad(X)
        if g < 1:
            continue
        w, h = X.size
        cw, ch = w / cols, h / rows
        native = max(cw, ch)
        prev, found = None, native
        for S in SIZES:
            if S >= native:
                break
            k = S / native
            size = (max(1, round(cw * k)) * cols, max(1, round(ch * k)) * rows)
            b = _blur(X, size) / g
            if b <= TAU:
                if prev is None:
                    found = S
                else:
                    ps, pb = prev
                    found = ps * (S / ps) ** ((pb - TAU) / max(pb - b, 1e-6))
                break
            prev = (S, b)
        best = max(best, found)
    return best


def _hue_name(deg):
    for lim, name in HUES:
        if deg < lim:
            return name
    return "red"


def _components(mask, w, x0, y0, cw, ch, vis):
    """8-connected components of mask inside one cell -> list of (weight, n, sx, sy, sxx, syy, sxy)."""
    seen = set()
    comps = []
    for y in range(y0, y0 + ch):
        for x in range(x0, x0 + cw):
            i = y * w + x
            if not mask[i] or i in seen:
                continue
            seen.add(i)
            stack = [i]
            W = n = sx = sy = sxx = syy = sxy = 0.0
            while stack:
                j = stack.pop()
                jy, jx = divmod(j, w)
                v = vis[j]
                W += v
                n += 1
                sx += jx * v
                sy += jy * v
                sxx += jx * jx * v
                syy += jy * jy * v
                sxy += jx * jy * v
                for yy in (jy - 1, jy, jy + 1):
                    if yy < y0 or yy >= y0 + ch:
                        continue
                    for xx in (jx - 1, jx, jx + 1):
                        if xx < x0 or xx >= x0 + cw:
                            continue
                        k = yy * w + xx
                        if mask[k] and k not in seen:
                            seen.add(k)
                            stack.append(k)
            comps.append((W, n, sx, sy, sxx, syy, sxy))
    return comps


def _shape(c):
    """(elongation, angle in degrees mod 180) of a component from its weighted second moments."""
    W, n, sx, sy, sxx, syy, sxy = c
    if W <= 0:
        return 1.0, 0.0
    mx, my = sx / W, sy / W
    cxx, cyy, cxy = sxx / W - mx * mx + 1 / 12, syy / W - my * my + 1 / 12, sxy / W - mx * my
    tr, det = cxx + cyy, cxx * cyy - cxy * cxy
    d = max(tr * tr / 4 - det, 0) ** 0.5
    l1, l2 = tr / 2 + d, max(tr / 2 - d, 1e-6)
    return (l1 / l2) ** 0.5, math.degrees(0.5 * math.atan2(2 * cxy, cxx - cyy)) % 180


def _parts(comps, total):
    """-> (count, label or None) for one cell."""
    big = [c for c in comps if c[0] >= 0.02 * total and c[1] >= 3]
    small_w = sum(c[0] for c in comps if c[0] < 0.02 * total)
    if len(comps) >= 12 and small_w >= 0.35 * total:
        return len(comps), "scatter"
    if len(big) >= 3:
        lines = [(a, c[0]) for (e, a), c in zip(map(_shape, big), big) if e >= 4]
        if len(lines) >= 3:
            ref = sorted(a for a, _ in lines)[len(lines) // 2]
            par = [l for l in lines if min(abs(l[0] - ref), 180 - abs(l[0] - ref)) <= 12]
            if len(par) >= 3 and sum(wt for _, wt in par) >= 0.6 * total:
                return len(big), f"{len(par)} lines"
    return max(1, len(big)), None


def analyse(im, grid=None, src="orig", debug=False):
    """Pillow image -> traits dict. grid = (cols, rows) of a flipbook, or None."""
    mode0 = im.mode
    had_alpha = mode0 in ("RGBA", "LA", "PA", "RGBa", "La") or (mode0 == "P" and "transparency" in im.info)
    im = im.convert("RGBA")
    W, H = im.size
    cols, rows = grid or (1, 1)
    A_full = im.getchannel("A")
    if had_alpha and A_full.getextrema()[0] >= 250:
        had_alpha = False  # an alpha channel that is opaque everywhere

    # full-res alpha statistics: faint haze and dark haze
    hist = A_full.histogram()
    faint_px, solid_px = sum(hist[1:26]), sum(hist[64:])
    faint_area = faint_px / (W * H)
    lum_full = im.convert("RGB").convert("L")
    haze = ImageChops.multiply(A_full.point(lambda v: 255 if 10 <= v < 153 else 0),
                               lum_full.point(lambda v: 255 if v < 77 else 0))
    dark_area = haze.histogram()[255] / (W * H)
    dark_mass = ImageStat.Stat(ImageChops.multiply(haze, A_full)).sum[0] / max(ImageStat.Stat(A_full).sum[0], 1)

    # working copy: premultiplied, each cell at most T px on its long side
    T = 160 if cols * rows == 1 else (96 if max(cols, rows) <= 4 else 64)
    k = min(1.0, T / max(W / cols, H / rows))
    cw, ch = max(1, round(W / cols * k)), max(1, round(H / rows * k))
    w, h = cw * cols, ch * rows
    pm = im.convert("RGBa").resize((w, h), Image.BOX)
    R, G, B, A = (_pixels(c) for c in pm.split())
    n = w * h
    lp = [(LUMA[0] * R[i] + LUMA[1] * G[i] + LUMA[2] * B[i]) / 255 for i in range(n)]  # premultiplied luma 0-1
    al = [x / 255 for x in A]
    lum = [min(1.0, lp[i] / al[i]) if al[i] > 0.004 else 0.0 for i in range(n)]  # colour luma 0-1

    # background: the outer band (4%) of every cell
    bw = max(1, round(0.04 * min(cw, ch)))
    band = [y * w + x for cy in range(rows) for cx in range(cols)
            for y in range(cy * ch, cy * ch + ch) for x in range(cx * cw, cx * cw + cw)
            if min(x - cx * cw, cx * cw + cw - 1 - x, y - cy * ch, cy * ch + ch - 1 - y) < bw]
    b_op = sum(1 for i in band if al[i] >= 0.5) / len(band)
    b_some = sum(1 for i in band if A[i] >= 2) / len(band)
    b_lum = sorted(lum[i] for i in band if al[i] >= 0.5)
    b_lum = b_lum[len(b_lum) // 2] if b_lum else 0.0
    if not had_alpha or b_op >= 0.6:
        bg = "black" if b_lum <= 0.15 else "card"
    elif b_some >= 0.5 or (faint_area >= 0.2 and faint_px >= 2 * solid_px):
        bg = "faint"
    else:
        bg = "clear"  # may become "dark" below, once the tone of the art is known

    # what you see of each pixel: alpha; luma on a black card; the difference from a light card
    if bg == "black":
        vis = lp
    elif bg == "card":
        vis = [abs(lum[i] - b_lum) * al[i] for i in range(n)]
    else:
        vis = al
    sv = sorted(vis)
    peak = max(sv[min(n - 1, int(n * 0.995))], 1e-6)

    # colour: alpha x luma weighted saturation and hue of the visible pixels
    sw = ssum = hx = hy = tw = tsum = bright = 0.0
    for i in range(n):
        a = al[i]
        if a < 0.02 or vis[i] < 0.05 * peak:
            continue
        r, g, b = R[i] / a, G[i] / a, B[i] / a
        mx, mn = max(r, g, b), min(r, g, b)
        wgt = lp[i] if bg == "black" else vis[i] * (0.02 + lum[i])
        tw += vis[i]
        tsum += vis[i] * lum[i]
        if lum[i] > 0.6:
            bright += vis[i]
        sw += wgt
        if mx < 40:  # too dark for a reliable hue
            continue
        sat = (mx - mn) / mx
        ssum += wgt * sat
        if mx - mn > 1:
            if mx == r:
                hd = 60 * (((g - b) / (mx - mn)) % 6)
            elif mx == g:
                hd = 60 * ((b - r) / (mx - mn) + 2)
            else:
                hd = 60 * ((r - g) / (mx - mn) + 4)
            hx += wgt * sat * math.cos(math.radians(hd))
            hy += wgt * sat * math.sin(math.radians(hd))
    sat = ssum / sw if sw else 0.0
    coh = (hx * hx + hy * hy) ** 0.5 / ssum if ssum else 0.0
    hue = math.degrees(math.atan2(hy, hx)) % 360
    tone = 1.0 if bg == "black" else (tsum / tw if tw else 0.0)
    if bg in ("clear", "faint") and dark_area >= 0.1 and dark_mass >= 0.3 and tone >= 0.3:
        bg = "dark"  # a dark haze round bright art (dark art itself, tone < 0.3, is ink by design: colour says so)
    if sat < 0.08:
        colour = "white" if tone >= 0.6 else ("grey" if tone >= 0.3 else
                                             ("black+white" if tw and bright >= 0.08 * tw else "black"))
    elif coh < 0.5:
        colour = "multicolour"
    else:
        colour = ("pale " if sat < 0.2 else ("dark " if tone < 0.3 else "")) + _hue_name(hue)

    # parts and fill per used cell
    thr = max(0.2 * peak, 0.04)
    mask = [v >= thr for v in vis]
    cells = []
    for cy in range(rows):
        for cx in range(cols):
            idx = [y * w + x for y in range(cy * ch, cy * ch + ch) for x in range(cx * cw, cx * cw + cw)]
            tot = sum(vis[i] for i in idx if mask[i])
            if tot <= 0:
                continue
            comps = _components(mask, w, cx * cw, cy * ch, cw, ch, vis)
            fill = sum(1 for i in idx if vis[i] >= 0.1 * peak) / len(idx)
            cells.append((tot, _parts(comps, tot), fill))
    if cells:
        maxtot = max(c[0] for c in cells)
        cells = [c for c in cells if c[0] >= 0.01 * maxtot]
    used = len(cells)
    if cells:
        counts = sorted(c[1][0] for c in cells)
        part_n = counts[len(counts) // 2]
        labels = [c[1][1] for c in cells if c[1][1]]
        label = max(set(labels), key=labels.count) if len(labels) * 2 > len(cells) else None
        if label and label.endswith("lines"):
            nl = sorted(int(l.split()[0]) for l in labels if l.endswith("lines"))
            label = f"{nl[len(nl) // 2]} lines"
        fills = sorted(c[2] for c in cells)
        fill = fills[len(fills) // 2]
    else:
        part_n, label, fill = 0, "empty", 0.0

    # effective resolution on the full image, per cell
    r_, g_, b_, a_ = im.convert("RGBa").split()
    chans = [Image.merge("RGB", (r_, g_, b_)).convert("L")]
    if had_alpha and bg != "black":
        chans.insert(0, a_)
    eff = effective_res(chans, (cols, rows))

    t = {}
    if src == "thumb":
        t["src"] = "thumb"
        t["aspect"] = f"{W}x{H}"
        if eff >= 0.5 * max(W / cols, H / rows):  # a thumbnail cannot show more: report a lower bound
            eff = 0.5 * max(W / cols, H / rows)
            t["eff_min"] = True
    else:
        t["px"] = f"{W}x{H}"
    if grid:
        t["grid"] = f"{cols}x{rows}"
        if src != "thumb":
            t["cell"] = f"{W // cols}x{H // rows}"
        t["used"] = used
    t.update(bg=bg, colour=colour, parts=label or str(part_n), eff=int(round(eff)), fill=int(round(fill * 100)))
    if debug:
        t["_dbg"] = dict(b_op=round(b_op, 3), b_some=round(b_some, 3), b_lum=round(b_lum, 3),
                         dark_area=round(dark_area, 3), dark_mass=round(dark_mass, 3), faint=round(faint_area, 3),
                         f_s=round(faint_px / max(solid_px, 1), 2), sat=round(sat, 3), coh=round(coh, 2),
                         hue=round(hue), tone=round(tone, 2), parts_n=part_n)
    return t


# ---------------------------------------------------------------------------------------------------------- output
def soft_above(eff):
    v = 1.25 * eff
    return int(round(v, -1 if v < 1000 else -2))


def is_lowres(t):
    """Single image with edges that looks soft above ~160 px on screen (eff 48-127)."""
    return not t.get("grid") and SMOOTH <= t["eff"] < 128


def is_upscaled(t):
    """Stored at 2x+ the detail it holds: eff under 0.3 x the stored long side (a crisp image reads ~0.5)."""
    if t.get("grid") or "px" not in t or t["eff"] < SMOOTH:
        return False
    return t["eff"] < 0.3 * max(int(x) for x in t["px"].split("x"))


def line(tid, t):
    """One compact line for an id."""
    if "fail" in t:
        return f"{tid}  FAILED: {t['fail']}"
    size = f"? px (thumbnail {t['aspect']})" if t.get("src") == "thumb" else t["px"]
    if t.get("grid"):
        cell = f", {t['cell'].split('x')[0]} px cells" if t.get("cell") else ""
        size += f" {t['grid']}{cell}, {t['used']}/{int(t['grid'][0]) * int(t['grid'][2])} used"
    p = t["parts"]
    parts = "1 part" if p == "1" else (f"{p} parts" if p.isdigit() else p)
    per = "/cell" if t.get("grid") else ""
    rough = (">=" if t.get("eff_min") else "~") if t.get("src") == "thumb" else ""
    if t["eff"] < SMOOTH:
        eff = f"eff {rough}{t['eff']} px{per} (smooth: no edges to lose, bigger only enlarges the blur)"
    else:
        eff = f"eff {rough}{t['eff']} px{per} (soft above ~{soft_above(t['eff'])} px on screen)"
    bg = {"black": "BLACK card (additive only)", "dark": "DARK haze (additive only)", "faint": "FAINT haze",
          "card": "OPAQUE card"}.get(t["bg"], "clear")
    return f"{tid}  {size}  {bg}  {t['colour']}  {parts}  {eff}  fill {t['fill'] or '<1'}%"


def summary(ts):
    def c(f):
        return sum(1 for t in ts if f(t))
    return (f"of {len(ts)}: coloured {c(lambda t: t['colour'] not in ('white', 'grey', 'black', 'black+white'))}"
            f" (pale {c(lambda t: t['colour'].startswith('pale'))}, multicolour"
            f" {c(lambda t: t['colour'] == 'multicolour')}), black card {c(lambda t: t['bg'] == 'black')},"
            f" dark haze {c(lambda t: t['bg'] == 'dark')}, faint {c(lambda t: t['bg'] == 'faint')},"
            f" opaque card {c(lambda t: t['bg'] == 'card')}, multi-part {c(lambda t: t['parts'] not in ('1', 'empty'))}"
            f" (parallel lines {c(lambda t: t['parts'].endswith('lines'))}, scatter"
            f" {c(lambda t: t['parts'] == 'scatter')}), smooth (eff < 48) {c(lambda t: t['eff'] < SMOOTH)},"
            f" low-res single images (eff 48-127) {c(is_lowres)}, upscaled 2x+ {c(is_upscaled)},"
            f" thumbnail only {c(lambda t: t.get('src') == 'thumb')}")


# ------------------------------------------------------------------------------------------------------------ batch
def parse_grid(s):
    m = re.fullmatch(r"(?:Grid)?(\d)x(\d)", (s or "").strip())
    return (int(m.group(1)), int(m.group(2))) if m else None


def index_ids(path):
    """Texture index (texture_sheets.py) -> {id: grid or None}; a grid when most layers use the texture with it."""
    out = {}
    for v in json.load(open(path)).values():
        g = None
        if v.get("flip"):
            layers = sum(c for _, c in v.get("LE") or []) or 1
            name, cnt = max(v["flip"], key=lambda x: x[1])
            if cnt >= 0.5 * layers:
                g = parse_grid(name)
        out[str(v["id"])] = g
    return out


def scan_ids(path):
    """Texture ids named in a markdown table (backticked, grid column '4x4') or a recipe .luau (textures table and
    Texture = <id>, grid from FlipbookLayout in the same layer) -> {id: grid or None}."""
    out = {}
    text = open(path, encoding="utf-8").read()
    if path.endswith(".md"):
        for row in text.splitlines():
            ids = re.findall(r"`(\d{7,})`", row)
            if not ids:
                continue
            cells = [c.strip() for c in row.strip().strip("|").split("|")] if row.lstrip().startswith("|") else []
            g = next((parse_grid(c) for c in cells if parse_grid(c)), None)
            for i in ids:
                out[i] = out.get(i) or g
        return out
    keys = {}
    m = re.search(r"\n\ttextures = \{(.*?)\n\t\}", text, re.S)
    if m:
        for key, v in re.findall(r"^\s*(\w+)\s*=\s*(\d{6,})", m.group(1), re.M):
            keys[key] = v
            out[v] = None
    for layer in re.split(r"\n\t\t\{", text):
        lay = "\n".join(l.split("--")[0] for l in layer.splitlines())
        fl = re.search(r"FlipbookLayout\s*=\s*(\d)", lay)
        g = (int(fl.group(1)),) * 2 if fl else None
        named = [keys.get(key) for key in re.findall(r'Texture\s*=\s*"(\w+)"', lay)]
        for v in re.findall(r"Texture\s*=\s*(\d{6,})", lay) + named:
            if v:
                out[v] = out.get(v) or g
    return out


def measure(tid, grid, cache, refetch, debug=False):
    try:
        path, src = fetch(tid, cache, refetch)
        with Image.open(path) as im:
            return analyse(im, grid, src, debug)
    except FetchError as e:
        return {"fail": str(e)}
    except Exception as e:  # keep going: one broken image must not stop a batch
        return {"fail": f"{type(e).__name__}: {e}"[:120]}


def write_out(path, results):
    old = json.load(open(path)) if os.path.exists(path) else {}
    old.pop("_about", None)
    old.update(results)
    about = {"made_by": "kit/scripts/texture_traits.py (legend in its docstring)", "date": time.strftime("%Y-%m-%d"),
             "count": len(old)}
    rows = [("_about", about)] + sorted(old.items(), key=lambda kv: int(kv[0]))
    with open(path + ".tmp", "w") as f:
        f.write("{\n" + ",\n".join(f"{json.dumps(k)}: {json.dumps(v, separators=(',', ':'))}" for k, v in rows)
                + "\n}\n")
    os.replace(path + ".tmp", path)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("ids", nargs="*", help="texture ids, optionally id:4x4")
    ap.add_argument("--grid", help="flipbook grid for the ids given on the command line, e.g. 4x4")
    ap.add_argument("--json", action="store_true", help="print JSON instead of lines")
    ap.add_argument("--index", help="texture index json (gallery/textures/index.json): measure all its ids")
    ap.add_argument("--scan", nargs="*", default=[], help=".md / .luau files: measure every texture id they name")
    ap.add_argument("--out", help="write (merge) results into this traits json")
    ap.add_argument("--cache", default=os.path.expanduser("~/.vfxmith/cache/textures"),
                    help="download cache (default ~/.vfxmith/cache/textures)")
    ap.add_argument("--threads", type=int, default=4, help="download threads (max 6)")
    ap.add_argument("--refetch", action="store_true", help="download again (also retries remembered failures)")
    ap.add_argument("--debug", action="store_true", help="add the raw measurements (_dbg)")
    a = ap.parse_args()
    os.makedirs(a.cache, exist_ok=True)

    todo = {}
    if a.index:
        todo.update(index_ids(a.index))
    for pat in a.scan:
        for path in sorted(glob.glob(pat)) or [pat]:
            for i, g in scan_ids(path).items():
                todo[i] = todo.get(i) or g
    for s in a.ids:
        tid, _, gs = s.partition(":")
        if not tid.isdigit():
            ap.error(f"not an id: {s}")
        todo[tid] = parse_grid(gs or a.grid or "") or todo.get(tid)
    if not todo:
        ap.error("give ids, --index or --scan")

    results = {}
    with concurrent.futures.ThreadPoolExecutor(max(1, min(a.threads, 6))) as ex:
        futs = {ex.submit(measure, tid, g, a.cache, a.refetch, a.debug): tid for tid, g in todo.items()}
        for k, f in enumerate(concurrent.futures.as_completed(futs), 1):
            tid = futs[f]
            results[tid] = f.result()
            if a.out:
                if k % 100 == 0:
                    print(f"  {k}/{len(todo)}", file=sys.stderr, flush=True)
            elif not a.json:
                print(line(tid, results[tid]) + (f"\n    {results[tid].get('_dbg')}" if a.debug else ""), flush=True)
    if a.json and not a.out:
        print(json.dumps(results, indent=1))
    if a.out:
        write_out(a.out, results)
        fails = {k: v["fail"] for k, v in results.items() if "fail" in v}
        print(f"{len(results)} ids, {len(fails)} failed -> {a.out}")
        print(summary([v for v in results.values() if "fail" not in v]))
        for k, v in sorted(fails.items()):
            print(f"  failed {k}: {v}")


if __name__ == "__main__":
    main()
