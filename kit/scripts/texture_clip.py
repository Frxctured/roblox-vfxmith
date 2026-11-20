#!/usr/bin/env python3
"""Visual texture index with CLIP (maintainer tool; plugin users never need it).

Build (once, after the texture caches change), with a Python that has torch + open_clip (here ~/.vfxmith/clipenv):
    ~/.vfxmith/clipenv/bin/python kit/scripts/texture_clip.py build [--model ViT-B-16 --pretrained laion2b_s34b_b88k]
  -> ~/.vfxmith/clip/<model>.npy + ids.json   (image embeddings, kept OUT of the plugin: ~20 MB, needs the model)
  -> gallery/textures/visual_tags.json        (shipped: per texture its best-matching words from VOCAB, so
                                               find_textures.py can match "crescent" or "wispy" by what the image
                                               SHOWS, not only by its name; plain JSON, no ML needed to read it)
Search by look (maintainer machine only):
    ~/.vfxmith/clipenv/bin/python kit/scripts/texture_clip.py query "thin glowing crescent slash arc" [-n 12] [--ids]

Images: every cached texture (<cache>/<id>.png original or <id>.thumb.png), alpha composited over black (how additive
VFX reads) for the embedding. A flipbook is embedded from its whole sheet (CLIP still sees the shape family).
"""
import json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, "..", ".."))
CACHE = os.path.expanduser("~/.vfxmith/cache/textures")
OUTDIR = os.path.expanduser("~/.vfxmith/clip")
TAGS = os.path.join(ROOT, "gallery", "textures", "visual_tags.json")

# What VFX artists ask for: shape, material, look. Kept generic (every effect type), one or two words each.
VOCAB = """crescent arc;slash;sword trail;swoosh;ring;thin ring;circle;shockwave;halo;disc;spiral;swirl;vortex;
star;four-point star;sparkle;glint;lens flare;burst;starburst;spike;spiky;shard;crystal;fragment;streak;speed lines;
line;needle;beam;ray;light rays;lightning bolt;branching lightning;electric arc;dot;orb;sphere;bubble;cloud;smoke puff;
wispy smoke;mist;dust;steam;flame;fire;flame tongue;ember;spark;explosion;fireball;splash;water drop;wave;ripple;
ice;snowflake;frost;crack;ground crack;scorch mark;rune;magic circle;glyph;symbol;hexagon;triangle;square;cross;
plus sign;petal;leaf;feather;heart;skull;eye;wing;claw mark;scratch;noise;grain;gradient;soft glow;blur;glow;
energy;aura;plasma;flare;comet;trail;ribbon;tendril;tentacle;smoke trail;wind;tornado;portal;hole;void;shadow;
ink;splatter;blood;rock;debris;dirt;sand;leaves;confetti;bokeh;sparkles;stars;galaxy;nebula;cosmic;holy light;
dark;bright;soft;sharp edges;crisp;blurry;pixelated;jagged;smooth;fluffy;thin;thick;hollow;filled;outline;
cartoon;anime;painterly;realistic;hand drawn;stylized;flipbook sheet;grid of frames;text;letters;logo""".replace("\n", "")
VOCAB = [w.strip() for w in VOCAB.split(";") if w.strip()]


def model(name, pre):
    import open_clip, torch
    m, _, prep = open_clip.create_model_and_transforms(name, pretrained=pre)
    m.eval()
    torch.set_num_threads(os.cpu_count() or 8)
    return m, prep, open_clip.get_tokenizer(name)


def image_paths():
    seen = {}
    for fn in os.listdir(CACHE):
        if not fn.endswith(".png"):
            continue
        tid = fn.split(".")[0]
        if fn.endswith(".thumb.png") and tid in seen:
            continue
        seen[tid] = os.path.join(CACHE, fn)
    return seen


def load_rgb(p):
    from PIL import Image
    im = Image.open(p).convert("RGBA")
    bg = Image.new("RGBA", im.size, (0, 0, 0, 255))
    bg.alpha_composite(im)
    return bg.convert("RGB")


def build(name, pre):
    import numpy as np, torch
    m, prep, tok = model(name, pre)
    paths = image_paths()
    ids = sorted(paths)
    embs, ok = [], []
    B = 64
    for i in range(0, len(ids), B):
        batch, bid = [], []
        for tid in ids[i:i + B]:
            try:
                batch.append(prep(load_rgb(paths[tid])))
                bid.append(tid)
            except Exception:
                pass
        if not batch:
            continue
        with torch.no_grad():
            e = m.encode_image(torch.stack(batch))
            e = e / e.norm(dim=-1, keepdim=True)
        embs.append(e.numpy().astype("float16"))
        ok += bid
        print(f"{min(i + B, len(ids))}/{len(ids)}", end="\r", flush=True)
    E = np.concatenate(embs)
    os.makedirs(OUTDIR, exist_ok=True)
    np.save(os.path.join(OUTDIR, f"{name}.npy"), E)
    json.dump({"model": name, "pretrained": pre, "ids": ok}, open(os.path.join(OUTDIR, "ids.json"), "w"))
    # zero-shot tags: words whose text embedding sits clearly above this image's average word similarity
    with torch.no_grad():
        t = m.encode_text(tok([f"a {w} visual effect texture on a black background" for w in VOCAB]))
        t = (t / t.norm(dim=-1, keepdim=True)).numpy().astype("float32")
    S = E.astype("float32") @ t.T  # images x words
    Z = (S - S.mean(axis=1, keepdims=True)) / (S.std(axis=1, keepdims=True) + 1e-6)
    tags = {"_about": {"made_by": "kit/scripts/texture_clip.py build", "model": f"{name} {pre}",
                       "rule": "top words by z-score of image-word similarity (z >= 1.6, at most 8)", "count": len(ok)}}
    for r, tid in enumerate(ok):
        order = np.argsort(-Z[r])[:8]
        tags[tid] = [[VOCAB[j], round(float(Z[r, j]), 2)] for j in order if Z[r, j] >= 1.6]
    json.dump(tags, open(TAGS, "w"), separators=(",", ":"))
    print(f"\n{len(ok)} images -> {OUTDIR}/{name}.npy and {TAGS}")


def query(text, n, ids_only):
    import numpy as np, torch
    meta = json.load(open(os.path.join(OUTDIR, "ids.json")))
    E = np.load(os.path.join(OUTDIR, f"{meta['model']}.npy")).astype("float32")
    m, _, tok = model(meta["model"], meta["pretrained"])
    with torch.no_grad():
        t = m.encode_text(tok([f"a {text} visual effect texture on a black background"]))
        t = (t / t.norm(dim=-1, keepdim=True)).numpy()[0]
    s = E @ t
    top = np.argsort(-s)[:n]
    for k in top:
        print(meta["ids"][k] if ids_only else f"{meta['ids'][k]}  {s[k]:.3f}")


if __name__ == "__main__":
    a = sys.argv[1:]
    opt = lambda k, d: a[a.index(k) + 1] if k in a else d
    if a and a[0] == "build":
        build(opt("--model", "ViT-B-16"), opt("--pretrained", "laion2b_s34b_b88k"))
    elif a and a[0] == "query":
        query(a[1], int(opt("-n", "12")), "--ids" in a)
    else:
        print(__doc__)
