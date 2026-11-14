---
title: "Open-source VFX study: miscellaneous (holy, light, character and other)"
source: "open-source VFX library (Discord packs) studied 2026-11-13"
tags: [vfx, roblox, particles, holy, light, aura, character, ink, brightness, open-source-study]
---

# Miscellaneous effects (holy, light, character, other): what 10 open-source effects teach

Evidence: freeze-frame sheets + layer tables in `gallery/effects/misc/` (repo root; layer tables: `kit/scripts/layer_table.py`)
(Edit-mode replayer, every script stripped; recaptured 2026-11-14 with placement and framing fixed: the first capture
had part of lamp2, Gravity, Gon, galaxy and Mochi FX under the stage floor). 295 ParticleEmitters, 4 Beams, 1 Trail
over 10 effects. This extends
`../PATTERNS.md`; it does not repeat it. **Seen** = visible in the stills; **Table** = read from the layer table;
**Script** = read from the effect's own (untrusted, not run) scripts; **Unclear** where neither settles it.

Group numbers (Table): 15/295 emitters (5%) have LightEmission < 0 (library 14%), 127 (43%) LE 0, 61 (21%)
0 < LE < 1, 92 (31%) LE 1. Median Brightness 5; 18 layers (6%) Brightness >= 50 (library 4.3%), up to 155. One effect
still renders nothing (Mochi Replicator, 10: emitters under a script); its notes come from the table and scripts. In the
recapture the 0.03 s still is empty for lamp2, Gravity and Mochi FX although their bursts fire at t = 0 (capture lag or
a real one-frame delay: Unclear), so read "peak at 0.10" as "frames 1-3".

## a. The ten effects

### 1. `174b4feeb18f` WrathPump lamp2 (Halloween boss: floating street lamp bursts into a warm glow), est. 1.19 s
- Phases (Seen, recapture): 0.03 empty; 0.10 white bloom with a pink-violet rim round the lamp head and upper post,
  ~0.5x the 24-stud lamp; 0.20-0.80 plateau, a blown-out white disc ~0.6x the lamp height (~14-16 studs, = the
  flare's 14.2) centred on the upper post, the post a dark silhouette through it; 0.10-0.80 a dim orange-brown flicker
  with black patches at the post's foot (~1/4 lamp height); 1.20 bloom shrinking up-left of the head, flicker gone,
  the post lit pale grey. Faint diagonal strokes at 0.80 are probably the 4 curved Beams. The figure-8 float of the lamp is
  a script (Heartbeat Motor6D offset), missing from the stills and irrelevant to the look.
- Layers (Table): bloom = `flare` 16511998441 (20 @0, colour #13100D, LE1 Br10, swell 0->14.2@0.5->0, Speed
  2.8-22.6, Drag 16.8, Squash -0.25); hot core = `fire` 11458438415 (Grid8x8, #130F0D, LE1 **Br150**, size 1.32) +
  `fire black` same texture LE **-2** Br5 size 1.45; soft halos at ~50% opacity = 130819656332431 (12.5 studs),
  105427977618886 (8), 123418029613465 (14), 92786624826011 (6), 12386392796 rays (4), all Transparency
  0.99 -> 0.47-0.52 at mid-life -> 0.99; 0.1 s flicker sprites 11597664950 / 14919880888 / 8073306083 (the last LE0 or
  LE-1 Br0 = black flecks); 4 Beams (Width 0->8, CurveSize -7/5, 50 segments, transparent ends, Br3-10).
- Works: dark colour x Brightness 10 = a white bloom with a warm-pink rim (see d1); every halo swells in and out
  (peak opacity at 44-50% of life), so nothing pops; drag 16.8 piles the 20 particles into one ball.
- Weak: 14 additive layers x 20 particles at Br 5-150 = a structureless white-out (the lamp head disappears, no inner
  shape); the dark layers are 4-10 studs against a 14-stud bloom, too small to cut it; the Br150 `fire` + LE -2 `fire
  black` pair, sitting at the foot, reads as a dim muddy flicker, not a hot core (d1).

### 2. `fea421530c94` Gravity/Pull ("ahhellnahbhhh"): purple gravity hit, est. 1.42 s (visible ~0.55 s)
- Phases (Seen): first capture 0.03 peak (a long magenta-white streak burst); recapture 0.03 empty, 0.10 peak:
  magenta-white streaks fanning out toward the camera with black streaks between them, grey swirl rings ~2x the core,
  a few flying purple shards; 0.20 grey swirl rings + white 4-point glint and violet sparks, grey smoke settling on
  the floor; 0.35 swirl fading, grey smoke clumps lying on the floor, wide translucent grey bands on the floor (the flat
  Water / wind layers, Unclear which); 0.55-0.80 faint floor smoke and bands; 1.2 gone.
- Layers (Table, all EMIT @0): flash = `Flash` 16874376111 + `FL` 16410508868 (1 each, VelocityParallel, Squash -2.2 /
  shrink 0->-1.4, size 0->8.7-10.4, Br25, life 0.31-0.36) with a black twin `Flash2` 17825526848 (LE0.1 Br11, life
  0.56, Squash 3->1.2); implosion = `FlashGreem`/`FlashWhite` 17627858096 + `FlashBlack` 17093828340 (Speed -126 /
  -34.6 on a Disc, size 22.4/17.6/16 -> 0, Squash 2-4); sparks = `Star` 17062454806 (15), `Sparks1` 7395118796 (12 @
  2.6-145, drag 19.2, life 0.1), `Shards` 17420819512 (spd 159, life 0.05), `BlackFireShard` 15687178002 (LE0,
  106-248, drag 15, life 0.07-0.1), `Fire1` 14005903992 (12 @ 21-107); flat rings `ShockwaveRin1` 14973797453 + `2`
  14850595833 (4 each, VelocityPerpendicular, Speed 0-10.9, Drag 19, Spread 25, RotSpeed +-114, size 0->9.8); wind =
  113773032724838 (size 0->19.4, T 0.91), 16659993490, `Wind`/`Wind2` 13714506706 / 16334183470 (LE -1), 14171276320
  (black); ink twins `LinesBG2` 16969300854 (black, LE-1, 4) next to `LinesBG1` (6), `SpecsGold2` 16511071584 (black);
  rising specks `Specs` 13712002093 (23 @ 41-71, drag 7, Acceleration +41 Y, Br55, ZOffset 15.7); smoke 116686317011720 /
  116535655897049 / 131667932715858 (12-23 @ 17-67, drag 3-6, Acceleration -10..-28 Y).
- Works: negative Speed on a Disc pulls streaks INTO the centre while sparks fly out (d4); colour ramp #55007F ->
  #AAAAFF at Br 25-55 = white centre, tinted tails; ultra-short sparks (0.05-0.1 s at 100-250 studs/s, drag 15-19)
  = a one-frame starburst; bright/black twin pairs (black streaks visible between the magenta ones at 0.10);
  smoke thrown out at 17-67 studs/s with Acceleration -10..-28 lands and lies on the floor for ~0.5 s.
- Weak: 52 emitters for ~0.5 s of action (0.8 s with the floor residue); 8 "decal" layers at Transparency 0.78-0.84 and `glow3` 17844277603 at 0.97
  add almost nothing; grey wind (#383838, LE 0.6) reads blue-grey mud, not ink (the falling smoke that lands as grey
  clumps does ground the hit); the big diagonal streak runs out of frame in both captures: the Disc implosion streaks and the flash are both VelocityParallel, so their direction comes from
  the attachment the game script aims (which one draws that streak: Unclear).

### 3. `fc291adfbbff` Jane Juliet: blue "charge shine" burst on a character's head, est. 3.15 s
- Phases (Seen): 0.03 small blue spark with black spikes behind the head; first big burst (blue shards fanning ~3
  character-heights wide + a thin tilted ring + black spike lines) at 0.10 in the first capture, 0.20 in the recapture;
  0.35 big light shafts fan out; 0.55 and 0.80 two more bursts (tilted rings again); 1.2-1.8 thinner rays, a star
  glint and a small glowing sphere; 2.6 gone. Pulse times shift between captures because the counts are spread
  randomly over 1-1.85 s.
- Layers (Table): five `SkibChargeshin` layers each **twice**: LE1 Br3-10 blue #277DFF and LE0 **Br0** (= black).
  Only two pairs carry an emit count, so only they fire in the replay: splash ring 133160707482918 (Grid4x4, a ring
  of blobs that expands; VelocityPerpendicular, 0->5.57, 5 over 1 s) and impact1 13465720714 (Grid4x4 star + ring
  with dark spike strokes painted in; 0->3.72, 6 over 1 s). Silent without their script (no count): Star113
  14590086212 (size 0.6, Speed 60, drag 15), 17788820923 (Speed 120, RotSpeed 1000), lens streak 3052949762 (3.6,
  T 0.8). `Skibshine` (all EMIT 1-3 spread over 1.85 s): rays Star1b 1053548563 (VelocityParallel, Speed 0.003,
  drag 2.25, 0->4.5, life 0.3-1.3), ring 12402897209 (VelocityPerpendicular, spread 360, **RotSpeed 1500-2000**),
  11519516443 (shrink 4.78->0, RotSpeed 1000-1300, TimeScale 0.75), 15852641323 / 15852815049, Absorb Swirl
  15048784530 (TimeScale 0.7), Lightning1 13465798493 (squash 2, from 0.3 s), one mid pulse 14762055684 (1 @0.5 s,
  swell 0->4.8, RotSpeed -360).
- Works: Br0 twin = free black silhouette of every shape (d2); bursts spread over 1-1.85 s (EmitDuration) instead of
  Rate = a pulsing aura where every pulse pops; VelocityPerpendicular + spread 360 = randomly tilted thin rings
  round the head; per-layer TimeScale 0.7-0.75 (Forge `TimeScale_Start = End`) slows only the swirl layers.
  Unclear: the light shafts at 0.35 s reach 2-3 body heights, more than any Size in the table (max 5.6 studs);
  most likely the Star1b needles, but no table value explains the length.
- Weak: one hue (#277DFF) everywhere, white only where additive layers overlap; three dead pairs (no count) in a
  shipped effect; the bursts cover the face.

### 4. `fc25b1ce31bb` WrathPump Head: flaming eye sockets + dark smoke, est. 13.7 s (loops)
- Phases (Seen): the two captures disagree. First: 0.20-0.80 two white-hot flame tongues ~1.2 head-heights tall over
  the eyes; 1.2 flames gone, brown smoke; 1.8-3.6 smoke thins. Recapture (other angle, camera locked): no flames at all
  (Unclear: the flame emitters probably sit inside or behind the head mesh); 0.20-0.35 brown smoke wisps above;
  0.55-1.8 **black ink tendrils** spreading ~3 head-widths over the head, crisp against the lit sky; 1.8-3.6 pale
  white-orange smoke curling up. `FIRE11` re-emits 5 over 10 s
  from 2.23 s (the long length).
- Layers (Table): flame = two pairs of `fire` 11458438415 (LE1 **Br150**, #100D0B, size 0.76) + `fire black`
  (LE **-2** Br5, size 0.836 = 1.1x), 20 each, Speed 1.34, drag 13.4; `flare` 16511998441 (swell 0->1.4, Br6);
  smoke = Colorful Aura 13365068138 (Grid8x8, Rate 1.9, life 1.49) bright LE1 Br20 size 7.68 + dark LE0 Br15 size
  9.22 (1.2x); `contrast` Purple Lightning 13013256540 (#0A0A0A, LE0, 25 @0); embers 11448304274 (LE0 Br25),
  Specs11 15081972937 (LE **-3** Br40), Aura pieces 118804921280192 (LE -1).
- Works: dark twin 10-20% larger than the bright copy at the same ZOffset = a dark rim round fire (d3); every colour
  near-black (#0A0A0A-#29211C) with Brightness 15-150 doing the work; the `contrast` layer (Purple Lightning
  13013256540 at #0A0A0A, LE0 Br2, 25 @0, T 0.49, life 1.12-2.6) gives the black tendrils (d27); bright and dark
  Colorful Aura copies alternate as pale and brown smoke.
- Weak: flames are 0.76 studs on a 2-stud head and only show from some angles; LE -2/-3 sprites over a black sky
  darken nothing.

### 5. `ea235b3b244f` Gon ("yum"): black-and-white cursed-energy body aura with spinning eyes, continuous
- Phases (Seen): 0.03-0.10 nothing; 0.20 first white wisps at a shoulder; 0.35 wisps up one side; 0.55-0.80 full:
  white smoky wisps hugging the whole body, legs included, ~1.3x its width, glowing ring eyes, sparse specks, dark
  wisps over the head where the sky is behind them (the black layers). Dark navy body (the rig has a Highlight).
- Layers (Table): one 12-emitter set per limb (6 sets): Energy Pulse 12123878312 (Br1.5 and **Br155** copies), Cursed
  Energy 97051019398375, Realistic Layered Fog 73401626133942, Energy2 124359042766194, Energyesque 11446801985, all
  **LE0** with colour #B0B0B0 -> #252525 and Br 15-155; ink: Small realistic 16509892607 + Purple Lightning
  13013256540 (colour #000000, Br0, Rate 25 each) + 16511790647 (#080808); orbiting specks OffCentered 16171528032
  (RotSpeed +-250) + Multiple Specs 18450596124; eyes = Fading Glow 107821950776778 + Black Crescent 17085222506
  (Br45, **Rate 100**, size 0->0.07 / 0->0.235, **RotSpeed 2500-5000**).
- Works: LE0 + Brightness 15-155 = bright white matter that keeps its alpha shape and never washes out (d6); Transparency
  minimum at 90% of life + size from 0 = wisps condense then vanish (d8); per limb the black layers emit 62/s against 99/s
  for the grey ones (0.6:1), and the grey ones end near-black (#252525), so most of the aura's lifetime is dark.
- Weak: ~1,380 particles/s total (~940 alive); slow start (0.2 s before anything); monochrome only.

### 6. `c064a4796d09` "galoaxy": purple galaxy aura with a ground rune circle, builds slowly, continuous (est. 5.28 s)
- Phases (Seen; the recapture frames the legs and floor, the first capture had the floor layers under the stage):
  0.10 small purple ripple rings at the feet (~2x the legs' width); 0.35-0.55 soft purple ripple rings spread to ~4x
  the legs' width; 0.80 a dim rune circle (runic text ring, ~2x the legs' width = 4 studs) with magenta tendrils inside,
  first wisps on the legs; 1.2 rune circle faint, one big outer ripple, a star flare at the upper body, white smoke on
  the legs; 1.8 rune circle bright magenta, tendril patterns crawling out over the floor, body glowing lilac; 2.6-3.6
  full: white-hot violet flames up the legs, bright rune circle, sparkle dust (first capture: also a big faint
  rainbow halo behind the head, Flare170New 12105193694).
- Layers (Table): body flames Outward Fog 11447021694, Smoke 11799607237, EnergyVFX10 11458438415, 13934610516,
  AuraBig2 12528455353 (Rate 8.8-17.6, life 3.5-5.3, colour #9C9CBD -> #C654FF -> #D6C4FF, LE1 Br1.1-10,
  FacingCameraWorldUp, Squash grow 0 -> 0.3-1.6, Acceleration +0.06..0.33 Y); ink `4` smoke 16 15270482724 (**LE -5**
  Br4.3, Rate 26.4, ZOffset -6); eye: 4-point star 100955378623032 (**LE0 Br15**, squash -0.4, ZOffset 5.5), RayBasic
  12386392796, 81012989604637, 117719268353600, T_Bright 15501797918 (Rate 3, life 1-2); floor (all flat,
  VelocityPerpendicular, colour #6A019E): rune circle 13399941667 (LE1 Br2, size 4.06) + 13600029796 (LE1 Br5, 3.6),
  both Rate 2, life 2, RotSpeed 90, Transparency 1 -> 0.38/0.28 at mid-life -> 1; tendrils Pulse 13992197350 (LE0
  Br5, Grid4x4, 0->5.8) + 13992190852 (LE1 Br10, Grid4x4, 0->6.91), Rate 2, life 1-1.5; ripples ImpactRipple
  13455499583 (3 @0, LE1 Br15, 0->8.81, life 0.5-2) and WaterRipple 15024914905 (2 @0.2, LE0 Br6, 0->5.88).
- Works: the floor tells the story first: a ripple at 0.10 confirms the cast while the body aura takes ~2 s
  (long life 3.5-5.3 s, opacity peak at 55% of life); a slowly turning rune circle from two cross-fading copies
  (d9); bright + dark copies of the same tendril flipbook on the floor; flames stretch upward as they age (WorldUp +
  Squash grow); a negative-LE smoke far behind (ZOffset -6) (its effect: Unclear in the stills).
- Weak: the lilac-lit body competes with the aura; one hue family only (white, lilac, magenta); the floor layers
  vanish if the effect origin sits even slightly below the ground.

### 7. `db693743ee74` GoldenAtmosphere: ambient golden ember/dust field (scenery, not an attack), continuous
- Phases (Seen): 0-0.2 empty; 0.35-0.8 a few sparks; 1.2 ~50 sparks; 1.8 haze + many sparks; 2.6-3.6 full field:
  hundreds of gold specks, soft orange haze bands, thin vertical light streaks, bokeh dots. Steady state needs the
  longest lifetimes (up to 9.75 s) to fill.
- Layers (Table, all Rate 2.2-83/s, ~900/s total, ~1,490 alive): one shared colour ramp **#211008 -> #FFB37C ->
  #2D160B**; haze deco 93545521782141 (**LE -0.7 / -0.5**, Br25, 10.5 studs, life 6.8-7.8), deco6 79284119732721,
  deco4alt 92276634521088, shinies 111508092337743; streaks stuff2 14050038331 (0->33.4, Squash -0.9, Acceleration
  +36.8 Y), fire2 15333816834 (18.8 -> 0); sparks Dot 8511527728 (**Br100**, swell 0->0.25), Star113 14590086212
  (Br30), Glowing Bezier 16056965573, 11201546023, 6909741538, 8037777212 (Rate 37-83 each, LE 0.6).
- Works: the colour ramp starts and ends near black, so additive particles are invisible at birth and death whatever
  their Transparency (d7); LE 0.6 at Br 15-100 = hot but not fully additive; sizes from 0.07 to 33 studs in one
  palette give depth.
- Weak: dozens of small matte cream rhombus flakes at 1.8-2.6 s (one near the camera became a big flat card in the
  first capture); they look like paper confetti beside the glowing specks (which layer, and whether deliberate or a
  texture without working alpha: Unclear); ~900 particles/s; `stuff2` LightInfluence 0.9 ties it to scene lighting.

### 8. `e83e1882d477` Mochi FX folder (ReplicatedStorage/FX): goo-power slam/spike burst sets, est. 5.0 s
- Phases (Seen, recapture only; the first capture showed nothing): 0.03 empty; 0.10 peak: white-hot starburst, long
  horizontal white streaks, a cage of white crescent arcs, a few cream toon rocks; 0.20 the arc cage swells, rocks fly
  out, a huge faint ring (bubble outline) appears; 0.35 the bubble at ~2x the cage, arcs thinning to wisps, warm orange
  specks appear, faint smoke haze below; 0.55-0.80 orange glowing orbs and white specks drift up through a faint grey
  haze; 1.2-1.8 a few specks; 2.6-3.6 only a small white puddle part on the floor. White/cream + warm orange, no ink.
- Game timing from Script (`Mochi/C`): goo ball flies a bezier at 100 studs/s;
  on landing a floor puddle pops to 16-28 studs in 0.18 s (Quad); +0.7 s a spike mesh pops 20-35 studs tall in 0.17 s
  (Back Out) and the `ExpFX` emitters burst (EmitCount attr); 1-2 goo blobs fly 40 studs/s arcs and splat into pools
  in 0.18 s; spike settles 5 s, flattens 0.45 s, shrinks 0.5 s; floor shrinks at 6 s in 0.6 s.
- Layers (Table): smoke 8120749500 (**85** @ Speed 40-86, Drag 5, Acceleration **-40 Y**, size 0->19.5, RotSpeed
  +-275, T 0.98, LE0 Br5 white) + grey #5B5B5B copy (40 @, size 0->7.1); soft ring "Gradient" 8030746658 (1 @, size
  **0->57**, life 0.4, T 0.66, LE0 Br5) and Ring 9231890834 (0->40, T 0.49); spike crown 8708744804 (10 @ 166-233,
  Drag 7.5, VelocityParallel, Squash 1.8); toon rocks 8132607319 (25 @ 211-251, Drag 10, Acceleration -66, RotSpeed
  400-700) + photo rock 6730730442 (black, LE0, life 5); flat Crescents 8618373035 (20 @, VelocityPerpendicular,
  0->24, RotSpeed 400-600, life 0.25-0.4); Lines2 9145574991 (25 @ 70-90, Squash grow 0->3, Br10); Wisps 6910301489
  (20 @, size 25->0, RotSpeed +-385, Acceleration +9 Y, life 2.5-3.65, #FFA142 -> #821D13); trail 6860332733.
- Works: 20 flat crescents at random tilts = a spherical cage of arcs round the hit (d28); horizontal streak flash
  (VelocityParallel + Squash 1.8 at 166-233 studs/s) on frames 1-3; one huge soft ring (Ring 0->40, T 0.49) reads as a
  faint bubble outline; orange Specs/Wisps take over from the white burst at ~0.35 s (white -> warm hand-over);
  matte cream (#FEF9ED, #FFDFB7) at LE 0-1 Br4 sells "goo/food" instead of energy.
- Weak: no dark tone at all; the 85-particle smoke at T 0.98 is only a faint haze (the settling dust ring of d15 is
  barely visible); a photo-real rock next to toon rocks is a style clash (the black photo rock is not visible).

### 9. `2d159f40caf9` Skyrim Healing: fire-orange "holy" circle with sun rays, continuous (est. 3.0 s)
- Phases (Seen): 0.03 one ember; 0.10-0.35 one or two flat light wedges sweep round + a small crack; 0.55 ray halo +
  faint ring; 0.80 ring brightens, dark crack interior; 1.2-2.6 steady: bright fire ring (lower half cut by the
  floor), soft radial rays reaching ~2-2.5x the ring radius, the wedges and a crescent flick sweeping past (in the
  recapture a crescent passes close to the camera at 1.2-1.8 and blows out a quarter of the frame).
- Layers (Table): ring = Ring 6900421398 (size 1.25, Br5) + RingBG 12414215754 (Grid8x8, size 2, Br3), both **Rate 2,
  life 1, Transparency 1 -> 0 -> 1**; halo = Light 1084999891 (**Rate 20**, life 1-2, size 3->2, opacity peaks 25%,
  RotSpeed +-15, Br3); the sweeping wedges = LightRays 8905957078 (needle texture; 2 @0, VelocityPerpendicular, Speed
  0.014, SpreadAngle 360 = a random tilt each, size 0->5.06, Squash 0->0.475, RotSpeed +-35, life 3); crescent flicks
  Slashes 89269419999864 / 134546616390489 (VelocityPerpendicular, spread 30, RotSpeed -360..-100, 0->2.5, Rate 2);
  Cracks 10352563514 (1 @0, grows 0 -> 3 over its 2 s life); Specs 16543943176 (Br25).
  Colours #FF5015-#FF8E4C only; brightness sets the hierarchy (specs 25, ring 5, halo 3, rays 1).
- Works: Rate 2 + life 1 + opacity peak at mid-life = a sprite that looks static (two copies always cross-fading,
  d9); 20 overlapping 25%-opacity halos with random rotation = shimmer (d10).
- Weak: all-orange healing reads as fire/sun, not holy (no white core, no cool contrast); the flat randomly tilted
  LightRays needles become big cones when seen near edge-on (1.2 s frame) and look like errors; muddy dark interior.

### 10. `01c9657c80d8` Mochi Replicator HitFX: small projectile impact, est. 2.25 s. **Nothing rendered**
- The emitters sit under a ModuleScript (no BasePart/Attachment), so they cannot emit in the replay. Script `Mochi/V`
  clones them into a new Attachment on the projectile and calls `Emit(EmitCount)`.
- Layers (Table, all @0): one-frame flash Rays 7265756294 (life **0.1**, 0->7.17, T peak 0.14 at 47% of life, LE1 LI1);
  streaks Shards 8030734851 (20 @ 19-27, drag 3, life 0.1-0.2, colour #6E52FE -> #FC7B41 -> #FC4B30, LE0) and 8708744804
  (8 @ 41-57, Squash 1.8); flames 8030839542 (50 @ 8.6-13, spread +-5 = a jet, white -> orange -> red, LE0 Br3.25,
  life 0.15-0.4); ink Backdrop 8342967058 (5 @, **#37050A -> #000000**, LE0, T 0.54, life 0.5-2); smoke 8120749500 (15);
  rocks 8132607319 (2).
- Works (from numbers): white-to-red flames with a dark-red-to-black puff behind = three tones in 3 layers; a
  directional jet (spread +-5) instead of a radial burst.
- Weak: cannot be judged; Rays has LightInfluence 1 (dims in shade).

## b. Anatomy of a miscellaneous effect (roles in firing order, typical values)

R = the effect's radius (burst or aura extent); sizes are particle Size (full width), so "2R" = as wide as the
effect. Rough R per effect: Gravity ~5 studs (its flat rings end at 9.8), Jane ~3, lamp ~7, Mochi FX ~10 (floor
16-28 wide), galaxy floor ~4 (ripples 8.8), Skyrim ring ~0.6-1. "@0" = EmitCount at t = 0.

| Role | Examples (ids) | LE / LI / Br | Lifetime | Size curve, peak vs R | Transparency | Speed / Drag / Spread | Orientation, Squash, flipbook, ZOffset | Count |
|---|---|---|---|---|---|---|---|---|
| Gather / pull streaks (only Gravity) | 17627858096, ink 17093828340 | 1 / 0 / 25-55; ink 0.1/0/1 | 0.17-0.39 | shrink 16-22 -> 0 (3-4.5R -> 0) | 0 | -35 to -126 on a Disc | VelocityParallel, Squash +2..+4, Grid4x4 Loop fps 1, z 1.4-3.2 | 1 |
| Flash (frame 1) | 16874376111, 16410508868, 7265756294, 16511998441 | 1 / 0 / 1-25 (lamp core 150) | 0.1-0.36 | grow 0 -> ~2R (Gravity 8.7-10.4, lamp swell to 14.2) | 0, or 1->0.14->1 (peak 47%) | ~0 (lamp 3-23, drag 16.8) | VelocityParallel Squash -1.4..-2.2 (flattened) or FacingCamera, z 0.8-6 | 1 (lamp 20) |
| Flash ink twin | 17825526848, 17093828340 | 0.1 / 0 / 1-11, colour #000000-#020802 | 1.55x the bright flash (0.56) | same peak as bright | 0 | same | Squash differs (3 -> 1.2), z between the bright ones | 1 |
| Hot core flipbook | 11458438415 | bright 1/0/150 + dark -2/0/5 | 0.36-1.49 | const 0.76-1.45 studs (0.1x the lamp's 14-stud bloom); dark copy 1.1x | 0 | 1.3-16, drag 13-17, spread 30 | FacingCamera, Squash -0.5, Grid8x8 OneShot, z ~3. Seen white-yellow (head, first capture) but dim orange-brown with black patches (lamp foot): the LE -2 twin cancels most of it | 20 + 20 |
| Glints / sparks | 14590086212, 17062454806, 7395118796, 17420819512, 8030760338 | 1 / 0 / 10-55 | 0.05-0.25 | 0.25-0.6 const, or swell to 1-2 | 0 | 40-250 / 9-19 / 360 (stop at ~1.3-3R) | FacingCamera, z 1-7 | 12-25 |
| Streak sparks | 8030734851, 8708744804, 9145574991, 16969300854, 14005903992 | 0-1 / 0 / 4-55 | 0.1-0.5 | grow 0 -> 1.9-8 | 0 | 19-233 / 3-10 / 360 (Mochi jet +-5) | VelocityParallel, Squash 0.5-1.8 const or grow 0 -> 0.8-3 | 6-25 |
| Ink sparks / ink twins | 16969300854 (black, LE -1), 16511071584 (black), Br0 copies (Jane 13465720714, 133160707482918), 16509892607 + 13013256540 (Gon, black, Br0) | 0 or -1 / 0 / 0-1, colour black, or same colour Br0 | as bright | as bright | as bright | as bright | same as the bright twin | 0.6-1x the bright count |
| Rays / shafts | 1053548563, 8905957078, 1084999891, 12386392796 | 1 / 0 / 1-3 (RayBasic 3-10) | 0.3-1.3 (burst), 1-3 (aura) | grow 0 -> 1.5R (Jane); Skyrim rays 5.06 reach far past its small ring; halo 3 -> 2 | opaque -> 1 linear; halo min 0.75 | ~0 (0.003-0.014) / 1-2.25 / 360 | VelocityParallel (from a point) or VelocityPerpendicular + Squash grow 0 -> 0.475 (flat), RotSpeed +-15..35 | 2-3 per burst; halo Rate 20 |
| Rings, flat | 14973797453, 14850595833, 12402897209, 8618373035 | 0-1 / 0 / 1-5 | 0.17-0.6 | grow 0 -> ~2R (Gravity 9.8, Mochi crescents 24); Jane spin rings only 0.2R | 0-0.39 const | 0-12 / 19 / 25 (or 360 = random tilt) | VelocityPerpendicular, RotSpeed +-114 .. 1500-2000 | 1-4 (crescents 20) |
| Rings, camera-facing soft | 8030746658, 9231890834 | 0-0.5 / 0 / 1-5 | 0.4 | grow 0 -> 4-6R (40-57 studs over a 16-28-stud floor); seen as a faint bubble outline at 0.2-0.35 s | 0.49-0.66 const | 0 | FacingCamera | 1 |
| Floor ripple (frame 1-3) | 13455499583, 15024914905 | 1 / 0 / 15 (#6A019E); second 0 / 0 / 6 | 0.5-2 | grow 0 -> ~2R (8.81, 5.88) | 0 -> 1 | ~0.002 | VelocityPerpendicular (flat), just above the floor | 3 @0 + 2 @0.2 |
| Floor rune circle + tendrils (aura) | 13399941667, 13600029796; tendrils 13992190852 (LE1) + 13992197350 (LE0) | 1 / 0 / 2-5; tendrils 1/0/10 + 0/0/5 | 2; tendrils 1-1.5 | const 3.6-4.06 (~1R); tendrils grow 0 -> 5.8-6.9 | 1 -> 0.28-0.38 at 50% -> 1 | ~0.003 | VelocityPerpendicular, RotSpeed 90 (circle), tendrils Grid4x4 OneShot | Rate 2 each |
| Held ring (aura) | 6900421398 + 12414215754 | 1 / 0 / 3-5 | 1 | const | 1 -> 0 -> 1 (peak 50%) | 0 | FacingCamera, RingBG Grid8x8 | Rate 2 |
| Wind / swirl | 113773032724838, 16659993490, 13714506706, 14171276320 | 0 to -1 / 0 / 0-2 | 0.1-0.75 | grow 0 -> 1.7-3.9R (8.7-19.4 studs) | 0.7-0.95 const | 0-14 / 0 / 15-360, RotSpeed -80..180 | VelocityPerpendicular, Squash -0.8 | 1-6 |
| Smoke / dust | 8120749500, 116686317011720, 131667932715858 | 0-0.6 / 0-0.8 / 3-15 | 0.5-2.25 | grow 0 -> 0.7-2R (4.4-19.5 studs) | 0.95-0.98 const (too faint) or 1 -> 0.36 -> 1 | 9-86 / 3-6 / 180-360, Acceleration -(min speed) Y, RotSpeed +-5..275 | FacingCamera(WorldUp) | 12-85 |
| Ink puffs / dark smoke | 8342967058, 15270482724, 93545521782141, tendrils 13013256540 (#0A0A0A) | 0 or -0.5..-5 / 0 / 2-25 | 0.5-7.8 | 1.3-10.5 | 0.49-0.72 | 0.2-8 | z -6 (behind everything) or -1 | 5-25 @0, or Rate 2-26 |
| Linger motes (rising, orbiting) | 6910301489, 13712002093, 16171528032 | 1 / 0 / 4-55 | 0.5-3.65 | shrink 4.7-25 -> 0 | Wisps 1 -> 0 by 35% then opaque; Specs 0 | 0-71 / 3-7, Acceleration +4..+41 Y, RotSpeed +-250..385 | FacingCamera, z 3.6-15.7 (in front) | 15-23 |
| Aura body flames (continuous) | 11447021694, 12528455353, 12123878312, 97051019398375 | LE1 Br1-10 (galaxy) or LE0 Br15-155 (Gon) | 0.4-0.7 (Gon), 3.5-5.3 (galaxy) | grow 0 -> 1-3.4 studs | 1 -> 0 at 55-90% of life -> 1 | 0-0.2 (Acceleration +0.06..2.5 Y) | FacingCamera(WorldUp), Squash 0.1-0.25 or grow 0 -> 1.6, Grid8x8 OneShot, LockedToPart | Rate 5-26 per emitter per limb |

Extras: one PointLight in 4 of 10 (lamp, head, galaxy, Skyrim; their values are not in the tables). ZOffset: ink behind
(-1..-6), specks and glints in front (3-16). LightInfluence 0 on 284/295 emitters (the 11 others: Gravity's grey smoke
and ground layers 0.1-0.8, Mochi Rays 1, Golden streaks 0.9, Jane 0.2, glow3 1).

## c. Timing (seconds)

| Phase | Bursts (Gravity, Mochi hits, lamp, Jane pulses) | Auras / ambient (Gon, galaxy, head, Skyrim, Golden) |
|---|---|---|
| Fire | flash at t = 0, first visible still 0.03-0.10 (the recapture shows lamp, Gravity, Mochi FX empty at 0.03); flash life 0.1-0.36 | no body flash; first sign 0.1 (galaxy floor ripple, Skyrim ember) - 0.2 (Gon, head smoke) |
| Peak | 0.10 (Gravity, Mochi FX; Gravity 0.03 in the first capture), plateau 0.2-0.8 (lamp) | steady state at ~0.5-0.7x max Lifetime: Gon 0.55, Skyrim 1.2, galaxy 1.8-2.6 (rune circle 0.8, flames 1.2+), Golden 3.6+ |
| Fade | sparks gone 0.05-0.4; rings 0.17-0.6; ink twin outlives flash by ~1.5x | loops; each particle fades over its last 10-50% |
| Linger | Gravity smoke clumps and floor bands to 0.8; Mochi FX orange orbs/specks 0.35-1.2, scattered specks to 1.8; lamp bloom out by 1.2 | n/a; head: ink tendrils 0.55-1.8, pale smoke 1.8-3.6 |
| Total | ~0.8 s (Gravity incl. floor residue), 1.2 (lamp), ~1.8 (Mochi FX), 2.6 (Jane, pulses at 0.1-0.2 / 0.35 / 0.55 / 0.8 from EmitDuration 1-1.85) | continuous; Mochi scripted sequence: pop 0.18 -> +0.7 spike pop 0.17 -> hold 5 -> shrink 0.45 + 0.5 -> floor out at 6 |

Variation: bursts agree within ~2x (flash 0.1-0.36, glints 0.05-0.25); auras vary 10x (0.4-0.7 s Gon vs 3.5-9.75 s
galaxy/Golden) and that lifetime alone sets how long the power-up takes to appear.

## d. Techniques catalogue (exact recipes)

1. **Near-black colour x Brightness = hue by ratio, intensity by Brightness.** Color #13100D, LE1, Brightness 10:
   (19, 16, 13)/255 x 10 = (0.75, 0.63, 0.51) per particle; 20 stacked = a white bloom with a warm-pink rim (lamp2).
   At Brightness 150 = (11.2, 9.4, 7.6) it should clip white, but paired with a same-place LE -2 twin (1.1x) the
   result varied: white-yellow tongues on the head (first capture), a dim orange-brown flicker with black patches at
   the lamp's foot (recapture). Use the high-Brightness copy alone (or with a Br0 twin behind it, d2) for a hot core;
   the LE -2 pairing is Unclear and must be checked in Studio. [lamp2, head]
2. **Brightness 0 twin = black copy.** Duplicate any emitter, set LightEmission 0 and Brightness 0: it renders black
   whatever its Color, same counts/speeds, so black spikes interleave with the bright ones. [Jane: 5 pairs]
3. **Dark twin 10-20% bigger, same ZOffset** behind a bright flipbook = dark rim / dark patches: fire 0.76 + fire black
   0.836 (LE -2 Br5, seen as black patches in the lamp's foot flicker); aura 7.68 (LE1 Br20) + 9.22 (LE0 Br15), seen as
   pale and brown smoke alternating over the head. [head, lamp2]
4. **Implosion without script:** Shape Disc, Speed -126 (or -34.6), VelocityParallel, Size 22.4 -> 0, Squash 2..4,
   Lifetime 0.17-0.39, EmitCount 1, LE1 Br25-55 plus a black copy (17093828340, LE0.1). Streaks converge while the
   sparks fly out. Geometry of Disc + negative speed UNVERIFIED in our runtime; ShapeInOut Inward is the documented
   way. [Gravity]
5. **Stop distance of a drag burst:** if speed halves every 1/Drag s (the docs' wording; the vault calls the exact
   formula undocumented, so treat this as a rule of thumb), a particle stops after ~1.44 x Speed / Drag studs.
   Gravity Sparks1 145/19.2 -> 11 studs, but life 0.1 cuts them at ~8; Jane 60-120/15 -> 6-11. Choose
   Speed = 0.7 x R x Drag for sparks that end at ~R.
6. **Bright non-additive matter:** LE0 + Brightness 15-155 on grey (#B0B0B0) = white wisps with solid alpha that do
   not wash out over other additive layers; colour ramp to #252525 turns them to smoke as they age. Extends the vault's
   "LE 0 + high Brightness = solid colour" (Particle Emitters In Depth, s.4) with numbers: grey x 15-155. [Gon]
7. **Fade by colour, not by transparency:** Color #211008 -> #FFB37C -> #2D160B (dark -> bright -> dark) at LE 0.6;
   particles are near-black (invisible additively) at birth and death even with Transparency 0. [Golden]
8. **Condense-then-vanish wisp:** Size grow 0 -> peak, Transparency 1 -> minimum at 0.9 of life -> 1. [Gon, 12 layers]
9. **Steady sprite with no restart:** Rate 2, Lifetime 1, Transparency 1 -> 0 at 0.5 -> 1. Two copies always
   cross-fade, so a ring or glow looks static. [Skyrim ring + RingBG] Floor version: rune circle 13399941667 /
   13600029796 flat (VelocityPerpendicular), Rate 2, Lifetime 2, Transparency 1 -> 0.28-0.38 at 0.5 -> 1, RotSpeed
   90 = a turning rune circle under a character (galaxy, seen 0.8-3.6 s).
10. **Shimmer halo:** Rate 20, Lifetime 1-2, opacity peak 0.25 (T min 0.75), random Rotation, RotSpeed +-15, Size 3 -> 2,
    on a soft radial-ray texture (1084999891). [Skyrim]
11. **Motion-blurred spinning rings:** RotSpeed 1000-2000 deg/s on a ring/impact sprite, VelocityPerpendicular, Speed
    0.002, SpreadAngle 360 (= random tilt per particle), life 0.17-0.33. [Jane 12402897209, 11519516443]
12. **Spinning glowing eyes:** two tiny sprites (0.07 and 0.235 studs, glow 107821950776778 + crescent 17085222506),
    Rate 100, RotSpeed 2500-5000, Br45, LockedToPart. [Gon]
13. **Orbiting / spiralling dots:** off-centre dot texture (6910301489, 16171528032) + random Rotation + RotSpeed
    +-250..385; radius = dot offset x Size, so Size 25 -> 0 makes inward spirals. [Mochi Wisps, Gon]
14. **Light shafts from a point:** 1053548563 (on black, additive only), VelocityParallel, Speed 0.003, SpreadAngle 360,
    Size 0 -> 4.5, life 0.3-1.3, 3 per pulse. The needle's wide end lands away from the source. [Jane]
15. **Cartoon dust ring that settles:** smoke 8120749500, 85 @0, Speed 40-86, Drag 5, Acceleration -40 Y (= minus the
    min speed), Size 0 -> 19.5, RotSpeed +-275, LE0. [Mochi]
16. **One huge soft ring:** 8030746658, 1 particle, Size 0 -> 57 (~6R), Lifetime 0.4, Transparency 0.66 constant, LE0 Br5.
    [Mochi]
17. **Flattened flash across the hit direction:** VelocityParallel + Squash const -2.2 (or 0 -> -1.4); its ink twin uses
    Squash 3 -> 1.2 so the two shapes differ. [Gravity]
18. **Flames stretch with age:** FacingCameraWorldUp + Squash grow 0 -> 0.3-1.6 + Acceleration +0.06..0.33 Y. [galaxy]
19. **Crisp, non-blooming glint:** 4-point star 100955378623032 at LE0 Br15, Squash -0.4, ZOffset 5.5. [galaxy eye]
20. **Built-in power-up ramp:** Lifetime 3.5-5.3 s, opacity peak at 55% of life; with Rate 9-26 the aura reaches full
    after ~2 s with no script. [galaxy]
21. **Pulses from bursts:** EmitCount 3-6 with EmitDuration 1-1.85 s gives an irregular pulsing aura in which each pulse
    is a fresh pop (unlike Rate). [Jane]
22. **One-frame flash:** Lifetime 0.1, Size 0 -> 7.2, Transparency 1 -> 0.14 at 47% -> 1 (Rays 7265756294). [Mochi hit]
23. **Negative LightEmission ink** (-0.5 haze, -1 lines/wind, -2 fire rim, -3 embers, -5 smoke at ZOffset -6): it only
    darkens what is behind it, so put it over bright layers or a lit world. [Golden, Gravity, head, galaxy]
24. **Brightness ladder in one hue:** Skyrim uses one orange family with Br 25 (specs) > 5 (ring) > 3 (halo) > 1 (rays).
25. **Colour ramp deep -> light at Br 25-55:** #55007F -> #AAAAFF: the centre clips white, the tails keep the hue.
    [Gravity, all bright layers]
26. **Per-layer slow motion:** ParticleEmitter.TimeScale 0.7-0.75 on only the swirl/ring layers (Forge attributes
    TimeScale_Start = TimeScale_End = 0.7) so they lag the rest of a burst without other changes. [Jane]
27. **Black ink tendrils:** smoky squiggle flipbook 13013256540 (Purple Lightning) at Color #0A0A0A, LE0, Br2, 25 @0,
    Transparency 0.49 then -> 0.94 after 78% of life, Lifetime 1.12-2.6: crisp black wisps over a lit sky or bright
    smoke (head, seen 0.55-1.8 s; Gon uses the same texture at #000000 Br0, Rate 25 per limb).
28. **Crescent cage:** 20 flat crescents 8618373035, VelocityPerpendicular, SpreadAngle 360 (random tilt each), Speed
    12, Size 0 -> 24, RotSpeed 400-600, Lifetime 0.25-0.4, LE1 Br4, #FFDFB7 -> #FEF9ED = a sphere of arcs round the
    hit for ~0.3 s. [Mochi FX, seen 0.10-0.35]
29. **Floor ripple as instant feedback for a slow aura:** 3 flat rings (13455499583) at t = 0, LE1 Br15, Size 0 ->
    8.81, Lifetime 0.5-2, plus 2 more at 0.2 s; they read at 0.10 s while the body aura needs ~2 s. [galaxy]

## e. Mistakes and weak spots

- **White-out:** many additive layers x 20 particles at Br 10-150 (lamp2) = no shape and the source object vanishes. Keep
  one white core, cap overlapping additive layers, let ink cut the bloom.
- **Dead layers:** constant Transparency 0.78-0.98 (Gravity decals, glow3, Mochi smoke 0.98: a barely visible haze)
  cost particles and show little over a dark ground. If it is worth a layer, give it >= 15-25% opacity somewhere.
- **Negative LE over black:** darkening layers (LE -1..-5) are invisible against a dark sky; use colour black + LE0 there.
- **Particle cost:** Gon ~1,380/s, Golden ~900/s, galaxy ~160/s; for phones keep auras under ~150/s.
- **Placement depends on scripts:** emitters under a script (Mochi Replicator) or VelocityParallel flashes aimed by an
  attachment show nothing or point anywhere without that context. Document the parent and axis in the spec.
- **Origin height:** flat floor layers (galaxy ripples, rune circle, tendrils) and falling smoke (Gravity) vanish when
  the origin sits below the ground (the first replay hid them): put floor layers 0.05-0.2 studs above the surface.
- **Flat sprites at grazing angles:** randomly tilted VelocityPerpendicular wedges become huge cones (Skyrim LightRays).
  Keep random-tilt flat layers small, or pair them with a camera-facing copy.
- **One hue:** Jane (all #277DFF, black only from its Br0 twins) and Skyrim (all orange, no ink at all) never change
  colour over time and have no white core of their own.
- **Wrong palette for the meaning:** orange healing reads as fire; holy wants a white core with warm gold and a cool
  or dark accent.
- **Slow feedback:** Gon shows nothing for 0.2 s and the galaxy body aura needs 1.2-1.8 s: fine for an aura, too slow
  to confirm a key press. The galaxy itself solves it with a floor ripple at 0.10 (d29); otherwise add a frame-1 flash.
- **Matte flakes among glowing specks:** Golden's cream rhombi read as paper confetti (and as a flat card up close).
- **Same pair, different look:** the Br150 + LE -2 flame pair looked white-hot on the head and muddy at the lamp's foot
  (d1): never trust an LE < 0 layer without a Studio check from the game's camera.
- **Style clash:** photo rock 6730730442 beside toon rocks 8132607319 (Mochi).
- **LightInfluence 1** on a flash (Mochi Rays) or 0.9 on streaks (Golden) makes them dim in shade.

Recipe built from this: `misc_recipe.luau` (same folder), a holy light burst with gather, white core, gold body and ink.
