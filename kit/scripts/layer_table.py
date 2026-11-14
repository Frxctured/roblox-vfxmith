#!/usr/bin/env python3
"""One readable line per layer for an effect from vfx_catalog.py's effects.jsonl (what an artist would read off the
Properties panel), sorted by when each layer fires.

    python3 -I layer_table.py <catalog dir> <effect id> [--textures <texture_sheets index.json>]

Columns: kind name | texture id (+ light mode/flipbook/common name if a texture index is given) | colour ramp |
LightEmission/LightInfluence/Brightness | lifetime | size curve | transparency curve | speed/drag/spread/accel |
orientation | flipbook | ZOffset | emit count @ delay (+duration) or Rate when continuous.
"""
import json
import os
import sys


def fmt(v):
    if isinstance(v, list):
        return "-".join(fmt(x) for x in v)
    if isinstance(v, float):
        return ("%.3g" % v)
    return str(v)


def line(l, tex):
    k = l["k"][0].upper()
    parts = ["%s %-14s" % (k, (l.get("name") or "")[:14])]
    t = l.get("tex")
    if t:
        info = tex.get(str(t))
        parts.append("tex %s%s" % (t, " (%s %s %s)" % (info.get("light"), (info.get("flip") or [["", 0]])[0][0] if info.get("flip") else "",
                                                       (info.get("names") or [[""]])[0][0][:12]) if info else ""))
    if l.get("col"):
        parts.append("col " + "->".join(l["col"]))
    parts.append("LE%s LI%s Br%s" % (fmt(l.get("LE")), fmt(l.get("LI")), fmt(l.get("Br"))))
    if l["k"] == "emitter":
        parts.append("life " + fmt(l.get("life")))
        parts.append("size " + str(l.get("size")))
        parts.append("tr " + str(l.get("transp")))
        mv = "spd %s" % fmt(l.get("speed"))
        if l.get("drag"):
            mv += " drag %s" % fmt(l["drag"])
        if l.get("spread") not in (None, [0, 0], 0):
            mv += " spread %s" % fmt(l["spread"])
        if l.get("acc"):
            mv += " acc %s" % fmt(l["acc"])
        if l.get("rotSpd") not in (None, 0, [0, 0]):
            mv += " rotSpd %s" % fmt(l["rotSpd"])
        parts.append(mv)
        parts.append(str(l.get("orient", "")) + ("/" + l["shape"] if l.get("shape") not in (None, "Box") else ""))
        if l.get("squash"):
            parts.append("squash " + l["squash"])
        if l.get("flip") not in (None, "None"):
            parts.append("flip %s %s %s" % (l["flip"], l.get("flipMode", ""), fmt(l.get("flipFps"))))
        if l.get("locked"):
            parts.append("locked")
        if l.get("emit") is not None:
            parts.append("EMIT %s @%s%s" % (fmt(l["emit"]), fmt(l.get("delay") or 0), (" for %s" % fmt(l["dur"])) if l.get("dur") else ""))
        elif l.get("on") and (l.get("rate") or 0) > 0:
            parts.append("RATE %s (continuous)" % fmt(l["rate"]))
    else:
        if l["k"] == "beam":
            parts.append("w %s curve %s seg %s%s" % (fmt(l.get("w")), fmt(l.get("curve")), l.get("seg"), " face" if l.get("face") else ""))
        else:
            parts.append("life %s width %s" % (fmt(l.get("life")), l.get("width")))
        parts.append("tr " + str(l.get("transp")))
        parts.append("tex %s %s spd %s" % (l.get("texMode"), fmt(l.get("texLen")), fmt(l.get("texSpd"))))
    if l.get("z"):
        parts.append("z " + fmt(l["z"]))
    if l.get("attrs"):
        parts.append("attrs " + json.dumps(l["attrs"], default=str)[:120])
    return " | ".join(parts)


def table(e, tex):
    def when(l):
        return (l.get("delay") or 0, l["k"] != "emitter")
    out = ["# %s  [%s]  %s :: %s" % (e["id"], ",".join(e["tags"]), e["file"], e["path"]),
           "counts %s  est.length %ss" % (json.dumps(e["n"]), e.get("lengthEst"))]
    for l in sorted(e["layers"], key=when):
        out.append(line(l, tex))
    for p in e.get("parts", [])[:20]:
        out.append("P " + json.dumps(p, default=str)[:160])
    for s in e.get("scripts", []):
        out.append("S %s %s len%d flags=%s%s" % (s["class"], s["name"], s["len"], ",".join(s["flags"]), " SUSPICIOUS" if s["suspicious"] else ""))
    return "\n".join(out)


def main():
    cat, eid = sys.argv[1], sys.argv[2]
    tex = {}
    if "--textures" in sys.argv:
        ti = json.load(open(sys.argv[sys.argv.index("--textures") + 1]))
        tex = {str(v["id"]): v for v in ti.values()}
    for l in open(os.path.join(cat, "effects.jsonl")):
        if l.startswith('{"id": "%s"' % eid):
            print(table(json.loads(l), tex))
            return
    for l in open(os.path.join(cat, "effects.jsonl")):
        e = json.loads(l)
        if e["id"] == eid:
            print(table(e, tex))
            return
    sys.exit("not found")


if __name__ == "__main__":
    main()
