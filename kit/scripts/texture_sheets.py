#!/usr/bin/env python3
"""Contact sheets of the most-used textures in a catalogue made by vfx_catalog.py (or any id list), so you LOOK at the
community's texture vocabulary before picking one.

    python3 -I texture_sheets.py --catalog <catalog dir> --out <dir> [--top 300] [--min-files 2] [--per 48]
    python3 -I texture_sheets.py --ids 123,456 --out <dir>

Each cell: the texture on a mid-grey ground (white art and dark ink both show), the index, the asset id, the number of
FILES that use it, the light mode (A = additive LightEmission 1, D = dark/normal LightEmission 0, M = mixed), the
flipbook grid if any, and the most common layer name. Writes <out>/sheet_NN.png and <out>/index.json
(index -> id, files, effects, names, LE, flip). Thumbnails (public Roblox thumbnails API) are cached in <out>/thumbs/.
"""
import argparse
import io
import json
import os
import time
import urllib.request

from PIL import Image, ImageDraw, ImageFont


def fetch_thumbs(ids, cache):
    os.makedirs(cache, exist_ok=True)
    need = [i for i in ids if not os.path.exists(os.path.join(cache, f"{i}.png"))]
    for k in range(0, len(need), 50):
        chunk = need[k:k + 50]
        q = "https://thumbnails.roblox.com/v1/assets?assetIds=" + ",".join(map(str, chunk)) + "&size=150x150&format=Png"
        for attempt in range(3):
            try:
                data = json.load(urllib.request.urlopen(q, timeout=30))["data"]
                break
            except Exception:
                time.sleep(2)
        else:
            continue
        for x in data:
            if x.get("state") == "Completed" and x.get("imageUrl"):
                try:
                    b = urllib.request.urlopen(x["imageUrl"], timeout=30).read()
                    open(os.path.join(cache, f"{x['targetId']}.png"), "wb").write(b)
                except Exception:
                    pass
            else:
                open(os.path.join(cache, f"{x['targetId']}.missing"), "w").write(x.get("state", "?"))


def light_mode(le):
    a = d = 0
    for v, c in le:
        try:
            f = float(v)
        except (TypeError, ValueError):
            continue
        if f >= 0.75:
            a += c
        elif f <= 0.25:
            d += c
    if a and d:
        return "A" if a > 3 * d else ("D" if d > 3 * a else "M")
    return "A" if a else ("D" if d else "?")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--catalog")
    ap.add_argument("--ids")
    ap.add_argument("--out", required=True)
    ap.add_argument("--top", type=int, default=300)
    ap.add_argument("--min-files", type=int, default=2)
    ap.add_argument("--per", type=int, default=48)
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)
    items = []
    if a.catalog:
        tex = json.load(open(os.path.join(a.catalog, "textures.json")))
        for tid, v in tex.items():
            if v["files"] >= a.min_files:
                items.append((tid, v))
        items.sort(key=lambda kv: (-kv[1]["files"], -kv[1]["effects"]))
        items = items[:a.top]
    else:
        items = [(i, {"files": 0, "effects": 0, "names": [], "LE": [], "flip": []}) for i in a.ids.split(",")]
    cache = os.path.join(a.out, "thumbs")
    fetch_thumbs([i for i, _ in items], cache)
    font = ImageFont.load_default()
    cell, cols = 150, 8
    index = {}
    for s in range(0, len(items), a.per):
        chunk = items[s:s + a.per]
        rows = (len(chunk) + cols - 1) // cols
        sheet = Image.new("RGB", (cols * cell, rows * (cell + 30)), (20, 20, 24))
        dr = ImageDraw.Draw(sheet)
        for j, (tid, v) in enumerate(chunk):
            n = s + j
            x, y = (j % cols) * cell, (j // cols) * (cell + 30)
            bg = Image.new("RGB", (cell - 4, cell - 4), (92, 92, 100))
            p = os.path.join(cache, f"{tid}.png")
            if os.path.exists(p):
                try:
                    im = Image.open(p).convert("RGBA").resize((cell - 4, cell - 4))
                    bg.paste(im, (0, 0), im)
                except Exception:
                    pass
            else:
                ImageDraw.Draw(bg).text((40, 65), "no thumb", fill=(255, 80, 80), font=font)
            sheet.paste(bg, (x + 2, y + 2))
            lm = light_mode(v.get("LE", []))
            flip = v["flip"][0][0].replace("Grid", "") if v.get("flip") else ""
            name = v["names"][0][0] if v.get("names") else ""
            dr.text((x + 4, y + 4), f"{n}", fill=(255, 255, 0), font=font)
            dr.text((x + 3, y + cell), f"{tid} f{v['files']} {lm} {flip}", fill=(230, 230, 230), font=font)
            dr.text((x + 3, y + cell + 13), name[:24], fill=(150, 200, 255), font=font)
            index[n] = {"id": tid, "files": v["files"], "effects": v["effects"], "names": v.get("names"),
                        "LE": v.get("LE"), "flip": v.get("flip"), "light": lm}
        sheet.save(os.path.join(a.out, "sheet_%02d.png" % (s // a.per)))
    json.dump(index, open(os.path.join(a.out, "index.json"), "w"), indent=1)
    print(len(items), "textures ->", a.out)


if __name__ == "__main__":
    main()
