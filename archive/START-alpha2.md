# START HERE: making a Roblox VFX effect with this folder (vfxmith 1.0.0-alpha2)

You have Roblox Studio through the Studio MCP tools and this folder. Do these steps in order. Do not read the whole
folder: `knowledge/archive/` is the old 0.1.x pack (about 40k tokens) and is NOT needed.

`ROOT` = this folder (quote it, it may contain spaces). Run Python as `python3 -I "$ROOT/kit/scripts/<tool>.py"`.

## Why it works this way
Models pick textures and layouts badly when they invent them from numbers, and code-made textures look generic.
So you never invent the look: you start from REAL professional effects (1,927 open-source pro effects with exact
data), load their actual instance trees into Studio, and adapt colour, scale, timing and placement to the request.
Combine pieces when one effect does not cover the request (e.g. a pro projectile + a pro impact).

## 1. Read (about 10 minutes of tokens, once)
- `knowledge/guide.md`: the craft rules (what to keep, change and check). Read all of it.
- `knowledge/compose-spec.md`: the spec format you will write.
- For a specific question later: `python3 -I "$ROOT/vault/_tools/vault.py" "<question>"` (research notes; `--read
  "<note title>" "<section>"` for one section). Don't browse the vault folder.

## 2. Brief
Write `brief.md` in your work folder: parts of the effect, where it lives (ground / on a character / flying /
between two points), size in studs and character heights (R15 = about 5 studs), timing (length, contact moment,
residue), palette (identity hue, support, dark remnant), and two lines that alpha1 missed (guide section 1):
- **Style register**: grounded, stylized, anime/battlegrounds, cute/cosy, sci-fi, ... from the request's words or the
  game, else "unspecified" (never battlegrounds by default).
- **Named elements**: a table of every thing the request names, its role and the times it must be on screen (e.g.
  the thrown object, a cloud that lingers, the player). The fault check confirms each one.
If the request leaves something essential open and you may ask, ask once; otherwise decide.

## 3. Find and look at compositions
```
python3 -I "$ROOT/kit/scripts/compose.py" "<the request in plain words>" --size <main size in studs>
```
It prints the best 3 pro effects per part of the request with their layer tables, ranked by type and by fit to the
style register (the first line says which style it read; `--style <name>` to set it, `--style any` to turn it off),
plus each one's style, estimated size and starting scale. A named element no piece covers (a mesh role: stone, ice,
an object): `compose.py --meshes "<role words>" --style <style>` lists pro meshes for it. Then:
1. Cut the 2-4 most promising into Studio's content folder (scripts are removed):
   `python3 -I "$ROOT/kit/scripts/compose.py" --cut <id> <id> ...`
2. LOOK at them: write a one-piece spec per candidate (`return { name = "look", folder = "<your folder>",
   dummy = true, length = 3, pieces = { { file = "fx_<id>" } } }`), export it (step 4 command), run it, then for
   2-3 moments (e.g. 0.1, 0.4, 1.0 s): `_G.VFXPlay(Vector3.new(0, 0, 0), t)` -> camera -> `screen_capture`.
   A Studio place may have other things at the origin: pick an empty spot (e.g. `Vector3.new(0, 500, 0)` with a
   floor part under it you create in your folder) and use it for every capture.
3. Choose by what you SAW (clear big shapes, dark partners, ground anchor, fits the request and its style
   register), not by the numbers. Usually one piece per part; at most 3-4 pieces in total. Every named element needs
   a piece (or a layer of one) that shows it.

## 3b. Scale to the scene first (before any styling)
Put all chosen pieces in the spec untouched with `dummy = true`, export + run it (step 4 commands), and run
`return _G.VFXCompose.measure()` with execute_luau (the build summary printed in the output has the same sizes). Then give every
piece `size = <the brief's studs for that part>` (`sizeBy = "height"` for pillars/spikes, `"largest"` for a flash)
and build again: `C.measure()` must now be within 30% of the brief, and no single layer much bigger than its piece
(shrink it with `set` or drop it). Capture one frame with the dummy beside the effect at its widest to see it.
Only then tint, retime and restyle.

## 4. Build = adapt the chosen pieces
Write `spec.luau` (format: `knowledge/compose-spec.md`): keep the `size` values from step 3b, `tint` to the brief's hue,
`speed`/`delay` for timing, `at`/`rot`/`yaw` for placement, `move` for anything that travels, `drop` for layers that
don't belong, `set` for values, and push the pieces toward the style register with values only (guide section 2b: grounded =
fewer, softer flashes and more lit volume; stylized = crisp shapes; cute = round, soft, no dark smoke; sci-fi = clean
lines). Streaks follow the motion path (guide 2c): arcs for a swirl or orbit, straight lines for a burst or dash.
Texture swaps only to pro textures from `compose.py --swap <texture id>`. Never draw
textures or meshes in code; never replace a pro texture with a made one. `C.layers(i)` (or `compose.py --show <id>`)
lists layer names for `drop`/`set`.

Run it in Studio:
```
python3 -I "$ROOT/kit/scripts/export_compose.py" spec.luau --out final.luau --globals BlindTestPlay,BlindTestStop
python3 -I "$ROOT/kit/scripts/kit_push.py" final.luau     # prints ONE line: run it with execute_luau (Edit mode)
```
(Use whatever global names your task asks for; the default without `--globals` is VFXPlay/VFXStop.) Never paste the
whole file into execute_luau: kit_push makes it a short loadstring line. Camera for captures: pass
`camera_position` / `look_at_position` to `screen_capture` (front-right of the dummy, which faces -Z: camera at
origin + (14, 7, -16) looking at origin + (0, 2.5, 0); top-down: origin + (0, 30, 0.01)).

## 5. Fault check (objective only, once or twice)
Capture 6-8 moments over the effect's life: `_G.BlindTestPlay(origin, t)` then `screen_capture`, then
`_G.BlindTestStop()`. Include each named element's time from the brief, one frame with the dummy beside the effect
at its widest, the peak frame from the standard camera with `return _G.VFXCompose.coverage(origin, origin + Vector3.new(14, 7, -16))` read there, and one top-down view at
the peak. Check ONLY the faults in `knowledge/guide.md` section 6 (nothing visible, missing part, wrong scale = more
than 30% off the brief or the largest layer over 60% of the frame, off-frame, timing far off, colour off-brief,
broken frames, a named element not visible at its time, streaks against the motion path, the opposite style
register). Fix with the
smallest change, re-export, re-check the affected moments. Do not iterate on taste: the pieces' quality came from
their artists; your changes are what can break it.

## 6. Finish
- `final.luau` is self-contained except for the piece files: export_compose copies them into `pieces/` next to it,
  and they stay in Studio's content folder (`vfxlib/fx_<id>.rbxmx`). Test final.luau in a clean state: delete your
  work folder in Workspace, run the kit_push line again, then `_G.BlindTestPlay(origin)` and
  `_G.BlindTestPlay(origin, 0.3)` + `_G.BlindTestStop()`.
- Report: the pieces used (ids and what each does), what you changed, the frames you captured with their times.

## If something fails
- `compose.py --cut` says the file is not found: the pack is missing (`python3 kit/scripts/get_pack.py --where`).
- `cannot load rbxasset://vfxlib/...`: run the `--cut` for that id again (Studio updates move the content folder).
- A piece plays nothing: it was script-driven; pick another candidate (prefer "N/M layers EmitCount-driven" high).
- A VFXCompose error: the file is `kit/studio/VFXCompose.luau`; fix your copy if needed and note it in your report.
