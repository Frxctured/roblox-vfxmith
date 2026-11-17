#!/usr/bin/env python3
"""OPTIONAL, Linux only (niri + wl-clipboard). Screenshot one Studio window (even off screen) to a file.

    python3 shot.py --win <niri window id> --out path.jpg [--full] [--width 1280]

A file lock serialises shots (niri puts every screenshot on the shared clipboard). The user's clipboard is saved
first and restored after. Default crops to the 3D viewport by window fractions (--crop: measure yours once);
--full keeps the whole window. Everywhere else use the MCP screen_capture (knowledge/selfcheck.md).
"""
import argparse, fcntl, io, subprocess, time
from PIL import Image

ap = argparse.ArgumentParser()
ap.add_argument("--win", required=True)
ap.add_argument("--out", required=True)
ap.add_argument("--full", action="store_true")
ap.add_argument("--crop", default="0.1425,0.1444,0.89,0.844", help="viewport as window fractions x0,y0,x1,y1")
ap.add_argument("--width", type=int, default=1280)
a = ap.parse_args()

def paste(t):
    return subprocess.run(["wl-paste", "--no-newline", "--type", t], capture_output=True).stdout

with open("/tmp/vfxmith_shot.lock", "w") as lk:
    fcntl.flock(lk, fcntl.LOCK_EX)
    types = subprocess.run(["wl-paste", "--list-types"], capture_output=True, text=True).stdout.split()
    saved = None
    for t in ("image/png", "text/plain;charset=utf-8", "text/plain"):
        if t in types:
            saved = (t, paste(t)); break
    subprocess.run(["wl-copy", "--type", "text/plain", "VFXMITH_SHOT"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    time.sleep(0.1)
    subprocess.run(["niri", "msg", "action", "screenshot-window", "--id", a.win, "--write-to-disk", "false"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    img = None
    for _ in range(60):
        time.sleep(0.05)
        if "image/png" in subprocess.run(["wl-paste", "--list-types"], capture_output=True, text=True).stdout.split():
            img = Image.open(io.BytesIO(paste("image/png"))).convert("RGB"); break
    if saved:
        p = subprocess.Popen(["wl-copy", "--type", saved[0]], stdin=subprocess.PIPE, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        p.stdin.write(saved[1]); p.stdin.close()
if img is None:
    raise SystemExit("no screenshot")
if not a.full:
    W, H = img.size
    x0, y0, x1, y1 = map(float, a.crop.split(","))
    img = img.crop((int(W * x0), int(H * y0), int(W * x1), int(H * y1)))
if img.width > a.width:
    img = img.resize((a.width, round(img.height * a.width / img.width)))
img.save(a.out, quality=88)
print(a.out, img.size)
