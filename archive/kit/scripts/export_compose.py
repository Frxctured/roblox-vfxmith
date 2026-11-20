#!/usr/bin/env python3
"""One self-contained Luau file for a composed effect: VFXCompose + the spec inlined, and two global functions that
play and stop it. Run the result once in Studio (command bar or MCP execute_luau, Edit mode).

    python3 -I kit/scripts/export_compose.py <spec.luau> --out final.luau [--globals BlindTestPlay,BlindTestStop]
                                             [--pieces-dir <dir>]

The spec is a Luau chunk that returns the spec table (knowledge/compose-spec.md). The pieces it names are loaded at
run time from Studio's content folder (rbxasset://vfxlib/fx_<id>.rbxmx, written by compose.py --cut). This script
checks that every piece file is there and copies them into --pieces-dir (default: <out dir>/pieces) so the effect can
be restored later: copy them back into <Studio content>/vfxlib/, or re-run compose.py --cut <id>.

Defines: _G.<Play>(origin: Vector3, freezeAt: number?) plays once with the base at origin; with freezeAt everything
holds still at exactly that effect time until _G.<Stop>(); the call returns once that frame is built. Calling Play
again first stops the previous play.
"""
import argparse
import os
import re
import shutil
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
COMPOSE = os.path.join(HERE, "..", "studio", "VFXCompose.luau")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("spec")
    ap.add_argument("--out", required=True)
    ap.add_argument("--globals", default="VFXPlay,VFXStop")
    ap.add_argument("--pieces-dir")
    a = ap.parse_args()
    play, stop = [g.strip() for g in a.globals.split(",")]
    for g in (play, stop):
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", g):
            sys.exit("bad global name: " + g)
    spec = open(a.spec).read().rstrip()
    if not re.search(r"^\s*return\b", spec, re.M):
        sys.exit("the spec must be a Luau chunk that returns the spec table (return { ... })")
    files = sorted(set(re.findall(r'file\s*=\s*"([^"]+)"', spec)))
    if not files:
        sys.exit("no pieces (file = \"fx_<id>\") in the spec")
    sys.path.insert(0, HERE)
    from rbx_assets import content_dir
    lib = os.path.join(content_dir(), "vfxlib")
    pdir = a.pieces_dir or os.path.join(os.path.dirname(os.path.abspath(a.out)), "pieces")
    os.makedirs(pdir, exist_ok=True)
    missing = []
    for f in files:
        src = os.path.join(lib, f + ".rbxmx")
        if os.path.exists(src):
            shutil.copy2(src, os.path.join(pdir, f + ".rbxmx"))
        elif os.path.exists(os.path.join(pdir, f + ".rbxmx")):
            shutil.copy2(os.path.join(pdir, f + ".rbxmx"), src)  # restore from an earlier export
        else:
            missing.append(f)
    if missing:
        sys.exit("missing in %s: %s (run compose.py --cut <id> first)" % (lib, ", ".join(missing)))
    compose = open(COMPOSE).read().rstrip()
    name = (re.search(r'name\s*=\s*"([^"]+)"', spec) or [None, os.path.splitext(os.path.basename(a.spec))[0]])[1]
    out = f"""-- {name}: composed effect exported by vfxmith kit/scripts/export_compose.py. Run once in Studio (Edit mode).
-- Pieces (pro open-source effects, scripts removed) load from Studio's content folder:
--   {", ".join("vfxlib/" + f + ".rbxmx" for f in files)}
-- Copies are in {os.path.relpath(pdir, os.path.dirname(os.path.abspath(a.out)))}/ next to this file; if Studio lost them, copy them back into
-- <Studio content>/vfxlib/ or run: python3 -I kit/scripts/compose.py --cut {" ".join(f[3:] if f.startswith("fx_") else f for f in files)}
--   _G.{play}(origin: Vector3, freezeAt: number?)   play once with the base at origin (freezeAt: hold at that time)
--   _G.{stop}()                                    stop and remove the current play
--   _G.VFXCompose.measure() / .coverage(origin, cam)  measured piece sizes / frame coverage from camera position cam
local __Compose = (function()
{compose}
end)()

local __Spec = (function()
{spec}
end)()

print("[{name}] " .. __Compose.build(__Spec))
_G.VFXCompose = __Compose
_G.{play} = function(origin, freezeAt)
	return __Compose.play(origin, freezeAt)
end
_G.{stop} = function()
	return __Compose.stop()
end
return "{name} ready: _G.{play}(origin, freezeAt?) / _G.{stop}()"
"""
    open(a.out, "w").write(out)
    print("wrote %s (%d pieces: %s; copies in %s)" % (a.out, len(files), ", ".join(files), pdir))


if __name__ == "__main__":
    main()
