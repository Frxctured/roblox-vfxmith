# VFXKit: start round 1 where earlier directed builds ended

`kit/studio/VFXKit.luau` holds building blocks that survived many rounds of directed builds and blind reviews, with
their proven values as defaults: a stroke with an ink rim, a mesh slash fitted to the swing, an impact frame, a bolt, shock and dust rings, ground crack
and scar, debris, smoke, flash, charge-up, an aftermath group, scrolling-beam curtains, one freeze-safe clock (`Timeline`: `fx:At`, `fx:OnUpdate`, `fx:Play(t)`),
declared camera shake, R15 pose helpers (step, stride, head, lean, two-handed grip, guard poses), a stage with five review cameras, dense-still capture and `fx:Lint()`.

Use it for melee moves, abilities, impacts and strikes, and (since 1.3) for flowing surfaces: walls and pillars of
fire, water, lava, energy or wind (`fx:Curtain`). For anything else (projectiles, beams, auras, loops, scenery)
use its stage, caster, clock, cameras, capture and Lint, and build your own layers with `fx:E` / `fx:Part` /
`fx:OnUpdate` from `knowledge/pro-guide.md` values. The blocks are a starting level, not a template: design the effect
first, and replace any block whose look does not serve it.

Files: `kit/studio/VFXKit.luau` (the module), `kit/studio/VFXKitDemo.luau` (a slash + a strike in ~70 lines),
`knowledge/checklist.md` (before you show anything), `knowledge/selfcheck.md` (the routine for every round),
`kit/scripts/kit_push.py` (load code into Studio), `kit/scripts/kit_sheet.py` (contact sheets).

## Round 1 in six steps
1. **Load.** `python3 -I "ROOT/kit/scripts/kit_push.py" "ROOT/kit/studio/VFXKit.luau"` prints one Luau line; run it
   with `execute_luau` (Edit mode). The kit is then `_G.VFXKit`. Write your effect as ONE file
   (`<effect>/effect.luau`; the demo shows the shape), push it the same way. Re-push after every edit (each push has
   a new name). Edit mode only: no Play, no publish. Works on Windows, macOS and Linux (the script finds Studio's
   content folder; `--content <dir>` if it does not).
2. **Stage and caster.** `local fx = K.new("LAB_<name>", CFrame.new(x, y, z), K.Palette(main, deep))`, then
   `fx:Stage()`, `fx:Caster()`, optionally `fx:Katana()` or `fx:Weapon{...}`. Set `fx.mark` = target distance.
   Everything you pass from here on is caster space: x right, y up, -z the look vector. Put the stage away from the
   user's own build (or ask where), and name everything `LAB_...` so it is easy to remove.
3. **Pose first.** `fx:Pose{...}`: per hit an anticipation key (0.07 s, "out"), the swing ("fast", 0.12-0.18 s) and a
   held follow-through (0.13 s). Check `fx:Cam("player"); fx:Play(t)` and the bird's-eye before adding any effect:
   limbs outside the silhouette, big moves over the top and on the look line. Keys also take `fz` (step forward),
   `st` (stride), `hy` (head yaw), `rl` (lean) and `two = 1` (off hand on the handle by IK); start from and return to
   a guard (`K.Key(t, K.Guard.Mid, { ... })`), never a T-pose. Pose sheet with the effects off:
   `fx:PoseOnly(true); fx:Shots(fx:Dense("side", 0, lastKeyTime, 0.1))` (checklist A1-A4; `Lint()` warns too).
4. **Effects from the pose.** `fx:Stroke{ t =, swing = { t0, t1 } }` reads plane, centre, middle and size from the
   pose (for a punch or kick: `swing = { t0, t1, "RightHand" }`). `fx:MeshSlash{ swing = { t0, t1 } }` is the mesh
   version (shines in daylight, turns with the blade, has height edge-on; `knowledge/mesh-slash.md` says when to use
   which). The pose leads: fit the effect to the blade, never the arms to the effect. Add `fx:Contact`, `fx:Crackle`, `fx:Needles`,
   `fx:Dots` per hit; `fx:Charge` for a wind-up; for the payoff `fx:ImpactFrame`, then `fx:Strike` (or its parts:
   `Flash`, `Burst`, `Bolt`, `ShockRing`, `DustRing`, `GroundCrack`, `GroundScar`, `Debris`, `Smoke`) at impact + 0.07 s;
   `fx:Shake` per hit. Custom moving parts and lights go through `fx:OnUpdate(function(T) ... end)`, custom emitters
   through `fx:E(att, K.Tex.X, props)` + `fx:EmitAt(t, e, n)`, so freezes keep working. Escalate sizes +15 % per hit.
5. **Build, lint, look.** End the file with `_G.kitfx = fx; return fx:Build() .. "\n" .. fx:Lint()`. Then run
   `knowledge/selfcheck.md` completely (5 views, dense strips) and answer `knowledge/checklist.md`. Paste
   `fx:Layers()` (every layer with its values and its reason) into `LOG.md` for each version.
6. **Report** only when the checklist is clean or the open points are named.

## New in 1.3 (all five are general: they apply to every effect type)
**1. A reason on every layer.** Every emitter, beam and mesh layer stores `why` ("<what it does for the read>; keep:
<the values that carry it>; free: <safe to change>"). Kit blocks fill it in; for a layer you make yourself pass
`why = "..."` in the props of `fx:E` (or `fx:Why(instance, text)` for beams and parts). `fx:Layers()` prints the
table (texture tag, LE, Brightness x gain, size, life, Transparency, ZOffset, why) for `LOG.md`. The director reads it
to see which values carry the read ("keep") and which are taste ("free"); Lint counts layers without a reason.

**2. Additive stack gain.** Additive layers (LE > 0) add up, and they add to the BACKGROUND too: on a light floor or sky
a stack clips to a white blob that hides the hero shape. At `Build` the kit finds the busiest spot (how many additive
layers cover it while alive, and their summed Brightness x opacity) and scales every stacked additive layer by one
per-effect gain (`fx.gain = "auto"` default; a number to set it; 1 = off; `fx.budget` 2). Flashes and pops (life <=
0.12 s) are left out. `Build` and `Lint` print `gain 0.85 (peak 5 additive, light 2.4 at ...)`. Measured: the gain keeps
big stacks from burning whiter than lean ones, but it cannot rescue a heavy stack (12 soft glows still clip at summed
Br 2 against the sky). Lint also counts the DIFFERENT additive layers (a curtain layer's panels count once; flashes and
pops left out) that cover one spot at one moment and warns above 4. The fix for a white blob is fewer additive layers: carry the body with LE 0 layers and a dark
partner (pro guide rules 1-4).

**3. Curtains: scrolling-beam sheets (`fx:Curtain`).** For anything that FLOWS across a surface: fire and energy walls,
waterfalls and lava falls, wind walls, aura sheets, portal rims, pillars. Each panel is a stack of Beams between a foot
and a top attachment, each layer with its own TextureSpeed and TextureLength (never multiples of each other, so the
pattern never visibly loops): a dark low-value body, the mid-tone body at Br 10-15, thin fast streaks, hot additive
wisps and a faint wide halo. It is wrapped for 3D, because one flat sheet is a slab from above and a stick from the
side: `line = { from, to }` gives 2+ staggered rows of overlapping panels with alternating yaw and a forward lean (holds
its volume end-on), `ring = { c, r }` gives 8 panels round a vertical axis (a pillar that reads from every side). Rise,
hold and fall (sink + fade) are clock-driven, the height flickers and the curve sways; a flat foot glow strip carries
the top-down read and a dark scorch line stays after the fall. Soft edges come from overlapping panels, nested widths
(narrow dense layers inside wide faint ones) and the halo, not from one hard-edged quad.
Axes (measured): with FaceCamera off the ribbon's width follows the attachments' **Y** axis and CurveSize bends along
their **X** axis; upright attachments (Y along the beam) collapse the ribbon to a line. The kit sets X = the panel's
front, Y = across. Tested from player, side (end-on), front and top-down views: the line wall keeps its volume end-on
and reads as a burning strip from above; a 5-panel ring shows a pentagon with bright overlap corners from above, so
rings default to 8 panels. Default textures are white masks (`K.Tex.Flow`, `FlowStreaks`, `FlowWisps`); pass your own
`layers` for a different material (search "beam" / "trail" textures with `find_textures.py`).
**Never a flat rectangle (1.3.1).** A curtain at one height reads as a billboard (fire wall test, 2026-11-17). By
default every panel now gets its own height from a smooth skyline along the line (`vary` 0.3), the two ends taper
down (`taper` 0.45: no square ends), humps travel along the hold (`surge = { amp = 0.25, waves = 1.5, speed = 0.45 }`),
single panels flare up on unsynced noise (`flare` 0.3), the density differs per panel and drifts slowly (`density`
0.12), and the collapse runs as a wave (`fallSweep`, `fallFrom` = "start" | "centre" | "end" | "edges") with a short
flare before each panel drops (`fallFlare` 0.15). Your own curve: `height = function(k, x, T, h, P) return h2 [, fade]
end` (k = 0..1 along the line or round the ring, x = seconds since this panel began to rise, h = the default height):
a breathing loop, a surge from the middle, a collapse wave of your own, without touching `hold`. Per layer:
`ramp = { col = { foot, ..., top } or a ColorSequence, tr = { {t, v}, ... } }` sets the colour and the hold
Transparency along the length (the fade is added on top), and `feather = 2-3` splits a layer into nested beams,
narrower and denser inside, for a soft edge on any texture. **Dark layers must be soft-sided:** the default `deep`
layer uses the soft wisps texture inside the body's width (a hard-sided texture's quad edges drew dark rectangles in
the fire wall test); Lint warns on a dark curtain layer with a hard-sided texture and on a curtain with one height.
Rings keep 8 panels; seen straight overhead they still show a faint polygon (the base pool under the pillar hides most
of it). Checked in Studio (daylight, player / side / front / bird; shots in the lab's `firewall2/blocktests/`).

**4. Mask and baked textures.** `K.TagOf(id)` returns `"mask"` (white / grey art: Color tints it freely), `"baked:<hue>"`
(colour painted in: Color only MULTIPLIES it, so blue art tinted orange goes dark and muddy) or `"unknown"`. All
`K.Tex` textures are masks; the MeshSlash "Hot" decal is baked orange and "Body" baked blue (fine for cold palettes,
muddy for warm ones). `K.Tint(tex, colour)` returns the colour for a mask and white for baked art; `fx:Recolor(palette)`
re-tints a built effect, masks only (palette colours map to the same role, other colours turn by the hue difference
keeping saturation and value; near-white, grey and black stay), and lists what it left alone. `find_textures.py` prints
`MASK` or `BAKED:<colour>` on every hit; tag a new id with `K.Tag(id, "mask")` once `texture_traits.py` says white / grey.
Lint warns when a baked texture is tinted.

**5. Aftermath.** Every impact gets a group that stays 1-2 s after the hit: FAINT, LOW and RADIAL. `fx:Aftermath{ t =
hit + 0.15, p, d = reach }`: dust haze rolling outward along the ground (Transparency >= 0.78, no upward acceleration,
so it never forms a dome), tiny glints skidding outward with a double twinkle, and optional residual ground arcs
(`arcs = 5-7` for energy hits). `fx:Strike` adds one by default (`aftermath = false` to skip). Role `linger`; Lint warns
on an impact without one. For a non-impact effect, the same idea is its ending: what is left when the main shape goes
(embers, scorch, a fading ring), never a cut.

## Values to keep (see `K.Tier`, `K.Tex`)
Cores LE -3..0 at Br 25-40 (finisher 60); highlight Br 60; needles LE -1 Br 28-45; sprite bolts LE -5 Br 45-60;
sparks LE -3 Br 20-30; glows and wind LE 1 only (Br 0.6-6); ink = black, Br 0, LE 0, 0.9x, Transparency 0.45.
Lives: strobe bolt 0.05 s, pop 0.06, flash 0.05, needles 0.08-0.18, stroke 0.2 (finisher 0.3), dots 0.4-0.9,
smoke 1.5-2. Combo spacing ~0.36 s; impact frame 5 frames.

## What the kit does not do
- It does not design the move: which cut reads from behind is your choice (Lint only warns when a plane is edge-on).
- Projectiles, single beams (only `TrackBeam` for freezing; flowing sheets have `Curtain`), auras / loops, mesh
  effects other than slashes, and sounds are not covered.
- New in 1.3 and checked on one test scene each (Studio, daylight, four views): `Curtain` (line and ring with the
  default layers, fire and storm palettes), `Aftermath`, the gain (on a stacked-glow test and the demo), `Recolor`
  (demo, storm -> fire). From exactly top-down a ring is still a faint polygon; a textured cylinder mesh would be round.
- New in 1.2 and checked on one demo sheet only (a two-handed rising cut, five views): `MeshSlash` (the `tail`
  sprite, punches / kicks and custom `layers` are untested), the pose channels, the off-hand IK and the pose Lint.
- `K.Tex.Star` and `K.Tex.BoltTangle` were swapped for library textures in 1.1 and the Fire palette, `Burst`, the
  3-layer bolt widths, the inverted impact phase and the radial streaks were checked on one demo sheet only: look at
  them critically on your own sheet.
- Textures are tuned for a cold storm look; other hues need a quick Brightness check on your palette (warm colours
  clip to white sooner). Pick other textures with `kit/scripts/find_textures.py`.
- The R15 dummy is posed by FK on anchored parts: no leg IK, no Animator, Edit mode only. It is a review stage, not
  game code: to ship the effect, rebuild its layers for your game's runtime (or `kit/runtime/VFXTimeline.luau`).
