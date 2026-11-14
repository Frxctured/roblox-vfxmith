---
title: Projectile and orb VFX - craft notes from 7 open-source effects
source: "open-source VFX library (Discord packs) studied 2026-11-13"
tags: [vfx, projectile, orb, trail, muzzle, impact, particle-emitter, roblox, os-library, self-learned]
---
# Projectile and orb VFX: what 7 open-source effects do

Evidence: freeze-frame sheets and layer tables in `gallery/effects/projectile/` (layer tables: `library/cards/projectile/`),
full-resolution stills (not shipped), the decoded pack files (`kit/scripts/rbxdump.py`) and the effects' own scripts
(read as text only). Texture ids are the ones in the layer tables. "D" below = the diameter of the effect's
core sprite (the travelling orb or blade), so sizes transfer between scales.

**Read the stills with care.** The replayer fires every layer at t = 0 at its authored place. Whatever the effects'
scripts did is missing: the Event Ball rising 150 studs and exploding 1.2 s later, the Christmas bolts flying their
Bezier path, the Yoru blade being moved, Artemis placing each storm piece separately. So several sheets show launch,
body and impact all stacked at one point. Where the timing comes from a script it is marked.

**Recapture (2026-11-14).** The phases below come from the corrected sheets: each effect is placed on the floor by
its emitters, each view is measured and re-aimed, and the camera is locked. The stage background is a slightly bluer
grey than before. The first capture put five effects (`de38a5c20879`, `c7fe3995c7de`, `38dac72930b4`, `4dbd242adaf5`,
`79f54bf1d241`) partly under the floor. Where the two captures differ, both are named.

Builds on `../PATTERNS.md` (three tones, pops not fades). New here: numbers per layer role, size-out rather than fade,
LightEmission 0 or below with high Brightness as the default (not additive), size-curve strobes and scaled kit reuse.

---

## a. The seven effects

### 1. `f7daccbc3ddd` random orb (`random orb.rbxm`): a blue glass orb you hold
- **What:** 13 continuous emitters on one Attachment, Rate 1-10, Lifetime 4 s, all camera-facing and locked to the part, sizes 2-5 studs (D ~2.1, the rim).
- **Phases (sheet):** nothing until 0.55 s, a faint shell at 0.8, half bright at 1.2, readable at 1.8, full at 2.6-3.6 s and still brightening. Every layer's Transparency runs 1 -> min at 0.5 of life -> 1, so the first particles take 2 s to peak. Steady from about 4 s.
- **Layer roles:** dark back disc `196969716` (Gradient, #100E38, LE 0, Br 0.4, Rate 10, RotSpeed -20, no fade, so it builds up solid) = the glass interior. Black pinhole `94273715920250` (#17182F, LE 0, z 4, ~0.9 studs at mid-life) sits in front. Bright rim `18951936601` (LE 1, Br 8, 2.1). Slow spirals `107815776288817` / `18814788385` / `129535698195231` (RotSpeed -4, grow 0 -> 2.2-3.2). Inner detail `90699600186298`, `91258314575153`, `137135817059159`. Glares `72058519746764` (5.0, Rotation 40) and `81828566722014` (3.0). Offset arc `95791597657384` (3.2, Rotation fixed 70) is the arc at the upper right of the 3.6 s still. Star `14590086212` with Squash 0 -> -2.85 is the horizontal lens line, about 3x the orb's width.
- **Why it looks good:** about 10 different textures stacked at nearly the same size, so it reads as one dense sphere. One hue in four tints (#3F45AF-#757BE7), white only where additive layers overlap, a dark navy back and a black pinhole. A squashed star gives the anamorphic line. Glares at odd fixed angles (40, 70 deg) break the symmetry.
- **Weak:** the 2 s build-up means it cannot be fired as a projectile without pre-warming. It barely moves (4 deg/s). With everything additive the centre washes to white. There is no launch or impact.

### 2. `de38a5c20879` Artemis bow, Weapons (`ArtemisArrowRainOS (2).rbxl`): the bow's charge and launch
- **What:** a launch kit on the bow (folders Effects, StarStart, Charge, MagicCircles) plus two `Beam Slash` trails. 34 emitters, sizes 0.5-10 studs.
- **Phases (sheet):**
  - 0.03 s: empty. Even the bow mesh is missing, so this still comes before the replay starts and is not part of the effect.
  - 0.1 s, the peak: a spray of soft green streaks (Snowfall `16511071584` 8x8, Br 25, grows to 4.6; Spec1 `16878181512` VelocityParallel + Squash). A yellow half ring arches over the bow (Swirls14 `138923760615400` #FFD063 VelocityPerpendicular, or Flare Twinkles `96013523226630`: unclear which). Also a long horizontal white-green glare line (Rainbow6 Squash -3 / Flare20New), a white star burst at the bow and a green oval glow below it.
  - 0.2 s: the burst is already gone. Only a faint translucent green dome arc remains over the bow.
  - 0.35 s: a second, smaller flash from the Charge flicker (EmitDelay 0.1, EmitDuration 0.65): a green swirl round the bow's centre, a white vertical spike (Star27 `17062454177`, Squash 3 -> -3) and green streaks.
  - 0.55 s: a soft green ring above the bow, a thin pale ring and a green arc (WindRings `14569425079`, 0 -> 4.7, life 0.4-0.9; Sw1).
  - 0.8 s: a few thin green arcs. 1.2 s: the bow alone.
  - The ground magic circles do not read from this camera height (unclear).
- **Layer roles:**
  - Launch flash: Flare20New `70728001087698` (Transparency 0.94 -> 0 at 3 % -> 0.84 at 9 % of a 0.2 s life, a 1-2 frame peak), Fading Glow `107821950776778` (0 -> 10, 0.1 s), Rainbow6 `97232854781041` (Squash -> -3, a flattened rainbow streak, z 7), Flare Twinkles (Br 30, 0.1 s).
  - Inward collapse (StarStart): Charging swirl (7.1 -> 0 over 1 s), Spark Vortex `135336871909366` (10 -> 0, 0.2 s, RotSpeed 360), BlackHole `16879789169` (double pulse).
  - Charge flicker (EmitDelay 0.1, EmitDuration 0.65): short sprites at Rate 10-52, including Impact327 `12402897209` in green plus a black copy, Impact333 `14457094589` (Br 500, 0.04 s), Bezier1 `15423151910` and an Sw1 `114656597667803` ring pair.
  - Ground magic circle: `127687210481707`, 0 -> 5 over 0.7 s.
  - Trail: `118758348149908`, 0.2 s, #31B0FF -> #28B557 -> #184B21, Br 15, LE 0.
- **Why it looks good:** a flash with a 1-2 frame peak inside a longer tail; sprites collapsing inward (shrink to 0) for the charge; a flicker stream of 0.04-0.1 s sprites; the same ring texture spinning two ways.
- **Weak:** 34 layers for a muzzle. `Moving Smoke Circle Overlay` (`127602127470983`) has EmitCount 0, a dead layer. Impact201 `8050136743` and Impact347 `12937922496` have Brightness 0 and render black; that may be deliberate ink, unclear.

### 3. `d62996d5679c` Event Ball (`EVENT PLACE.rbxl`): a rising fireball that detonates (ultimate scale)
- **In game** (script `ReplicatedStorage.VFX.Modules.Event`):
  - The ball rises 150 studs in 1.5 s (Exponential Out) while turning 285 deg. The `Enabled` body emitters are on during the rise.
  - Its tail beams widen 0 -> full in 0.6 s (Sine Out) and close after 0.8 s (0.5 s, Quad In). The tail attachments drop 50 studs in 0.4 s.
  - `Flare` fires at 0.38 s and `Explode` at 1.2 s. The script also tweens every Explode emitter's Size x2.5 over 1 s and plays an impact-frame GUI sequence and an FOV kick. None of this is in the stills.
- **Phases (sheet, all folders at once):**
  - 0.03 s: only a small white flash and a flat orange band at floor level (the authored beams). The disc is not there yet, although its data has no delay. In the first capture it was already full at 0.03 s, so this is a replay start-up difference (unclear).
  - 0.1-0.2 s: a giant pale-yellow sun disc, cut in half by the floor. It is Circle `107251295851688` (LE 0, Br 4, #FF8A47, 78 -> 101 studs by 0.07 s, held, then collapsing 106 -> 35 in the last 15 % of its 0.3 s) plus Dots `107821950776778` (102 studs, Br 16, fading in over 0.18 s, gone by 0.65 s). In front, a **dark** 4-point star `17062452367` (z 7) grows 10 -> 40 by 0.03 s, -> 61 at 0.22 s, -> 30 at 0.3 s (sizes from data). It is black in the first capture and dark bronze with lighter edges in the recapture, always far darker than the disc.
  - 0.2 s: an inner white disc, Impact `75804565349970` from 51 studs.
  - 0.35 s: a toon explosion. Circular Smack `18140248952`, Impact62 `71570654111653`, Spike Impact `18457400581` and Round Spikey `18350947061` (EmitDelay 0.3, 41 -> 109 studs, life 0.2-0.4), with horizontal flame streaks (Lines `16879608903`, VelocityPerpendicular, Squash -0.48 -> 1.24, LE -3, Br 20).
  - 0.55 s: an orange broken spiky ring and a rainbow halo (Rainbow3 `85664013418740`, 55 studs; Blurred Flare `105427977618886`, 50 studs) round the striped red core.
  - 0.8 s: the halo fades and the core stays.
  - 1.2 s: only the authored beam cone is left (`105185967968678`, 4 beams, width 0 -> 25). The script drives those beams, so this is a replay artifact.
- **Layer roles:**
  - Core body (`Enabled` folder): constant-size flipbooks with Lifetime 1 s and Rate 2-5, so 2-5 copies overlap. Ball2 `14483718869` and Ball `14645775583` (8x8, size 10 = D), Ring `16877851515` and Ring2 `120212371638970` (4x4, 10-14), Inner `83109627968100`, Fall `138209242993782` (Speed 22), Blur `109985324958700` (Br 25), Circle `126034245450101` / `140601772804997` (VelocityPerpendicular). Most are LE -1, Br 5-12.
  - Trail `12781750620`: LE 0, Br 25, 0.5 s.
  - Spark pops: stars `17000879366` and dots `9533204568` (size 1.2 -> 10.7 at 11 % -> 1.9 at 28 % -> 2.7, rest of a 0.4-1 s life).
- **Why it looks good:**
  - A saturated orange at LE 0 with Brightness 4-16 overexposes to pale yellow-white with an orange soft edge, so one layer is both core and colour.
  - A dark (black to bronze) star at a high ZOffset over the white disc is the strongest silhouette in the whole group.
  - Phase handoff: the disc collapses at 0.27-0.3 s exactly as the toon pops arrive (0.2-0.3 s).
  - The halo uses an in / hold / out envelope (in by 0.28, hold to 0.84, out by 1.0 of life).
- **Weak:** impact pieces are 4-11x the 10-stud core, so the whole screen goes white (an ultimate can afford that, a normal shot cannot). The asset is incomplete without its script (size tween, beam widths, motion). Three copies of every constant-size core sprite stack their brightness. The core flipbooks are LE -1.

### 4. `c7fe3995c7de` Yoru projectile move (`Projectile Move.rbxm`): a green crescent blade and its hit
- **What:**
  - The body is three curved Beams on the same two attachments, about 14 studs apart. CurveSize0 6, CurveSize1 -8, Segments 40, FaceCamera. Forge holds both widths at 2.72 for EffectDuration 1 s.
    - Bright edge `73691880139198`: LE 0, Br 8, #5FFF6B, z +0.02.
    - Body `105117753061718`: LE 0, Br 1, #4AAF5A, z +0.01.
    - Halo `12402903335`: Transparency 0.6, width 0 -> 13, z -0.02.
  - Floor beams `139748527161624` and `9988507605`.
  - A hit kit at the `Flash` attachment, 6.3 studs ahead.
  - Highlight FillTransparency 0 -> 1 over 0.5 s, a body flash. It does not show in the recapture either (the character stays grey); whether the replayer runs Highlight tweeners is unclear.
- **Phases (sheet, recapture):**
  - 0.03 s: a large green-white starburst low at the floor, with long green rays fanning out along the ground. These are the hit's streak and glow layers (Shorter impact `14379744080`, Sideways Spec `7246982406`, Glow particle `6673021984`, circle_01 `7216856402`). Also a gold 4-point spark with a dark centre at chest height and cyan specks. The blade is mostly hidden behind the burst.
  - 0.1 s: the green crescent blade shows, with the gold star and a smaller green-white starburst low to the right.
  - 0.2 s: white slanted slabs (VelocityPerpendicular flat sprites seen nearly edge-on: Png-15 `15056677063`, 0 -> 10, LE 1), flat green diamonds (probably the dark Spec9 copy, #407A2E), an orange spike and a pink spark. Grey smoke starts on the floor.
  - 0.35 s: grey smoke spreading low over the floor (smoke_0 `7216851093`, LE 0.3, Br 0.5, white = grey), flat green shards lying on the floor and a dark translucent patch on the floor (probably floor beam `139748527161624`: not camera-facing, width 10, most visible at 69 % of its life). The blade is saturated green with a white edge.
  - 0.55 s: the blade with faint smoke. 0.8 s: the blade alone.
- **Hit kit roles:**
  - Hot streaks: Shorter impact `14379744080` x10 (VelocityParallel, LE -1, Br 50, speed 30-64, Drag 15, Squash -0.09 -> -2.2, life 0.06) and impact texture `15153511168` x7 x2 (VelocityPerpendicular, Br 50, Squash 1.5, life 0.06).
  - Coloured streaks: Sideways Spec `7246982406` x5 in three colours (green, pink-red, orange) with LE -1, Br 10, speed 10-70, Drag 6.5, Acceleration -40.
  - Off-centre specs `16171528032` x5 (LE -1, Br 8, cyan).
  - Two-tone specs: Spec9 `16879585719` as a dark (LE 0, Br 1) plus bright (LE -1, Br 8) pair.
  - Rock 7 `118243636520967` (Acceleration -50), two smoke layers, cracks `130848219849162` and the circle_01 strobe (technique 4).
- **Why it looks good:** the stacked beam blade with ZOffset steps; a hit that is over in 0.35 s; one emitter copied in three colours for accents; a dark and bright version of the same spark.
- **Weak:** flat VelocityPerpendicular sprites depend on the camera (they become white slabs from the side). Br 50 on 0.06 s sprites flickers. The blade holds full strength for 1 s and then switches off (Transparency_Scale 1 -> 1).

### 5. `79f54bf1d241` Don Lorenzo "ball" (`ball.rbxm`): a dark violet energy aura over a character
- **What:** 10 continuous emitters on each of 6 R6 body parts (60). Rate 5-25 each, 151/s per part and about 900/s in total. Life 0.4-0.7 s, sizes grow 0 -> 1.25-3.4 studs (about one limb). All layers LE 0, ZOffset -1 to -1.55 (behind the body).
- **Phases (sheet, recapture, whole body in view):** nothing at 0.03-0.1 s. At 0.2 s a few specks and one violet wisp beside the head. At 0.35 s violet clouds round the head and shoulders, brightest on the right shoulder. Full at 0.55-0.8 s: violet wisps with black smoky lumps round the head, shoulders and upper arms, and specks up to ~3 studs above the head. Nothing reads round the legs or lower torso: with ZOffset -1 to -1.55 and puffs of 1.4-3.4 studs, the leg emitters stay behind the body. Part of the slow start is in the data: with a 90 % fade-in, a 0.5 s puff is still ~55 % transparent at 0.2 s.
- **Layer roles:**
  - Colour ramp layers: #B661FF -> #261435 (light violet to near-black over life). Energyesque Fog `11446801985` (Br 25), Realistic Layered Fog `73401626133942` (Br 25), Energy Pulse `12123878312` (Br **155**), Black Smoke 3 `15222191191` (Br 15).
  - Pure ink: Small realistic energy burst `16509892607` and Purple Lightning `13013256540` at #000000, LE 0, Br 0, Rate 25 each, the highest rate in the kit.
  - Others: Realistic Energy Pulse `16511790647` (#09050C), off-centre specs `16171528032` (Br 25, RotSpeed ±250, 0.25-0.4 studs), Multiple Specs `18450596124`, Thaw flare `79485011518974`, Noisy Fading Glow `127984119352635`, ShadowMonarch overlay `137926940506348`.
- **Why it looks good:** no additive layer at all, so the violet stays saturated on a dark scene. The black ink flipbooks run at the highest rate. A "condense" envelope (Transparency 1 -> 0 at 90 % -> 1) means each puff grows and solidifies, then vanishes. Squash 0.1-0.25 on everything stretches it slightly upward.
- **Weak:** about 900 particles/s (the engine guideline is 400/s, 100 on mobile). There is no core or orb shape, so it reads as an aura, not a ball. ZOffset -1 to -1.55 puts all of it behind the body, so the body covers most of it: only a fringe round the head and shoulders reads, and the 20 emitters on the legs show nothing. Energy Pulse at Br 155 is a hack. Two near-identical off-centre spec layers.

### 6. `4dbd242adaf5` Christmas projectile (`christmaswowwowow.rbxl`): festive bolts with a confetti burst
- **What:** three Forge Bezier projectiles (EmitDelay 0 / 0.8 / 1.4). Each path is 1 s long and 30.5 studs, an S-curve from tangents ±4 studs sideways, so about 30 studs/s.
  - During flight: a trail stack (technique 15), plus a stream from the `vfx` attachment for EmitDuration 0.7 (present, ornament and candy-cane icons at Rate 4-10, stick `84584450910078` at Rate 60).
  - On arrival: an `EmitOnFinish` burst.
- **Recapture:** the replayer now holds `EmitOnFinish` back, as Forge does, and the bolts do not fly. So the new sheet shows only the flight stream at one point: a small red glow with candy canes, presents, a cyan ornament and yellow stars, about 2-4 studs across. It runs from 0.1 to 0.8 s and is nearly gone at 1.2 s. The burst phases below come from the **first capture**, which fired the EmitOnFinish children at the origin at t = 0 (its placement problem cut off low layers).
- **Phases (first capture, burst):**
  - 0.03 s: long horizontal green flares (starshiny2 `94105566940601`, Squash -0.41 -> 0.14, size 0 -> 5.15 at 0.15 s) and yellow flame petals (`137624374323028` x15 x2, VelocityParallel, Squash 1.39 -> 2.32, 4x4).
  - 0.1 s: a dense red/green/yellow burst with grey arcs.
  - 0.2 s: stars, presents and red streaks spread about 2x.
  - 0.35-0.8 s: sparse icons drifting and falling, grey arcs fading.
  - 1.2 s: almost empty; 1.8 s: empty.
- **Layer roles:**
  - Centre flash `15888463683`: LE 1, Br 5, 0 -> 17.6 at 15 % of 0.1 s, about 13x the 1.3-stud trail width.
  - Stop-dead shards: shinyShard2 `14271209798` x15, VelocityParallel, speed 66-199, Drag 30, Squash 0 -> 3, life 0.1-0.21.
  - Shard sparkles: shardlit `112825054831918` x10 green + x10 red, speed 8-95, Drag 7, life 0.8-1.6.
  - Cubes(7) `79737158206928`: x5 in each of 3 colours, size 0 -> 1.86 at 7 % then shrinking.
  - Confetti icons (`72249216120861`, `97888893663452`, `110247854701270`, `114323830243859`, `77658010168721`): x3 each, 0.9-2.4 studs shrinking to ~0.1, speed 25-80, Drag 5, Acceleration -20, RotSpeed ±360, life 1-1.5, LightInfluence 0.5.
  - Rings: shockwave `15509824141` (#414141, LE 1, LI 1, 0 -> 11, 0.8-1.5 s), wind `112934848465841` (#666666, Br 15, 0 -> 14.6) and crescent 03 `77399181389527` (TimeScale 0.5, RotSpeed 326-814).
- **Why it looks good:** a short additive trail plus a long dark one; Drag 30 shards that stop dead within about 4 frames; the palette made by duplicating emitters (green copy plus red copy); one layer slowed with TimeScale 0.5.
- **Weak:** five hues plus white icons is noisy. In the first capture nothing dominates after 0.1 s, and the recaptured flight stream is the same mix of red, yellow and cyan icons. The layers with LightInfluence 0.5-1 depend on scene light. The grey shockwave (#414141, LI 1) was barely visible in the first capture and does not fire in the recapture, so whether that is lighting stays unclear. The stream's stick `84584450910078` is LE 1 with Br 0, which adds nothing (a dead layer at Rate 60). The burst's only dark layer is the trail's black ramp; there is no dark sprite.

### 7. `38dac72930b4` Artemis Rain (`ArtemisArrowRainOS (2).rbxl`): the hovering storm orb of the arrow rain
- **In game** (script `ReplicatedStorage.Effects.Skill1`): the main part goes 18.9 studs up and 29 ahead, the ground circle 2.8 down. The storm then spawns Bezier arrows from it, each 0.05 s after the last.
- **What:**
  - The bow's launch kit (effect 2) is reused at **x2.76** (MainPart) and **x1.38** (StormCharge Bezier: ArcSpace, Duration 0.1, Rate 20, DestroyDelay 1). Size, Speed and Acceleration are all scaled by the same factor. Everything runs continuously for EmitDuration 1.4 s.
  - 15 Forge mesh models use sphere mesh `8501563708` with a **negative** SpecialMesh Scale (inside-out), with decals, ConstantVFX Rate 5-10, life 0.2-1 s, scale ~0 -> 0.4-1.47. These are the translucent domes.
  - Ground circles, all VelocityPerpendicular: MagicCircle4 `127687210481707` (23 studs), hexagram `105293844623669` (16), Crystal Circle `16511298384` (13), Circle8 `16877883455` (LE -2, Br 20, 10 -> 22), Bubbles `76488007713121` (15).
  - 15 identical emitters of `138004702320351`, each with speed -73.7 and Acceleration (0, 127, -84.5).
- **Phases (sheet, recapture):** the authored layout shows the orb floating about 3 orb-widths above a separate ground circle.
  - 0.03 s: the orb is already lit: a yellow-orange ring round a white-green core, a green bubble, green swirl streaks and a dark grey inner shell at the back. On the ground, a dark swirl disc with green ripples.
  - 0.1 s: a bright core with a long horizontal lens line. The ground rune circle, about 2x the orb's width, lights up green with a grey smoke ring spreading outward.
  - 0.2 s: dark grey-green wisp shells (the inside-out decal domes) curl round the orb's lower half and hang toward the ground.
  - 0.35 s: a yellow arrow streak shoots up out of the orb.
  - 0.55-1.2 s: the orb and ground circle hold steady. The yellow ring blinks between stills (missing at 0.35-0.55, back at 0.8-1.2), as expected from a 0.2 s sprite re-emitted at Rate 13: most likely Flare Twinkles `96013523226630` (#FF9040, Br 30).
  - 1.8 s: the orb is gone; the rune circle still shows faintly (life 1 s after the 1.4 s emission).
- **Why it looks good:** scaled reuse of one kit; inside-out sphere domes; a "boiling" orb made from 0.04-0.2 s sprites re-emitted at Rate 10-52; a negative speed with a strong Acceleration makes particles shoot one way and curve back.
- **Weak:** 57 emitters plus 34 meshes. 15 duplicate emitters where EmitCount 15 would do. The core is white-green where additive layers overlap, but the ring and bubble stay readable; the white-out at 0.35 s in the first capture does not repeat in the recapture. Impact333 is recoloured #000000 with LE 0 and Br 500, which is a black blob for 0.04 s (Brightness cannot lift black): a copy-paste leftover or a deliberate ink frame, unclear.

---

## b. Anatomy of a projectile / orb effect

Layer roles in firing order. Values are the typical spread across these effects. "Burst" figures come from the 163 non-continuous emitter layers.

Across those burst layers:
- LE < 0: 28; LE 0: 59; LE > 0: 76. So **53 % are not additive**.
- Brightness median 10, with 88 layers at 10 or more.
- Transparency flat (no fade) on 90 of 163.
- Size shape: shrink 64, grow 41, swell 38, constant 20.
- Lifetime max median 0.4 s; 34 layers live 0.1 s or less.
- Orientation: FacingCamera 106, VelocityPerpendicular 39, VelocityParallel 18.
- Drag above 0 on 84 layers (median 5).
- ZOffset non-zero on 83 (most common +5, then -1, +7).

| # | Role | Texture role (ids) | LE / LI / Br | Lifetime s | Size (studs, x D) | Transparency | Speed / Drag / Spread | Orient. / Squash / flipbook | EmitCount | ZOffset |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Charge collapse (optional, before launch) | swirl flipbooks `14197070443` 8x8, `138923760615400` 8x8, vortex `135336871909366` 4x4 | 0 / 0 / 10 | 0.2-1.0 | starts 5-10 (2-4 D), shrinks to 0 | flat 0 | ~0 (0.001) | FacingCamera or VelocityPerpendicular; RotSpeed 360 on the vortex | 1-3 | 0-1 |
| 2 | Ground sigil (optional) | magic circles `127687210481707`, `16511904372` 8x8 | 0 or -1 / 0 / 10-40 | 0.7-1.2 | 0 -> 2-5 in 7-20 % of life, or constant 10-23 | 0 -> 1 linear | 0.001, EmissionDirection Top | VelocityPerpendicular, RotSpeed ±50 | 1 | 0 |
| 3 | Launch flash | `70728001087698`, `107821950776778`, `97232854781041` (Squash -3), `10556525755` | 1 / 0 / 1-10 (Br 30 on tiny ones) | 0.1-0.2 | 0 -> 4.75-10, at ~0.3-0.6x the impact flash | 0.94 -> 0 at 3 % -> 0.84 at 9 % -> 1 (1-2 frame peak) | 0 | FacingCamera; Squash 0 -> -0.38 or -3 | 1 | +4 to +7 |
| 4 | Launch sparks | `13161986324`, `16878181512`, `11448304274` | 1 or 0 or -2 / 0 / 2.8-23 | 0.1-0.3 | 0.56-2.4 -> 0 | flat 0 | 1-70, Drag 6-12, Spread 100-360, Acceleration -10 to -15 | VelocityParallel + Squash 0 -> 1.39; specs Rotation 90 | 2-4 | 0 |
| 5 | Core: dark back | gradient disc `196969716` | 0 / 0 / 0.4, deep hue #100E38 | follows the core | ~1 D, constant | flat 0 | ~0, LockedToPart | FacingCamera, RotSpeed -20 | 1 (Rate 10 in source) | 0 |
| 6 | Core: body | 8x8 orb flipbooks `14483718869`, `14645775583`; ring flipbooks `16877851515`, `120212371638970` | -1 / 0 / 5-12 (or 1 / 0 / 3-8) | 1 (flipbook OneShot over life) | constant 1-1.4 D | flat 0 | 0, LockedToPart | FacingCamera, fixed Rotation 90-150 | 2-3 overlapping | +4 to +6 |
| 7 | Core: hot centre / rim | `15153511168` (hard white disc), `18951936601` rim | 1 / 0 / 3-8 | as core | 0.4-1 D | 0-0.46 | 0 | FacingCamera | 1 | +3 to +5 |
| 8 | Core: lens line | star `14590086212` | 1 / 0 / 3 | as core | ~1.4 D | min 0.34 | 0 | Squash -2.85 (horizontal) | 1 | +3 |
| 9 | Wake specks | off-centre `16171528032`, `18450596124` | 0 / 0 / 25 | 0.4-0.7 | 0.25-0.4 -> 0 | 1 -> 0 at 50 % -> 1 | 4-12, Drag 7, Spread 360, Acceleration +0.6 to +1 | RotSpeed ±250 (orbits) | stream | -1.2 |
| 10 | Wake ink | `16509892607`, `13013256540` at #000000 | 0 / 0 / 0 | 0.4-0.7 | 0 -> 1.4-2 | 1 -> 0 at 90 % -> 1 | ~0 | Squash 0.1 | stream | -1.2 to -1.5 |
| 11 | Trail | `12781750620`, `126171454491178`, `79903427169836`, `118758348149908` | 1 (hot) + 0 (dark) / 0 / 5-25 | 0.2 hot, 0.5 dark | width ~1 D, spindle WidthScale | 1 -> 0 at 0.4 % -> 0.55 at 87 % -> 1 | - | FaceCamera; colour ramps to black on the dark copy | - | - |
| 12 | Impact flash | `15888463683`, `14457094589`, `10556525755`, `107821950776778` | 1 / 0 / 5-30 (Br 500 at 0.04 s) | 0.04-0.1 | swell 0 -> 7-13 D at 15 %, or 4-11 -> 0 | flat 0 | 0 | FacingCamera | 1 | -1 to +3 |
| 13 | Impact disc (overexposed) | `107251295851688`, `107821950776778` | **0** / 0 / 4-16, saturated orange | 0.3-0.65 | 8-10 D: grows 78 -> 101 in 22 %, holds, collapses to 35 in the last 15 % | flat 0, or in 0.18 s / hold / out | 0 | FacingCamera | 1 | +6 |
| 14 | Ink star over the flash | `17062452367` (renders black to dark bronze); black copy of `12402897209` | 0 / 0 / 5-15 | 0.1-0.3 | 1 -> 6 D (0.6x the disc) | flat 0 | 0 | FacingCamera, fixed Rotation -70 | 1 | **+7** |
| 15 | Toon impact pop | `18140248952`, `71570654111653` 4x4; `18457400581`, `18350947061` 2x2; `75804565349970` | -1 or 0 / 0 / 7-25 | 0.2-0.5 | 4 -> 8.5-11 D (grows) | flat 0 | 0 | FacingCamera; EmitDelay 0.2-0.3 after the flash | 1 | +6 to +7 |
| 16 | Shock rings | `126034245450101` 4x4, `14569425079`, `114656597667803`, `7216856402`, `15509824141`, `112934848465841` | 1 or -1 / 0 / 1-15 | 0.2-1.5 | 0 -> 1-1.5 D (Yoru: ~1x blade length) | 0.54-0.85 -> 1, or flat | 0.001-0.02, Spread 360 (random flat plane) | VelocityPerpendicular, RotSpeed ±100-600 | 1-3 | 0 |
| 17 | Streak sparks | `14379744080` 4x4, `7246982406`, `14271209798` 4x4, `137624374323028` 4x4 | -1 / 0 / 10-50 | 0.06-0.55 | 1.4-4.7, grow or shrink | flat 0 | 10-200, Drag 6.5-30, Spread 360, Acceleration -40 | VelocityParallel, Squash 0 -> 3 or -0.09 -> -2.2 | 5-15 | +1 to +1.5 |
| 18 | Two-tone sparks | `16879585719` 4x4 (dark + bright copy) | 0 / 0 / 1 and -1 / 0 / 8 | 0.25-0.45 | 1.8 -> 0 | flat 0 | 15-60, Drag 4.5, Spread 360 | FacingCamera, Squash 1 | 5 + 5 | 0 |
| 19 | Debris / confetti | `118243636520967`, `79737158206928`, `112825054831918`, icon sprites | -1 to 1 / 0-0.5 / 1-15 | 0.7-1.6 | 0.9-2.4 shrinking to 0.1, or swell to 1.2-1.9 at 7-20 % | flat 0 | 8-95, Drag 5-7, Acceleration -20 to -50 | FacingCamera, RotSpeed ±360 | 3-10 | -2.7 to +4.7 |
| 20 | Smoke | `7216851093`, `15222191191` 8x8 | 0-0.3 / 0 / 0.5-15 | 0.25-0.8 | 0 -> 5.7-6.5 (~0.5x the flash) | flat 0 -> 1 | 11-44, Drag 5, Spread 0-180 | FacingCamera / VelocityPerpendicular | 5 | -1.5 |
| 21 | Linger halo | `85664013418740`, `105427977618886` 4x4, `6673021984` | 1 / 0 / 1-6 | 0.65-1.2 | 5 D constant, or 10.3 -> 0 | 0.95 -> 0.05 at 28 % -> 0.06 at 78 % -> 0.9 | 0, RotSpeed -10 | FacingCamera | 1 | +6 |

D in the sources: Event Ball core 10 studs, random orb rim 2.1, Christmas trail width 1.3 (the bolt is invisible apart from its trail), Yoru blade 2.7 wide x ~14 long. The bow kit has no core; its flash is 4.75-10 studs.

---

## c. Timing (seconds; 0 = fire, C = contact)

| Phase | Typical | Range seen | Source |
|---|---|---|---|
| Wind-up / charge | 0.35-0.4 s before launch | inward swirls 0.2-1 s | Event WIND_UP 0.38; Artemis waits 0.34 s then charges; Charging swirl life 1 |
| Launch flash | peaks at 0.006-0.03, gone by 0.1-0.2 | 0.04-0.3 | Flare20New, Fading Glow, Rainbow6 |
| Launch sparks | 0.1-0.3 life, stopped by Drag in ~0.1 | - | Flare247New, Spec1/2 |
| Charge flicker (if held) | 0.1 -> 0.75 | EmitDuration 0.65-1.4 | Artemis Charge, Rain |
| Travel | 0.1-1.5 s, 30-300 studs/s | Bezier arrows 0.1 s; Christmas 1 s / 30 studs; Event rise 1.5 s / 150 studs | scripts / Forge attributes |
| Trail | life 0.2 (hot) and 0.5 (dark) | 0.1-0.5 | Christmas, Event, Artemis |
| Impact flash | C to C + 0.04-0.1 | big disc C to C + 0.3 | Impact333, center, Event Circle |
| Main pop | starts C + 0 to C + 0.3, lasts 0.06-0.5 | - | Yoru 0.06 streaks; Event toon pops 0.2-0.5 |
| Rings | C to C + 0.4-1.5 | - | WindRings 0.4-0.9, shockwave 0.8-1.5 |
| Debris / confetti / smoke | C + 0.25 to C + 1.6 | - | Christmas icons 1-1.5, smoke 0.25-0.65 |
| Linger halo | C + 0.3 to C + 1.2 | - | Rainbow3 / Blurred Flare |
| Ground sigil under a hovering orb | the orb's life + ~1 s | rune circle still faint 0.4 s after the orb is gone | Rain magic circles (life 1-1.2 after EmitDuration 1.4) |
| Gone | C + 0.65 (light hit) to C + 1.5 (big burst) | Event ultimate: several seconds by script | sheets |

Read from the sheets:
- Christmas burst (first capture): dense until 0.2, sparse 0.35-0.8, empty at 1.8.
- Event explosion: disc 0.1-0.3 (missing at 0.03 in the recapture), pop 0.3-0.55, halo to ~1.0.
- Yoru hit: the ground starburst peaks at 0.03-0.1, slabs at 0.2, floor smoke to ~0.55.
- Bow launch: the burst is over by 0.2, the charge flicker re-flashes at 0.35, rings at 0.55-0.8.
- Light hits last about 0.35 s, big ones 1.2-1.5 s.
- Continuous effects whose Transparency fades in over half or more of their life need 0.35-2 s to reach full density: random orb about 2 s, Don about 0.55 s (nothing at 0.1, specks at 0.2, full at 0.55). Rain, whose layers fade in over 0-11 % of life, is full at 0.03-0.1 s. Its ground sigil outlives the orb by ~1 s (still faint at 1.8 s).

---

## d. Techniques catalogue (exact recipes)

1. **Size-out instead of fade.** Transparency flat 0; Size N -> 0 (shrink) or 0 -> peak at 7-23 % -> 0 (swell). 90 of 163 burst layers never fade; they leave full-value by shrinking. Example: Flash `10556525755` 4.08 -> 1.65 at 25 % -> 0.33 at 54 % -> 0 over 0.1 s.
2. **One-frame peak inside a longer flash.** Transparency {0: 0.94, 0.03: 0, 0.09: 0.84, 1: 1} on a 0.2 s life plus Size {0: 0, 0.12: 0.55, 0.3: 0.98, 1: 1} x 4.75. Bright for about 1 frame, then a dim growing afterglow. (Flare20New `70728001087698`)
3. **Overexposed core with a coloured edge in one layer.** LE 0, LightInfluence 0, Brightness 4-16, Color a saturated orange (#FF7F35-#FF8A47) on a soft disc or glow at 8-10 D. On screen: a pale yellow-white centre, with orange only in the soft falloff. (Event Circle `107251295851688` Br 4; Dots `107821950776778` Br 16)
4. **Size-curve strobe: several flashes from one particle.** Size {0: 0, 0.10: 11.2, 0.26: 0, 0.40: 6.6, 0.50: 0, 0.70: 13.3, 1: 0} over 0.5 s, LE 0, Br 8, white, texture `7216856402`, emitted twice (camera-facing plus VelocityPerpendicular). The result is three pulses in 0.5 s with no script. (Yoru circle_01)
   - Double pulse with a squash change: Size {0: 0, 0.2: 10, 0.3: 2.7, 0.5: 0, 0.8: 2.35, 1: 10}, Squash {0: 3, 0.71: 0.08, 1: -0.15}, life 0.3. (Artemis BlackHole `16879789169`)
5. **Collapse at the end, not a fade.** Size grows and holds, then drops about 70 % in the last 10-15 % of life with Transparency flat 0: 78 -> 101 (22 %) -> 106 (85 %) -> 35 (100 %) over 0.3 s. Time the next phase to start at that moment. (Event Circle)
6. **Ink silhouette over the flash.** Dark 4-point star, LE 0, ZOffset 7 (in front of everything), Size 10 -> 40 (11 %) -> 61 (73 %) -> 30 over 0.3 s, fixed Rotation -70, peaking at ~0.6x the flash disc. Renders black (first capture) to dark bronze (recapture) over a white disc. (Event Star `17062452367`; its texture art is unseen, so for a guaranteed result set Color #000000.)
7. **Brightness 0 makes black ink from any colour.** With LightInfluence 0 the colour is multiplied by Brightness, so Br 0 gives black. Used on Small realistic energy burst `16509892607` and Purple Lightning `13013256540` (#000000, Br 0, Rate 25 each), and on rings `8050136743` / `12937922496` (#FF5820, Br 0). Br 500 on #000000 (Rain Impact333) is still black.
8. **Colour ramp to near-black over life**, giving three tones inside one emitter: Color #B661FF -> #261435 at LE 0 (Don). Trails: #FFC338 -> #181100 -> #000000 (Christmas `dark`, LE 0), #31B0FF -> #28B557 -> #184B21 (Artemis, Br 15, LE 0).
9. **Same texture as an additive copy and a black copy.** Impact327 `12402897209`: a green LE 1 Br 10 copy at 5.37 -> 0, z -1, plus a #000000 LE 0 Br 15 copy at 3.12 -> 0, z 0.75, which gives a dark core inside a glowing ring. Spec9 `16879585719`: a dark #407A2E LE 0 Br 1 copy plus a light #9EFF8B LE -1 Br 8 copy, same motion.
10. **Negative LightEmission with high Brightness** on non-additive textures: LE -1 to -3 with Br 6-50 (28 of 163 burst layers, median Br 10). On screen these read as saturated, solid colour that does not wash to white (the Event core ball, Yoru cyan specks). Undocumented engine behaviour: verify in Studio.
11. **Transparency below 0.** `11448304274` specs carry Transparency -50 (flat) with LE -2 and Br 10. It probably forces full opacity on soft texture edges. Unverified.
12. **Anamorphic lens line from a star.** Squash -2.85 to -3 on a cross or flare texture flattens it into a horizontal streak about 3x the core width: `14590086212` (Squash 0 -> -2.85), Rainbow6 `97232854781041` (0 -> -3, a flat rainbow streak), starshiny2 `94105566940601` (-0.41 -> 0.14).
13. **Squash flip.** Squash 3 -> -3 over a 0.4 s life turns a vertical needle into a horizontal one, a twinkle with no script. (Star27 `17062454177`, Size 4 -> 0, Br 30)
14. **Stop-dead streaks.** VelocityParallel, speed 66-199, Drag 30, life 0.1-0.21, Squash 0 -> 3, Size 0 -> 3.55 at 31 % -> 1.77 at 77 % -> 0: a star of streaks frozen within about 4 frames (Christmas shinyShard2 `14271209798`). Milder: speed 25-50, Drag 8.5-15.
15. **Trail stack.** Three Trails on the same two attachments, 1.34 studs apart (the width), FaceCamera:
    - Hot: LE 1, Br 5, life 0.2, texture `79903427169836`.
    - Body: LE 1, Br 5, life 0.5, texture `126171454491178`.
    - Dark: LE 0, Br 5, life 0.5, same texture, colour #FFC338 -> #181100 -> #000000.
    - Shared WidthScale {0: 0.03, 0.19: 0.33, 0.45: 0.41, 0.81: 0.35, 1: 0} (a spindle: thin at the head, fat in the middle, tapered tail).
    - Shared Transparency {0: 1, 0.004: 0, 0.44: 0.2, 0.87: 0.55, 1: 1}.
    - At 30 studs/s that is a 6-stud hot core inside a 15-stud dark streak.
16. **Orbiting specks.** The off-centre dot `16171528032` at Size 0.25-0.4 -> 0, Rotation ±360, RotSpeed ±250, speed 4-12, Drag 7, Acceleration +0.6 to +1 (rising), LE 0, Br 25. Each speck circles its own centre while drifting. (Don)
17. **Random flat rings.** VelocityPerpendicular, Speed 0.0002-0.02, SpreadAngle (-360, 360). Each ring lies in a random plane facing its tiny velocity. With RotSpeed ±150-600 they spin (WindRings `14569425079`, Sw1 `114656597667803`, Circle72 `17006200673`).
18. **Ring pair, contracting plus expanding.** Two Sw1 layers on the same spot: one 5.83 -> 0 at RotSpeed -600, Transparency 0.78 -> 1; one 0 -> 3.12 at RotSpeed -500. Life 0.2. A ring that seems to fold through itself.
19. **Constant-size flipbook core.** Lifetime 1, Rate 2-5 (or EmitCount 3), FlipbookMode OneShot, constant Size 1-1.4 D, fixed Rotation 90-150. The flipbook animates the surface and 2-5 copies at different frames overlap. (Event `14483718869` / `14645775583` 8x8)
20. **Glass orb.** A dark gradient disc behind (`196969716`, deep hue, LE 0, Br 0.4, constant ~1 D), an additive rim (`18951936601`, Br 8), slow spirals (RotSpeed -4), a black pinhole in front (z 4). (random orb)
21. **Condensing puffs.** Transparency {0: 1, 0.9: 0, 1: 1} with Size 0 -> max: each puff grows, gets denser, then is cut in the last 10 %. Reads as energy gathering, not dissipating. (all Don layers)
22. **Scaled kit reuse.** The same emitters at x1, x1.38 and x2.76, with Size, Speed and Acceleration all multiplied by one factor so the motion keeps its shape. (Artemis bow -> StormCharge -> storm orb). Our runtime's `scale` already does this.
23. **Per-layer slow motion.** The emitter's TimeScale 0.5-0.9 slows one layer's flipbook and motion only: 03 crescent 0.5, Circle72 0.75, Impact327/333 0.9, Don fog 0.6.
24. **Inside-out sphere dome.** A sphere mesh (`8501563708`) with a negative SpecialMesh Scale (all axes) shows its inner faces. Decals start at Transparency 0-0.85 and go to 1. As a Forge Start/End model it scales from ~0 to 0.4-1.47 in 0.2-1 s, which gives a translucent dome round the orb. (Rain)
25. **Shoot back.** Speed -73.7 with Acceleration (0, 127, -84.5), life 0.4: particles leave against the emission direction and curve up and away. (Rain `138004702320351`)
26. **Phase handoff.** The next layer group's EmitDelay equals the moment the previous big layer collapses: Event disc collapses at 0.25-0.3 s, Impact `75804565349970` starts at 0.2 and the toon pops at 0.3.
27. **In / hold / out envelope for linger halos.** Transparency {0: 0.95, 0.06: 0.85, 0.17: 0.26, 0.22: 0.05, 0.78: 0.06, 0.84: 0.17, 0.9: 0.48, 1: 0.89} over 1-1.2 s at 50-55 studs, RotSpeed -10. (Event Flare)
28. **Pop-and-settle sparks.** Size {0: 1.23, 0.06: 4.85, 0.11: 10.7, 0.17: 9.6, 0.22: 3.5, 0.28: 1.85, 1: 2.68} over 0.4-1 s, speed 13-27, RotSpeed ±80: a big pop, then a small spark that lingers. (Event stars `17000879366` / dots `9533204568`)
29. **Accent colours by duplication.** Copy a spark emitter and change only Color: Yoru Sideways Spec in green / #FF5D6D->#FF0054 / #FF9E5D->#FF2B00; Christmas shardlit and the 137624374323028 streaks in green plus red.
30. **ZOffset layering.** Flash, star and spark layers +4 to +7; core +4 to +6; rings and sparks 0 to +1.5; smoke and wake -1 to -1.5; beam stacks ±0.01-0.02 between near-identical beams.
31. **Curved beam blade.** Three Beams on one attachment pair 14 studs apart: CurveSize0 6, CurveSize1 -8, Segments 40, width 2.7, FaceCamera. Order: halo (Transparency 0.6, wider, z -0.02), body (Br 1, z 0.01), edge (Br 8, z 0.02). (Yoru)

---

## e. Mistakes and weak spots seen here

- **Slow build-up on an "instant" orb.** Transparency min at 50 % of a 4 s life means 2 s to full (random orb); a 90 % fade-in on 0.4-0.7 s puffs leaves the first ~0.2-0.35 s faint (Don: nothing at 0.1 s, specks at 0.2, full at 0.55). For a fired projectile, fade in over ≤10 % of life, or emit the core as one burst at full value.
- **Impact 7-13x the core.** Event Ball (pieces up to 109 studs on a 10-stud core, then x2.5 by script) and the Christmas flash (17.6 on a 1.3-stud trail) fill the screen. Fine for an ultimate; for an ordinary shot keep the flash at 4-6 D.
- **Additive on additive.** The random orb's centre washes to white; Rain's core goes white-green (readable in the recapture, washed out in the first). The cleaner effects (Event disc, Don, Yoru blade) use LE 0 or below with high Brightness for colour and keep LE 1 for small or short sprites.
- **The look lives in a script.** Event Ball (size x2.5 tween, beam widths, rise) and the Yoru blade (moved by code) are incomplete as assets. The replay shows static beams that should have closed. Put timing in data (EmitDelay, Forge attributes) or in the spec, not in one-off code.
- **Duplicates instead of counts.** 15 identical Rain emitters; two identical Don off-centre layers; three copies of each Event core sprite. Use EmitCount, and remember that overlapping identical additive sprites multiply brightness.
- **Dead or invisible layers.** EmitCount 0 (Moving Smoke); Br 0 on coloured rings (black, maybe unintended); LightInfluence 0.5-1 layers whose look depends on the map's lighting (Christmas shockwave #414141 LI 1, confetti LI 0.5; the recapture does not fire that burst, so how they read stays unclear). Christmas stick `84584450910078`: LE 1 with Br 0 adds nothing (Rate 60, dead).
- **Particle budget.** Don runs about 900 particles/s across 60 emitters. Rain runs 57 emitters plus 34 meshes for a 1.4 s orb.
- **Too many hues.** Christmas: green, red, yellow, white and cyan icons, with no dominant shape after 0.1 s. Prefer the three-tone rule plus one accent.
- **Flat sprites seen edge-on.** VelocityPerpendicular shock sprites become white slabs when the camera is near their plane (Yoru 0.2 s). Use camera-facing for the main shock, flat only for ground or decoration rings.
- **Hard switch-off.** The Yoru blade stays at full strength until its 1 s EffectDuration ends. Shrink or fade the body in its last 0.1 s.
