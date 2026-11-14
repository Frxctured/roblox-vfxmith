---
name: vfx-make
description: Build a Roblox VFX effect end to end - from a description ("a cool light beam with an explosion", "ice slam", "purple aura") or a reference video - with library references, a data-driven spec, capture in Roblox Studio, comparison and blind review, iterated to a score bar. Use for "make a VFX", "make it look like this", "improve this effect", any new or reworked effect.
---

# Make a Roblox effect

`ROOT` = the plugin root: `<base directory>/../..` (also `${CLAUDE_PLUGIN_ROOT}`). All paths are relative to ROOT;
resolve it to an absolute path first and quote it (it may contain spaces). Python 3 + Pillow (+ numpy, ffmpeg for
video) run the scripts; Studio is driven through the Studio MCP server (`execute_luau`, `screen_capture`).

Good effects come from a process, not from the prompt: find real references, build the effect as editable data, LOOK
at your result next to the references, let blind reviewers list the differences, fix, repeat.

## 0. Read first
- `knowledge/patterns.md` (section 14: rules shared by ~1,900 effects from experienced artists; 1-13: three tones,
  pops not fades, impact frames, escalation, aftermath).
- `knowledge/categories/<type>.md` for every effect type in the request (index: `knowledge/README.md`).
- `knowledge/spec-format.md` (how an effect is written) and `knowledge/gotchas.md` (Studio and capture traps).

## 1. References (never build from nothing)
- **From a description:** run the `vfx-find` skill, or directly
  `python3 -I "ROOT/kit/scripts/find_effects.py" "<the request>"`. For each part of the request, read the 2-3 best
  cards in `library/cards/` (exact layer values) and LOOK at their frames in `gallery/effects/` (when a card has
  none, play the effect: `vfx-find` section 3). Pick 1-2 as the visual target for framing, size, phases and colour.
- **From a video:** give it a folder (`refs/<slug>/`: `source.mp4`, contact sheets at 2 fps, ONE cycle at 30 fps with
  frame numbers burnt in, full-size key frames, all with ffmpeg). LOOK at every sheet. Write `analysis.md`: phase
  timeline in seconds and frames (t0 = first frame of the effect), one row per layer (look + likely build), palette hex,
  how colour ages, rhythm (build -> quiet beat -> payoff -> linger), world grade (sky/ground RGB before/during/after).
  Then still run `find_effects.py` for the closest library effects: their layer values are your starting numbers.

## 2. Start from a recipe
- Copy `knowledge/categories/<type>_recipe.luau` into your effect folder as `<Name>.luau` and change its `name`.
  How each recipe plays as it is: `gallery/recipes/<type>_recipe.jpg` (look first: know what you start from).
- **Combined effects** ("a light beam with an explosion"): one spec, both recipes' layers in one `layers` list. Prefix
  ids per part (`beam_core`, `boom_flash`), shift the second part's `t` values to where it should start (e.g. the
  explosion at the beam's impact, t = beam length), move its `at` positions to that point, merge palettes and texture
  tables, and drop duplicate roles (one flash, one light, one grade). Keep the total around 150 particles at the peak.
- Adapt to the request: palette (three tones: white core, saturated body, dark ink), size (`scale` or the recipe's
  base size), extra layers from the category note's anatomy table, values from the library cards.
- Textures: `knowledge/texture-vocab.md` by role (contact sheets: `gallery/textures/`); avoid the ids it lists as not
  loading. Own textures/meshes: section 7.

## 3. Install the kit in Studio (no Rojo, no upload)
```bash
python3 -I "ROOT/kit/scripts/rbx_assets.py" local "ROOT/kit/runtime/VFXTimeline.luau" "ROOT/kit/studio/VFXCapture.luau" \
    "ROOT/kit/studio/VFXLibPlayer.luau" <your effect>.luau --name devkit
```
This writes `<Studio content folder>/vfxlib/devkit.rbxmx` (Studio reads its own content folder as `rbxasset://`; the
script finds it on Windows, macOS and Linux/Vinegar). Then with MCP `execute_luau` (Edit mode):
```lua
local SS = game.ServerStorage
local dev = SS:FindFirstChild("VFXDev") or Instance.new("Folder", SS); dev.Name = "VFXDev"
local fx = dev:FindFirstChild("Effects") or Instance.new("Folder", dev); fx.Name = "Effects"
local assets = dev:FindFirstChild("Assets") or Instance.new("Folder", dev); assets.Name = "Assets"
for _, m in ipairs(game:GetObjects("rbxasset://vfxlib/devkit.rbxmx")[1]:GetChildren()) do
	local parent = (m.Name == "VFXTimeline" or m.Name == "VFXCapture" or m.Name == "VFXLibPlayer") and dev or fx
	local old = parent:FindFirstChild(m.Name); if old then old:Destroy() end
	m.Parent = parent
end
```
Re-install only what changed (usually the spec). When done: `C.clear()` and destroy `ServerStorage.VFXDev` unless the
user wants the kit kept in that place.

## 4. First play: does it run?
```lua
local C = require(game.ServerStorage.VFXDev.VFXCapture:Clone())
C.stage("void")                                        -- black box far above the map ("day" = grey floor under the sky)
C.camera({ dist = 30, height = 6, lookUp = 4, fov = 70 }) -- frame like your reference; world +X is screen LEFT
return C.hold("<Name>", 0.15)                           -- plays and freezes at t = 0.15 s
```
Then MCP `screen_capture` and LOOK. Check the Output (MCP `get_console_output`) for `[VFXTimeline]` warnings: a layer
with a bad property or a texture that does not load. Fix before going on. Adjust the camera until the effect fills about
half the frame height and sits where the reference has it.

## 5. Capture a timeline
- **Any OS (default):** for t in 0.03, 0.1, 0.2, 0.35, 0.55, 0.8, 1.2, 1.8, 2.6 (to the effect's end): `C.hold("<Name>", t)`
  then `screen_capture`; the tool result names the saved file: copy it to `<effect>/vN/t<t>.jpg`. Take one frame of the
  empty stage first as `<effect>/vN/base.jpg`. LOOK at every frame.
- **Real-time video** (only when the user has Studio focused, or asks for it): `C.playLater("<Name>", 3.5)` then
  `kit/scripts/record.sh <effect>/vN.mp4 9` (Linux/Wayland with wf-recorder; elsewhere use any screen recorder).
- **Many stills unattended (Linux + niri):** `VFXCapture.batch(items)` + `kit/scripts/stills.py --follow` (frames are
  identified by on-screen marker squares, no timing to copy). Run ONE effect first and look at it.
- The camera must not move during capture: the modules set `Camera.Focus` with the camera and lock it; do not click in
  the viewport meanwhile.

## 6. Compare and review
```bash
python3 -I "ROOT/kit/scripts/gallery_frames.py" "ROOT/gallery/effects/<type>/<id>.jpg" --out <effect>/ref   # library reference
python3 -I "ROOT/kit/scripts/compare.py" --ref <effect>/ref|<ref.mp4> --ours <effect>/vN \
    --times 0.03,0.1,0.2,0.35,0.55,0.8,1.2 --out <effect>/cmp_vN --label vN
```
(`--ref` = a folder of frames or a video with `--ref-t0`; `--ours-crop x,y,w,h` if your frames include more than the
viewport.) Match framing first (box, ground line, centre). Then run `vfx-review` (3 blind reviewers) on
`cmp_vN/pairs.png`, `curves.png`, `metrics.json`. Merge: fix what 2+ reviewers flag first, change by half steps when one
says "much too much", never break what they said matches. Log each round in `<effect>/LOG.md`.

## 7. Iterate, then finish
Repeat 5-6 until every lens scores >= 8.5, or 2 rounds gain < 0.5 (then report what still differs and why). Then a
daylight check (`C.stage("day")`), a game-fit pass (scale, Reduced Motion: no grade flashes, `VFXTimeline.Quality` 0.6
on phones, ~150 particles at the peak, one light), and only if the user wants it in a game: copy
`kit/runtime/VFXTimeline.luau` + the spec (+ assets) into the project, played on the client
(`VFXTimeline.play(spec, cframe)`; the server only sends "play <Name> at <cframe>").

Own textures (PIL) and meshes (Blender; vertex colours white -> light grey >= 0.85 so Neon tints them): upload with
`kit/scripts/rbx_assets.py upload <files> --ids ids.json` (Open Cloud key in `~/.config/roblox/env`: `RBX_API_KEY`,
`RBX_USER_ID`); group games also need `rbx_assets.py grant --universe <id> --from ids.json`. Fresh meshes are invisible
in Studio for a few minutes. Worked example of a full run (9 versions, 4 review rounds): `kit/examples/VoidRend/`.

## 8. Learn
New traps -> `knowledge/gotchas.md`; rules that hold across effects -> `knowledge/patterns.md`; type-specific lessons
-> `knowledge/categories/<type>.md`.

## Optional: the LihFolk vault
If `lihfolk:*` skills are listed in the session: ask `lihfolk:lihfolk` for engine facts you are unsure of,
`lihfolk:lihfolk-vfx` has slash/ability presets and a VFX rubric, `lihfolk:roblox-blender-modeling` a mesh gate and
the Blender helpers (only needed to regenerate the VoidRend meshes). Nothing here requires it; never block on it.
