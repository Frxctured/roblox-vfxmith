#!/usr/bin/env python3
"""Takes the freeze-frame screenshots scheduled by VFXCapture.stills (Studio side) without bringing Studio to the
front: niri can screenshot a window that is not on screen.

    python3 tools/vfx/pipeline/stills.py --start <ms> --markers "x,y;x,y;..." --times 0.03,0.1,... \
        [--hold 2.5] [--gap 0.3] [--viewport 368,207] --out DIR

--start and --markers come from the JSON VFXCapture.stills returns; times/hold/gap must be the same values.
Schedule: play k starts at S_k (S_0 = start, S_k+1 = S_k + t_k + hold + gap), freezes at effect time t_k and holds for
`hold` s. A Studio window that is not on screen only redraws about once a second, so a screenshot can show an older
frame: VFXCapture shows the still's number k on five marker cubes (binary, white = 1) while it is frozen, and this
script re-shoots until the cubes read k. A base shot of the empty stage (cubes all black) is taken before start.
Shots go through the clipboard (niri puts every screenshot there; --write-to-disk false), which is saved first and
restored at the end. Writes DIR/base.png and DIR/t<t>.png (whole Studio window; compare.py crops the viewport).
"""
import argparse
import io
import json
import os
import subprocess
import sys
import time

from PIL import Image


def studio_window():
    wins = json.loads(subprocess.run(["niri", "msg", "-j", "windows"], capture_output=True, text=True, check=True).stdout)
    for w in wins:
        if w.get("app_id") == "explorer.exe" and "Wine Desktop" in (w.get("title") or ""):
            return w["id"]
    sys.exit("Studio window not found")


def save_clipboard():
    types = subprocess.run(["wl-paste", "--list-types"], capture_output=True, text=True).stdout.split()
    for t in ("image/png", "text/plain;charset=utf-8", "text/plain", "UTF8_STRING"):
        if t in types:
            return t, subprocess.run(["wl-paste", "--no-newline", "--type", t], capture_output=True).stdout
    return None, None


def restore_clipboard(kind, data):
    if kind:
        p = subprocess.Popen(["wl-copy", "--type", kind], stdin=subprocess.PIPE, stdout=subprocess.DEVNULL,
                             stderr=subprocess.DEVNULL, start_new_session=True)
        p.communicate(data)


def shot(win):
    """One screenshot of the window via the clipboard. niri fills the clipboard a little AFTER the command returns, so a
    sentinel text goes on the clipboard first and we wait until an image replaces it (else we would read the old one)."""
    # wl-copy stays alive to serve the clipboard: never capture its output (run() would wait for it forever)
    subprocess.run(["wl-copy", "vfx-capture-sentinel"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                   stdin=subprocess.DEVNULL)
    subprocess.run(["niri", "msg", "action", "screenshot-window", "--id", str(win), "--write-to-disk", "false"],
                   capture_output=True)
    deadline = time.time() + 1.5
    while time.time() < deadline:
        types = subprocess.run(["wl-paste", "--list-types"], capture_output=True, text=True).stdout.split()
        if "image/png" in types:
            data = subprocess.run(["wl-paste", "--type", "image/png"], capture_output=True).stdout
            if data:
                return Image.open(io.BytesIO(data)).convert("RGB")
        time.sleep(0.02)
    return None


def read_index(img, pts):
    k = 0
    for i, (x, y) in enumerate(pts):
        px = [img.getpixel((x + dx, y + dy)) for dx in (-1, 0, 1) for dy in (-1, 0, 1)]
        lum = sum(0.299 * r + 0.587 * g + 0.114 * b for r, g, b in px) / len(px)
        if lum > 128:
            k |= 1 << i
    return k


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--start", type=int)
    ap.add_argument("--markers", help='viewport pixels "x,y;x,y;..." from VFXCapture.stills')
    ap.add_argument("--times")
    ap.add_argument("--plan", help="JSON from VFXLibPlayer.batch (many effects): writes OUT/<name>/t<t>.png")
    ap.add_argument("--follow", help="JSON list of {name, times} in batch order: no start time needed; each still is "
                    "identified by the marker number it shows (k = running index mod 32)")
    ap.add_argument("--timeout", type=float, default=900, help="--follow: give up after this many seconds")
    ap.add_argument("--hold", type=float, default=2.5)
    ap.add_argument("--gap", type=float, default=0.3)
    ap.add_argument("--viewport", default="368,207", help="viewport top-left inside the Studio window shot")
    ap.add_argument("--out", required=True)
    a = ap.parse_args()
    if a.follow:
        return run_follow(a)
    if a.plan:
        return run_plan(a)
    times = [float(t) for t in a.times.split(",")]
    vx, vy = (int(v) for v in a.viewport.split(","))
    pts = [(int(p.split(",")[0]) + vx, int(p.split(",")[1]) + vy) for p in a.markers.split(";")]
    os.makedirs(a.out, exist_ok=True)
    win = studio_window()
    kind, clip = save_clipboard()
    start = a.start / 1000
    plan, s = [], start
    for k, t in enumerate(times, 1):
        plan.append((k, t, s + t, s + t + a.hold))  # frozen window
        s += t + a.hold + a.gap
    got, tries = [], 0
    try:
        # base: empty stage, all cubes black
        deadline = start - 0.3
        while time.time() < deadline:
            img = shot(win)
            if img and read_index(img, pts) == 0:
                img.save(os.path.join(a.out, "base.png"))
                break
            time.sleep(0.2)
        for k, t, frozen, release in plan:
            if time.time() < frozen + 0.3:
                time.sleep(frozen + 0.3 - time.time())
            ok = False
            while time.time() < release - 0.15:
                img = shot(win)
                tries += 1
                if img and read_index(img, pts) == k % 32:
                    img.save(os.path.join(a.out, f"t{t:.3f}.png"))
                    ok = True
                    break
                time.sleep(0.15)
            got.append((t, ok))
    finally:
        restore_clipboard(kind, clip)
    missed = [t for t, ok in got if not ok]
    print(f"{len(got) - len(missed)}/{len(times)} stills ({tries} shots) in {a.out}"
          + (f"; MISSED {missed} (raise --hold)" if missed else ""))
    if not os.path.exists(os.path.join(a.out, "base.png")):
        print("WARNING: no base shot (start was too soon)")


def run_follow(a):
    """Start-time free: shoot continuously; every time the cubes show a new non-zero number, that is the next still
    of the list (k = index mod 32). A missed still is skipped by matching k against the next 31 expected numbers."""
    items = json.load(open(a.follow))
    shots = [(it["name"], t) for it in items for t in it["times"]]
    vx, vy = (int(v) for v in a.viewport.split(","))
    pts = [(int(x) + vx, int(y) + vy) for x, y in json.loads(a.markers)] if a.markers.startswith("[") else \
        [(int(p.split(",")[0]) + vx, int(p.split(",")[1]) + vy) for p in a.markers.split(";")]
    win = studio_window()
    kind, clip = save_clipboard()
    idx, got, miss, last = 0, 0, [], 0
    deadline = time.time() + a.timeout
    try:
        while idx < len(shots) and time.time() < deadline:
            img = shot(win)
            if not img:
                continue
            k = read_index(img, pts)
            if k == 0 or k == last:
                last = k
                time.sleep(0.1)
                continue
            last = k
            j = next((j for j in range(idx, min(idx + 31, len(shots))) if (j + 1) % 32 == k), None)
            if j is None:
                continue
            for m in range(idx, j):
                miss.append(shots[m])
            name, t = shots[j]
            d = os.path.join(a.out, name)
            os.makedirs(d, exist_ok=True)
            img.save(os.path.join(d, f"t{t:.3f}.png"))
            got += 1
            idx = j + 1
    finally:
        restore_clipboard(kind, clip)
    miss += shots[idx:]
    print(f"{got}/{len(shots)} stills in {a.out}" + (f"; MISSED {miss[:20]}" if miss else ""))


def run_plan(a):
    plan = json.load(open(a.plan))
    vx, vy = (int(v) for v in a.viewport.split(","))
    pts = [(int(x) + vx, int(y) + vy) for x, y in plan["markers"]]
    win = studio_window()
    kind, clip = save_clipboard()
    got = missed = 0
    miss = []
    try:
        for sh in plan["shots"]:
            frozen, release = sh["a"] / 1000, sh["b"] / 1000
            if time.time() > release:
                miss.append((sh["name"], sh["t"])); continue
            if time.time() < frozen + 0.3:
                time.sleep(frozen + 0.3 - time.time())
            ok = False
            while time.time() < release - 0.15:
                img = shot(win)
                if img and read_index(img, pts) == sh["k"]:
                    d = os.path.join(a.out, sh["name"])
                    os.makedirs(d, exist_ok=True)
                    img.save(os.path.join(d, f"t{sh['t']:.3f}.png"))
                    ok = True
                    break
                time.sleep(0.15)
            if ok:
                got += 1
            else:
                miss.append((sh["name"], sh["t"]))
    finally:
        restore_clipboard(kind, clip)
    print(f"{got}/{len(plan['shots'])} stills in {a.out}" + (f"; MISSED {miss[:20]}" if miss else ""))


if __name__ == "__main__":
    main()
