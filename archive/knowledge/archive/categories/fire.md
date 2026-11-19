---
title: Fire and flame VFX - lessons from 7 open-source effects
source: open-source VFX library (Discord packs) studied 2026-11-13
tags: [vfx, fire, flame, particles, roblox, os-library, brightness, light-emission, flipbook, three-tone]
---

# Fire and flame: what 7 open-source effects teach

Evidence: freeze-frame stills from the Edit-mode replayer (the first capture (not shipped), full-res frames in
full-resolution frames (not shipped)), the layer tables (`library/cards/<category>/<id>.md`), the raw property dumps (the decoded pack files (`kit/scripts/rbxdump.py`), read for
exact curves, Rate and Enabled) and the one effect with scripts (`oragnecubething`). Things the effects' own scripts did
(spinning parts, enabling layers late) are missing from the stills and are flagged where they matter. Studio was not
used. "Inferred" = my reading, not measured. Brightness/LightEmission claims come from the stills and should be checked
in Studio once. Re-checked 2026-11-14 against the recapture (`gallery/effects/fire/<id>.jpg`:
effects placed by their emitters on the floor, camera locked, bluer-grey stage). The first capture had flame2 and the
cube partly under the floor; their notes below were rewritten from the new frames.

Two families show up. **Burst** effects fire everything at t=0 and let lifetimes make the timeline (FireTowers, the
cube's explosion). **Sustained** flames run emitters at a Rate (fire orb, torch, hand flame, fire bed, "sun"). The recipe
at the end (`fire_recipe.luau`) is a burst built from both.

Library context (fire-named emitter layers, n = 3,878, in the 1,227 effects tagged fire; `catalog/effects.jsonl`):
LightEmission p10/p25/p50/p75/p90 = -1 / -0.2 / 0 / 0.55 / 1; Brightness = 1 / 4 / 10 / 15 / 35; Lifetime max =
0.2 / 0.4 / 0.56 / 0.8 / 1.25 s; Orientation FacingCamera 51 %, VelocityParallel 37 %, VelocityPerpendicular 7 %,
FacingCameraWorldUp 5 %; flipbook Grid4x4 82 %, Grid8x8 7 %, none 10 %; 32 % of multi-key colour ramps end near black
(luma < 40). So the median fire layer is NOT additive (LE 0) and is bright (Br 10).

---------------------------------------------------------------------------------------------------------------

## a. The 7 effects

### `6f9f67b2a7cf` FireTowers "fire tower things1" (190 OS) - ground fire eruption, 1.2 s, the best burst here
- 44 emitters on one Attachment, every one a single burst at t=0 (EmitCount 1-15). The order on screen comes only from
  lifetimes: 0.05-0.1 s flashes, 0.25-0.5 s flames and column, 0.5-1 s ground rings and smoke, 1-1.5 s scorch.
- Phases: **flash 0-0.05** (huge soft orange glow, Size 32, a vertical flare and the column start; the recapture's
  0.03 s frame is empty, so the flash is not reliable, see e.7); **peak 0.1-0.2**
  (column taller than the ground ring is wide, running out of frame; flame blobs flung up it; a spiky ring flat on
  the ground); **cool 0.2-0.55**
  (column and blobs go red then oxblood, grey smoke, red ground ring); **linger 0.55-1.0** (glowing cracks on the
  ground); **1.2** only a faint dark scorch disc, barely darker than the floor. Measured warm-pixel colour, median / 90th pct: 0.03 s (242,46,2) / (255,254,64); 0.2 s
  (229,34,0) / (255,145,14); 0.55 s (103,2,0) / (238,115,47) - yellow to red to oxblood without any track.
- Roles: flash = `13189667061` x2 (glow dot flipbook, one copy Squash 1), `131352238269113`, `93876593554856`; ground
  starburst `16892268625`; column `17703378809` x3 (FacingCameraWorldUp, Squash 0 -> 3); flame blobs `109903311910886`,
  `16504098653`, `13528076463`; rising shards `118422915306523`, `118323587821210`, `74091341996632`, `119387723789903`;
  flat ground stack `13800461961`, `110017652984281`, `17000896359`, `18707464177`, `130341645640774`, `95382709647093`,
  `17612099597`, `121552805259111`, `14995139783`, `13795445083`, `16442657509`; cracks `124744903601692` +
  `82556288879264` + `87418254231660`; smoke `102953958619237` x5; grey LE -1 veils `109204940734898`,
  `135279586943950` (`#595959`, Tr 0.9).
- Why it works: (1) colour ramps that end near black (`#FF431D -> #1E0702`) so each layer cools into ink by itself;
  (2) one upright column sprite stretched by Squash; (3) a dense flat ground stack (rings + cracks + dark twins) that
  outlives the flames and anchors the effect; (4) flashes at Br 25 that live 1-6 frames.
- Weak: 44 emitters with duplicates (`102953958619237` x5); almost every layer fades Tr 0 -> 1 linearly so everything
  dims together; flash Lifetime ranges start at 0 (a roll near 0 = no flash); grey LE 0 smoke reads cold blue-grey.

### `56ff37281fe7` The sun! (2026 part 2) - a sustained 2 s fire "sun"/aura, radius ~10 studs
- 22 emitters, all Rate-driven: EmitDuration 2 s (most) or 3.5 s (white streaks, wind, smoke); EmitCount 0-15.
- Phases: **build 0.1-0.35** (white streaks shoot first, crescent dome by 0.2); **sustain 0.35-2.0** (churning orange
  and black crescent arcs, white-grey swirl core, orange 4-point star, white streaks); at **2.0** the 2-s layers stop;
  **2.6** only streaks, pale smoke and the grey core; **3.6** thin orange arcs (`15441066093`, life 3 s) and smoke;
  tail to ~5 s.
- Roles: solid orange arcs `16897191960` (LE 0, Br 12, RotSpeed 444) and `90258917420631` at Br 5; their **black twin**
  `90258917420631` at Br 0 ("Shaded Aura", same size 29.5); swirl core `13603608421`, `15011464541` (x2, Squash +2 / -2),
  `13844830230`, all LE -1 Br 250; star `77377738193796` (z 5); streak pair `107683303782344` (white LE 1 + black LE 0);
  smoke `80874274718676`, `15072761142`; wind swirl `16397543640`; charge `14704600122`; one long yellow needle
  `9742976067`.
- Why it works: orange and black arcs of the same texture at random rotation interleave (three tones from one sprite);
  LE 0 + Br 12 makes the arcs solid saturated orange-yellow (screen median (255,87,6), 90th pct (255,212,24)).
- Weak: ~800 particles/s for 2 s; the Br 250 LE -1 core renders grey-white, not hot (99th pct ~(213,215,221)); white
  streaks and pale smoke go blue-grey over a blue sky; no single silhouette, it reads as a churning aura.

### `818f3ffd4aef` RoVfx Flame Slop (190 OS) - torch flame, ~2.5 studs, continuous
- 20 emitters, nearly every one Color `#FF4722` (smokes `#FF3A0A`), all Rate except one burst of 14 at t=0.
- Phases: 0.03-0.1 red smudge (the 14-particle LE -2 burst `13367803563`, orange -> black ramp); 0.2 first curled
  core with a dark smoke loop rising above it; **steady from 0.35 s** (= flame life max 0.86); yellow-white core, orange
  curly body with small tongues on top, red edges, embers to ~1 stud above, and grey-black smoke wisps rising about
  1-1.5x the flame height above it (they read against the sky in the recapture).
- Roles: core `119272314820246` (LE 0 Br 12, z 2) + `138270984714302` (LE 1 Br 8) + `16847138652` (Br 5); flame flicks
  `16847071704`, `16708557658` (VelocityParallel, spread 25); dark swirls `126052664189577`, `15811547630` (LE -8,
  orange -> black); ink smoke `16867342570` (LE -0.5, Br 0), `16867492882` (Br 0), `16860461660` (Br 0), maroon smoke
  `15072761142` (Br 0.2), `11858203067` (Br 0.33); embers `115530057206994`, `103222240579945`; spark streak
  `72464786650138`; halo `107186854128142` (LE 1 Br 3, FacingCameraWorldUp, Size -> 5.4); 2 PointLights.
- Why it works: ONE hue, value set by Brightness (0 / 0.2 / 0.33 / 2 / 5 / 8 / 12 / 15 = black -> maroon -> orange ->
  yellow-white); short flames (0.35-0.86 s) under longer smoke (0.66-1.45 s) and embers (1.3-3.4 s).
- Weak: 20 emitters, ~170 particles/s for a 2.5-stud torch; LE -8 is far outside the documented range.

### `1fd017316313` flameos (2026 part 2) - purple hand flame on a rig arm, ~2 studs, continuous 5 s
- 28 emitters on one Attachment off the Right Arm, all Rate for EmitDuration 5 s.
- Phases: already visible at 0.03 (lifetimes 0.1-0.65 s), full at 0.1-0.2, steady to 5 s. On screen: pink-white core
  at the base, violet body, dark indigo wisps rising above the flame (they read against the sky in the recapture),
  small specks flying out and up.
- Roles: body = toon smoke/fire flipbooks `16867397491`, `11827618350`, `16867548275`, `126287684189183`,
  `81110833835270`, `125578376132704` at LE -0.75..-1.5, Br 5-35, `#5726F3`/`#7339F3`; core `137806784992714`
  (LE -1.5 Br 35, FacingCameraWorldUp, spread 5); ink `123704686542503`, `16867514432`, `132271580778174` (`#190C4A`
  at Br 0.25-0.5), `14919880888` (`#070419`); specks `74047287675215`, `127186152406798`, `104010557159978`,
  `128838952167682`, off-centre orbiters `15419189018`, `16879806460`; ring `91958284756655` LE 1 Br 15 + Br 0 twin.
- Why it works: burst-out-then-rise motion (Speed 5, spread 360, Drag 5, Acc +15..25); a fade-in of 1-2 frames then a
  hold (Tr 1 -> 0.3 @6 % -> 0 @23 % -> 0.08 @49 % -> 0.49 @80 % -> 1); negative LE + near-black indigo ink keeps
  the violet saturated.
- Weak: 28 emitters / ~200 particles/s for a 2-stud flame; its PointLight is disabled.

### `521e568eee6a` flame2 (2026 part 2) - fire orb floating over a ground glow, continuous
- 23 emitters + 4 Beams (`14029063178`, Tr 0.9), Rate 10-100 each, ~790 particles/s. The flame attachment sits 4.18
  studs above the ground-glow attachment and the beam ring (inferred: meant to sit on a brazier or torch top). The
  first capture hid the lower half; the recapture shows a ball, not a campfire.
- Phases: 0.03 only a flat orange annulus on the floor (inferred: the 4-beam ring drawn before its texture loaded; at
  LE 1, Br 6, Tr 0.9 an untextured beam is ~60 % of its colour); 0.1 a red-pink blob (the ramp's red birth key);
  0.2 a small yellow core spraying sparks; 0.35 a white-yellow ball; **steady from 0.55**: white-hot ball (~3 studs,
  estimated) in a golden swirl halo (~8 studs), pinkish-grey haze above, sparks, and a faint orange swirl ring on the
  floor below.
- Roles: hot ball `9470659899` (Grid8x8 A, LE 1 Br 5, Tr 0, Size 0 -> 4.13) + `13712003438` (Size 1 -> 2.49);
  body ~10 flipbooks (`92411870095278`, `13131157579`, `94226968127691`, `103222240579945`, `138270984714302`,
  `120154460257489`, `133171799071569`, `13655845087`, `119272314820246`) at Tr 0.8-0.95, Size 0 -> 5.5-15.7
  (envelope 0.3-0.8), ramp `#E80606 -> #F9E93C @0.34 -> #D07F1E @0.43 -> #F77607 @0.56 -> #F70707`; flat glow under
  the orb, on the floor 4.18 studs down: `119272314820246`, `13026594575`, `16924755732` (VelocityPerpendicular,
  LE 0 Br 25, Tr 0.9-0.95, Size -> 7-8) plus the beam ring (radius 3, Width 3, CurveSize 1.65 = 0.55 r);
  dusk puffs `11822996479`, `110017652984281` (`#783535`, random flat cards); embers `115530057206994` x4 (Br 100).
- Why it works: the two Tr 0 core layers are the only opaque things and read as a white-hot ball; ~10 faint additive
  layers (Tr 0.8-0.95, Rate 10-50 each) stack into a soft golden halo round it (d.30); embers at Br 100, Size 0.25,
  Speed 0-50 with Drag 15 pop out and stop.
- Weak: no flame shapes at all (every body layer is 80-95 % transparent), so it reads as an orb, not a fire; body
  Acceleration -1.7..-4.85 Y makes the halo sag under the ball; 400 embers/s; the beams barely show once textured.

### `9e5d9d9528da` firevfx (2026 part 2) - ground fire bed, continuous
- 9 emitters on a flat 4.2 x 8.9 stud union (volume emission), Rate 5-10, Lifetime 2 s, Tr 1 -> 0 @0.5 -> 1.
- Phases: first orange at ~0.2; two dim orange clouds at 0.35; an orange cloud with pale grey puffs on top at
  0.55-0.8 (which layer makes the puffs is unclear); white-hot from 0.8; at 1.2-1.8 a bed about as wide as the
  8.9-stud union, white-hot inside with dark brown ragged rims; embers from 0.8; steady after 2 s.
- Roles: each flame flipbook twice: bright `15433989948`, `13486412595`, `18369800560` at LE 2, Br 3, `#FF7430`
  (Size 2.87 / 5.98) + dark twin LE 0, Br 1, `#843D19` (Size 2.39 / 5.98, z -0.1); specks `1851669703`,
  `127583435334430` (LE 2); dark puff `965116971` (LE -1.12, `#33261E`, z -0.2). Acceleration (0, 2.39, -1.91).
- Why it works: the wind lean (acceleration sideways) and the bright + dark twin idea: the dark twins show as brown
  rims wherever they stick out past the white core (1.2-1.8 s).
- Weak: LE 2 on five overlapping layers at Tr 0 = a white blob with no flame shapes (90th pct warm pixel
  (255,255,249)); the dark twins only read at the outer rim, inside the core they are washed out; 1 s fade-in for a
  fire that should just be there.

### `d9609eb01ee4` oragnecubething "pyroflow/flairon" (190 OS) - fire cube world prop
- 67 emitters. A translucent Neon 5-stud cube with surface glow, corner streaks, inner haze and two fire orbs on a
  pivot spun by Scripts. A server Script loops: wait 8-15 s, `charge:Emit(100)`, 0.3 s, `shockwave:Emit(25)` +
  `sparkles:Emit(150)`, 0.3 s, then enables flame jets (`12656840930` Flames, `12800351571` Haze, `1269254614` Lines,
  `564847326` Rings, `1084969997` Vortex, `12224333321` Sparkles) for 5-8 s.
- **Missing from the stills**: the jets (Enabled = false in the file, turned on by the script) and the orb spin.
  The replayer fired charge 50 @0 and shockwave 25 + sparkles 150 @0.5 (their attributes).
- Phases on the stills (recapture, whole cube visible): 0.1-0.35 short orange streaks spread over ~3x the cube width,
  mostly above it, close in (charge), small flame curls in the cube and both orbs (`12807576476`, EMIT 25, TimeScale
  0.45); 0.55 white-ish corner marks, the cube's inside turns into a bright orange-yellow fireball (inferred: the
  converged charge sprites stacking) through 0.8; 0.8-1.2 a soft orange halo of arcs swells to ~2x the cube (shockwave)
  and fades by 1.8; orange 4-point sparkles (~1 stud) fly out from 0.8 and twinkle to ~3.5 s; from 1.8 the idle state:
  glowing orb dots, a 4-point star in the cube centre (`12713358795`, z 6) and orange heat haze rising ~1 cube height
  above it.
- Why it works: off-centre charge (big shrinking sprites); a halo from 25 randomly rotated crescents; looping 2x2
  sparkle flipbooks for twinkle; TimeScale 0.45-0.75 on single layers to slow them.
- Weak: ~1,040 particles/s idle (24 corner emitters at Rate 20 = 480/s), ~2,700/s with jets; spin Scripts run
  `repeat ... wait(.00001) until pigs == 1` (never ends, server-side, replicates every step); all Enabled toggles sit
  inside `if sound then`, so without the sound nothing turns on.

---------------------------------------------------------------------------------------------------------------

## b. Anatomy of a fire / flame effect

Units: for bursts, **R** = final Size of the main ground ring (FireTowers Size 17.9; a particle's Size is its half-width, measured 2026-11-14, so that
ring sprite is ~36 studs across). For
sustained flames, **H** = visible flame height on the stills (flameos ~2, Slop ~2.5 studs; flame2 is a ball ~3 studs
in a ~8-stud halo, estimated).
LI is 0 everywhere except the cube's haze (0.5-1) and sparkles (0.5).

### Burst (firing order)

| # | Role | Texture (ids) | LE / Br | Lifetime | Size curve, peak | Transparency | Motion | Orientation, Squash, flipbook | Count, z |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Charge-in (before t=0) | off-centre marks: `2545904564`; radial streaks `14704600122` | 1 / 1 (cube); 0 / 25 (sun) | 0.2-0.5 | shrink 0.7-2 R -> 0 (cube 12.6, envelope 7.15 = 57 %; sun 35.6) | 1 -> 0.2 @0.5 (env 0.2) -> 1; sun ~0.96 (faint) | Speed 0, Drag 1.75, Rotation +-180, RotSpeed +-50 | FacingCamera; Squash -1 -> -0.71; none | 10-100, z 0-2.5 |
| 2 | Flash | glow dot `13189667061` (4x4), `131352238269113` (8x8), `93876593554856`, column copy `17703378809`; streak flash `110520773428204` | 1 / 25 (streak 15, column copy 2) | {0, 0.05-0.1}; streak 0.03 | grow 0 -> 1-1.8 R (17.4-32), soft ease (16/31/45/58 % at 0.1/0.2/0.3/0.4 life) | 0 flat | ~0.005 (streak: 19-1036, VelocityParallel) | FacingCameraWorldUp; one copy Squash 1 (vertical flare), streak 0 -> 3 | 1, z 5-15 |
| 3 | Ground starburst | spiky star `16892268625` (flat) | 1 / 25 | 0.1 | 0 -> 0.6 R, punchy ease (19/54/73/83 %) | 0 | 0.004 | VelocityPerpendicular, dir Top | 1, z 5 |
| 4 | Hot core | `119272314820246` (LE 0 Br 12), `9470659899` + `13712003438` (LE 1 Br 5, Tr 0), `137806784992714` (LE -1.5 Br 35) | 0..1 / 5-35 | 0.3-0.6 | 0.5-0.7 H (Slop 0.2 -> 1.4; flame2 0 -> 4.13) | 0 -> 1, or 1 -> 0 @6 % hold -> 1 | 1-5 up, spread 0-5 | FacingCamera / WorldUp; 4x4-8x8 OneShot | Rate 7-10 or a burst, z 0.1-3 |
| 5 | Column | `17703378809` | -1 or 0 / 5 | 0.25-0.5 | const 0.7-1.2 R (13.1, 20.9) | 0 -> 1 | ~0 | FacingCameraWorldUp; Squash 0 -> 3 (0.48 @0.1, 0.94 @0.2, 1.75 @0.4) or 0 -> 1; 4x4 | 1, z 0 |
| 6 | Flame blobs flung up | `109903311910886` (8x8), `16504098653`, `13528076463` | 0 / 15 | 0.25-0.5 | shrink 0.29 R (5.16, env 0.81) -> 0 | 0 | Speed 50, Spread 90, Acc (25, 50, 25) | VelocityParallel; 4x4/8x8 OneShot | 5 each, z 5 |
| 7 | Rising tongues/shards | `118422915306523`, `118323587821210`, `74091341996632`; dark `119387723789903` | 1 / 5 (dark: 0 / 5 `#441401`) | 0.18-0.5 (dark 0.25-1) | swell 0 -> 0.33-0.55 R @0.37 (env ~46 %) -> half @0.52 -> 0 | 0 | Speed 1.8-141 (25x range), Spread 0 or 25, no drag | FacingCameraWorldUp | 3, z 0 |
| 8 | Shock ring (bright) | `18707464177`, `130341645640774` | -1 / 25 | 0.5-1 | 0 -> 0.83 R, punchy ease | 0 | 0.005 | VelocityPerpendicular, dir Top, 4x4 | 2, z 5 |
| 9 | Ground ring (cools to ink) | `13800461961`, `110017652984281`, `17000896359`, `95382709647093`, `17612099597` (2x2) | 0 / 1 | 0.5-1 | 0 -> 0.55-1.1 R, soft ease | 0 -> 1 | 0.003-0.006 | VelocityPerpendicular, Rotation +-360 | 1-3, z 5 |
| 10 | Sparks | `115530057206994` (flame2), `72464786650138` | 1 / 100 (or 0 / 15) | 0.2-0.6 | 0 -> 0.25 (0.01 R) | 0.5 -> 1 | Speed 0.01-50, Drag 15, Spread 360, Acc +-50 Y | VelocityParallel; spark streak Squash 0 -> 0.375 | Rate 100 (x4); burst ~40 |
| 11 | Smoke | `102953958619237` (grey toon), `16867492882`, `16867342570`, `15072761142`, `109204940734898` | 0 (or -0.5..-1) / 0-1 | 0.5-1.45 | 0.65-1.3 R shrinking ~33 % (env 20 %), or grow 0 -> 0.8 R | 0.84-0.98 -> 1 | Speed 0.4-45, Acc +2..+50 Y, Drag 1-3 | FacingCamera, 4x4 | 1-15, z 0-1.3 |
| 12 | Scorch / cracks | `124744903601692` + `82556288879264` (`#240000`) + `87418254231660` (`#C6462C`); `16442657509` | 1 / 25 bright; 0 / 1 dark | 1-1.5 | 0 -> 0.6-0.9 R, punchy ease | 0 -> 0.485 @0.68 -> 0.95 | 0.004-0.005 | VelocityPerpendicular, 4x4 | 1, z 5 |
| 13 | Twinkle embers (linger) | `12224333321` (2x2 Loop 16-25 fps) | 1 / 6.3 (LI 0.5) | 0.5-3 | 0.364 (env 0.364) -> 0.351 @0.88 -> 0 | 1 -> 0 @0.34 -> 0 | Speed 3-43, Drag 2.5, Acc -1 Y | FacingCamera | 150 (cube) |
| 14 | Light | PointLight | Br 0.6-6 | effect length | Range 3-12 (~0.5 R) | | | | Shadows on in Slop |

### Sustained flame (all concurrent, Rate per layer)

| Role | Values seen |
|---|---|
| Hot core / seat | Size 0.5-0.7 H; LE 0 + Br 12 (Slop) or LE 1 + Br 5 at Tr 0 (flame2) or LE -1.5 + Br 35 (flameos); life 0.3-0.6; Rate 7-10; z 0.1-3 (in front). |
| Flame body | 3-10 flipbooks (4x4 OneShot, random Rotation); Size grows 0 -> 0.4-1.5 H (flame2's faint halo layers reach 5.5-15.7 studs), eased ~40 % of final by 20 % and ~64 % by 40 % of life (flameos); envelope 20-45 %; life 0.1-0.86 s (flame2 0.6-1.2); Speed 1-6 with Spread 25-360, Drag 4-7, Acc +12..+25 Y (rise then stop); Rate 2-22 each; Tr 0 (Slop, flameos hold) or 0.87-0.95 with Rate 25-50 (flame2: only a halo round its core, never flame shapes). |
| Flicks | VelocityParallel, Spread 25, Speed 1-6, Size 0.77 -> 1.4 (Slop); spark streaks Speed 8-15, Drag 7, Squash 0 -> 0.375. |
| Ink / smoke | LE <= 0 with Br 0 (black, any Color) or Br 0.2-0.5 on the flame hue (maroon, `#190C4A` indigo); Size 0.6-1.2 H; life 1-2x the flame life (0.66-1.45 s); Tr 0.84-0.94 -> 1, or thickening 0.94 -> 0.36 @0.72 -> 1; Spread 177, Drag 1-3, Acc +2..+4.4. |
| Embers | Size 0.1-0.5 shrinking to 0; life 1.3-3.4 s; Speed 3-5, Spread 150, Drag 2-3, Acc +7.44 (drift up, Slop) or Speed 0-50, Drag 15 (pop and stop, flame2); Br 15 at LE 0 or Br 100 at LE 1; Rate 5-8 (Slop). |
| Specks / orbiters | off-centre `15419189018`, `16879806460`: Rotation 90-150, RotSpeed +-110..130, Size 1.3-1.5, life 0.45-0.78. |
| Halo / haze | Size 2-15 H at Tr 0.8-0.97 (`107186854128142` 5.4; cube `448862775` 31-33 at Tr 0.95-0.97, life 6, Rate 0.4). |
| Light | PointLight #FF6141-ish: Br 3 Range 7 + Br 1 Range 12 (Slop), Br 2 Range 8 (firevfx), Br 0.6 Range 5.7 (flame2). |

---------------------------------------------------------------------------------------------------------------

## c. Timing

Burst (seconds from the trigger):

| Phase | FireTowers | Cube explosion | Sun onset | Recipe (`fire_recipe.luau`) |
|---|---|---|---|---|
| Anticipation | none | charge 0 -> 0.3 (script) / 0.5 (attrs), life 0.35-0.5 | streaks 0 -> 0.1 | charge 0 -> 0.35 |
| Flash | 0 -> 0.05-0.1 (1-6 frames; missing in the recapture) | - | - | 0.35 -> 0.45 |
| Peak | 0.05 -> 0.2 | core 0.55 -> 0.8, halo largest ~1.2 | dome formed 0.2 -> 0.35 | 0.35 -> 0.6 |
| Cool (colour -> oxblood, smoke) | 0.2 -> 0.55 | halo fades 1.2 -> 1.8 | (sustained to 2.0) | 0.6 -> 0.95 |
| Linger | 0.55 -> 1.0 (cracks, life 1-1.5); faint scorch at 1.2 | sparkles to ~3.5 | 2.0 -> 5 (life-3 arcs) | to ~1.5 (embers ~3.4) |
| End | ~1.2 | ~3.5 (then idle) | ~5 | ~1.5 main, 3.4 last ember |

Spread across the group: flash always <= 0.1 s; the peak lands 0.05-0.35 s after the trigger; a burst's main body is
over by 0.6-1.2 s; lingering marks/embers add 1-3 s.

Sustained: the flame reaches its steady look after ~1x its longest flame lifetime (flameos 0.2 s, Slop 0.35 s,
flame2 0.55 s, firevfx ~1.2-2 s because of its 2 s triangle fade); after the emitters stop it takes the longest
lifetime to clear (0.65 s flameos, 3.4 s Slop embers, 3 s sun arcs).

---------------------------------------------------------------------------------------------------------------

## d. Techniques catalogue (exact recipes)

1. **Brightness is the value knob on ONE hue** (Slop). Color `#FF4722` everywhere; Br 0 (`16867492882`,
   `16860461660`) = black smoke, Br 0.2 (`15072761142`, Color `#FF3A0A`) = maroon smoke, Br 0.33 (`11858203067`) dark
   red, Br 1-2 (`138372515259698`, `122954463046434`) orange, Br 5 (`16847138652`, `16708557658`) bright orange, Br 8
   (`16847071704`), Br 12 (`119272314820246`) yellow-white core, Br 15 (`72464786650138`, embers). Inferred from the
   stills: at LE 0, Br > ~5 pushes the dense centre of an orange sprite toward yellow/white while soft edges keep the
   hue. This extends the vault note "LE 0 + high Brightness stays saturated": true at the edges, not in the core.
2. **Br 0 = ink twin of the same sprite** (sun): `90258917420631` at LE 0 Br 5 `#FF4010` + the same at Br 0, both Size
   29.5, life 0.5, Rate 15, Rotation -360..360, VelocityParallel Speed 0.0098 Spread 360 -> orange and black arcs
   interleave. flameos: ring `91958284756655` LE 1 Br 15 Size -> 1.5 life 1 + LE 0 Br 0 Size -> 2 life 0.5 = a black
   rim behind the bright ring.
3. **Same flipbook, bright + dark twin**: firevfx `15433989948` LE 2 Br 3 `#FF7430` Size 2.87 z 0 + LE 0 Br 1 `#843D19`
   Size 2.39 z -0.1 (reads only as a brown rim where it sticks out past the core, see e.2); sun streaks `107683303782344` white LE 1 Tr 0.6 + black
   LE 0 Tr 0.4, Speed 153-842, Drag 24.6, life 0.13-0.2, Squash 0 -> -2 (envelope 1); FireTowers cracks bright
   `124744903601692` (LE 1 Br 25 `#FF3B00`, -> 15.9) + dark `82556288879264` (`#240000`, -> 11) + mid `87418254231660`
   (`#C6462C`, -> 11), same life 1 and Tr 0 -> 0.485 @0.68 -> 0.95.
4. **Colour ramp that cools into ink**: `#FF431D -> #1E0702` over life on 12 FireTowers layers (column `#FF431D ->
   #6A1C0B @0.18 -> #3A0F06 @0.24 -> #1E0702`). Flame blobs: `#FF4B08 @0 -> #9A2D05 @0.0035 -> #5B1407 @0.47 ->
   #270606 @0.99` at Br 15 renders yellow -> orange -> red (key at 0.35 % of life = colour for the birth frame only).
   Author a dark ramp x high Brightness: the visible ramp is roughly the ramp times Br, clipped (inferred).
5. **Upright fire column**: `17703378809`, Orientation FacingCameraWorldUp (stays vertical when the camera pitches),
   constant Size 13.1, Squash 0 -> 0.48 @0.1 -> 0.94 @0.2 -> 1.75 @0.4 -> 3 @1 (positive Squash = taller, thinner),
   life 0.5, LE -1 Br 5, ramp to `#1E0702`; plus a Size 20.9 copy (life 0.25, Squash 0 -> 1, LE 0) and a flash copy
   (LE 1 Br 2 `#FF7A3E`, Size 8.48, life 0-0.05).
6. **Blobs flung up and curling**: VelocityParallel, Speed 50, SpreadAngle 90 (dir Top), Acceleration (25, 50, 25),
   Size 5.16 (env 0.81) -> 0, life 0.25-0.5, 5 per flipbook x 3 flipbooks, LE 0 Br 15, z 5.
7. **One burst of 3 = a tower of tongues**: FacingCameraWorldUp, SpreadAngle 0, Speed 4.7-118 (or 5.6-141),
   life 0.18-0.36, Size 0 -> 5.87 @0.37 (env 2.72) -> 2.93 @0.52 -> 0. Each tongue tops out at a different height.
8. **Flash**: `13189667061` LE 1 Br 25, Size 0 -> 32 (soft ease), Lifetime {0, 0.1}, ZOffset 15, FacingCameraWorldUp,
   plus a twin with Squash 1 and Rotation 0 (vertical flare); `131352238269113` (8x8) life {0, 0.075}; `93876593554856`
   life {0, 0.05}. Sun streak flash `110520773428204`: life 0.03, Size 4.6 -> 15.6, Squash 0 -> 3, Speed 19-1036,
   VelocityParallel, Br 15, z -1.
9. **Flat ground stack**: VelocityPerpendicular + Speed 0.003-0.006 + SpreadAngle 0 + EmissionDirection Top +
   Rotation -360..360, all ZOffset 5. Two ease shapes: soft (16/31/45/58/70 % of final at 0.1/0.2/0.3/0.4/0.5 life) for
   rings, flashes and smoke; punchy (19/54/73/83/90 %) for starbursts, cracks and shock rings.
10. **Negative LightEmission**: -0.5..-1.5 on toon smoke/flame flipbooks with Br 5-35 (flameos, Slop); -1 with Br 25
    on bright ground rings (`18707464177`, `130341645640774`); -2 Br 8 on the opening puff (`13367803563`); -8 Br 12 on
    swirls with Tr 0.59 / 0.975 and ramp to black (`15811547630`, `126052664189577`, RotSpeed +-100, life 0.3-0.5);
    -1 Br 250 on the sun core. 16.7 % of fire-tagged layers in the library are negative. Inferred effect: it darkens
    what is behind more than normal blending while the colour still adds, so the sprite looks thicker and outlined.
    Undocumented range: re-check after engine updates.
11. **LightEmission above 1**: firevfx LE 2, Br 3 - harsher additive; with 5 layers it whites out (e.1).
12. **Huge Brightness on tiny things**: embers `115530057206994` LE 1 Br 100 at Size 0.25 (flame2); Slop embers LE 0
    Br 15 at Size 0.1. Small sprites need 10-100x the brightness of big ones.
13. **Off-centre converge (charge)**: `2545904564`, Size 12.6 (env 7.15) -> 0, Speed 0, Drag 1.75, life 0.35-0.5,
    Tr 1 -> 0.2 @0.5 (env 0.2) -> 1, Squash -1 -> -0.71, Color `#FF4006 -> #FFA145`, Rotation +-180, RotSpeed +-50,
    EmitCount 50 (script: 100). Marks far out on a big sprite slide to the centre as it shrinks. Sun variant
    `14704600122` Size 35.6 -> 0, life 0.2.
14. **Burst out, then rise** (small flames): Speed 5, Spread 360, Drag 5, Acc +15..25 Y (one speck layer +104 with
    life 0.09-0.15); Slop: Speed 1-6, Drag 4-7, Acc +12.
15. **Fade-in-and-hold envelope** (flameos): Tr 1 -> 0.297 @0.058 -> 0 @0.227 -> 0.079 @0.485 -> 0.491 @0.798 -> 1.
    Core variant: 1 -> 0 @0.058, hold to 0.817 -> 0.35 @0.868 -> 1.
16. **Smoke that thickens as it cools** (Slop `15072761142`): Tr 0.944 -> 0.562 @0.27 (env 0.2) -> 0.356 @0.72
    (env 0.19) -> 1.
17. **Size envelope for variety**: 16 % (flame blobs 5.16 +- 0.81), 30-45 % (Slop smokes 1 +- 0.455), 46 % (tongues),
    57 % (charge 12.6 +- 7.15). flame2 uses it on every body layer (0.2-0.79).
18. **Random flat cards for volume**: VelocityPerpendicular with SpreadAngle 5454 (flame2), 500 (cube Shine,
    innerHaze) or +-1000 (sun), Speed 0.001-0.01: flat rings/puffs at random angles.
19. **Crescent halo**: `1084965356` (arc on black, additive) EMIT 25, FacingCamera, Rotation +-180, RotSpeed +-360,
    Size 0 -> 9.36 (env 5.3), life 0.25-1, Tr 1 -> 0.59 @0.5 (env 0.47) -> 1, LE 1 Br 1, `#FF4006`.
20. **Solid spinning crescents** (sun): `16897191960` LE 0 Br 12 `#FF4010`, VelocityPerpendicular, Speed 0.039,
    Spread 180, RotSpeed 444, Size 0 -> 7.78 @0.15 -> 19.4, life 0.15-0.2, Tr 1 -> 0.78 @0.5 -> 1, Rate 45, z 1.21.
21. **Squash cross**: the same flipbook (`15011464541`, Size 10.1) twice with Squash +2 and -2 (sun core): one tall,
    one wide, crossing.
22. **Twinkling sparks**: `12224333321` Grid2x2 Loop, FlipbookFramerate 16.2-24.6, LE 1, LI 0.5, Br 6.3, Size 0.364
    (env 0.364) -> 0.351 @0.877 -> 0, life 0.5-3, Speed 3-43, Drag 2.5, Acc -1 Y, Tr 1 -> 0 @0.34 -> 0.
23. **Wind lean**: firevfx Acceleration (0, 2.39, -1.91) with Speed 2.39 up: flames lean ~39 deg.
24. **Corner streaks on a block**: `867619398` Size 0.1, Speed 1.25, Spread 1, Acceleration (0.5, 0.5, 0) on an
    Attachment at each corner rotated so the two axes run along the edges, life 1.25, Rate 20 -> glowing "Y" marks.
25. **Surface glow on a part**: `867619398` directly on the Part, Shape Box, ShapeStyle Surface, ShapeInOut Inward,
    VelocityPerpendicular, Size 0.7, Rate 35, Tr 1 -> 0.83 @0.5 -> 1, LE 1 Br 0.54, z 1.5, one emitter per face direction.
26. **Per-layer TimeScale < 1** to slow a flipbook or motion: 0.25 (debris), 0.45 (`12807576476` 20 fps flipbook),
    0.5 (Flames Loop 40 fps), 0.6-0.75 (haze, charge, shockwave). Our VFXTimeline overwrites TimeScale, so retime
    with Lifetime/FlipbookFramerate instead.
27. **Two lights**: Slop PointLights Br 3 Range 7 + Br 1 Range 12, `#FF6141`, Shadows on: hot near, soft spill.
28. **ZOffset order**: flash 15 > ground stack 5 = flame blobs 5 > core/specks 2-3.5 > body 0-2.4 > smoke 0.3-1.3 >
    dark twins -0.1..-3 > haze -1..-1.5 (cube Glow +6 is a faint wash in front).
29. **Short flames under long smoke**: Slop flames 0.35-0.86 s, smoke 0.66-1.45 s, embers 1.3-3.4 s (about 1 : 1.7 : 4).
30. **Halo from many faint layers** (flame2): ~10 flipbooks at Tr 0.8-0.95 (two at LE 0, the rest LE 1 Br 5), Rate
    10-50 each, life 0.6-1.2, Size 0 -> 5.5-15.7 (envelope 0.3-0.8), round two opaque Tr 0 core layers (Size -> 2.5
    and 4.1) = a white-hot ball in a soft golden halo. Good for an orb or sun; it never makes flame shapes.

---------------------------------------------------------------------------------------------------------------

## e. Mistakes and weak spots (avoid)

1. **Additive white-out** (firevfx): LE 2 on 5 overlapping flipbooks at Tr 0 mid-life = a white blob with no flame
   shapes. Keep additive body layers at Tr >= 0.3 or LE <= 1, and carry the shape in LE 0 layers.
2. **Dark twin that barely shows** (firevfx): the dark copy is 17 % smaller and behind (z -0.1), so it only reads as a
   brown rim at the edges of the bed (1.2-1.8 s), never inside it. Make the ink copy the same size or bigger with its
   own rotation (sun Br 0 arcs), or put it on the rim on purpose.
3. **Everything faint** (flame2): Tr 0.8-0.95 on every body layer makes a soft halo round the two Tr 0 core layers, never
   a flame silhouette, so the "flame" reads as a glowing orb. A flame needs at least one opaque shape layer.
4. **Flame mass sinking** (flame2): body Acceleration -1.7..-4.85 Y makes the halo sag under the ball. Fire
   accelerates UP (+7..+50).
5. **Cold tones inside a fire** (sun, FireTowers smoke): white LE 1 streaks and grey LE 0 smoke over a blue sky read
   blue-grey; the Br 250 LE -1 core reads grey. Tint smoke maroon/oxblood (Br 0.2 on the flame hue) instead.
6. **Particle budgets**: sun ~800/s for 2 s, flame2 ~790/s (embers alone 400/s), cube ~1,040/s idle and ~2,700/s with
   jets, flameos ~200/s and Slop ~170/s for 2-3-stud flames. Vault cap: 400/s, 100 on mobile.
7. **Flash that can miss**: Lifetime {0, 0.05-0.1} on a single-particle layer can roll ~0. Use min >= 0.05.
8. **One fade for everything** (FireTowers): almost every layer Tr 0 -> 1 linear, so the whole effect dims together;
   cracks end at Tr 0.95 and pop. Give flashes a hold, smoke a fade-in, ground marks a late fade.
9. **Script plumbing** (cube): server Scripts spin parts in `repeat ... wait(.00001) until pigs == 1` (never ends,
   replicated each step); Enabled toggles nested in `if sound then`; 67 emitters, 24 of them corner copies.
10. **Duplicate layers**: FireTowers `102953958619237` x5 and `13800461961` x3 with near-identical settings.
11. **Too small for play**: flameos (~2 studs), Slop (~2.5), flame2 (~3-stud ball) are props; at gameplay distance they read as a
    dot. Scale the whole stack (sizes and speeds together), not single layers.
12. **Streaks through the floor** (sun): black VelocityParallel streaks at up to 842 studs/s cut dark wedges across the
    ground. Use EmissionDirection Top + Spread <= 90 for ground effects.
