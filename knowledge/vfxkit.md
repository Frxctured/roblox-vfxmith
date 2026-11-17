# VFXKit: start round 1 where earlier directed builds ended

`kit/studio/VFXKit.luau` holds building blocks that survived many rounds of directed builds and blind reviews, with
their proven values as defaults: a stroke with an ink rim, an impact frame, a bolt, shock and dust rings, ground crack
and scar, debris, smoke, flash, charge-up, one freeze-safe clock (`Timeline`: `fx:At`, `fx:OnUpdate`, `fx:Play(t)`),
declared camera shake, R15 pose helpers, a stage with five review cameras, dense-still capture and `fx:Lint()`.

Use it for melee moves, abilities, impacts and strikes. For anything else (projectiles, beams, auras, loops, scenery)
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
   limbs outside the silhouette, big moves over the top and on the look line.
4. **Effects from the pose.** `fx:Stroke{ t =, swing = { t0, t1 } }` reads plane, centre, middle and size from the
   pose (for a punch or kick: `swing = { t0, t1, "RightHand" }`). Add `fx:Contact`, `fx:Crackle`, `fx:Needles`,
   `fx:Dots` per hit; `fx:Charge` for a wind-up; for the payoff `fx:ImpactFrame`, then `fx:Strike` (or its parts:
   `Flash`, `Burst`, `Bolt`, `ShockRing`, `DustRing`, `GroundCrack`, `GroundScar`, `Debris`, `Smoke`) at impact + 0.07 s;
   `fx:Shake` per hit. Custom moving parts and lights go through `fx:OnUpdate(function(T) ... end)`, custom emitters
   through `fx:E(att, K.Tex.X, props)` + `fx:EmitAt(t, e, n)`, so freezes keep working. Escalate sizes +15 % per hit.
5. **Build, lint, look.** End the file with `_G.kitfx = fx; return fx:Build() .. "\n" .. fx:Lint()`. Then run
   `knowledge/selfcheck.md` completely (5 views, dense strips) and answer `knowledge/checklist.md`.
6. **Report** only when the checklist is clean or the open points are named.

## Values to keep (see `K.Tier`, `K.Tex`)
Cores LE -3..0 at Br 25-40 (finisher 60); highlight Br 60; needles LE -1 Br 28-45; sprite bolts LE -5 Br 45-60;
sparks LE -3 Br 20-30; glows and wind LE 1 only (Br 0.6-6); ink = black, Br 0, LE 0, 0.9x, Transparency 0.45.
Lives: strobe bolt 0.05 s, pop 0.06, flash 0.05, needles 0.08-0.18, stroke 0.2 (finisher 0.3), dots 0.4-0.9,
smoke 1.5-2. Combo spacing ~0.36 s; impact frame 5 frames.

## What the kit does not do
- It does not design the move: which cut reads from behind is your choice (Lint only warns when a plane is edge-on).
- Projectiles, beams (only `TrackBeam` for freezing), auras / loops, mesh effects and sounds are not covered.
- `K.Tex.Star` and `K.Tex.BoltTangle` were swapped for library textures in 1.1 and the Fire palette, `Burst`, the
  3-layer bolt widths, the inverted impact phase and the radial streaks were checked on one demo sheet only: look at
  them critically on your own sheet.
- Textures are tuned for a cold storm look; other hues need a quick Brightness check on your palette (warm colours
  clip to white sooner). Pick other textures with `kit/scripts/find_textures.py`.
- The R15 dummy is posed by FK on anchored parts: no leg IK, no Animator, Edit mode only. It is a review stage, not
  game code: to ship the effect, rebuild its layers for your game's runtime (or `kit/runtime/VFXTimeline.luau`).
