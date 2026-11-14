---
title: "Open-source VFX study: beam / laser"
source: "open-source VFX library (Discord packs) studied 2026-11-13"
tags: [vfx, roblox, beam, laser, trail, particles, muzzle, impact, open-source-study]
---

# Beam / laser: what 7 open-source effects teach

Evidence: freeze-frame sheets + layer tables in `gallery/effects/beam/` (repo root; layer tables: `kit/scripts/layer_table.py`)
(Edit-mode replayer, scripts stripped), the decoded instance trees in the decoded pack files (`kit/scripts/rbxdump.py`) (attachment positions,
Beam endpoints, Forge attributes the tables truncate) and the effects' own scripts read as text. This extends
`../PATTERNS.md`; it does not repeat it. **Seen** = visible in the stills; **Table** = layer table / dump;
**Script** = the effect's own (untrusted, not run) code; **Unclear** where nothing settles it.

**Captures.** The Seen notes come from the recaptured sheets `gallery/effects/beam/<id>.jpg` (2026-11-14: effects
placed by their emitters on the floor, each view measured and aimed, camera locked). The first capture had placed 6 of
the 7 too low; claims that relied on it were re-checked and corrected (revision notes at the end). The recapture frames
`ebf853272c64` very wide (its projectile template and impact sit ~300 studs apart), so its notes keep the first
capture's close view, which the new frames agree with.

**What the group really is.** Only 2 of the 7 draw their beam with Beam instances (`f4248717e073`, `79af1f3a498d`).
One builds the laser out of particle streaks (`d6a216ec5995`), one is a beam's charge-up whose beam never fires
(`b72098bc93a1`), one is a spark column (`f7c71691a378`), one a hit burst (`ad89e82f9154`), one trail projectiles with an
impact (`ebf853272c64`). Together they cover a laser's whole life: charge, muzzle, body, travel, hit, linger.

Group numbers (Table): 308 emitters, 70 Beams, 11 Trails. LightEmission < 0 on 51 emitters (17%), = 0 on 171 (56%),
between on 19, = 1 on 65 (21%), > 1 on 2 (LE 3 and LE 15). So 73% of layers are non-additive (library: 48%): beam
effects lean on solid colour boosted by Brightness, not on additive stacking. Median Brightness 5; 106 layers (34%)
Br >= 10, 10 layers Br >= 50, max 155. Orientation: FacingCamera 125, VelocityPerpendicular 122, VelocityParallel 61.

**Library numbers for Beams and Trails** (my count over `catalog/effects.jsonl`, 5,021 distinct Beam designs and
1,260 Trail designs, deduplicated on every property but the name):
- Beam: LightEmission 1 in 46%, 0 in 40%, between in 14%; LightInfluence 0 in 90%. Brightness median 2 (p25 1, p75 5,
  p90 15). TextureMode Stretch 86%, Static 11%, Wrap 3%; TextureLength median 1 (p90 22). TextureSpeed median 1
  (p75 3, p90 5.9), negative in 12%, zero in 14%. FaceCamera 46%. Segments 10 in 44%; 50-1000 in 27%. Width0 median
  5, Width1 median 10; equal widths 45%, Width0 = 0 in 9% (a cone from a point). Curved 54%; CurveSize0 and CurveSize1
  of opposite sign (arch/bow) 30%. Enabled = false in 61% (templates switched on by code). Black colour in 10%
  (327 at LE 0 = ink ribbons; 126 at LE 1 = draws nothing unless the colour is tweened: a smell).
- Trail: Lifetime median 0.3 s (p25 0.18, p75 0.5, p90 1.4); LE 0 51%, LE 1 35%; Brightness median 4; width curve
  shrink 52%, const 22%, swell 21%; FaceCamera 74%; Stretch 70%, Static 27%.

---------------------------------------------------------------------------------------------------------------

## a. The seven effects

### 1. `f4248717e073` Prototype 2 (`prototypebeam.rbxm`): sustained magic laser, est. 7 s. The best real beam here.
- What (Table): a 72-stud laser (attachment `att0` z -11.5 to `att1` z +60.4) switched on for 4 s by the generic
  util (every Beam: `EmitDelay 0.1`, `EmitDuration 4`), wrapped by a **cage of 40 bowed ribbons**, with 24 muzzle
  emitters 1 stud behind `att0`. Two Neon MeshParts (mesh 6044670354, ~70 studs long, colours #645BE4 and #270607)
  never render in either capture (the 0.03 frame is empty): unclear whether the mesh failed to load or the replayer
  skips static parts.
- Phases (Seen; close perspective view along the axis, the muzzle in the distance and the beam fanning toward the
  camera): 0.03 empty (the beams wait for EmitDelay 0.1); 0.10 the whole stack is on at full width (no grow-in): a fan
  of pink streaks converging on the muzzle, **near-white where the additive pink layers overlap** in its centre, black
  ribbon edges along the top of the stack; 0.20 a spiky white-pink star sits on the muzzle, a wide violet ribbon with a
  blue rim and red line beams show inside the fan; 0.35-3.6 sustained, with long pink-white sheets flying off toward
  the upper right (rings or specks seen edge-on; unclear which); 1.20 the whole view turns red with a dark-red ring arc
  on the left (likely the 42-stud Swirls29 ring, #FF2C5D at LE -1, passing the camera); 1.8-3.6 pink again.
- Layers (Table): **body haze** 4 FaceCamera beams 15824130839 / 15824087323 (wavy smoke-noise on black), Width
  16-22, LE 1 (one LE 0), Br 14, Transparency along the length 0.64 -> 0.71 @0.16 -> 0.91 @0.5 -> 1, TextureSpeed 2.6,
  ZOffset 4.5-5; **line beams** 16892374733 / 119058761936819 / 107746228303534, Width 14, opaque, TextureSpeed 5;
  **ink beam** 16892386886 #2A2044 LE 0, Transparency 0.68 -> 1, ZOffset 1; **cage** 12781834839 on 8 attachment pairs
  rolled 45 deg apart, 5 tones each (pink #FF297B LE1 Br7 W8-10, dull #74539C LE1 Br1 W7-9, violet #38206C LE0
  W10-12, black LE0 W9-11, red #FF2C3A LE0 W10.5-12.5), CurveSize0 +5..+10 / CurveSize1 -6..-10, FaceCamera false,
  TextureSpeed -2..-5; **muzzle**: travelling rings (Swirls29 135190266136069, Wind1 76109550912270, Wind5
  102374151967894; Rate 12 each), sigils (magic_01-pentagon 113456825922961 LE 3 Br15, rune_11 71046177668087,
  Infinity Circle 135141028133816, Portal Outward 13370270611, halftone; size 13-20, Rate 2-8), `ray`
  123853979238604 LE **15** Br15 0 -> 35 studs over 3 s, and **streaming specks** Spec37 16879834064 x5.
- Techniques: (1) the rolled-attachment cage; (2) 5 tones on one curve with different TextureSpeeds so the bands
  slide against each other; (3) the body fades along its own length, so the laser dissolves into distance without an
  end cap; (4) streaming specks: invisible for the first 31% of life while Acceleration 1000 along the axis bends them
  into streams (section d).
- Weak: no dedicated white layer: white appears only where pink additive layers stack, so the core's value depends on
  how many ribbons overlap at that angle; ~46 beams + ~660 particles/s for 4 s; the specks' Acceleration is
  world-space (breaks if the beam is re-aimed); a big LE -1 ring crossing the camera turns the whole view red (1.20).

### 2. `79af1f3a498d` Yaversu RunKick (`Purple.rbxl`): kick that releases a spiral drill of beams, est. 2.5 s
- What (Table): folders Swipe / Swirl / Startup / Kick that a game script would play in sequence; the replayer fires
  all four at t = 0, so the sheet superposes anticipation, release and the kick. 105 emitters, 16 Beams, 8 Trails,
  Forge mesh Models.
- Phases (Seen): 0.03 peak: wide translucent purple veils fill the whole view, with a white veil at the upper right
  and one dark curl: the drill cone at its widest (Width0 15) right round the dummy; the 1-2 frame smears are lost
  under it (one violet sliver); 0.10 the veils have narrowed into grey swirl arcs round the dummy, inside them a burst
  of violet flame shards (up to a dummy-height long), 4-point stars, crescents and dark smoke; 0.20 soft violet glow
  blobs among the grey arcs; 0.35 violet curls and crescents, stars and dark-purple smoke silhouettes spread about
  three dummy-widths; 0.55 scattered sparks, fading arcs, dark smoke; 0.80 a few sparks and green leaf bits; 1.2 a few
  leaves and rocks; 1.8 on, empty.
- Layers (Table): **the drill** = parts Beam1/Beam2: 8 `Beam101` (10240434007 toon blob streak, white, LE 0) + 8
  `BeamAura` (12713360567 wavy line, #402C63, LE 0, Br 2), each from a ring of radius 6.1 to one apex 13 studs ahead,
  CurveSize0 -10 / CurveSize1 2, 10 segments; Forge attributes Width0 15 -> 4, Width1 2 -> 1.5, Speed_Texture 6 -> 1,
  Transparency_Scale 1 (BeamAura) or 1.7 (Beam101) -> 2, EffectDuration 1.0 s; along-beam Transparency 1 -> 0.65
  @0.1 -> 0.43 @0.24 -> 0.61 @0.71 -> 1. **Corkscrew trails**: 4 `Beam Slash` trails (118758348149908, life 0.2,
  width 1 -> 0, #5F29FF Br15) at radius 2.6 on a Forge mesh copy that flies 13 studs while spinning (Part_RotSpeed
  7 -> 0). **Smears**: BeamWave 13801691431 / Impact27 16892268625 / Layered Impact 10365552059, life 0.03-0.05.
  **Specks** 16879806460 at LE -0.5 / -2, Br 10 (26 of 105 layers are LE < 0).
- Techniques: spiral cone of curved beams to one apex; width snaps wide and tightens (15 -> 4 out-cubic) while the
  texture slows (6 -> 1): Seen as purple veils at 0.03 that become thin grey arcs by 0.10; 1-2 frame smear streaks
  for the strike frame (hidden by the veils in this view).
- Weak: at its widest the cone covers the whole view when the camera is near (0.03), a one-frame wash; afterwards the
  Beam101 copies (Transparency_Scale 1.7, densest 0.15 becomes 0.745) read only as faint grey arcs; green leaf and
  grey rock debris inside a purple effect; 129 visual instances for one kick.

### 3. `d6a216ec5995` Zoltraak ShotEf (`ZoltraakSpellVFX.rbxm`): hitscan spell laser built from particles, est. 3.4 s
- What (Table): one of six identical shots (`ShotEf`..`ShotEf5` at EmitDelay 0 / 0.3 / 0.6 / 1.2 / 1.6 / 1.8: a
  barrage); the study plays `ShotEf`. Part 7 x 7 x 36.45 tilted 40 deg = the barrel; 6 emitters on the part fire
  along it (EmissionDirection Back = along the shot; 4 streak layers, 2 dot layers); 17 emitters at the muzzle attachment (z -17); child
  `Ice3` = the impact on the ground ~38 studs ahead, EmitDelay **0.02 s after its shot** (0.32 vs 0.30 in ShotEf1).
  **No Beam instance at all.**
- Phases (Seen; muzzle at the top, impact on the ground below): 0.03 a white-out: a soft white flash covers about a
  third of the view round the muzzle (HIT EFFECTS 2, 70 studs), and the impact already glows on the ground as a small
  blue orb with flat rings; 0.10 the laser: a column of blue-white streaks from a white muzzle blob (with one thin
  vertical ray) down to the impact orb; 0.20 the rune circle fades in behind the muzzle, wind rings round it, the
  streak column still on; 0.35 rune circle at full strength, the column breaking into a stream of sparkles; 0.55-0.80
  the rune circle alone with sparkles drifting down; 1.2 sparse dots; 1.8 a faint ground glow; 2.6 empty.
- Layers (Table): **barrel** IMG_9350 131290109763904 (Grid8x8, Size 10 -> 19.8 -> 25), trace_05 15268229875
  (0 -> 10.7, envelope 2.4), Smoke6 11808623574 (const 11.9, Transparency 1 -> 0 @0.5 -> 1), Images/18 16879840263,
  all VelocityParallel, Rotation fixed +-90, Squash 0 -> 0.5 -> 0.6, Speed 8.6-257, Drag 5.1, life 0.35-0.87, LE 1
  Br 5-15 on dark navy (#252F59, #32495F); **muzzle flash** HIT EFFECTS 2 10198439352 (Grid4x4 OneShot, Size 70 -> 0,
  life 0.06-0.12, LE1 Br25, ZOffset 7); **sigil** 75751709312199 (10 studs const, Squash -0.3, life 1.17,
  Transparency 1 -> 0 @0.5 -> 1, LE1 Br5); **sparks** SparksLinger 7922645282, dot 3 15394198783, Starts 15615341722
  (Br 15-45 on #344860-#3E5865); **wind rings** 139071870446239 #1F1F1F Br25, Impact327 12402897209 #111111 Br15;
  **impact** rings at random 3D tilts (decay16 15269685466, shock 133650067075481, 17409991165), ink (127136593142768
  LE -1 Br50, Circle 14687560696 LE -1 Br40), smokes to 3.35 s (smh 138231890129613, smokkk3 96092264894202).
- Techniques: particle-built laser (a long box part emitting VelocityParallel streaks along its axis); near-black
  colours x Brightness 15-45 additive = controlled pale blue (hue by ratio, intensity by Brightness); hitscan impact
  2 frames (0.02 s) after the muzzle; barrage cadence 0.2-0.6 s.
- Weak: the line is only streaks: it reads as a beam for ~0.1-0.35 s, then as a sparkle trail, never as a solid core;
  the 70-stud flash whites out a third of the view at 0.03; 568 particles per shot x 6 shots; 14687560696 has no
  thumbnail (likely broken).

### 4. `b72098bc93a1` Blue Beam (`Unfinished.rbxm`): charge-up of a beam that never fires, est. 19 s (EmitDuration 15)
- What (Table): a 0.45-scale avatar; a box part with 15 continuous emitters (712 particles/s in total); a Neon orb 6.4
  studs in front with two cone beams `12` (Width0 0 -> Width1 9.1, CurveSize +-2.3, LE1 Br10, enabled) and two
  `Beam75` (Width1 22.6, disabled); a hand orb joined to it by two crackle beams (disabled, no emit attributes).
- Phases (Seen): 0.03 black vertical bars round the avatar (the black BeamWave crackle copy), the hand orb lit, and
  two long grey translucent wedges from the orb (the `12` cone beams, Transparency 0.75 -> 1); 0.10 blue streaks and a
  flat blue ring on the ground at the feet; 0.20 tall thin blue pillars 2-3x the avatar's height and curved white
  lightning arcs; 0.35 a white 4-point flare at the chest and white toon smoke puffs at the feet; 0.55-3.6 the same
  loop: blue and black streaks interleaved, each visible 1-2 frames, smoke puffs, the wedges, now and then a tall
  pillar. The bright oval at the lower right is the front Neon orb near the camera. No beam ever fires (disabled
  templates).
- Layers (Table): **crackle** BeamWave 13801691431 (black), Beam97 77189927291566, BeamSpiked 117143920327635 /
  16879828729, Spec48 16997104240, Water9 16865869553: VelocityParallel, life 0.02-0.03, Size 1.3 -> 0, Squash 0 -> 3,
  Speed 13-65, RATE 50 each; **lightning flipbooks** 17061859571 / 115846753587357 / 17005501598 LE -0.5, life
  0.05-0.1, RATE 15; **outline beams** 13280245934 / 137421465332915 FaceCamera, TextureLength 0.1, TextureSpeed 155.
- Techniques: the 2-frame crackle (life 0.03 + Squash 3; the streaks render as thin pillars much taller than wide,
  consistent with positive Squash stretching the sprite along its height) with **one black copy** (BeamWave #000000,
  LE 0, Br 15) interleaving dark bars with the bright ones; a cone from a point (Width0 0, Width1 9-22.6, CurveSize
  +-2.3..3.2) as a blast fan (Seen as grey wedges); crackle by scroll (TextureSpeed 155 on TextureLength 0.1; disabled,
  look unverified).
- Weak: the payoff is missing; a charge that never changes for 19 s; 712 particles/s; the hue is blue only (the dark
  tone comes from the black crackle copy and black Circular Smack / shockwave sprites).

### 5. `f7c71691a378` Light Sacred Jewel `Dash`: gold spark column, est. 1.0 s
- What (Table): an invisible 10 x 10 x 47.9 part (a 48-stud column); 6 emitters on the part fill its volume with gold
  streaks shooting along the long axis (Speed 1.44-250, Drag 4.5-5.8); 8 emitters at one end (z -22.25) burst dots,
  stars and lines in all directions. Every layer #FFBD3A. 5 layers have EmitDelay **-0.5** (fires at once: every util
  treats a negative delay as 0).
- Phases (Seen): 0.03 empty; 0.10 a bright gold flash at the base with short streaks above it and ~10 round glows
  scattered higher; 0.20 peak: a narrow column of gold streaks (about 4x taller than wide) standing on the base;
  0.35 the column has risen off the base; 0.55 faint, thinning streaks; 0.80 traces; 1.2 empty. Only this narrow
  column shows: the particles do not fill the 10-stud width of the part.
- Layers (Table): column streaks Stylized Star 18636189591 (EMIT 100, VelocityParallel, Squash 0 -> 0.554, life
  0.14-1), Shards2 18636201915 (50), flipbooks Fire123 96626727980511 / Pointy Star 12452578181 / Smoke 15123700665,
  **LE 0, Br 50** (Smoke LE 1, Br 50); Star102 17391818367 cross 8.8 studs for 0.3 s; end burst Lines 12938221405 / 8085900043
  (VelocityParallel, spread 360, Drag 10-15), Specs 13369657435, Star 10656594569 / 10904740497 (LE1 Br20).
- Techniques: LE 0 + Brightness 50 = a saturated solid gold glow that does not wash to white; an emitter on a long
  part = particles along a line; speed >> drag makes streaks that rise and stop.
- Weak: one hue (no white core beyond the base flash, no ink); 327 particles for a 1-s accent; reads as a rising
  spray of sparks, not as a dash line.

### 6. `ad89e82f9154` purple.rbxm `TestingPart`: violet hit burst (where a beam lands), ~0.4 s
- What (Table + Script): 31 emitters at one attachment, all EMIT at t = 0, fired every 2 s by its loop script;
  the script also tweens 9 meshes (Outline, Impact, Swirl, SwirlTwo, Wind..., 17.8 to 73 studs wide) over 0.1-0.5 s
  (Linear InOut or Circular Out, Transparency 0 or 0.96 -> 1). The meshes are missing from the stills.
- Phases (Seen): 0.03 a violet smoke-and-flame mass about half the view wide, lavender-white in its densest parts,
  a soft lavender haze over the whole upper half, 4-point stars and two light streaks in a V below; 0.10 peak spread:
  4-point stars (one about a quarter of the view wide), ring arcs, crescent shards, curls; 0.20 violet curl blobs over
  the whole view with grey rocks and green grass streaks; 0.35 sparse remnants; 0.55 gone.
- Layers (Table): **pop stars** Star131 15840018597 / Circle Centered 100664667744354, Speed 492-985, **Drag 76**,
  life 0.15-0.35, Size 6.15 -> 0, Squash 0.11 -> 0.98 @0.29 -> -0.25; **streak flash** Dbz_Aura 100372125086427
  (Speed 352-704, Drag 76, life 0.05, Squash 0 -> 5); **0.1-s flipbooks** Wind35 91804963265247 (0 -> 40.3),
  16509892607, Energy Pulse 12123878312, Swirl 13603608421, Circular Smack 18140248952, Wavy 139843022964858
  (30.8 -> 0); **faint shells** 13367229656 / 109920824813240 at Transparency 0.98 (32-42 studs); debris 392758851
  (Acceleration -172 y), Rock6 85403020583447 LE -1. 19 of 31 layers are #754FFF, 17 of them at LE 0, Br 12.
- Techniques: pop-and-stop (travel ~ speed / drag = 6.5-13 studs in 2 frames); a 16-frame flipbook skimmed in 0.1 s
  (stepped smear look); LE 0 + Br 12 keeps violet violet.
- Weak: one violet hue (white only where Br 12 saturates the densest smoke), almost no ink (only Rock6). The 0.03
  haze shows that 98%-transparent layers can still read when Brightness is high (2% x Br 12-15 ~ 0.3): unclear whether
  the haze is the shells or the 49-stud `debris burst 2` (LE 1, Br 12, 0.1 s).

### 7. `ebf853272c64` bloody orbs: curving red missiles with trails and impact, est. 6 s
- What (Script): 4 projectiles per cast, each on a random Bezier (3 midpoints +-15 x, +5..10 y, +-15 z) over
  0.65-0.95 s; the impact fires 0.1 s before arrival; camera shake, vignette, a ColorCorrection tint (in 0.001 s,
  out 0.25 s), PointLight Br 2.5 -> 0 / Range 0 -> 15 over 0.6 s, impact light Br 9 -> 0 / Range -> 40 over 0.3 s.
  The replay shows the projectile template and the impact in place.
- Phases (Seen, complete): 0.03 peak: a white-red ball with a soft red halo; 0.10-0.35 a red spiky splatter star;
  0.55 sparse specks; 0.80 a few dots; 1.2 a faint red tint over the area; 1.8 empty.
- Layers (Table): **trails** 6091474388 / 6091329339 / 5320412027 (life 2, width 0.225, LE1 Br9, TextureLength 3.75);
  projectile specks 14944433028 (red and black, LE -0.1, Size 0.4, Squash 0.1, EMIT 50 + 5 s on), core 14709239500
  (Br **155**, Size 1.2); **impact**: crack 13783882492 (ground-flat, 20 studs, OneShot 1 s, LE 0.4 Br10), 1-frame flash
  Spec19 16879789169 (68 studs, LE1 Br2, life 0.05), dim glow Spec19 (75 studs, Transparency 0.55, life 1.7-2), stars
  Impact13 16892226410 / Impact28 16892272385 (0 -> 12.7-13.9, life 0.07-0.15), 6 spark layers Spec24 16879802703 /
  Spec25 16879804431 (25 each, Speed 40-60, Drag 5, Acceleration -12 y, Size 2.62 -> 0, Br 0.55 / 2.5 / 5).
- Techniques: three noise-line textures overlaid on thin trails; one spark design copied at three Brightness tiers
  for tonal depth; a ground crack; a giant dim sprite as an area tint.
- Weak: red only (black specks are the only ink); 150 sparks from 6 near-identical layers; the 75-stud tint fills the
  whole view (fine on a dark stage, mud in daylight).

---------------------------------------------------------------------------------------------------------------

## b. Anatomy of a beam / laser effect

Reference sizes: **W** = beam body width (Prototype 16-22, Zoltraak barrel 7), **L** = beam length (Prototype 72,
Zoltraak 36). W is about 0.2-0.3 L in these effects. Layers in firing order.

| # | Role | Fires | Textures (role: ids) | LE / LI / Br | Lifetime s | Size (peak vs W) | Transparency | Speed / Drag / Spread | Orientation, Squash, Flipbook | Count | ZOffset |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Charge rings (converge or run down the axis) | before fire, continuous | thin rings: 135190266136069, 76109550912270, 102374151967894, 7394759196, 14850595833 | LE 0 / -1 / -2 + one black LE 0 copy; Br 1-15 | 0.25-0.67 | shrink 42.7 -> 2.85 (2 -> 0.15 W) or grow 0 -> 24 (1.2 W), out-expo baked in ~12 keys, envelope ~50% | 0 -> 0.875 @0.46 -> 1 | 15-88 along the axis / 2 / 24 | VelocityPerpendicular, RotSpeed -1000..-500 | Rate 12 per layer, 4 tones | 0 |
| 2 | Charge crackle | before fire, continuous | streak lines: 13801691431, 77189927291566, 117143920327635, 16879828729 | LE 0 (-0.5), Br 5-20; one black copy LE 0 Br 15 | **0.02-0.03** | 1.3 -> 0 (about 0.6 x character height) | flat 0 | 13-65 / 0 / 0 | VelocityParallel, Squash 0 -> 3, Grid4x4 OneShot | Rate 50 per layer | 1-1.5 |
| 3 | Muzzle flash | t 0 | 10198439352 (Grid4x4), 16879789169 soft dot, 70616322760783, 127984119352635 | LE 1 (Noisy at 0), Br 2-25 | **0.05-0.12** | 35-70 studs (5-10 W of the barrel), shrink to 0 or grow from 0 | flat 0 | ~0 | FacingCamera or VelocityPerpendicular; flipbook at 55 fps | 1-5 | 3-7 (on top) |
| 4 | Fire smear streaks | t 0 | 13801691431, 16892268625, 10365552059, 100372125086427 | LE 0, Br 6-12 | **0.03-0.05** | grow 0 -> 8-10.7 (~1 W), or 22 -> 0 | flat 0 | 1.5-704 (Drag 76 on the fast ones) | VelocityParallel, Squash 0 -> 1.5 (or -> 5) | 1-3 | 2-5 |
| 5 | Muzzle sigil / magic circle | t 0 | 75751709312199, 113456825922961, 71046177668087, 135141028133816, 13370270611 | LE 0.3-3, Br 1-15 | 1-1.17 | const 10-20 (1-1.4 W) | 1 -> 0 at 0.37-0.5 -> 1 (fade in to mid-life; Zoltraak Seen: from 0.20 s, full 0.35-0.80 s) | ~0.001-0.03 along the axis | VelocityPerpendicular (faces down the beam), Squash -0.3, RotSpeed -500..-250 or 0 | 3, or Rate 2 | 0.1-2 |
| 6 | Beam body (Beam) | t +0.1 | haze: 15824130839, 15824087323; lines: 16892374733, 119058761936819, 107746228303534 | LE 1 (one LE 0), Br 14 | 0.8-4 s on | W = 0.22-0.3 L; lines 0.64-0.88 W | **along length** 0.64 -> 0.71 @0.16 -> 0.91 @0.5 -> 1 | TextureSpeed 2.6-5, Stretch, TextureLength 1 | FaceCamera, Segments 10, straight | 4 + 3 | 4.5-5 |
| 7 | Ink beam (Beam) | t +0.1 | 16892386886 (soft-edged bar) | LE 0, Br 1, #2A2044 | as body | 0.64-0.88 W | 0.68 -> 1 | TextureSpeed 5 | FaceCamera | 1 | 1 (behind) |
| 8 | Cage / spiral ribbons (Beam) | t +0.1 | 12781834839 (cage); 12713360567 wavy line, 10240434007 toon streak (drill) | pink LE1 Br7, dull LE1 Br1, violet / black / red LE 0 Br1; drill LE 0 Br 1-2 | 1 s (drill) to 4 s (cage) | width 0.35-0.6 W (7-12.5); bulge 0.75 x CurveSize = 3.75-7.5 | flat 0 (cage); drill 1 -> 0.43 @0.24 -> 1 + scale 1 -> 2 | TextureSpeed 2-6 flowing away from the muzzle | FaceCamera false; CurveSize0 +k, CurveSize1 -k on rolled attachments (k 5-10); drill -10 / 2 | 8 rolls x 5 tones; drill 8 + 8 | 0-4 |
| 9 | Body streak particles | t 0 + during | 131290109763904 (Grid8x8), 15268229875, 11808623574, 16879840263 | LE 1 (one LE 0), Br 5-25 on dark navy | 0.35-0.87 | 0 -> 10.7 (1.5 W) or 10 -> 25; envelope 2.4 | 0 -> 0.43-0.46 @0.5 -> 1; Smoke6 1 -> 0 @0.5 -> 1 | 8.6-257 / 5.1 / 0, from a box the length of the barrel | VelocityParallel, Rotation +-90 fixed, Squash 0 -> 0.5 -> 0.6, Grid8x8 OneShot | 15-25 | 0-1.4 |
| 10 | Streaming specks | t 0 + Rate | 16879834064 | LE 0.87 Br 2; one copy LE 0 Br 0 black | 0.4-0.8 | 7.17 -> 0, envelope 7.17 (0.35 W) | 1 until 0.31, 0 from 0.36 to 0.84, -> 1 | 100-120 / 14 / 100 + **Acceleration 1000 along the axis** | VelocityParallel, Squash 0.2, Rotation 90 | 35 + Rate 100 for 4 s | 5 |
| 11 | Muzzle sparks / dots | t 0 | 7922645282, 15394198783, 125523015121474, 15615341722, 12938221405, 13369657435 | LE 1 Br 15-45 on dark colours, or LE 0 Br 50 | 0.29-1.75 | swell 0 -> 0.6-6 @0.06-0.4 -> 0 | flat 0 | 15-250 / 4.5-15 / 15-70 (dots 360) | VelocityParallel (+ Squash 0 -> 0.55) or FacingCamera; RotSpeed +-137..343 | 7-100, median 25 | 0-3.5 |
| 12 | Hit flash + stars | t +0.02 (hitscan) | 16892226410, 16892272385, 14045123768, 15840018597 | LE 1 Br 1-3, or LE 0 Br 12 | 0.07-0.35 | grow 0 -> 12.7-21 (hit radius) | flat 0 | 0, or 492-985 / **76** | FacingCamera; Squash 0.11 -> 0.98 -> -0.25 on stars | 1-4 | 5-6 |
| 13 | Hit rings | t +0.02 | 15269685466, 133650067075481, 17409991165, 17323225068, 109920824813240, 11037067793 | LE 1 Br 2.5-3 | 0.07-0.74 | grow 0 -> 21-30 | 0 or 0.38 flat -> 1 | 0.002-6.7 / 0 / **360** | VelocityPerpendicular (random 3D tilt), RotSpeed +-77..529 | 2-7 | 2-10 |
| 14 | Ink | with flash / hit | 127136593142768, 14687560696, 16879806460, 103104593098163, black copies of rings | LE -0.5..-3 Br 3-50, or Color #000000 LE 0 Br 0-3 | 0.08-1.25 | as the layer it shadows | flat 0, rings 0.66-0.9 | as role | as role | 1-6 | 1-12 |
| 15 | Smoke / linger | t +0.02 | 138231890129613, 96092264894202, 16867447521, 15239406796, 13975873083 | LE 0 Br 1 | 0.26-3.35 | grow 0 -> 4-7.6 (puffs), 0 -> 24.5 (flat disc) | 0.42-0.9 at start -> 1 | 8-156 / 2-9.4 / 360 | FacingCamera; Grid4x4 OneShot | 4-15 | 0 |
| 16 | Trails | with the projectile | thin noise lines 6091474388, 6091329339, 5320412027; slash 118758348149908, 13546935092 | LE 1 Br 9, or LE 0 Br 5-15 | 2 (thin) / 0.1-0.2 (slash) | 0.225 const / 1 -> 0 | flat 0 | - | Stretch, TextureLength 1-3.75 | 3-4 | - |
| 17 | Light | t 0 | PointLight | Br 2-9 | 0.3-0.6 tween | Range 0 -> 15-40 | - | - | - | 1-2 | - |

---------------------------------------------------------------------------------------------------------------

## c. Timing

| Phase | Starts | Lasts | Evidence | Variation |
|---|---|---|---|---|
| Charge | before the fire (-0.5 to 0) or 0-0.35 inside the effect | 0.3 s to continuous | Blue Beam (continuous), Prototype rings (all 4 s), Yaversu `Cursed Energy` EmitDelay 0.35 for 0.8 | large: a design choice |
| Fire flash + smears | 0 | 0.03-0.12 (2-7 frames) | Zoltraak 0.06-0.12, Yaversu 0.03-0.05, bloody 0.05, purple 0.05-0.1 | small |
| Beam on | +0.02 to +0.1 after the flash | snaps to full width in 0-2 frames | Prototype EmitDelay 0.1 (full at 0.10, Seen); Zoltraak streaks at 0.10 | small |
| Width settle | with beam on | over the beam's life, out-cubic | Yaversu Width0 15 -> 4 over 1.0 s | - |
| Hold | | 0.8-4 s | Yaversu EffectDuration 1.0; Prototype EmitDuration 4; Zoltraak streak life 0.35-0.87 | large |
| Hit | hitscan: muzzle + 0.02; projectile: flight - 0.1 (flight 0.65-0.95) | flash 0.05-0.3, rings 0.07-0.5 | Zoltraak `Ice` EmitDelay +0.02; bloody script | small |
| Fade | last 20-30% of the beam's life | 0.2-0.3 s | Transparency_Scale 1 -> 2 out-cubic (243 of 262 Forge beam fades, os-conventions 2.2) | - |
| Linger | until 1.2-3.35 s | sparks 0.6-1.75, sigil 1-1.17, smoke 1.2-3.35, dim tint 1.7-2 | Zoltraak, bloody | medium |
| Repeat | barrage step 0.2-0.6 s | - | Zoltraak 0 / 0.3 / 0.6 / 1.2 / 1.6 / 1.8 | - |

Seen peaks: Zoltraak flash 0.03, streak laser 0.10, sigil full 0.35-0.80 (fades in from 0.20); Yaversu 0.03 (cone
veils), burst 0.10; purple 0.03-0.10; Light Jewel 0.20; bloody 0.03; Prototype full at 0.10 and steady to 3.6. Every
burst is at full size by 0.10 s and mostly gone by 0.55 s; only beams, sigils, smoke and tints stay past 0.8 s.

---------------------------------------------------------------------------------------------------------------

## d. Techniques catalogue

**Beam geometry**
1. **Fade along the length instead of an end cap**: body Transparency (along the beam) 0.64 -> 0.71 @0.16 -> 0.91
   @0.5 -> 1 (Prototype). The laser dissolves into distance; needs Segments >= keypoints - 1 (10 used).
2. **Rolled-attachment cage**: N attachment pairs at both ends, each pair rolled 360/N deg about the beam axis (8 x
   45 deg), CurveSize0 = +k and CurveSize1 = -k (k 5-10): both handles point outward along the rolled X axis, so each
   ribbon bows out by 0.75 k (3.75-7.5 studs) at its middle. FaceCamera false, widths 7-12.5. (Prototype, 40 beams)
3. **Tone stack on one curve**: 5 beams per curve, same texture, different colour / LE / width / TextureSpeed (pink LE1
   Br7 W8-10 speed -4; dull LE1 Br1 W7-9 -2; violet LE0 W10-12 -5; black LE0 W9-11 -5; red LE0 W10.5-12.5 -4.5). The
   dark LE 0 ribbons are 1-2.5 studs wider than the bright one (a dark outline) and the bands slide at different speeds
   (parallax shimmer). (Prototype)
4. **Texture flows away from the muzzle**: positive TextureSpeed when Attachment0 is the muzzle (core beams +2.6..+5),
   negative when the beam was built from the far end (cage -2..-5). (Prototype)
5. **Spiral drill cone**: 8 beams from a ring of radius 6.1 to one apex 13 studs ahead, attachments rotated so
   CurveSize0 -10 / CurveSize1 2 twist each ribbon; two textures (12713360567 wavy line #402C63, 10240434007 white toon
   streak), both LE 0. (Yaversu)
6. **Snap wide, then tighten**: Forge Width0_Start 15 -> End 4 and Speed_Texture 6 -> 1 over EffectDuration 1.0,
   out-cubic: the beam opens 3.75x too wide with a fast-flowing texture and settles. Seen: translucent purple veils
   filling the view at 0.03, thin grey arcs by 0.10. Near the camera the wide first frames wash the whole view.
   (Yaversu)
7. **Cone from a point**: Width0 0, Width1 9-22.6, CurveSize +-2.3..3.2 = a blast fan from the hand or orb.
   (Blue Beam)
8. **Crackle by scrolling**: TextureLength 0.1 (texture repeated 10x, Stretch) + TextureSpeed 155 = per-frame noise
   on an electric beam. Disabled in the file, look unverified. (Blue Beam)

**Particle-built beam**
9. **Laser body from particles**: a long box part (7 x 7 x 36) along the shot, EmissionDirection Back (+Z, along the
   shot), VelocityParallel streaks, Speed 8.6-257 with Drag 5.1 (each travels ~1.7-50 studs then stops), Size 0 ->
   10.7 or 10 -> 25, Squash 0 -> 0.5 -> 0.6, Rotation fixed +-90 (inferred: turns horizontal stroke textures onto the
   velocity axis). (Zoltraak; Seen as a streak column joining the muzzle to the impact at 0.10-0.35, sparkles after)
   Same idea on a 48-stud column with Speed 1.44-250, Drag 4.5-5.8 (Light Jewel).
10. **Streaming specks with a visibility window**: Speed 100-120, SpreadAngle 100, Drag 14, Acceleration 1000 along the
   beam axis, Transparency 1 until 0.31 of life, 0 from 0.36 to 0.84: the sideways burst is hidden while drag and
   acceleration bend the specks into streams flowing down the beam. Acceleration is world-space: set it from the aim
   in code. (Prototype)
11. **Rings running down the axis**: VelocityPerpendicular rings, Speed 19-88 along the axis, SpreadAngle 24,
   RotSpeed -1000..-500, life 0.25-0.67, Rate 12; Size 42.7 -> 2.85 (tighten = suction) or 0 -> 24 (expand = wake);
   copies in LE 0 / -1 / -2 and one black. (Prototype)
12. **Baked ease**: ~12 Size keypoints at 0.1 steps following out-expo (0, 10, 16.7, 20.4, 22.4, 23.4 ... 24.3) instead
   of a linear 2-key ramp. (Prototype Wind1 / ray / Star10)
13. **Big size envelopes**: envelope ~50% of the peak (12.97 on 24.3, 22.8 on 42.7, 7.17 on 7.17) = strong per-particle
   size variety from one layer. (Prototype)

**Light and colour**
14. **Dark colour x high Brightness, additive**: Color #111111-#3E5865 with LE 1 and Br 15-45 renders a controlled pale
   tint (hue from the colour ratio, intensity from Brightness). (Zoltraak)
15. **LE 0 + high Brightness = saturated solid glow**: #754FFF LE 0 Br 12 (purple), #FFBD3A LE 0 Br 50 (Light Jewel):
   bright without washing to white; LightInfluence 0 required. (Purple, Light Jewel)
16. **LightEmission > 1**: `ray` LE 15 Br 15 (0 -> 35 studs over 3 s, RotSpeed -1000..-500), pentagon sigil LE 3
   Br 15. Additive overdrive; outside the documented range, re-check after engine updates. (Prototype)
17. **Negative LightEmission ink on bright flipbooks**: LE -1..-3 with Br 15-50 (127136593142768 LE -1 Br50 Size
   11.6 -> 0 life 0.083; Lightning10 17005504268 LE -3; Specs 16879806460 LE -2). 17% of this group's emitters. (Zoltraak,
   Yaversu)
18. **Brightness tiers of one design**: the same spark layer copied at Br 0.55 / 2.5 / 5 = tonal depth without new art.
   (bloody)
19. **Negative Transparency**: particle16 flat -50 (Zoltraak); the library has beams at -4..-5. Effect **unclear**
   (likely clamped to 0); check in Studio before using.
20. **Lit sprites inside an unlit effect**: two dark disc flipbooks at LE 0, LightInfluence 1, Transparency 0.8
   (104922764134050, 73249515680342, 23-38 studs) so the scene light shades them. (Zoltraak)
20b. **White by overlap**: Prototype has no white layer, yet its beam centre and muzzle read near-white where several
   LE 1 pink layers (Br 7-14) stack; purple's densest smoke at LE 0 Br 12 also reaches lavender-white. Value then
   depends on how many layers overlap at that angle. (Prototype, purple; Seen)
20c. **Faint layers rescued by Brightness**: Transparency 0.98 at Br 12-15 still adds ~0.3 of the colour; purple's 0.03
   frame shows a soft lavender haze over half the view (source layer unclear: the 0.98 shells or the 49-stud
   `debris burst 2`). (purple)

**Timing tricks**
21. **2-frame crackle**: life 0.02-0.03, Rate 50, VelocityParallel, Squash 0 -> 3, Size 1.3 -> 0: each streak shows for
   1-2 frames at a new spot = electric flicker; Seen as thin pillars far taller than wide, with one black copy (LE 0,
   Br 15) giving dark bars between the bright ones. (Blue Beam)
22. **1-2 frame smear streaks on the fire frame**: life 0.03-0.05, VelocityParallel, Squash 0 -> 1.57, Size 0 -> 10.7,
   Speed 45-123. (Yaversu)
23. **Pop and stop**: Speed 492-985 with Drag 76 (travel ~ speed / drag = 6.5-13 studs in ~2 frames, then hang).
   (purple) Same on a streak: Speed 352-704, Drag 76, life 0.05, Squash 0 -> 5.
24. **Flipbook skim**: Grid4x4 / Grid8x8 OneShot on Lifetime 0.1-0.3 = 16-64 frames shown in 6-18 rendered frames:
   a stepped, anime-smear look. (purple)
25. **Hitscan offset**: the impact fires 0.02 s after the muzzle (EmitDelay 0.32 vs 0.30). (Zoltraak)
26. **Per-layer slow motion**: TimeScale 0.65 / 0.85 on single impact layers. (Zoltraak)
27. **Random 3D ring tilt**: VelocityPerpendicular + Speed 0.002-0.005 + SpreadAngle 360 on rings (decay16 15269685466,
   17409991165). (Zoltraak; confirms the brief's example)

**Trails and projectiles**
28. **Corkscrew trail**: 4 Trails (life 0.2, width 1 -> 0, Br 15) at radius 2.6 on a part that flies 13 studs while
   spinning (Forge Part_RotSpeed 7 -> 0 rad/s, applied twice per frame by Forge, os-conventions 2.3). (Yaversu)
29. **Glitter thread**: 3 Trails overlaid (6091474388, 6091329339, 5320412027), width 0.225, life 2, LE1 Br9,
   TextureLength 3.75 Stretch. (bloody)
30. **Curved missile path (script)**: Bezier through 3 random midpoints, flight 0.65-0.95 s, impact at flight - 0.1,
   tint in 0.001 s out 0.25 s, light Range 0 -> 15 while Brightness 2.5 -> 0. (bloody)
31. **Area tint sprite**: one 75-stud soft dot, Transparency 0.55, LE 0 Br 1, life 1.7-2, plus a 68-stud LE 1 Br 2
   flash for 0.05 s. (bloody)

---------------------------------------------------------------------------------------------------------------

## e. Mistakes and weak spots (avoid)
- **No dedicated white core layer** in 6 of 7: the base colour is pink (Prototype), gold (Light Jewel), violet
  (purple) or red (bloody). White appears only by overlap (Prototype centre, purple's densest smoke) or by dark colour x
  Brightness (Zoltraak), so it comes and goes with the view. Add a thin LE 1 white core line.
- **One hue for most layers** (purple 19/31 at #754FFF, 17 of them LE 0 Br 12; Light Jewel 14/14 at #FFBD3A): saturated
  but flat; no value steps. Keep the three tones (PATTERNS 1).
- **Particle-only lasers have no solid line** (Zoltraak): the streak column reads as a beam only for ~0.1-0.35 s,
  then as sparkles; add one continuous Beam for the line.
- **Payoff missing**: Blue Beam charges for 19 s at 712 particles/s and its beams are disabled templates. A charge must
  end in a fire within ~0.3-1 s.
- **Cost**: Prototype ~46 Beams + ~660 particles/s for 4 s; Zoltraak 568 particles x 6 shots; Light Jewel 327 for a 1-s
  accent; bloody 150 sparks from 6 near-identical layers. Mobile Rate cap is ~100/s (PATTERNS pitfalls).
- **Near-invisible layers**: Transparency_Scale 1.7 on Yaversu's Beam101 copies (densest 0.745: faint grey arcs only).
  Very high Transparency can still read when Brightness is high (technique 20c), so judge faint layers in a capture,
  not by their numbers.
- **World-space Acceleration** on beam-aligned layers (Prototype specks): breaks as soon as the beam aims elsewhere.
- **Meaningless values**: EmitDelay -0.5 (Light Jewel), black Beams at LE 1 (library 126 designs), a texture id with
  no thumbnail (14687560696), off-theme debris (green leaves in a purple kick).
- **Giant sprites drive framing and wash the screen**: 70-stud flash (Zoltraak: Seen whiting out a third of the view at
  0.03), 75-stud tint (bloody), the 15-wide drill cone's first frames (Yaversu: purple veils over the whole view). Size
  flashes to 5-10 W at most and keep them under 0.12 s.
- **Framing decides whether a beam reads**: from far down its axis (first capture) the Prototype was a small tangle; in
  a close perspective view along the axis (recapture) it reads as a fan of streaks converging on the muzzle. Frame
  lasers side-on or in close along-axis perspective, never far end-on.

---------------------------------------------------------------------------------------------------------------

## Revision 2026-11-14 (recaptured sheets)
- Prototype: 0.03 is empty (not a ring arc); the centre reads near-white by additive overlap (was "no white
  anywhere"); 1.20 turns red (likely a big LE -1 ring at the camera); Neon meshes still never render (unclear).
- Yaversu: the 0.03 peak is the drill cone's wide purple veils, not smear streaks; the cone is the dominant layer at
  fire (was "almost invisible").
- Zoltraak: impact orb and streak column now Seen; the 0.03 flash whites out a third of the view; sigil fades in
  0.20, full 0.35-0.80.
- Blue Beam: black crackle copy, grey cone wedges, ground ring, tall pillars, flare and smoke puffs now Seen.
- Light Jewel: 0.03 empty, base flash at 0.10, a narrow rising column (whole effect visible).
- purple: 0.03 lavender-white core and half-view haze (98% layers can read at high Brightness).
- Recipe: sigil fade-in moved later; header comment on white core corrected.
