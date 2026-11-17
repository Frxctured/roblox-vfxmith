#!/usr/bin/env python3
"""OPTIONAL, Linux only (uses shot.py: niri). Frozen contact sheet on a shared wall clock, with no image in any
agent context: Studio freezes each frame (fx:Schedule), this script shoots it. Default path on every OS:
fx:Shots + fx:NextShot + MCP screen_capture (knowledge/selfcheck.md).

  START=$(python3 -c 'import time; print(round(time.time() + 10, 3))')
  python3 sched.py luau  $START [--shots shots.json] [--fx _G.kitfx]      -> Luau line: run it with execute_luau (Edit)
  python3 sched.py shoot $START <outdir> --win <id> [--shots shots.json]   -> shoots every frame, then:
  then make the sheet from the files (their names carry camera, time and light)

shots.json = [["player", 0.17, "day"], ...]: camera (player | side | front | bird), clock time in s, day | night.
Default = the 5-camera set of knowledge/selfcheck.md with placeholder times: REPLACE the times with your effect's beats.
Both sides must get the same START and the same shots. PAD seconds between slots (the unfocused viewport redraws ~1/s).
"""
import sys, json, time, subprocess, os, argparse
HERE = os.path.dirname(os.path.abspath(__file__))
SHOT = os.path.join(HERE, "shot.py")
DEFAULT = [
    ["player", 0.14, "day"], ["player", 1.03, "day"], ["player", 1.06, "day"], ["player", 1.10, "day"],
    ["player", 1.16, "day"], ["player", 1.30, "day"], ["player", 2.40, "day"], ["side", 0.14, "day"],
    ["side", 1.03, "day"], ["side", 1.16, "day"], ["front", 1.03, "day"], ["front", 1.16, "day"],
    ["bird", 0.14, "day"], ["bird", 1.03, "day"], ["bird", 1.16, "day"], ["player", 1.16, "night"],
]
PAD = 3.0
ap = argparse.ArgumentParser()
ap.add_argument("mode", choices=["luau", "shoot"])
ap.add_argument("start", type=float)
ap.add_argument("out", nargs="?")
ap.add_argument("--shots")
ap.add_argument("--fx", default="_G.kitfx")
ap.add_argument("--win", default=os.environ.get("WIN"), required="WIN" not in os.environ)
a = ap.parse_args()
shots = json.load(open(a.shots)) if a.shots else DEFAULT
if a.mode == "luau":
    rows = ",".join('{"%s",%s,"%s"}' % tuple(s) for s in shots)
    print("return %s:Schedule({%s}, %s, %s)" % (a.fx, rows, a.start, PAD))
    print("-- takes %.0f s" % (sum(s[1] + PAD for s in shots) + 6), file=sys.stderr)
else:
    os.makedirs(a.out, exist_ok=True)
    slot = 0.0
    for i, (cam, t, lt) in enumerate(shots):
        d = a.start + slot + t + 1.9 - time.time()
        if d > 0: time.sleep(d)
        fn = "%s/%02d_%s_%.2f_%s.jpg" % (a.out, i, cam, t, lt)
        subprocess.run([sys.executable, SHOT, "--win", str(a.win), "--out", fn], capture_output=True)
        print(fn, "late by %.2f s" % (time.time() - a.start - slot - t - 1.9), flush=True)
        slot += t + PAD
