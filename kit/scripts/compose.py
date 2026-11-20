#!/usr/bin/env python3
"""Composition finder: the professional open-source effects that best match a request, with their layer tables and
an optional way to load one into Studio to look at it.

    python3 -I kit/scripts/compose.py "frost nova that bursts from the ground"      top 3 per part of the request
    python3 -I kit/scripts/compose.py "..." -k 5 [--lines 18]                         more candidates / layer lines
    python3 -I kit/scripts/compose.py --show <id>                                     one effect's full layer table
    python3 -I kit/scripts/compose.py --cut <id> [<id> ...]                           write fx_<id>.rbxmx into Studio's
                                                                                      content folder (scripts removed)
    python3 -I kit/scripts/compose.py --swap <texture id> [-k 8]                      other pro textures used in the same
                                                                                      role (layer names, kind, flipbook)
    python3 -I kit/scripts/compose.py "..." --style grounded|stylized|anime|cute|scifi|any   force / turn off the style
    python3 -I kit/scripts/compose.py "..." --size 12                                 the brief's main size in studs:
                                                                                      prints a starting scale per piece
    python3 -I kit/scripts/compose.py --meshes "rock stone" [--style grounded]        pro meshes for a role (when a
                                                                                      piece's own mesh is weak or missing)

A request is split into parts ("a projectile that explodes on impact" -> projectile, impact) and every part gets its
own candidates, so a build can combine a pro projectile with a pro impact. Ranking = word match (file, path, tags,
layer names, with VFX synonyms) + a small prior for effects that replay well (EmitCount-driven layers, a sane layer
count), then x (0.5 + style fit) when the request names a style register (or --style): fit is the effect's
percentile for that style in catalog/traits.json.gz (build_style_index.py documents the signals), so a "realistic"
request gets the most grounded matches of the right type instead of the battlegrounds majority. Every candidate also
shows its estimated size (studs and character heights H = 5 studs) and, with --size, the starting scale. No quality
ratings exist yet.

Index: catalog/compose.jsonl.gz (built by build_compose_index.py; effects from files that are not open source are not
in it). Cutting needs the effect files: the open-source pack (get_pack.py --where), or for a few loose files the
maintainer library (env VFXMITH_LIBRARY, or a raw/ folder 1-3 levels above this plugin folder). Library files are untrusted data:
rbxcut reads them as bytes and writes only the effect's own instances, never a script.
"""
import argparse
import gzip
import json
import math
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, HERE)
from find_effects import SYN, STOP, parts as split_parts  # noqa: E402

# extra vocabulary for request words that the library names differently
MORE = {
    "nova": ["nova", "burst", "explosion", "shockwave", "blast"], "smite": ["smite", "holy", "strike", "pillar", "beam"],
    "claw": ["claw", "slash", "scratch", "swipe"], "shield": ["shield", "barrier", "bubble", "dome"],
    "heal": ["heal", "healing", "regen", "aura"], "buff": ["buff", "aura", "charge", "power"],
    "summon": ["summon", "circle", "sigil", "portal"], "dash": ["dash", "speed", "afterimage", "rush"],
    "punch": ["punch", "fist", "hit", "impact"], "kick": ["kick", "stomp", "impact"],
    "orb": ["orb", "ball", "sphere", "projectile"], "spark": ["spark", "sparkle", "star", "glint"],
    "rune": ["rune", "sigil", "circle", "magic"], "pillar": ["pillar", "beam", "column"],
    "flash": ["flash", "glint", "burst"], "poison": ["poison", "toxic", "acid", "green"],
}
# style register of a request: explicit words first (weight 2), leaning words (weight 1). (signals in build_style_index.py).
STYLE_QUERY = {
    "grounded": ({"realistic", "realism", "grounded", "photoreal", "photorealistic", "natural", "believable", "real",
                  "physical", "cinematic", "gritty", "lifelike", "naturalistic", "subtle"},
                 {"campfire", "bonfire", "candle", "torch", "dust", "debris", "rubble", "mist", "fog", "steam", "smoke",
                  "embers", "ash", "rain", "mud", "dirt", "gravel", "landslide", "bushfire", "wildfire"}),
    "stylized": ({"stylized", "stylised", "cartoon", "cartoony", "toon", "cel", "clean", "simulator", "lowpoly",
                  "flat", "simple", "readable"}, {"zelda", "genshin", "fortnite", "tycoon"}),
    "anime": ({"anime", "battlegrounds", "battleground", "manga", "shonen", "jjk", "tsb"},
              {"ultimate", "awakening", "domain", "cursed", "combo", "barrage", "aura", "kamehameha", "bankai",
               "sword", "beam", "slash"}),
    "cute": ({"cute", "cosy", "cozy", "kawaii", "adorable", "wholesome", "pastel", "sweet", "bubbly", "chibi"},
             {"heart", "hearts", "love", "candy", "flower", "flowers", "petals", "confetti", "bubble", "bubbles",
              "sparkle", "sparkles", "pet", "bunny", "kitten"}),
    "scifi": ({"scifi", "futuristic", "cyber", "cyberpunk", "hologram", "holographic", "tech", "techy", "digital",
               "robotic", "mech"},
              {"laser", "plasma", "shield", "forcefield", "energy", "hex", "hexagon", "neon", "glitch", "ion",
               "pulse", "reactor", "drone", "robot", "railgun"}),
}
STYLE_ONLY = set().union(*(a for a, _ in STYLE_QUERY.values())) | {"style", "styled", "looking", "look"}
H = 5.0  # studs per character height (R15)

ROLE_WORDS = {"aura": "on a character: load with on = \"dummy\" (rig parts are mapped onto the dummy)",
              "buff": "on a character", "heal": "on a character", "charge": "on a character"}


def lib_dirs():
    env = os.environ.get("VFXMITH_LIBRARY")
    cands = [env] if env else []
    cands += [os.path.join(ROOT, *[".."] * n, "raw") for n in (1, 2, 3)]  # plugin next to / inside the library
    return [os.path.abspath(c) for c in cands if c and os.path.isdir(c)]


def load_traits():
    p = os.path.join(ROOT, "catalog", "traits.json.gz")
    if not os.path.exists(p):
        return {}
    with gzip.open(p, "rt", encoding="utf-8") as fh:
        return json.load(fh)


def norm_query(q):
    q = q.lower()
    q = re.sub(r"\bsci[\s-]?fi\b", "scifi", q)
    q = re.sub(r"\bbattle[\s-]?grounds?\b", "battlegrounds", q)
    q = re.sub(r"\blow[\s-]?poly\b", "lowpoly", q)
    q = re.sub(r"\bphoto[\s-]?real(istic)?\b", "photoreal", q)
    return q


def detect_style(query):
    """(style, words that decided it) or (None, []) when the request names no style register."""
    ws = set(re.findall(r"[a-z]+", norm_query(query)))
    best, why = None, []
    top = 0.0
    for st, (strong, lean) in STYLE_QUERY.items():
        hit_s, hit_l = sorted(ws & strong), sorted(ws & lean)
        v = 2.0 * len(hit_s) + 1.0 * len(hit_l)
        # leaning words alone decide only with 2 or more of them, and never anime / stylized (their leaning words,
        # sword or beam, are common to every style); one explicit word always decides
        if not hit_s and (st in ("anime", "stylized") or len(hit_l) < 2):
            v = 0
        if v > top:
            best, why, top = st, hit_s + hit_l, v
    return best, why


def style_note(tr, style):
    if not tr:
        return "style ?"
    sc = tr["style"]
    txt = "style: top %s" % tr["top"]
    if style:
        txt += ", %s fit %.2f" % (style, sc.get(style, 0.5))
    return txt


def size_note(tr, want):
    z = tr.get("size") if tr else None
    if not z:
        return None
    t = "size est: extent ~%.0f studs (%.1f H), largest layer %.0f studs (%s)" % (
        z["extent"], z["extent"] / H, z["largest"], z["largestName"])
    if want:
        # fit the extent to the brief's size; a single layer over 1.5x the brief swamps the shot (alpha1 meteor)
        sc = want / max(0.5, z["extent"])
        t += " -> start scale %.2f for %s studs" % (sc, want)
        if z["largest"] * sc > 1.5 * want:
            t += "; largest layer would still be %.0f studs: shrink or drop '%s'" % (z["largest"] * sc, z["largestName"])
    t += " (rough estimate)"
    return t


def load_index():
    p = os.path.join(ROOT, "catalog", "compose.jsonl.gz")
    if not os.path.exists(p):
        sys.exit("catalog/compose.jsonl.gz missing (maintainer: build_compose_index.py)")
    with gzip.open(p, "rt", encoding="utf-8") as fh:
        return [json.loads(l) for l in fh]


def expand(word):
    w = word.lower()
    for table in (MORE, SYN):
        for k, vs in table.items():
            if w == k or w in vs or any(len(v) > 3 and w.startswith(v) for v in vs):
                return k, set(vs) | {k, w}
    return w, {w}


def score(rec, terms, tok):
    s = 0.0
    for key, ws in terms:
        best = 0.0
        for w in ws:
            c = tok.get(w, 0) or sum(v for t, v in tok.items() if len(w) > 3 and t.startswith(w))
            if c:
                best = max(best, (2.0 if w == key else 1.4) * (1 + math.log(1 + c)))
        s += best
    if s == 0:
        return 0
    L = rec["layers"]
    s += 0.8 if 6 <= L <= 120 else (0.2 if L >= 3 else -1.0)
    s += 0.8 * min(1.0, rec["emitDriven"] / max(1, L))  # replays exactly from its own EmitCount/EmitDelay attributes
    if L > 300:
        s -= 1.0
    return s


def tokens(rec):
    d = {}
    for w in rec["text"].split():
        d[w] = d.get(w, 0) + 1
    return d


def show(rec, lines, tr=None, style=None, want=None):
    n = rec["n"]
    tag = ",".join(rec["tags"]) or "-"
    print("  [%s] %s :: %s" % (rec["id"], os.path.basename(rec["file"]), rec["path"][-70:]))
    print("      %d emitters, %d beams, %d trails, %d parts (%d mesh), %d lights | est %ss | %d/%d layers EmitCount-driven"
          " | rig parts: %d | tags %s" % (n.get("emitters", 0), n.get("beams", 0), n.get("trails", 0), n.get("parts", 0),
                                          rec["meshes"], n.get("lights", 0), rec["len"], rec["emitDriven"], rec["layers"],
                                          rec["rig"], tag))
    print("      %s" % style_note(tr, style))
    zn = size_note(tr, want)
    if zn:
        print("      " + zn)
    for c in ("gallery/effects/%s/%s.jpg",):
        for cat in os.listdir(os.path.join(ROOT, "gallery", "effects")) if os.path.isdir(os.path.join(ROOT, "gallery", "effects")) else []:
            p = os.path.join(ROOT, c % (cat, rec["id"]))
            if os.path.exists(p):
                print("      frames already captured: " + os.path.relpath(p, ROOT))
    tab = rec["table"]
    for l in tab[:lines]:
        print("        " + l[:230])
    more = len(tab) - lines + rec.get("tableMore", 0)
    if more > 0:
        print("        ... %d more lines: compose.py --show %s" % (more, rec["id"]))


def find(recs, query, k, lines, style_arg=None, want=None):
    print("Library: %d open-source pro effects. These are references: how artists layered this kind of effect. "
          "Optional; nothing needs loading or copying.\n" % len(recs))
    traits = load_traits()
    if style_arg == "any":
        style, why = None, []
    elif style_arg:
        style, why = style_arg, ["--style"]
    else:
        style, why = detect_style(query)
    if style:
        print("Style register: %s (from: %s). Ranking = type match x (0.5 + %s fit)." %
              (style, ", ".join(why), style))
    else:
        print("Style register: none named (ranking by type only; the library leans battlegrounds/anime). If the brief "
              "has a style, pass --style.")
    if not traits:
        print("  (catalog/traits.json.gz missing: no style or size data; maintainer: build_style_index.py)")
    print()
    toks = [tokens(r) for r in recs]
    ps = [[w for w in p if w not in STYLE_ONLY] for p in split_parts(norm_query(query))]
    ps = [p for p in ps if p]
    if len(ps) > 1:
        ps = ps + [[w for p in ps for w in p]]  # also the request as a whole (one effect may cover everything)
    for words in ps:
        terms = [expand(w) for w in words if w not in STOP]
        if not terms:
            continue
        def total(r, t):
            s0 = score(r, terms, t)
            if style and s0 > 0:
                tr = traits.get(r["id"])
                s0 *= 0.5 + (tr["style"].get(style, 0.5) if tr else 0.5)
            return s0
        ranked = sorted(((total(r, t), i) for i, (r, t) in enumerate(zip(recs, toks))), reverse=True)
        print('=== part: "%s"' % " ".join(words))
        hints = {ROLE_WORDS[k] for k, _ in terms if k in ROLE_WORDS}
        for h in hints:
            print("    note: " + h)
        shown, files = 0, set()
        for s, i in ranked:
            if s <= 0 or shown >= k:
                break
            r = recs[i]
            if r["file"] in files:  # one candidate per source file: variants of one pack are near-copies
                continue
            files.add(r["file"])
            shown += 1
            print("  #%d  score %.1f" % (shown, s))
            show(r, lines, traits.get(r["id"]), style, want)
        if not shown:
            print("  (no match: try other words for this part, e.g. the element or the shape)")
        print()
    print("More: --show <id> for a full layer table. To see one in Studio (optional, needs the pack): --cut <id>.")


def cut(recs, ids):
    sys.path.insert(0, HERE)
    import get_pack
    from rbx_assets import content_dir
    import rbxcut
    by = {r["id"]: r for r in recs}
    pack = get_pack.find_pack()
    dest = os.path.join(content_dir(), "vfxlib")
    os.makedirs(dest, exist_ok=True)
    for eid in ids:
        r = by.get(eid)
        if not r:
            print("no effect", eid)
            continue
        src = None
        for d in ([pack] if pack else []) + lib_dirs():
            p = os.path.join(d, r["file"])
            if os.path.exists(p):
                src = p
                break
        if not src:
            print("%s: file not found (%s). Get the pack: python3 kit/scripts/get_pack.py" % (eid, r["file"]))
            continue
        xml, n, dropped = rbxcut.cut(src, r["ref"], None)
        out = os.path.join(dest, "fx_%s.rbxmx" % eid)
        open(out, "w").write(xml)
        print("%s: %d instances, %d scripts dropped -> %s" % (eid, n, dropped, out))
        print('    Studio: game:GetObjects("rbxasset://vfxlib/fx_%s.rbxmx")[1]' % eid)


def swap(tex, k):
    with gzip.open(os.path.join(ROOT, "catalog", "texture_roles.json.gz"), "rt") as f:
        roles = json.load(f)
    me = roles.get(str(tex))
    if not me:
        sys.exit("texture %s is not used by any indexed effect" % tex)
    mine = {n for n, _ in me["names"]}
    mk = max(me["kinds"], key=me["kinds"].get)
    mf = me["flip"][0][0] if me["flip"] else None
    print("texture %s: names %s, kinds %s, flipbook %s, LightEmission %s, in %d effects" %
          (tex, me["names"], me["kinds"], me["flip"], me["LE"], me["effects"]))
    out = []
    for t, r in roles.items():
        if t == str(tex) or mk not in r["kinds"]:
            continue
        rf = r["flip"][0][0] if r["flip"] else None
        if rf != mf:
            continue  # a flipbook needs the same grid, a still the same no-grid
        ov = sum(c for n, c in r["names"] if n in mine)
        if ov:
            out.append((ov * math.log(1 + r["effects"]), t, r))
    out.sort(reverse=True)
    print("same-role pro textures (same kind and flipbook grid, shared layer names):")
    for s, t, r in out[:k]:
        print("  %s  in %d effects  names %s  LE %s" % (t, r["effects"], r["names"][:4], r["LE"]))
    if not out:
        print("  none: keep the original texture")


def meshes(query, k, style_arg):
    """Pro meshes whose part or effect names match a role ("rock stone"): grouped by mesh id, ranked by how many
    effects reuse them (pros reuse the good ones) x style fit. Use when a chosen piece's own mesh looks weak."""
    ok = {r["id"] for r in load_index()}  # only effects compose.py can cut (open-source files)
    eff = [json.loads(l) for l in gzip.open(os.path.join(ROOT, "catalog", "effects.jsonl.gz"), "rt", encoding="utf-8")]
    eff = [e for e in eff if e["id"] in ok]
    traits = load_traits()
    style = None if style_arg in (None, "any") else style_arg
    terms = [expand(w) for w in re.findall(r"[a-z]+", norm_query(query)) if w not in STOP and w not in STYLE_ONLY]
    groups = {}
    for e in eff:
        for p in e.get("parts") or []:
            mid = p.get("mesh")
            if not mid:
                continue
            nm = " ".join(re.findall(r"[a-z]{2,}", re.sub(r"([a-z])([A-Z])", r"\1 \2", p.get("name") or "").lower()))
            ctx = nm + " " + " ".join(re.findall(r"[a-z]{2,}", (e["path"] + " " + os.path.basename(e["file"])).lower()))
            hit = sum(1 for key, ws in terms if any(w in nm.split() for w in ws)) * 2 + \
                sum(1 for key, ws in terms if any(w in ctx.split() for w in ws))
            if not hit:
                continue
            g = groups.setdefault(mid, {"hit": 0, "effects": set(), "names": {}, "mats": {}, "size": p.get("size"),
                                        "tex": p.get("meshTex")})
            g["hit"] = max(g["hit"], hit)
            g["effects"].add(e["id"])
            g["names"][p.get("name")] = g["names"].get(p.get("name"), 0) + 1
            g["mats"][p.get("mat")] = g["mats"].get(p.get("mat"), 0) + 1
    out = []
    for mid, g in groups.items():
        fit = 0.5
        if style:
            fs = [traits[i]["style"].get(style, 0.5) for i in g["effects"] if i in traits]
            fit = sum(fs) / len(fs) if fs else 0.5
        out.append((g["hit"] * (1 + math.log(len(g["effects"]))) * (0.5 + fit), mid, g, fit))
    out.sort(key=lambda x: -x[0])
    print("Pro meshes for '%s'%s (reuse across effects = the closest thing to a rating the library has):" %
          (query, " , style " + style if style else ""))
    for s, mid, g, fit in out[:k]:
        names = ", ".join(n for n, _ in sorted(g["names"].items(), key=lambda x: -x[1])[:3])
        mats = ", ".join(str(m) for m, _ in sorted(g["mats"].items(), key=lambda x: -x[1])[:2])
        ex = sorted(g["effects"])[:3]
        print("  mesh %s  in %d effects  names %s  mat %s  size %s%s" % (mid, len(g["effects"]), names, mats, g["size"],
                                                                       "  fit %.2f" % fit if style else ""))
        print("      carried by effect(s) %s: cut one and drop its other layers, or use it as a second piece" %
              " ".join(ex))
    if not out:
        print("  none: keep the piece's own mesh and say in the notes that the library has no better one")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("query", nargs="?")
    ap.add_argument("-k", type=int, default=3)
    ap.add_argument("--lines", type=int, default=16)
    ap.add_argument("--show")
    ap.add_argument("--cut", nargs="+")
    ap.add_argument("--swap")
    ap.add_argument("--style", choices=["grounded", "stylized", "anime", "cute", "scifi", "any"])
    ap.add_argument("--size", type=float, help="the brief's main size in studs (diameter / length)")
    ap.add_argument("--meshes", help="role words for pro meshes, e.g. \"rock stone\"")
    a = ap.parse_args()
    if a.meshes:
        return meshes(a.meshes, max(a.k, 6), a.style)
    if a.swap:
        return swap(a.swap, max(a.k, 8))
    recs = load_index()
    if a.show:
        r = next((r for r in recs if r["id"] == a.show), None)
        if not r:
            sys.exit("no effect " + a.show)
        show(r, 10 ** 6, load_traits().get(r["id"]), a.style if a.style != "any" else None, a.size)
        for p in r.get("parts", []):
            print("        P " + p)
        return
    if a.cut:
        return cut(recs, a.cut)
    if not a.query:
        ap.error("give a request, --show, --cut or --swap")
    find(recs, a.query, a.k, a.lines, a.style, a.size)


if __name__ == "__main__":
    main()
