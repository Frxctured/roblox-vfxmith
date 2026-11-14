---
title: Explosion VFX - lessons from 7 open-source effects
source: open-source VFX library (Discord packs) studied 2026-11-13
tags: [vfx, explosion, impact, shockwave, flash, particles, roblox, os-library, three-tone, ink, brightness, light-emission, squash]
---

# Explosions: what 7 open-source effects teach

Evidence: the freeze-frame stills from the Edit-mode replayer, the layer tables (`library/cards/<category>/<id>.md`), the raw dumps
(decoded with `kit/scripts/rbxdump.py`, e.g. Fire explosion.rbxm, for the Forge mesh models and decoded curves), the catalog
(`catalog/effects.jsonl.gz`) and the scripts of Jingliu and Cid (read as text). Studio was not used. Two captures exist:
the **recapture** (`gallery/effects/explosion/<id>.jpg`, placement and framing fixed, each view aimed at the
effect, camera locked; Rate-only emitters stream for 0.6 s; late effects shot from their start) is the main evidence;
the **first capture** (the first capture (not shipped)) is quoted only where it caught something the recapture
missed, and says so. Labels: **Seen** (in the stills), **Measured** (recapture: share of the frame at least 40 luma
brighter than the effect's own last, empty still, and the median / 90th-percentile colour of those pixels; framing is
per effect, so compare percentages over time within one effect, not across effects), **Inferred** (my reading).
The 0.03 s still is unreliable: in the recapture LightingBurst, Cinnamon, Fire explosion and BigExplosion show no
particles at 0.03 while the first capture showed LightingBurst's and Cinnamon's flashes there. Flashes shorter than
0.1 s are therefore described from whichever capture caught them.

**Evidence gaps, read first.**
- `f9ef4f62abcb` BigExplosion: all 70 emitters have EmitCount 0 and run on `Rate`. The recapture streams them for
  0.6 s, which is the replayer's choice, not the author's (the script that drove them is not in the file); its timing
  is not representative, its looks are. The 8 mesh shells stay static (no animation script in the file).
- `c5645c4c7d50` Cid Slashes3: every layer has **EmitDelay 6.2 s**; the recapture shoots it from 6.23 s (the first
  capture stopped at 3.6 s and was empty).
- `acb7087801ae` Fire explosion: at 0.03 only the falling ring mesh is visible in the recapture (no particles yet, as in
  the other effects above). Its 4 Forge mesh models are replayed; its debris module (raycast rocks with a trail) is
  script-driven and missing.
- Scripts missing from all stills: Jingliu recolours its smoke to the ground (see d.29); BigExplosion's shell animation
  lives outside the file (the only script there is a rig `Animate`); Cinnamon has an EZ CameraShaker module but the
  caller that plays this explosion is not in the dumped scripts.

**Library context** (catalog, the 609 effects tagged `explosion`, emitter layers grouped by name; D = median peak Size
of the effect's ring-named layers, 272 effects have one):

| Role (name match) | n | LE p10/p50/p90 | neg. LE | Brightness p25/p50/p75/p90 | Lifetime max p25/p50/p75 | Size / D p25/p50/p75 | Life / ring life p50 | EmitCount p50/p90 | Size curve |
|---|---|---|---|---|---|---|---|---|---|
| flash | 294 | -0.1 / 0.5 / 1 | 11 % | 2 / 5 / 15 / 45 | 0.10 / 0.12 / 0.18 s | 0.45 / 1.11 / 1.82 | 0.32 | 2 / 4 | shrink 55 %, grow 22 %, swell 19 % |
| shock/ring/wave | 1976 | -0.55 / 0.75 / 1 | 12 % | 1 / 2 / 8 / 15 | 0.21 / 0.41 / 0.9 s | 0.81 / 1.0 / 1.23 | 1.0 | 2 / 8 | grow 93 %; VelocityPerpendicular 76 % |
| smoke/dust | 1590 | 0 / 0.1 / 1 | 8 % | 1 / 1 / 3.7 / 10 | 0.75 / 1.25 / 2.0 s | 0.28 / 0.44 / 0.77 | 2.5 | 6 / 25 | grow 86 %; FacingCamera 75 % |
| spark/spec | 997 | -3 / 0 / 1 | **26 %** | 5 / 12 / 20 / 35 | 0.46 / 0.8 / 1.25 s | 0.07 / 0.13 / 0.29 | 1.14 | 5 / 25 | swell 58 %, shrink 23 % |
| glow | 298 | -1 / 0 / 1 | 17 % | 2 / 5 / 8 / 15 | 0.2 / 0.32 / 1.0 s | 0.67 / 1.16 / 1.52 | 0.82 | 1 / 4 | grow 63 % |
| crack/burn/ground | 208 | 0 / 0.1 / 1 | 9 % | 1 / 2 / 10 / 30 | 0.5 / 1.0 / 2.1 s | (Size 9.8 / 17.6 / 35.9 studs) | - | 1 / 3 | grow 57 %, const 40 % |

So the library's explosion is: a flash about as wide as the main ring living a third of the ring's life and shrinking,
rings that grow from 0, smoke at ~0.45 D living 2.5x the ring, sparks at ~0.13 D, and a ground mark ~1 s.

---------------------------------------------------------------------------------------------------------------

## a. The 7 effects

### `d0bab8f5b533` ExplosionPack/LightingBurst (2026 part 2) - red-to-violet lightning burst, ~0.5 s visible, D ~98
- 79 emitters on one 0.001-stud Part, all single bursts at t=0, 291 particles. One shared colour ramp on **all 79 layers**:
  `#FFA070 -> #A070FF -> #CCBEE2` (peach, violet, lavender).
- Phases (Measured, recapture): **0.03** nothing yet (the first capture showed a red-orange wash here: giant soft red
  rays, three white toon puffs with red rims, a long thin ray, p50 (238,74,32)); **0.10** red-orange spiky star core
  with red needle rays (one long red ray across the frame), a thin vertical white ray, white-violet lightning bolts
  around it, 17.0 %, p90 (255,194,214); **0.20** white-violet lightning mass with red and violet arcs, 18.2 %, p50
  (220,162,223); **0.35** lavender lightning squiggles inside big faint violet arcs (a dome of crescents), red streak
  bits, a darker core behind the lightning, 6.2 %, p50 (130,137,179); **0.55** gone except faint arc traces (est.
  length 1.05 s is the invisible tail of `14329791140` at Tr >= 0.61).
- Roles: flash = `12764529137` (Size 371 -> 0 in 0.132 s, LE 1 Br 6, Squash -0.5: the giant rays), `9710916533` /
  `71588252451469` (~87, LE -1 Br 55, 0.06-0.14 s), `11187665050` (spiky star 88 -> 0, LE -2 Br 10, 0.087 s), pinpoints
  `80503196424138` / `138354400511840` (27 -> 0, 0.05-0.11 s), front cross flares `13711999895` / `14128174572` (const
  70, Tr 1 -> 0.47-0.79, ZOffset 15); glow `14045123768` (0 -> 185, LE -5 Br 25) + `6679618752` (const 166, Tr 0.74);
  ~15 shock-ring layers (`74406026456360`, `70929015970253`, `124692159307028`, `79288998225061`, `112778373890022`,
  `92949373282527`...) 0 -> 41-117; spiky ring `14538969234` (LE -2 Br 55); crescents `17085222506` x15+15; lightning
  `11862032588`, `12848554034`, `13420962998`, `103745196712409`; sparks `7136536841` x59 and `80987425145271`; puffs
  `16867514432` x25, `79034116104407` / `93675353995344` (shoot-and-stop).
- What makes it work: the shared ramp tells the colour story by lifetime alone (d.7); rings in every orientation build a
  sphere, not a disc (d.9); sparks paired with a black twin (d.5) and a Squash morph (d.14); flares pushed to ZOffset 15.
- Weak: in the first capture the 0.03 frame was a 17.5 % red wash with straight card edges (the 371-stud card; the
  recapture did not catch that frame); 79 layers and 15 ring variants for 0.45 s of screen time; the red persists on
  LE<0 layers long after the ramp says lavender (d.28).

### `8f69477f9552` IceExplosion (2026 part 2) - pale-blue swirl burst with ice shards and a glowing crack web, ~2 s, D ~50
- 42 emitters, 274 particles, all at t=0. Colours `#B9E9F6`, `#90C6DF`, `#8EC2DB`, slate `#4D6976`, `#3A5759`. All the
  `particle*` emitters sit at **ZOffset 10-12**, the rest at 0-3: the whole burst draws over the ground layers.
- Phases (Measured, recapture): **0.03** a small bubble of thin tilted rings with specks inside, about a quarter of the
  later size, 1.2 % (it grows from 0 instead of popping); **0.10** peak, a white ball of tilted swirl rings packed with
  crystal blobs and radial streaks, 21.6 %, p90 (250,255,255); **0.20** crystals and specks flying out, swirl arcs, and
  a **glowing crack web appears on the ground**, 23.8 %; **0.35** the crack web, a flat swirl ring round it, specks
  rising above, 6.8 %; **0.55-0.80** crack web, dim pale smoke puffs, stray specks, 5.0 -> 3.3 %; **1.2** crack web and
  faint smoke, 1.6 %; **1.8** the crack web fading, 0.3 %; **2.6** gone.
- Roles: core `127136593142768` (starburst 22 -> 0, 0.083 s, LE -1 Br 50) + glow `14045123768` (0 -> 40, LE 0 Br 3);
  rings, all random-orientation (SpreadAngle (360,-360)): `15269685466` x9, `14687560696` flipbook (LE -1 Br 40, flies
  out at Speed 69-173), `17409991165` x7, `11037067793` (LE 1 Br 2.5 in slate `#4D6976`), `133650067075481`,
  `17323225068`, `109920824813240`, wind rings `7394759196` / `14850595833` (0.4-1.3 s); shards `14005903992`
  (VelocityParallel, LE 1 Br 30), `134022882058457` and `92176991886542` (Acc +11.6 / +20.5 Y), `17865388433`; sparks
  `11448304274` x15 (Squash 1.61 -> 0.3); orbit specks `16171528032` / `17334135713` / `12386378844` x25 each; smoke
  `16867387523` / `16867447521` x15 each, `14148906175`; linger `138231890129613` x15 (Tr 0.9), `96092264894202`;
  ground `11189079998` (slate `#3A5759` at LE 1 **Br 65**, 2 s), lit swirls `73249515680342` / `104922764134050` (LI 1).
- What makes it work: a gyroscope of thin rings reads "energy" before anything else (d.9); the crack web
  `11189079998` (const 26.5 = 0.53 D, slate at Br 65) is the payoff that stays from 0.2 to ~1.8 s, the same ending as
  Jingliu's crack star; fade-in-and-out specks give a second sparkle beat at 0.35-0.55 (d.17); dark colours at huge
  Brightness give exact hue control (d.27).
- Weak: no real dark tone (slate additive and lit smoke only), so the peak is a white ball; the LI 1 swirls
  (`73249515680342` / `104922764134050`) show as dark slate cards with straight edges at 0.10-0.35 (e.7); 30 linger
  smokes at Tr 0.9 are faint (visible only as a pale haze at 0.55-1.2); `11448304274` has Transparency -50 (out of
  range, effect unclear).

### `f8b7b6d9d087` Jingliu IceExplosion (190 OS) - ground ice burst with frost crack, ~1.2 s, D ~40
- 36 emitters, 151 particles, all at t=0, emitted by `VFXHelp.EmitAndRemove` at the mouse hit (an `icespike` model is
  spawned separately). Colours `#87BAFF` and white.
- Phases (Measured, recapture): **0.03** white-out, 70 % of the frame brightened, p50 (199,222,236): a huge jagged
  white burst and hard-edged cards; **0.10** upright white spikes over a flat white ground starburst with radial streaks,
  one snowflake, big translucent grey sheets on the floor (the white LE 0 swirl pairs), 62 %; **0.20** long icicle
  shards and snowflakes thrown up and out, blue toon smoke at the base, the frost-crack star forming, 53 %; **0.35**
  snowflakes and sparkles above the crack star, blue smoke drifting out, 25 %; **0.55-0.80** crack star, smoke, 4-point
  sparkles, 22 -> 19 %; **1.2** faint smoke and dots; **1.8** gone.
- Roles: flash `18118762332` (51 -> 0 in **0.0153 s** = one frame), solid white star `18601496949` (LE 0 Br 5, 54 -> 0,
  0.057 s), `18601630691` (2x2, LE 1 Br 25, 0.04-0.075 s); upright cards `90466590575911` (Impact1/3), `117575906316340`
  (Impact2) and `139297563566257`, VelocityParallel, 0.05-0.1 s; ground rings `18527700887` x3 layers (one whip-spinning),
  `17388367001`, `8048608283`, `18682835879`, `18682826321`, `18118833929`, `9326695061` x8 (Squash 0.1),
  `137206037294477` / `71156719204383` / `70487382117208` (0 -> 39); swirl pairs `109440284900004` + `127940423551603`
  (LE 0 white, 58-68); shards `111038288560190`; dots `72767385757082`, `75197275732699`, stars `116919342416403`,
  snowflakes `117575906316340` (the Impact2 texture again, at 2.4 studs); smoke `86416754715762` (8x8),
  `87367507830235`, `16867490141` (2.2-3.8 s), `82761263816477`, `18118931443`; cracks `83159820722985` x2 +
  `110316246218390` (LE 1 Br 3-6, 1 s).
- What makes it work: everything lies flat on the ground (EmissionDirection Top, spread 0-15) so it reads as a ground
  impact from any camera; a one-frame flash; the crack star is the payoff that stays 1 s; the snowflakes say "ice".
- Weak: the first frame is an over-exposed white wall (70 % of the frame) with straight card edges (`18601630691` and
  `18601496949` have spikes touching the image border); the only dark tone is grey: the 58-68-stud white LE 0 swirls
  cover the floor in flat grey sheets at 0.10-0.20 (e.7).

### `acb7087801ae` Fire explosion (2026 part 2) - toon fire burst with black flash and smoke, ~1.8 s, D ~37
- 66 emitters but only 91 particles (EmitCount 1-3), 4 Forge mesh models (all 1 s, out-cubic), a raycast debris module
  with a trail (script, missing). Est. length 16.6 s comes from ground decals (`196969716` 5-16.6 s, cracks 14.3 s).
- Phases (Measured, recapture): **0.03** only the white ring mesh, high above the ground (no particles yet); **0.10**
  hot white-yellow core, an orange 4-point star flare, orange radial streaks, pale white veils, the white ring halfway
  down, a black dome outline and black ground rings, 6.9 %, p50 (175,84,66); **0.20** core plus orange flame tongues,
  the ring now wide and low, a long pale veil streak, 4.4 %; **0.35** orange toon flames, red flame shards flying out,
  2.7 %, p90 (255,207,165); **0.55** flames gone dark red, black wisps rising, an ember, 0.9 %, p50 (201,69,54);
  **0.80** black smoke tendrils and 2 embers; **1.2** embers and a few dark debris flecks; **1.8** one ember; **2.6** gone.
- Roles: flash `17062452486` x3 + `17391818367` (25-33 -> 0 in 0.086 s), `73836552066678`, `16892268625`,
  `71292207805624` (0.057-0.07 s, LE 0 Br 15); **black flash** (attachment literally named "Black Flash"): `8133065785`
  (LE -8 Br 0, 0.15 s; LE -1 Br 0, 2.5 s), `119057920510209` x2 (LE -2 Br 0), `13521633748` x2 (LE 0 Br 0); white
  veils `71615994682305`, `15355409903`, `104474092334072`, `102939845623041`, `110371770198075`, `87604394896847`
  (LE 1 **Br 0.05-0.09**); flames `118323587821210` (8x8, LE -0.2 Br 30), `13486412595`, `101324652618658`,
  `16845391847`; dark smoke = the veil flipbooks again plus `125286709104562`, `132537238667080`, `80133022978198`,
  `16867383201`, `135127539536518` with `#A6623C -> #090503 -> #000000`, LE -1 Br 5, 0.86-2 s; sparks `17391818367`
  (swell to 8, LE -2 Br 50), `7246982406` (Acc -23.4 Y); embers `16171528032` (LE -2 **Br 200**, 1.85-3.7 s); ground
  `130848219849162` (orange -> black crack, 1.8 s), `196969716` scorch, `85474069372331`, `11155929795`, `77518832892114`,
  wind rings `15556415618`, `18838828771`, `18838832554`, `12402897209`, `7216856024`.
- Meshes: a ForceField ring (mesh `7472102456`) drops from y 17.7 to 0.46 while widening 6.7 -> 38.5 (Transparency
  0.85 -> 1; Seen: high at 0.03, halfway at 0.10, wide and low at 0.20); a swirl (mesh `18739246604`) sinks 2 studs, widens 1.85x, flattens 3.6x, spins 1.5 -> 0 rad/s; an inverted
  dome (mesh `17700114556`, negative SpecialMesh Scale) widens 2.5x, flattens 4x, spins 5 -> 0 rad/s; their decals use
  Color3 above 1 (2.35 and (11.8, 11.8, 117.6)).
- What makes it work: black flash behind the hot core (d.4); one flipbook used as a fast pale veil and as slow smoke
  ramping to black (d.6); a few very bright embers carry the linger (d.18).
- Weak: the flash is small and short (<= 0.9 D, <= 0.086 s, LE <= 0.5) so the peak frame has no white pop (6.9 %); most
  layers emit 1 particle in a random direction, so the shape changes a lot per play; 16.6 s decals invisible after 1.8 s.

### `b65c89df275e` Cinnamon FxStorage/Explosion (190 OS) - flash pillar, gold star cloud, glowing sigil, ~1.2 s seen
- 10 emitters, 221 particles (190 of them sparks), one Attachment. No ring: the ground sigil (Size 10) is the scale.
- Phases (Measured, recapture): **0.03** nothing yet (the first capture showed the flash here: an orange glow with a
  very tall thin vertical light pillar and a black smoke ring silhouetted over it, p50 (255,126,26)); **0.10** the sigil
  flat on the ground, glowing pale gold, gold 4-point stars bursting up from it, black smoke wisps above, 21.4 %, p50
  (255,202,135); **0.20** sigil plus a spreading star cloud, 25.0 %; **0.35** sigil plus stars higher and wider,
  17.4 %; **0.55** stray stars only, the sigil gone, 0.8 %; **0.80** a few specks; **1.2** a sliver of the sigil, 1.1 %;
  **1.8** gone (the first capture showed the full sigil at 1.2-1.8).
- Roles: `14834550802` (70 -> 0, 0.095 s, LE 1 Br 15, FacingCameraWorldUp) + `15294279094` (20.5 -> 0 with **Squash
  0 -> 10.6** = the pillar); specs `15472703101` + stars `107982202716468` (x95 each, LE 0 Br 15, 1.28 -> 0.035/0.285);
  smoke `14875600193` / `15105860974` (LE 0 **Br 0** = black, const 15, Tr 0.81); sigil `130344359336812` (LE 1 Br 15,
  2.45 s); scorch `14926541120`, `16673259523`, `16728366909` (Br 0, 3 s).
- What makes it work: a flash that is also a light pillar (d.13); 190 tiny solid-bright (LE 0) stars that never wash out;
  a designed glyph as the linger.
- Weak: no shock ring; the 2.45 s sigil comes and goes: recapture shown 0.10-0.35, hidden 0.55/0.80/1.8, a sliver at
  1.2; first capture hidden 0.10/0.20/0.55, shown 0.35/1.2/1.8. Inferred: the three 15-stud black scorch sprites and the
  10-stud sigil are co-planar at ZOffset 0 and their draw order flips frame to frame (e.3).

### `c5645c4c7d50` Cid Slashes3 (2026 Mar-April) - third hit of a sword combo, a flat slash-line burst, ~0.5 s, D ~13
- 39 emitters, 311 particles, all at EmitDelay 6.2 s (timed to a combo). Purple `#9336B5` / `#CB4AFB` / `#A62ED2`.
- Phases (Measured, recapture from 6.23 s): **6.23** white-violet over-exposure, 43.6 % of the frame, p50
  (255,221,254): a long flat band of streaks along the slash line and a large vertical card with straight edges;
  **6.30** the band thins to a violet slash line with a 4-point star glint at its far end, first purple smoke and
  shards, 20.3 %, p50 (224,103,234); **6.40** purple smoke clouds rising along the line, streak remnants, 16.8 %,
  p50 (151,43,180); **6.55** shard and flame bits along the line, smoke fading, 3.3 %; **6.75** faint smoke and specks;
  **7.0** gone. The data's 7.45 s flames and 7.77 s grey smoke are not visible: the smoke reads purple (Inferred: the
  `131290109763904` flipbook, x70 in `#CC53F8`), the grey LI 1 smoke does not show.
- Roles: flash `10556525755` x8 (on-black cross, **Br 100**, VelocityParallel with **negative Speed -339..-130**, Squash
  0.4 / 2, 34 -> 0 in 0.163 s, ZOffset 4.7), `13189667061` (26, 0.042 s), `83841937662573`; impact stamps, every one
  VelocityPerpendicular with **Squash const -3** and an additive + negative-LE twin: `127057910167957` (13.2 LE 1 /
  14.2 LE -1), `87962185594365` (13.2 / 14.2), `86784509554212` (10.2 / 10.9 LE -3), `16940439225` (6.9 / 7.4 LE -3),
  `137532295078891`, `11862051043`, `135690160721179` (2x2), `119373840389661` (LE -8); sparks `15431912045` x25,
  `6444340454` x25, `131290109763904` (8x8, x70), `107423905441539` / `87442265401764` / `15989904878` (x30 each, Acc -107 Y);
  flames `15413764911` x10 (LE 0.45 Br 7, Squash 0.3 -> 1.39 -> 0); smoke `18326864825` (grey, LI 1, x14).
- What makes it work: Squash -3 flattens all hit stamps into the slash plane, Seen as one long flat band (d.12); the
  smoke and shards stay on the slash line, so the hit reads as a cut, not a ball; falling sparks (Acc -107) sell weight.
  The additive + negative-LE twin stamps (d.5) do NOT show a dark outline in the stills: everything reads saturated
  violet (d.28).
- Weak: 311 particles for one sword hit; a 43.6 % white-out with a straight-edged card on the first frame (e.1, e.2);
  a hard-coded 6.2 s delay (reuse needs re-timing).

### `f9ef4f62abcb` BigExplosion (2026 Mar-April, "excalibur morgan stuff") - 250-stud nested fireball, ~1.2 s with a 0.6 s stream
- 8 nested ellipsoid MeshParts, one mesh (`11067917371`, 0.93 aspect): Core 125 Neon, CoreShade1 128.7 Neon, CoreShade2
  126.6 ForceField, Middle 144 Neon, Inside 214 Neon + InsideShade1 216 ForceField, Outside 245 Neon + OutsideShade 250
  ForceField. Measured on the first capture: core flat orange (255,173,75) with a red rim (255,45,55), pale lilac shell
  (240,208,255), deep purple inside (41,24,106) carrying the ForceField pattern, red-pink outer rim. Static in every
  still (no animation script).
- Phases (Measured, recapture; particles stream 0-0.6 s, so the timing is the replayer's; layer attributions Inferred):
  **0.03** shells only; **0.10** red flame spikes at the base of the shell (`14635196973`, red, Squash 0.06), first orange sparks, 0.7 %;
  **0.20** pink-lavender lightning wisps across the shell (`15691415178` / `17006190392` / `130816273370709`), orange
  spark flakes (`125765563402572`), a red crescent, **black vertical streaks** (`14635196973` black copy at Br 0 and
  `89779528189516` LE -5 Br 0), 7.7 %; **0.35** a dark purple-black curtain fills the inner shell behind the core,
  fiery streaks over the core, pink bubbles (`6889406585`), grey smoke, 6.6 %; **0.55** a magenta glowing rim swirl on
  the shell, dark interior, a fire-toothed core, 12.2 %; **0.80** grey smoke, a white wind swirl round the core, a huge
  red crescent sweeping the foreground, pink bubbles, 15.3 %; **1.2** a faint wind line and embers; **1.8** shells only.
- 70 emitters, all Rate-driven, 40 of them dead (4 disabled `Main` + 36 `X`/`Y`/`Z` at Rate 0, Size 0; leftovers of a
  tool). The 30 live ones are world-scale: `11871320339` / `11867465395` / `11866744589` (0 -> 1000, Speed 450), `17226921546`
  (0 -> 650), `16863839438` (0 -> 476, LE -2 Br 150, Speed 2290-2400, Drag 10, Squash 2.17 -> -0.6), `14267547915`
  (const 82, Br 150, Squash 0.1, ZOffset 16.1, plus a dark `#23073B` twin at 175 and ZOffset -1), `8120666025`
  (swell to 93, **Br 155 at Transparency 0.99**), `6889406585` (LE **-15** Br 45, ZOffset -55), `125765563402572`
  (Speed 900-2000), ramp `#FF0B23 -> #230D42 -> #1B0C67` on `77189927291566`, `13828988163`, `16867383201`,
  `13726311040`, `138270984714302`, `14987238761`, `117280660128652`.
- What makes it work: Neon + ForceField shell pairs at +1-3 % size = solid glowing body with an animated patterned rim
  (d.26); a dark interior curtain behind the bright core (Inferred: the `#23073B` Orb twin at 175 studs, ZOffset -1,
  plus black `77189927291566` smudges) makes core and rim pop (d.33); black streaks via Brightness 0 (d.4); the
  crescent `14002915397` is dark maroon `#78080F` but at LE -1 Br 45 renders vivid red (d.28); colour ramps that end
  in navy (d.8).
- Weak: unplayable as a burst (Rate-driven, script-dependent, MiddleGlare Rate 15,151,515/s); 40 dead emitters; no
  evidence of how the shells grow or fade; very busy at 0.55-0.80 (crescent, smoke, bubbles, lightning all at once).

---------------------------------------------------------------------------------------------------------------

## b. Anatomy of an explosion effect

Unit: **D** = peak Size of the effect's main ring (LightingBurst 98, Ice 50, Jingliu 40, Fire 37, Cid 13 studs). All
layers fire at t=0 as single bursts (88 % of library designs carry EmitCount); the order on screen comes only from
lifetimes. LI 0 everywhere unless noted. "Tr a -> 1" = Transparency starts at a and ends at 1.

| # | Role (tone) | Texture role, ids | LE / Br | Lifetime | Size curve, peak | Transparency | Speed / Drag / Spread | Orientation, Squash, flipbook | Count, ZOffset |
|---|---|---|---|---|---|---|---|---|---|
| 1 | **Flash pop** (white) | spiky starburst `18118762332`, `11187665050`, `127136593142768`; soft flash `12764529137`, `14834550802`; 4-point star `17062452486`, `17391818367`, `10556525755` | 1 / 3-15, or -1..-5 / 25-55 (Br 100 on an on-black cross); solid: 0 / 5-15 | 0.015-0.16 (median ~0.09) | **shrink** from peak to 0 (17 of 25 here); peak 0.45-1.35 D, typical ~1 D; one giant 3.8 D card | 0 flat | ~0.001-0.01 (orientation only) | FacingCamera (some WorldUp / VelocityParallel); Squash 0.5 or -0.5 | 1-3; z 1-5 |
| 2 | Solid hot star (white) | `18601496949`, `11187665050`, `73836552066678`, `16892268625` | 0 / 5-15 (LE -2 Br 10) | 0.05-0.09 | shrink, 0.5-1.35 D | 0 | ~0 | FacingCamera or flat | 1-3; z 1-5.5 |
| 3 | Bloom glow (body) | `14045123768`, `6679618752`, `15601489180`, `13189667061` | 1 / 3-5, 0 / 3-15, or -5 / 25 | 0.06-0.45 | grow 0 -> 0.8-1.9 D (one const 1.7 D) | starts 0.69-0.74 -> 1 | ~0 | FacingCamera | 1; z -1..1 |
| 4 | Black flash (ink) | `8133065785`, `119057920510209`, `13521633748`; black streaks `14635196973` / `89779528189516` (BigExplosion) | 0..-8 / **0** | 0.15-0.2 (ring copies 1-2.5 s) | grow 0 -> 0.65-1.9 D (streaks const, Squash 0.06-0.08) | 0 | ~0.03-0.15, spread +-360 (streaks 117 up) | FacingCamera + a flat copy (streaks VelocityParallel) | 1-2; z 1-15 |
| 5 | Upright impact card (white) | `90466590575911`, `117575906316340`, `139297563566257` | 1 / 3-10 | 0.05-0.1 | swell to ~0.9 D at 97 % or shrink 1 D -> 0 | 0 | 0.004 up | **VelocityParallel**, dir Top | 1; z -0.5..1 |
| 6 | Shock rings (body) | thin/soft rings `18527700887`, `15269685466`, `17409991165`, `18682826321`, `74406026456360`, `79288998225061`; ring flipbooks `14687560696`, `124692159307028`, `70929015970253`, `17323225068` | 1 / 1-3 (soft) or 0..-1 / 8-40 (flipbooks, solid) | 0.1-0.8 (median ~0.3) | grow 0 -> 0.6-1.2 D | soft: starts 0.35-0.81 -> 1; flipbook: 1 -> 0 at 6 % -> 1 | 0.001-0.04 (one flipbook flies out at 69-173) | VelocityPerpendicular; spread 3333 or (360,-360) = random tilt, or dir Top + 0-15 = flat; Rotation +-360, RotSpeed +-25..250 | 1-7 per layer, 3-15 ring layers; z 0-1 |
| 7 | Spiky shock (body) | `14538969234`, `133650067075481`, `8048608283`, `87640706669094` | -0.5..-2 / 25-55, or 1 / 1-3 | 0.28-0.75 | grow 0 -> 0.4-1.2 D | 0 | ~0.001-0.03 | VelocityPerpendicular | 1-3; z 0.2-4 |
| 8 | Streak rays / needle sparks (white) | `7136536841`, `80987425145271`, `111038288560190`, `11448304274`, `15431912045` | 1 / 15-35 (+ black twin 0 / 0) | 0.13-0.6 | swell 0 -> 0.1-0.25 D @5-13 % -> 0 (or shrink) | 0 | 18-412, Drag 0-10, spread 75-3555 | VelocityParallel or FacingCameraWorldUp; Squash 1.4-1.6 at start (or -3 -> +1 -> -2) | 4-36; z 0-3.3 |
| 9 | Flame tongues / shards (body) | `14005903992` = `15413764911` (same art), `92176991886542`, `118323587821210`, `101324652618658`, `134022882058457` | 1 / 20-30, 0.15-0.5 / 7-15, or -1 / 20 | 0.15-1.9 | grow 0 -> 0.25-0.5 D | 0 | 8-267, Drag 7-17; Acc +11..+20 Y on some | VelocityParallel or FacingCamera; Squash 0.3 -> 1.4 @45 % -> 0; 4x4/8x8 OneShot | 3-5 per layer, x2-4 layers; z 0-11 |
| 10 | Lightning crackle (optional, white-violet) | `11862032588`, `12848554034`, `13420962998`, `103745196712409`, `127057910167957` | -1 / 25-35 (inner copy 1 / 3) | 0.06-0.54 | grow 0 -> 0.35-0.6 D | 0 (inner: 1 -> 0 @20-76 % -> 1) | 0.1-50, Drag 5-35 | VelocityParallel / Perpendicular, spread 360-3333; 4x4 OneShot | 2-6; z -2..3 |
| 11 | Sparks / specks (white) | dots `16171528032`, `17334135713`, `72767385757082`; stars `15472703101`, `107982202716468`, `116919342416403`, `17391818367` | 1 / 15-20, 0 / 15 (solid), -2 / 50-200 (embers) | 0.25-2 (embers 1.85-3.7) | 1.3-4.75 studs (0.04-0.13 D); swell @5-55 % or shrink | 0, or 1 -> 0.05 @50 % -> 1 (specks fade in) | 20-412, Drag 3-10 (travel ~ Speed/Drag = 0.5-1 D); Acc -23..-107 Y on some | FacingCamera (streaks VelocityParallel) | 10-95 per layer, 30-190 total; z 0-2 |
| 12 | Smoke body (mid / dark) | toon puffs `16867387523`, `16867447521`, `14148906175`, `86416754715762`, `16867514432`, `74149687949243`, `16867383201`, `14875600193` | 0 / 1 (pale), 0 / 0 (black), 1 / 5-10 (tinted), -1 / 5 (ramp to black) | 0.25-2.15 | grow 0 -> 0.3-0.75 D | starts 0.5-0.84 (pale) or 0 (dark) -> 1 | 24-301, Drag 6-12, spread 40-360 (shoot-and-stop: 89-1220 at Drag 11-18) | FacingCamera; 4x4/8x8 OneShot; RotSpeed +-50..500 | 4-25 per layer; z 0-3.5 |
| 13 | Ink smoke (dark) | same flipbooks as 9/12 (`15355409903`, `101324652618658`, `104474092334072`, `16867383201`) | -1 / 5 with `#A6623C -> #090503 -> #000000`; or 0 / 0 | 0.86-2.07 | grow 0 -> 0.26-0.7 D | starts 0.16 -> 1 | 20-170, Drag 6-9 | VelocityParallel / FacingCameraWorldUp; Squash 0 -> 0.34 | 1-3 per layer, ~10 layers; z 0 |
| 14 | Ground mark (linger) | cracks `83159820722985`, `110316246218390`, `130848219849162`; glow sigil `130344359336812`; slate crack `11189079998`; scorch `196969716` | 1 / 3-15 (glow), 0 / 15 -> black, 1 / 65 on slate; scorch -0.5..0.3 / 0-0.5 | 1-2.45 (scorch 5-16.6, too long); Seen to 0.8 s (Jingliu) and 1.8 s (Ice) | grow 0 -> 0.5-0.7 D (cracks pop to full in ~6 %), or const (Ice 0.53 D) | 0 -> 1 (scorch 0.6) | 0.002-0.1 | VelocityPerpendicular, dir Top | 1-2; z 0.1-2.1 |
| 15 | Linger smoke / dust | `16867490141`, `138231890129613`, `96092264894202`, `18118931443` | 0-0.15 / 1-5 | 1.2-3.8 | grow 0 -> 0.15-0.6 D | starts 0.25-0.9 -> 1 | 16-225, Drag 5-6; spread (0,180) = flat fan | FacingCamera | 4-15; z 0-3.5 |

Pairs worth remembering: rings 6 come in 2-15 variants per effect; every bright role (1, 8, 9) has a dark twin in the
best effects (4, 13, the Br 0 black spark twin, BigExplosion's dark interior). Cid's negative-LE stamp twins were meant
as outlines but read saturated, not dark (d.5).

---------------------------------------------------------------------------------------------------------------

## c. Timing

Times in s from the trigger (Cid: from its 6.2 s delay). BigExplosion is left out: its 0.6 s stream is the replayer's.

| Phase | LightingBurst | Ice (8f69) | Jingliu | Fire explosion | Cinnamon | Cid | Generic (recipe) |
|---|---|---|---|---|---|---|---|
| Flash | 0 -> 0.1 (first capture: red wash at 0.03) | none (grows from a small bubble, 1.2 % at 0.03) | 0 -> 0.06 (white-out at 0.03, 1-frame flash) | -> 0.09 (not caught: 0.03 shows only the ring mesh) | 0 -> 0.1 (+ pillar; first capture only) | 0 -> 0.1 (43.6 % at 0.03) | 0 -> 0.09 |
| Peak (most screen) | 0.10-0.20 (17-18 %) | 0.10-0.20 (22-24 %) | 0.03 (70 %) | 0.10 (6.9 %) | 0.10-0.20 (21-25 %, sigil + stars) | 0.03 (43.6 %) | 0.03 -> 0.15 |
| Break-up (lightning, flames, sparks, smoke) | 0.2 -> 0.35 | 0.2 -> 0.35 | 0.1 -> 0.35 | 0.2 -> 0.55 (flames darken) | 0.35 -> 0.55 (stars) | 0.1 -> 0.35 (smoke, shards) | 0.15 -> 0.45 |
| Linger | none | 0.35 -> 1.8 (crack web, dim smoke, specks) | 0.35 -> 0.8 (crack star, smoke) | 0.55 -> 1.8 (black smoke, embers) | (sigil meant to 2.45, hidden after 0.35) | none (faint smoke at 0.55) | 0.45 -> 1.6 (crack), embers to ~2.8 |
| Gone | 0.55 | 2.6 | 1.2-1.8 | 2.6 | 1.8 | 0.8 | ~2.8 |

How much they vary: the flash is always <= 0.1 s (one frame to 6 frames). Peak coverage lands on the first still where
the flash is big (Jingliu, Cid) or at 0.10-0.20 where the body grows (LightingBurst, Ice, Cinnamon, Fire). After the
peak the bright area halves about every 0.07-0.15 s (LightingBurst 18.2 -> 6.2 -> 0 % at 0.2 / 0.35 / 0.55; Cid 43.6 ->
20.3 -> 16.8 -> 3.3 % at +0.03 / +0.1 / +0.2 / +0.35; Jingliu slower, 70 -> 62 -> 53 -> 25 -> 19 % at 0.03 / 0.1 /
0.2 / 0.35 / 0.8, held up by its crack star and smoke). Visible length runs from 0.5 s (LightingBurst, Cid: no linger)
to ~1.8-2.6 s (Ice's crack web, Fire's embers). Library ratios: flash life ~0.3x ring life, smoke ~2.5x, sparks ~1.1x.

---------------------------------------------------------------------------------------------------------------

## d. Techniques catalogue (exact recipes)

Flash and core
1. **Shrink-from-peak flash.** Size `{0, ~1 D}, {1, 0}`, Lifetime 0.05-0.15, count 1-3, FacingCamera. 17 of the 25 flash
   layers here; 161 of 294 library flash layers. It pops at full size on frame 1 (extends PATTERNS 2 with numbers).
2. **One-frame flash.** Lifetime 0.0153 s, Size 51 -> 0, LE 1 Br 5 (`18118762332`, Jingliu): exactly one frame at 60 fps.
3. **Solid white flash.** LE 0, Br 5, white, starburst `18601496949`, 0.057 s (Jingliu): a toon white shape that does
   not bloom-wash. Same idea for sparks: Cinnamon's 190 gold stars at LE 0 Br 15.
4. **Black via Brightness 0.** LE <= 0, LI 0, **Brightness 0** renders black whatever the Color (Fire "Black Flash":
   `8133065785` LE -8 Br 0 0.15 s, `119057920510209` LE -2 Br 0; Cinnamon smoke LE 0 Br 0; LightingBurst spark twin
   LE 0 Br 0; BigExplosion `14635196973` black copy LE 0 Br 0 and `89779528189516` LE -5 Br 0). Seen: black dome outline
   and ground rings (Fire 0.10), black wisps (Cinnamon 0.10-1.2), black vertical streaks (BigExplosion 0.20-0.35).
   Mechanism Inferred.
5. **Ink twin.** Duplicate a bright layer with identical motion as a dark copy: LE 1 Br 35 + LE 0 Br 0, same Speed and
   Squash curves, ZOffset 2.99 / 2.98 (LightingBurst `7136536841`, 15+36 bright / 4+4 dark); or LE 1 + LE -1..-3 with
   Size x1.05-1.1 and ZOffset -0.5, meant as a dark outline (Cid: 13.2 / 14.2, 6.9 / 7.4, 10.2 / 10.9). The Br 0 twin
   works; Cid's negative-LE twins (Br 8-25) show no dark outline in the recapture, only saturated violet (d.28), so
   for ink use Brightness 0, not negative LE.
6. **One flipbook, two jobs.** The same flipbooks fire twice in Fire explosion: as a white LE 1 **Br 0.05** veil at
   Tr 0.16, Speed 70-413, Drag 19-28, life 0.35-0.53 (fast pale gust) and as `#A6623C -> #090503 -> #000000`
   LE -1 Br 5 smoke at Speed 20-170, Drag 6-9, life 0.86-2 (slow, ends black). Pale-then-dark from one asset set.
7. **One colour ramp on every layer.** LightingBurst puts `#FFA070 -> #A070FF -> #CCBEE2` on all 79 layers; short
   layers flash through it, long ones sit in the lavender end, so the screen goes red-orange (first capture p50
   (238,74,32) at 0.03; recapture red-pink p90 (255,194,214) at 0.10) -> pink-violet p50 (220,162,223) at 0.20 ->
   lavender-grey p50 (130,137,179) at 0.35 with no tracks.
8. **Ramp to ink.** End the colour at black or navy so a layer turns into its own shadow: Fire smoke `-> #000000`, Fire
   crack `#F35529 -> #000000`, BigExplosion `#FF0B23 -> #230D42 -> #1B0C67`, Fire trail `#FF6342 -> #571000 -> #000000`.

Rings and shock
9. **Gyroscope ring shell.** VelocityPerpendicular + Speed 0.001-0.006 + SpreadAngle 3333 (or (360,-360)) + Rotation
   +-360 + RotSpeed +-25..250: rings tilted in every direction make a sphere (Ice 0.03, LightingBurst 0.20). Ice ~14
   and LightingBurst ~18 layers use it.
10. **Ground-flat rings.** EmissionDirection Top + VelocityPerpendicular + Speed 0.003-0.04 + SpreadAngle 0-15 (all of
    Jingliu's rings). Rings stay on the floor from any camera.
11. **Whip-spin ring.** RotSpeed +-3510 deg/s, Lifetime 0.026-0.049, Size 0 -> 0.73 D, LE 1 Br 15 (`18527700887`,
    Jingliu): 2-3 frames of a spinning blur at the start; its sibling copies spin +-249..589 for 0.15-0.7 s.
12. **Flattened stamps.** Squash const -3 on VelocityPerpendicular impact flipbooks (all 14 of Cid's stamps); Squash 0.1
    on 8 ground rings (`9326695061`, Jingliu); Squash 0.06-0.1 on VelocityParallel world-scale sprites (BigExplosion).
13. **Light pillar from a flash.** FacingCameraWorldUp, Size 20.5 -> 0, **Squash 0 -> 10.6** over 0.095 s, LE 1 Br 15
    (`15294279094`, Cinnamon): a thin vertical beam through the frame on the first frames, next to a 70-stud soft glow.
    Seen in the first capture only (the recapture's 0.03 still came before it and 0.10 after it).
14. **Squash-morph sparks.** FacingCameraWorldUp, Size swell 0 -> 10-18 @9 % -> 0, Squash -3 -> +0.4..1.6 @9 % ->
    -2.85..0, Lifetime 0.13-0.42, Speed 18-62, SpreadAngle 3555 (`7136536841`, LightingBurst): wide -> needle -> wide.
15. **Shoot-and-stop puffs.** Disc shape, FacingCamera, Speed 89-1220, Drag 11-18, life 0.04-0.44, Size 15-21
    (`79034116104407`, `93675353995344`): puffs jump out a fixed distance and freeze (PATTERNS 2 high Drag, on smoke).
16. **Upright impact card.** VelocityParallel + EmissionDirection Top + Speed 0.004 + Size 33-40, life 0.05-0.1
    (`90466590575911`, Jingliu): a jagged white burst standing on the ground for 3-6 frames.
17. **Second sparkle beat.** Off-centre dots `16171528032`, `17334135713`, `12386378844`, Size const 2, Speed 180-240,
    Drag 8.69, Transparency `1 -> 0.05 @46-54 % -> 1`, x25 each, life 0.4-1 (Ice): invisible at the flash, peak around
    0.35-0.55 s as a ring of specks.
18. **Hero embers.** `16171528032` at LE -2 **Br 200**, Size 2.69 -> 0, Speed 22-79, Drag 3.24, RotSpeed 97-162,
    life 1.85-3.7, only 4 (Fire): 2-3 hot dots still visible at 0.8-1.2 s carry the linger alone.
19. **Weight.** Sparks with Acc -107 Y (Cid `107423905441539`...), -23.4 Y (Fire `7246982406`); flames with Acc +11.6 /
    +20.5 Y (Ice) rise.
20. **Negative Speed.** VelocityParallel streak flashes at Speed -339..-130 (Cid `10556525755`): they fly against the
    emission direction (toward the slash origin). Inferred use: recoil streaks.
21. **Sizes chained to D.** Flash ~1 D, glow 0.8-1.9 D, rings 0.6-1.2 D, flames 0.25-0.5 D, smoke 0.3-0.75 D, cracks
    0.5-0.7 D, sparks 0.04-0.13 D (here and in the 272-effect library sample).
22. **Brightness by area** (confirms the vault rule with numbers): Br 0.05-0.16 on 15-40-stud veils, Br 1-3 on rings,
    Br 15-35 on 1-18-stud sparks, Br 50-200 on 2-stud embers and on a 22-stud, 0.083 s core flash (Ice).
23. **Soft start on big additive rings.** Start Transparency 0.35-0.81 on LE 1 rings so 10+ overlapping rings stay
    readable (LightingBurst `tr 0.47..0.81 -> 1`, Ice wind rings 0.5-0.68).
24. **One-frame fade-in on solid ring flipbooks.** Transparency `1 -> 0 @6 % -> 1` (`70929015970253`,
    `124692159307028`): no hard first frame.

Meshes and extras
25. **Forge mesh slam ring.** Model {Start, End}, 1 s, out-cubic: ring (mesh `7472102456`, ForceField) from y +17.7 to
    +0.46 while Size 6.7 -> 38.5 and Transparency 0.85 -> 1 (Fire): a ring that falls onto the ground and spreads (Seen:
    high at 0.03, halfway at 0.10, wide and low at 0.20; it is the only thing on screen before the particles).
26. **Neon + ForceField shell pairs.** Each Neon shell gets a ForceField twin 1-3 % larger (125 / 126.6 / 128.7,
    214 / 216, 245 / 250; BigExplosion): flat glowing body plus a moving patterned rim.
27. **Hue by Color, intensity by Brightness.** Dark colours at high Brightness: slate `#3A5759` at LE 1 Br 65 (Ice
    crack), `#4D6976` at Br 2.5 for dim rings. Lets one layer be dim and exactly tinted.
28. **Negative LightEmission with high Brightness** (LE -1..-5 at Br 25-55; library: 26 % of explosion spark layers):
    lightning `11862032588` (LE -1 Br 35) reads white-violet and keeps edge contrast; red persists on LE < 0 layers after
    the ramp has gone violet (LightingBurst 0.35); the dark maroon `#78080F` crescent `14002915397` at LE -1 Br 45
    renders vivid red (BigExplosion 0.20-0.80; attribution Inferred: it is the only crescent layer); Cid's LE -1..-8 stamps read saturated violet. So in practice negative
    LE + high Brightness = a saturated, non-washing version of the Color, not a darkening. Exact maths unclear.
29. **Ground-coloured smoke** (Jingliu script): raycast 25 studs down from the effect, set `ColorSequence` of every
    emitter whose name contains "Smoke" to the hit part's Color. Free context matching.
30. **Inverted dome.** Negative SpecialMesh Scale (-0.075, -0.167, -0.078) -> (-0.187, -0.042, -0.194) (Fire): the shell
    is drawn inside-out; it widens 2.5x and flattens 4x while spinning 5 -> 0 rad/s.
31. **HDR decals.** Decal Color3 above 1 ((2.35, 2.35, 2.35); (11.8, 11.8, 117.6)) on Forge mesh decals (Fire): an
    overbright tint. Not visible in the stills, unverified.
32. **Z-grouping.** Push one whole sub-assembly to ZOffset 10-12 (Ice `particle*`) or flares to 15-16 (LightingBurst,
    BigExplosion), dark sprites to -1..-55: draw order by group, not per layer.
33. **Dark interior.** A large dark copy of the core sprite behind it (BigExplosion: Orb `14267547915` at Br 150,
    ZOffset 16.1 in front; its `#23073B` twin at 175 studs, LE 0, Transparency fading in to mid-life, ZOffset -1; black
    `77189927291566` smudges): from 0.35 s a purple-black curtain fills the shell and the core and rim pop against it.
    Attribution Inferred, the dark curtain is Seen.

---------------------------------------------------------------------------------------------------------------

## e. Mistakes and weak spots (avoid)

1. **White-out first frame.** Jingliu 70 % of the frame brightened at p50 (199,222,236), Cid 43.6 % at p50
   (255,221,254), LightingBurst a 17.5 % red wash (first capture). Cause: several large additive cards at once (Jingliu
   3 flash layers at 50-54 studs; Cid 8 Br-100 streak flashes at 18-34 studs on a 13-stud hit; LightingBurst a 371-stud
   card).
   Keep the flash about 1 D and give the core one solid (LE 0) shape instead of stacking additive ones.
2. **Visible card edges.** Straight cut lines in the first frames: `18601630691` and `18601496949` have spikes touching
   the image border (Jingliu, both captures); the 371-stud LightingBurst card shows its square (first capture); Cid's
   first frame shows a large vertical card with straight edges. Use textures with transparent margins or keep them
   small.
3. **Co-planar flicker.** Cinnamon's 10-stud sigil and three 15-stud black scorch sprites are flat at the same height and
   ZOffset 0; the sigil is hidden on 3 of 6 stills in the first capture and 4 of 8 in the recapture, on different
   frames each time (Inferred cause). Separate them by ZOffset (+0.1) or height.
4. **No dark tone.** Ice and Jingliu have only slate additive, LI 1 lit smoke and grey (white LE 0) swirls, so the peak is
   a white-blue blob. LightingBurst, Fire and BigExplosion carry explicit ink (Br 0 twins, ramp to black, a dark
   interior); Cid's negative-LE "outline" twins do not read as dark (d.5).
5. **Overbuilt.** LightingBurst 79 layers / 15 ring variants for 0.45 s; Cid 39 layers / 311 particles for one slash;
   BigExplosion 70 emitters with 40 dead (disabled, Rate 0, Size 0). 15-20 layers cover every role in b.
6. **Peak with no pop.** Fire explosion's flashes are <= 0.9 D, <= 0.086 s and LE <= 0.5; its brightest frame covers
   6.9 % and at 0.03 only the ring mesh shows. A burst needs one frame clearly brighter and bigger than the rest.
7. **Big pale non-additive sheets read as grey plastic.** Jingliu's white LE 0 swirl pairs at 1.4-1.7 D cover the floor
   in flat grey sheets at 0.10-0.20; Ice's LI 1 slate swirls show straight card edges at 0.10-0.35. Keep LE 0 layers
   small or dark; make big sheets additive with a soft start (d.23). (The first version listed a Cinnamon "dead beat"
   at 0.1-0.35 s here; the recapture shows the sigil bright with stars over that span, so it was a capture artefact.)
8. **Invisible long tails.** Fire's scorch/crack decals live 5-16.6 s but nothing is visible after 1.8 s; Ice's linger
   smoke at Tr 0.9 x30 (a faint haze at best); Cinnamon's 2.45-3 s sigil and scorch are hidden after 0.35 s. They cost
   memory and make the effect "last" 16 s for scripts that wait on it.
9. **Single-particle randomness.** Fire emits 1 particle per layer in a random direction (spread +-360): good variety,
   but some plays come out lopsided. Emit 2-3 smaller ones or narrow the spread.
10. **Timing locked to a cutscene.** Cid's EmitDelay 6.2 s on every layer and BigExplosion's Rate emitters only work
    inside their own script; a reusable explosion fires everything relative to its own t=0.
11. **Out-of-range values with unknown effect.** Transparency -50 (Ice `11448304274`), LightEmission -15 (BigExplosion),
    MiddleGlare Br 155 at Transparency 0.99, Rate 15,151,515: none can be read from the stills; test before copying.
