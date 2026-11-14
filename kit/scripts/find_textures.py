#!/usr/bin/env python3
"""Search every texture vfxmith knows: the 1,539 from the open-source library (what real effects use, with roles from
knowledge/texture-vocab.md) and the ~9,200 of the VFX Studio library (a free Roblox plugin's catalogue, ~2,750 of them
flipbooks), each with measured traits. Use it to pick FRESH textures per role instead of the recipe's defaults.

    python3 -I find_textures.py "spiky ice shard" [-n 12] [--flipbook | --single] [--bg clear|any] [--colour white|any]
                                [--min-eff 96] [--source all|library|vfxstudio] [--exclude <spec.luau or ids>]
                                [--sheet out.jpg] [--json]
    python3 -I find_textures.py --roles "flash=ice flash star; ring=shockwave ring; shards=ice shard crystal" \
                                -n 5 --exclude <recipe or spec .luau> --sheet <effect>/textures.jpg
      (one row of candidates per role on ONE sheet: what the librarian hands the builder)

Prints one line per hit: rank, id, source, name, flipbook grid, traits (bg, colour, parts, eff, fill), keywords/roles.
--sheet writes one contact sheet of the hits (thumbnails from the traits cache, fetched if missing), labelled with the
rank, so a builder looks at ONE image. Use a hit by its id (in a spec's `textures` table); a flipbook needs
`FlipbookLayout = 4` (2, 4 or 8 = the grid), `FlipbookMode = "OneShot"` ("Loop", "PingPong", "Random") and
`FlipbookFramerate` (or OneShot over the Lifetime). Traits: see
kit/scripts/texture_traits.py (bg black / dark = additive only, LightEmission 1; coloured art tinted another hue goes
muddy; eff = the art's real resolution). Default filters keep clear-background, non-card textures with eff >= 48.
"""
import argparse
import glob
import io
import json
import math
import os
import re
import urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, "..", ".."))
TEX = os.path.join(ROOT, "gallery", "textures")
CACHE = os.path.expanduser("~/.vfxmith/cache/textures")

SYN = {
    "spark": "spark sparks spec specs star glint twinkle point sparkle", "glint": "glint star twinkle sparkle flare",
    "flash": "flash flare burst glow star light shine bloom", "flare": "flare flash star lens glow",
    "ring": "ring circle shockwave shock wave halo disc", "shockwave": "shockwave shock ring wave circle",
    "smoke": "smoke cloud dust puff mist fog steam", "dust": "dust smoke puff ground debris", "mist": "mist fog smoke steam",
    "fire": "fire flame ember burn blaze inferno", "flame": "flame fire burn blaze", "ember": "ember spark fire",
    "ice": "ice frost crystal snow frozen shard glass cold", "frost": "frost ice snow crystal cold",
    "crystal": "crystal shard ice gem glass", "shard": "shard crystal fragment glass debris rock piece",
    "rock": "rock debris stone chunk shard", "debris": "debris rock chunk shard fragment",
    "slash": "slash slashes crescent arc swing cut sword", "crescent": "crescent slash arc moon",
    "lightning": "lightning bolt electric zap thunder arc", "electric": "electric lightning bolt zap",
    "beam": "beam ray laser trail streak", "ray": "ray rays beam light godray",
    "streak": "streak line needle speed wind trail", "needle": "needle streak line spike",
    "swirl": "swirl vortex spiral wind twist portal", "vortex": "vortex swirl spiral portal",
    "impact": "impact hit burst splash crack", "burst": "burst impact explosion star flash",
    "explosion": "explosion burst blast fire impact", "crack": "crack ground decal scorch fissure",
    "ground": "ground floor decal crack scorch", "energy": "energy magic aura orb power",
    "aura": "aura energy glow", "orb": "orb ball sphere glow", "water": "water splash wave drop liquid bubble",
    "dark": "dark void black shadow ink", "void": "void dark black portal", "holy": "holy light divine ray god",
    "glow": "glow soft light orb bloom", "star": "star flare glint spark", "spike": "spike spiky star burst needle",
    "wind": "wind swirl air streak speed", "magic": "magic rune circle energy glyph", "rune": "rune glyph magic circle",
}
TEXT_PENALTY = {"text"}  # VFX Studio "Text" keyword: letters and words, rarely wanted


def words(s):
    s = re.sub(r"([a-z])([A-Z])", r"\1 \2", s or "")
    return [w for w in re.split(r"[^a-z]+", s.lower()) if len(w) > 1]


def load():
    rows = {}
    # library: usage names + texture-vocab roles + traits
    idx = json.load(open(os.path.join(TEX, "index.json")))
    for v in idx.values():
        tid = str(v["id"])
        names = [n for n, _ in v.get("names", [])]
        flip = None
        if v.get("flip"):
            flip = str(max(v["flip"], key=lambda x: x[1])[0]).replace("Grid", "")
        rows[tid] = {"id": tid, "src": "library", "name": names[0] if names else "", "kw": set(), "text": " ".join(names),
                     "grid": flip, "uses": v.get("effects", 0)}
    vocab = os.path.join(ROOT, "knowledge", "texture-vocab.md")
    if os.path.exists(vocab):
        role = ""
        for line in open(vocab):
            if line.startswith("### "):
                role = re.sub(r"^###\s*\d+\.\s*", "", line).strip()
            for tid in re.findall(r"`(\d{8,15})`", line):
                if tid in rows and role:
                    rows[tid]["kw"].add(role)
    vs = os.path.join(TEX, "vfxstudio_index.json")
    if os.path.exists(vs):
        for tid, v in json.load(open(vs)).items():
            r = rows.get(tid) or {"id": tid, "src": "vfxstudio", "name": "", "kw": set(), "text": "", "grid": None,
                                  "uses": 0}
            if r["src"] == "library":
                r["src"] = "library+vfxstudio"
            r["name"] = r["name"] or v.get("Name", "").replace("Images/", "")
            r["text"] += " " + v.get("Name", "").replace("Images/", "")
            r["kw"] |= set(v.get("Keywords") or [])
            if v.get("Grid") and not r["grid"]:
                r["grid"] = f"{v['Grid']}x{v['Grid']}"
            rows[tid] = r
    for fn in ("traits.json", "traits_vfxstudio.json"):
        p = os.path.join(TEX, fn)
        if os.path.exists(p):
            for tid, t in json.load(open(p)).items():
                if tid in rows and isinstance(t, dict) and "fail" not in t:
                    rows[tid]["t"] = t
    return rows


def short(t):
    if not t:
        return "traits not measured"
    eff = t.get("eff")
    parts = str(t.get("parts", ""))
    if parts.isdigit():
        parts = f"{parts} part" + ("" if parts == "1" else "s")
    approx = "~" if t.get("src") == "thumb" else ""
    return " ".join(str(x) for x in (t.get("bg", "?"), t.get("colour", "?"), parts,
                                     f"eff {approx}{eff}" if eff else "",
                                     f"fill {t.get('fill')}%" if t.get("fill") is not None else "") if x)


def score(r, q, a):
    toks = [w for w in words(" ".join([r["text"], r["name"]] + list(r["kw"])))]
    kw = {w for k in r["kw"] for w in words(k)}
    bag = set(toks) | kw
    s = 0.0
    for w in q:
        if w in bag:
            s += 3.0 if w in kw else 2.5
        elif any(t.startswith(w) or w.startswith(t) for t in bag if len(t) > 2):
            s += 1.5
        elif any(x in bag for x in SYN.get(w, "").split()):
            s += 1.2
    if s == 0:
        return None
    t = r.get("t") or {}
    bg = str(t.get("bg", ""))
    if a.bg == "clear" and bg and not bg.startswith("clear"):
        return None
    if a.colour == "white" and t and str(t.get("colour", "")) not in ("white", "grey"):
        return None
    eff = t.get("eff") or 0
    if isinstance(eff, str):
        m = re.search(r"\d+", eff)
        eff = int(m.group()) if m else 0
    if t and eff and eff < a.min_eff and "smooth" not in str(t.get("eff_note", "")):
        s -= 1.0
    if "card" in bg or "faint" in bg:
        s -= 1.5
    if "lines" in str(t.get("parts", "")) and not ({"streak", "line", "lines", "speed"} & set(q)):
        s -= 1.0
    if kw & TEXT_PENALTY and "text" not in q:
        s -= 3.0
    if r["grid"]:
        s += 0.3  # flipbooks animate on their own: a small nudge
    if not t:
        s -= 0.5
    return s


def thumb(tid):
    for name in (f"{tid}.png", f"{tid}.thumb.png"):
        p = os.path.join(CACHE, name)
        if os.path.exists(p):
            return p
    try:
        url = f"https://thumbnails.roblox.com/v1/assets?assetIds={tid}&size=420x420&format=Png"
        data = json.load(urllib.request.urlopen(url, timeout=15))
        img = data["data"][0]["imageUrl"]
        p = os.path.join(CACHE, f"{tid}.thumb.png")
        os.makedirs(CACHE, exist_ok=True)
        urllib.request.urlretrieve(img, p)
        return p
    except Exception:
        return None


def sheet(hits, out, rows_of=None):
    """hits: a list (6 per row), or with rows_of = [(role, [hits])] one labelled row per role."""
    from PIL import Image, ImageDraw, ImageFont
    cw, ch, cols = 220, 250, 6
    font = ImageFont.load_default()
    if rows_of:
        lw = 110
        cols = max(len(h) for _, h in rows_of) or 1
        im = Image.new("RGB", (lw + cw * cols, ch * len(rows_of)), (20, 20, 26))
        d = ImageDraw.Draw(im)
        cells = []
        for ri, (role, hs) in enumerate(rows_of):
            d.text((8, ri * ch + ch // 2 - 6), role[:16], fill=(255, 255, 255), font=font)
            for ci, r in enumerate(hs):
                cells.append((lw + ci * cw, ri * ch, f"{role[:1].upper()}{ci + 1}", r))
    else:
        rows_n = (len(hits) + cols - 1) // cols
        im = Image.new("RGB", (cw * cols, ch * rows_n), (20, 20, 26))
        d = ImageDraw.Draw(im)
        cells = [((i % cols) * cw, (i // cols) * ch, str(i + 1), r) for i, r in enumerate(hits)]
    for x, y, tag, r in cells:
        p = thumb(r["id"])
        if p:
            try:
                t = Image.open(p).convert("RGBA")
                t.thumbnail((cw - 10, ch - 40))
                bg = Image.new("RGBA", t.size, (40, 40, 52, 255))
                bg.alpha_composite(t)
                im.paste(bg.convert("RGB"), (x + 5, y + 5))
            except Exception:
                pass
        label = f"{tag}. {r['id']}" + (f" g{r['grid']}" if r["grid"] else "")
        d.text((x + 5, y + ch - 32), label, fill=(255, 220, 120), font=font)
        d.text((x + 5, y + ch - 18), (r["name"] or "")[:34], fill=(220, 220, 230), font=font)
    im.save(out, quality=88)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("query", nargs="?", default="")
    ap.add_argument("--roles", help='"role=words; role=words": one row of candidates per role')
    ap.add_argument("-n", type=int, default=12)
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--flipbook", action="store_true")
    g.add_argument("--single", action="store_true")
    ap.add_argument("--bg", default="clear", choices=["clear", "any"])
    ap.add_argument("--colour", default="any", choices=["white", "any"])
    ap.add_argument("--min-eff", type=int, default=48)
    ap.add_argument("--source", default="all", choices=["all", "library", "vfxstudio"])
    ap.add_argument("--exclude", default="", help="a spec .luau (its ids) or comma-separated ids to leave out")
    ap.add_argument("--sheet")
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()
    rows = load()
    ex = set()
    for part in a.exclude.split(","):
        part = part.strip()
        if part.endswith(".luau") and os.path.exists(part):
            ex |= set(re.findall(r"(?<![\d.])(\d{8,15})(?![\d.])", open(part).read()))
        elif part.isdigit():
            ex.add(part)
    def search(query, n):
        q = words(query)
        hits = []
        for r in rows.values():
            if r["id"] in ex:
                continue
            if a.source != "all" and a.source not in r["src"]:
                continue
            if a.flipbook and not r["grid"]:
                continue
            if a.single and r["grid"]:
                continue
            s = score(r, q, a)
            if s is not None:
                hits.append((s, r))
        hits.sort(key=lambda x: (-x[0], -x[1]["uses"]))
        top, seen = [], set()
        for _, r in hits:  # the same art uploaded under two ids: keep the first
            key = (r["name"].lower(), r["grid"], short(r.get("t")))
            if r["name"] and key in seen:
                continue
            seen.add(key)
            top.append(r)
            if len(top) == n:
                break
        return hits, top

    if a.roles:
        rows_of = []
        for part in a.roles.split(";"):
            if "=" not in part:
                continue
            role, query = (x.strip() for x in part.split("=", 1))
            hits, top = search(query, a.n)
            rows_of.append((role, top))
            print(f"[{role}] '{query}': {len(hits)} matches")
            for i, r in enumerate(top, 1):
                grid = f" flipbook {r['grid']}" if r["grid"] else ""
                print(f"  {role[:1].upper()}{i}. {r['id']}  [{r['src']}]{grid}  {r['name'][:28]}  | {short(r.get('t'))}")
        if a.sheet:
            print("sheet:", sheet(None, a.sheet, rows_of))
        return
    if not a.query:
        ap.error("give a query or --roles")
    hits, top = search(a.query, a.n)
    if a.json:
        print(json.dumps([{k: (sorted(v) if isinstance(v, set) else v) for k, v in r.items() if k != "text"} for r in top],
                         indent=1))
    else:
        print(f"{len(hits)} matches for '{a.query}' ({len(rows)} textures searched); top {len(top)}:")
        for i, r in enumerate(top, 1):
            kws = ", ".join(sorted(r["kw"]))[:60]
            grid = f" flipbook {r['grid']}" if r["grid"] else ""
            print(f"{i:2d}. {r['id']}  [{r['src']}]{grid}  {r['name'][:30]}  | {short(r.get('t'))}  | {kws}")
    if a.sheet and top:
        print("sheet:", sheet(top, a.sheet))


if __name__ == "__main__":
    main()
