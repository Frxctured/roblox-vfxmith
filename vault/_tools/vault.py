#!/usr/bin/env python3
"""vault.py - one-call search over the Frxctured Vault (Python 3 standard library only).

    python3 vault.py "why do our effects look matte"        best 3 notes: TL;DR bullets + section list
    python3 vault.py -k 5 "texture choice"                   more notes
    python3 vault.py --brief "texture choice"                cheapest: best note in full, the others 1 bullet
    python3 vault.py --paths "smoke"                         titles and paths only
    python3 vault.py --sections "<note title>"               the note's ## headings
    python3 vault.py --read "<note title>" "<heading>"       one section's text (heading can be partial)
    python3 vault.py --read "<note title>"                   the whole note
    python3 vault.py --json "..."                            machine-readable results

Ranking: BM25F over title, tags, TL;DR, headings and body (title and TL;DR count most), with a small synonym map so
everyday words find vault vocabulary. The index is cached in ../.cache/ and rebuilt when any note changes.
"""
import argparse, json, math, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
CACHE = os.path.join(ROOT, ".cache", "index.json")
SKIP_DIRS = {"_tools", ".cache", ".obsidian", ".git", "_assets"}
FIELDS = {"title": 4.0, "tags": 3.0, "tldr": 2.5, "head": 2.0, "body": 1.0}
# project and test notes mention everything; rank them below craft notes unless the query is clearly about them
TYPE_PRIOR = {"project": 0.6, "test": 0.75}
K1, B = 1.2, 0.75

STOP = set("""a an and are as at be but by can do does for from has have how i if in into is it its me my of on or
our so that the their then there these this to was we were what when where which who why will with you your not no
than too very just also more most should would could""".split())

# everyday words -> vault vocabulary (both directions are added to the query)
SYNONYMS = {
    "particle": ["emitter", "particles"], "emitter": ["particle"], "texture": ["textures", "flipbook", "sprite"],
    "flipbook": ["texture", "spritesheet"], "glow": ["lightemission", "brightness", "bloom"], "bright": ["brightness"],
    "matte": ["brightness", "lightemission", "glow"], "flat": ["matte", "depth"], "smoke": ["cloud", "gas", "puff"],
    "slash": ["swing", "crescent", "smear"], "aura": ["character", "player", "body"], "player": ["character"],
    "look": ["quality", "visual"], "good": ["quality"], "bad": ["fail", "problem"], "ugly": ["fail", "quality"],
    "cost": ["tokens", "price"], "tokens": ["cost"], "review": ["reviewer", "panel", "rating"], "rate": ["rating"],
    "rating": ["poll", "score"], "score": ["rating"], "mesh": ["meshes", "model"], "asset": ["texture", "mesh"],
    "timing": ["motion", "rhythm"], "motion": ["timing", "movement"], "colour": ["color", "palette"],
    "chaotic": ["speed", "motion", "move"], "calm": ["speed", "barely", "move"], "fly": ["speed", "motion", "flung"],
    "messy": ["chaotic", "clutter"],
    "tiny": ["size", "scale", "small"], "small": ["size", "scale"], "big": ["size", "scale"], "huge": ["size", "scale"],
    "dull": ["matte", "brightness", "contrast"], "washed": ["contrast", "value", "glow"], "white": ["value", "glow", "contrast"],
    "color": ["colour", "palette"], "compose": ["composition", "layout"], "composition": ["layering", "placement"],
    "layout": ["composition", "placement"], "test": ["benchmark", "blindtest"], "benchmark": ["test"],
}


def tokens(text):
    out = []
    for w in re.findall(r"[a-z0-9]+", text.lower()):
        if w in STOP or len(w) < 2:
            continue
        for suf in ("ing", "es", "ed", "s"):  # tiny stemmer: good enough for short notes
            if len(w) > len(suf) + 3 and w.endswith(suf):
                w = w[: -len(suf)]
                break
        out.append(w)
    return out


def parse(path):
    text = open(path, encoding="utf-8", errors="replace").read()
    meta, body = {}, text
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if m:
        body = text[m.end():]
        for line in m.group(1).splitlines():
            if ":" in line:
                k, v = line.split(":", 1)
                meta[k.strip()] = v.strip()
    title = meta.get("title") or os.path.splitext(os.path.basename(path))[0]
    tags = meta.get("tags", "").strip("[]").replace(",", " ")
    tldr, in_tldr, heads = [], False, []
    for line in body.splitlines():
        s = line.strip()
        if s.lower().startswith("> tl;dr"):
            in_tldr = True
            continue
        if in_tldr:
            if s.startswith(">"):
                b = s.lstrip(">").strip()
                if b:
                    tldr.append(b.lstrip("- ").strip())
                continue
            in_tldr = False
        if s.startswith("## "):
            heads.append(s[3:].strip())
    return {"path": os.path.relpath(path, ROOT), "title": title, "tags": tags, "type": meta.get("type", ""),
            "tldr": tldr, "heads": heads, "body": body}


def note_files():
    for dirpath, dirs, files in os.walk(ROOT):
        dirs[:] = [d for d in dirs if d not in SKIP_DIRS and not d.startswith(".")]
        for f in files:
            if f.endswith(".md") and f not in ("README.md", "INDEX.md"):
                yield os.path.join(dirpath, f)


def load_index():
    files = sorted(note_files())
    stamp = [[os.path.relpath(f, ROOT), os.path.getmtime(f)] for f in files]
    try:
        cached = json.load(open(CACHE))
        if cached.get("stamp") == stamp:
            return cached
    except Exception:
        pass
    notes = [parse(f) for f in files]
    docs = []
    for n in notes:
        fields = {"title": tokens(n["title"]), "tags": tokens(n["tags"]), "tldr": tokens(" ".join(n["tldr"])),
                  "head": tokens(" ".join(n["heads"])), "body": tokens(n["body"])}
        docs.append({k: _counts(v) for k, v in fields.items()} | {"len": {k: len(v) for k, v in fields.items()}})
    avg = {f: (sum(d["len"][f] for d in docs) / len(docs) if docs else 1) or 1 for f in FIELDS}
    df = {}
    for d in docs:
        for t in set().union(*[d[f].keys() for f in FIELDS]):
            df[t] = df.get(t, 0) + 1
    idx = {"stamp": stamp, "notes": [{k: n[k] for k in ("path", "title", "tags", "type", "tldr", "heads")} for n in notes],
           "docs": docs, "avg": avg, "df": df}
    os.makedirs(os.path.dirname(CACHE), exist_ok=True)
    json.dump(idx, open(CACHE, "w"))
    return idx


def _counts(toks):
    c = {}
    for t in toks:
        c[t] = c.get(t, 0) + 1
    return c


def search(idx, query, k=3):
    q = tokens(query)
    expanded = set(q)
    for t in q:
        for s in SYNONYMS.get(t, []):
            expanded.update(tokens(s))
    n = len(idx["docs"]) or 1
    scores = []
    for i, d in enumerate(idx["docs"]):
        total = 0.0
        for t in expanded:
            df = idx["df"].get(t)
            if not df:
                continue
            idf = math.log(1 + (n - df + 0.5) / (df + 0.5))
            tf = 0.0
            for f, w in FIELDS.items():
                c = d[f].get(t, 0)
                if c:
                    norm = 1 - B + B * d["len"][f] / idx["avg"][f]
                    tf += w * c / norm
            weight = 1.0 if t in q else 0.5  # synonyms count half
            total += weight * idf * tf / (K1 + tf)
        if total > 0:
            note_type = idx["notes"][i].get("type", "")
            if note_type in TYPE_PRIOR and not expanded & set(tokens(note_type + " plan plugin vfxmith benchmark")):
                total *= TYPE_PRIOR[note_type]
            scores.append((total, i))
    scores.sort(reverse=True)
    return [(s, idx["notes"][i]) for s, i in scores[:k]]


def find_note(idx, title):
    t = title.lower()
    exact = [n for n in idx["notes"] if n["title"].lower() == t]
    if exact:
        return exact[0]
    part = [n for n in idx["notes"] if t in n["title"].lower() or t in n["path"].lower()]
    return part[0] if part else None


def read_section(note, heading=None):
    body = parse(os.path.join(ROOT, note["path"]))["body"]
    if not heading:
        return body.strip()
    out, on = [], False
    for line in body.splitlines():
        if line.startswith("## "):
            on = heading.lower() in line[3:].lower()
            if on:
                out.append(line)
            continue
        if on:
            out.append(line)
    return "\n".join(out).strip() or f"(no section matching '{heading}'; sections: {' | '.join(note['heads'])})"


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("query", nargs="*")
    ap.add_argument("-k", type=int, default=3)
    ap.add_argument("--brief", action="store_true")
    ap.add_argument("--paths", action="store_true")
    ap.add_argument("--json", action="store_true")
    ap.add_argument("--sections", metavar="TITLE")
    ap.add_argument("--read", nargs="+", metavar=("TITLE", "HEADING"))
    a = ap.parse_args()
    idx = load_index()
    if a.read:
        note = find_note(idx, a.read[0])
        print(read_section(note, a.read[1] if len(a.read) > 1 else None) if note else f"no note '{a.read[0]}'")
        return
    if a.sections:
        note = find_note(idx, a.sections)
        print(" | ".join(note["heads"]) if note else f"no note '{a.sections}'")
        return
    query = " ".join(a.query)
    if not query:
        ap.print_help()
        return
    hits = search(idx, query, a.k)
    if a.json:
        print(json.dumps([{"score": round(s, 3)} | n for s, n in hits], indent=1))
        return
    if not hits:
        print("no matching notes")
        return
    for rank, (s, n) in enumerate(hits):
        if a.paths:
            print(f"{n['title']}  ({n['path']})")
            continue
        print(f"## {n['title']}  ({n['path']})")
        bullets = n["tldr"] if not (a.brief and rank > 0) else n["tldr"][:1]
        for b in bullets:
            print(f"- {b}")
        if n["heads"] and not (a.brief and rank > 0):
            print("sections: " + " | ".join(n["heads"]))
        print()


if __name__ == "__main__":
    main()
