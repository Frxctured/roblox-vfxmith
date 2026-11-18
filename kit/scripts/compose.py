#!/usr/bin/env python3
"""Composition finder: the professional open-source effects that best match a request, with their layer tables and
a ready way to load each one into Studio as the starting point of a build.

    python3 -I kit/scripts/compose.py "frost nova that bursts from the ground"      top 3 per part of the request
    python3 -I kit/scripts/compose.py "..." -k 5 [--lines 18]                         more candidates / layer lines
    python3 -I kit/scripts/compose.py --show <id>                                     one effect's full layer table
    python3 -I kit/scripts/compose.py --cut <id> [<id> ...]                           write fx_<id>.rbxmx into Studio's
                                                                                      content folder (scripts removed)
    python3 -I kit/scripts/compose.py --swap <texture id> [-k 8]                      other pro textures used in the same
                                                                                      role (layer names, kind, flipbook)

A request is split into parts ("a projectile that explodes on impact" -> projectile, impact) and every part gets its
own candidates, so a build can combine a pro projectile with a pro impact. Ranking = word match (file, path, tags,
layer names, with VFX synonyms) + a small prior for effects that replay well (EmitCount-driven layers, a sane layer
count). No quality ratings exist yet: LOOK at the candidates in Studio before choosing (START.md step 3).

Index: catalog/compose.jsonl.gz (built by build_compose_index.py; effects from files that are not open source are not
in it). Cutting needs the effect files: the open-source pack (get_pack.py --where), or for a few loose files the
maintainer library (env VFXMITH_LIBRARY or ../../raw next to this plugin folder). Library files are untrusted data:
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
ROLE_WORDS = {"aura": "on a character: load with on = \"dummy\" (rig parts are mapped onto the dummy)",
              "buff": "on a character", "heal": "on a character", "charge": "on a character"}


def lib_dirs():
    env = os.environ.get("VFXMITH_LIBRARY")
    cands = [env] if env else []
    cands += [os.path.join(ROOT, "..", "..", "raw"), os.path.join(ROOT, "..", "raw")]
    return [os.path.abspath(c) for c in cands if c and os.path.isdir(c)]


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


def show(rec, lines):
    n = rec["n"]
    tag = ",".join(rec["tags"]) or "-"
    print("  [%s] %s :: %s" % (rec["id"], os.path.basename(rec["file"]), rec["path"][-70:]))
    print("      %d emitters, %d beams, %d trails, %d parts (%d mesh), %d lights | est %ss | %d/%d layers EmitCount-driven"
          " | rig parts: %d | tags %s" % (n.get("emitters", 0), n.get("beams", 0), n.get("trails", 0), n.get("parts", 0),
                                          rec["meshes"], n.get("lights", 0), rec["len"], rec["emitDriven"], rec["layers"],
                                          rec["rig"], tag))
    print("      load: python3 -I kit/scripts/compose.py --cut %s   then piece file = \"fx_%s\"" % (rec["id"], rec["id"]))
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


def find(recs, query, k, lines):
    print("Library: %d open-source pro effects. Candidates are starting points to LOAD AND LOOK AT, not to copy blindly.\n"
          % len(recs))
    toks = [tokens(r) for r in recs]
    ps = split_parts(query)
    if len(ps) > 1:
        ps = ps + [[w for p in ps for w in p]]  # also the request as a whole (one effect may cover everything)
    for words in ps:
        terms = [expand(w) for w in words if w not in STOP]
        if not terms:
            continue
        ranked = sorted(((score(r, terms, t), i) for i, (r, t) in enumerate(zip(recs, toks))), reverse=True)
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
            show(r, lines)
        if not shown:
            print("  (no match: try other words for this part, e.g. the element or the shape)")
        print()
    print("Next: cut the 2-3 most promising, load each in Studio and capture 3 frames of it (START.md step 3).")


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
        print('    Studio: game:GetObjects("rbxasset://vfxlib/fx_%s.rbxmx")[1]   (VFXCompose piece file = "fx_%s")' % (eid, eid))


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


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("query", nargs="?")
    ap.add_argument("-k", type=int, default=3)
    ap.add_argument("--lines", type=int, default=16)
    ap.add_argument("--show")
    ap.add_argument("--cut", nargs="+")
    ap.add_argument("--swap")
    a = ap.parse_args()
    if a.swap:
        return swap(a.swap, max(a.k, 8))
    recs = load_index()
    if a.show:
        r = next((r for r in recs if r["id"] == a.show), None)
        if not r:
            sys.exit("no effect " + a.show)
        show(r, 10 ** 6)
        for p in r.get("parts", []):
            print("        P " + p)
        return
    if a.cut:
        return cut(recs, a.cut)
    if not a.query:
        ap.error("give a request, --show, --cut or --swap")
    find(recs, a.query, a.k, a.lines)


if __name__ == "__main__":
    main()
