#!/usr/bin/env python3
"""Maintainer tool: score every indexed effect by STYLE REGISTER and estimate its SIZE, for compose.py.

    python3 -I kit/scripts/build_style_index.py            writes catalog/traits.json.gz
    python3 -I kit/scripts/build_style_index.py --check    prints the most typical effects per style (sanity look)

Why: the library is mostly battlegrounds / anime packs, so a finder that ranks by type alone hands every request a
battlegrounds look (alpha1: a "meteor" came out as a battlegrounds move). compose.py multiplies its type score by
the style fit computed here when the request names a style.

Styles: grounded (photoreal, natural, believable), stylized (clean cartoon, cel), anime (battlegrounds, anime
packs), cute (cosy, sweet, pastel), scifi (tech, energy, hologram). Scores are 0..1 PERCENTILES inside this library
(0.9 = more typical of that style than 90% of the effects), so the anime-heavy mix does not make "anime" win
everywhere. Each style's raw score is a sum of documented signals, read only from the catalog JSON:

- layer data (catalog/effects.jsonl.gz): share of additive layers (LightEmission >= 0.7), share of hot layers
  (Brightness >= 20) and of flash-class layers (Brightness >= 50), share of dark alpha layers (LE <= 0.2 and a dark
  first colour, or negative LE), share of lit layers (LightInfluence >= 0.3: the scene light shades them, grounded),
  share of soft flipbook volume (LE <= 0.3 on a flipbook grid: smoke, dust), share of streak layers
  (VelocityParallel or beam/trail), mean saturation, share of pink/magenta and cyan/teal first colours, layer count,
  part materials (Neon/ForceField/Glass = energy look; Slate/Granite/Concrete/Sand/Wood/Grass = natural material);
- names (file, path, layer and part names): style words (realistic, realism, stylized, toon, anime character and
  move names, cute words, sci-fi words);
- texture families: every texture gets the mean raw style of the effects that use it; an effect's family signal is
  the mean over its textures (a texture shared with realistic packs pulls an effect toward grounded), blended 30%;
- texture traits (gallery/textures/traits.json): faint/soft art leans grounded, multicolour leans cute.

Size (studs, rough, from values only; positions are not in the catalog): per emitter reach = travel (mid Speed over
mid Lifetime with Drag, plus |Acceleration| t^2 / 2) + half the largest Size; per beam the largest width; per visible
part the largest side. "extent" = the 75th percentile of the layer reaches x 2 (a diameter), "largest" = the single
largest sprite / part / beam width with its layer name. The Studio measure (C.measure in VFXCompose) is the real
number; this one only lets compose.py say "this piece is about N studs, scale ~x for the brief".
"""
import argparse
import bisect
import colorsys
import gzip
import json
import math
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
STYLES = ("grounded", "stylized", "anime", "cute", "scifi")

# Explicit style words in effect names (strong evidence) ...
STYLE_WORDS = {
    "grounded": {"realistic", "realism", "real", "photoreal", "natural", "physical", "cinematic"},
    "stylized": {"stylized", "stylised", "toon", "toony", "cartoon", "cel", "lowpoly", "zelda", "genshin"},
    "anime": {"anime", "amine", "anine", "battleground", "battlegrounds", "jjk", "tsb", "kj", "domain", "cursed",
              "bankai", "ssj", "kaioken"},
    "cute": {"cute", "kawaii", "pastel", "cozy", "cosy", "heart", "hearts", "love", "candy"},
    "scifi": {"scifi", "tech", "cyber", "hologram", "holo", "digital", "glitch", "hex", "hexagon", "circuit", "laser",
              "plasma", "forcefield"},
}
# ... and content words that lean a style (weak evidence). Anime: series, characters and battlegrounds terms that the
# library's pack names actually use.
NAME_WORDS = {
    "grounded": {"realistic", "realism", "real", "natural", "physical", "debris", "rubble", "dirt", "dust", "rock",
                 "rocks", "gravel", "embers", "ember", "campfire", "bonfire", "torch", "candle", "mist", "fog", "steam",
                 "ash", "soot", "cinematic"},
    "stylized": {"stylized", "stylised", "toon", "toony", "cartoon", "cel", "simple", "clean", "lowpoly", "flat",
                 "zelda", "genshin", "simulator"},
    "anime": {"anime", "amine", "anine", "battleground", "battlegrounds", "jjk", "sukuna", "gojo", "yuji", "mahito",
              "nanami", "hakari", "aizen", "bankai", "vergil", "wukong", "tatsumaki", "goro", "monarch", "domain",
              "cursed", "awakening", "awakened", "ultimate", "ssj", "kaioken", "jajanken", "zoltraak", "suplex",
              "combo", "barrage", "ranked", "punisher", "goliath", "samurai", "slayer", "breathing", "soul",
              "transformation", "gezzu", "bloody", "overdrive", "excalibur", "kj", "tsb"},
    "cute": {"cute", "kawaii", "heart", "hearts", "love", "pink", "pastel", "candy", "sweet", "bubble", "bubbles",
             "flower", "flowers", "petal", "petals", "confetti", "sparkle", "sparkles", "twinkle", "rainbow", "paw",
             "mochi", "cinnamon", "christmas", "christmaswowwowow", "snowflake"},
    "scifi": {"scifi", "tech", "cyber", "laser", "lasers", "plasma", "hologram", "holo", "digital", "glitch", "neon",
              "hex", "hexagon", "grid", "circuit", "shield", "barrier", "forcefield", "energy", "atomic", "nuke",
              "reactor", "robot", "mech", "pulse", "ion", "quantum", "matter", "galactic", "bullet", "cannon"},
}


# library-wide layer shares (measured on this catalogue) and how many pseudo-layers of them every effect gets, so a
# one-layer effect does not score 100% of anything
PRIOR = {"add": 0.45, "hot": 0.13, "flash": 0.045, "dark": 0.12, "lit": 0.08, "smoke": 0.15, "streak": 0.33, "sat": 0.45,
         "pink": 0.04, "cyan": 0.12, "warm": 0.35}
SHRINK = 4


def words(s):
    s = re.sub(r"([a-z])([A-Z])", r"\1 \2", s or "")
    return re.findall(r"[a-z]{2,}", s.lower())


def num_max(s):
    xs = [float(x) for x in re.findall(r"-?\d+(?:\.\d+)?", str(s or ""))]
    return max([abs(x) for x in xs] or [0.0])


def rng_max(v):
    if isinstance(v, (list, tuple)):
        return max([abs(float(x)) for x in v if isinstance(x, (int, float))] or [0.0])
    try:
        return abs(float(v or 0))
    except (TypeError, ValueError):
        return 0.0


def rng_mid(v):
    if isinstance(v, (list, tuple)):
        xs = [abs(float(x)) for x in v if isinstance(x, (int, float))]
        return sum(xs) / len(xs) if xs else 0.0
    return rng_max(v)


def travel(l):
    # a typical particle (mid speed, mid lifetime), not the fastest: the fastest ones are thin and fade early
    v, t, d = rng_mid(l.get("speed")), rng_mid(l.get("life")), rng_max(l.get("drag"))
    t = min(t, 6.0)
    dist = v * (1 - 2 ** (-d * t)) / (d * math.log(2)) if d > 1e-3 else v * t
    a = l.get("acc")
    am = math.sqrt(sum(float(x) ** 2 for x in a)) if isinstance(a, (list, tuple)) and a else rng_max(a)
    return dist + 0.5 * am * t * t


def hsv(hexs):
    try:
        h = hexs.lstrip("#")
        r, g, b = (int(h[i:i + 2], 16) / 255 for i in (0, 2, 4))
        return colorsys.rgb_to_hsv(r, g, b)
    except (ValueError, AttributeError, IndexError):
        return (0.0, 0.0, 1.0)


def features(e, traits):
    L = e.get("layers") or []
    n = max(1, len(L))
    f = {k: 0.0 for k in ("add", "hot", "flash", "dark", "lit", "smoke", "streak", "sat", "pink", "cyan", "warm")}
    for l in L:
        le, li, br = float(l.get("LE") or 0), float(l.get("LI") or 0), float(l.get("Br") or 1)
        h, s, v = hsv((l.get("col") or ["#FFFFFF"])[0])
        f["add"] += le >= 0.7
        f["hot"] += br >= 20
        f["flash"] += br >= 50
        f["dark"] += (le <= 0.2 and v < 0.45) or le < 0
        f["lit"] += li >= 0.3
        f["smoke"] += le <= 0.3 and l.get("flip") not in (None, "None") and l["k"] == "emitter"
        f["streak"] += l.get("orient") == "VelocityParallel" or l["k"] in ("beam", "trail")
        f["sat"] += s if v > 0.2 else 0
        if s > 0.25 and v > 0.3:
            deg = h * 360
            f["pink"] += 285 <= deg <= 345
            f["cyan"] += 165 <= deg <= 205
            f["warm"] += deg <= 50 or deg >= 345
    for k in f:
        f[k] = (f[k] + SHRINK * PRIOR.get(k, 0.1)) / (len(L) + SHRINK)  # few-layer effects lean to the library mean
    f["n"] = len(L)
    parts = e.get("parts") or []
    mats = [p.get("mat") for p in parts if (p.get("transp") or 0) < 1]
    f["energyMat"] = sum(m in ("Neon", "ForceField", "Glass") for m in mats) / max(1, len(mats)) if mats else 0
    f["natMat"] = sum(m in ("Slate", "Granite", "Concrete", "Sand", "Wood", "Grass", "Rock", "Basalt", "Ground",
                            "Pebble", "Cobblestone", "Mud", "Brick") for m in mats) / max(1, len(mats)) if mats else 0
    tx = [traits.get(str(t)) for t in (e.get("textures") or []) if traits.get(str(t))]
    f["faint"] = sum(t.get("bg") == "faint" for t in tx) / len(tx) if tx else 0
    f["multi"] = sum("multi" in str(t.get("colour")) for t in tx) / len(tx) if tx else 0
    text = words(os.path.basename(e["file"])) + words(e.get("path")) + [w for l in L for w in words(l.get("name"))] + \
        [w for p in parts for w in words(p.get("name"))]
    ws = set(text)
    f["names"] = {st: 2.0 * len(ws & STYLE_WORDS[st]) + 0.6 * len(ws & (NAME_WORDS[st] - STYLE_WORDS[st]))
                  for st in STYLES}
    return f


def raw_scores(f):
    nm = {k: min(4.0, v) for k, v in f["names"].items()}
    big = math.log(1 + f["n"])
    other = {st: sum(v for k, v in nm.items() if k != st) for st in STYLES}  # named as another style: lean away
    r = {
        # grounded: soft lit volume, dark partners, few hot flashes, natural materials, low saturation
        "grounded": 2.2 * f["smoke"] + 0.8 * f["lit"] + 1.2 * f["dark"] + 1.5 * f["natMat"] + 0.8 * f["faint"]
        - 2.2 * f["flash"] - 1.0 * f["hot"] - 0.8 * f["sat"] - 0.6 * f["add"] + 1.2 * nm["grounded"],
        # stylized: clean, moderate layer counts, saturated non-additive shapes, few flashes
        "stylized": 1.0 * f["sat"] * (1 - f["add"]) + 0.8 * (1 - f["flash"]) - 0.25 * abs(big - 2.3)
        - 0.6 * f["faint"] + 1.6 * nm["stylized"],
        # anime / battlegrounds: hot additive stacks, flashes, streaks, many layers, series names
        "anime": 1.5 * f["hot"] + 1.2 * f["flash"] + 0.8 * f["add"] + 0.8 * f["streak"] + 0.35 * big
        + 0.9 * nm["anime"],
        # cute / cosy: pink and multicolour, sparkle words, low heat, small effects
        "cute": 2.5 * f["pink"] + 1.2 * f["multi"] - 1.2 * f["flash"] - 0.2 * big - 0.8 * f["dark"]
        + 1.3 * nm["cute"],
        # sci-fi: cyan energy, Neon/ForceField/Glass parts, beams, tech words, little smoke
        "scifi": 2.0 * f["cyan"] + 1.2 * f["energyMat"] + 0.6 * f["streak"] - 0.8 * f["smoke"] - 0.6 * f["warm"]
        + 1.3 * nm["scifi"],
    }
    return {st: v - 0.45 * other[st] for st, v in r.items()}


def percentiles(vals):
    s = sorted(vals)
    n = max(1, len(s) - 1)
    return [bisect.bisect_left(s, v) / n for v in vals]


def size_est(e):
    reach, largest = [], (0.0, "")
    for l in e.get("layers") or []:
        if l["k"] == "emitter":
            sz = num_max(l.get("size"))
            r = travel(l) + sz / 2
            if sz > largest[0]:
                largest = (sz, l.get("name") or "emitter")
        elif l["k"] == "beam":
            sz = rng_max(l.get("w"))
            r = sz / 2
            if sz > largest[0]:
                largest = (sz, l.get("name") or "beam")
        else:
            r = rng_max(l.get("width")) / 2
        reach.append(r)
    for p in e.get("parts") or []:
        if (p.get("transp") or 0) >= 1 or not p.get("size"):
            continue
        sz = max(float(x) for x in p["size"])
        if (p.get("name") or "").lower() in ("humanoidrootpart", "torso", "head", "right arm", "left arm", "right leg",
                                              "left leg", "uppertorso", "lowertorso"):
            continue
        reach.append(sz / 2)
        if sz > largest[0]:
            largest = (sz, p.get("name") or "part")
    if not reach:
        return None
    reach.sort()
    p75 = reach[min(len(reach) - 1, int(len(reach) * 0.75))]
    return {"extent": round(2 * p75, 1), "largest": round(largest[0], 1), "largestName": largest[1][:24]}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    a = ap.parse_args()
    eff = [json.loads(l) for l in gzip.open(os.path.join(ROOT, "catalog", "effects.jsonl.gz"), "rt", encoding="utf-8")]
    tp = os.path.join(ROOT, "gallery", "textures", "traits.json")
    traits = json.load(open(tp)) if os.path.exists(tp) else {}
    feats = [features(e, traits) for e in eff]
    raws = [raw_scores(f) for f in feats]
    # texture families: mean raw (percentile) style of the effects using a texture
    pct0 = {st: percentiles([r[st] for r in raws]) for st in STYLES}
    fam = {}
    for i, e in enumerate(eff):
        for t in set(e.get("textures") or []):
            d = fam.setdefault(str(t), {st: [0.0, 0] for st in STYLES})
            for st in STYLES:
                d[st][0] += pct0[st][i]
                d[st][1] += 1
    blended = []
    for i, e in enumerate(eff):
        ts = [fam[str(t)] for t in set(e.get("textures") or []) if fam.get(str(t), {}).get("grounded", [0, 0])[1] > 1]
        row = {}
        for st in STYLES:
            own = pct0[st][i]
            if ts:
                famv = sum(d[st][0] / d[st][1] for d in ts) / len(ts)
                row[st] = 0.7 * own + 0.3 * famv
            else:
                row[st] = own
        blended.append(row)
    pct = {st: percentiles([b[st] for b in blended]) for st in STYLES}
    out = {"_about": {"made_by": "kit/scripts/build_style_index.py (signals in its docstring)", "count": len(eff),
                      "styles": list(STYLES)}}
    for i, e in enumerate(eff):
        sc = {st: round(pct[st][i], 3) for st in STYLES}
        top = max(sc, key=sc.get)
        rec = {"style": sc, "top": top}
        z = size_est(e)
        if z:
            rec["size"] = z
        out[e["id"]] = rec
    with gzip.open(os.path.join(ROOT, "catalog", "traits.json.gz"), "wt", encoding="utf-8") as fh:
        json.dump(out, fh, separators=(",", ":"))
    tops = {}
    for k, v in out.items():
        if k != "_about":
            tops[v["top"]] = tops.get(v["top"], 0) + 1
    print("wrote catalog/traits.json.gz: %d effects; top style counts %s" % (len(eff), tops))
    if a.check:
        byid = {e["id"]: e for e in eff}
        for st in STYLES:
            best = sorted((v["style"][st], k) for k, v in out.items() if k != "_about")[-8:][::-1]
            print("\n== most %s" % st)
            for s, k in best:
                e = byid[k]
                print("  %.2f %s %s :: %s" % (s, k, os.path.basename(e["file"])[:40], e["path"][-40:]))


if __name__ == "__main__":
    main()
