---
title: Impact, slam and ground-hit VFX - lessons from 7 open-source effects
source: open-source VFX library (Discord packs) studied 2026-11-13
tags: [vfx, impact, slam, ground-hit, shockwave, dome, particles, roblox, os-library, three-tone, light-emission, brightness, squash]
---

# Impact / slam / ground hit: what 7 open-source effects teach

Evidence: the freeze-frame sheets (`gallery/effects/impact/<id>.jpg`, full-resolution frames in
full-resolution frames (not shipped)), the layer tables (`library/cards/<category>/<id>.md`), and the raw property dumps
(the decoded pack files (`kit/scripts/rbxdump.py`)) read for exact Size / Transparency / Squash / Colour curves, Rotation, EmissionDirection, Shape,
Rate, attachment offsets and the per-emitter `TimeScale` property. The sheets are the 2026-11-14 recapture: each effect
is placed with its lowest emitter ON the floor, each view is aimed at the effect, the camera is locked per effect and the
stage is a slightly bluer grey. A first capture (old placement: kick barrage and Yuji sat too low, Wukong sat higher than
the floor) differed in three places, noted where they matter: it is how the Wukong lesson in d28 was found. None of the
7 effects ships scripts in the library, but two carry script hooks the replayer does not run: a `CameraShake` RayValue
(Yuji) and two "Rings" debris folders (attributes `Radius`, `Segments`, `MinSize/MaxSize`: a scripted rock ring, kick
barrage and Yuji). Camera shake and rock rings are therefore missing from the stills. Studio was not used. "Inferred" =
my reading of the numbers, not measured. All LightEmission / Brightness claims come from the stills plus the numbers and
should be checked in Studio once.

Library context (effects tagged impact + floor or shockwave: 1,601 effects, 77,456 emitter layers;
`catalog/effects.jsonl`): LightEmission p10/p25/p50/p75/p90 = -1 / 0 / 0.2 / 1 / 1; Brightness = 0.15 / 1 / 2 / 10 / 25;
Lifetime max = 0.1 / 0.2 / 0.5 / 1.0 / 1.74 s; LE < 0 on 14.2 % of layers, Brightness exactly 0 on 5.9 %, pure black
Color on 5.5 %, emitter `TimeScale` < 1 on 11.1 %; Orientation VelocityPerpendicular 45.5 %, FacingCamera 32.7 %,
VelocityParallel 20.1 %, FacingCameraWorldUp 1.7 %. So half of an impact is flat ground cards, and a quarter of all
layers is non-additive or darkening.

R below = half of the effect's main ground-ring final Size (the effect's radius). Sizes are particle Size in studs
(the sprite's edge length), so "Size 2R" = a sprite as wide as the ring.

---------------------------------------------------------------------------------------------------------------

## a. The 7 effects

### `ea2342503619` Wukong "Slam1" (WukongSpinRushVFXos) - orange fire ground slam, 2.4 s, R ~ 12. The best one.
- **Phases (recapture, all its attachments sit at one point, so the whole effect is ON the floor):** 0.03: only a
  cluster of small grey smoke puffs (cut flat by the floor) and grey wind-swirl crescents, NO flash or core; 0.10 peak:
  a large orange glowing arch / hemisphere (~1.2-1.5R) over grey billow smoke, smoke cards with hard horizontal edges;
  0.20: translucent orange dome, gold specks and embers, huge pale swirl crescents, smoke 2x wider; 0.35: dome pale,
  glowing ember net on the ground; 0.55-0.80: tall smoke plumes (~2x dome height) and the ember net; 1.2: faint smoke;
  1.8: gone. The first capture (effect raised above the floor) showed the missing beat at 0.03 s: a white-yellow
  starburst core (~0.5R), a thin vertical stab ~1R above it, chromatic spark streaks and a dark disc behind (~2x the
  core). Those layers fire DOWN (EmissionDirection Bottom: stabs, Star3, Downwards / Shorter impact) or lie flat at y = 0
  (Fire42, Bezier1, Specs53), so the floor swallows them when the hit point is on it (d28; inferred from the two
  captures plus Yuji, whose same layers sit 3.9 studs up and do show).
- **Layer roles:** stab = `speed`/`speed3`/`speed4`/`speed5` (VelocityParallel, life 0.04, Size 14-20 shrinking to 0,
  Squash curves to +4.4 / -3; orange LE0 Br10 Transparency -50, orange LE0.8 Br0, two black LE0.95 Br0). Core =
  Fire42 `16860398159` (8x8, flat, 0 -> 10, life 0.1-0.2, LE0 Br10), Bezier1 `15423151910` x2 (Br50, life 0.05),
  Specs53 `17226944366` (LE-2 Br20), Full short impact `115475105765006` x5 (15.6 -> 0 in 0.08 s). Flash swell =
  R Impact `101995042384072` (FacingCamera LE1 Br5, 0 -> 45 = 3.7R in 0.09 s at TimeScale 0.6), Inverted muddy impact
  `104632340635453` (flat, LE0 Br25, 0 -> 32), Extra `18717313304` (FacingCamera LE0 Br15, 0 -> 25, 0.3 s), black
  Fixed circle impact `134557993252093` (LE0.9 Br10, 0 -> 28.5, 0.08 s). Dome = Impact333 `14457094589` (FacingCamera,
  orange LE0 Br35, 0 -> 14.1, 0.4 s) + two black copies (0 -> 14.6 and 7.3 -> 22, 0.2 s). Rings = Impact145
  `18765326355` and Impact70 `116897739829086` (flat, LE0.45, Transparency 0.765 -> 1). Swirls =
  `127940423551603` x5, `109440284900004` x4, `75104427275304`. Sparks = Star3 `17062416111`, Downwards Impact
  `129378836572027`, Shorter impact `14379744080` (LE -10). Smoke = Plume5 `8527116276`, Billowing `15415212938`
  (white and black), Stylized smoke `16867483883`. Embers = Glitter `16511093402` (LE -1, dark grey). Ground = 19 decals
  under the `Fire` attachment, life 1-2.4 s, every one as a FacingCamera + VelocityPerpendicular pair.
- **Techniques:** the floor-clipped dome (d1); black twins behind every bright shape (dome, flash, stab: d2);
  Brightness 10-50 on a saturated orange, which clips to white where the texture is bright and stays orange where it is
  dim, so one layer is both core and body (d6); ground decals whose Color ramps orange -> black at 60-70 % of life, so
  the glow cools into a scorch while it fades (d15).
- **Weak:** the smoke cards (FacingCameraWorldUp, Acceleration -29) cut hard horizontal lines where they cross the floor
  (visible 0.1-1.2 s); the core / stab / sparks all sit at the same point as the ground layers, so on a floor the first
  frames are empty (d28); 61 emitters, bursts of 3-15 each; the flat rings (52-stud ring never below 76.5 %
  transparency) are invisible in every still.

### `53681671d73f` Yuji "FinalHitModel" (YujiThings) - blue finishing slam, 2.0 s, R ~ 12
- **What:** the Wukong slam kit recoloured blue (#234CBD / #2E53B8 / #446FF9): about 30 layers are identical
  (Fire42, Bezier1, Downwards/Shorter impact, Specs53, Star3, Extra, Full short impact, Impact70/333/145, R Impact,
  Plume5, Billowing, Stylized smoke, the four `speed` stabs), plus its own flash, an eruption column, 12 spec emitters
  and Forge mesh models (two `Winds` columns that move DOWN from 14 studs to 4-7 studs in 0.35-0.65 s, a spinning black
  Neon mesh, `NormalShock`, `PlumeSmoke`, `SecondaryShroud` 1 s, two `SlowDecalHighlight` 1.2 s, `MassiveBlackMesh` x2).
  Mesh decals use Color3 values of 2-21.8 (overbright). A `CameraShake` RayValue is script-driven and absent.
- **Phases (recapture):** 0.03 peak: a bright blue-white spiky starburst on the ground inside a clear blue dome
  (~1R wide, glowing rim), a tall blue column of needles rising past the frame top, a white crescent arc above (a Forge
  mesh; which one is unclear), small grey dust at the centre; 0.10: the dome as a darker blue outline (~1.3x wider),
  grey billow (~0.5 of the dome), 3 cyan vertical needles, 4-point sparkles, blue orbs; 0.20: two smoke puffs, a dark
  elliptical ground ring ~1.5x the dome (source unclear: ground mark, black meshes or the flat rings), orbs flying out
  past the dome, one needle; 0.35: faint dome outline, larger dark ground ring, smoke columns, orbs; 0.55: tall smoke
  plumes, orbs, a faint ground-ring outline; 0.80: faint plumes; 1.2: almost gone; 1.8: gone.
- **Height offsets (why Yuji keeps the core that Wukong loses, d28):** relative to its lowest emitter (ground mark
  `impactdust1`, on the floor) the debris `Ring` sits +0.6, `NormalHit` (dome, rings, R Impact, Extra) +2.1, and
  `FirstMoveStart` (Fire42, Bezier1, stab, sparks) and the `Chonk` flash +3.9 studs.
- **Own layers:** column = Sideways Spec `12363816474`, `12363818754`, `8747784536` (VelocityParallel, up, Speed 5-200,
  Drag 0-5, LE -1 Br70, Size 12.8 -> 1.5 at 20 % -> 0, life 0.05-1.5, x3/x5/x10). Flash (`Chonk`) = Spike Impact
  `18457400581` (2x2, flat, LE1 Br5, 26.6 -> 0 in 0.053 s, ZOffset 2), halftone glow `121143963977274` (LE1 Br5,
  11.5 and 17.8 -> 0) over its black twin `79229618038296` (Br0, 17.8 -> 0, Transparency 1 -> 0 at 43 % -> 1), flash
  `18118762332` (16.4 -> 0 in 0.033 s). Stab cross = `18465146997` (LE -10 Br100 and a black LE0 Br0 copy),
  `119637388841475` (LE -2 Br10 and black), `12867450128` (LE1 Br3), TimeScale 0.75. Claws `12921172449` /
  `12919895706` (Br 10-45, LockedToPart). Specs `11448304274` x12. Ground mark = `16511719438` + `116852757864858`
  (flat, black, LE 0.6 / 0.425, Br20, Transparency 1 -> 0 at 20 % -> 0 at 80 % -> 1, 0.5 s, LockedToPart).
  Ring = Impact617 `13280251453` (LE1 Br0.5, 0 -> 13.9 in 0.1 s).
- **Techniques:** an eruption column from VelocityParallel needles only (d21); kit reuse by recolouring (d24); a black
  twin under the additive flash (d2); a trapezoid fade on the ground mark (d22).
- **Weak:** 77 emitters + 9 mesh models (heavy); the same floor-cut smoke lines as Wukong (flat bottom edges on the
  smoke at 0.2-1.2 s); after 0.1 s the dome is only a thin dark-blue outline.

### `f179743ad3c1` wallcombo "ground1" - blue electric ground strike, 1.2 s, R ~ 5
- **Phases (sheet):** 0.03: almost empty (a few blue dots); 0.10 peak: a blue dome (~2R), a white-hot flat streak along
  the ground ~5R long, six thin vertical light rays rising from it, specs; 0.20: streak longer with a white centre, rays
  shorter, orbs flying; 0.35: streak thinner and violet; 0.55: dark-blue smear on the ground + scattered orbs; 0.80: a
  few orbs; 1.2: gone.
- **Layer roles:** flash = `n2` + a second `18118762332` (FacingCamera, 6.9 / 10 -> 0, life 0.033, LE0 Br10 and LE0.5
  Br5.8). Dome = `shock` `87611664787759` (FacingCamera at ground, LE0 Br9, 0 -> 12.5, 0.123 s, 4x4 OneShot, ZOffset
  -0.2). Ring = `18682835879` (FacingCamera, LE1 Br5.8, 0 -> 10, 0.205 s). Starbursts = SW2 `17296456452`, SW3
  `17296514835`, SW4 `17296579364` (LE1 Br10-15, 0 -> 10 in 0.06 s, Drag 58-91). Ground streak = seven `Ground`
  layers on `13781849388`, `13783882492`, `15712719625` (VelocityParallel, Rotation 90, Size 0 -> 3, Squash 0 -> 4.33,
  0.2-0.5 s, TimeScale 0.7-0.8; blue Br1111 LE0 and LE-1, plus black LE0 Br1 copies). Rays = six emitters on
  `16433757077`, `16501229582`, `13712002093`, `10335418884`, `13712004045` (VelocityParallel, Speed 7-85, Drag 7-8,
  Spread 3-10, LE 11, Br 50-155, x5-15). Dark wisps = `light*` / `swquash` on `121996673679031`, `77288601403675`,
  `115506914345580`, `137562321329688` (Color black, LightInfluence 1, LE0, 0 -> 3, Speed 1-40, Drag 3.24, peak opacity
  only 7-54 %). Specs = `11448304274` x4 (LE0 Br50, Transparency -50).
- **Techniques:** Brightness 1111 on a crack flipbook (d7); LE 11 + Br 50-155 on tiny rays (d8); the flat ground streak
  from VelocityParallel + Rotation 90 + growing Squash (d17); blinking spark transparency (d14); dome (d1).
- **Weak:** nothing reads in the first ~0.05 s: both flashes live 0.033 s and every other layer starts at Size 0, so the
  hit is read 2-6 frames late; Br1111 and LE11 are far outside the documented ranges and may break after an engine change.

### `d269c33f2a0a` kick barrage "XNL ANIMS(Open Source)" - grey wind slam, R ~ 10. Capture is a superposition.
- **Caveat:** the captured instance is the whole moveset folder (M1s First/Second, Leap, Slam, Spin, falling) plus an
  R6 rig, all fired at once (also a `Pre` folder of pre-hit meshes). The Slam part is `Slam/Part` (rizzimpact x4,
  rizzwind x2), `Slam/Part/Smoke2` (16 smoke layers), `Slam/Part/crack` (4 decals) and six Forge mesh models; the rest of
  the sheet comes from other moves.
- **Phases (recapture):** 0.03: a crown of tall dark-grey spikes (~1.2x rig height) in a ring ~3-4 rig widths around
  the rig, a bright white flat ring on the floor under it, a large translucent wind bubble above and a huge translucent
  cone sweeping in from the side; 0.10: the cone and bubble wider (fill the frame), a very dark ground disc with a sharp
  elliptical edge (~2.5R), white flat rings inside it, black vertical bars rising from the centre, a red blood spray
  starting (M1s); 0.20: dark disc at its widest, white rings and swirling white wind arcs, a dark-red blood ball, black
  bars; 0.35: blood spatter flung wide, wind crescents, the dark disc still clear; 0.55-0.80: a tornado of white wind
  wisps filling the frame, the dark disc merged into the dark floor; 1.2: faint wisps; 1.8: very faint; 2.6-3.6: only
  the rig. No ground mark is visible after 0.55 s although the crack decals live 4-7 s.
- **Layer roles (Slam):** the spike crown / needle -> drum shape is NOT Slam: it is `Pre/Shockwave Black` (Forge mesh
  `5774635802`, Start 0.95 x 14.3 x 0.95 -> End 15.9 x 5.8 x 15.9, 0.35 s, part transparency 0.7 -> 1) and `Pre/Shock
  Back Large` (same mesh, 0.1 s, 0.3 -> 1); the bubble = `Leap` meshes. Slam's own mesh `4681227436` goes 12.6 x 5.9 ->
  27.2 x 8.8 in 0.8 s. Ground rings = rizzwind
  `15516389398` / `15516392140` (flat, LE0 Br1, Transparency 0.84 -> 1, 0 -> 21.6 / 17.5, 0.6-1 s, x4 each). Ghost rings
  = rizzimpact `9281305957`, `18356099314`, `131070767868542` (flat, LE1 Br 0.01-0.1, 0 -> 30-32, 1.4-3.8 s, RotSpeed
  8-48). Spiky shock ring = `14538969234` (flat, LE0 Br1, 0 -> 21, Transparency 0 -> 0.67 at 10 %, 0.5-1.1 s, x3).
  Smoke = `15072761142` x25 (flat, Speed 84-105, Drag 10, SpreadAngle (0, 360)), `13464599286` x16 (Speed 103, Drag 6.3,
  Squash 0 -> 1.8 at 25 % -> 0.375, Loop flipbook), `116686317011720` x12 x2, `131667932715858` x23,
  `116535655897049`, `125085407527682`, plus the same Plume5 / Billowing kit as Wukong. Cracks = `138241506642100`,
  `99197004872210`, `17137667240` (Brightness 0, LE 0.65-0.8, Size 23.7, 7 s) and `99911247720869` (black, LE0.9,
  Transparency 0.56, 4 s).
- **Techniques:** radial ground-skid smoke from a planar SpreadAngle (d9); ease-out size curves that reach 50 % of the
  final size at 10 % of life (16.1 of 32.2), the shockwave look without scripts (d12); Brightness-0 crack decals as a
  darkening layer (d3, the dark disc at 0.1-0.35 s); the pre-hit mesh that goes tall -> flat (d23).
- **Weak:** rings at Brightness 0.01-0.1 add at most 10 % grey by the numbers; in the stills they cannot be told apart
  from the clearly visible white rizzwind rings (Transparency 0.84, LE0), so their contribution stays unclear; 4-7 s
  crack decals that stop reading after ~0.5 s on a dark floor (wasted, and a long black stain on a light floor); the M1s
  put a big dark-red blood ball and spatter (`skibblood`, #470000) right on the hit at 0.1-0.35 s (content-rating risk,
  see PATTERNS pitfalls).

### `8e7cd9fc76b3` hakari "impactWU" - teal toon hit barrage, R ~ 5, a 2 s stream
- **What:** all 23 emitters carry EmitCount 1 with EmitDuration 2, so they stream at their Rate for 2 s (claws 14/s,
  specs 5-10/s, toon stars 1.8-10/s): a rapid multi-hit, not one slam. Teal/green (#2C634C, #27514B, #1A3D18, key
  #68F860) + black.
- **Phases (recapture):** 0.03: a hard-edged teal toon star (~1R) with green flame shapes inside and one spike, its
  bottom cut flat by the floor; 0.10-0.20: shards, orbs and a claw streak (between hits) inside a large dark translucent
  hemisphere (~2x the toon star: the Brightness-0 b10 sphere rim, renewed at 10/s); 0.35: a green fan of soft spikes
  over the dark dome; 0.55-0.8: orbs, each bright core ringed by a dark halo, claw; 1.2-1.8: new hits, soft green spike
  stars with thin rays inside the dark dome; 2.6: a few orbs; 3.6: gone. Each hit is visible for 0.06-0.11 s.
- **Layer roles:** toon frames = `Drawn Star 2` x6 on `14052685115` (2x2), `12363773628`, `13778611432` (LE0.8 LI0.2
  Br5, 0.06-0.1 s, ZOffset 1-4) stacked in teal, dark green and black; spike stars = R Impact `101995042384072` (black;
  and green -> black over life), Impact4722 `16997078201`, Fixed circle `134557993252093` (LE -1), Blurry Star
  `116952409636124` (black, LE -1), all 0.109 s; backdrop = b10 `137014331200061` (Brightness 0 = black, 0 -> 9.7,
  Transparency 0 -> 0.51 at 19 % -> 1, 0.2 s); claws = `12921172449` / `12919895706` (VelocityParallel, Rotation 90,
  Squash -1.36 -> 3, 0.07 s, Br 0 / 7 / 12, LockedToPart); sparks = Spinning Shard `16924875355` (4x4 at 30 fps) and
  Spec1 `16878181512` (LE -1, Br 15-25, Speed 32-148, Drag 7-7.5, SpreadAngle 200, 0.16-0.38 s); specs `11448304274` x4
  (LE -8 Br20, Transparency -50).
- **Techniques:** frame-1 pop curves (d12); one toon sheet in three tints at ZOffset 1 / 3 / 4 = cel shading (d20);
  negative LE on every small part (d4); a Brightness-0 ring as a dark backdrop (d3).
- **Weak:** a Rate stream inside a "hit": which frame a player sees is random; the main tints (#27514B at Br5) are
  dark, so on a dark floor only the #68F860 key reads.

### `e937fd217dcc` Black White "h9" - white hit streak, 0.76 s, R ~ 6.5
- **Phases (recapture):** 0.03: nothing visible; 0.10 peak: one short white streak + a soft white glow puff (~1.5R) +
  a second fainter puff and a dark wisp; 0.20-0.35: faint grey-dark curved ring arcs (the flat rings); 0.55: two faint
  arcs near the horizon; 0.80: gone. (The first capture, effect raised above the floor, showed a long white streak
  cluster across a third of the frame at 0.03 s. Inferred: the streak and cross are emitted sideways at the effect's
  height, so on the floor part of them is hidden: d28.)
- **Layer roles:** streak = `15370174971` (4x4, VelocityParallel, Speed 150, Drag 15, Size 1 -> 13 linear, Squash
  0 -> -3, LE0 Br15, 0.1 s, x4, ShapeInOut Inward). Cross = `18465146997` and `119637388841475` (VelocityParallel,
  Rotation 90, Squash 3, 0.083 s at TimeScale 0.75): white LE1 Br3 at Size 0 -> 9.1 at 13 %, ZOffset +0.1, over black
  LE0 Br0 copies at 0 -> 14.7 at 17 %, ZOffset -0.1. Glow = `15556583761` (LE1 Br10, 0 -> 11, Transparency 1 -> 0.71 at
  39 % -> 1, 0.155 s). Rings = `127940423551603`, `84251750889260`, `16812738942`, `126755071876766`,
  `74406026456360`, `85563186076856`, `75267576298199` (flat, 0 -> 8-13, best opacity only 4-24 %, 0.25-0.76 s).
- **Techniques:** the black twin 1.6x bigger behind the white speed-line cross (d2); a streak that grows linearly while
  its Squash goes negative (it gets longer and flatter); Speed 150 / Drag 15 = shoots ~10 studs and stops.
- **Weak:** the seven rings never get more than 24 % opaque and show only as faint arcs at 0.2-0.55 s; no ground
  contact apart from those; nothing bright after 0.15 s. It reads as a slash flash, not a ground hit.

### `aff199dac08d` Vergil "Ground2" - small landing dust with sparkles, 0.8 s, R ~ 5.5
- **Phases (recapture, camera closer):** 0.03 peak: a tight cluster of 6-8 blue-white 4-point stars and dots (~0.5R)
  inside a wide soft blue ring lying on the floor (the shock disc, ~2R, seen in perspective as an arch); 0.10: disc
  gone, stars flung 0.5-1R out (one large star near the camera), white glow orbs, a dark brown/grey dust cloud with gold
  specks; 0.20: dust wider, few stars; 0.35: dust and specks faint; 0.55: gone.
- **Layer roles:** shock disc `68` = `12402897209` (flat, LE1 Br1 blue, 0 -> 11, 0.1 s, x3; visible only at 0.03 s).
  Dust = `16867397491` + `95791849628501` x55 each (brown #665B3C, LE1 Br5 / Br1, 0 -> 2.4, best opacity 14 %, Speed
  25-65, Drag 11, SpreadAngle (7, 180), ZOffset -1). Dust specs = `7231210720` (LE0) + `5368629557` (LE1) x15 each
  (#BD9F63, Acceleration -8). Puffs = `16867507329` + `16867389591` x15 (grey, LE1, 6 % opacity, Squash 0.338 -> 0).
  Stars = five emitters x3: OffCentered `15658580283` (LE -3), Star116 `8037777212` (LE1), Star108 `116403060004639`
  (LE0), Star97 `89480767232810` (LE0), Br25, LockedToPart, Size 0 -> 1.19 at 10 % -> 0.19 at 82 % -> 0, Speed 35-75,
  Drag 6, ZOffset 2.
- **Techniques:** one star burst through three light modes (d19); a pop-then-long-tail star size curve; brown dust at
  LE1 with a dark colour = a dim translucent veil.
- **Weak:** tiny: stars <= 1.2 studs, dust <= 3 studs; the 11-stud shock disc (Br1, 0.1 s) is the only ground contact
  and is gone before 0.1 s; no dark layer except the dust; 110 dust particles for a veil at 14 % opacity is expensive for what it shows. Fine as a
  footstep / landing puff, weak as an impact.

---------------------------------------------------------------------------------------------------------------

## b. Anatomy of an impact / slam / ground hit (firing order)

Every layer in all 7 effects fires at t = 0 (EmitDelay 0 everywhere); the order below is when each role is SEEN, set by
lifetimes and size curves. Values: typical (range) across the effects. Size as a multiple of R.

| # | Role | Texture role (example ids) | Light | Life (s) | Size, shape | Transparency | Motion | Orientation, other |
|---|---|---|---|---|---|---|---|---|
| 1 | **Impact flash** | spiky starburst `18118762332`, 2x2 spike `18457400581`, halftone glow `121143963977274` | LE 0.5-1, Br 5-10 (LE0 Br10 in wallcombo) | 0.033-0.053 | shrink from 1.4-2.2R to 0 | 0 flat | Speed ~0 | FacingCamera (2x2 spike: flat); x1-2; ZOffset 0-2 |
| 1b | Flash ink | black twin `79229618038296`, `12363773628` | LE0 Br0 or black LE0.8 | 0.05-0.1 | 1.1-1.5x the flash | 1 -> 0 at 43 % -> 1 | - | FacingCamera, behind (ZOffset 0 vs 2) |
| 2 | **Stab / speed-line cross** | `18465146997`, `119637388841475`, speedlines 4x4 `17657522953`, claws `12921172449` | additive LE1 Br3 or LE -2..-10 Br10-100 | 0.04-0.083 (x 1/TimeScale 0.75 = 0.11 real) | swell 0 -> 0.7-1.8R at 13-38 % -> 0 | 0 flat (claws: -50) | Speed 0.001-0.25 (axis only) | VelocityParallel, Rotation 90, Squash 3 or curves to +-3, x1 |
| 2b | Stab ink | same sheet, Color black | LE0 Br0, or black LE 0.95 Br0 | same | 1.4-1.6x the light copy | 0 | same | ZOffset -0.1 vs +0.1 |
| 3 | **Hot core** | Fire42 8x8 `16860398159`, Bezier1 `15423151910`, Specs53 `17226944366`, Full short impact `115475105765006`, toon stars `14052685115` | LE0 Br10-50 on a saturated colour (or LE0.55-0.8 Br5-10) | 0.05-0.2 | grow 0 -> 0.5-1R ease-out, or shrink 1.3R -> 0 | 0 flat, or 1 -> 0 at 11 % -> 0 at 70 % -> 1 | Speed 0.06-0.9 | VelocityPerpendicular (flat) or FacingCamera; x1-5; ZOffset -1..+1 |
| 4 | **Flash swell** | R Impact 4x4 `101995042384072`, Inverted muddy `104632340635453`, Extra `18717313304` | LE1 Br5, or LE0 Br15-25 | 0.09-0.3 (TimeScale 0.6 -> 0.15) | grow 0 -> 2-3.7R, 50 % of final by 30 % life | 0 flat | - | FacingCamera or flat; x1 |
| 4b | Swell ink | Fixed circle `134557993252093` black | black LE0.9 Br10 | 0.08 | 0 -> 2.3R | 0 | - | FacingCamera |
| 5 | **Dome** (floor-clipped) | sphere-rim `14457094589`, ring flipbook `87611664787759` | LE0 Br9-35 coloured | 0.12-0.4 (x 1/0.9) | grow 0 -> 1.15-2R (dome width = Size) | 0 -> 0.41 at 9 % -> 0.75 at 24 % -> 0.92 at 60 % -> 1 | Speed ~0 | FacingCamera at floor level (Wukong, wallcombo) or ~0.2R up (Yuji +2.1); ZOffset -0.2..0.75 |
| 5b | Dome ink | same, black | LE0 Br35 | 0.2 | 1.0-1.6x the dome | same curve | - | same |
| 6 | **Spark streaks** | Downwards Impact `129378836572027`, Shorter impact `14379744080`, cross star `17062416111`, needles `16433757077` | LE -10 Br10, LE0 Br25, or LE11 Br50-155 | 0.04-0.12 (rays 0.2-1) | 0.3-1R constant, or Star3 flicker 0 -> 1R | 0 flat | Speed 1-354 (wide random range), Drag 5-30 | VelocityParallel (FacingCamera for Star3); x1-15 |
| 7 | **Specs / orbs** | `11448304274`, `16878181512`, `16924875355`, `13712002093` | LE -1..-8 Br20-50 (or LE0 Br50) | 0.5-1.5 | swell 0 -> 0.03-0.1R at 15-17 % -> 0 | -50 flat (hard) | Speed 5-127, Drag 7-8.6, RotSpeed +-500 | VelocityParallel Rotation 90, Disc shape ShapePartial 0.5; x5 per emitter, 4-12 emitters |
| 8 | **Ground shock rings** | `18765326355`, `116897739829086`, `15516389398`, spiky `14538969234`, `18682835879`, starburst `17296456452` | LE0-0.45 Br1-2 (thin LE1 rings Br5.8-15) | 0.3-1.1 (fast rings 0.06-0.2) | grow 0 -> 2R ease-out (25-50 % of final at 10 % life); a slow outer ring 0 -> 4.3R over 1-2 s | starts 0-0.84, reaches 1 by 70-100 % | Speed 0.001-0.03 | VelocityPerpendicular, Rotation random; x1-4 |
| 9 | Wind swirls | 4x4 `127940423551603`, `109440284900004`, `131070767868542` | LE0-0.25 Br1-3 | 0.2-0.6 | grow 0 -> 1.6-3R | 0.7-0.9 -> 1 | RotSpeed +-56..150 | flat; x2-5 |
| 10 | **Smoke body** | Plume5 `8527116276`, Billowing 4x4 `15415212938`, toon `16867483883`, radial `15072761142` | grey #616161 LE0 LI0.75 Br15; white LE0 Br0.4; black LE0.75 Br1.15 | 0.35-2 | grow 0 -> 0.6-1.3R, ease-out; Squash 0 -> 1.79 | 0 -> 0.45 at 10 % -> 0.69 at 20 % -> 0.8 at 30 % -> 1 | Speed 1-100, Drag 7, SpreadAngle (0, 180), Acceleration -8..-29 | FacingCameraWorldUp; x1-5 per emitter, 6-16 emitters |
| 11 | Embers / grit | Glitter 8x8 `16511093402`, smoke specs `7231210720` | LE -1 Br5 dark grey | 1-2 | 0 -> 0.75R | 0.85 -> 1 | Speed 29-102, Drag 8, Acceleration -33 | FacingCamera, Loop 9 fps; x15 |
| 12 | **Ground marks** | cracks 4x4 `17137667240`, `17013333656`, `99911247720869`, scorch `78777197785281`, glow `107821950776778`, cooling `124164858775284` | Br0 (black) with LE0.4-0.9; glow LE1 Br1 | 0.5-2.4 (kick 4-7) | constant 0.65-2.4R | 0 -> 0.42 at 10 % -> 1 (cracks), or hold to 72 % then fade, or 1 -> 0 at 20 % -> 0 at 80 % -> 1 | Speed 0.0002-0.001 | VelocityPerpendicular, LockedToPart; glow decals paired FacingCamera + flat |

Counts: 13-77 emitters per effect (median 30); burst sizes 1-5 for big shapes, 5-25 for smoke and sparks (55 in the
weakest one). Brightness scales inversely with screen area exactly as the vault says: flashes and big rings Br 1-5,
dome and core Br 9-50 (they are small or brief), sparks and needles Br 10-155.

---------------------------------------------------------------------------------------------------------------

## c. Timing (seconds, effect time, all layers fire at t = 0)

| Phase | Typical | Range across the 7 | Evidence |
|---|---|---|---|
| Impact flash | 0 - 0.04 | 0.033 - 0.06 (0.15 when a layer runs at TimeScale 0.6) | `18118762332` 0.033 s (wallcombo, Yuji), spike 0.053 s, R Impact 0.09 / 0.6 |
| Stab lines | 0 - 0.08 | 0.04 - 0.11 | speed lines 0.04-0.083 s at TimeScale 0.75 |
| Peak read (stills) | 0.03 - 0.1 | 0.03 (Yuji, kick, Vergil, hakari) - 0.10 (wallcombo; Wukong and Black White when sitting on the floor) | sheets; Wukong / Black White peaked at 0.03 in the first capture, raised above the floor |
| Core | 0 - 0.15 | 0.05 - 0.3 | Bezier1 0.05, Fire42 0.1-0.2, Extra 0.3 |
| Dome / fast shock | 0.03 - 0.35 | 0.06 - 0.45 | dome bright at 0.03 and an outline to 0.35 s (Yuji), 0.1-0.35 s (Wukong, wallcombo); hakari's dark sphere is renewed for its whole 2 s stream |
| Spark streaks | 0 - 0.12 | 0.04 - 0.5 | streaks 0.04-0.12, flung shards 0.16-0.38, rays to 1 |
| Ground rings | 0.05 - 0.6 | 0.06 - 1.1 (+ slow outer ring to 2) | Impact145 0.4-0.6, rizzwind 0.6-1 |
| Smoke dominant | 0.2 - 0.8 | 0.1 - 1.2 | stills: Wukong / Yuji smoke is the main shape from 0.2-0.35 s; kick's wind wisps from 0.55 s |
| Specs / orbs / embers | 0.1 - 1.0 | 0.5 - 2 | specs 0.5-1.5, Glitter 1-2 |
| Ground marks | 0 - 2.4 | 0.5 (Yuji) - 7 (kick) | cracks, scorch, glow decals |
| Gone (stills) | 1.2 - 1.8 | 0.55 (Vergil) / 0.8 (Black White) - 2.6 (kick) | sheets; Yuji and Wukong gone by 1.8; kick's 4-7 s cracks stop reading after ~0.5 s |

Shape of the curve: everything is brightest at 0.03-0.1 s and the eye's centre of mass moves outward and upward: flash and
core (0-0.1, <= 1R) -> dome and rings (0.1-0.35, 1-2R) -> smoke (0.2-0.8, 2-4R wide, up to 2R tall) -> ground marks.
The strong effects have NO anticipation inside the effect (that lives in the animation); the weak ones lose the first
frames (wallcombo; Wukong and Black White when their hit point sits on the floor, d28) or have nothing bright after
0.15 s (Black White).

---------------------------------------------------------------------------------------------------------------

## d. Techniques catalogue (exact recipes)

1. **Floor-clipped dome.** A FacingCamera ring / sphere-rim sprite emitted AT floor level: the floor hides its lower
   half and it reads as a hemisphere. Wukong / Yuji: `14457094589`, LE0, Br35, coloured, Size 0 -> 14.1 (~1.15R), life
   0.4 at TimeScale 0.9, ZOffset 0.75, Transparency 0 -> 0.41 at 9 % -> 0.75 at 24 % -> 0.92 at 60 % -> 1; two black
   copies (Br35, 0 -> 14.6 and 7.3 -> 22, life 0.2) behind it. wallcombo: ring flipbook `87611664787759`, LE0 Br9,
   0 -> 12.5, 0.123 s, ZOffset -0.2. hakari's toon star is cut the same way at 0.03 s, and its Brightness-0 sphere rim
   `137014331200061` (0 -> 9.7, 0.2 s, 10/s) reads as a dark translucent dome for the whole stream. Yuji raises the
   dome's attachment 2.1 studs above its ground mark, so it is a bit more than a hemisphere (bright rim at 0.03 s).
   Needs a floor; in the air it is a full circle.
2. **Black twin behind the bright shape.** Same texture, Color #000000, LE0 with Brightness 0 (or Br35 / LE0.8-0.95),
   1.0-1.6x the size, ZOffset 0.1-0.2 lower. Black White and Yuji speed-line cross: white 0 -> 9.1 at ZOffset +0.1 over
   black 0 -> 14.7 at ZOffset -0.1; Yuji flash: halftone `121143963977274` LE1 over `79229618038296` Br0; Wukong dome
   and flash swell; hakari's toon stars. This IS the three-tone rule's ink layer, done per shape.
3. **Brightness 0 = black, whatever the Color.** With LightInfluence 0 the colour is multiplied by Brightness, so Br0
   turns any greyscale texture into a black card. Used for ground cracks and scorch (`17137667240`, `17013333656`,
   `138241506642100`, `99197004872210`, LE 0.5-0.8: kick's sharp-edged dark ground disc at 0.1-0.35 s), the hakari
   backdrop dome `137014331200061` (LE0, clearly dark in every recaptured frame), stab ink. Observed (first capture):
   black cards with LE 0.8-0.95 still read clearly dark (Wukong's 0.03 s needle and halo), so do not assume a high
   LightEmission makes a black card vanish. The exact blend maths is unverified. On a dark floor a Br0 decal stops
   reading once it is ~50 % transparent (kick: gone by 0.55 s of a 4-7 s life).
4. **Negative LightEmission on small sharp parts.** LE -1 (Glitter, Spec1, Fixed circle), -2 (Specs53, stab), -3
   (Vergil star), -7 / -8 (specs), -10 (Downwards / Shorter impact, stab needle), always with Brightness 10-100. On the
   stills these read as crisp, solid, saturated shapes with no glow halo, and the recaptured hakari orbs (Spec1
   `16878181512`, LE -1 Br25) show a bright core ringed by a DARK halo against the sky (0.55 s): the soft alpha fringe
   darkens what is behind it, a built-in dark outline. Library: 14.2 % of impact layers.
5. **Transparency -50 (constant).** On specs `11448304274` (wallcombo, hakari, Yuji) and the Wukong / Yuji `speed5`
   claw stab. The specs render as hard-edged discs. Inferred: alpha = texture alpha x (1 - T) = x51, clipped, so a soft
   dot becomes a solid disc. Rare (0.2 % of impact layers). If Studio rejects a negative keypoint, use 0 and a
   harder texture.
6. **Brightness that clips a saturated colour to white.** Orange #FF622E at Br10 (Fire42) or Br50 (Bezier1): every
   channel x10 exceeds 1 where the texture is bright, so the centre goes white-yellow and only the dim fringe keeps the
   hue. One layer gives core + body. Blue Yuji (#446FF9) does the same. Rule: Br >= 1 / (smallest colour channel) whites
   out the brightest texels.
7. **Brightness 1111 on a crack flipbook** (wallcombo `13783882492`, blue, LE0 and LE -1, 0.2-0.5 s): every lit texel
   clips, the dark cracks stay dark: a posterised two-tone. Out of range; fragile.
8. **LightEmission 11 + Brightness 50-155 on tiny sparks** (wallcombo rays `16433757077`, `16501229582`,
   `13712002093`, `10335418884`): white-hot cores with a coloured fringe on 1-2 stud particles. Out of range; fragile.
9. **Planar SpreadAngle.** SpreadAngle (0, 360) emits in one plane only: kick's radial ground-skid smoke
   (`15072761142` x25, flat, Speed 84-105, Drag 10: slides out ~9 studs and stops). (0, 180) = a half fan, used for the
   upward smoke plumes (Plume5 / Billowing) and Vergil dust (7, 180). (200, -200) on hakari shards.
10. **Disc shape + ShapePartial 0.5** for specs: they leave from the outer half of a disc, so the burst has a hole in
    the middle where the core is.
11. **Drag sets the throw distance.** Distance ~ Speed / Drag (inferred from the exponential drag). Star3 Speed 1-354,
    Drag 30.5 -> 0-11.6 studs in ~0.05 s; Shorter impact 118-236 / 5 -> 24-47 studs but it dies at 0.1 s; specs 6-127 /
    8.64 -> up to 15 studs; SW starbursts Speed ~0 with Drag 58-91 = frozen in place.
12. **Pop-on-frame-1 size curves.** hakari: 15 keys reaching 2.3 of 8.3 at 0.1 % of life, 5.7 at 2 %, 7.5 at 10 %:
    the shape is ~70 % size on its first rendered frame. Rings: 50 % of final at 10 % life (kick 16.1 / 32.2),
    25-35 % (Wukong Impact145 8.1 / 24.6, Vergil 3 / 11). Extends PATTERNS 2 ("pops, not fades") with numbers.
13. **Flicker inside one particle.** Star3 Size keys: 0, 0.42 at 16 %, 11.8 at 20 %, 1.9 at 30 %, 0 at 49 %, 4.0 at
    74 %, 0 at 100 % over 0.07-0.12 s: two flashes from one particle.
14. **Blinking sparks.** `13712002093` Transparency alternates 0 / 1 five times over 0.5-1.2 s (keys 0, 0.975, 0,
    1, 0, 1, 0, 1, 0, 1): twinkle without a flipbook.
15. **Colour ramp to black inside the particle.** Faint Wispy Energy `124164858775284`: #FFBA42 -> #FF9E4A at 60 % ->
    black at 69 % (life 1.4); `102071926154708`, `86354126672265`, `103809786001643`: orange -> black linearly over 1 s;
    hakari R Impact: #68F860 -> black in 0.109 s. Ground glow cools into scorch; a flash dies into ink.
16. **Every ground decal twice:** FacingCamera + VelocityPerpendicular (Wukong `Fire`: Fading Glow 15 / 20,
    `124164858775284` 8 / 10, `124384892151105`, `96013523226630`, `117358359592021`, `139851738398320`,
    `96754486633479`): readable from a side camera and a top-down one.
17. **Flat ground streak.** VelocityParallel + Rotation 90 + tiny Speed (0.011) + Squash 0 -> 4.33 (wallcombo
    `Ground`, Size 0 -> 3, 0.2-0.5 s): a long thin streak lying along the ground, ~10x longer than wide on the stills.
18. **Smoke that stretches up as it grows.** FacingCameraWorldUp + Squash 0 -> 1.79 (Plume5, Billowing).
19. **Same burst, three light modes.** Vergil stars: OffCentered LE -3, Star116 LE1, Star108 / Star97 LE0, all Br25,
    3 each: some glow, some are solid, some dark-cored, from one spawn pattern.
20. **Cel shading by tint stacking.** hakari: the same toon star sheet in #27514B (ZOffset 1), #1A3D18 (ZOffset 3),
    and black, LE0.8 LI0.2 Br5, 0.06-0.1 s.
21. **Eruption column from needles.** Yuji: VelocityParallel, EmissionDirection Top, Speed 5-200, Drag 0-5, LE -1
    Br70, Size 12.8 -> 1.5 at 20 % -> 0, life 0.05-1.5, 3 + 5 + 10 particles: a pillar of streaks without beams.
22. **Trapezoid ground mark.** Transparency 1 -> 0 at 20 % -> 0 at 80 % -> 1 over 0.5 s (Yuji `16511719438`,
    `116852757864858`, black, LE 0.425-0.6, Br20, LockedToPart). Ground30 `78777197785281`: hold until 72 %, gone by
    100 % of 2 s.
23. **Forge mesh shapes (Start -> End models).** kick `Pre/Shockwave Black`: mesh `5774635802` from 0.95 x 14.3 x 0.95
    to 15.9 x 5.8 x 15.9 in 0.35 s at 70 -> 100 % transparency (reads as a crown of dark spikes ~1.2x rig height at
    0.03 s); Yuji `Winds`: Start 10 studs above End, so the wind column slams DOWN in 0.35-0.65 s.
    Decal Color3 values 2-100 on these meshes = overbright decals (Yuji 21.8, kick 100).
24. **Kit reuse.** Yuji FinalHit = Wukong Slam1 with ~30 identical layers recoloured from #FF622E to #446FF9: a slam
    kit is a reusable asset; recolour the body tone, keep white and black.
25. **Ghost rings.** LE1 with Brightness 0.01-0.1 (kick rizzimpact, 30 studs, up to 3.8 s): adds <= 10 % grey by the
    numbers; in the recapture they cannot be told apart from the visible LE0 rings. A deliberate whisper or a mistake;
    either way, do not copy blindly.
26. **Per-emitter TimeScale 0.6-0.95.** R Impact 0.6, speed-line cross 0.75, Billowing 0.85, Impact333 / 145 0.9,
    wallcombo cracks 0.7-0.8, kick smoke 0.7: the layer plays slower than the rest without re-authoring its curves.
    Real lifetime = Lifetime / TimeScale. (Our VFXTimeline runtime overwrites TimeScale for slow-motion, so bake it
    into Lifetime instead.)
27. **ZOffset ordering.** Flash, sparks, specs +1..+4; dome +0.75; smoke +0.2 or -0.5..-2; ink copies -0.1 below
    their bright twin.
28. **Height offsets: the core above the ground layers.** Yuji (same kit as Wukong): ground mark at 0, debris ring +0.6,
    dome / rings / swell (`NormalHit`) +2.1, core / stab / sparks / flash (`FirstMoveStart`, `Chonk`) +3.9 studs. On a
    floor its whole sequence reads (flash and column at 0.03 s). Wukong puts every attachment at one point: placed on
    the floor, its 0.03 s frame is empty (only smoke puffs) because those layers fire down (EmissionDirection Bottom)
    or lie flat at y = 0; raised above the floor (first capture) it peaks at 0.03 s. Rule: ground cards 0.05-0.2 studs
    up, dome / rings ~0.15-0.25R up, core and anything emitted downward 0.3-0.5R up (inferred from these two).

---------------------------------------------------------------------------------------------------------------

## e. Mistakes and weak spots (avoid)

- **Smoke cards crossing the floor.** Roblox particles have no soft-depth fade; FacingCameraWorldUp smoke with
  Acceleration -18..-29 (Wukong, Yuji) sinks into the floor and shows hard horizontal cut lines for ~1 s. Fix: emit
  smoke 0.5-1 stud above the floor, use little or no downward acceleration, keep cards smaller than their height above
  the floor, or use upward Acceleration.
- **Work that barely shows.** Black White's seven rings peak at 4-24 % opacity (faint arcs only); kick's ghost rings
  at Brightness 0.01-0.1 (indistinguishable in the stills); Wukong's flat rings (52-stud one never under 76.5 %
  transparency) never show; Vergil's 11-stud shock disc reads for one sampled frame (0.03 s). Check every layer on a
  still at its peak; delete what never reads.
- **Core layers at the same height as the ground layers.** Wukong on the floor loses its whole first beat (d28); keep
  downward-fired and flat core layers 0.3-0.5R above the contact point.
- **A late first read.** wallcombo shows nothing at 0.03 s: its flashes live 0.033 s and everything else starts at
  Size 0. Give at least one big shape full size on frame 1 and keep a flash alive >= 0.05 s (3 frames).
- **Too small for the hit.** Vergil's stars (<= 1.2 studs) and dust (<= 3) read as glitter, not an impact. The strong
  slams put a 2R ring, a 1-1.5R dome and a 2-4R flash in the first 0.1 s.
- **No ground contact.** Black White has no flat card, no smoke, no mark: it is a slash, not a slam. A ground hit needs
  at least one VelocityPerpendicular ring and one ground mark.
- **Streams inside a hit.** hakari's Rate-based layers (EmitDuration 2) make the timing random; for a single slam use
  `Emit` bursts only.
- **Cost.** 61-77 emitters (Wukong, Yuji) and 2 x 55-particle dust bursts (Vergil). The read comes from ~15 layers;
  thin counts with `VFXTimeline.Quality` and drop decoration first (vault mobile budgets).
- **Out-of-range values** (Br 1111, LE 11, LE -10, Transparency -50) work today but are undocumented; keep a fallback.
- **Long, dark linger.** kick's Brightness-0 cracks are 2.4R wide and live 4-7 s, but on the dark stage floor they
  stop reading after ~0.5 s (nothing visible at 1.2-3.6 s); on a light floor the same numbers make a big black stain for
  a combo move (inferred). Tune ground marks on the game's real floor colour and keep them <= 2.4 s for repeatable moves.
- **Gore next to an impact** (kick `skibblood`, dark red #470000): stylise it (see PATTERNS pitfalls).
- **Capture caveat for future studies:** kick barrage was captured as a whole moveset; split by move before reading
  timing from a sheet.

## Most transferable (short list)
1. Fire everything at t = 0; lifetimes 0.033-0.06 (flash), 0.05-0.2 (core), 0.12-0.45 (dome), 0.3-1.1 (rings),
   0.35-2 (smoke), 0.5-2.4 (marks) make the timeline.
2. A FacingCamera ring sprite at floor level = a dome for free (1.15-2R, LE0, Br9-35, 0.12-0.4 s) + a black copy
   1.0-1.6x behind.
3. Black twin of every bright shape: Br0 or black, 1.4-1.6x, ZOffset 0.1-0.2 lower.
4. Brightness >= 1 / min(channel) on a saturated colour whites out the core: one layer = core + body (Br10-50).
5. Rings and flashes pop: 25-50 % of final size at 10 % of life (or 70 % on frame 1), transparency already 0.4-0.8 at
   10 % of life.
6. Smoke: grey Plume5 LE0 LI0.75 Br15 + black Billowing LE0.75, Speed 1-100, Drag 7, SpreadAngle (0, 180),
   Transparency 0 -> 0.45 at 10 % -> 0.8 at 30 % -> 1, 1-2 s; emit above the floor.
7. Sparks: VelocityParallel, Speed up to 350 with Drag 5-30 (distance ~ Speed / Drag), negative LE with Br 10-100.
8. Ground marks: Brightness-0 cracks / scorch 0.65-2.4R, 0.5-2.4 s, plus an additive glow decal whose colour ramps to
   black at ~65 % of life.
9. Height: ground cards just above the floor (0.05-0.2 studs), dome / rings ~0.2R up, core and anything fired
   downward 0.3-0.5R up (Yuji +2.1 / +3.9 studs); with everything at y = 0 the first beat vanishes (Wukong, d28).
