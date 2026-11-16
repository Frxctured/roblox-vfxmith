---
title: "Open-source VFX study: aura / charge-up"
source: "open-source VFX library (Discord packs) studied 2026-11-13"
tags: [vfx, roblox, particles, aura, charge-up, ink, brightness, negative-lightemission, squash, open-source-study]
---

# Aura / charge-up: what 7 open-source effects teach

Evidence: freeze-frame sheets + layer tables in `gallery/effects/aura/` (repo root; layer tables: `kit/scripts/layer_table.py`)
(Edit-mode replayer, every script stripped), the decoded instance trees in the decoded pack files (`kit/scripts/rbxdump.py`) and the effects'
own scripts (read as text only). 226 emitter designs (Sukuna's 38 counted once, they repeat on 6 limbs), 18 Beams,
2 Trails. This extends `../PATTERNS.md` (section 6 "Aura rig" and the three-tone rule); it does not repeat it.
**Seen** = visible in the stills; **Table** = from the layer table or dump; **Script** = from the effect's scripts;
**Inferred** = my reading; **Unclear** where nothing settles it. Recipe: `aura_recipe.luau` next to this file.

**Stills.** Revised 2026-11-14 against the recapture (effects placed on the floor by their emitters, each view
re-aimed and closer, bluer-grey stage). The first capture hid floor layers of `a71fc16cc7b0`, `dfdc1ff4eaa4`,
`d4822fa4128e` and `ace632d5c265`; those claims are now replaced by what the new frames show. In the recapture the
0.03 s frame is empty for the plain-particle sets (Sukuna leg, Voidstrike, Voidflare: first particles at 0.10 s),
while Tatsumaki, Angel, Charge Up and Sukuna Base show content at 0.03; why is unclear, so read "0.10" there as
"first frame".

**Most of these are NOT one-shot effects.** 5 of the 7 are streaming auras: their emitters are saved
`Enabled = true` with a `Rate`, a script switches them on when the move starts and off when it ends (Script: Voidstrike
`VFXHelp.EnableVFX/RemoveVFX` on animation markers, Voidflare welds the Aura to the root for the rush, Tatsumaki
disables the limb aura after 3.9 s). The replayer fires `EmitCount` bursts instead (and a few RATE layers), so the
stills show a burst version. Only Charge Up (`ace632d5c265`) and Tatsumaki's Cast/Star/Coil parts are real one-shots.

Group numbers (Table, 226 emitters): LightEmission < 0 in 27 (12%; values -1, -2, -5), = 0 in 136 (60%),
between 0 and 1 in 21 (9%), = 1 in 42 (19%). Brightness median 5; >= 10 in 86 (38%); >= 25 in 14; max 150.
FacingCamera 65%, VelocityParallel 18%, VelocityPerpendicular 15%, FacingCameraWorldUp 2%. Flipbook Grid4x4 48%
(library 35%), Grid8x8 10%, Grid2x2 4%. Squash set in 35% (library 25%). LockedToPart 32% (library 25%).
Continuous load as authored (Table, all Enabled emitters): Sukuna 228 emitters / 2,587 particles/s / ~2,600 live
for the whole body; Angel 46 / 1,283 per s / ~3,200 live (TimeScale 0.3 triples lifetimes); Voidflare 42 / 1,350 per s
/ ~280 live; Tatsumaki limb aura 4 / 100 per s / ~23 live per limb; Voidstrike hand 8 / 102 per s / ~28 live.

## a. The seven effects

### 1. `ca02a0ef8c5a` Sukuna Aura, Right Leg (red-black cursed-energy body aura), streaming
- What: 38 emitters on EACH of the 6 limbs (same set on every part), no locking, plus a red Highlight
  (FillTransparency 0.94, OutlineTransparency 0.9) and a red PointLight on the torso (Br 0.5, Range 15) (Table).
- Phases in the replay (Seen): 0.03 nothing; 0.10 sharp red flame wisps ~0.5 stud tall on the top edge of the
  1x2x1 part, one already black; 0.20 thin red strands rising ~1 stud; 0.35 red specks, and a brown smudge where a
  dark-red smoke sprite sits in front of the light part; 0.55 red specks and short vertical red streaks; 0.80-1.80 a
  loose cloud 1-2 studs above the part: thin black curling ink wisps mixed with glowing red embers and vertical red
  streaks (the RATE layers). In game every emitter streams, so this 0.8-1.8 s state is the real look.
- Layer roles (Table): sparks = 4 spec layers at Rate 25 (`12363816474` sideways spec, `12713358298` glowing spec,
  `138454022090507` Grid4x4 sharp flame; swell 0 -> 0.07-0.26 at 10% of life -> 0, Speed 2, Drag 3, Spread 55,
  Acc 0,3,0, life 0.5-1.2); flame tongues = Grid4x4 one-shots `17226921546`, `16847071704`, `100157595400098`,
  `86644934246125`, `140471746213044`, `13486412595` (#FF4040, LE 0 or -1, Br 11-15, size 0.15-1.44 shrinking to 0,
  Speed 1.8-4, Acc up 3-10.8, Squash 0 -> 3 or 0 -> -1.61, life 0.3-1); cursed energy `17006172452` (Grid4x4,
  Rate 15, colour #FF2727 -> #000000); 9 smoke layers at #510000 (`11858203067`, `99966049870137`, `16867361532`,
  `16867352057`, `13717823765`, `12930785601`, `11822996479`, `125578376132704`, `81110833835270`; LE 0-1, Br 0-2,
  life 1.63-1.96, size 0 -> 1.16, Spread 170, Drag 3.07, ZOffset -0.1/-1); a once-per-second glow `12402851670`
  (LE 1, Br 15, Transparency 0.8, Squash 0.3, Rate 1).
- Techniques: (1) **every element twice, a bright twin (Br 11-15) and a dark twin (Br 0-0.1, or LE -1 Br 0)** with
  identical motion, so black flames mix into the red ones (the red/black "cursed" read: black wisps beside red
  embers, Seen 0.10 and 0.80-1.80 s);
  (2) smoke is a dark saturated colour (#510000 = 32% value) rather than grey; (3) rising flames stretch with
  Squash 0 -> 3 as Acceleration speeds them up.
- Weak: 2,600 live particles for one character; 9 near-identical smoke emitters (9 textures for one role); every
  sprite is 0.07-1.7 studs, so beyond ~30 studs it reads as red noise with no shape; the #510000 smoke at LE 0.3
  drawn in front of a light surface turns into a brown smudge (Seen 0.35 s).

### 2. `169d8de5f532` Sukuna Aura Base, Right Arm (same aura + flame beams), streaming
- What: the same 38 emitters plus 5 Beams on the arm (3 more on other parts), 7 of 13 Beams enabled (Table).
- Phases (Seen): 0.03 a red light fan wider than the frame, flaring up from the part (the beams at their authored
  Width1 5.24, before the Forge Width attributes apply); 0.10-1.80 narrow red flame streaks fanning up 2-3 limb
  heights above the part the whole time, plus red crescent flame shapes (0.20), black ink wisps (0.35-0.80) and red
  embers and specks. (The first capture showed the beams only from 0.8 s; the recapture contradicts that.)
- Beam recipe (Table): attachments 4 studs apart along the limb (y -1.42 to +2.63), FaceCamera, Segments 10,
  Width0 0.73 -> Width1 5.24 as properties, but the Forge attributes set the playing widths: 0.73 -> 1.47
  (`12713360567`), 0 -> 2.62 (`125283151882051`), 1 -> 2.5 (`118613370531472`, `10240434007`), 2.62 -> 4.19
  (`117954206167253`), so each streak flares 2-6x from bottom to top; `TextureMode Stretch`, TextureSpeed 0.5, Transparency
  1 @0.16 -> 0 @0.36 -> 0 @0.59 -> 1 @0.82 (soft band in the middle of the length, both ends invisible), colour
  #621D1D; textures `12713360567` (LE 1 Br 2), `125283151882051` (LE 1, Width 0 -> 3.14), `118613370531472`
  (LE 1 Br 1.25), `117954206167253` and `10240434007` (LE 0 Br 3 = the dark twins of the beam layer).
- Techniques: (1) beams = the only big shape in the Sukuna set, giving the aura a flame silhouette 2-5x the limb;
  (2) beam ends faded by the Transparency sequence (not by width), so the streaks start and end softly;
  (3) LE 0 dark beams under LE 1 bright ones, the same twin idea as the particles.
- Weak: Forge-style attributes (EffectDuration 2) but the beams are static; nothing pulses. Authored property widths
  (5.24) far wider than the attribute widths (1.47-2.62) flash a frame-filling red fan for one frame if the beam is
  enabled before the attributes are applied (Seen 0.03 s).

### 3. `dfdc1ff4eaa4` Tatsumaki Throw / Charge (green psychic charge on the hand + limb aura)
- What (Script): `Cast` and `Star` burst at the hand, `Coil` bursts at the floor, `Light` (PointLight green Br 2,
  Range 8) tweens to Br 0 in 0.5 s Quint, `Lighten` = Highlight FillTransparency 0.15 -> 1 in 0.5 s Quart (white
  flash on the body), `Shockwave` = 8 radial flat Beams tweened in 0.5 s Quint, `Aura` cloned onto EVERY limb and
  disabled at 3.9 s, arm Trails disabled at 4 s; Cast re-fires at 3.9 s.
- Phases (Seen): 0.03 a square-ish white-green starburst ~3 studs wide at the hand; 0.10 the burst turns into a
  spiky green splash with a dark centre; 0.20 a small green 4-point glint; 0.20-1.80 a green flame flickering
  ~1-1.5 studs tall (one limb aura), biggest at 0.35 (several tongues). Grey vertical streaks hang over the whole
  view all along: the Shockwave beams frozen at their start pose (their collapse tween is a script). Floor layers
  (Coil) barely read even with the floor in frame: a few faint dark dust specks at 0.20-0.35; the Brightness-0 floor
  ring and the #2A2A2A dust are dark on a near-black floor, so they vanish.
- Layer roles (Table): ignition = Star2a `7216849703` (LE 1, Br 5-35, size 9-10 -> 0, life 0.1, Rotation 45,
  RotSpeed 180) + Grid4x4 `138371936465467` (LE 1 Br 5, 0 -> 5, life 0.1) + `3909691881` (LE 0, Br 35, colour
  #10391C -> #20733A, swell 0 -> 6.8); ink = `102977909637329` at #000000 LE 0 Br 0 (0 -> 6, life 0.42, ZOffset
  2.99, just behind the bright layers at 3-5) and the same texture at LE -1 Br 0 tinted green; limb aura = 4 locked
  emitters: `129286674281579` pair (LE 1 Br 2 ZOffset +3 in front / LE 0 Br 0 ZOffset -2 behind, colour
  #000000 -> #43F27D -> #000000, swell 1.5 -> 3-5 -> 1.5, Squash 0.255, Transparency 1 -> 0.8-0.88, Rate 20),
  `137103478440334` (Grid8x8, Rate 40, life 0.25, 0 -> 1.5, colour green -> black), `106715194614609` (Grid4x4,
  Rate 20, life 0.15, Squash 0.2); floor = `102977909637329` flat ring (VelocityPerpendicular, 0 -> 7,
  Transparency 0.5), dust `79923145601000` (#2A2A2A, EMIT 25, Speed 27.5-35, Drag 6, Acc -7, LightInfluence 0.5),
  rising specs `334397163` (LE -1, EMIT 8, Speed 15-25, Drag 4.5, Acc +3).
- Shockwave beams (Table): start pose 8 beams at radius 5.3, 12 studs long, Width 7.5, LE 1, TextureMode Wrap,
  TextureLength 20, TextureSpeed 5, texture `106588947025757`, colour black -> white -> black across the beam (soft
  edges by colour, not transparency); end pose radius 3.5, length 0, Width 5, LE 0, TextureSpeed 0, tilted 22.5 deg.
  A light cage that collapses inward in 0.5 s (Inferred from the two poses).
- Techniques: (1) ignition = shrinking 4-point star + growing flipbook + a black disc growing behind them at
  ZOffset 2.99; (2) limb aura sandwich: glow in front (ZOffset +3), the dark copy behind (ZOffset -2);
  (3) fade in from black and out to black through the Color ramp instead of Transparency.
- Weak: the limb aura peaks at 12-20% opacity (Transparency 0.8-0.88), so it almost vanishes on a bright map; the
  re-cast at 3.9 s is a second, identical flash (no escalation); dark floor layers (Br 0 ring, grey dust) are
  invisible on a dark floor (Seen), so a ground beat needs a light layer on dark ground.

### 4. `d4822fa4128e` Voidstrike Lightning Strike / HandAura (blue electric charge held in the hand)
- What (Script): cloned onto the right arm at the `HandUp` marker (its Summon emitters are already Enabled and
  stream), `EnableVFX` at `ImpactLines` switches on the rest, `RemoveVFX` at `HandDown`; the strike is another
  effect. The hold lasts as long as the animation (length unclear).
- Phases (Seen): 0.03 nothing; 0.10 white-blue vertical needles ~3 studs tall crossed by a horizontal streak
  ~5 studs wide, an RGB-fringed cross, electric squiggles and a blue ring arc below, dark navy wind fans behind;
  0.20 the dark wind arcs fan out into a broken ring ~2x the cross width, the cross still lit, squiggles reach
  ~2 studs below; 0.35-0.80 a bright jagged electric column 2-3 studs tall at the hand (which layer is unclear:
  the 0.4 s flash flipbooks `16218239465` / `16028033353` or the locked lightning sheet `14197135879`) with glitter
  rising above it; 1.20-2.60 only the glitter column, ~1 stud wide and 5+ studs tall; 3.60 gone.
- Layer roles (Table): needles `18118860997` (LE -5, Br 25, VelocityParallel, Rotation 90, size 0 -> 0.81 -> 0,
  Squash -3 -> 3 at 0.28, life 0.064-0.128, EMIT 10) and `18491531924` (Grid2x2, LE -5, Br 25, Drag 146, Squash
  keys 0, 3 @0.07, -1.5 @0.21, 3 @0.34, -1.31 @0.55, -3 @1, life 0.024-0.086); cross sparks `17062416111` x2 (LE 0,
  Br 5, Squash +0.5 on one emitter and -0.5 on the other, size 0 -> 1.47 -> 0.15 -> 1.41 -> 0, Drag 15.3); black
  frame `97073167273125` (LE 0, Br 0, size 1.81, life 0.02-0.03); wind fans `124244494490688` (LE 0, Br 0 and
  0.355, VelocityPerpendicular, Speed 7.76, Drag 5, SpreadAngle (0, 360), Transparency 1 -> 0.12 -> 0.8); filaments
  `17005480412` (LE -2), `17005538321` and `14197133127` (LE 0), all Br 25, spread 360, Speed 3.7-23, Drag 7.5-15,
  life 0.17-0.33; flash flipbooks `16028033353`, `16218239465` (LE -2, Br 25, 0 -> 1.7-2.2, life 0.4);
  smoke `14754464270` (LE -2, Br 25, EMIT 7); glitter `16511093402` (Grid8x8, LE -5, **Br 150**, VelocityParallel,
  Squash 2, Speed 0.51, locked, visible until 0.68 of life, Rate 20 for EmitDuration 3); Trail `17867372958`
  (LE 1, Br 10, TextureMode Static).
- Techniques: (1) squash keyframes that swing between +3 and -3 make one sprite flicker tall/wide = electricity
  without a lightning builder; (2) negative LightEmission with very high Brightness (LE -5 / Br 25-150) on every
  bright element (crisp, solid-looking blue-white at 1-2 stud sizes); (3) dark fans at Brightness 0 frame the
  bright core and open into a dark ring round it (Seen 0.20 s); (4) three beats in one hold: needle cross
  (0.1-0.2) -> electric column (0.35-0.8) -> glitter only (to 2.6).
- Weak: lifetimes 0.02-0.03 s (black frame) are shorter than one frame at 30 fps and may never be drawn on slow
  clients (Inferred); LE -5 / Br 150 are undocumented values.

### 5. `ace632d5c265` Charge Up (blue charge ball with a release flash), one-shot, VFX Forge
- What (Table): attachment groups `Load` (core, 0-0.5 s via EmitDuration 0.5 = Rate stream for 0.5 s), `Sparks`,
  `FloorWind` (2.4 studs below), `Flash` (EmitDelay 0.8), plus Forge mesh Models `BeamSpin` (2 dark arched Beams
  `9988507605`, CurveSize +-18, Width0 1 -> 0, spinning 20 -> 0 rad/s over 1 s, RotAroundOrigin), `WindMesh` and
  `WindDecalMesh` (Neon meshes, Transparency 0.9 -> 1, ConstantVFX streams) that only Forge plays.
- Phases (Seen; the replayer plays the Forge mesh models): 0.03 two dark navy ribbon arcs sweeping across the view
  (the BeamSpin beams, LE 0 #242A47) over a glassy grey bowl and ground swirl rings (WindDecalMesh / WindMesh,
  Neon at Transparency 0.9); 0.10 a faint glass bubble round the core, a bright blue broken ring inside it, one long
  bright streak shooting diagonally out of the view (which layer is unclear), white orbiting dots, a dark core;
  0.20 the core is a bright white-blue curled crescent, 4 white dots orbit about 1 R out, one orange speck; 0.35 the
  third bubble pulse grows past the view, the core is a white "butterfly" of crescents, dark ribbon arcs pass in
  front; 0.55 a white-hot oval core with a blue-white crescent rising from it and a thin needle spike; 0.80 the
  release: a soft white-blue X-shaped bloom ~3x the core, overexposed to near-white, with a pale smoky fan to one
  side; 1.20 empty. The bright core crescents are probably `74187681812534` (LE -1, Br 8, flat Transparency 0,
  VelocityParallel, Squash -0.8, size 11.2) and the spinning `125485406249210` / `101795579020586` (Inferred).
- Layer roles (Table): core glow `6673021984` pair (LE 0 Br 8 #5A78FF size 9.63 ZOffset +0.01 / LE -2 Br 1 #222356
  size 11.2 ZOffset -0.01, both Transparency 0.9 -> 1); pulsing bubbles `7216856402` (size 0 -> 14 @0.1 -> 0 @0.26 ->
  8.2 @0.4 -> 0 @0.5 -> 16.6 @0.7 -> 0, Transparency 1 -> 0.84 -> 1), `119057920510209` and `14004161351` (LE -2) with
  the same triple-pulse curve; suction `101795579020586` (LE 1, size 10 -> 0, RotSpeed 500) and `125485406249210`
  (5.19 -> 0, RotSpeed +-360); ink `74187681812534` (LE -1, Br 8, Squash -0.8); sparks `16171528032` x2 (one orange
  #FFA548 -> #FF3F00, one #92BFFF; Speed 12.4-49.8, Drag 5, RotSpeed +-200); floor `12713735498` (0 -> 16.5),
  `15056677063` (0 -> 8), `7216856024` (white at **Br 0** = a black ring), all flat with Transparency 0.33 -> 0.91 by
  0.27 of life; release at 0.8 s: `17062452486` star (LE -1, Br 10, 12.6 -> 0, Squash 0 -> 2.21, life 0.103), discs
  `6631155345` (LE 0.5 Br 1 and white LE 0 **Br 0**, cubic-out 0 -> 7.39, Transparency 0.8 -> 1), `119057920510209`
  (0 -> 7.4 and a flat 0 -> 13.7 at 0.83 s, life 0.15); `13510176991` stretched circles (Squash 2.02, life 0.08).
- Techniques: (1) **one particle pulses three times** through a multi-hump Size curve (heartbeat charge with a
  single emit); (2) **cubic-out easing baked into Size keys** (38% at 5% of life, 92% at 15%) with a matching eased
  fade in Transparency; (3) dark glow twin 16% bigger right behind the bright glow; (4) release built as a white star
  over a 20%-opaque black disc (Brightness-0 twin of the same disc); (5) a faint shell + a hot core: the glows and
  bubbles stay at 10-16% opacity while a few opaque crescent sprites (LE -1, Br 8, Transparency 0) carry the read;
  (6) dark ribbon arcs (LE 0 Beams, CurveSize +-18) spinning round the core give depth against the bright core.
- Weak: the meshes at Transparency 0.9 read as grey glass, not energy, on a light background (Seen 0.03-0.35 s);
  the release overexposes to white and loses the blue (Seen 0.80 s); the strongest shapes (BeamSpin arcs, wind
  meshes) depend on the Forge runtime; Rotation (-3603, 60) and SpreadAngle -3603 are authoring typos (harmless,
  both random anyway). (The first capture suggested the build barely shows; the recapture contradicts that.)

### 6. `a71fc16cc7b0` angel aura, WingsTest (gold halo + teal wings, holy idle aura), streaming
- What (Table, Script): a gold halo MeshPart (`17525372238`, 17 studs) welded behind the head and spun -0.6 rad/s by
  a LocalScript; teal Glass wings mesh with bones; body-part emitters; a flat ground stack 5.2 studs below the root;
  a 78 x 20 x 70 invisible volume emitting rising sparks and fog; PointLight cyan (Br 1.5, Range 17) + SpotLight
  pointing down (Br 5, Angle 50, Range 16).
- Phases (Seen): 0.03 the spiky gold halo ring + teal wings; 0.20 a faint gold circle round the halo; 0.35-0.55 a
  yellow disc that fills the halo, turning white-cream by 0.55; 0.80 a cream disc with a dark centre; 1.20 disc gone,
  yellow specks scattered over the frame; 1.80-2.60 yellow-green fog rising over the whole frame, specks bigger.
  Ground stack: 0.35 faint gold specks on the floor; 0.55-0.80 a gold glitter carpet spreading radially over the
  floor several wingspans wide, brightest at 0.80; 1.20 it fades to grey-white streaks; 1.80 a dark disc darkens
  the floor round the character (a hard straight edge shows, cause unclear) with a thin gold ring ripple; 2.60
  4-5 concentric gold ripple rings ~3x the wingspan with a swirl at the centre.
- Layer roles (Table): halo burst = 4 layers on the halo with **EmitCount 133 each** (`14004739953` glow x3 at LE 1
  **Br 0.1**, size 10.5-15.4; `14727016281` fog; `17723930633` slash LE 0 Br 5 size 16) all VelocityPerpendicular;
  ground stack (VelocityPerpendicular, locked, TimeScale 0.3): rings `18281460865` (Grid4x4 Loop), `16877839414`,
  `109574326366882`, slashes `119473092655714` / `129732204988744` (size 44-53), dark discs `8119252523` #202020
  (0 -> 70) and `1075864321` #000000 (0 -> 45, life 3), star `16409068152` coloured (size 6, LE 1) over a black
  twin (size 8, LE 0, Br 0); air volume: sparks `14590086212` (**Rate 500**, LE 1, Br 30, size 0.42 -> 0,
  Acc 0,43.6,0, TimeScale 0.3) and fog pairs `117962134521217` (LE 1) + `76997705216999` (LE 0), FacingCameraWorldUp,
  size 17, Squash 0.5; body: smoke `11799607237` / `14727016281`, `13013256540` at TimeScale 0.15-0.5.
- Techniques: (1) a coloured mesh as the solid core of the aura (halo), particles only around it; (2) TimeScale
  0.15-0.3 on streaming emitters = slow, floaty flipbooks without retiming them; (3) giant flat dark discs (#000000 /
  #202020, 45-70 studs) under the light layers to darken the ground round the character (Seen 1.80 s); (4) ring
  flipbooks on the ground at TimeScale 0.3 stack into slow concentric ripples (Seen 2.60 s), a ground beat that keeps
  going without new bursts.
- Weak: 133 particles x 4 layers at Br 0.1 to make one soft disc, and it still washes to white (Seen 0.55 s);
  Rate 500 is above the documented 400/s per-emitter cap; ~3,200 live particles; the halo-burst emitters are
  Enabled at Rate 10-75 too, so the burst also streams.

### 7. `79f04711219b` Voidflare Rush / Aura (violet flame shell around a dashing character), streaming
- What (Script): a 7-stud invisible Part welded to the root for the rush, `RemoveVFX` at the end. Emitters face
  Back (EmissionDirection Back) so the stream trails behind the dash; 42 emitters, 5-150 particles/s each.
- Phases (Seen, replay only): 0.03 nothing; 0.10 a dense pink-white flame puff ~3 studs with a violet rim, violet
  sparks and thin black streaks off to one side (the stripes); 0.20 the puff (the layer with EmitCount 2,555 at
  EmitDelay 0.05) with a bright violet crescent arc sweeping over it, ~1.5x the puff wide; 0.35 puff gone, two
  crossing violet arcs and a bundle of blue streaks; 0.55 one thick violet arc low on one side, a large black smoky
  arc above it, blue streaks; 0.80 a faint violet haze. Which layers draw the arcs is unclear (probably the flame
  sheets, e.g. `138698095349887`, named "shockwave" in other packs: VelocityParallel, Spread 360, life 0.3-0.5).
  Many layers have EmitCount 0, so the real look (a continuous trailing stream) is not in the stills.
- Layer roles (Table): flames `115927130568600`, `133878014409173`, `87286695409895`, `140367461792076`,
  `138698095349887` (LE 0.5-1, Br 0.3-7, size 4-12, life 0.2-0.6, colour #5E4CFF -> #3407FF); shell
  `13734332372`, `13778319879`, `14327437980`, `13894904991` (LE 0, Br 10, #6A39FF -> #0400FF, VelocityParallel,
  Speed 8-203, Drag 5-10, Squash 0.5-1.6); stripes (no texture, #000000, Br 25, Disc shape, Speed 14-601, life
  0.07-0.23, Squash 0.4); wind/shards on a Disc shape `12061201262`, `12096349161`, `15572330616` (light and dark
  twins: Br 4.43 / Br 1), `16658351981`, `16637904761`, `17258046088`; spin cards `12009965333`, `15611036245`,
  `18212303178` (VelocityPerpendicular, RotSpeed 300-2000, life 0.015-0.14, some #000000); impacts `16722863337`
  (one Br 3.33, one Br 0 black twin); bloom card "5" (no texture, LE 1, swell to 58.7 in 0.05 s); Trail
  `11828267185`.
- Techniques: (1) LE 0 with Br 10 on a saturated violet: Color x Brightness clips, so the dense centre goes
  pink-white and only the thin edges stay violet, a free white core (Seen 0.20 s; mechanism Inferred);
  (2) Disc-shaped emission + VelocityParallel + very high Speed = streaks that radiate from a ring; (3) light/dark
  twins of the same texture at different Brightness (Br 4.43 vs Br 1; Br 3.33 vs Br 0); at large scale this shows
  as a bright violet arc beside a black smoky arc of the same shape (Seen 0.55 s).
- Weak: EmitCount 2,555 (a typo or a density tool's output: one Emit call spawns 2,555 particles); ZOffset -13.7;
  lifetimes 0.015-0.03 s; 1,350 particles/s while dashing.

## b. Anatomy of an aura / charge-up

R = the effect radius: half the height of the caster part (limb 1x2x1: R = 1), the core radius (Charge Up R ~ 5) or
half the halo (Angel R ~ 8.5), Voidflare R = 3.5. Roles in firing order for a one-shot charge-up; streaming auras
use roles 3-9 as Rate streams.

| # | role | when / life | texture role + example ids | LE / Br | size (and x R) | transparency | motion | orientation / squash / flipbook | count | ZOffset |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | ignition flash | t 0, life 0.05-0.1 | 4-point glow `7216849703`, flipbook burst `138371936465467`, cross `17062416111`; textureless bloom card (Voidflare) | LE 1 Br 5-35 (or LE 0 Br 35 for solid colour) | 9-10 shrinking to 0 (Tatsumaki, 9-10 R); 58.7 bloom (17 R) for 0.05 s | 0 | Speed 0, RotSpeed 180, Rotation 45 | FacingCamera; none | 1 each, 2-3 layers | +3 to +5 (front) |
| 2 | tension needles | t 0, life 0.04-0.13 | diamond needle `18118860997`, `18491531924` | LE -5 Br 25 | 0 -> 0.8 -> 0 (0.8 R) | 0 | Speed 0-5, Drag 0-146 | VelocityParallel, Rotation 90; Squash -3 -> +3 (or oscillating) | 5-10 | +1 |
| 3 | ink core / dark twin | t 0, life 0.4-0.5 (streams: same life as the bright layer) | same texture as the bright layer, or `102977909637329`, `6673021984` | LE 0 Br 0 (pure black) or LE -2 Br 1 with #222356 | 1.0-1.16x the bright layer (Charge Up 11.2 vs 9.63; Tatsumaki black 6 vs green 4.8) | 0 or 0.9 | none | FacingCamera | 1 | 0.01-5 behind its bright twin |
| 4 | core glow | build, life 0.5-1 | soft halo `6673021984`, `12402851670`, `14004739953` | LE 0 Br 8 or LE 1 Br 15; Angel LE 1 Br 0.1 x133 | 1.2-2 R | 0.8-0.9 constant -> 1 | Speed ~0 | FacingCamera (Sukuna Squash 0.3) | Rate 1-10 (Charge Up 5 over 0.5 s) | +-0.01 |
| 5 | pulsing / converging rings | build, life 0.5 | soft ring `7216856402`, `119057920510209`, wobble `14004161351`; swirl `101795579020586` | LE 0 Br 5-8 (LE -2 on the wobble) | triple pulse up to 1.7-3.3 R; swirl 2 R -> 0 | 1 -> 0.84 -> 1 (very faint: reads as a glass bubble) | RotSpeed 500 on the swirl | FacingCamera; swirl VelocityParallel | 1-5 per 0.5 s | 0 |
| 5b | hot core crescents | build, life 0.15-0.5 | `74187681812534` (Grid4x4), corner debris `125485406249210` (Charge Up) | LE -1 Br 8 / LE 0 Br 8 | 1-2.2 R (size 5.19-11.2 at R 5) | 0 flat (opaque: this is what reads, Seen 0.20-0.55 s) | Speed ~0.01-0.02, Spread 360, RotSpeed +-360 on the debris | VelocityParallel (random plane), Squash -0.8 | 1-5 per 0.5 s | 0 |
| 6 | body flames | streaming or build, life 0.25-0.6 | Grid4x4 one-shot flames `17226921546`, `16847071704`, `100157595400098`, `115927130568600`, `133878014409173`; Grid8x8 `137103478440334` | LE 0 Br 11-15 (Sukuna), LE 0.5-1 Br 3-7 (Voidflare) | 0.15-1.4 R shrinking to 0 (Sukuna); 1.1-3.4 R growing (Voidflare) | 0 flat | Speed 1.8-4, Spread 55, Acc up 3-10.8 x R | FacingCamera; Squash 0 -> 0.75 or 0 -> 3 | Rate 6-15 per layer | 0 to +1.3 |
| 7 | dark smoke | streaming, life 1.6-2.0 | Grid4x4 smoke `11858203067`, `16867352057`, `12930785601` (2x2) | LE 0-0.3, Br 0-2, colour at ~30% value of the hue (#510000) | 0 -> 0.8-1.16 R, eased | 0 -> 1 eased (0.31 at 0.2, 0.8 at 0.6) | Speed 0.4-1.2, Drag 3.07, Spread 170, Acc up 0.9-1.3 | FacingCamera | Rate ~12 | -0.1 to -1 |
| 8 | rising sparks / glitter | streaming, life 0.2-1.2 | specs `12363816474`, `12713358298`, `16171528032` (off-centre), glitter sheet `16511093402`, star `14590086212` | LE 0 Br 10-15; LE -5 Br 150 (glitter); LE 1 Br 30 (Angel) | 0.05-0.26 R (single specs), 1.5 (glitter sheet) | 0, cut at 0.68-0.78 of life | Speed 0.5-2 (or 12-50 with Drag 5), Spread 55-360, Acc up 3-43.6 | FacingCamera, or VelocityParallel + Squash 2 | Rate 20-25 (Angel 500) | 0 to +1 |
| 9 | electric filaments | build, life 0.17-0.33 | Grid4x4/8x8 squiggles `17005480412`, `17005538321`, `14197133127` | LE -2 or 0, Br 25 | 0 -> 0.5-0.6 R | 0 | Speed 3.7-23, Drag 7.5-15, Spread 360 | FacingCamera, Rotation +-180 | 6 per burst | +2 |
| 10 | ground layer | t 0 and release, life 0.4-1 (Angel 1.4-3 x TimeScale) | flat ring `7216856024`, `102977909637329`; cloud `12713735498`; shock `15056677063`; dust `79923145601000` | LE 0, Br 0-2 (Br 0 = black ring); Angel LE 1 Br 10-15 gold rings/slashes over #000000/#202020 discs | 3-7 R (Angel 5-8 R) | 0.33 -> 0.91 by 0.27 of life -> 1 | Speed ~0.03 flat; dust Speed 27.5-35 Drag 6 | VelocityPerpendicular, EmissionDirection Top | 1-3; dust 25 | 0 |
| 11 | release flash | end of build (Charge Up 0.8 s), life 0.1-0.15 | long star `17062452486`, disc `6631155345`, dissolving ring `119057920510209` | star LE -1 Br 10; disc LE 0.5 Br 1 + Br 0 twin; ring LE 0 Br 8 | star 2.5 R -> 0; disc 1.5 R; ring 2.7 R, cubic-out | disc 0.8 -> 1; star/ring 0 | Speed ~0 | star Squash 0 -> 2.2; ring VelocityPerpendicular | 1 each | +0.4 to +0.5 |
| 12 | light + highlight | whole effect | PointLight, Highlight | Br 2 -> 0 in 0.5 s Quint, Range 8 x R (Tatsumaki); Sukuna Br 0.5 Range 15 constant; Highlight fill 0.15 -> 1 in 0.5 s (flash) or 0.94 constant (tint) | | | | | 1 | |
| 13 | flame beams (optional) | streaming | `12713360567`, `125283151882051`, dark twins `117954206167253`, `10240434007` | LE 1 Br 1-2 + LE 0 Br 3 | playing widths 0.73 -> 1.47, 0 -> 2.62, 1 -> 2.5, 2.62 -> 4.19 (flare 2-6x upward; up to ~4 R), 4 studs long | 1 / 0 @0.36-0.59 / 1 along the length | TextureSpeed 0.5, Stretch | FaceCamera, Segments 10 | 3-5 per limb | |

Ground-layer reading (Seen in the recapture): dark ground layers (Br 0 ring, #2A2A2A dust) vanish on a dark floor
(Tatsumaki); light ring and slash layers at LE 1 over big dark discs read clearly, as a glitter carpet and then slow
concentric ripples (Angel 0.55-2.6 s).

## c. Timing

| phase | Charge Up (one-shot) | Tatsumaki (hand) | Voidstrike (hand) | streaming auras (Sukuna, Angel, Voidflare) | use |
|---|---|---|---|---|---|
| ignition | 0-0.08 (Seen: dark ribbons + glass meshes at 0.03, ring + streak at 0.10) | 0-0.10 (star 0.1, black disc to 0.42) | table 0-0.13 (needles 0.04-0.13, cross 0.13-0.24); Seen 0.10-0.20 | none | 0-0.1 (to 0.2) |
| build / hold | 0-0.5 stream (EmitDuration 0.5), core crescents bright to 0.55, hold to 0.8 | aura 0-3.9 (script) | electric column 0.35-0.80 (Seen), glitter 0-3 (EmitDuration 3), until HandDown | as long as the move (Rate streams) | 0.5-0.8 one-shot, else the move |
| release | 0.80 star/disc (life 0.103), 0.83 ring (0.15) | re-cast at 3.9 | separate strike effect | none (RemoveVFX lets particles die) | 0.10-0.15 flash |
| linger | cloud to 1.8 (Seen gone by 1.20) | light and highlight fade 0.5 s | glitter alone 1.2-2.6, gone by 3.6 | smoke 1.6-2.0; Angel ground ripples 0.55 -> 2.6+ (x 1/TimeScale = 3-5 s) | 1-2 s |

Lifetimes inside streams: flames 0.25-0.6 s, sparks 0.5-1.2 s, smoke 1.6-2.0 s, needles and cards <= 0.13 s.
Variation: ignitions all fall within 0.05-0.13 s; builds range from 0.5 s to the whole move; release flashes 0.1-0.15 s.

## d. Techniques catalogue

1. **Bright/dark twin emitters.** Duplicate the emitter, keep every motion value, set the copy to Brightness 0
   (LightInfluence 0) or LE -1 Br 0 (Table: Sukuna pairs Br 15 / Br 0.1 for specs, flames, beams; Voidflare
   Br 4.43 / Br 1, Br 3.33 / Br 0; Angel star Br 5 / Br 0; Charge Up disc Br 1 / Br 0). The dark copy rolls its own
   random values, so black tongues and specks mix into the bright ones: built-in three-tone contrast.
2. **Brightness 0 = black sprite of any texture.** With LightInfluence 0 the sprite's colour is scaled by Brightness,
   so a white ring at LE 0 Br 0 renders black (Charge Up `7216856024`; Tatsumaki `102977909637329` #000000 Br 0;
   Voidstrike wind at Br 0 / 0.355 reads as dark navy fans, Seen 0.10 s). An ink layer without a dark texture.
3. **Negative LightEmission + very high Brightness.** LE -5 with Br 25-150 (Voidstrike needles, glitter), LE -2
   with Br 25 (filaments, flashes), LE -1 with Br 10 (Charge Up release star). Small sprites read solid and crisp.
   Inferred mechanism: below 0 the blend goes past normal alpha and darkens what is behind while the high Brightness
   keeps the sprite bright. Undocumented; keep a fallback (LE 0, Br 8-15).
4. **Squash keyframes for flicker.** `Squash = {0,0},{0.07,3},{0.21,-1.5},{0.34,3},{0.55,-1.31},{1,-3}` (Voidstrike):
   one sprite jumps tall/wide 5 times per life = electric jitter. `{0,-3},{0.28,3},{1,3}`: a needle that flips from
   wide to tall. Two copies with Squash +0.5 and -0.5 = horizontal and vertical variants of one cross.
5. **Stretch as it rises.** Squash 0 -> 3 (or 0 -> 0.75) + Acceleration up 5-10.8 + size shrinking to 0 (Sukuna):
   flame tongues that get thinner and taller as they speed up.
6. **Multi-hump Size = pulses from one particle.** `Size = {0,0},{0.1,14},{0.26,0},{0.4,8.2},{0.5,0},{0.7,16.6},{1,0}`,
   `Transparency = {0,1},{0.5,0.84},{1,1}`, life 0.5 (Charge Up): a heartbeat bubble, three beats in 0.5 s.
7. **Baked ease-out.** Size keys `{0,0},{0.05,0.38},{0.1,0.62},{0.15,0.83},{0.24,0.99},{1,1}` x full size (Charge Up
   discs and rings) plus `Transparency {0,0.33},{0.04,0.51},{0.09,0.64},{0.15,0.76},{0.21,0.84},{0.27,0.91},{1,1}`
   (floor layers): fast grow, long dissolve. Sukuna smoke uses a gentler version (0.31 at 0.2, 0.8 at 0.6).
8. **Suction swirl.** Size 10 -> 0 (2 R -> 0), RotSpeed 500, LE 1, life 0.5 (Charge Up `101795579020586`); debris
   corners 5.19 -> 0 with RotSpeed +-360. Shrinking + spinning reads as energy being pulled in.
9. **Dark halo behind the glow.** Bright LE 0 Br 8 at 9.63 + dark LE -2 Br 1 #222356 at 11.2, ZOffset +0.01 / -0.01,
   both Transparency 0.9 (Charge Up): a dark rim 8% of the radius wide round the core.
10. **ZOffset sandwich round a limb.** Glow at ZOffset +3 (in front of the arm), its dark copy at -2 (behind it)
   (Tatsumaki); smoke at -0.1 / -1 behind flames at 0 (Sukuna); ignition layers at +3 to +5, the black disc at 2.99.
11. **Fade through black, not transparency.** Colour #000000 -> #43F27D -> #000000 or #FF2727 -> #000000 with
   Transparency flat (Tatsumaki, Sukuna): at LE 1 that is a fade-in/out; at LE 0 the end of life burns to ink.
12. **Shoot and stop.** Speed 3.7-23 + Drag 15 (filaments, ~1.5 studs out); Speed 27.5-35 + Drag 6 (floor dust);
   Speed 0-5 + Drag 146 (needles stay put); Speed 192-384 + Drag 25 (Voidflare specks).
13. **Flat fan of directions.** VelocityPerpendicular + SpreadAngle (0, 360) + Speed 7.76 + Drag 5 (Voidstrike wind):
   the cards spread in one plane only and stop, a ring of dark wind.
14. **Off-centre orbiters.** Off-centre dot `16171528032` + RotSpeed +-200 + Speed 12-50 + Drag 5: sparks that curl.
15. **Rate 1 breathing glow.** Glow LE 1 Br 15, life 1, Rate 1, size 0 -> 1.72, Transparency 0.8, Squash 0.3 (Sukuna):
   one soft bloom a second = the aura breathes.
16. **TimeScale < 1 on a streaming aura.** TimeScale 0.15-0.5 (Angel) slows flipbooks and motion; real lifetime =
   Lifetime / TimeScale (0.1 s -> 0.67 s at 0.15), and live particle count rises by the same factor.
17. **Beam flame streaks on limbs.** Playing widths Width0 0.73 -> Width1 1.47 (and 0 -> 2.62, 1 -> 2.5), Transparency
   band 1 @0.16 / 0 @0.36-0.59 / 1 @0.82, TextureSpeed 0.5 Stretch, FaceCamera, Segments 10, LE 1 + an LE 0 copy
   (Sukuna Base; Seen 0.10-1.80 s as narrow red streaks fanning 2-3 limb heights up). The authored property width
   5.24 shows only for one frame (0.03 s) as a frame-filling fan, so author the property at the playing width.
18. **Collapsing beam cage.** 8 flat radial beams (radius 5.3, length 12, Width 7.5, colour black -> white -> black,
   TextureSpeed 5) tweened in 0.5 s Quint to radius 3.5, length 0, Width 5, LE 0 (Tatsumaki, needs code).
19. **Highlight flash.** Highlight FillColor white, FillTransparency 0.15 -> 1 in 0.5 s Quart, DepthMode Occluded
   (Tatsumaki) at the cast; a constant tint is FillTransparency 0.94 / OutlineTransparency 0.9 (Sukuna).
20. **Over-bright LE 0 colour for a free white core.** #6A39FF at LE 0 Br 10 (Voidflare): where many particles overlap
   the colour clips to pink-white, edges stay violet (Seen 0.20 s; mechanism Inferred).
21. **Disc-shaped emission for radiating streaks.** Shape Disc + VelocityParallel + Speed 14-601 + Squash 0.4
   (Voidflare stripes, textureless #000000 Br 25): black speed lines leaving a ring.
22. **Mesh core + particle shell.** A coloured mesh holds the shape (Angel halo spun -0.6 rad/s; Charge Up BeamSpin
   arcs at 20 -> 0 rad/s, Seen as dark navy ribbons sweeping past the core at 0.03 and 0.35 s); particles only
   dress it.
23. **Faint shell, opaque core.** Glows and bubbles at Transparency 0.84-0.9 make a glass-like shell; 1-2 opaque
   sprites per beat (Transparency 0, LE -1, Br 8) carry the read (Charge Up `74187681812534`, Seen 0.20-0.55 s as
   white-blue crescents).
24. **Ground ripples from a slow ring stack.** LE 1 ring flipbooks + slash discs (44-60 studs) at TimeScale 0.3 over
   #000000 / #202020 discs: a gold glitter carpet (0.55-0.80 s) that settles into 4-5 concentric ripples (2.60 s)
   (Angel).

## e. Mistakes and weak spots (avoid)

- **Round 1 + four reference auras (2026-11-16; the rules are in `taste.md` "Character effects" and "Motion and
  rhythm").** Our dark charge aura (owner ~7) was a ribbon cage turning as one piece: the same in every hold frame,
  no ground layer, no head accent, symmetric, a pale haze over a pale body. Auras the owner rates 8.5-9 have: a
  ground layer 1.4-3.4 H wide as the biggest element (this study's role 10 is too small and too short-lived for a
  held aura: keep it for the whole hold); still structure with moving textures and particles; heartbeat pulses (1
  frame on, 0.4-0.8 s decay, every ~0.7-1.1 s with jitter) on unsynced periods; one head accent in a shifted hue
  with the face clear; one tall off-centre accent; ink beside the white cores; ~50+ tiny particles (0.02 H). A
  release needs a tail (cool smoke, falling embers, a fading ground mark for 0.3-0.8 s): ours was over in ~0.3 s.

- **Cost.** Sukuna ~2,600 live particles, Angel ~3,200 (Rate 500 on one emitter, above the documented 400/s cap;
  4 x 133-particle bursts), Voidflare 1,350/s. Whole-body auras need a budget: 1-2 emitters per role per body, not
  38 per limb. Thin counts on mobile yourself (Emit and Rate ignore graphics quality).
- **Redundant layers.** 9 smoke emitters with 9 textures for one smoke role (Sukuna); 3 identical halo glows
  (Angel). Each role needs one texture + at most one twin.
- **Too faint to read.** Limb glows at Transparency 0.8-0.88 (Tatsumaki) almost vanish; Charge Up's 0.84-0.9
  bubbles only read as glass. Charge Up survives because a few opaque core sprites carry it (Seen); keep the core of
  an aura at >= 30% opacity somewhere.
- **Dark-on-dark ground layers.** Brightness-0 rings and grey dust disappear on a dark floor (Tatsumaki, Seen).
  On dark ground, use a light ring over a dark disc (Angel).
- **Semi-transparent meshes read as glass.** Neon meshes at Transparency 0.9 look like grey glass on a light
  background (Charge Up wind meshes, Seen 0.03-0.35 s).
- **Property vs attribute mismatch.** A beam whose property width (5.24) is 2-4x its Forge attribute width shows a
  frame-filling fan for one frame (Sukuna Base, Seen 0.03 s).
- **Dark-red smoke in front of skin.** #510000 at LE 0.3 over a light surface reads as a brown stain (Sukuna, Seen
  0.35 s); keep dark smoke behind the body (ZOffset < 0 is not enough when the sprite is in front in 3D).
- **Additive stacking to white.** 133 LE 1 glows (Angel) turn the gold disc cream-white by 0.55 s (Seen); Charge Up's
  release (star LE -1 Br 10 + discs + ring) overexposes to near-white at 0.80 s (Seen). The hue is lost. One
  non-additive or dark layer per stack (PATTERNS pitfall, confirmed).
- **No big shape.** Sukuna's leg set is all 0.07-1.7 stud sprites: noise at distance. Add a silhouette layer (beams,
  a mesh, a big soft glow).
- **Sub-frame lifetimes.** 0.015-0.03 s (Voidstrike black frame, Voidflare cards) are shorter than a 30 fps frame
  and may never be drawn (Inferred). Use >= 0.05 s for one-frame cards.
- **Typos and out-of-range values.** EmitCount 2,555 (Voidflare), Rotation -3603 / SpreadAngle -3603 (Charge Up),
  ZOffset -13.7; LE -5 and Brightness 150 rely on undocumented behaviour.
- **Script-dependent looks.** The best shapes (Tatsumaki beam cage, Charge Up BeamSpin and wind meshes, Angel halo
  spin) need the effect's own code or the Forge runtime; the particles alone do not carry the effect.
- **EmitCount 0 on stream layers** (Voidflare, Angel, Voidstrike lightning): fine for a Rate stream, but a burst
  replayer or an "emit all" helper shows nothing for them. Give stream layers a sensible EmitCount for previews.

## Recipe

`aura_recipe.luau` (20 layers, R = 3 studs): ignition star + needles + RGB sparks; build with glow/ink halo pair,
faint triple-pulse bubbles and suction swirl around opaque core crescents, curling sparks, rising flames with their
Brightness-0 twins, dark smoke, filaments, glitter and a light ground ring; release star, disc, dissolving ring,
ground cloud; one PointLight. Untested: run it through the VFX pipeline before use. Revised 2026-11-14 after the
recapture: added the opaque core crescent, swirl back to source opacity, ground ring made light (dark rings vanish
on dark floors), the release disc's black twin dropped (it does not read under the overexposed release).
