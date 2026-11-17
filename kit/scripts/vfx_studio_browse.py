#!/usr/bin/env python3
"""Browse the VFX Studio texture library (a free Roblox Studio plugin's catalogue) as labelled contact sheets, so
effects can be built from textures you have actually looked at. To SEARCH it together with the open-source library,
with measured traits, use kit/scripts/find_textures.py (gallery/textures/vfxstudio_index.json is the shipped copy of
this index).

  python3 -I kit/scripts/vfx_studio_browse.py --out <dir> [--keyword Fire] [--search swirl] [--grid 4|8|2|none|any]
                                            [--offset 0] [--count 30] [--ids 123,456]

Library index: https://raw.githubusercontent.com/Sytranom/VFXStudio/refs/heads/main/VFXData.json (cached as
<out>/VFXData.json): asset id -> { Name, Keywords, Grid (flipbook grid: 2 = 2x2, 4 = 4x4, 8 = 8x8), Resolution }.
Keywords in use: Form Flare Other Impact Beam Circle Smoke Slashes Text Spec Lightning Fire Swirl Energy Grid Ground
Water Star. Thumbnails come from the public Roblox thumbnails API. Writes <out>/<tag>.png (6 x 5 grid, each cell
labelled "<index> g<grid>") and <out>/<tag>.json (index -> id, grid, name). Use the id as "rbxassetid://<id>"; a flipbook
needs FlipbookLayout Grid<g>x<g>. A texture on a BLACK background is additive-only (LightEmission 1); one on
transparency also works with LightEmission 0 (dark layers).
"""
import argparse, io, json, os, urllib.request
from PIL import Image, ImageDraw

URL = "https://raw.githubusercontent.com/Sytranom/VFXStudio/refs/heads/main/VFXData.json"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", required=True)
    ap.add_argument("--keyword")
    ap.add_argument("--search")
    ap.add_argument("--grid", default="any")
    ap.add_argument("--offset", type=int, default=0)
    ap.add_argument("--count", type=int, default=30)
    ap.add_argument("--ids")
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)
    cache = os.path.join(a.out, "VFXData.json")
    if not os.path.exists(cache):
        urllib.request.urlretrieve(URL, cache)
    d = json.load(open(cache))
    if a.ids:
        items = [(i, d.get(i, {"Name": "?"})) for i in a.ids.split(",")]
    else:
        items = []
        for i, v in d.items():
            if a.keyword and a.keyword not in v.get("Keywords", []):
                continue
            if a.search and a.search.lower() not in (v.get("Name", "") + " " + " ".join(v.get("Keywords", []))).lower():
                continue
            g = v.get("Grid")
            if a.grid == "none" and g:
                continue
            if a.grid not in ("any", "none") and str(g) != a.grid:
                continue
            items.append((i, v))
        items = items[a.offset:a.offset + a.count]
    tag = "_".join(x for x in (a.keyword, a.search, "g" + a.grid, str(a.offset)) if x) if not a.ids else "ids"
    urls = {}
    for k in range(0, len(items), 50):
        chunk = [i for i, _ in items[k:k + 50]]
        q = "https://thumbnails.roblox.com/v1/assets?assetIds=" + ",".join(chunk) + "&size=150x150&format=Png"
        for x in json.load(urllib.request.urlopen(q, timeout=30))["data"]:
            if x.get("state") == "Completed":
                urls[str(x["targetId"])] = x.get("imageUrl")
    cols, rows = 6, max(1, (len(items) + 5) // 6)
    sheet = Image.new("RGB", (cols * 160, rows * 175), (25, 25, 32))
    dr = ImageDraw.Draw(sheet)
    index = []
    for k, (i, v) in enumerate(items):
        x, y = (k % cols) * 160, (k // cols) * 175
        if urls.get(i):
            try:
                im = Image.open(io.BytesIO(urllib.request.urlopen(urls[i], timeout=20).read())).convert("RGBA")
                bg = Image.new("RGBA", im.size, (25, 25, 32, 255))
                bg.alpha_composite(im)
                sheet.paste(bg.convert("RGB").resize((150, 150)), (x + 5, y + 5))
            except Exception:
                pass
        dr.text((x + 6, y + 157), f"{k} g{v.get('Grid') or '-'}", fill=(255, 255, 0))
        index.append({"k": k, "id": i, "grid": v.get("Grid"), "name": v.get("Name"), "keywords": v.get("Keywords")})
    sheet.save(os.path.join(a.out, tag + ".png"))
    json.dump(index, open(os.path.join(a.out, tag + ".json"), "w"), indent=1)
    print(os.path.join(a.out, tag + ".png"), len(items), "items,", len(urls), "thumbnails")


if __name__ == "__main__":
    main()
