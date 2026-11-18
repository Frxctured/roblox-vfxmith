#!/usr/bin/env python3
"""Maintainer tool: build the composition finder's index (catalog/compose.jsonl.gz + catalog/texture_roles.json.gz)
from the full library catalogue written by vfx_catalog.py.

    python3 -I kit/scripts/build_compose_index.py <library catalog dir with effects.jsonl> [--pack-md PACK.md]

Every effect becomes one compact record: where it lives (pack file + referent), counts, search text and its layer
table (one line per layer, identical layers merged as "xN"). Effects from files that PACK.md lists under "Left out"
(ripped from live games, not open source) are never indexed. Texture roles = for every texture, the layer names,
kinds, flipbook grids and LightEmission values pros used it with, so compose.py can offer same-role swaps.
Reads JSON only (never a Roblox file).
"""
import argparse
import collections
import gzip
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
sys.path.insert(0, HERE)
import layer_table  # noqa: E402

RIG = {"head", "torso", "uppertorso", "lowertorso", "humanoidrootpart", "right arm", "left arm", "right leg", "left leg",
       "rightupperarm", "leftupperarm", "rightupperleg", "leftupperleg", "righthand", "lefthand", "rightfoot", "leftfoot",
       "rightlowerarm", "leftlowerarm", "rightlowerleg", "leftlowerleg"}


def left_out(pack_md):
    out = set()
    if not os.path.exists(pack_md):
        return out
    sec = False
    for line in open(pack_md, encoding="utf-8"):
        if line.startswith("## "):
            sec = line.strip().lower() == "## left out"
            continue
        if sec and line.startswith("| ") and not line.startswith("| File") and not line.startswith("|---"):
            out.add(line.split("|")[1].strip())
    return out


def words(s):
    s = re.sub(r"([a-z])([A-Z])", r"\1 \2", s or "")
    return [w for w in re.findall(r"[a-z]{2,}", s.lower())]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("catalog")
    ap.add_argument("--pack-md", default=os.path.join(ROOT, "PACK.md"))
    ap.add_argument("--pack", help="pack folder (to mark which files it has)")
    a = ap.parse_args()
    bad = left_out(a.pack_md)
    if not bad:
        sys.exit("no 'Left out' list found in " + a.pack_md)
    if not a.pack:
        import get_pack
        a.pack = get_pack.find_pack()
    roles = collections.defaultdict(lambda: {"names": collections.Counter(), "kinds": collections.Counter(),
                                             "flip": collections.Counter(), "LE": collections.Counter(), "effects": 0})
    n_in = n_skip = 0
    out = gzip.open(os.path.join(ROOT, "catalog", "compose.jsonl.gz"), "wt", encoding="utf-8")
    for line in open(os.path.join(a.catalog, "effects.jsonl"), encoding="utf-8"):
        e = json.loads(line)
        if e["file"] in bad:
            n_skip += 1
            continue
        n_in += 1
        layers = e["layers"]
        lines = collections.OrderedDict()
        for l in sorted(layers, key=lambda l: (l.get("delay") or 0, l["k"] != "emitter")):
            t = layer_table.line(l, {})
            lines[t] = lines.get(t, 0) + 1
        table = [("x%d " % c if c > 1 else "") + t for t, c in lines.items()]
        names = collections.Counter(w for l in layers for w in words(l.get("name")))
        parts = e.get("parts") or []
        rig = sum(1 for p in parts if (p.get("name") or "").lower() in RIG)
        meshes = [p for p in parts if p.get("k") in ("MeshPart",) or p.get("mesh")]
        text = " ".join(words(os.path.basename(e["file"])) * 3 + words(e["path"]) * 3 + list(e["tags"]) * 2 +
                        [w for w, _ in names.most_common(40)] +
                        [w for p in parts[:40] for w in words(p.get("name"))])
        emit_driven = sum(1 for l in layers if l.get("emit") is not None)
        rec = {"id": e["id"], "file": e["file"], "ref": e["ref"], "path": e["path"], "root": e["root"],
               "tags": e["tags"], "n": e["n"], "len": e.get("lengthEst"), "emitDriven": emit_driven,
               "layers": len(layers), "rig": rig, "meshes": len(meshes),
               "inPack": bool(a.pack and os.path.exists(os.path.join(a.pack, e["file"]))),
               "text": text, "table": table[:80], "tableMore": max(0, len(table) - 80),
               "parts": [json.dumps(p, default=str)[:140] for p in parts[:12]]}
        out.write(json.dumps(rec, separators=(",", ":")) + "\n")
        seen = set()
        for l in layers:
            t = l.get("tex")
            if not t:
                continue
            r = roles[str(t)]
            r["names"].update(words(l.get("name"))[:3])
            r["kinds"][l["k"]] += 1
            if l.get("flip") not in (None, "None"):
                r["flip"][l["flip"]] += 1
            r["LE"][str(l.get("LE"))] += 1
            if t not in seen:
                r["effects"] += 1
                seen.add(t)
    out.close()
    slim = {t: {"names": r["names"].most_common(6), "kinds": dict(r["kinds"]), "flip": r["flip"].most_common(2),
                "LE": r["LE"].most_common(2), "effects": r["effects"]} for t, r in roles.items()}
    with gzip.open(os.path.join(ROOT, "catalog", "texture_roles.json.gz"), "wt", encoding="utf-8") as f:
        json.dump(slim, f, separators=(",", ":"))
    print("indexed", n_in, "effects; skipped", n_skip, "from left-out files;", len(slim), "textures")


if __name__ == "__main__":
    main()
