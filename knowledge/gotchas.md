# Gotchas (measured while building the pipeline, 2026-11-13)

## Capture
- `niri msg action screenshot-window --id <id>` works while Studio is off screen (Vinegar/Wine under niri). The shot
  may lag the scene a little, so never trust the timing of a background shot: freeze holds (2.5 s) + the marker cubes,
  which stills.py checks. (An early "redraws only ~1/s" reading was mostly the clipboard lag below.)
- **The clipboard is filled a moment AFTER the screenshot command returns.** Reading it 0.06-0.1 s later returns the
  PREVIOUS clipboard (an old image). stills.py puts a sentinel text on the clipboard first and waits until an image
  replaces it (~0.15 s per shot).
- `wl-copy` stays alive to serve the clipboard: `subprocess.run(["wl-copy", ...], capture_output=True)` hangs forever.
  Always DEVNULL its stdout/stderr. And never `pkill -f <pattern>` from a bash command that contains the pattern: it
  kills its own shell.
- niri screenshots always go to the **clipboard** and (with `--write-to-disk true`) to `~/Pictures/Screenshots` named
  per SECOND (two shots in one second collide). stills.py uses `--write-to-disk false` + `wl-paste`, and saves and
  restores the user's clipboard. An earlier test overwrote the user's clipboard: always save it first.
- Focusing Studio to record video steals the user's screen and keyboard (they may be playing in Sober). Check
  `niri msg focused-window` first; prefer the stills path.
- Studio Edit mode: Heartbeat/RenderStepped run (~180 Hz), particles simulate, beams scroll. No Play needed.
- **ParticleEmitter.TimeScale = 0** freezes live particles exactly; Beam TextureSpeed must be zeroed separately.
  `VFXTimeline` `freezeAt` does both and clamps the timeline clock.
- A void stage made of SmoothPlastic black parts is not black (ambient + atmosphere tint it blue). Neon black parts are.
- MCP `screen_capture` leaves BillboardGuis out. Its result names the saved image file (newer Studio MCP versions;
  older ones returned the image only): copy that file into your version folder for compare.
- **Every `screen_capture` image stays in the caller's context for the rest of the run**, and every later turn re-reads
  it. In blind test 3 the 0.1.5 builder's 128 one-by-one captures were about two thirds of its context by the end. Let
  the `vfx-capturer` helper (fast model, short-lived) take timelines: `C.plan` + `C.next` + `screen_capture`, then
  `kit/scripts/shot_sheet.py` copies the files it names and writes one sheet.
- Get dev modules into a place with `rbx_assets.py push ... --universe <id>` + InsertService:LoadAsset (no Rojo, no
  pasting). A pushed model owned by the user fails LoadAsset in a GROUP place until granted ("Requester does not have
  permission"). Don't add/remove folders inside a project's Rojo-watched tree for this: deleting a watched folder
  crashed Rojo 7.7 (canonicalize NotFound) and Rojo also deletes instances it created when their files go.
- `require` caches per ModuleScript: require a `:Clone()` to get the latest synced source.

## Measured 2026-11-14 (blind test follow-up)
- **A particle's Size is its HALF-width: Size N draws a sprite 2N studs across.** Measured in Studio with a fully
  opaque square texture, FacingCamera, next to 1-, 2- and 4-stud parts: Size 1 = 2.0 studs, Size 4 = 8.0 studs (a disc
  texture the same). **Beam Width0/Width1 and Part Size are full widths** (Width 2 = 2 studs). So a particle and a
  beam or part "of the same size" differ 2x: to cover a 10-stud ring with a glow sprite use Size 5. Ratios between
  particles in the category studies still hold; numbers called "diameter" or "sprite width" there are half-widths.
- `game.Lighting.Technology` cannot be read from MCP `execute_luau` ("lacking capability RobloxScript"). Don't
  read it; judge the lighting from a capture.
- **First play after loading misses textures** for a few frames (ContentProvider still fetching): call
  `VFXTimeline.preload(spec)` once when the game (or the capture) loads the spec. The capture functions do it; game
  code must do it itself.
- **The void stage flatters.** On black, dark layers (ink smoke, black spikes, a dark band) vanish and every additive
  layer looks brighter. The blind test effect lost most of its lead on a daylight baseplate: its ink band, ink smoke
  and black spikes read as dirt there. Capture every version on `C.stage("void")` AND `C.stage("day")` (a copy of
  the default Roblox baseplate) or the user's own map (`C.stage("place")`).
- Low-resolution art magnified shows stair-stepped edges, worst on black (LE 0) twins of spiky shapes drawn big.
  Check a texture's effective resolution with `kit/scripts/texture_traits.py <id>` before drawing it large.
- **Swapping a texture changes the on-screen size** when the new art fills more or less of its square: scale the
  layer's Size by old fill / new fill (the `fill` trait). Two recipe flashes swapped to a texture filling 32 % instead
  of 22 % whited out half the frame until their Size was cut x0.7.
- **Particles of an emitter far from the camera do not simulate.** Nine frozen copies set up away from the camera and
  shot by flying the camera to each (`screen_capture` camera_position) all showed newborn particles. Play each
  capture where the camera already looks (`C.hold`), one at a time. (Heartbeat and particle ageing are fine with the
  Studio window off screen: a 20 studs/s particle frozen at 1.0 s sat exactly 20 studs up.)
- **A comment in the middle of a props line swallows the rest of it** (`Size = ..., -- note Transparency = 0,
  Lifetime = 0.06,`): the layer silently gets Roblox defaults (Lifetime 5-10 s). It happened again while fixing the
  recipes; `C.check` flags it (no Lifetime / no Transparency). Put notes on their own line.

## Building
- **Never create a Script or LocalScript from MCP `execute_luau` and set its `Source`**: it crashed Studio during the
  blind tests (and a command-bar error inside a just-created script crashed it again). Ship any script inside an
  `.rbxmx` written by `kit/scripts/rbx_assets.py local ...` and load it with `game:GetObjects("rbxasset://vfxlib/...")`,
  or keep everything in ModuleScripts loaded that way.
- **A velocity-aligned streak follows the texture's own long axis.** With `Orientation = VelocityParallel`, a streak
  texture drawn horizontally renders ACROSS its motion; `Rotation = 90` (or a texture drawn vertically) fixes it
  (found while building the test-3 void rift's inward streaks).
- **Beam Segments 1 + a Transparency/Color sequence = invisible beam** when the sequence is 1 at both ends (a fade-in /
  fade-out laser): beams sample sequences only at segment ends. The runtime defaults Segments to 10.
- Template MeshParts from Open Cloud model uploads have PivotOffset 0 and CFrame at the bbox centre; the runtime's
  normalised `pivot` handles "grow from the bottom tip". VR_Crescent: hollow side = local -Z, tips on the front plane,
  pivot `{0,-0.5,-0.5}`; to face +X (a crescent left of the pillar) rot y = -90, right one rot y = 90.
- CFrame.Angles(0, θ, 0) sends local -Z to (-sin θ, 0, -cos θ).
- Beam curves bend along the attachments' Axis (default +X): set `axis = {0,1,0}` for arches.
- Flat ground sprites: Orientation VelocityPerpendicular + tiny upward Speed.
- `GroundSwirl`-type single textures with LightEmission 0.4 and Brightness 2 read as a solid saturated disc: keep ground
  rings at Transparency 0.4-0.5, Brightness ~1.
- Camera framing dominates every comparison: match the reference's bounding box (width share, ground line) and centre
  BEFORE judging anything else. VoidRend framing: dist 15.5, height 3.7, lookUp 2.75, FOV 70, crop 450,379,1746,663
  (centred on the 1910x1008 viewport, clear of the toolbar at x < 450 and the marker band at the top).
- Neon renders ~30% hotter than its authored colour under bloom: author body colours darker (orchid #8E3CC8 reads like
  #B45AE6). Grey vertex colours near a mesh's tip turn black under a high-Contrast grade: keep them >= 0.85.
- Over-correction is common: round 1 said "linger too loud", v4 went too empty; v6 empty again, v7 too much. When a
  layer oscillates, stop following words and steer by the coverage curve in metrics.json (aim between the last two).
- **Reviewers measure ON-SCREEN colours; specs author INPUT colours.** A particle shows roughly texture value x Color x
  opacity (x Brightness when emissive): typing a reviewer's target #390489 into Color on a grey smoke texture at 50%
  opacity renders near-black (v6 lost its whole linger). Author ~target / (texture value x opacity). Same for ground
  swirls with dark colours. Ask the colour reviewer to say which one it means.
- Neon + bloom pushes saturation as well as value: desaturate Neon body colours (#A08CB8 renders pale orchid).
- The capture camera sits on the -Z side looking toward +Z, so world +X is SCREEN LEFT. Reviewers speak in screen
  terms: translate before editing (VoidRend v4 had its horns mirrored because of this).
- Fresh mesh uploads render invisible ("No asset content representation found") for a few minutes. Check a still
  before blaming the spec.
- wf-recorder writes black as 16 but tags the video full range (yuvj420p, pc), and ignores -x yuv420p: the void reads
  grey. record.sh re-tags the stream as limited range afterwards (ffmpeg -c copy -bsf:v
  h264_metadata=video_full_range_flag=0), which decodes black as 0 without re-encoding.

## Open-source packs and the local loader (2026-11-13)
- `game:GetObjects("rbxasset://vfxlib/x.rbxmx")` loads a file from Studio's own content folder (Vinegar:
  `~/.var/app/org.vinegarhq.Vinegar/data/vinegar/versions/<ver>/content/`), no upload. A `.rbxl` returns copies of the
  services WITHOUT Workspace, and destroying them errors (locked TextChatService children): cut effects with
  `rbxcut.py` instead. A new Studio version = a new content folder (`rbx_assets.content_dir()` picks the newest).
- XML 1.0 rejects control characters; pack files have them in names and attributes ("ill-formed XML"). rbxcut writes
  such strings as BinaryString and strips them from names.
- `stills.py --plan` must use the start time the SAME `P.batch` call returned (a stale start = every shot missed);
  rebuild the plan from the returned `start`, never from an earlier run.
- Never `pkill -f <pattern>` when the pattern is in your own command line: it kills the shell running it (exit 144).
  Find the pid with `pgrep -f` and kill that one.
- VFX Forge's runtime (shipped inside many packs) is licensed VFX-DL: it may not be run from plugins/dev tools or
  redistributed. Our player reimplements the attribute semantics from `os-conventions.md`; never load Forge itself.
- Fractional `EmitCount` (density-scaled, e.g. 16.2) and string counts ("2") are common: `tonumber` then floor (>= 1).
- Effects whose meshes were tweened by their OWN scripts show those meshes frozen at their template pose in the
  player (e.g. spheres sitting still): the effect is incomplete there, not broken.
- **Set `Camera.Focus` with `Camera.CFrame`** in Edit mode. Studio's edit camera re-aims at Focus: with a stale Focus
  the view swings away (seen 2026-11-14: frames full of ceiling, "camera vastly misplaced"). Both capture modules set it.
- Verify a capture setup on ONE effect and LOOK at the frames before a long batch (framing, floor, markers).
- A still frozen on the SAME frame its particles are emitted shows them at age 0 (Size curves that grow from 0 are
  invisible): the 0.03 s frame comes out empty. Freeze only after at least 2 rendered frames (both players do).
- Batch stills must hold for their full time AFTER freezing (relative timing). A precomputed timetable falls behind on
  heavy effects and then flashes the late stills for one frame, so they get missed.
- With Studio focused, holds of ~0.8 s are enough; with Studio in the background it redraws about once a second and
  runs slower than real time: use holds of ~1.9 s.
