#!/usr/bin/env python3
"""One self-contained Luau file for an effect: the VFXTimeline runtime and the spec inlined, textures preloaded, and two
global functions to play and stop it. Paste it into Studio's command bar (or MCP execute_luau) in ANY place to preview
or share the effect; no files, modules or uploads needed (meshes and textures are asset ids).

    python3 -I export_effect.py <Name>.luau --out final.luau [--globals VFXPlay,VFXStop] [--seed 7]

Defines (names from --globals):
  _G.VFXPlay(origin: Vector3, freezeAt: number?)  plays the effect once with its base at origin. With freezeAt the whole
      effect (timeline, particles, beams, custom layers) holds still at exactly that time until _G.VFXStop(); the call
      yields until that frame is built. Calling it again first stops the previous play.
  _G.VFXStop()  stops and removes the current play at once.
Each play lives in its own folder in Workspace; an unfrozen play removes itself when it ends.
Limits: template parts from VFXDev.Assets are not inlined (put them in ReplicatedStorage.VFXAssets in that place).
For a game, use the runtime + spec as ModuleScripts on the client instead (vfx-make step 7).
"""
import argparse
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
RUNTIME = os.path.join(HERE, "..", "runtime", "VFXTimeline.luau")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("spec")
    ap.add_argument("--out", required=True)
    ap.add_argument("--globals", default="VFXPlay,VFXStop")
    ap.add_argument("--seed", type=int, default=7)
    a = ap.parse_args()
    play_name, stop_name = [g.strip() for g in a.globals.split(",")]
    for g in (play_name, stop_name):
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", g):
            raise SystemExit("bad global name: " + g)
    runtime = open(RUNTIME).read().rstrip()
    spec = open(a.spec).read().rstrip()
    m = re.search(r'name\s*=\s*"([^"]+)"', spec)
    name = m.group(1) if m else os.path.splitext(os.path.basename(a.spec))[0]
    key = re.sub(r"[^A-Za-z0-9_]", "_", name)
    head = f"""-- {name}: self-contained preview/share script made by vfxmith kit/scripts/export_effect.py. Run it ONCE in Studio
-- (command bar or MCP execute_luau) in any place: the VFXTimeline runtime (vfxmith kit, MIT) and the {name} spec are
-- inlined below. Then:
--   _G.{play_name}(origin: Vector3, freezeAt: number?)  play once at origin (freezeAt: hold still at that time)
--   _G.{stop_name}()                                   stop and remove the current play
-- Textures and meshes are Roblox asset ids; check their licences before shipping them in a game.
"""
    api = f"""
local RunService = game:GetService("RunService")
local KEY = "__vfxexport_{key}"
local S = _G[KEY] or {{}}
_G[KEY] = S
if S.handle then pcall(S.handle.stop) end
if S.holder then pcall(game.Destroy, S.holder) end
S.handle, S.holder = nil, nil
pcall(VFXTimeline.preload, Spec)

_G.{stop_name} = function()
	local h, holder = S.handle, S.holder
	S.handle, S.holder = nil, nil
	if h then pcall(h.stop) end
	if holder then holder:Destroy() end
end

_G.{play_name} = function(origin: Vector3, freezeAt: number?)
	_G.{stop_name}()
	local holder = Instance.new("Folder")
	holder.Name = "{key}_Play"
	holder.Parent = workspace
	local h = VFXTimeline.play(Spec, CFrame.new(origin), {{
		important = true, seed = {a.seed}, freezeAt = freezeAt, parent = holder,
		onDone = function()
			if S.holder == holder then S.handle, S.holder = nil, nil end
			holder:Destroy()
		end,
	}})
	S.handle, S.holder = h, holder
	if freezeAt then
		local t0 = os.clock()
		while h.time() < freezeAt and os.clock() - t0 < freezeAt + 5 do RunService.Heartbeat:Wait() end
		RunService.Heartbeat:Wait() -- one more rendered frame in the frozen state
	end
	return h
end

return string.format("{name} ready: _G.{play_name}(origin, freezeAt?) / _G.{stop_name}(); %.2f s, %d layers",
	VFXTimeline.length(Spec), #Spec.layers)
"""
    out = head + "\nlocal VFXTimeline = (function()\n" + runtime + "\nend)()\n\nlocal Spec = (function()\n" + spec + "\nend)()\n" + api
    os.makedirs(os.path.dirname(os.path.abspath(a.out)), exist_ok=True)
    open(a.out, "w").write(out)
    print(f"{a.out}: {len(out)} bytes, {name}, _G.{play_name} / _G.{stop_name}")


if __name__ == "__main__":
    main()
