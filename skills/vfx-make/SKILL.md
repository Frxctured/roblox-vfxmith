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

**Full mode is the default.** Run every request through the whole loop (steps 1-7: iterate captures and review
panels to the score bar). It costs about an hour and ~500-700k tokens. Two blind tests on 2026-11-14 measured why:
the full loop beat a plain agent 7.5 to 7.0, while quick mode (one panel, fixes, no second check) LOST 5.5 to 7.5:
the effect shipped at the level its first panel had scored.
- **Quick** only when the user explicitly asks for speed ("quick", "rough draft", "just something fast"): steps 1-4,
  one capture set on both backdrops, one review panel, its shared fixes, then ONE more panel (or at least a re-capture
  you score against 7) before finishing. Say that it is a draft and what the full loop would still fix.

## 0. Read first
- `knowledge/patterns.md` (section 14: rules seen across the library's ~1,900 catalogued effects by experienced
  artists; 1-13: three tones, pops not fades, impact frames, escalation, aftermath).
- `knowledge/categories/<type>.md` for every effect type in the request (index: `knowledge/README.md`).
- `knowledge/spec-format.md` (how an effect is written) and `knowledge/gotchas.md` (Studio and capture traps).
- `knowledge/patterns.md` section 15 (what lost points in the blind tests: daylight, clutter, repeated beats, payoff
  scale, style, texture traps) and the "Traps" section at the top of `knowledge/texture-vocab.md`.
- `knowledge/design-brief.md` (the questionnaire and the brief: step 0b).

## 0b. Brief: ask, then plan (before anything else)
Follow `knowledge/design-brief.md`: ask the user the short questionnaire, only the questions their request leaves
open (none if it is descriptive; defaults from the wording if they are away), then write `<effect>/brief.md`: purpose
and scale, total length, peak time, the beats with their hero shape and size at gameplay distance, style, palette,
lighting, budget, capture camera. Everything after this serves the brief.

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
- **Fit it to the brief** (`design-brief.md` section 4): scale each part to the size the brief gives, retime its layers
  to the brief's beats, keep one hero shape per beat. Recipes are sized and timed for an average library effect; the
  brief decides how big, when and how long.
- **Combined effects** ("a light beam with an explosion", "an ice dash into a slash", "a portal that spits fire"):
  one spec, both recipes' layers in one `layers` list. Prefix
  ids per part (`beam_core`, `boom_flash`), shift the second part's `t` values to where it should start (e.g. the
  explosion at the beam's impact, t = beam length), move its `at` positions to that point, merge palettes and texture
  tables, and drop duplicate roles (one light, one grade). If both parts keep a flash or burst, give them DIFFERENT
  shapes and make the later one bigger (the payoff is the biggest beat). Keep the total around 150
  particles at the peak, bright-white streaks and needles at the payoff to ~25, and one hero shape per beat
  (patterns.md 15).
- Adapt to the request: palette (three tones: white core, saturated body, dark ink), size (`scale` or the recipe's
  base size), extra layers from the category note's anatomy table, values from the library cards. Keep ONE rendering
  style, the user's (toon with outlines, or soft glow; patterns.md 15.7): never fix one beat by switching style.
- Textures: `knowledge/texture-vocab.md` by role (contact sheets: `gallery/textures/`); avoid the ids it lists as not
  loading. Its `traits` column (also `gallery/textures/traits.json`) says per texture: white or coloured, transparent
  or on a black/faint card, single or multi-part, effective resolution. Check every id your spec uses
  (`python3 -I "ROOT/kit/scripts/texture_traits.py" <id> ...`; `C.check` lists them) and avoid: a coloured texture
  tinted to another hue (muddy), a black or faint card at LightEmission < 1 (a dark square), a multi-line texture as
  one streak (combs), art drawn bigger on screen than its effective resolution (stair steps). When you swap a
  texture, scale the layer's Size by old fill / new fill, or the shape grows or shrinks on screen. Own
  textures/meshes: section 7.
- Sizes: a particle's Size is its HALF-width (Size N = 2N studs across); beam widths and part sizes are full widths.

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

## 4. Check, then first play: does it run?
```lua
local C = require(game.ServerStorage.VFXDev.VFXCapture:Clone())
return C.check("<Name>")      -- ERROR / WARN lines, then peaks (particles, streaks, layers) and the textures used
```
Fix every ERROR and WARN before capturing (run it after EVERY spec edit: in the blind test a comment that swallowed a
layer's Transparency went unseen for two review rounds). Then:
```lua
local C = require(game.ServerStorage.VFXDev.VFXCapture:Clone())
C.stage("void")                                        -- black box far above the map ("day" = default baseplate)
C.camera({ dist = 30, height = 6, lookUp = 4, fov = 70 }) -- frame like your reference; world +X is screen LEFT
return C.hold("<Name>", 0.15)                           -- plays and freezes at t = 0.15 s
```
Then MCP `screen_capture` and LOOK. Check the Output (MCP `get_console_output`) for `[VFXTimeline]` warnings: a layer
with a bad property or a texture that does not load. Fix before going on. Adjust the camera until the effect fills about
half the frame height and sits where the reference has it. The capture functions preload textures; the very first
play after a load can still miss a few: hold again if a frame looks incomplete.

## 5. Capture a timeline
- **Any OS (default):** for t in 0.03, 0.1, 0.2, 0.35, 0.55, 0.8, 1.2, 1.8, 2.6 (to the effect's end): `C.hold("<Name>", t)`
  then `screen_capture`; the tool result names the saved file: copy it to `<effect>/vN/t<t>.jpg`. Take one frame of the
  empty stage first as `<effect>/vN/base.jpg`. LOOK at every frame.
- **Both backdrops, every version.** The void stage flatters (dark layers vanish into it, additive ones look
  brighter); the blind-test effect lost most of its lead on a daylight baseplate. After the void set, capture the same
  times on `C.stage("day")` (a copy of the default Roblox baseplate; add `{ lighting = "default" }` if the place is
  dark) into `<effect>/vN_day/`, at gameplay distance (`dist` about 1.5x the void framing). When the effect is for
  the user's open place, use `C.stage("place", { at = <Vector3 on their map> })` instead.
- **Real-time video** (only when the user has Studio focused, or asks for it): `C.playLater("<Name>", 3.5)` then
  `kit/scripts/record.sh <effect>/vN.mp4 9` (Linux/Wayland with wf-recorder; elsewhere use any screen recorder).
- **Many stills unattended (Linux + niri):** `VFXCapture.batch(items)` + `kit/scripts/stills.py --follow` (frames are
  identified by on-screen marker squares, no timing to copy). Run ONE effect first and look at it.
- The camera must not move during capture: the modules set `Camera.Focus` with the camera and lock it; do not click in
  the viewport meanwhile.

## 6. Compare and review
A reference card without frames: if the pack is installed, capture it like your own effect (`vfx-find` section 3,
`P.batch` + `stills.py --follow`) into `<effect>/ref`, same camera and times.
```bash
python3 -I "ROOT/kit/scripts/gallery_frames.py" "ROOT/gallery/effects/<type>/<id>.jpg" --out <effect>/ref   # library reference
python3 -I "ROOT/kit/scripts/compare.py" --ref <effect>/ref|<ref.mp4> --ours <effect>/vN \
    --times 0.03,0.1,0.2,0.35,0.55,0.8,1.2 --out <effect>/cmp_vN --label vN
```
(`--ref` = a folder of frames or a video with `--ref-t0`; `--ours-crop x,y,w,h` if your frames include more than the
viewport.) Match framing first (box, ground line, centre). Then run `vfx-review` (3 blind reviewers) on
`cmp_vN/pairs.png`, `curves.png`, `metrics.json` and the `vN_day/` frames, with the scale that fits the request:
"match" for a reference video, ABSOLUTE quality for a description (a resemblance scale stalls at ~6 on new effects).
Merge: fix what 2+ reviewers flag first, change by half steps when one says "much too much", never break what they
said works. Log each round in `<effect>/LOG.md`.

## 7. Iterate, then finish
Full mode: repeat 5-6 until every lens scores >= 8.5, or until two rounds IN A ROW each gain < 0.5 on average.
After the first flat round, change approach for the next one (attack the biggest shared complaint with a bigger
change) instead of stopping; after the second, report what still differs and why. Then a game-fit pass (scale,
Reduced Motion: no grade flashes, `VFXTimeline.Quality` 0.6 on phones, ~150 particles and ~25 bright-white streaks at
the peak, one light; `C.check` prints these), and only if the user wants it in a game: copy
`kit/runtime/VFXTimeline.luau` + the spec (+ assets) into the project, played on the client; the server only sends
"play <Name> at <cframe>":
```lua
local VFXTimeline = require(ReplicatedStorage.VFXTimeline)
local spec = require(ReplicatedStorage.VFX.<Name>)
VFXTimeline.preload(spec)            -- once at load, or the first play misses textures
-- on the server's message:
VFXTimeline.play(spec, cframe)
```

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
