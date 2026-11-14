---
name: vfx-make
description: Build a Roblox VFX effect end to end - from a description ("a cool light beam with an explosion", "ice slam", "purple aura") or a reference video - with library references, a data-driven spec, capture in Roblox Studio, comparison and blind review, iterated to a score bar. Use for "make a VFX", "make it look like this", "improve this effect", any new or reworked effect.
---

# Make a Roblox effect

`ROOT` = the plugin root: `<base directory>/../..` (also `${CLAUDE_PLUGIN_ROOT}`). All paths are relative to ROOT;
resolve it to an absolute path first and quote it (it may contain spaces). Python 3 + Pillow (+ numpy, ffmpeg for
video) run the scripts; Studio is driven through the Studio MCP server (`execute_luau`, `screen_capture`).

Good effects come from a process, not from the prompt: settle what the user wants, DESIGN the effect yourself, use
real references as a guide (techniques, timing, values that work), build it as editable data, look at it in daylight,
let blind reviewers list the differences, fix. **The library is a guide, not a requirement, for every effect type.**
In blind test 5 every plugin build used library meshes for its hero and read as "smooth cones"; a plain agent that
designed and built its own hero in code was people's clear favourite. Design the hero shape for the brief, whatever
the effect; borrow techniques, timing and values from the references.

**Cheap by design.** The loop hands its heavy reading and capturing to helpers, so the builder's own context stays
small (every turn re-reads it):
- the **librarian** (`vfx-librarian`, fast model) reads the library and returns references as a guide (what works, and where nothing fits);
- the **capturer** (`vfx-capturer`, fast model) takes the freeze frames and returns one contact sheet per backdrop;
- the **reviewers** are fresh agents that see the full frames.
The builder reads `knowledge/builder-notes.md` instead of the whole knowledge folder and looks at sheets, not frames.
(Blind test 3, 2026-11-14: the 0.1.5 loop scored 7.5 against 6.0 without the plugin but cost 3.3x the tokens. About
two thirds of its context by the end was screenshots it took one by one, and every one of its 212 turns re-read them.)

**Spend turns on versions, not on overhead.** Every turn re-reads the whole context, so batch what is independent:
read all pack files together, read the three sheets together, send `execute_luau` + `screen_capture` together, spawn
the three reviewers together, and never read a doc one file or one chunk per turn (the 0.1.6-beta builder spent ~45
of its 86 turns that way). There is no turn cap: a hard 30-40 turn budget (beta3) saved 9% and cost quality in the
human poll. The turns that improve the effect are building, looking and fixing.

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

## 1-2. References as a guide, then ONE read of everything
- **Librarian:** spawn `vfxmith:vfx-librarian` (or a general-purpose agent with model `haiku` told to follow
  `ROOT/agents/vfx-librarian.md`) with `ROOT=<root>`, the request, the brief's beats and the effect folder. Save its
  reply as `<effect>/refs.md`: it is the map (which cards, which types), not the material. It also writes
  `<effect>/textures.jpg`: 5 fresh texture candidates per role from both texture libraries.
- **Pack:** `python3 -I "ROOT/kit/scripts/builder_pack.py" --types <type>[,<type>] --cards <the 2-3 best card ids>
  --out <effect>/pack`. Pick the types by what the effect DOES, not its name (a rift that collapses into a blast is
  darkportal + explosion; index: `knowledge/README.md`). It writes builder-notes + spec-format, each category study
  with its starting recipe, and the cards, in files of ~15k tokens or less.
- **Read them all in ONE message** (parallel Read calls), together with `textures.jpg`, the frame sheets of the 1-2
  best references (`gallery/effects/...`, the paths are in the pack) and the recipe's gallery strip. That is the whole reading: about
  40k tokens of text, a few cents over the run. Read the cards for techniques and numbers that work, not for a shape
  to copy (in test 4 a builder that worked from the librarian's summary alone built a generic shape and came last;
  in test 5 builders that copied library meshes lost to one that designed its own). Anything else later: `grep -n`
  the term in `knowledge/`, then read that one section.
- **From a video:** give it a folder (`refs/<slug>/`: `source.mp4`, contact sheets at 2 fps, one cycle at 30 fps with
  frame numbers burnt in, full-size key frames, all with ffmpeg). Look at the sheets. Write `analysis.md`: phase
  timeline in seconds and frames (t0 = first frame of the effect), one row per layer (look + likely build), palette
  hex, how colour ages, rhythm (build -> quiet beat -> payoff -> linger), world grade. Then still ask the librarian for
  the closest library effects and pack them: their layer values are your starting numbers.
- **From a video:** give it a folder (`refs/<slug>/`: `source.mp4`, contact sheets at 2 fps, one cycle at 30 fps with
  frame numbers burnt in, full-size key frames, all with ffmpeg). Look at the sheets. Write `analysis.md`: phase
  timeline in seconds and frames (t0 = first frame of the effect), one row per layer (look + likely build), palette
  hex, how colour ages, rhythm (build -> quiet beat -> payoff -> linger), world grade. Then still ask the librarian for
  the closest library effects: their layer values are your starting numbers.

## 3. Design, then build on the recipe's scaffold
- **Design first (write it in `LOG.md` before any spec):** per beat, the hero shape, what it is built from (sprite,
  beam, part, `ctx.Crystal`, a custom layer) and why it reads as THIS effect, plus the moment a player will remember.
  For each hero: where white, body colour and the deep tone sit ON it (tip, body, base, facet shadows), and its whole
  life: birth (where, when, ease, stagger), what keeps moving while it holds, the warning before it ends, how its
  pieces are born from it, where they land, what stays (builder-notes rules 12-15). If you are unsure what Studio can
  render (a texture made in code, a mesh API), test it in one small `execute_luau` first.
  Ask of every library asset you consider: does it match the design closely? If it only roughly fits, build that
  part yourself (faceted solids such as rocks, debris, crystals, shards: `ctx.Crystal`, see spec-format; other solids: Parts, wedges, custom
  layers; flat marks: sprites or decals). Library meshes and textures are options, never the default.
- Use `knowledge/categories/<type>_recipe.luau` as a parts menu: copy it into the effect folder as `<Name>.luau`
  (change its `name`) for the format and the timing skeleton, keep only the layers whose role a beat of your design
  needs, and replace any whose look does not serve it. Skip a dome or a dark twin the design does not need (test 5: a
  recipe dark twin and dark sprite cracks read as "fur" and "dirt"). How it
  plays as it is: `gallery/recipes/<type>_recipe.jpg`.
- **Fit it to the brief** (`design-brief.md` section 4): scale each part to the brief's size in studs, retime its
  layers to the brief's beats, keep one hero shape per beat. Borrow values from `refs.md` where they serve the design.
- **Combined effects** ("a beam with an explosion", "a portal that spits fire"): one spec, both recipes' layers in one
  `layers` list, ids prefixed per part (`beam_core`, `boom_flash`), the second part's `t` shifted to where it starts,
  its `at` moved to that point, palettes and texture tables merged, duplicate roles dropped (one light, one grade). A
  later flash or burst gets a different shape and is bigger.
- Palette: three tones (white core, saturated body, a deep tone). In daylight put the deep tone on geometry and
  decals (bases, crack cores, facet shadows), not on sprite twins. Saturated, glowing colour in the asked hue family
  is good; people preferred it. ONE rendering style, the user's.
- Textures: the recipe's textures are defaults, not the palette. Pick per role from `textures.jpg` (the open-source
  library and VFX Studio: ~10,000 textures, ~2,750 animated flipbooks) and keep a recipe texture only where it is the
  best candidate; search more with `kit/scripts/find_textures.py "<role words>" --sheet ...` (one image). Flipbooks:
  `FlipbookLayout = 4` (the grid), `FlipbookMode = "OneShot"` over the particle's Lifetime. Check ids you pick outside
  the sheet with `kit/scripts/texture_traits.py` (builder-notes lists the traps). Own textures and meshes: step 7.

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
Fix every ERROR and WARN before capturing. **Every later version is two turns:**
1. one Bash call that edits the spec (a small Python patch, or the Edit tool first in the same message) AND re-packs
   it: `... && python3 -I "ROOT/kit/scripts/rbx_assets.py" local <Name>.luau --name devkit`;
2. one message with `execute_luau`
   `return require(game.ServerStorage.VFXDev.VFXCapture:Clone()).update("devkit", "<Name>", { length = <s>, frame = <payoff time>, stage = "day", camera = { <framing> } })`
   (reload + check + the framing frame) AND the MCP `screen_capture` after it.

## 5. Capture: one framing shot, then the capturer
1. **Framing (yourself, once per version):** the `C.update(..., { frame = <payoff time>, stage = "day", camera = {
   dist = 42, height = 8, lookUp = 6, fov = 70 } })` call of step 4 plus ONE MCP `screen_capture` in the same message
   (gameplay distance; world +X is screen LEFT; "void" = black box, "place" = their map). Adjust the camera until the
   payoff fills what the brief says. Look at the Output (`get_console_output`) only if `C.check` or the frame looks
   wrong.
   **Hero check (yourself, every version):** one more shot with the camera at about 1x the effect's width (the hero
   fills about a third of the frame), and after the capturer returns, open the payoff frame and one hold frame at
   full size. Judge shapes, facets and colour there; the sheets are for timing. Fix what you can see yourself before
   you spend a panel on it.
2. **Timeline (the capturer):** spawn `vfxmith:vfx-capturer` (or a general-purpose agent with model `haiku` told to
   follow `ROOT/agents/vfx-capturer.md`) with `ROOT=<root>`, the Studio id, the spec name and two plans:
   - `plan day -> <effect>/vN_day: { times = {...}, stage = "day", camera = { <the framing above> }, base = true }`
   - `plan void -> <effect>/vN: { times = {...}, stage = "void", camera = { dist = <about 0.7 x day> , ... }, base = true }`
   Pick 10-14 times that cover the brief: the start, each beat's peak, the payoff and 0.1 s either side, the linger,
   the end. When the effect is for the user's open place, use `stage = "place", stageOpts = { at = <Vector3> }` for
   the day plan. Add `focus = <3-4 payoff times>` to the day plan. It returns `vN_day/sheet.jpg`, `vN_day/focus.jpg`
   (the payoff at 640 px) and `vN/sheet.jpg`, with the full frames beside them. **Read these three images in ONE
   message, not the frames.** On the focus sheet check builder-notes rule 3: the payoff must be the biggest thing on
   screen. The reviewers (step 6) need the capturer's frames: spawn them after it returns, all three in one message.
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
  said works. **Rebuild, don't re-value,** when a reviewer writes REBUILD, when 2+ say a hero's shape or colour is
  wrong, or when the same problem comes back in the next panel: change how that layer is built (mesh, `ctx.Crystal`,
  decal instead of particle, Neon lines instead of a sprite). Log the round in `<effect>/LOG.md`.

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
- **One file to preview or share:** `python3 -I "ROOT/kit/scripts/export_effect.py" <Name>.luau --out <effect>/<Name>_play.luau`
  writes the runtime + spec as one self-contained script with `_G.VFXPlay(origin, freezeAt?)` / `_G.VFXStop()`
  (`--globals` renames them). Check it once: one message with `execute_luau` (the file's text, then a frozen play) and
  a `screen_capture`. Do not write your own exporter.
- Clean up: `C.clear()`, and destroy `ServerStorage.VFXDev` unless the user wants the kit kept in that place.

Made in code, no upload: faceted solids (rocks, debris, crystals, shards) with `ctx.Crystal` (spec-format); other meshes with
`AssetService:CreateEditableMesh` and textures with `CreateEditableImage` (Decals and MeshParts only: particles show
nothing and beams a flat white strip; live games need "Allow Mesh / Image APIs" on, so keep a fallback; builder-notes
lists the details). Own textures (PIL) and meshes (Blender; vertex colours white -> light grey >= 0.85 so Neon tints them): upload with
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
