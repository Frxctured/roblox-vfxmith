#!/usr/bin/env python3
"""Catalogue a folder of open-source Roblox VFX (.rbxm/.rbxl/.rbxmx) without Studio.

    python3 -I vfx_catalog.py <raw dir> <out dir>

Splits every file into EFFECTS (the largest Model/Folder/Part/Attachment subtree with <= 160 particle/beam/trail
layers), describes each layer compactly (texture, colour ramp, light mode, size/transparency curve shape, motion,
flipbook, emit timing from EmitCount/EmitDelay/EmitDuration attributes), dedupes identical effects across files and
writes:
  <out>/effects.jsonl      one effect per line (file, path, tags, counts, length, layers, meshes, scripts)
  <out>/textures.json      texture id -> uses (effects, files, layer names, light mode, flipbook)
  <out>/stats.json         distributions over unique emitter designs (what values experienced artists pick)
  <out>/files.json         per file: effects, script count, warnings (suspicious scripts)
Scripts are never run; only their names and a few flags (TweenService, :Emit, attributes, delays) are kept.
"""
import collections
import hashlib
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import rbxdump as rd  # noqa: E402

VFX = {"ParticleEmitter", "Beam", "Trail"}
CONTAINERS = {"Model", "Folder", "Part", "MeshPart", "Attachment", "UnionOperation", "WedgePart", "Configuration",
              "Tool", "Accessory", "Bone", "SpawnLocation", "CornerWedgePart", "TrussPart"}
SCRIPTS = {"Script", "LocalScript", "ModuleScript"}
MAX_LAYERS = 160

ORIENT = ["FacingCamera", "FacingCameraWorldUp", "VelocityParallel", "VelocityPerpendicular"]
SHAPE = ["Box", "Sphere", "Cylinder", "Disc"]
INOUT = ["Outward", "Inward", "InAndOut"]
FLIP = ["None", "Grid2x2", "Grid4x4", "Grid8x8", "Custom"]
FLIPMODE = ["Loop", "OneShot", "PingPong", "Random"]
TEXMODE = ["Stretch", "Wrap", "Static"]
NORMAL = ["Right", "Top", "Back", "Left", "Bottom", "Front"]
MATERIAL = {256: "Plastic", 272: "SmoothPlastic", 288: "Neon", 512: "Wood", 800: "Slate", 816: "Concrete",
            1040: "Metal", 1568: "Glass", 1584: "ForceField", 1056: "Foil", 1088: "DiamondPlate", 784: "Marble",
            832: "Granite", 848: "Brick", 864: "Pebble", 1280: "Grass", 1296: "Sand", 1312: "Fabric", 1536: "Ice",
            1376: "Snow", 2304: "Cardboard", 2320: "Carpet", 2336: "CeramicTiles", 2352: "ClayRoofTiles",
            1552: "Rock", 2048: "Basalt", 1328: "Ground", 2256: "Plaster", 2272: "Leather", 1536 + 1: "Ice"}

TAGS = [
    ("explosion", r"explo|boom|nuke|kaboom|blast|detonat|bomb"),
    ("slash", r"slash|cut|crescent|creshant|swipe|sword|blade|katana|slice|claw"),
    ("aura", r"aura|charge|power ?up|ssj|haki|transform"),
    ("beam", r"beam|laser|ray\b|kamehameha|cannon|hollow purple"),
    ("projectile", r"projectile|fireball|bullet|arrow|missile|orb|ball|shot|meteor"),
    ("impact", r"impact|hit|punch|kick|slam|smash|crater|crator|ground ?break|dust|debris|rock"),
    ("shockwave", r"shock|wave|ring|ripple|wind"),
    ("lightning", r"lightning|electric|thunder|spark|chidori|zap|bolt|raiden"),
    ("fire", r"fire|flame|burn|blaze|pyro|ember|heat|molten|lava|volcan"),
    ("water", r"water|aqua|splash|ocean|wet|bubble"),
    ("ice", r"ice|frost|freez|snow|glacier|cryo|frozen"),
    ("smoke", r"smoke|fog|cloud|mist|steam|dust"),
    ("dark", r"void|dark|black ?hole|abyss|shadow|curse|demon|nebula|black ?flash"),
    ("holy", r"holy|angel|light ?pillar|divine|sacred|heal|sun"),
    ("portal", r"portal|vortex|tornado|swirl|spin"),
    ("domain", r"domain|barrier"),
    ("blood", r"blood|gore"),
    ("star", r"star|sparkle|twinkle|glint|flare|cosmos|galax|space"),
    ("flash", r"flash|glow|burst"),
    ("dash", r"dash|teleport|flash ?step|afterimage|sandevistan|rush"),
    ("floor", r"floor|ground|crack"),
]
TAG_RX = [(t, re.compile(p, re.I)) for t, p in TAGS]


def hexc(c):
    return "#%02X%02X%02X" % tuple(max(0, min(255, round((x or 0) * 255))) for x in c[:3])


def color_ramp(seq):
    if not isinstance(seq, list) or not seq:
        return None
    pts = [s for s in seq if isinstance(s, list) and len(s) >= 4]
    if not pts:
        return None
    out = [hexc(pts[0][1:4])]
    if len(pts) > 2:
        mid = min(pts, key=lambda p: abs(p[0] - 0.5))
        out.append(hexc(mid[1:4]))
    if len(pts) > 1:
        out.append(hexc(pts[-1][1:4]))
    # collapse repeats
    ded = []
    for c in out:
        if not ded or ded[-1] != c:
            ded.append(c)
    return ded


def seq_points(seq):
    if not isinstance(seq, list):
        return []
    return [(p[0], p[1]) for p in seq if isinstance(p, list) and len(p) >= 2 and p[0] is not None and p[1] is not None]


def curve_shape(seq, kind):
    pts = seq_points(seq)
    if not pts:
        return None
    vals = [v for _, v in pts]
    a, z, hi, lo = vals[0], vals[-1], max(vals), min(vals)
    if kind == "size":
        if hi - lo < 1e-3 or (hi > 0 and (hi - lo) / hi < 0.08):
            return "const %.3g" % hi
        tpk = pts[vals.index(hi)][0]
        if a <= lo + 1e-6 and z >= hi - 1e-6:
            return "grow 0->%.3g" % hi
        if a >= hi - 1e-6 and z <= lo + 1e-6:
            return "shrink %.3g->%.3g" % (hi, z)
        return "swell %.3g->%.3g@%.2f->%.3g" % (a, hi, tpk, z)
    # transparency
    if hi - lo < 1e-3:
        return "flat %.2f" % hi
    t_vis = [t for t, v in pts if v <= lo + 0.02]
    first_vis = t_vis[0] if t_vis else 0
    last_vis = t_vis[-1] if t_vis else 0
    return "%.2f..%.2f vis %.2f-%.2f ->%.2f" % (a, lo, first_vis, last_vis, z)


def rng(v):
    if isinstance(v, list) and len(v) == 2 and all(isinstance(x, (int, float)) for x in v):
        return v if v[0] != v[1] else v[0]
    return v


def enum(lst, v):
    return lst[v] if isinstance(v, int) and 0 <= v < len(lst) else v


def tex_id(v):
    return rd.asset_id(v) if isinstance(v, str) else None


def num(v):
    if isinstance(v, (int, float)) and not isinstance(v, bool):
        return v
    if isinstance(v, str):
        try:
            return float(v)
        except ValueError:
            return None
    return None


def emitter_design(o):
    p, at = o["props"], o["attrs"] or {}
    d = {
        "k": "emitter", "name": o["name"],
        "tex": tex_id(p.get("Texture")),
        "col": color_ramp(p.get("Color")),
        "LE": p.get("LightEmission"), "LI": p.get("LightInfluence"), "Br": p.get("Brightness"),
        "life": rng(p.get("Lifetime")), "size": curve_shape(p.get("Size"), "size"),
        "transp": curve_shape(p.get("Transparency"), "transp"),
        "speed": rng(p.get("Speed")), "spread": rng(p.get("SpreadAngle")), "drag": p.get("Drag"),
        "acc": p.get("Acceleration") if p.get("Acceleration") and any(abs(x or 0) > 1e-4 for x in p.get("Acceleration")) else None,
        "rot": rng(p.get("Rotation")), "rotSpd": rng(p.get("RotSpeed")),
        "orient": enum(ORIENT, p.get("Orientation")), "dir": enum(NORMAL, p.get("EmissionDirection")),
        "shape": enum(SHAPE, p.get("Shape")), "inout": enum(INOUT, p.get("ShapeInOut")),
        "z": p.get("ZOffset"), "rate": p.get("Rate"), "on": p.get("Enabled"), "locked": p.get("LockedToPart"),
        "squash": curve_shape(p.get("Squash"), "size") if seq_points(p.get("Squash")) and any(abs(v) > 1e-3 for _, v in seq_points(p.get("Squash"))) else None,
        "flip": enum(FLIP, p.get("FlipbookLayout")), "flipMode": enum(FLIPMODE, p.get("FlipbookMode")),
        "flipFps": rng(p.get("FlipbookFramerate")), "ts": p.get("TimeScale"),
        "emit": num(at.get("EmitCount")), "delay": num(at.get("EmitDelay")), "dur": num(at.get("EmitDuration")),
    }
    if d["flip"] in (None, "None"):
        d.pop("flipMode"); d.pop("flipFps")
    for k in [k for k, v in d.items() if v is None]:
        d.pop(k)
    extra = {k: v for k, v in at.items() if k not in ("EmitCount", "EmitDelay", "EmitDuration") and not str(v).startswith("\u0000")}
    if extra:
        d["attrs"] = {k: (v if not isinstance(v, str) else v[:40]) for k, v in list(extra.items())[:8]}
    return d


def beam_design(o, cls):
    p = o["props"]
    d = {
        "k": cls.lower(), "name": o["name"], "tex": tex_id(p.get("Texture")), "col": color_ramp(p.get("Color")),
        "LE": p.get("LightEmission"), "LI": p.get("LightInfluence"), "Br": p.get("Brightness"),
        "transp": curve_shape(p.get("Transparency"), "transp"),
        "texLen": p.get("TextureLength"), "texMode": enum(TEXMODE, p.get("TextureMode")),
        "texSpd": p.get("TextureSpeed"), "z": p.get("ZOffset"),
        "on": p.get("Enabled"),
    }
    if cls == "Beam":
        d.update({"w": [p.get("Width0"), p.get("Width1")], "curve": [p.get("CurveSize0"), p.get("CurveSize1")],
                  "seg": p.get("Segments"), "face": p.get("FaceCamera")})
    else:
        d.update({"life": p.get("Lifetime"), "minLen": p.get("MinLength"), "maxLen": p.get("MaxLength"),
                  "width": curve_shape(p.get("WidthScale"), "size"), "face": p.get("FaceCamera")})
    for k in [k for k, v in d.items() if v is None]:
        d.pop(k)
    at = o["attrs"] or {}
    if at:
        d["attrs"] = {k: (v if not isinstance(v, str) else v[:40]) for k, v in list(at.items())[:8]}
    return d


def part_design(o):
    p = o["props"]
    cls = o["class"]
    mid = tex_id(p.get("MeshId") or p.get("MeshContent"))
    d = {"k": cls, "name": o["name"], "size": p.get("Size") or p.get("size"),
         "mat": MATERIAL.get(p.get("Material"), p.get("Material")), "transp": p.get("Transparency"),
         "col": hexc(p["Color"]) if isinstance(p.get("Color"), list) and len(p.get("Color")) == 3 else None}
    if mid:
        d["mesh"] = mid
    t = tex_id(p.get("TextureID") or p.get("TextureContent"))
    if t:
        d["meshTex"] = t
    for k in [k for k, v in d.items() if v is None]:
        d.pop(k)
    return d


SCRIPT_FLAGS = {
    "tween": r"TweenService|:Create\(", "emit": r":Emit\(", "attr": r"GetAttribute\(['\"]Emit",
    "delay": r"task\.delay|task\.wait|wait\(", "debris": r"Debris", "heartbeat": r"Heartbeat|RenderStepped|PreRender",
    "raycast": r"Raycast|FindPartOnRay", "camera": r"CurrentCamera|Camera", "shake": r"[Ss]hake",
    "remote": r"FireServer|FireClient|FireAllClients|OnServerEvent|OnClientEvent", "anim": r"LoadAnimation|:Play\(",
    "bezier": r"[Bb]ezier|lerp", "highlight": r"Highlight", "colorcorr": r"ColorCorrection|Bloom|Lighting",
}
SCRIPT_RX = {k: re.compile(v) for k, v in SCRIPT_FLAGS.items()}
SUS_RX = re.compile(r"require\s*\(\s*\d{5,}|[gs]etfenv|loadstring|\\\d{2,3}(\\\d{2,3}){20,}|discord\.com/api/webhooks")


def segment(insts):
    idx = rd.index(insts)
    vcount = {}

    def count(o):
        n = 1 if o["class"] in VFX else 0
        for c in o["children"]:
            n += count(idx[c])
        vcount[o["ref"]] = n
        return n

    roots = [o for o in insts if o["parent"] is None]
    for r in roots:
        count(r)
    effects = []

    def walk(o):
        v = vcount.get(o["ref"], 0)
        if v == 0:
            return
        if o["class"] in CONTAINERS and v <= MAX_LAYERS:
            effects.append(o)
            return
        if o["class"] in VFX:  # a lone layer straight under a service/huge folder
            effects.append(o)
            return
        for c in o["children"]:
            walk(idx[c])

    for r in roots:
        walk(r)
    return idx, effects


def descendants(o, idx):
    out = []
    st = list(o["children"])
    while st:
        c = idx[st.pop()]
        out.append(c)
        st.extend(c["children"])
    return out


def describe(o, idx, rel):
    ds = [o] + descendants(o, idx)
    layers, parts, scripts = [], [], []
    counts = collections.Counter(d["class"] for d in ds)
    for d in ds:
        c = d["class"]
        if c == "ParticleEmitter":
            layers.append(emitter_design(d))
        elif c in ("Beam", "Trail"):
            layers.append(beam_design(d, c))
        elif c in ("MeshPart", "Part", "UnionOperation") and (c == "MeshPart" or d["props"].get("Transparency", 0) < 1):
            if len(parts) < 40:
                parts.append(part_design(d))
        elif c == "SpecialMesh":
            mid = tex_id(d["props"].get("MeshId"))
            if mid and len(parts) < 40:
                parts.append({"k": "SpecialMesh", "name": d["name"], "mesh": mid,
                              "meshTex": tex_id(d["props"].get("TextureId")), "scale": d["props"].get("Scale")})
        elif c in SCRIPTS:
            src = d["props"].get("Source") if isinstance(d["props"].get("Source"), str) else ""
            scripts.append({"name": d["name"], "class": c, "len": len(src),
                            "flags": sorted(k for k, rx in SCRIPT_RX.items() if rx.search(src)),
                            "suspicious": bool(SUS_RX.search(src))})
    name_blob = " ".join([rel, rd.path_of(o, idx)] + [l.get("name", "") for l in layers])
    tags = sorted({t for t, rx in TAG_RX if rx.search(name_blob)})
    ends = []
    for l in layers:
        if l["k"] != "emitter":
            continue
        life = l.get("life")
        lmax = max(x for x in life if isinstance(x, (int, float))) if isinstance(life, list) else (life or 0)
        ends.append((l.get("delay") or 0) + (l.get("dur") or 0) + (lmax or 0))
    texs = sorted({l["tex"] for l in layers if l.get("tex")})
    sig = hashlib.md5(json.dumps(sorted(json.dumps(l, sort_keys=True, default=str) for l in layers)).encode()).hexdigest()[:12]
    return {
        "id": sig, "file": rel, "ref": o["ref"], "path": rd.path_of(o, idx), "root": o["class"], "tags": tags,
        "n": {"emitters": counts["ParticleEmitter"], "beams": counts["Beam"], "trails": counts["Trail"],
              "meshparts": counts["MeshPart"], "specialmesh": counts["SpecialMesh"], "parts": counts["Part"],
              "lights": counts["PointLight"] + counts["SpotLight"] + counts["SurfaceLight"],
              "highlights": counts["Highlight"], "attachments": counts["Attachment"], "scripts": len(scripts),
              "sounds": counts["Sound"], "decals": counts["Decal"] + counts["Texture"]},
        "emitAttrs": sum(1 for l in layers if "emit" in l),
        "lengthEst": round(max(ends), 2) if ends else None,
        "textures": texs, "layers": layers, "parts": parts, "scripts": scripts,
    }


def main(raw, out):
    os.makedirs(out, exist_ok=True)
    seen = {}
    files = {}
    tex = collections.defaultdict(lambda: {"effects": 0, "files": set(), "names": collections.Counter(),
                                           "LE": collections.Counter(), "flip": collections.Counter(),
                                           "kinds": collections.Counter()})
    designs = {}
    ef = open(os.path.join(out, "effects.jsonl"), "w")
    for root, _, fs in os.walk(raw):
        for f in sorted(fs):
            if not f.lower().endswith((".rbxm", ".rbxl", ".rbxmx", ".rbxlx")):
                continue
            p = os.path.join(root, f)
            rel = os.path.relpath(p, raw)
            try:
                insts, _ = rd.load(p)
            except Exception as e:
                files[rel] = {"error": repr(e)[:200]}
                continue
            idx, effs = segment(insts)
            sus = [rd.path_of(o, idx) for o in insts if o["class"] in SCRIPTS and isinstance(o["props"].get("Source"), str)
                   and SUS_RX.search(o["props"]["Source"])]
            files[rel] = {"effects": 0, "dupes": 0, "scripts": sum(1 for o in insts if o["class"] in SCRIPTS),
                          "suspicious": sus[:20]}
            for o in effs:
                e = describe(o, idx, rel)
                if e["id"] in seen:
                    seen[e["id"]]["also"].append(rel + " :: " + e["path"])
                    files[rel]["dupes"] += 1
                    continue
                e["also"] = []
                seen[e["id"]] = e
                files[rel]["effects"] += 1
                for l in e["layers"]:
                    t = l.get("tex")
                    if t:
                        x = tex[t]
                        x["files"].add(rel); x["names"][l.get("name", "")[:24]] += 1
                        x["LE"][str(l.get("LE"))] += 1; x["kinds"][l["k"]] += 1
                        if l.get("flip") and l.get("flip") != "None":
                            x["flip"][l["flip"]] += 1
                    if l["k"] == "emitter":
                        key = json.dumps({k: v for k, v in l.items() if k not in ("name", "attrs")}, sort_keys=True,
                                         default=str)
                        designs.setdefault(key, l)
                for t in e["textures"]:
                    tex[t]["effects"] += 1
    for e in seen.values():
        ef.write(json.dumps(e, default=str) + "\n")
    ef.close()
    texout = {str(k): {"effects": v["effects"], "files": len(v["files"]), "names": v["names"].most_common(6),
                       "LE": v["LE"].most_common(3), "flip": v["flip"].most_common(2), "kinds": dict(v["kinds"])}
              for k, v in sorted(tex.items(), key=lambda kv: -len(kv[1]["files"]))}
    json.dump(texout, open(os.path.join(out, "textures.json"), "w"), indent=0)
    json.dump(files, open(os.path.join(out, "files.json"), "w"), indent=1)
    json.dump(stats(list(designs.values())), open(os.path.join(out, "stats.json"), "w"), indent=1)
    print("effects", len(seen), "files", len(files), "textures", len(texout), "unique emitter designs", len(designs))


def stats(ds):
    def hist(vals, edges):
        c = collections.Counter()
        for v in vals:
            if not isinstance(v, (int, float)):
                continue
            for e in edges:
                if v <= e:
                    c["<=%g" % e] += 1
                    break
            else:
                c[">%g" % edges[-1]] += 1
        return dict(c)

    def first(v):
        return v[0] if isinstance(v, list) else v

    def hi(v):
        return v[1] if isinstance(v, list) else v

    out = {"designs": len(ds)}
    out["LightEmission"] = hist([d.get("LE") for d in ds], [0, 0.25, 0.5, 0.75, 0.99, 1])
    out["LightInfluence"] = hist([d.get("LI") for d in ds], [0, 0.25, 0.5, 0.99, 1])
    out["Brightness"] = hist([d.get("Br") for d in ds], [0.5, 1, 2, 5, 10, 20, 50])
    out["LifetimeMax"] = hist([hi(d.get("life")) for d in ds], [0.1, 0.2, 0.35, 0.5, 0.75, 1, 1.5, 2, 3, 5])
    out["SpeedMax"] = hist([hi(d.get("speed")) for d in ds], [0, 0.5, 2, 5, 10, 20, 50, 100])
    out["Drag"] = hist([d.get("drag") for d in ds], [0, 1, 3, 5, 10, 20])
    out["ZOffset"] = hist([d.get("z") for d in ds], [-5, -1, -0.01, 0, 0.5, 1, 2, 5])
    for k in ("orient", "shape", "flip", "flipMode", "dir", "inout"):
        out[k] = collections.Counter(str(d.get(k)) for d in ds).most_common(8)
    out["emitAttr"] = sum(1 for d in ds if "emit" in d)
    out["continuous(on+rate>0)"] = sum(1 for d in ds if d.get("on") and (d.get("rate") or 0) > 0)
    out["squash"] = sum(1 for d in ds if d.get("squash"))
    out["locked"] = sum(1 for d in ds if d.get("locked"))
    out["sizeShape"] = collections.Counter((d.get("size") or "?").split(" ")[0] for d in ds).most_common()
    out["EmitCount"] = hist([d.get("emit") for d in ds], [1, 2, 3, 5, 10, 20, 50, 100])
    out["EmitDelay"] = hist([d.get("delay") for d in ds], [0, 0.05, 0.1, 0.2, 0.3, 0.5, 1, 2])
    return out


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
