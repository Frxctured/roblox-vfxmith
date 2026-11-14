---
name: vfx-make
description: Build a Roblox VFX effect end to end - from a description ("a cool light beam with an explosion", "ice slam", "purple aura") or a reference video - with library references, a data-driven spec, capture in Roblox Studio, comparison and blind review, iterated to a score bar. Use for "make a VFX", "make it look like this", "improve this effect", any new or reworked effect.
---

# Make a Roblox effect

`ROOT` = the plugin root: `<base directory>/../..` (also `${CLAUDE_PLUGIN_ROOT}`). All paths are relative to ROOT;
resolve it to an absolute path first and quote it (it may contain spaces). Python 3 + Pillow (+ numpy, ffmpeg for
video) run the scripts; Studio is driven through the Studio MCP server (`execute_luau`, `screen_capture`).

Good effects come from a process, not from the prompt: settle what the user wants, find real references, build the
effect as editable data, look at it in daylight, let blind reviewers list the differences, fix.

**Cheap by design.** The loop hands its heavy reading and capturing to helpers, so the builder's own context stays
small (every turn re-reads it):
- the **librarian** (`vfx-librarian`, fast model) reads the library and returns the layer values to copy;
- the **capturer** (`vfx-capturer`, fast model) takes the freeze frames and returns one contact sheet per backdrop;
- the **reviewers** are fresh agents that see the full frames.
The builder reads `knowledge/builder-notes.md` instead of the whole knowledge folder and looks at sheets, not frames.
(Blind test 3, 2026-11-14: the 0.1.5 loop scored 7.5 against 6.0 without the plugin but cost 3.3x the tokens. About
two thirds of its context by the end was screenshots it took one by one, and every one of its 212 turns re-read them.)

**Modes.** Full is the default: steps 0-7 with at most TWO review panels.
- **Quick** only when the user asks for speed ("quick", "rough draft"): one panel, its shared fixes, then a final
  capture you check against the brief yourself. Say it is a draft.
- **Polish** only when the user asks for the best possible result: a third panel if the second gained 0.5 or more.

## 0. Brief: ask, then plan (in the conversation with the user)
Follow `knowledge/design-brief.md`: ask only the questions the request leaves open (none if it is descriptive;
defaults from the wording if the user is away), then write `<effect>/brief.md`: purpose and scale, total length, peak
time, the beats with their hero shape and size in studs, motion (stays, follows, travels; pulls in or throws out),
style, palette, lighting, budget, capture camera. Everything after this serves the brief.

**Then hand off.** If this conversation already holds other work, spawn ONE builder agent (`vfxmith:vfx-builder`, or a
general-purpose agent told to read and follow `ROOT/agents/vfx-builder.md`) with `ROOT=<root>`, the effect folder, the
Studio id and the mode, and wait for its report: it runs steps 1-7 in a fresh context. If the request opened the
conversation, or you are an agent spawned for this effect, run steps 1-7 yourself.

## 1. Read (only these)
- `knowledge/builder-notes.md`: the look rules, texture and Studio traps, and the token rules. Keep to them.
- `knowledge/spec-format.md`: how an effect is written.
- `knowledge/categories/<type>.md` for each effect type in the request: its anatomy and timing tables (index:
  `knowledge/README.md`).
Anything else: `grep -n` the term in `knowledge/`, then read that section only.

## 2. References (never build from nothing)
- **From a description:** spawn the librarian (`vfxmith:vfx-librarian`, or a general-purpose agent with model `haiku`
  told to follow `ROOT/agents/vfx-librarian.md`) with `ROOT=<root>`, the request and the brief's beats. Save its reply
  as `<effect>/refs.md`. Look at the frame sheets of the 1-2 references it ranks best (`gallery/effects/...`, one image
  each) for framing, size, phases and colour.
- **From a video:** give it a folder (`refs/<slug>/`: `source.mp4`, contact sheets at 2 fps, one cycle at 30 fps with
  frame numbers burnt in, full-size key frames, all with ffmpeg). Look at the sheets. Write `analysis.md`: phase
  timeline in seconds and frames (t0 = first frame of the effect), one row per layer (look + likely build), palette
  hex, how colour ages, rhythm (build -> quiet beat -> payoff -> linger), world grade. Then still ask the librarian for
  the closest library effects: their layer values are your starting numbers.

## 3. Start from a recipe
- Copy `knowledge/categories/<type>_recipe.luau` into the effect folder as `<Name>.luau` and change its `name`. How it
  plays as it is: `gallery/recipes/<type>_recipe.jpg`.
- **Fit it to the brief** (`design-brief.md` section 4): scale each part to the brief's size in studs, retime its
  layers to the brief's beats, keep one hero shape per beat. Take values from `refs.md`.
- **Combined effects** ("a beam with an explosion", "a portal that spits fire"): one spec, both recipes' layers in one
  `layers` list, ids prefixed per part (`beam_core`, `boom_flash`), the second part's `t` shifted to where it starts,
  its `at` moved to that point, palettes and texture tables merged, duplicate roles dropped (one light, one grade). A
  later flash or burst gets a different shape and is bigger.
- Palette: three tones (white core, saturated body, dark ink). ONE rendering style, the user's.
- Textures: from `refs.md` and the recipe; check every id with `kit/scripts/texture_traits.py` (builder-notes lists
  the traps). Own textures and meshes: step 7.

## 4. Install the kit and check (no Rojo, no upload)
```bash
python3 -I "ROOT/kit/scripts/rbx_assets.py" local "ROOT/kit/runtime/VFXTimeline.luau" "ROOT/kit/studio/VFXCapture.luau" \
    "ROOT/kit/studio/VFXLibPlayer.luau" <your effect>.luau --name devkit
```
This writes `<Studio content folder>/vfxlib/devkit.rbxmx` (the script finds the folder on Windows, macOS and
Linux/Vinegar). Then one MCP `execute_luau` (Edit mode) installs it and checks the spec:
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
local C = require(dev.VFXCapture:Clone())
return C.check("<Name>", { length = <the brief's length in s> })
```
After each spec edit, re-run `rbx_assets.py` with just the spec and the same call (it replaces what changed). Fix every
ERROR and WARN before capturing.

## 5. Capture: one framing shot, then the capturer
1. **Framing (yourself, once per version):**
   ```lua
   local C = require(game.ServerStorage.VFXDev.VFXCapture:Clone())
   C.stage("day")                                         -- default baseplate; "void" = black box; "place" = their map
   C.camera({ dist = 42, height = 8, lookUp = 6, fov = 70 }) -- gameplay distance; world +X is screen LEFT
   return C.hold("<Name>", <the payoff time>)
   ```
   Then ONE MCP `screen_capture`. Adjust the camera until the payoff fills what the brief says. Check the Output
   (`get_console_output`) for `[VFXTimeline]` warnings.
2. **Timeline (the capturer):** spawn `vfxmith:vfx-capturer` (or a general-purpose agent with model `haiku` told to
   follow `ROOT/agents/vfx-capturer.md`) with `ROOT=<root>`, the Studio id, the spec name and two plans:
   - `plan day -> <effect>/vN_day: { times = {...}, stage = "day", camera = { <the framing above> }, base = true }`
   - `plan void -> <effect>/vN: { times = {...}, stage = "void", camera = { dist = <about 0.7 x day> , ... }, base = true }`
   Pick 10-14 times that cover the brief: the start, each beat's peak, the payoff and 0.1 s either side, the linger,
   the end. When the effect is for the user's open place, use `stage = "place", stageOpts = { at = <Vector3> }` for
   the day plan. It returns `vN_day/sheet.jpg` and `vN/sheet.jpg` (full frames beside them). **Look at the two sheets,
   not the frames.**
- Real-time video (only when the user has Studio focused or asks): `C.playLater("<Name>", 3.5)` then
  `kit/scripts/record.sh <effect>/vN.mp4 9` (Linux/Wayland; elsewhere any screen recorder).
- Many stills unattended on Linux + niri: `VFXCapture.batch(items)` + `kit/scripts/stills.py --follow` (no images in
  any context).
- The camera must not move during capture: do not click in the viewport meanwhile.

## 6. Review (blind panel)
- With a reference: `python3 -I "ROOT/kit/scripts/gallery_frames.py" "ROOT/gallery/effects/<type>/<id>.jpg" --out
  <effect>/ref` (library) and `python3 -I "ROOT/kit/scripts/compare.py" --ref <effect>/ref|<ref.mp4> --ours
  <effect>/vN --times <your times> --out <effect>/cmp_vN --label vN` (`--ref-t0` for a video). Do not open its
  outputs yourself; they are reviewer evidence.
- Run `vfx-review`: three blind reviewers, fresh each round, with the sheets AND frame folders on both backdrops, the
  `cmp_vN` outputs if any, `brief.md` and the spec. Scale: "match" for a reference video, ABSOLUTE quality for a
  description.
- Merge: fix what 2+ reviewers flag first, change by half steps when one says "much too much", never break what they
  said works. Log the round in `<effect>/LOG.md`.

## 7. Iterate, then finish
- Full: panel 1 -> fixes -> capture -> panel 2 -> apply its shared fixes -> a final capture by the capturer; check its
  sheets against the brief and panel 2's top complaints yourself, then finish. No third panel (polish mode only, and
  only if panel 2 gained 0.5 or more). Quick: one panel, fixes, the final capture.
- Game-fit pass: scale, Reduced Motion (no grade flashes), `VFXTimeline.Quality` 0.6 on phones, ~150 particles and ~25
  bright-white streaks at the peak, one light (`C.check` prints these).
- Only if the user wants it in a game: copy `kit/runtime/VFXTimeline.luau` + the spec (+ assets) into the project,
  played on the client; the server only sends "play <Name> at <cframe>":
```lua
local VFXTimeline = require(ReplicatedStorage.VFXTimeline)
local spec = require(ReplicatedStorage.VFX.<Name>)
VFXTimeline.preload(spec)            -- once at load, or the first play misses textures
-- on the server's message:
VFXTimeline.play(spec, cframe)
```
- Clean up: `C.clear()`, and destroy `ServerStorage.VFXDev` unless the user wants the kit kept in that place.

Own textures (PIL) and meshes (Blender; vertex colours white -> light grey >= 0.85 so Neon tints them): upload with
`kit/scripts/rbx_assets.py upload <files> --ids ids.json` (Open Cloud key in `~/.config/roblox/env`: `RBX_API_KEY`,
`RBX_USER_ID`); group games also need `rbx_assets.py grant --universe <id> --from ids.json`. Fresh meshes are invisible
in Studio for a few minutes. Worked example of a full run: `kit/examples/VoidRend/`.

## 8. Learn
New traps -> `knowledge/gotchas.md` (and a line in `builder-notes.md` if it cost real time); rules that hold across
effects -> `knowledge/patterns.md`; type-specific lessons -> `knowledge/categories/<type>.md`.

## Optional: the LihFolk vault
If `lihfolk:*` skills are listed in the session: ask `lihfolk:lihfolk` for engine facts you are unsure of,
`lihfolk:lihfolk-vfx` has slash/ability presets and a VFX rubric, `lihfolk:roblox-blender-modeling` a mesh gate and
the Blender helpers. Nothing here requires it; never block on it.
