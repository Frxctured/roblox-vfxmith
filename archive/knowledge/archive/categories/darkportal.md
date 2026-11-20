---
title: Dark, void, portal and domain VFX - lessons from 6 open-source effects
source: open-source VFX library (Discord packs) studied 2026-11-13
tags: [vfx, dark, void, portal, domain, ink, particles, roblox, os-library, light-emission, brightness, three-tone, rings]
---

# Dark / void / portal / domain: what 6 open-source effects teach

Evidence: freeze-frame stills from the Edit-mode replayer, cropped and brightened for reading. Phases below come from
the **recapture** (`gallery/effects/darkportal/<id>.jpg`: effects placed on the floor by their emitters, view measured
and re-aimed, camera locked); the first capture is quoted only where it shows something the recapture cannot (its
0.03 s frame). The two captures differ in the first frame: Doom, tatsumaki and Crucible show nothing at 0.03 s in the
recapture but their flash at 0.03 s in the first capture, so treat t of the first visible frame as +-0.07 s. Also used:
the layer tables (`library/cards/<category>/<id>.md`), the raw dumps (the decoded pack files (`kit/scripts/rbxdump.py`), read for exact
curves, part positions and mesh/beam models) and the effects' scripts (read as text only). Studio was not used.

**Honest scope.** None of the six is a true portal (a standing ring you can see through) or a domain expansion (a dome
or world swap). What they are: a dark storm cloud (VoidStorm), a red hell-strike with black smoke (DoomSlayer Bonus), a
violet slash burst (Collab), a red-lightning sword aura (Crucible), a grey "void" launch shock (Voidflare) and a green
psychic burst with black punch-outs (tatsumaki). What transfers to portals and domains is the **dark-layer craft**
(how to make black read on screen), the **flat spinning ring stacks** and the **timing**. The recapture adds two
dome-like forms worth copying for domains: tatsumaki's translucent green sphere and Collab's cage of grey wind arcs,
plus Doom's black storm cloud lit from inside by red lightning. Other portal- or dome-specific advice is marked
*inferred*.

What the stills miss (scripts): camera shakers ship with DoomSlayer and Collab (`Utilities/CameraShaker`); Voidflare's
dive script lifts the caster 60 studs (AlignPosition), raycasts the burst onto the floor (30 studs max) and, on the later
slam only, clones a Lighting effect at Brightness 0.6 and tweens it to 0 over 0.35 s (linear); the VoidStorm debris is
moved by the storm (the stills show it static); tatsumaki's burst sits inside a Charge/Grab/Throw/Tornado sequence.

Notation: R = radius of the effect's main readable body (Doom ~15 studs, Voidflare ~10, Collab ~8, tatsumaki ~6,
VoidStorm ~4, Crucible ~3). Sizes are given in studs and in R so they transfer. "tr floor" = lowest Transparency the
layer reaches. Texture ids without a thumbnail in our index are marked (nt): check them in Studio before use.

---------------------------------------------------------------------------------------------------------------

## a. The six effects

### a449104719e7 - VoidStorm debris cloud (`VoidStormClouds.rbxm :: VoidStorm/MainDebris3/Debris30`), weak alone
- What: one dark storm cloud riding a flying debris chunk. 12 emitters, all `EMIT 1`, all VelocityParallel + LockedToPart,
  Speed -9.5 to -12.7 (negative), Acceleration (0, 4.8..6.4, -11.6..-15.7). The storm script moves the chunk; without it
  the stills show a small static puff.
- Phases (both captures agree): invisible 0-0.2 s; dim purple fade-in 0.2-0.55; peak 0.55-0.8 (lilac zigzag lightning, specks); thins and
  drifts 0.8-1.4; gone ~1.8 (est. 2.03).
- Layers: 4 dark cloud cards (89816655384560 nt, 8187308218 nt, 105900768863906 nt, 14006773822) at **LE -0.25..-0.9,
  Br 2.5-6.7, colour #231E35 -> #393C5D**, Size 4.4-7.5 const (1.1-1.9R), Squash -0.3..-0.7 (wide), ZOffset 3.5-3.8;
  2 lightning (9732664178 LE 0.32 Br 16.9; 13390196434 Grid4x4 **Loop 10 fps**, LE 0.5 Br 25); 3 speck/glow cards at
  **Br 95-120 with LE 1.11 and 2** (18450596124, 87970239798298, 87834277333031 nt) whose colour ramps start at #000000.
- Techniques: (1) Transparency keys above 1 (1.5 -> 0.5 at mid-life -> 1.5): each single particle is hidden for the
  first and last quarter of its life, which staggers 12 one-particle layers without any EmitDelay; (2) negative LE at
  low Brightness with dark violet-greys = a cloud that darkens the sky behind it instead of glowing; (3) colour ramps
  that start black on additive layers = a second, colour-driven fade-in.
- Weak: tiny and dim on its own (it is one of many debris pieces); `bg-clouds` 619393574 peaks at Transparency 0.99
  (contributes nothing); LE > 1 with Br 95-120 is hostage to bloom settings.

### 55f32e520bc4 - DoomSlayer Bonus/4 hell-strike (strongest of the group)
- What: a 45 x 36 stud cloud part 75 studs up (55 black smoke puffs over 0.3 s), lightning bolts fired DOWN from it
  (3 `Recolor` layers: VelocityParallel, EmissionDirection Bottom, Br 15-100, Drag 20), a 32-stud lightning card 38.7
  studs up (FacingCameraWorldUp, Squash 0.5, Grid8x8) and a ground burst. 88 emitters, 936 particles, longest 4.36 s.
- Phases (recapture, whole column in frame): 0.03 only a faint dark puff high up (the first capture already showed the
  white flash and the pillar at 0.03); 0.10 black cloud with red lightning arcs, a red-orange bolt column to the
  ground, white-hot fire at its foot, dark swirl ring; 0.20 cloud wider and full of bolts, the column a thin zigzag,
  white flame core; 0.35 cloud at its brightest (orange-yellow crackle), column gone, fireball at the base; 0.55 cloud
  crackle turning pink-red, fire dark red with black smoke behind; 0.80 cloud breaks into sparks over grey-black
  smoke, fire dark red; 1.20 embers in black smoke; 1.80 a black smudge on the ground; 2.6 almost empty; 3.6 gone.
  The ground fireball is about the cloud's width, so the column spans ~5 body heights.
- Layers: flash 12118255430 (LE 1, **Br 600**, Size 32.6 -> 0 halving about every 10% of a 0.15 s life, ZOffset 8.3);
  **black ground shock 16509144751 (#000000, LE 0, 0 -> 61.9 studs = 4R in 0.3 s)**; ground swirl rings 14850595833
  (LE 0.5, 0 -> 45), 13724617538 (spin -225 deg/s), 11715867299 (0 -> 58-62 at 3-6% opacity); fire core = 9 layers at
  **LE -1..-5, Br 15-55**, 0 -> 13-17 studs, EMIT 5-15, Speed up to 96, Drag 3-8; embers 350 particles (dot2, dot 3,
  17334135713) Br 35, life to 3.85 s; black smoke 10 x smoke_4 94413041905151 nt + 5 x 16867490141 (**#000000, LE 0,
  tr floor 0.5**) plus 42 x #000001 at LE 0.67; faint veils 18 layers (137087333353962 nt, 12930785601) at tr 0.92;
  dark dust #562525 LE -1 Br 3 at 7% opacity; ground CRACK 13452217224 and Dissolve 13784241004 at **Brightness 0**
  (2.46 s and 3.26 s, the linger).
- Techniques: hot opaque fire = negative LE at high Brightness; colour ramps that dip to near-black mid-life
  (#FF3030 -> #180701 at 47% -> #FF0000) so an additive layer goes out and re-ignites; bolt flicker by Transparency keys
  (4 one-frame dropouts in 0.6 s); black LE-0 smoke that never goes below 0.5 transparency; **a black cloud lit from
  inside**: 55 black puffs (11799607237, #000000, LE 0, life 0.8, tr 1 -> 0.25 at 25% -> 1, Disc shape, ZOffset 10)
  with the bolt flipbooks in front of them (ZOffset 17, Br 15-100), readable 0.1-0.8 s.
- Weak: weight (88 emitters, 936 particles in one frame, 20 near-invisible veil layers); a Br 600 flash depends entirely
  on bloom; 10 copies of the same smoke emitter at EMIT 1 instead of one emitter.

### e73b7ea4943e - Collab FX violet slash burst (second strongest)
- What: three identical waves fired at t 0, 0.1 and 0.2, each = 12 orbs + 1 slash card + 4 dark crescents + 1 spiky
  star + 1 curved beam slash (Forge model, moved by its CFrame curve); plus a white flash stack, white crescents, ground
  cracks, grey wind-swirl meshes and ground dirt. 56 emitters (31 distinct), 8 beams, 14 mesh models, 10 Highlights.
- Phases (recapture): 0.03 one big hooked violet crescent with a white-pink core (first capture: two crescents);
  0.10 a dark violet ball behind a flat violet slash ring (most likely the LE-0 crescents at ZOffset -1), grey arcs
  rising on one side; 0.20 violet slashes and stars, the grey arcs closing round the centre; 0.35 slash fading, purple
  orbs, dirt; **0.35-0.80 the grey arcs stand round the centre as a dome cage about 3.5-4R wide**; 0.55 last thin dark
  slash + orbs; 0.80 cage + a few specks; 1.2 cage faint; gone ~1.4 (est. 1.71).
- Layers: flash = 18772155424 nt (x5, LE 1 Br 15, **life 0.064**) + 15838898369 nt (VP, life 0.089) + 128446029439741 nt
  (Grid4x4, life 0.19), all 0 -> 16.9 studs (2R); slash 78371370584447 nt (Grid4x4, **LE -1 Br 12 #6830FF**, 7 studs,
  0.3 s, ZOffset 1.2); dark crescents 14973797453 (Grid2x2, **LE 0, tr 0.7, ZOffset -1**, spin -500..-200 deg/s, 0 ->
  12.6); white crescents 90260830415214 nt / 14850595833 (**LE 1, Br 0.2-0.4**, 0 -> 9-16, Speed 0.0016-194, Drag 9.8);
  orbs 13712004045 (LE -1 Br 18, 0.44 studs peak, Speed 5-22, Drag 3, gravity -3.3); spiky star 10357935135 (LE -1
  Br 12, 6.2 -> 0 in 0.12 s); beams 103262111231223 nt (Width 3.27, CurveSize0/1 = 9.81/-9.81, Segments 50, **LE 0,
  Br 12**, Transparency 1 -> 0 at 12% -> 0 at 87% -> 1, 0.2 s); GlowCrack 13781849388 (LE 1 Br 10, Squash 0 -> 5.4,
  0.875 s) over Cracks (same texture, **Br 0**, 1.1 s); flat ground swirl meshes 4681227436 growing 0.7 -> 3.7 and
  3.7 -> 19.3 studs (Part Transparency 0.8 -> 1, 2 per model, random yaw) with a Highlight child (white fill 0.6,
  black outline 0.6); the arc cage, most likely the two tall Neon wind meshes 109006532542425 (9 x 18.5 -> 31 x 28
  studs) and 74181482131152 (12.8 x 3 -> 28 x 25 studs), one each, Part Transparency 0.9 -> 1 over 1.0 s, default grey.
- Techniques: identical waves every 0.1 s; bright-over-dark crescent pair (LE -1 Br 12 at ZOffset 1.2 over LE 0 at -1);
  beams at LE 0 + Br 12 = saturated violet that does not wash to white; one emitter fills centre AND rim through a
  Speed range of 0.0016-194 with Drag 9.8.
- Weak: the dark tone is a brief dark-violet ball (0.10 s) and grey wind, no true ink; dirt/grass layers rely on game ground-colour hooks; 10 Highlights
  per cast (the client shows at most 31 at once).

### 941b0d77b160 - DoomSlayer Crucible red-lightning sword (aura, not a burst)
- What: a weapon with a short spawn burst and a continuous crackle. 72 emitters, 65 of them on RATE.
- Phases (recapture, whole blade in frame): 0.03 the neon zigzag blade only; 0.10 white-hot star at the blade's upper
  end (16151520120, VP, 15 particles, Br 25, swell 0 -> 5.3 at 65% of 0.1 s; first capture: 0.03-0.10) with red crackle
  starting; 0.2-0.55 red fire/smoke billow drifting right and a red wisp rising (14197156344 LE 1 Br 24;
  131290109763904 LE 0 Br 14; acceleration +14..+17 up); 0.8 smoke thinning; from ~0.2 s on, steady crackle along
  the blade with an occasional white glint, to the end of capture (2.6 s).
- Layers: 9 lightning flipbooks (17005492589 nt, 17061857191 nt, 15826927544, 131958542548800 nt, ...) at **LE -1..-5,
  Br 45-56, 0.36-4.3 studs, life 0.05-0.2, RATE 15-35, random Rotation, Drag 15**; 3 fire wisps RATE 50; 44 identical
  dot emitters (5076152048, 0.12 studs) on 44 parts tracing the blade edge.
- Techniques: crackle from very short flipbooks at a moderate rate with random rotation (never repeats); LE -1..-5 at
  Br 45-56 keeps the red hue at full punch; the dotted edge line.
- Weak: **3,270 particles/s** in total (2,674/s from the 44 dot emitters alone, up to RATE 293 each), about 8x a 400/s
  budget; the blade Part (SmoothPlastic, Transparency 0.2, 4.2 x 2.6 studs) cuts hard dark edges through the additive
  smoke at 0.35-0.8 s (seen in both captures; transparent parts and particles sort badly).

### 80d86b0489f6 - Voidflare Dive/Jump launch shock (monochrome, weak as "void")
- The first capture placed this effect under the stage floor; everything below is from the recapture.
- What: the burst under the caster as the dive script lifts them 60 studs. 61 emitters, 200 particles, 35 of them flat
  (VelocityPerpendicular). Every colour ramp is white -> #889090 -> #121212 (layer table: no hue anywhere).
- Phases (recapture): 0.03 thin white vertical jet (Smoke3 11871320339: VelocityParallel, **Squash 3 -> 0**, 0 -> 18.3
  studs, white -> #242424) + small white splash; 0.10 the jet splits into 3-4 tall white plumes, a white ground ring
  (~1R) with a fringe of grey radial spikes, dark rock chips, white flecks; 0.20 peak: concentric white ripples on the
  ground, huge translucent wind arcs sweeping up past the top of the frame (the tilted rings: 17848865880 nt,
  17848724385 nt, 17848837505 nt, 0 -> 19-46 studs = 2-4.6R, spread 15-30 deg, spin 135-324 deg/s), radial speed lines,
  grey smoke at the base; 0.35 grey smoke ring, jet thinning to streaks, arcs fill the frame, rocks thrown up; 0.55 low
  grey dust spreading, a faint elliptical ring, a darker flat patch with straight edges at the centre; 0.80 dust and
  dark radial rays on the ground; 1.20 faint dust; 1.8 near-empty; 2.6 a few specks; 3.6 gone.
- Layers worth copying: the same texture twice as FacingCamera + VelocityPerpendicular (11037538087, life 0.1-0.25);
  white needle 16171607099 (LE -2, Br 15, VelocityParallel, swell 0 -> 1.5 at 10%) + a black copy of the same needle
  (#000000, LE 0.6, Squash 0 -> 2.86); a near-black flat shock 16804767781 (#191531 -> #000000, LE 0.3, **Br 0**, 0 ->
  13.5, 0.75 s); a black crack 12467846390 (Br 0, 0.25 s).
- Weak: no hue at all, so it reads as a wind and dust shock, not a coloured void; its dark ground ink (most likely
  Shock 16804767781 at Br 0; the crack is one of the 0.689-count layers below) does show, but only as a faint darker patch with straight card edges (0.55 s) and dark rays (0.8 s)
  that barely separate from a dark floor; busy at 0.2-0.35 s (ripples, frame-filling arcs and speed lines all in the
  same grey); fractional EmitCounts from a density scaler (BaseEmitCount x 0.714 = 0.689 ... 16.1): `Emit()` takes a
  whole number, so the 0.689 layers (Shockwave2, crack, wisp ring) probably emit nothing in game (unverified);
  `impact` 9572542664 has Transparency 1 for its whole life (invisible).

### 783fb2166dc6 - tatsumaki green psychic burst (best dark punch-out, no aftermath)
- What: a 0.6 s burst on a character. 46 emitters, 109 particles; **91% of layers live <= 0.5 s, median 0.2 s**, 34 of 46
  layers emit exactly 1 particle.
- Phases (recapture): 0.03 nothing yet (the first capture showed the full flash here, with **two dark discs inside the
  glow**); 0.10 huge white-green flash with flat jagged shards (spinning 720 deg/s) inside **a translucent green sphere
  about 5 character widths across** (a camera-facing rim texture faking a dome; which layer draws it is unclear,
  candidates 129286674281579 nt at 9-10 studs / 0.5 s and 77383546350314 nt at 12.3 studs) and a dark streak through
  its lower half (most likely the VelocityParallel ink copy: Br 0.05, Speed 84.5, Squash -0.5); 0.20 the sphere breaks
  into green arcs, glowing chips and two orbs; 0.35-0.55 one faint arc at the frame edge; gone by 0.8.
- Layers: **ink discs 102977909637329 nt at Brightness 0-0.05 and LE 0 to -4** (7 layers, 6.5-15 studs, 0.1-0.2 s,
  ZOffset 2.9-3, just behind the bright cards at 3-4) plus one Br 10 copy of the same texture; flat whirl flipbooks
  120231892309889 nt / 137316281619903 nt / 73866757195285 nt (VP, LE 0.5, Br 5-12, RotSpeed 720, 0.1-0.2 s);
  streak sparks 114624268966614 nt (VelocityParallel, LE 0, Br 25, Speed 86-150, Drag 25, life 0.05-0.1); squash pulse
  133649181078588 nt (Squash -0.2 -> 0.714 at 18% -> -0.2 over 0.15 s); colour ramps **#62F2C7 (cyan-white) -> green ->
  #000000** on almost every layer; VP + FacingCamera pairs (77383546350314, 101044231601372, 120763774005899, all nt).
- Weak: nothing lingers past 0.55 s except one arc (no aftermath); the flash frame (0.03 s first capture, 0.10 s
  recapture) half-buries the character in additive white-green; the two hand Trails depend on the sequence's motion.

---------------------------------------------------------------------------------------------------------------

## b. Anatomy of a dark / void / portal / domain effect

Roles in firing order. Nearly every layer is a single burst at t 0 (or in 0.1 s waves); lifetimes, not delays, make the
phases. Size curves: bodies grow 0 -> max on a **cubic-out** curve (Doom smoke: 27% of max at 10% life, 49% at 20%,
66% at 30%, 87% at 50%); flashes start at max and shrink exponentially (halving each ~10% of life); sparks and orbs
**swell** to their peak at 5-10% of life and shrink to 0.

| # | Role | Texture role (example ids) | Orient | LE / LI / Br | Life s | Peak size | Transparency | Motion | Count, ZOffset, extras |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Flash card (white core) | big soft burst or flash: 12118255430, 18772155424 nt, 15049808173 nt, 7216849703 | FacingCamera | LE 1, LI 0, Br 10-25 (Doom 600) | 0.06-0.15 | 1.3-2.2R, start at max, exp. shrink (or 0 -> max in < 0.1 s) | 0 (or 0.95 x 5 stacked) | Speed 0 | EMIT 1-5, z 3-8.3 (front-most) |
| 2 | Spiky impact star (body hue) | starburst: 10357935135, 16151520120 | FC or VP | LE -1 Br 12, or LE 0.5 Br 25 | 0.1-0.12 | 0.75-1.8R; shrink from max, or swell peaking at 65% | 0 | 0 | EMIT 1-15, z 3-5, random Rotation |
| 3 | Ink punch (void core) | soft disc 102977909637329 nt | FC (+ a VP copy) | **Br 0-0.05**, LE 0 to -4 | 0.1-0.2 | 0.8-2.5R, grow 0 -> max | 0 -> 1 after 20% | 0 (one copy VelocityParallel 84.5 with Squash -0.5) | EMIT 1, z 2.9-3 (just under the bright cards) |
| 4 | Dark ground shock | black burst/ring flipbook 16509144751; 16804767781 nt; 98601807716287 nt | VP flat (Speed 0.002-8.8) | LE 0-0.5, Br 0-1, Color #000000 | 0.3-0.75 | 1.3-4R; fast sqrt-like grow (32% of max at 10% life) | 0 -> 0.66 at 39% -> 1, or 1 -> 0.4 | none | EMIT 1-3 |
| 5 | Flat spinning rings / swirl | spiky wind ring 17848865880 nt, swirl 14850595833, ring 11037291253, streak ring 11715867299, toon crescents 14973797453 | VP, SpreadAngle 15-40 (tilted shell) or 360 (random) | LE 1, Br 0.4-5 (dark copy LE 0 Br 1) | 0.15-1.2 | 1.6-4.6R, grow 0 -> max | floor 0 for <= 2R; **0.64-0.97 for >= 3R** | Speed 0.001-52, Drag 1-3.4, RotSpeed 75-500 one sign | EMIT 2-8; ramp white -> #889090 -> #121212; dark copy at z -1 |
| 6 | Body: slash / crescent / fire | slash 78371370584447 nt, crescents 90260830415214 nt, fire 18227093452, 14641036736 | VP for slashes, FC for fire | **LE -1 Br 12-55** (dense, hot) or **LE 1 Br 0.2-0.4** for white cards >= 1R | 0.1-1.5 (slash 0.3) | 0.9-2R | 0 | fire Speed 47-58 Drag 3.1 Spread 360; crescents Speed 0.0016-194 Drag 9.8 | flipbook OneShot (Lifetime = timing); EMIT 1-15; waves at +0.1 s |
| 7 | Streak sparks (+ ink copy) | needle 16171607099, 114624268966614 nt, 122415791346141 nt | VelocityParallel | LE -2..0, Br 15-25; ink copy #000000 LE 0.6 | 0.05-0.55 | swell 0 -> 1.5-1.95 at 10% -> 0 | 0 | Speed 16-150, Drag 3.9-25 (stop distance ~ Speed/Drag) | EMIT 3-10; Squash 0 -> 2.86 on the ink copy |
| 8 | Lightning / crackle | 13390196434 (Loop 10 fps), 9732664178, 15958823639 nt, 17005492589 nt | FC; VelocityParallel for falling bolts; FacingCameraWorldUp for pillars | LE 1 Br 15-100, or LE -1..-5 Br 45-56 | bolt 0.1-0.6, crackle 0.05-0.2 | crackle 0.15-0.5R; bolt card 1R; pillar 2R | flicker keys (one-frame dropouts) or 1.5 -> 0.77 window | Drag 15-20 | EMIT 2 over 0.3 s, or RATE 15-35 for loops; bolts at ZOffset 17 over black cloud smoke at 10 (Doom) |
| 9 | Orbs / embers | soft blob 13712004045, dots 15394196527, 15394198783, off-centre dot 17334135713 | FC | LE -1 (or +-1), Br 18-35 | orbs 0.3-1, embers 0.96-3.85 | orbs 0.44 studs; embers 2.6-3.6 studs at R 15; swell peak at 5-10% | 0 | Speed 5-207, Drag 3-7.3, Accel Y -2..-3.3, Spread 360 | orbs 12 per wave; embers 100-150; RotSpeed +-130 on the off-centre dot (curly paths) |
| 10 | Black smoke | smoke 16867490141, 94413041905151 nt, 11799607237, 18326864825 | FC | **LE 0, Color #000000**, LI 0-0.2, Br 1-3; soft variant #000001 at LE 0.67 | 0.73-2.5 | 1.2-2R, cubic-out | **floor 0.5**, linear to 1 (soft variant floor 0) | Speed 20-147, Drag 4-7 (hangs at 10-26 studs), Spread 90-180 | EMIT 1-2 per emitter x 10-20, or 55 over 0.3 s; z 0-10 |
| 11 | Dark cloud (negative LE) | fog 89816655384560 nt, cloud 8187308218 nt | VelocityParallel, locked | **LE -0.5..-0.9, Br 2.5-5**, Color #231E35 -> #43395D | 1.35-1.95 | 1.1-1.9R const | 1 -> 0.42 at 50% -> 1 (or 1.5 -> 0.5 -> 1.5) | Speed -9.5 (follows its part) | Squash -0.3..-0.7, z 3.5-3.8 |
| 12 | Veil (lit edge) | 137087333353962 nt, 12930785601 | FC | LE 1, LI 0.2, Br 3, #414141 / #D9D9D9 | 0.73-2.06 | 1.4-2.2R | floor 0.92 | Speed 9-179, Drag 5.7 | Squash 0 -> 1.35 |
| 13 | Ground mark (glow + ink) | GlowCrack 13781849388 / 130658933079638, CRACK 13452217224, Dissolve 13784241004 | VP, Speed 0.0003-0.05 | glow LE 1 Br 10; ink **Br 0** (LE 0-0.6) | glow 0.75-0.9; ink 1-3.3 (longest layer) | 0.5-1R const; Squash 5.4 for long cracks | ink floor 0.49-0.6; Dissolve 0 until 62% then fades | none | EMIT 1-2, z 2-4 |
| 14 | Debris | rocks 16070964921 (2x2), 626588936 | FC | LE 0 to -0.1, **LI 0.4-0.75**, Br 0.1-1 | 0.3-4.4 | 0.2-0.9 studs, shrink | 0 | Speed 23-165, Drag 2-8, Accel Y -19..-125 | EMIT 3-15; the only scene-lit layers |
| 15 | Dome shell / arc cage (domain) | tall wind meshes 109006532542425, 74181482131152 (Collab); a rim card, layer unclear (tatsumaki) | Neon MeshPart (fixed yaw); or FC card | mesh: Neon, default grey; card: LE 1 | mesh 1.0; card 0.1-0.3 | mesh grows x2.2-3.4 to 28-31 studs (3.5-4R); card ~2.5-3R | mesh Part Transparency 0.9 -> 1 | none | 1 per mesh; reads 0.1-1.2 s |

Notes on the table:
- **ZOffset stacking** seen across the group: flash 3-8.3 > spiky star / bright body 1.2-5 > ink punch 2.9-3 (just
  under the bright cards it sits inside) > ground 0-2 > dark crescents -1. Smoke can sit forward (Doom z 10) because it
  is black and should cover.
- **Brightness by size** (additive layers): white cards at 1-2R run Br 0.2-0.4 (Collab) or tr floor 0.64-0.97
  (Voidflare, Doom rings); dots under 1 stud run Br 18-56. One flash per effect may go far higher (Doom 600, 0.15 s).
- **Light influence**: every glow, smoke and ink layer has LI 0 (a few 0.2); only debris and ground dust are lit
  (LI 0.4-0.75).

## c. Timing

All six fire everything at t 0 (no anticipation layer; VoidStorm fades in by its transparency curve instead).

| Phase | Window (s) | Range across the six |
|---|---|---|
| Flash / impact frame | 0 - 0.15 | 0.064 (Collab) .. 0.15 (Doom); Voidflare 0.1-0.25; VoidStorm none; recapture first shows Crucible's and tatsumaki's flash at 0.10 and misses Doom's |
| Ink punch inside the flash | 0.05 - 0.2 | visible as soon as the flash shrinks below it; tatsumaki 0.1-0.2 |
| Dark ground shock | 0 - 0.3 | Doom 0.3; Voidflare 0.75 by the table, seen faintly to 0.8 |
| Body peak | 0.05 - 0.35 | tatsumaki peaks at 0.03-0.1; Doom later and longer: bolt column 0.1-0.2, cloud brightest 0.35, fireball 0.2-0.55 |
| Repeat waves | +0.1 s steps | Collab 0 / 0.1 / 0.2; Doom smoke spread over 0.3 s |
| Rings at full size | 0.15 - 0.4, gone by 0.6-1.2 | Voidflare arcs peak 0.2-0.35 and fill the frame |
| Dome / arc cage | 0.1 - 1.2 | Collab cage 0.1-1.2 (meshes 1.0 s); tatsumaki sphere 0.1-0.2 |
| Streak sparks | 0 - 0.1 | 0.05-0.55 |
| Orbs / embers | 0.05 - 1.0 | Doom embers to 3.85 |
| Smoke / dark cloud | 0.3 - 2.5 | Doom black plume peaks 0.8-1.2; VoidStorm cloud 0.2-1.8 |
| Ground mark linger | 0.05 - 3.3 | Collab 1.1, Doom 2.46 / 3.26 |
| Whole effect readable | 0.6 - 2.6 | tatsumaki 0.6, Collab ~1.4, Voidflare ~1.2 (dust; specks to 2.6), VoidStorm ~1.8, Doom ~2.6 |

A good default for a 2R-wide dark burst: flash 0.12 s, punch 0.2 s, body 0.3 s in three waves 0.1 s apart, rings
0.4-1.2 s, smoke 0.8-2.4 s, ground ink 3 s.

## d. Techniques catalogue

Dark layers (the point of this group):
1. **Brightness 0 = ink, whatever the Color.** With LightInfluence 0, Brightness scales the emitted colour, so Br 0
   draws the texture's shape in black. Used for dark layers in 4 of 6 effects: tatsumaki 102977909637329 (white colour,
   Br 0), Voidflare Shock 16804767781 and crack 12467846390, Doom CRACK 13452217224 and Dissolve 13784241004 (colour
   #959595, Br 0), Collab Cracks (#713DFF, Br 0). LightEmission then sets the strength: LE 0 = normal black, LE < 0 =
   darker than its alpha (tatsumaki LE -1..-4), LE 0.3-0.6 = partial darkening (Voidflare, Doom Dissolve).
2. **Negative LightEmission depends on Brightness.** At low Br with dark colours it darkens and thickens (VoidStorm
   clouds LE -0.5..-0.9 Br 2.5-5; Doom dust #562525 LE -1 Br 3; tatsumaki LE -4 Br 0.05). At high Br it renders as a
   dense, opaque, hot colour that keeps its hue (Doom fire LE -1..-5 Br 15-55; Crucible bolts LE -1..-5 Br 45-56;
   Collab slash LE -1 Br 12 reads bright violet, not dark). *Inferred* from the blend: LE extrapolates past normal
   blending, so the background behind a semi-transparent edge is removed faster than the particle's alpha.
3. **Black smoke**: Color #000000, LE 0, Transparency held at 0.5 then to 1, grow 0 -> 1.2-1.8R cubic-out, Speed
   20-147 with Drag 4.9-5.7 (bursts out, hangs), Spread 90-180, life 0.73-2.4 (Doom smoke_4 / Images/56).
4. **Soft darkening**: Color #000001 with LE 0.67 (Doom IncentS / Images/56, 42 particles): the additive part adds
   nothing and the rest darkens at about one third strength, a shadow haze rather than a black blob.
5. **Black ground shock**: Doom 16509144751, #000000 LE 0, VelocityPerpendicular (flat; Speed 8.8 lifts it ~2.6 studs), Size 0 -> 4R in
   0.3 s (32% at 10% life), Transparency 0 -> 0.66 at 39% -> 1, EMIT 2.
6. **Ink punch inside a flash**: a Br 0 disc of 0.8-2.5R at ZOffset 2.9 under bright cards at ZOffset 3-4 and a flash
   at 8 (tatsumaki): as the flash shrinks the dark hole appears inside the glow (two dark discs at 0.03 s in the first
   capture; in the recapture the fast VelocityParallel ink copy shows as a dark streak through the flash at 0.10 s).
7. **Same texture bright + dark**: Voidflare needle 16171607099 white (LE -2, Br 15) + black (#000000, LE 0.6, Squash
   0 -> 2.86); Collab GlowCrack (LE 1 Br 10, 0.875 s) over Cracks (Br 0, 1.1 s): the dark copy outlives the glow;
   tatsumaki ink disc at Br 0 (x7) and Br 10 (x1).
8. **Colour ramps that end in black**: cyan-white #62F2C7 -> green -> #000000 (tatsumaki), white -> #889090 -> #121212
   (Voidflare rings), #FF1414 -> #550000 -> #000000 (Doom S23): on additive layers this is a fade that keeps full shape;
   on LE 0-0.5 layers the tail becomes ink. Three tones in one sprite.

Light and timing:
9. **Hue by channel ratio at high Brightness**: Doom fire ramps through #180701 at Br 33 (= 3.1, 0.9, 0.13 before
   tonemapping) and reads orange; the start key #FF3030 x 33 reads yellow-white. Author dark colours and let Brightness
   set intensity (*inferred*, matches the sheets and the misc group's finding).
10. **Colour dip = flicker**: #FF3030 -> #180701 at 47% of life -> #FF0000 (Doom fire, lightning cards): an additive
    layer goes out mid-life and re-ignites.
11. **One-frame dropouts**: Doom bolt Transparency keys = hidden until 17% of a 0.6 s life, then 1.0 spikes at 23%,
    45%, 65%, 75% of life, each 0.02-0.03 of life wide (12-18 ms). A bolt that blinks, not a screen strobe.
12. **Transparency keys above 1** hide part of a life: 1.5 -> 0.5 at 50% -> 1.5 = visible only from 25% to 75%
    (VoidStorm). A free delay for single-particle layers.
13. **LE above 1** (VoidStorm 1.11 at Br 120, 2 at Br 95): super-additive specks; rare (0.3% of 106k designs). Avoid.
14. **Flash that shrinks**: Doom 12118255430 at Br 600, Size 32.6 -> 21.7 (20%) -> 12.8 (30%) -> 4.7 (50%) -> 1.4 (70%)
    -> 0 over 0.15 s, ZOffset 8.3: a white-out that collapses into the body.

Shape and motion:
15. **Tilted ring shell**: VelocityPerpendicular rings with SpreadAngle 15-40 (Voidflare 15-30, Doom 20-40) are not
    coplanar, so 3-4 rings read as a gyroscope/shell; SpreadAngle 360 = fully random orientation (Collab cres, Doom
    Wind). *Inferred* for portals: a narrow spread (4-10) around EmissionDirection Front gives a standing ring stack.
16. **Rings spin one way**: RotSpeed 135-276 (Voidflare), -500..-200 (Collab crescents), -225 / -407 (Doom); never
    mixed signs within a layer.
17. **Big = faint**: rings >= 3R sit at tr floor 0.64-0.97 or Br <= 1; the 46-62 stud rings would white out otherwise.
18. **Centre and rim from one emitter**: Speed 0.0016-194 with Drag 9.8 (Collab crescents) leaves some cards at the
    centre and throws others ~20 studs where they stop. Stop distance ~ Speed / Drag (up to 1.44 x that; the exact
    drag formula is undocumented).
19. **Running crack**: a flat sprite (VP) with constant Size 3.65 and Squash 0 -> 5.4 stretches along one axis over its
    life (Collab GlowCrack).
20. **Jet that opens**: VelocityParallel smoke with Squash 3 -> 0, Size 0 -> 18.3, Speed 21-96, Drag 1.75, Spread 5
    (Voidflare): a tall thin line at birth that widens into a puff.
21. **Upright pillar card**: FacingCameraWorldUp + Squash 0.5 + Size 32 (Doom lightning card) stays vertical while it
    faces the camera.
22. **Squash pulse**: -0.2 -> 0.714 at 18% -> -0.2 over 0.15 s (tatsumaki): stretch tall, snap back flat.
23. **Double-plane pop**: the same texture as a FacingCamera and a VelocityPerpendicular copy (Voidflare 11037538087,
    tatsumaki x3 pairs) reads from any camera height.
24. **Whirl in 0.1 s**: flat flipbooks with RotSpeed 720 and life 0.1-0.2 (tatsumaki).
25. **Identical waves**: the same layer set re-fired at +0.1 and +0.2 s (Collab) multiplies the impact without new art.
26. **Curly embers**: off-centre dot 17334135713 with RotSpeed +-130 (Doom) orbits its own centre as it flies.
27. **Crackle loop**: lightning flipbooks of 0.15-0.5R, life 0.05-0.2, RATE 15-35, random Rotation, Drag 15, LE -1..-5
    Br 45-56 (Crucible). Never repeats.
28. **Curved slash beam**: Width 3.27, CurveSize0 9.81 / CurveSize1 -9.81, Segments 50, LE 0, Br 12, Transparency
    1 -> 0 (12%) -> 0 (87%) -> 1, 0.2 s (Collab).
29. **Mesh wind with a Highlight** (Collab): MeshPart Transparency 1 + Highlight (FillColor white, FillTransparency 0.6,
    OutlineColor black, OutlineTransparency 0.6), Part Transparency 0.8 -> 1, EmitCount 2 with random yaw (MaxInitRot
    Y 360), growing x5 to 15.6-21.6 x 4.3-5.4 studs (flat) in 1.0 s; most likely the low grey swirl round the base (the
    tall cage is a different mesh, see 30). Collab mesh decals also use Decal.Color3 overdrive (3.92 and 217.9) for
    HDR-bright decals.
30. **Dome from arcs or a rim card** (recapture): Collab's two tall Neon wind meshes (109006532542425: 9 x 18.5 -> 31 x 28
    studs; 74181482131152: 12.8 x 3 -> 28 x 25 studs; one each, Part Transparency 0.9 -> 1, default grey, 1.0 s) stand
    round the centre as a faint cage of grey arcs from 0.2 to 1.2 s (most likely; each mesh appears to hold several
    arcs); tatsumaki gets a translucent sphere for 0.1-0.2 s from one camera-facing card about 2.5-3R wide. For a
    domain: a few faint shells, not a solid dome.
31. **Storm cloud lit from inside** (Doom, recapture): black LE-0 puffs at ZOffset 10 with bolt flipbooks at ZOffset 17
    and Br 15-100 in front; the cloud reads as black with red veins, brightest at 0.35 s.

## e. Mistakes and weak spots

- **A ground portal that reads as a flat disc (round 1, 2026-11-16, owner ~4.5: depth was asked; "the smoke is kinda
  low quality").** Bright swirl bands ran right across the centre at one height and one brightness, so the pit was a
  painted plate. Depth cues to stack (drafts from this one case, check them in a capture): a true-black centre
  covering a third or more of the radius; arms that thin, dim and speed up toward it; 2-3 swirl layers at different
  heights turning at different speeds; the rim as the one hot mass with a lip that hides the near edge of the
  inside; debris and streaks that shrink and fade as they go in. Rim smoke is a volume (overlapping, two-tone,
  rising from the lip), not 8 faint separate puffs; pulled-in rocks are faceted (`ctx.Crystal`), not plain cubes.

- **Particle rate abuse**: Crucible 3,270 particles/s from one weapon (44 dot emitters alone 2,674/s, one at 293/s).
  Use one emitter with a Shape along the blade.
- **Too many layers for the payoff**: Doom 88 emitters / 936 particles in one frame; 10 identical smoke_4 emitters at
  EMIT 1; 20 veil layers at 3-8% opacity.
- **Dead layers**: Voidflare `impact` (Transparency 1 all life), VoidStorm `bg-clouds` (peak 1% opacity), Doom Wind9
  (#1E1E1E additive adds almost nothing), Doom Wind 11715867299 at 3% opacity.
- **Fractional EmitCount** from a density scaler (Voidflare 0.689 ... 16.1): `Emit()` needs a whole number; round.
- **Transparent parts in front of particles**: Crucible blade (Transparency 0.2) slices a black wedge through the
  smoke. Keep effect geometry opaque, or Neon, or out of the particle volume.
- **No hue = not "void"**: Voidflare is white-grey-black only and reads as a wind and dust shock; its Br-0 ground ink
  is there but too faint on a dark floor. The effects that read darkest (Doom, tatsumaki, Collab) all have a saturated
  body hue plus a true black layer (Br 0 or #000000 at LE 0) set against something bright.
- **No aftermath**: tatsumaki is gone at 0.55 s; give at least one 1-3 s ground ink or smoke layer.
- **Subject lost under the flash**: tatsumaki's flash frame half-buries the character in additive white-green; keep the flash
  small (<= 2R) or short (<= 0.1 s), or put the ink punch over the subject.
- **Bloom-dependent numbers**: Br 600 (Doom) and LE 1.11-2 at Br 95-120 (VoidStorm) look different under every
  bloom setting; prefer Br 10-25 flashes.
- **Dark tone faked with grey** (Collab wind meshes): grey additive does not darken; use #000000 at LE 0 or Br 0.
- **Highlights per cast** (Collab 10): the client draws at most 31 at once; several casts on screen will drop some.
