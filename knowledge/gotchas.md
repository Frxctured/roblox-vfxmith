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
- MCP `screen_capture` returns the image to the model only (no file) and leaves BillboardGuis out: not usable for
  compare.
- Get dev modules into a place with `rbx_assets.py push ... --universe <id>` + InsertService:LoadAsset (no Rojo, no
  pasting). A pushed model owned by the user fails LoadAsset in a GROUP place until granted ("Requester does not have
  permission"). Don't add/remove folders inside a project's Rojo-watched tree for this: deleting a watched folder
  crashed Rojo 7.7 (canonicalize NotFound) and Rojo also deletes instances it created when their files go.
- `require` caches per ModuleScript: require a `:Clone()` to get the latest synced source.

## Building
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
