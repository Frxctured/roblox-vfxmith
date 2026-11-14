#!/usr/bin/env python3
"""Everything a builder has to read, gathered into a few files it can read in ONE message (parallel Read calls): one
turn instead of dozens of cat/sed calls, and no tool output too long to show (those get saved to a file and cost extra
reads). Text is cheap; turns are what re-read the context.

    python3 -I builder_pack.py --types impact,icewater [--cards 3f2a...,9bc1...] --out <effect>/pack

Writes <out>/1_rules.md (builder-notes + spec-format), <out>/2_<type>.md per type (the category study + its starting
recipe), <out>/3_cards.md (the library cards named by id, if any). Every file stays under ~60k characters (~15k
tokens): a longer study is split at its headings into 2_<type>_a.md, _b.md. Prints the files to read.
"""
import argparse
import glob
import os

ROOT = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
LIMIT = 60000


def read(rel):
    p = os.path.join(ROOT, rel)
    return open(p).read() if os.path.isfile(p) else None


def split(text, limit=LIMIT):
    """Split at '## ' headings into parts under the limit (a single huge section is cut at a line break)."""
    if len(text) <= limit:
        return [text]
    parts, cur = [], ""
    for block in text.split("\n## "):
        block = block if not cur and not parts else "## " + block
        if len(cur) + len(block) > limit and cur:
            parts.append(cur)
            cur = ""
        while len(block) > limit:
            cut = block.rfind("\n", 0, limit)
            parts.append(block[:cut])
            block = block[cut + 1:]
        cur += ("\n" if cur else "") + block
    if cur:
        parts.append(cur)
    return parts


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--types", required=True, help="category types, e.g. impact,icewater (see knowledge/README.md)")
    ap.add_argument("--cards", default="", help="library card ids from the librarian, comma-separated")
    ap.add_argument("--out", required=True)
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)
    written = []

    rules = ["# Builder pack 1: rules and format\n",
             "\n\n---\n# knowledge/builder-notes.md\n\n" + (read("knowledge/builder-notes.md") or ""),
             "\n\n---\n# knowledge/spec-format.md\n\n" + (read("knowledge/spec-format.md") or "")]
    p = os.path.join(a.out, "1_rules.md")
    open(p, "w").write("".join(rules))
    written.append(p)

    for t in [x.strip() for x in a.types.split(",") if x.strip()]:
        study = read(f"knowledge/categories/{t}.md")
        if study is None:
            known = sorted(os.path.basename(f)[:-3] for f in glob.glob(os.path.join(ROOT, "knowledge/categories/*.md")))
            raise SystemExit(f"no study for type '{t}'; types: {', '.join(known)}")
        recipe = read(f"knowledge/categories/{t}_recipe.luau") or ""
        body = (f"# Builder pack 2: {t}\n\nStudy: knowledge/categories/{t}.md. Starting recipe: "
                f"knowledge/categories/{t}_recipe.luau (how it plays: gallery/recipes/{t}_recipe.jpg).\n\n---\n"
                + study + "\n\n---\n# knowledge/categories/" + t + "_recipe.luau\n\n```lua\n" + recipe + "\n```\n")
        parts = split(body)
        for i, part in enumerate(parts):
            suffix = "" if len(parts) == 1 else "_" + "abcdefgh"[i]
            p = os.path.join(a.out, f"2_{t}{suffix}.md")
            open(p, "w").write(part)
            written.append(p)

    ids = [x.strip() for x in a.cards.split(",") if x.strip()]
    if ids:
        chunks = ["# Builder pack 3: library cards (exact layers, textures, numbers)\n"]
        for cid in ids:
            hits = glob.glob(os.path.join(ROOT, "library", "cards", "*", cid + "*.md"))
            if not hits:
                chunks.append(f"\n---\n## {cid}: no card found\n")
                continue
            rel = os.path.relpath(hits[0], ROOT)
            frames = glob.glob(os.path.join(ROOT, "gallery", "effects", "*", cid + "*.jpg"))
            note = f" (frames: {os.path.relpath(frames[0], ROOT)})" if frames else " (no frame sheet)"
            chunks.append(f"\n---\n## {rel}{note}\n\n" + open(hits[0]).read())
        for i, part in enumerate(split("".join(chunks))):
            p = os.path.join(a.out, f"3_cards{'' if i == 0 else '_' + 'bcdefgh'[i - 1]}.md")
            open(p, "w").write(part)
            written.append(p)

    total = sum(os.path.getsize(p) for p in written)
    print(f"pack: {len(written)} files, {total // 1000}k chars (~{total // 4000}k tokens). Read them all in ONE message:")
    for p in written:
        print(f"  {p}  ({os.path.getsize(p) // 1000}k)")


if __name__ == "__main__":
    main()
