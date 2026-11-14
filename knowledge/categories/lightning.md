---
title: Lightning and electric VFX - lessons from 7 open-source effects
source: open-source VFX library (Discord packs) studied 2026-11-13
tags: [vfx, lightning, electric, bolts, particles, beams, roblox, os-library, flicker, drag, three-tone, light-emission]
---

# Lightning / electric: what 7 open-source effects teach

Evidence: freeze-frame stills from the Edit-mode replayer (recapture 2026-11-14:
`gallery/effects/lightning/<id>.jpg`), the layer tables
(`library/cards/<category>/<id>.md`), the raw dumps (the decoded pack files (`kit/scripts/rbxdump.py`), read for exact Size/Transparency/Squash/Color curves, Rate,
Enabled, TimeScale and part sizes) and, as text only, the scripts of `lightningburst.rbxl` and `lightningos.rbxl`.
Studio was not used. "Inferred" = my reading, not measured. **R** = the effect's radius in studs (estimated from the
emitter part / beam ring / ground ring), so sizes can be compared across scales.

What the replay misses (said again per effect): THUNDER's sequencing lived in server Scripts that could not be
decompiled (the replay fires its Init/Impact/Hit/Final/End/After stages all at t=0); Debris30 was a thrown debris chunk
(no motion in the replay); lightningburst's actual bolts are scripted Neon parts (not in the emitter set); TimeScale
values below 1 are kept by the replayer but not printed in the layer tables.

**Recapture (2026-11-14):** the first capture placed `69f2a565d257`, `af00e114ff57`, `7363005673d2`, `288977e54391`
and `7a7a6d0cb951` too low (layers under the floor) and framed some too wide. The recapture places each effect by its
emitters on the floor with a measured camera; all phase readings below come from it (one effect is still floor-limited:
the pillar's beams hang below its burst, see there). In the recapture the 0.03 s frame of THUNDER and lightningos is
empty (THUNDER's static props are missing too), so their first frame looks earlier than the first emit; what the first
capture showed there is kept and marked "(first capture only)".

Library context (2,041 emitter layers named lightning/bolt/electric/zap/thunder/volt in `catalog/effects.jsonl`):
Brightness median 10 (p75 15, p90 35); LightEmission median 0, 54% at <= 0 and 22% negative; Lifetime median 0.3 s
(p25 0.15, p75 0.6); max Speed median 141 (p90 1,179); Drag median 1 (p90 15); 82% Grid4x4, 76% OneShot; 48% constant
Size; EmitCount median 2; VelocityParallel layers use Rotation +-90 (264) far more than 0 (59). So "lightning = additive
LE 1" is only half the story: half of all bolt layers are normal-blend or darkening.

## a. The 7 effects

### `7363005673d2` LightingPillar :: Main/Lightning (2026 part 2) - magenta lightning pillar, sustained 3.4 s, R ~12, the best here

- **What:** a column of 48 beams on an 11-stud ring with a crackling magenta burst on top; everything runs 3.4 s
  (`EmitDuration` 3.4, beams on 3.4 s), then wisps. Emitter part 24 x 0.9 x 24. The beams hang DOWN 158 studs from the
  burst's attachment (Rotation X 90 sends their local +Z to world -Y; part at y 110 + attachment 47.7 = burst ~158 up,
  beam ends at ~0): the burst is the sky end of the pillar, the ground hit is the separate `Roar`/`Debris` parts.
- **Phases (recapture):** 0.03 and 0.10 a frame-wide burst, near-white core with lilac rays (Br 25 burns #B866E1 to
  white, colour only on the fringes); 0.20-0.35 small crackle with faint flat rings on the floor; 0.55 medium; re-flares
  as big as the first at 0.8, 1.2 (one long diagonal spike) and 2.6 (with jagged bolts flying out); 1.8 small;
  3.6 only faint grey ring wisps; ends ~4.4 s (data: everything stops at 3.4 s, longest lifetime 1.04 s). The beam
  column is not in the recapture (it hangs under the floor-placed burst); the first capture showed its top ~25 studs
  as a pink, vertically streaked column from 0.03 to 2.6 s.
- **Layer roles:** flash = `Impact` 16151520120 (LE 0.5, Br 25, swell 0->151 studs @0.65 ->0, life 0.04-0.125, 25 then
  Rate 30); bolts = `Lightning1/2/3` 13622252312 / 15958832214 / 15958823639 (LE 1, Br 25, Speed 2-2136 / 0.8-785,
  Drag 62.2, Spread 95, VelocityParallel, Rotation -90, Squash 1-2, 25 then Rate 30-50, ZOffset 38.7-39.8); radial
  streak card = `Shockwave2` 12043778355 (LE 0, Br 10, ease-out 0->21.3, 0.08-0.29 s, 15); energy rings =
  136391706912472 / 16503876723 (Br 15, ease-out 0->70, 0.125-0.29 s, 3 each); falling streaks = 126562784871818 /
  112818889917832 (Speed 350-850, Drag 10, EmissionDirection Bottom, Size 15->30 / 10->20, Squash 0.34->1.5, Rate 25
  for 2 s); linger wisps = `Crescents3` 14881109059 (white, LE 0.25, Br 1, 0->75.6, life 0.125-1.04, RotSpeed -420..-120,
  Transparency 1->0.35@0.15->1) and wind ring 15094930910 (0->98, never above 15% opacity); pillar body = 8 groups of 6
  beams, 158 studs long: 8415143764 `Lines` (LE 1, Br 6.5, width 40), 16452993902 (LE 0-0.2, Br 8-11, width 30-32),
  14872650955 (LE 0, Br 9, width 30), 16442602412 x2 (LE 0, Br 11, width 60); TextureMode Static, TextureSpeed 3-10.
- **Techniques:** (1) flicker baked into each bolt's Size and Transparency sequences (section d.1); (2) Speed range
  x1000 with Drag 62 scatters bolts at every radius from one point; (3) ONE colour ramp on all 59 layers
  (#35004F -> #B866E1 @0.48 -> #55007F @0.82): every particle starts near-black, peaks lilac mid-life, ends deep purple,
  so each particle carries all three tones and the stack reads as one designed thing; (4) the pillar body is mostly
  normal-blend beams (LE 0, Br 8-11 = solid saturated magenta) with one additive `Lines` layer.
- **Weak:** the 151-stud flash card is re-emitted at Rate 30 for 3.4 s, a white strobe far above the <= 3 flashes/s cap
  (the recapture shows frame-filling re-flares at 0.8, 1.2 and 2.6 s);
  0.35-2.6 s has no shape (same rates throughout); bolts at ZOffset ~39 draw over everything; `Lightning1` plays a
  Grid4x4 sheet (13622252312, indexed 4x4) as Grid8x8, so each frame shows a quarter cell (intended? unclear).

### `6bd2745beea6` LightingPillar :: Main/MainDebris3/Debris30 (2026 part 2) - storm cloud trailing a thrown debris chunk, 3.2 s, R ~6

- **What:** 12 emitters on an 11.7 x 3.5 x 5.9 part (Shape Disc, EmissionDirection Left, Speed -63 to -77 and
  Acceleration (68, 165-193, -168), LockedToPart): a dense violet cloud with lightning crawling inside. All emit 1 at
  t=0 then Rate 9-67/s for 3.2 s, lifetimes 0.5-0.76 s. The script that threw the chunk is not in the replay, so it
  sits still and reads as a blob.
- **Phases:** 0-0.2 fade-in (every Transparency starts at 1.0-1.5 and is lowest at 0.5 of life), 0.35 first readable
  cloud with sparks, 0.55-2.6 steady, emission stops 3.2, gone ~3.9 (both captures agree). In the recapture the cloud
  cards read as flat angular violet shards (their edges show) and the lightning inside only reads at 0.35-0.8 and 2.6.
- **Layer roles:** dark body = clouds 8187308218 (LE -0.5, Br 10.7, 12.7 studs), 105900768863906 (LE -0.9, Br 12.7,
  17.7), fog flipbook 89816655384560 (LE -0.7, Br 10.2, 15.9), `bg-clouds` 619393574 (LE -0.8, Br 12.7, 14.2), realistic
  clouds 14006773822 (LE -0.25, Br 14.4, 21.6); hot body = `Smoll` 87970239798298 (LE 1.11, Br 128, 24.8),
  87834277333031 (LE 2.0, Br 103, 18.5), 87160246794036 (LE 0.11, Br 128, 8.1), energy pulse 16511790647 (8x8, LE 1.11,
  Br 23, 8.1), specks 18450596124 (LE 1.11, Br 128, 4.0); electric = spark sheet 9732664178 (LE 0.32, Br 24.6, 10.5,
  VelocityParallel, Rotation 80, TimeScale 0.85) and "moving lightning" 13390196434 (LE 0.5, Br 32.7, 9.6, Grid4x4
  **Loop 26.5 fps, FlipbookStartRandom**, RotSpeed -8).
- **Techniques:** negative LE (-0.25 to -0.9) at Br 10-14 with violet colours = thick lit-from-inside smoke; colour
  strobe inside one life (spark sheet: #27100C @0 -> #2D1B2E @0.27 -> #8E4F98 @0.57 -> #27100C @0.82 -> #854B98 @1);
  Transparency 1.5 -> 0.5 @0.5 -> 1.5 @0.75 keeps a particle hidden for its first ~25% and last ~37% of life with soft
  ramps (values above 1 as margins; inferred to clamp).
- **Weak:** needs its motion; ZOffset 44-47 over everything; LE 1.11-2.0 and Br 103-128 are out of the documented
  range (LE > 1 is 0.3% of the library's 106k designs).

### `69f2a565d257` Voidstrike :: Lightning Retribution/handeff (2026 Mar-April) - hand spark charge, ~0.4 s, R ~1.5

- **What:** a burst in the palm (1 x 1 x 1 part) for the "Lightning Retribution" move: tiny blue bolts, dark blue
  masks, white shock rings and a flickering star. Everything 4 studs or smaller.
- **Phases (recapture):** 0.03 a white 4-point star flash with blue-tinted rays, about 4R across; 0.10 the star
  still white plus a blue electric shell around it (the dark masks with bright rims) and the first bolts; 0.20 the
  star is gone except a thin horizontal glint, blue bolts (dark bodies, bright edges) scattered over ~2-3R; 0.35 one
  small vertical white 4-point glint (inferred: the 14746170922 streak, whose colour ends white, at TimeScale 0.37 it
  lives ~0.38 s); 0.55 gone. Burst 0-0.4 s, as the data said.
- **Layer roles:** bolts = 17005480412 / 17005538321 / 14197133127 (#5185EC, Br 25, LE -2 / 0 / 0, 6 each, Size
  0 -> 0.46 by 10% of life -> 0.645, life 0.17-0.33, Speed 4.8-24, Drag 7.5-15, Spread 180 (one at 10),
  ShapeInOut InAndOut, OneShot flipbooks); dark masks = 16028033353 / 16218239465 (LE -2, Br 25, ease-out 0 -> 3.3 /
  4.2, life 0.4) and smoke 14754464270 (LE -2, Br 25, x7, 0 -> 2); white shock rings LE 0 Br 1 = 13478831328 (x4,
  0 -> 4.3, Transparency 0.4 -> 1), 13551207868 (x5, 0.23 -> 1), 12208186192 (x4, 0.75 -> 1); stars = 7160024951
  (blue, LE 1, Br 10, size flicker; white copy Br 12, TimeScale 0.65, swells to 9) and 1084970835 (#FDEAE8, Br 1);
  streak 14746170922 (LE 1, LightInfluence 0.15, Br 5, Color #151515 -> #484848 -> white, VelocityParallel Speed 13.2,
  Drag 6, Size/Squash/Transparency all flickering, TimeScale 0.37); swirl 14505776454 (grey, RotSpeed 400, TimeScale 0.7).
- **Techniques:** body AND ink from one colour (#5185EC at LE -2 Br 25 for the bolts and the dark masks); star size
  flicker 2.55 / 3.85 / 1.95 / 3.85 / 0.99 / 3.85 / 0 at 0 / 0.13 / 0.17 / 0.25 / 0.33 / 0.41 / 1 of a 0.15-s life;
  grow-fast-then-hold bolt size (72% at 10% of life); shock rings that are never fully opaque (start 0.23-0.75);
  a white end-of-life glint (a dark streak whose Color ramps to white at the end) as a last beat after the bolts.
- **Weak:** small (<= 4 studs by the data): it reads well framed close, but will be tiny at gameplay distance; the
  white core is only the first ~0.15 s, the bolts after it are dark blue held up by thin bright rims.

### `288977e54391` AnemoiaAndLighting :: Anemoia (2026 part 2) - NOT lightning: a character aura showcase

- **What:** a looping character look (sword, blood flipbooks, a red heart icon, a chrome title billboard). "Lighting"
  in the file name is the bundled Lighting preset, not lightning: Bloom Intensity 0.35, Size 56, Threshold 0.8;
  ColorCorrection Contrast 0.125, Saturation 0.125; DepthOfField FarIntensity 1, FocusDistance 150; Atmosphere
  Density 0.3. All 85 emitters run at a Rate (no bursts); 41 beams on the limbs.
- **Phases (recapture):** 0.03 black specks all over the body (`X`, 100 black dots, life 0.05) and the red blood
  starts; from 0.10 the limbs show white streaky "energy skin" (the limb beams); from 0.1-0.2 a white ground sigil
  (rings, rays, bright star centre) grows on the floor beside the dummy and keeps turning to 3.6; blood clouds grow
  0.2-0.55 and loop; the heart icon appears ~0.55. (The first capture's "arms flash white at 0.03" was not seen again.)
- **Ground sigil:** `HumanoidRootPart/Floor` carries flat (VelocityPerpendicular) layers: `Slash`/`Slash2`/`Detail3`
  (114561803327224, 124988722463420, 102251252675953, 85042237818479; LE 1, Br 44-555, RotSpeed 55-65), `Middle ring`
  71129968102374 (#FF557F, Br 444, RotSpeed 150-250), `Spec 1` 136503879190164 (Br 100), `Ray4` 74542037738289,
  galaxy ring 109574326366882, `crack` 97120619633686, over a dark `Contrast` 448862775 (LE -3, Br 0.2) underlay.
  Colour #5555FF at Br 44-555 renders white with only a faint tint (inferred from the frames).
- **Electric-relevant layers:** crackle specks clinging to head and limbs: `Floating Animated Spec` 15441262724 (8x8,
  Rate 1998, life 0.045, Size 0.23 -> 0.18, **TimeScale 0.04**), `Fireflies 2` 87790026409442 (8x8, Rate 198, Br 55,
  0.83, TimeScale 0.06), `ember sparks 4x4` 102585449614606 (Rate 400, Br 55, TimeScale 0.04), `Weird Energy Line`
  17635385037 (4x4, LE 0, Br 10, Rate 60, TimeScale 0.04); limb "energy skin" = per limb face 3-4 beams of width 1 and
  2.58 studs running down the arm: `Lines` 133678734873639 (LE 1, Br 44), sci-fi grid 110811012355416 (LE 1, Br 10),
  `Beam17.2` 92670131784607 (LE 0-1, Br 33), 99418129568765 (LE 0, Br 13), TextureSpeed 0.2-3; sword Highlight
  (FillTransparency 1, white outline at 0.4).
- **Techniques:** TimeScale 0.04-0.07 on 0.045-s specks = 15-25x slow motion: each speck lives ~0.7-1.1 s on screen
  and the 50-fps flipbook crawls (inferred: TimeScale also slows emission, so Rate 1998 is ~80/s effective); extreme
  negative LE on tiny layers makes hard black specks (`X` 5234388158 #000000 Br 0 x100; `Dark` 448862775 LE -6;
  136372760088216 LE -100 Br 50; `Dots` 130665832047450 LE -44 Br 144; eye leak 2807298556 LE -555).
- **Weak (for us):** no burst structure, 126 emitters/beams for an idle look, red blood (rating risk).

### `5b3db2b419f7` lightningburst :: ReplicatedStorage/Assets/Debris (190 OS) - end-of-beam ground burst, ~2.5 s

- **What:** the debris burst 75 studs ahead of a "lightning ki blast"; the script fires every emitter once with
  `:Emit(EmitCount)`. The emitter part is a 159 x 1.35 x 25 strip, so the burst spreads along the beam's path. 28
  emitters = 9 layers x 3 colour copies: blue #90BCFF, gold #FFE5A4, and white/grey (several of those at Br 0-0.05).
  No lightning texture: the bolts come from a script (below).
- **Phases:** 0.03 small rings (the first capture also showed white stick sparks here; the 2-frame sticks end at
  0.033 s, so they sit on the frame edge); 0.10-0.35 big flat spinning arcs and rings (30-60 studs) with round
  glowing specks; 0.55-0.8 smoke puffs and hanging specks; 1.2-1.8 only specks; empty by 2.6 (both captures agree).
- **Layer roles:** stick pop = `dotsburst` 1084982817 (LE 0, Br 2.09, Size 5.27 -> 0.04 by 5% of a 0.65-s life, Squash
  -3, VelocityParallel, Speed 1-20, Drag 6.5, Spread 50, x25) and `dots1` (Size 0.04, Squash -3 -> 0.07 @0.62); spinning
  arcs = `wind4` 1084996536 (arc on black, LE 1, LightInfluence 0.55, Br 5, Size 4.5 -> 40, life 0.15-0.3, Speed 12-42,
  Spread 15, RotSpeed 700-1500, x15); wind sheets 10149702982 (0 -> 59 in 0.1-0.25 s, x2), 14049010990 (0 -> 45, life
  0.9-1.5, RotSpeed 50-150, x9), 14370150460 (0 -> 32, life 0.2-1.5, RotSpeed 100-400, x10); rings `shockwave`
  15733547086 (0 -> 28, 0.75 s), `ray` 15733628490 (0 -> 33.7, 1 s), `Shockwave2` 14080556170 (1.7 -> 31, 0.4-0.5 s,
  never above 8% opacity); smoke 14511315116 (LE 0, Br 2-5, 0 -> 15, life 0.25-1.25, rises with Acceleration 15, x15);
  linger = `Specs` 8414194072 (off-centre dot, LE 1, Br 7, Size 3.81 -> 0, life 1-3, Speed 1-250, Drag 20, Rotation
  and RotSpeed +-360, x25 per colour).
- **Script (text read):** at the blast a ColorCorrectionEffect tweens to Saturation -1, Brightness -1, Contrast 6 in
  0.05 s and back after 0.1 s (a black impact frame), CameraShaker `Explosion` x3, and 25 pairs of procedural bolts
  (Neon cylinder parts, 15 per bolt, blue #93BCFF + yellow #FAFF9E, Thickness 1-3, MaxRadius 20, CurveSize +-40,
  PulseSpeed 50, PulseLength 0.5 -> each bolt lives (0.5+1)/50 = 0.03 s) spawned 0.01 s apart; during the 7-s charge,
  bolt pairs every 0.05 s, Thickness 0.45, MaxRadius 2.5-7.5, PulseLength 0.7-1 at the default PulseSpeed 10 ->
  0.17-0.2 s each, 9-14 studs tall around the character.
- **Weak:** a third of the layers are dark-weight (Br 0-0.05 copies); no dark layer, so the stills are faint wisps;
  the 159-stud strip thins the density.

### `af00e114ff57` iso_textures :: Workspace/THUNDER (190 OS) - storm lightning strike, ~4 s with crater, R ~27

- **What:** a ground strike from a cloud: charge glow, bolt cards, two strike tiers (`Hit`, then a 1.5x scaled
  `Final`), ground dust, smoke, scorch crater. Its control scripts are server Scripts that the dump could not
  decompile, so the stage order is lost; the replay fires every stage at t=0. The 3 bolt beams start Enabled = false
  and never show. Static props sit still from 0.1 to 3.6 s: crumpled white decal-on-cylinder shapes and a magenta
  spiked crown (part `Impact`, SpecialMesh 17700114556 with negative Scale, decal Color3 (8.16, 0.59, 10) = HDR
  magenta), which the scripts would have animated.
- **Phases (recapture):** 0.03 empty (the props are missing too: frame before the first emit, unclear); 0.10-0.20 a
  bright white bloom cloud with a glow column rising above it (the tail of the 110-stud flash and the 85-stud glow;
  their peak falls between the 0.03 and 0.10 frames); 0.20-0.35 grey smoke puffs and a flat dust ring spreading left;
  0.55-0.8 white smoke; 1.2 fading; 1.8-3.6 only the static props. The first capture showed a full white-out with
  radial spikes and visible square card edges at 0.03 (first capture only) and a dark crater ring 1.2-3.6; the
  crater (LE 0, Br 0, #41464F -> black) does not read on the recapture's dark floor.
- **Layer roles:** flash = 17726059714 (LE 1, Br 15, Size 110 -> 0 in 0.133 s, Color #D2E3FF -> black, x1
  FacingCamera + x2 flat, ZOffset 3) and glow 17725406680 (LE 1, Br 3, Size 85 constant, Squash -0.5, life 0.5,
  Transparency 0 -> 1 linear); bolt cards = 17736470192 (LE 1, Br 1, Size 45 and 25, life 0.1, Squash 0.5,
  VelocityParallel, Rotation 90, x6 at 30.5 studs up and x6 at the ground); streaks = 17726149753 (LE 1, Br 5,
  22 -> 0, life 0.21, Speed 950, Drag 39.3, Spread 180, Rotation -90, Squash 0.5, x7), 17736554683 (22.5 held to 0.5
  of life then -> 0, life 0.1-0.2, Speed 506, Drag 15, x5), 17736780089 (Br 15, 0 -> 22.5, Speed 37-225, Drag 5,
  Squash 0 -> 1, x4); ground discs 17725961956 + 17725945834 (LE 1) + 17725958788 (LE 0), all 54.9 studs, 0.53 s,
  Color -> black; lit/dark pair 17726162654 (LE 1, Br 15, #FFEFEF -> #D4E4FF -> black) + 17726176892 (LE 0, Br 15,
  #D2E3FF -> #3A3F47 -> black), both 15 -> 55, life 0.21-0.74; cooling debris 17726049367 (LE 0, Br 5, #FFFFFF ->
  #31353B @0.4 -> black, Speed 285, Drag 18.9, flat, x5); dust 17723265554 (LE 0, LI 0.5, grey, 12 -> 32, Speed
  240-300, Drag 10); rising glow 17736991392 (LE 1, Br 1.5, 5 -> 45, Speed 25, Drag 2, 2 s); smoke 17737018860 (LE 0,
  15 -> 25, 2 s, #D1E2FF -> #1D1F23); crater 17745162015 (LE 0, Br 0, 37.5, 4 s, #41464F -> black) with 17745060341
  (2 s) and 17745013709 (LE -1, 1 s).
- **Techniques:** fade by Color -> black instead of Transparency on almost every layer (Transparency flat 0): on LE 1
  layers that is a fade-out, on LE 0 layers a cool-down to ink; lit/dark twins of the same size and timing; strike
  tiers as a scaled copy (sizes 36.6 -> 54.9, speeds 633 -> 950); flipbooks carry the fade (dust keeps
  Transparency 0 to the end; the OneShot sheet's last frames are empty).
- **Weak:** the stacked Br 15 additive cards white out the frame and their square edges show (first capture only);
  no dark layer separates the white frames; the pure-dark crater is invisible on a dark floor (recapture); all
  timing in unrecoverable scripts.

### `7a7a6d0cb951` lightningos :: Workspace/Character (190 OS) - toon lightning landing on a dummy, R ~5

- **What:** a 9.4 x 5 x 9 emitter part (Shape Disc) on a dummy: a black ink frame, cartoon blue bolts, a dark-blue
  ground swirl and wind crescents, a delayed shard beat and a 5-s stream of light spikes. (The demo's script clones a
  different model, `Bolt`, at the dummy and at 10 points of a 100-stud diamond with 0 / 0.8 / 1.6 s random delays;
  `Bolt` rains and crackles in the cloud for 1.2 s and strikes the ground at `EmitDelay` 1.2.)
- **Phases (recapture):** 0.03 empty, only the dummy (see the header note; the first capture showed here a black
  ink disc hiding the dummy plus the first bolts: first capture only); 0.10 peak: big cartoon bolts 1-2R long, blue
  with white inner edges, and the first spikes; 0.20-0.80 wide dark-blue crescents spread to ~4R on the floor and fade
  by 1.2; from 0.35 a bright blue swirl turns at the dummy's feet and keeps going to 3.6 (Rate 4 for 7 s); 0.8 small
  bright shard bits beside the swirl (the 0.7-s second beat); light spikes stand around the dummy the whole time.
- **Layer roles:** ink frame = `lines` 18751910490 (Color #000000, LE -1, Br 1, Size 5, Squash -0.3, life 0.05,
  FacingCameraWorldUp, Grid4x4 Loop 35 fps, Transparency 0.575 -> 0.84 @0.56 -> 1, **x500**); bolts = 4 toon sheets
  98016283117283 / 98371801305515 / 128704617763218 / 88209568981749 x 2 colours (#0329FF and #375CFF / #3964FF), all
  LE 0, Br 15, Size 5 constant, life 0.1-0.3, Grid4x4 OneShot, 1 particle each, Disc surface, FacingCamera or
  VelocityParallel (Rotation -50 / 90 / random); swirl = `Main swirl body` 18584658493 x2 (LE 1 Br 15 #2C6FFF and
  LE 0 Br 4 #3964FF, Size 10 -> 0, RotSpeed 500, life 1, Rate 4 for 7 s); crescents = 17085222506 / 14152783729 /
  106488490711262 (#3964FF, LE 1, Br 3, 0 -> 10.6 @0.34 -> 21.3, life 0.2-1.2, RotSpeed 200, Drag 3-9, x7 each);
  shards 10439119562 (LE 0, Br 5, #3D7AFF, 0 -> 1.06 @0.55 -> 0, Speed 15-55, Drag 5, VelocityParallel, x20 at
  **EmitDelay 0.7**); spikes = `FingerHit` 14080708584 twin (LE 1 Br 35 #2554FF + LE -1 Br 5 #3964FF, Size 2, life
  0.07, Speed 25-75, Squash -1.39 -> -2.77, Rate 35 for 5 s); haze = `Glow` 12159555294 (#0011FF, LE 1, Br 0.2,
  Size 20, life 3, opacity 13% -> 0 by 0.61, x7); floor dust 14291927024 (LE 0.8, Br 0.2, 0 -> 9.75, x35).
- **Techniques:** a particle black frame (local, no ColorCorrection; seen in the first capture only); solid toon bolts
  (LE 0, Br 15) in two blues that read clearly thanks to the sheets' light inner edges; bright/dark twins of the spike
  sprite (LE +1 / -1); a delayed second beat at 0.7 s.
- **Weak:** the darkest layers (#0011FF haze, dark crescents) barely separate from the navy floor; the spikes and
  the feet swirl run 5-7 s after a ~1-s beat; some emitters carry `EmitCount` 0 (`lighting vfx 2/3`, `SparkFlip`)
  and never fire in the burst.

## b. Anatomy of a lightning / electric effect (firing order)

Sizes are Roblox particle Size (card edge, studs) and given as multiples of R. "Burst" values come from pillar /
THUNDER / lightningos / handeff / lightningburst; "sustained" ones from pillar / Debris30.

| # | Role | Textures seen (role) | LE / LI / Br | Lifetime | Size curve, peak vs R | Transparency | Speed / Drag / Spread | Orientation, Squash, flipbook | Count, ZOffset |
|---|---|---|---|---|---|---|---|---|---|
| 0 | Ink frame (optional; lightningos, first capture only) | 18751910490 (lines sheet), Color #000000 | LE -1, LI 0, Br 1 | 0.05 | const ~1R (5 for R 5) | 0.575 -> 0.84 -> 1 | ~0 | FacingCameraWorldUp, Squash -0.3, 4x4 Loop 35 fps | 500 over a Disc, z 1 |
| 1 | Flash (white core) | starburst 16151520120; 17726059714; 4-point stars 7160024951, 1084970835 | LE 0.5-1, Br 10-25 (Br 1 on the plain star) | 0.04-0.15 | swell 0 -> peak @0.65 -> 0, or shrink peak -> 0, or flicker; 4-12R (151 for R 12, 110 for R 27, 9 for R 1.5) | flat 0 (fade by size or Color -> black) | 0-0.2; flat cards: VelocityPerpendicular + Spread 50-360 | FacingCamera or flat; Squash 0-0.4 | 1-3 (pillar 25 + Rate 30: too many), z 3-14 |
| 2 | Glow / bloom card | 17725406680, 12159555294 | LE 1, Br 0.2-3 | 0.5 (3 s for haze) | const 3R (85) / 4R (20 for R 5); Squash -0.5 = wide | 0 -> 1 linear, or start 0.87 | 0 | FacingCamera | 1-7, z 3-5 |
| 3 | Bolts | 13622252312, 15958832214, 15958823639, 17736470192, toon 98016283117283 / 98371801305515 / 128704617763218 / 88209568981749, 11862032588, 17005480412 / 17005538321 / 14197133127, 9732664178, 13390196434 | additive LE 1 Br 1-25, or solid LE 0 / -1 / -2 Br 15-25 | 0.067-0.4 (median ~0.2) | const, grow-fast-hold (72% at 10%), or a flicker curve; 1-2R (spikes to 5.7R for one key) | flat 0, or 1/0 toggles | placed (0.01-0.2) or scattered (2-2136, Drag 62, Spread 95-180) | VelocityParallel Rotation +-90 Squash 1-2, or FacingCamera; Grid4x4 OneShot | 1 per emitter x 4-8 emitters, or 6-25; z 1-40 |
| 4 | Streak sparks | 17726149753, 17736554683, 17736780089, 126562784871818, 14080708584, 1084982817, 10439119562 | LE 1 Br 4-35 (+ dark twin LE 0/-1 Br 0-5) | 0.07-0.25 | shrink 0.8R -> 0, or hold to 0.5 then -> 0 | flat 0 | 300-1000 (to 2136), Drag 10-62, stop ~ Speed/Drag = 15-35 studs (~1R); Spread 90-180 | VelocityParallel: Rotation +-90 + Squash 0.5-1.5, or Rotation 0 + Squash -1.4..-3 | 5-25, z 0-3 |
| 5 | Shock ring / radial card | 12043778355 (radial streaks), 13478831328 / 12208186192 / 15094930910 (rings), 16028033353, 15733547086, 15733628490, 14080556170, 17725961956 | LE 0-1, Br 1-15 (lower when big) | 0.08-0.75 | ease-out grow 0 -> 2-6R (80% of size by ~35% of life) | in by 0.1, out from 0.5; rings often never opaque (min 0.23-0.92) | 0.0004-0.04, Spread 20-50 (mostly flat) or 360 (any tilt) | VelocityPerpendicular; Squash 1 on the radial card | 1-15, z 0-6 |
| 6 | Spin arcs / crescents / swirl | 1084996536 (arc on black), 17085222506, 14152783729, 106488490711262, 18584658493, 14881109059, 14049010990, 14370150460 | LE 0.1-1, Br 1-15 | 0.15-1.5 | grow 0 -> 3-6R | min 0.35-0.88 (faint) | 0.001-42, Drag 3-9, Spread 15-25 | VelocityPerpendicular, RotSpeed 50-1500 | 5-15, z 0-3 |
| 7 | Dots / specks | 8414194072 (off-centre dot), 1084982817, 18450596124, 15441262724, 87790026409442, 102585449614606 | LE 0-1, Br 2-55 | 0.045-3 | 0.04-4 studs, shrink | flat 0 | 1-250, Drag 6.5-20 | FacingCamera / VelocityParallel | 20-100 |
| 8 | Smoke / dust (ink) | 14511315116, 14006773822, 619393574, 8187308218, 89816655384560, 14754464270, 17723265554, 17737018860, 14291927024 | LE -0.9..0 (floor dust LE 0.8 Br 0.2), Br 1-14 | 0.25-2.3 | 1-4R, grow | fade in to 0.4-0.6, out | 15-300, Drag 3-12, rise 4-15 | FacingCamera, 4x4 OneShot | 7-35 |
| 9 | Linger | crater 17745162015 / 17745060341 / 17745013709; Specs 8414194072; Crescents3 14881109059; Glow 12159555294; ground sigil (Anemoia `Floor`) | crater LE 0 Br 0 (pure dark: unreadable on a dark floor), LE -1; specks LE 1 Br 7 | 1-4 | crater const ~1.4R | 0 -> 1 linear | 0 (crater), specks shoot out and stop | flat crater | 1-25 |
| 10 | Sustained body | beams (pillar 48, THUNDER 3); cloud emitters | beams LE 0 Br 8-11 + one LE 1 Br 6.5; cloud LE -0.9..2 | EmitDuration 2-7 s, Rate 4-67/s | beams width 30-60 on an 11-stud ring | beams: along length 1 -> 0 @0.25 ... 0 @0.75 -> 1 | - | beams Static texture, TextureSpeed 3-10 | - |

Colour: one hue family per effect, shifted by age inside each particle (dark -> bright -> deep, pillar) or by layer
(white flash, saturated bolts, near-black smoke and crater). Complementary second hue in lightningburst (blue + gold).

## c. Timing

| Phase | Start (s) | Length (s) | Seen in | Spread |
|---|---|---|---|---|
| Wind-up (optional) | -1.2 to 0 | 0.4-7 | `Bolt` model (rain + cloud bolts 1.2 s), lightningburst charge (7 s of 0.2-s bolts every 0.05 s) | script-driven |
| Ink / black frame | 0 | 0.05 (particles) or 0.05 + 0.1 (ColorCorrection) | lightningos (first capture only), lightningburst script | 2 of 7 |
| Flash | 0 | 0.04-0.15 | pillar, THUNDER, handeff (recapture: handeff star white 0.03-0.10, pillar burst frame-wide at 0.03-0.10, THUNDER bloom tail at 0.10-0.20) | flash cards never outlive 0.15 s |
| Bolts | 0 (re-strikes to 0.3) | 0.067-0.4 per particle; procedural bolts 0.03-0.2 | all but Anemoia / burst-debris | median ~0.2 s |
| Streak sparks | 0 | 0.07-0.25 | THUNDER, pillar, lightningburst, lightningos | |
| Rings / radial cards | 0-0.05 | 0.08-0.75 | every burst | |
| Arcs / crescents / swirl | 0-0.1 | 0.15-1.5 | lightningos, lightningburst, pillar | |
| Second beat | 0.35-0.7 | 0.1-0.4 | lightningos shards (seen at 0.8), handeff white end glint (0.35) | 2 of 7 |
| Smoke / dust | 0-0.1 | 0.25-2.3 | THUNDER, lightningburst, Debris30, lightningos | |
| Linger | - | 1-4 | THUNDER crater 2-4 s, lightningburst specks 1-3 s, pillar wisps <= 1.04 s | |
| Sustain | 0 | EmitDuration 2-7 at Rate 4-67/s per layer | pillar 3.4 (full-size re-flares at 0.8, 1.2, 2.6), Debris30 3.2, lightningos feet swirl 7 / spikes 5 | tail = longest Lifetime after the stop |

Burst totals: 0.4-0.55 s (hand), ~2.5 s (ground burst), ~4 s with a crater. The readable core (flash -> bolts ->
rings) is always over by 0.3-0.4 s; everything after is smoke, crescents and linger.

## d. Techniques catalogue (exact recipes)

1. **Flicker inside one particle (no script).** Pillar `Lightning1/2`: Size keys 0 @0, 6.7 @0.056, 67.8 @0.097
   (envelope 17), 8.4 @0.12, 6.7 @0.2, 16.3 @0.25, 2.6 @0.3, 2.9 @0.4, 8.8 @0.43, 0 @0.446, 50.2 @0.505, 15.9 @0.527,
   0 @0.548, 9.7 @0.578, 2.2 @0.657, 13.7 @0.741, 9.9 @0.8, 0 @0.824, 6.2 @0.878, 0 @1 (20 keys = the maximum) and
   Transparency 1 until 0.17, then 0 with 1-blips at 0.23, 0.446, 0.646, 0.748 and a fade 0.8 -> 1. With lifetimes
   0.067-0.4 s each bolt blinks 3-5 times and jumps in size. Handeff star: Size 2.55 / 3.85 / 1.95 / 3.85 / 0.99 /
   3.85 / 0 at 0 / 0.13 / 0.17 / 0.25 / 0.33 / 0.41 / 1 of 0.15 s; 14746170922 also flickers Squash (0, 1.8 @0.046,
   0.225 @0.055, -0.11 @0.33, 1.275 @0.5, -0.34 @0.57, -0.94 @1). Extends PATTERNS 5: a particle can live 0.3-0.4 s
   and still read as lightning if its curves blink.
2. **Radial scatter from one point:** Speed {2, 2136}, Drag 62.2, Spread 95 (pillar bolts) - each particle stops at
   about Speed/Drag (0.03-34 studs; vault rule of thumb, exact formula undocumented), so one emitter fills a ball.
   THUNDER streaks: Speed 950, Drag 39.3 (stop ~24 studs ~ 0.9R); 506 / 15 (~34). PATTERNS 2 had Drag 10-16; lightning
   goes to 39-62 (top 5% of the library: Drag > 20 in 5.3% of designs).
3. **Shared colour-by-age ramp:** every pillar layer uses #35004F -> #B866E1 @0.48 -> #55007F @0.82. On additive
   layers the dark start is a free fade-in; on normal-blend ones it is the ink. One ramp = one style key for 59 layers.
4. **Fade by Color -> black (THUNDER):** Transparency flat 0, Color X -> #000000. LE 1: clean fade-out with no grey
   halo. LE 0: white-hot -> ink cool-down (debris #FFFFFF -> #31353B @0.4 -> #000000; smoke #D1E2FF -> #1D1F23).
5. **Lit / dark twin:** same sprite, timing and size twice, one LE 1 Br 4-35 and one LE 0 or -1 Br 0-15:
   17726162654 / 17726176892 (THUNDER), `FingerHit` LE 1 Br 35 / LE -1 Br 5, `Main swirl body` LE 1 Br 15 / LE 0 Br 4,
   pillar `Roar` Sparks LE 1 Br 4 / SparksB LE 0 Br 0 and Shockwave2 LE 1 Br 3 / 2B LE 0.5 Br 0. The dark twin gives
   the bright one an edge.
6. **Solid (non-additive) bolts:** LE 0 with Br 15 and a saturated colour (#0329FF, #375CFF toon bolts) or LE -2 Br 25
   (#5185EC handeff): the hue survives bloom instead of washing to white. 54% of the library's bolt layers do this.
7. **Particle black frame:** 500 x Size 5 cards, #000000, LE -1, life 0.05, FacingCameraWorldUp, Transparency 0.575
   start, emitted over a Disc the size of the effect: a local ink flash that hides the character for 1-3 frames (seen
   in the first capture; the recapture's 0.03 frame is empty, so it is confirmed by the data, not twice by eye). The
   lightningburst script does the global version (ColorCorrection Saturation -1, Brightness -1, Contrast 6 in 0.05 s,
   back after 0.1 s); keep PATTERNS 3's photosensitivity limits for either.
8. **Beam ring pillar:** 8 attachment groups on an 11-stud ring, 6 flat beams each (FaceCamera false, width 30-60 so
   neighbours overlap into a tube), 158 studs long, TextureMode Static (texture does not stretch with length),
   TextureSpeed 3-10, Transparency along the length 1 -> 0 @0.25 ... 0 @0.75 -> 1 (soft ends), Color along the length
   dark -> lilac @0.48 -> deep; 5 of 6 beams LE 0 Br 8-11, one additive `Lines` 8415143764 at Br 6.5.
9. **One-elbow sky bolt (THUNDER):** Beam Segments 2, CurveSize0 -55, CurveSize1 -200, width 6.7-12.7 at the ground
   -> 15-25 at the sky, TextureMode Wrap, TextureLength 150-225, LE 1, Br 10, Transparency 0 at the ground -> 1 at the
   sky, Color #DDF3FF -> black; 3 such beams to points 93-163 studs up. The texture supplies the jaggedness.
10. **Procedural bolts (lightningburst `LightningBolt`):** Neon cylinder parts, 10-15 per bolt, noise re-evaluated every
   Heartbeat; lifetime = (PulseLength + 1) / PulseSpeed: 0.03 s for blast bolts (PulseSpeed 50, PulseLength 0.5,
   Thickness 1-3, MaxRadius 20, CurveSize +-40, a new pair every 0.01 s for 25 pairs), 0.17-0.2 s for charge bolts
   (Thickness 0.45, MaxRadius 2.5-7.5, a pair every 0.05 s). A parts alternative to PATTERNS 5's beam builder.
11. **Two-hue copies:** every layer twice, blue #90BCFF and gold #FFE5A4 (lightningburst); bolts blue #93BCFF + yellow
   #FAFF9E. Complementary pairs keep a blue effect from going monochrome.
12. **Transparency > 1 as hidden margins:** 1.5 -> 0.5 @0.5 -> 1.5 @0.75 (Debris30) shows the particle only ~0.25-0.63
   of its life with linear soft edges (inferred clamp at 1; the vault advises explicit 1-keys instead).
13. **Colour strobe in the ColorSequence:** dark @0, dark @0.27, bright @0.57, dark @0.82, bright @1 (Debris30 spark
   sheet) - a second flicker channel next to Size and Transparency.
14. **Continuous crackle sheet:** 13390196434, Grid4x4 **Loop** 26.5 fps + FlipbookStartRandom, life 0.6 s, RotSpeed -8
   (Debris30): bolts that keep crawling inside a cloud.
15. **TimeScale slow motion on specks:** 0.04-0.07 (Anemoia) turns 0.045-s, 50-fps flipbook specks into ~1-s
   crawling crackle; handeff uses 0.37-0.7 on single flickers. 145 bolt layers in the library run below 1 (mostly
   0.4-0.7). Our runtime overwrites TimeScale with the playback speed, so bake it into Lifetime and counts instead.
16. **VelocityParallel needles:** Rotation 0 + Squash -1.4 .. -3 makes a needle along the travel direction
   (`FingerHit` arrow 14080708584 emitted upward renders as vertical spikes; `dotsburst` disc 1084982817 at -3 renders
   as sticks along their motion); vertical streak art is instead rotated +-90 with Squash +0.5 .. 2 (pillar bolts,
   THUNDER streaks). Which texture axis VelocityParallel aligns and the exact Squash sign convention: unverified,
   check once in Studio (the vault says positive Squash stretches vertically).
17. **Two-frame stick:** Size 5.27 -> 0.04 by 5% of a 0.65-s life with Squash -3 (dotsburst): a stick that exists for
   ~2 frames, then a dot that drifts with Drag 6.5.
18. **Orbiting glints:** off-centre dot 8414194072, Rotation and RotSpeed +-360, Size 3.81 -> 0, life 1-3, Speed
   1-250, Drag 20: shoots out, stops dead, then circles and shrinks (the linger of lightningburst).
19. **Spinning flat arcs:** 1084996536 (on black: additive only), VelocityPerpendicular, Speed 12-42, Spread 15,
   RotSpeed 700-1500, Size 4.5 -> 40, life 0.15-0.3, Transparency 1 -> 0 @0.07 -> 0.42 @0.25 -> 0.82 @0.57 -> 1.
20. **Grow fast, then hold:** bolt Size 0 -> 72% by 10% of life -> 100% at the end (handeff) or ease-out keys
   (pillar rings: 19.4 @0.1, 32.9 @0.2, 50.8 @0.4, 61.6 @0.6, 70.1 @1). A pop without a scale-in.
21. **Strike tiers by scaled copy:** THUNDER `Final` = `Hit` with sizes and speeds x1.5 (36.6 -> 54.9, 633 -> 950).
22. **Flipbook-driven fade:** Transparency stays 0 to death while the OneShot sheet's last frames are blank (THUNDER
   dust and most of its layers). Free, but the effect then depends on flipbooks staying enabled (phones can drop them).
23. **Limb energy skin:** width-1 beams laid on each face of a limb with scrolling textures (TextureSpeed 0.2-3) and a
   Highlight outline (FillTransparency 1, outline 0.4) - a cheap "electrified body" look (Anemoia).
24. **Brightness burns the tint to the fringe:** pillar layers at Br 25 on #B866E1 render a white core with lilac
   rays only at the edges; Anemoia's floor sigil at Br 44-555 on #5555FF renders white. Choose Br for where the colour
   should survive: high Br = white centre, colour at the rim; Br 3-10 = colour all over (recapture, inferred).
25. **White end-of-life glint:** a streak whose Color ramps dark -> white over its life (handeff 14746170922:
   #151515 -> #484848 @0.24 -> #F7F7F7 @0.88 -> white, TimeScale 0.37 -> ~0.38 s) leaves one small white star after
   the bolts are gone, a quiet last beat (recapture, 0.35 s).
26. **Ground sigil under a character:** stacked flat emitters (VelocityPerpendicular) with off-centre slashes,
   rings and a star at Br 44-555, RotSpeed 55-250, over a dark LE -3 underlay (Anemoia `HumanoidRootPart/Floor`).

## e. Mistakes and weak spots (avoid)

- **Strobing flashes:** pillar `Impact` (151-stud card, LE 0.5 Br 25) at Rate 30/s for 3.4 s; THUNDER's three
  stacked white frames. Keep the flash to one burst per strike, <= 3 flashes/s (PATTERNS 3).
- **Sustain with no shape:** pillar 0.35-2.6 s and Debris30 at constant Rates look frozen; ramp Rate down (or step it)
  and add re-strike beats instead of a flat stream.
- **Visible card edges:** big additive cards at Br 15 show their square borders when they overlap at white-out
  (THUNDER, first capture); smoke cards with hard texture edges read as angular shards (Debris30, recapture). Use
  textures that reach black or transparent at the edge, lower Br for big cards.
- **Dark on dark:** the darkest layers (#0011FF haze, dark-blue crescents, THUNDER's Br 0 crater) vanish on a navy
  floor; the solid toon bolts survive only because their sheets have light inner edges. Every electric stack needs a
  near-white core layer (flash, hot bolt start, glints), and a crater needs a lighter rim or a light floor.
- **Dead weight:** layers at Br 0-0.05 (lightningburst white copies), beams at Br 0 (THUNDER godrays), emitters with
  `EmitCount` 0 that only scripts would fire (lightningos). They cost instances and confuse tuning.
- **Effect lives in scripts:** THUNDER (stage timing in server Scripts), Debris30 (thrown motion), lightningburst
  (the bolts themselves) do not reproduce from their emitters alone. Keep timing in data (EmitDelay or our spec).
- **Tails that outlast the beat:** lightningos spikes stream for 5 s and its feet swirl for 7 s after a ~1-s event.
- **ZOffset 38-47** forces bolts and clouds over characters and terrain from every angle.
- **Out-of-range values:** LE 1.11-2, LE -30 .. -555, Br 103-555, Transparency 1.5 work today but are undocumented;
  re-check after engine updates. LE > 1 is 0.3% of the library.
- **Flipbook grid mismatch:** a Grid4x4 sheet set to Grid8x8 shows quarter cells (pillar `Lightning1`); check the grid
  per texture.
- **Too small to read:** a 2-4 stud hand burst (handeff) reads well framed close (recapture) but needs a bigger flash
  or glow to register at gameplay distance.

## Corrections and extensions to PATTERNS.md

- PATTERNS 5 (bolts removed after 0.07-0.13 s): procedural bolts here live 0.03 s (blast) to 0.2 s (charge); particle
  bolts live 0.067-0.4 s but blink inside their life via Size/Transparency/Color curves (d.1, d.13).
- PATTERNS 2 (Drag 10-16 stops bursts dead): lightning uses Drag 39-62 with Speed ranges spanning 1000x for radial
  scatter (d.2).
- PATTERNS 1 (three tones): the dark tone often lives inside each particle (colour ramp from near-black, d.3; cool to
  black, d.4) or as an LE 0 / -1 twin (d.5), not only as a separate ink layer.
- New for PATTERNS 3: a particle-made black frame (d.7) is local to the effect, an alternative to the global
  ColorCorrection flip.
