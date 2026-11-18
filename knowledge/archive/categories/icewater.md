---
title: "Open-source VFX study: ice / water"
source: "open-source VFX library (Discord packs) studied 2026-11-13"
tags: [vfx, roblox, particles, ice, frost, water, whirlpool, crystals, ground-rings, open-source-study]
---

# Ice / water: what 6 open-source effects teach

> **Hero crystals (blind test 5, 2026-11-14):** the library crystal meshes below (`75306692763883` and the icy ones)
> can only be tinted as a whole; three builds that used them read as "smooth cones" / "one flat colour". The build
> people rated clearly best made faceted crystals in code: deep blue base -> cyan -> white tip, alternating facet tones,
> shards as their own angular pieces that land, stumps that stay. Use `ctx.Crystal` (spec-format.md) for hero spikes
> and shards; take timing, sizes, mist and ring values from the effects below.

Evidence: freeze-frame sheets + layer tables in `gallery/effects/icewater/` (repo root; layer tables: `kit/scripts/layer_table.py`)
(Edit-mode replayer, every script stripped), plus the decoded instance trees in the decoded pack files (`kit/scripts/rbxdump.py`) (read as data)
and the 4 FrostOs scripts (read as text, never run). 286 ParticleEmitters, 85 Beams, 2 Trails, 14 crystal MeshParts.
This extends `../PATTERNS.md`; it does not repeat it. **Seen** = visible in the stills; **Table** = read from the layer
table / dump; **Script** = from the effect's own scripts; **Unclear** where neither settles it.

## 0. Read this first: what the evidence can and cannot show

1. **Recaptured after a placement bug (2026-11-14).** The first capture pivoted a Model without a PrimaryPart by its
   bounding-box CENTRE, so Ice.rbxm's emitters (Y 0.07 vs centre 11.1), icy's (Y 0 vs 12.7) and FrostOs's ground
   layers (Y 0.5-2.0 vs 3.3) fired under the stage floor. The player now places effects by their emitters (lowest
   emitters on the floor) with a measured, locked camera; all "Seen" claims below come from the recapture
   (`gallery/effects/icewater/<id>.jpg`, a slightly bluer grey stage). In the recapture the 0.03 s frame of every burst
   is empty (Whirlwind, Chara, polething showed content there in the first capture): treat 0.03 s as unreliable by
   about one frame. The capture camera sits low (roughly 15-25 deg above the ground), which matters for flat rings
   (section e10).
2. **Two are not ice or water.** `37b080b2910d` (Chara) is a red pixel-art hit; `50b56a6be8e6` (polething) is an
   orange rune-circle burst with grey smoke. Their tags came from texture/layer names. They are studied for their
   transferable tricks only. The real ice/water evidence is Ice, icy, FrostOs (frost aura) and Whirlwind (water/wind
   vortex).
3. Group numbers (Table): Ice is 28/29 emitters LightEmission 0 with Brightness 10 (one look everywhere); FrostOs is
   43/58 LE >= 0.7 with median Brightness 10 on NEAR-BLACK colours; Whirlwind 9/11 LE >= 0.7, median Br 2. Median
   longest lifetime 2.1-2.3 s for the three ice files vs 1.15 s for the water vortex and 0.5 s for the pixel hit; the
   library-wide median is <= 0.5 s for 51% of designs, so **ice lingers about 4x longer than a typical hit effect**.

## a. The six effects

### 1. `f94ba5a23040` Ice.rbxm :: Model (frozen-ground eruption), est. 7.9 s
- **What:** 10 Glass crystal MeshParts (one mesh `75306692763883`, one texture, 15-31 studs tall, tilted 2-54 deg) in a
  cluster about 22 studs wide on a 40x40 invisible `AOE` disc, 29 emitters, one PointLight (Br 3, Range 25, #9DE2FF).
  Every emitter has `EmitDelay 0.07`.
- **Phases (Seen):** 0.03 s crystals only, already full size and static to 3.6 s (white-hot centres, saturated blue
  tips; the meshes carry custom CFrame/Size/Transparency/Duration/TimeBeforeReset attributes, all 0, for a tweener the
  library has no runtime for, so any real grow-in is Unclear); 0.10 a white frost splash on the ground round the base
  (about 1.3x the cluster width) + small blue snowflake specks; 0.20 thin horizontal streaks out to ~1.6x the cluster
  width (the flat hit/wind rings seen edge-on) and sharper splash edges; 0.35-0.55 pale mint/cyan-grey puffs low on
  both sides; 0.80-1.80 puffs drift outward and darken to slate; 2.60 splash still there, fading; 3.60 gone, crystals
  only. No flash is visible. Table: fire 0.07; flash ring 0.07-0.28 (at Transparency 0.85, not seen); slow smoke to
  2-7.9 s; crack peaks at 2.17 s, gone at 3.07 s.
- **Layer roles (Table):** flash ring `18397658030` FacingCamera 1 -> 9.3 @28% -> 14.6, 0.135 s at TimeScale 0.65;
  flat hit flipbooks `13778611432` (x5) / `16125610617` (x2), Size 8 -> 40.5 / 6 -> 31; 4 flat wind-ring textures
  (`18652132265`, `123630005106717`, `18684145757`, `88836910549343`) 18.6-30.2 studs, RotSpeed +-3.8..5.8; a spinning
  ring `18397737060` (Lines, RotSpeed 70); radial mist fan (5 smoke sheets, 4-22 each, SpreadAngle (5-9, 360));
  up-cone toon puffs (`138231890129613`, `101430476623997`, `125716684677906`, `139474473857712`, VelocityParallel
  spread 45); double-blink sparks `11932690139` + `137831468` (25 + 25, TimeScale 0.5); crack `99911247720869` and
  crater `130658933079638` x100.
- **Techniques:** solid matter everywhere (LE 0, Br 10, #80C8FF: the puffs read soft pale mint/cyan-grey, not blown
  out, Seen 0.35-1.8 s); the crystals themselves carry the white core and the saturated blue (Glass + texture + bloom);
  a white ground splash that appears with the hit and holds ~2.5 s (the crater layer, Seen); hit ring born at 20% of
  its final size, fade-in in 15% of life, hold to 75% (Table; edge-on streaks on screen); crack that fades IN for 70% of
  a 3 s life (Table: hidden behind the crater splash on screen); sparks that blink twice.
- **Weak:** one colour on all 29 particle layers (the white comes only from the meshes and the splash; no ink); 100
  stacked copies of a 26%-opaque crater to fake one opaque decal; emitters 11 studs below the model's bbox centre (any
  bbox-based placement buries them, as it did in our first capture); flat rings invisible from a low camera.

### 2. `50b56a6be8e6` polething.rbxl :: Workspace/practice (orange rune-circle burst, NOT ice/water), est. 2.0 s
- **What:** a practice staff move: 155 emitters in 5 stage groups (`few1`, `few12`, `spinn11`, `ender`, `Pole`), a
  pole MeshPart with two Trails and two PointLights (Br 2, Range 5). The replayer fired all stages at t = 0, so the
  stills overlap stages that were presumably sequenced by an animation (Unclear: no scripts in the file).
- **Phases (Seen):** 0.03 s empty in the recapture (the first capture showed the ring already); 0.10 gold rune ring +
  a wide orange ground glow ellipse (~3x the ring width, the flat copy of the glow) + black ink splats lying on the
  ground + embers; 0.20 ring holds, grey smoke starts, dark chips fly; 0.35 smoke billows to about 2x the ring width;
  0.55 smoke and embers peak, ring dims, a dark square-edged patch on the ground; 0.80 smoke drifts out, ring faint;
  1.20 dim haze; 1.80 gone (pole remains).
- **Layer roles (Table):** spinning glyph/wind rings (`131070767868542`, `7417145436`, `16034321024` and others) flat,
  9.6-48.5 studs, RotSpeed 100-555, LE 1 at Br 0.05-1, ZOffset 6.8-8.2; ink splats/dust (`120806769380157`,
  `96754486633479`, `7832491488`, `139851738398320`) LE 0 at Br 0.01-0.1; smoke (`15855917528`, `16867377762`,
  `11799788138`, `135611124886147`) LE 0, const Size 7-22.7, Speed 15-150, Drag 4-6, Sphere shape; radial dust
  streaks (`93743935237246`, `90532677171477`, `128124707976588`, `113398526623218`) VelocityParallel, Squash -0.5,
  colour #FFA43C -> #000000; embers `15658580283` (off-centre spec); flash `107821950776778` 0.1-0.3 s, Size 5-30;
  1-frame flash `99849115529087` 0.05 s.
- **Techniques:** LE 0 + Brightness 0.01-0.1 turns any colour into ink (the dark splats, Seen); every ground sprite
  emitted twice, once VelocityPerpendicular and once FacingCamera, so it reads from above and from the side; smoke that
  does not grow (const Size) and expands by travel (Speed 25-150, Drag 4); colour-to-black ramps on streak dust.
- **Weak:** 155 emitters; ~20 additive ring layers at Brightness 0.05 add almost nothing; every sprite duplicated; a
  dark LE 0 ground sprite shows its square texture edge at 0.55 s (which layer is Unclear).

### 3. `37b080b2910d` Chara Giveaway :: Practice/Chara/Step2 (red pixel-art hit, NOT ice), est. 0.8 s
- **What:** 15 emitters on one part: 7 red pixel-star layers (5 each), 3 pixel-smoke layers (15 + 55 + 15), tan dust
  specks, a circle flipbook pop. All fire at 0.
- **Phases (Seen):** 0.03 s a white-hot blob with red bits (flash; first capture only, empty in the recapture); 0.10
  peak: pale pixel smoke + 15-20 red stars; 0.20 tan dust specks visible, smoke fading, stars scattered; 0.35 a few red
  stars; 0.55 gone. Total ~0.4 s.
- **Layer roles (Table):** stars (`8733414465`, `15268170416`, `13448020277`, `105729953163455`, `80635905349701`)
  LE -3, Br 5-15, #FF3939, LockedToPart, Size swell 0 -> 0.6-1.2 @10% -> 0, life 0.2-0.5, Speed 35-75, Drag 4-6; pixel
  smoke (`16310643442`, `13820471965`, `8733226116`) LE 1, Br 1, #B3B3B3, Transparency 0.94 -> 1, Speed 6-61, Drag 3,
  Squash 0.34 -> 0; pop `113678423988783` flat, Size 0 -> 21.9 in 0.13-0.2 s, Speed -0.3..0.3; dust `7231210720`,
  `5368629557` tan #BD9F63 at ZOffset -1.05.
- **Techniques:** LE -3 + Br 15 renders saturated red stars with white-hot cores and a red bloom halo (Seen at 0.10);
  85 pixel-smoke particles at 94% transparency build a visible volume only where they overlap; Speed range -0.3..0.3
  on a flat card mirrors it at random.
- **Weak:** off-category; nothing lingers (fine for a pixel hit).

### 4. `0695319f172d` FrostOs.rbxm :: Frost (frost aura showcase), continuous, est. 5.2 s per particle generation
- **What:** an avatar with a floating title BillboardGui ("Frost / Winter exclusive", Brightness 30), two hovering
  orbs, two snowflake emblems, beam "sleeves" on all four limbs, a big curved "Line beam" arc, a ground fog and ripple
  field and a sky glitter field. 58 emitters (mostly Rate, not bursts), 85 Beams, 4 scripts: the orbs bob 2 studs on a
  sine at pi/3 rad/s, the orbs and snowflakes drift on a 1-stud figure-8 (x = sin t, y = sin t cos t) (Script).
- **Phases (Seen):** 0.03 s the big arc reads as a wide solid translucent ribbon behind the avatar; 0.10-0.55 it reads
  as thin streak lines, plus the title (Rate emitters warming up; their layers fade in over half their life); 0.55-0.80
  first snowflake specks and a faint orb; 1.20 a frosted orb sphere, a snowflake starburst with a 4-point flare and the
  sky glitter band; 1.80 thin pale spiral rings start on the ground round the feet, dim fog wisps left and right;
  2.60-3.60 steady state: a full ground spiral of concentric thin rings (about 4x the avatar's height across), glitter
  density still rising.
- **Layer roles (Table):** sky glitter `106582379906133` (8x8 speck sheet, Size 13.4, Rate 20 on a 37x40 Disc, Br 20,
  acc +43.6, TimeScale 0.3) and rising glints `111508092337743` (VelocityParallel, Squash 1.1, Rate 9.45, Br 10-15);
  snowflakes `16924962354` / `97817549850353` (8x8, flat, Br 15-50, one at LE -3); orb fog stack (`16509892607`,
  `16509144751`, `15333819074`, `18539291909`, sizes 1.6-3, ZOffset 1.0/1.1/1.2); ground ripples (`9281305957`,
  `13367229656`, `96351874787069`) flat, 0 -> 31-35, Rate 8.9, Br 2.7; ground disc `2065086791` (LE 0 "darkground" and
  LE 0.2 "ground"), fog `94513258966357`; limb sleeves: 4 beams per limb at 0/90/180/270 deg (`11137657583`,
  `18837316844`, `13526801263`, `86470467217654` LE 1 Br 15 + `15398088681` LE 0 Br 4), TextureSpeed -1,
  FaceCamera off; anamorphic flare `84427792951578` Size 28-39 at Br 0.1-0.7 behind the title.
- **Techniques:** near-black colour x high Brightness as the tint control: #13161A at Br 10 adds (0.75, 0.86, 1.0) =
  #BEDCFF, the same pale ice blue icy types directly (#BCDCFF at Br 6); per-emitter TimeScale 0.3-0.8 to slow ambient
  layers; micro ZOffsets (0.001-0.008) to sort coplanar ground layers; 4-beam sleeve readable from every side.
- **Weak:** 85 beams + 58 emitters for an idle showcase; it takes ~1.2 s before anything reads (all fade-in, no
  opening beat); the character model itself is a plain R6 dummy.

### 5. `ab56eca4fb1c` icy.rbxm :: ice (single crystal eruption), est. 6.0 s
- **What:** 4 Glass MeshParts (`434582627`, #148CFF at Transparency 0.5: one 25-stud cone + three 10-11-stud chunks
  15-17 wide) and 18 emitters, all #BCDCFF, all fired at 0 (EmitCount only).
- **Phases (Seen):** 0.03 s the crystal cluster only (silvery glass with blue highlights), static to 3.6 s; 0.10 a
  white cracked-ice disc at the base with a spiky white fringe (about 1.7x the cluster width; the 0.28 s ring bursts
  and/or the crown, not separable); 0.20 one big 4-point glint on the crystal and the first dark ripple rings; 0.35
  small 4-point sparkles round the crystal; 0.55-1.20 two or three concentric ripple rings with pale rims and dark bands
  expand to ~3x the cluster width (they read as water ripples), white specks rise; 1.20-1.80 frost mist at the crystal's
  sides; 2.60 the disc is breaking into fragments, ripples gone; 3.60 dark fragments with white crack bits remain.
  Table: ring bursts 0-0.28 s; long rings 1-4.2 s; specks 0-2.2 s; wisps and fog 2-6 s; ground disc 6 s.
- **Layer roles (Table):** 6 flat ring/ground textures (`17225103010`, `108294254596627`, `17224592748`,
  `16777577977`, `18679627389`, `11541772958`) LE 1, Br 6, 18-24 studs, life 0.28-4.2, Transparency 0.59 -> 1 with
  envelope 0.08-0.15; crown `8133845150` (V of streaks on black) + `12683695494` (AuraCloud 8x8) VelocityPerpendicular,
  dir Back, SpreadAngle (0, 360), Speed 80, Drag 8.88, Br 20, 12 + 20; energy wisps `11941047152` / `12779603482`
  (8x8, LE 1, Br 6, Speed 24, Drag 2.79, 2-4 s); fog `11447021694` / `14066311352` (8x8, LE 0.2, Br 4, 2-6 s, z 4);
  specks `12222002958` (24 + 20, LE 0, Br 4, Speed 48, Drag 6, acc +20); glints `14221498728` (flicker size curve, and
  a Squash wobble, acc +80, z 6); ground ice disc `13781849388` (LE 0, Br 1.48) + twin `120945058729325` (LE 1, Br 6),
  Size 16, life 6.
- **Techniques:** long-life flat rings (`11541772958` 1-4.2 s, `18679627389` 1.8-2.4 s, `108294254596627` 2-2.6 s,
  18-24 studs, Transparency 0.59 -> 1) read as water ripples round frozen ground (Seen); a cracked-ice disc that crumbles
  through its flipbook over 6 s (Seen breaking at 2.6-3.6 s); Squash wobble 0 -> +0.79 @24% -> -0.26 @45% -> 0 with a
  size swell to 6 @31% (the glint layer; Seen as a 4-point sparkle at 0.20 s); specks that stay opaque and fade late
  (Transparency 0.18 @50%, 0.51 @80%) while floating up; Transparency envelopes for per-particle opacity variety; the
  same ground disc as solid (LE 0) + glow (LE 1) twins.
- **Weak:** single colour on 18 layers; the 8 ground/ring ids are outside the top-1500 index (no preview; check they
  still load); depends on the mesh for its silhouette.

### 6. `8679294aa869` zzzanimpractice :: Whirlwind VFX1 (water/wind vortex on the ground), est. 2.25 s
- **What:** 11 emitters on one 4.2-stud flat part, no scripts, no meshes. The cleanest file in the group.
- **Phases (Seen):** 0.03 s empty in the recapture (a small whirl of arcs in the first capture); 0.10 arcs at about
  half size, swirl smoke inside, bright cyan blobs; 0.20 widest arcs, first orange twinkles; 0.35 arcs breaking, dim
  slate-blue smoke, bright cyan droplets thrown upward (the LE 0 Br 15 rock sprites); 0.55 one large orange 4-point
  twinkle + faint ring; 0.80 faint remnant; 1.20 gone.
- **Layer roles (Table):** 3 whirl-ring textures (`99030912594735`, `73296613374574`, `84269775676097`) x4 each, flat,
  Size 0 -> 19.6, RotSpeed -450..-50 (one direction), LE 1, Br 0.5-1, #87B4FC, life 0.5-1.15 at TimeScale 0.5; shock
  disc `75353285142738` x1, 0.35 s at TimeScale 0.5; swirl smoke (`13726321388`, `16867530947`, `16867548275`) x6
  each, LE 1, Br 1.5-3, #73BAFC, Transparency 0.46-0.86 -> 1, dir Front, SpreadAngle (0, 360), Speed 5-65, Drag 6,
  Squash -0.2; twinkles `8180428772` (4 + 7, #FF7231, LE 0.76, Br 5); rock sprites `15441282898` (7, LE 0, Br 15,
  #5792FF).
- **Techniques:** one-direction spin makes a coherent whirlpool; front-loaded ring fade (0.49 -> 0.66 @15% -> 0.91 @34%
  -> 1) so the ring is brightest while small and fast; dim additive smoke reads as slate-blue water mass on a dark
  ground (Seen); a complementary orange accent of 11 tiny stars (Seen); rock sprites tinted #5792FF at LE 0 Br 15
  render as glowing cyan droplets, not rocks (Seen 0.10-0.55 s).
- **Weak:** no white core or flash (the burst has no opening beat); second rock layer has EmitCount 0 (dead); ring
  arcs are 90% transparent by the time they reach full size, so the peak footprint is faint.

## b. Anatomy of an ice / water effect

R = radius of the largest ground ring at the end of its life (Ice 20, icy 12, Whirlwind 10, FrostOs ~17 studs).
Sizes are ParticleEmitter Size values, which are HALF-widths (a sprite is 2x its Size across, measured
2026-11-14): where this note says "diameter", read "Size". Multiples of R compare particles with particles correctly;
compare with beam widths or part sizes at 2x. "Flat" = VelocityPerpendicular, EmissionDirection Top, Speed 0.0006-0.03.
Reach = how far a particle travels, about Speed / Drag.

| # | Role (firing order) | Textures seen here | Orientation / emission | LE / Br | Life s | Size (diam vs R) and curve | Transparency | Motion | Count / flip / ZOffset |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Flash (white core) | `18397658030` (Ice), `107821950776778` (poly), `113678423988783` (Chara), `99849115529087` (poly) | FacingCamera (Chara: flat) | LE 1, Br 0.5-2 (Ice: LE 0 Br 2, too faint) | 0.05-0.2 | 0.7-1.25 R; grows from 5-10% (Ice 1 -> 9.3 @28% -> 14.6) or const | Ice 0.85 -> 1; poly 0 const then cut | none | 1-3 / none / 0-4 |
| 2 | Ground hit ring (flipbook) | `13778611432`, `16125610617` (Ice), `75353285142738` (WW) | flat | Ice LE 0 Br 10; WW LE 1 Br 0.5 | 0.26-0.43 (WW 0.7 real) | 1.5-2 R; Ice STARTS at 0.4 R (8 -> 40.5) on a t^0.3 curve (49% @10%, 65% @20%, 84% @50%) | Ice 1 -> 0 @15%, hold to 75%, -> 1; WW 0.49 -> 0.66 @15% -> 0.91 @34% -> 1 | none; Ice Squash envelope 0.5 | 1-5 / 4x4 OneShot / 0. Seen (Ice): from the low capture camera only thin horizontal streaks at 0.20 s |
| 3 | Spinning rings (wind, water, frost) | WW `99030912594735` `73296613374574` `84269775676097`; Ice `18652132265` `123630005106717` `18684145757` `88836910549343` `18397737060`; icy 6 ids | flat (SpreadAngle 0-45 for tilt) | LE 1 Br 0.5-1 (WW), LE 1 Br 6 (icy), LE 0 Br 10 (Ice) | 0.28-3.5 (WW 1-2.3 real) | 0 -> 0.9-2 R, ease-out (WW 30% @4%, 49% @9%, 80% @44%) | never below 0.49: start 0.49-0.81 -> 1 | RotSpeed -450..-50 one-way (WW) or +-4-24, 70 (Ice/icy) | 1-8 (median 4) / none / 0. Seen: WW arcs read as a whirl; icy's 1-4.2 s rings as concentric water ripples (pale rims, dark bands) to ~3x the cluster width; Ice's rings not readable (edge-on) |
| 4 | Ice crown (standing radial cards) | `8133845150`, `12683695494` (icy) | VelocityPerpendicular, dir Back, SpreadAngle (0, 360) | LE 1, Br 20 | 0.46-0.6 | 0 -> 0.67 R ease-out | 0.68 -> 1 | Speed 80, Drag 8.88 (reach ~0.75 R); Rotation fixed -180 | 12-20 / 8x8 OneShot (cloud) / 0 |
| 5 | Radial ground mist (fan) | Ice `16867447521` `16867387523` `16867344972` `83337784980211` `93383785948325`; WW `13726321388` `16867530947` `16867548275` | FacingCamera, dir Front/Back, SpreadAngle (0-9, 360) = flat fan | Ice LE 0 Br 10; WW LE 1 Br 1.5-3 | 0.3-0.76 fast; 0.85-1.5 WW | 0 -> 0.35-0.7 R (WW 4 = 0.4 R), ease-out (WW 23% @2.5%, 62% @19%) | Ice 1 -> 0.36 @5% -> 1; WW 0.46-0.86 -> 1 | Speed 35-160, Drag 5.3-6 (reach 0.35-1.5 R); WW Squash -0.2 | 4-22 per layer (Ice ~55 fast) / 4x4 OneShot / 0-1 |
| 6 | Up plume (toon puffs) | `138231890129613`, `101430476623997`, `125716684677906`, `139474473857712` (Ice) | VelocityParallel, dir Top, spread 45 | LE 0, Br 10 | 0.4-3.9 | 0 -> 0.33-0.9 R (envelope 0.7-1.1) | 0.5-0.9 -> 1 (faint) | Speed 19-90, Drag 3.5-8 | 2-6 / 4x4 OneShot / 0 |
| 7 | Ice dust specks | `12222002958` (icy) | FacingCamera, spread 360 | LE 0, Br 4 | 1-2.2 | 0 -> 0.02-0.07 R (0.28-0.88 studs) ease-out | 0, ease-in fade (0.18 @50%, 0.51 @80%, 0.70 @90%) | Speed 48, Drag 6 (reach 0.67 R), acc +20, RotSpeed +-200-280 | 20-24 / none / 4 |
| 8 | Sparkles / twinkles | `11932690139`, `137831468` (Ice), `8180428772` (WW), Chara stars | FacingCamera | LE 0.76-1 Br 4-5; Chara LE -3 Br 15 | 0.5-2.25 (Ice 2-3 real) | 0.5-1.2 studs with blink curves (section d) | 0 | Speed 0-100, Drag 3-5, spread 100-360 | 4-25 (Ice 2 x 25 twins) / none / 2 |
| 9 | Debris / glints | `15441282898` (WW), `14221498728` (icy) | FacingCamera | rocks LE 0 Br 15 tinted #5792FF (Seen as glowing cyan droplets); glints LE 0 Br 2.8 (Seen as a 4-point sparkle) | 0.4-0.85 | rocks swell 0 -> 0.5 @32% -> 0, Squash 0.25; glints swell to 2.5-6 | 0 | rocks Speed 0-40, Drag 3 (acc -20); glints Speed 48-60, Drag 6, acc +80 | 4-20 / 2x2 Loop fps 0 StartRandom / 0-6 |
| 10 | Ground decal linger (crack, frost) | `99911247720869`, `130658933079638` (Ice), `13781849388` + `120945058729325` (icy) | flat | LE 0 Br 1.5-4 (+ LE 1 Br 6 twin) | 3-6 | const 0.75-1.3 R | Ice crack 1 -> 0 @70% -> 1 (slow reveal, Table only); Ice crater 0.74 (x100 = opaque); icy 0 const (flipbook crumbles it) | none | 1 (Ice crater x100: avoid) / icy 4x4 OneShot / 0. Seen: both files show white ground frost from 0.10 s with the hit, holding to 2.6 s; icy's disc crumbles 2.6-3.6 s, Ice's fades by 3.6 s |
| 11 | Linger fog / slow smoke | `11447021694`, `14066311352` (icy), Ice `83337784980211` `106361267446501` `96092264894202` | FacingCamera, spread 360 | LE 0.2 Br 4 (icy); LE 0 Br 10 (Ice) | 2-6 (Ice up to 7.9) | 0 -> 1 R, 85% reached @10% | 0.6 -> 1 ease-out (icy); 1 -> 0.5-0.85 @22% -> 1 (Ice) | Speed 3-112, Drag 2.3-4.4, acc +6 | 4-11 / 8x8 or 4x4 OneShot / 1-4. Seen: Ice puffs drift out low and darken to slate 0.8-1.8 s; icy mist at the crystal's sides 1.2-1.8 s |
| 12 | Light | Ice PointLight; poly 2 PointLights | - | Br 2-3 | static | Range 1.25 R (Ice 25); poly 5 | - | - | 1 |
| 13 | Ink / dark (rare here) | poly `120806769380157` `96754486633479` `7832491488`; FrostOs `94513258966357` `104888060261813` `2065086791`, beam `15398088681` | flat + FacingCamera | LE 0 at Br 0.01-0.12 (any hue -> ink); FrostOs #13161A | 1-4 | 0.5-1 R | 0 const (poly) | none | 1 per sprite / 4x4 (FrostOs) / -0.001 below other ground layers. Seen (poly): black splats lying on the ground at 0.10 s |
| 14 | Crystal meshes | Ice `75306692763883` + texture `110424748403202`; icy `434582627` | Glass | Ice Transparency 0, grey (202,202,202) + texture; icy #148CFF Transparency 0.5 | static here | 1.25-2.5 R tall (Ice 15-31, icy 25) | - | - | 4-10. Seen: Ice crystals white-hot centres with saturated blue tips; icy silvery clear glass with blue highlights |

Three tones in this group: white core = crystal centres and ground frost (rows 14, 10, Seen), flash (row 1), sparkles
(8) and specks (7); saturated body = crystal tips, rings, mist, plume, fog, debris in #73BAFC / #80C8FF / #87B4FC /
#BCDCFF / #5792FF; ink = only polething and FrostOs (row 13). The ice files skip the ink layer entirely (section e).

## c. Timing

| Phase | Ice (Seen; fires at 0.07) | icy (Seen) | Whirlwind (Seen) | polething (Seen) | Chara (Seen) | Typical |
|---|---|---|---|---|---|---|
| Fire | 0.07 (Table) | 0 | 0 | 0 | 0 | 0 (Ice delays 0.07 to sync with its crystals/animation) |
| Flash | none visible | none | none | 0-0.1 (first capture) | 0-0.05 (first capture) | 0-0.15 |
| Ring / impact peak | 0.10-0.20 (ground splash, edge-on ring streaks) | 0.10-0.20 (disc + spiky fringe, big glint) | 0.10-0.35 | 0.10-0.35 | 0.10 | 0.1-0.35 |
| Body (mist, ripples, specks, twinkles) | 0.35-1.8 (puffs) | 0.2-1.8 (ripples, specks, mist) | 0.1-0.55 | 0.35-0.8 | 0.1-0.2 | 0.1-1.8 |
| Fade | 1.8-2.6 | 1.8-2.6 | 0.55-0.8 | 0.8-1.2 | 0.2-0.35 | 0.5-2.6 |
| Linger | ground splash to 2.6, gone by 3.6 (Table: slow smoke to 7.9) | disc crumbling 2.6-3.6 (Table: 6 s) | gone by 1.2 | gone by 1.8 | gone by 0.55 | ice 2.6-3.6 s; water 1.2 s |

Variation: the impact (ring peak 0.1-0.35 s) is the same in every burst here. What separates ice from water is the
body and the tail: the ice files keep mist/ripples to 1.8 s and white ground frost to 2.6-3.6 s (frozen ground stays),
the water/wind vortex is gone by 1.2 s and the polething smoke by 1.8 s. FrostOs (continuous) needs ~1.2 s to read,
~1.8 s before its ground spiral starts and ~3.6 s to fill.

## d. Techniques catalogue (exact recipes)

1. **Tint by a near-black colour x high Brightness** (FrostOs): Color #13161A, LE 1, Brightness 10 adds #BEDCFF
   (0.0745 x 10, 0.0863 x 10, 0.102 x 10); Br 15 overflows to white with a blue bloom. The colour sets the hue RATIO,
   Brightness the value, and one number moves an entire layer from dim haze (Br 0.1-0.7 on Size 28-39 flares) to
   white-hot (Br 15-50 on Size 1.5-6 sparks). Same hue as icy's direct #BCDCFF at Br 6.
2. **Ink from any hue: LE 0 + Brightness 0.01-0.1** (polething): #FFA43C at Br 0.01-0.05 renders as near-black warm
   ink splats (Seen 0.03-0.2 s). The ink keeps a trace of the body hue, so it reads as the effect's own shadow. For
   ice: body colour at Br 0.05-0.1, or Color #0A1430 at Br 1.
3. **Solid ice matter: LE 0 + Brightness 10 on a light cyan** (Ice, all 29 layers, #80C8FF): non-additive, so it
   covers the background instead of washing to white; puffs read soft pale mint/cyan-grey and darken to slate as they
   thin over the dark ground (Seen 0.35-1.8 s). Vault rule "water and dense matter look solid when not additive" with
   the number.
4. **Flat radial fan** (Whirlwind, Ice): EmissionDirection Front (or Back) + SpreadAngle (0-9, 360) + Speed 35-160 +
   Drag 5.3-6 = a ground-hugging ring of smoke that shoots out to Speed/Drag studs and stops (horizontal in the
   Whirlwind stills). Add Squash -0.2 (wider than tall) for a flattened water spray.
5. **Standing crown of cards** (icy, Inferred: the spiky white fringe Seen at 0.10 s fits it but cannot be separated
   from the 0.28 s ring bursts): the same fan with Orientation VelocityPerpendicular makes
   each card face outward and stand up around the centre; Speed 80, Drag 8.88 (reach ~9 studs), Rotation fixed -180
   (flips the V-streak texture `8133845150` into an upward spike), Size 0 -> 8 ease-out, Transparency 0.68 -> 1, LE 1,
   Br 20, 12 cards.
6. **Ring born open** (Ice hit rings): Size starts at 0.2 of final (8 -> 40.5 or 6.2 -> 31) so frame 1 is already a
   ring, not a dot; Transparency 1 -> 0 in the first 15% (fade-in of 0.04-0.06 s, softer than a pop) and held to 75%.
7. **Power-law ease-out written as 11 keypoints**: Ice rings reach 49% @10%, 65% @20%, 75% @30%, 84% @50%, 90% @70%
   (about t^0.3); icy rings 68% @10%, 83% @20%, 95% @40% (sharper, expo-like); Whirlwind 30% @4%, 49% @9%, 61% @17%,
   70% @27%, 80% @44%, 88% @62%. In our runtime: quintOut/expoOut for icy, quartOut-ish for Ice/Whirlwind.
8. **Front-loaded ring fade** (Whirlwind): Transparency 0.49 -> 0.66 @15% -> 0.91 @34% -> 0.95 @41% -> 0.98 @54% -> 1;
   paired with the ease-out size, the ring is at its brightest while small and fast and thins as it slows.
9. **One-way whirlpool spin** (Whirlwind): RotSpeed -450..-50 (all negative) on 12 flat ring particles = a coherent
   vortex; random-sign +-4-24 deg/s (Ice, icy) only drifts.
10. **TimeScale per emitter to stretch a layer** (Whirlwind 0.5 on rings/shock, Ice 0.5 on sparks and 0.65 on the
    flash, FrostOs 0.3-0.8 on ambient layers): curves keep their shape, real duration = Lifetime / TimeScale. Our
    runtime overwrites TimeScale (speed control), so fold it into Lifetime instead.
11. **Delayed twinkle from one burst** (Whirlwind, extends the vault's two-bump twinkle): Size {0,0} {0.179,0} {0.259,
    0.908} {0.355,0} {1,0} with Lifetime 0.5-1.35 makes each star invisible, then twinkle once at a random moment
    between 0.09 and 0.48 s, so 7 particles from one Emit read as a sparkle sequence.
12. **Double blink** (Ice sparks): Size 0.498 -> 0 @29.4%, 0 until 29.5%, 0.498 @35.7%, 0 @66.3%; Lifetime 1-1.5 at
    TimeScale 0.5; the same burst emitted twice with two textures (additive cross `11932690139` LE 1 Br 5 and
    `137831468` LE 0 Br 4) for a glow + solid pair.
13. **Squash wobble = liquid pop** (icy glint): Squash 0 -> +0.79 @24% -> -0.26 @45% -> 0 with Size 0 -> 6 @31% ->
    2.05 @41% -> 1.18 @61% -> 0: stretches tall, squashes wide, settles. Use for water droplets and splash blobs.
14. **Size flicker glint** (icy): Size 0 -> 0.22 @13% -> 1.9 @23% -> 2.45 @31% -> 0.67 @38% -> 0.33 @55% -> 2.07 @61%
    -> 0.69 @70% -> 0 plus Transparency 0 -> 0 @39% -> 0.87 @48% -> 0 @70% -> 1: an ice glint that flares twice.
15. **Ground frost that lands with the hit** (Ice, icy, Seen): white ground frost appears at 0.10 s and holds to 2.6 s
    (Ice: crater `130658933079638` Size 20.2, Lifetime 3, Transparency 0.74 stacked x100 = opaque; icy: cracked-ice
    disc `13781849388` Size 16, 6 s, Transparency 0, crumbling through its flipbook from ~2.6 s). Ice also carries a
    slow-reveal crack (`99911247720869`, 14.7 studs, Transparency 1 -> 0 @70% -> 1, peak 2.1 s after the hit) but on
    screen it is hidden behind the crater splash: Table only.
16. **Late-fading ice dust** (icy specks): Transparency 0 held, ease-in fade (0.18 @50%, 0.51 @80%, 0.70 @90%), acc
    +20 Y, Speed 48, Drag 6: crystals burst 8 studs, hang, float up and vanish late.
17. **Random static debris frame** (Whirlwind rocks): FlipbookLayout Grid2x2 + FlipbookMode Loop + FlipbookFramerate 0
    + FlipbookStartRandom true = each particle shows one random rock of four, no animation. Tinted #5792FF at LE 0
    Br 15 they render as glowing cyan droplets/gems, not rocks (Seen 0.10-0.55 s): a free water-droplet layer.
18. **Complementary accent** (Whirlwind): 11 orange (#FF7231) 4-point stars at Size <= 0.9 in a blue effect; small
    and few, so they accent without changing the effect's colour.
19. **Dim additive smoke as water mass** (Whirlwind): LE 1, Br 1.5-3, Transparency 0.46-0.86 on #73BAFC renders as
    slate-blue blobs on a dark ground (Seen 0.2-0.55 s); it only works on a dark background.
20. **Solid + glow twin of one ground decal** (icy): `13781849388` at LE 0 Br 1.48 and `120945058729325` at LE 1 Br 6,
    both Size 16, Lifetime 6, emitted together.
21. **Flat + facing pair** (polething): each glow/splat emitted twice, VelocityPerpendicular and FacingCamera, same
    Size and life, so it reads from a top-down and a side camera.
22. **Many near-invisible particles = soft volume** (Chara): 85 pixel-smoke particles at Transparency 0.94 build a
    visible cloud only where they overlap; edges stay invisible.
23. **Negative LE + high Brightness for saturated hot sparks** (Chara LE -3 Br 15 #FF3939; FrostOs snowflake LE -3 Br
    50): red stars with white-hot cores and a coloured bloom halo (Seen in Chara).
24. **Random mirror of a flat card** (Chara): Speed range -0.303..0.303 with VelocityPerpendicular flips the card up
    or down at random.
25. **Micro ZOffsets to sort coplanar ground layers** (FrostOs): ground glow 0, dark ground -0.001, fogs 0.004-0.008,
    effect 0.004: a stable draw order without visible displacement. Rings in front of big smoke: ZOffset 6.8-8.2
    (polething).
26. **4-beam sleeve** (FrostOs limbs): 4 non-FaceCamera beams at 0/90/180/270 deg around a limb, Width 1-1.2,
    TextureSpeed -1, 4 additive (#13161A Br 15) + 1 dark (LE 0 Br 4): a volumetric frost wrap from any angle.
27. **Area fields from a Disc emitter** (FrostOs): Shape Disc on a 37-45 stud part, Rate 20-25, TimeScale 0.3-0.5:
    glitter and fog spread over an area with no extra emitters.
28. **Showcase fade-in** (FrostOs continuous layers): Transparency 1 -> min @50% -> 1 on 2-5 s lives: every particle
    eases in and out, so a Rate emitter never pops (at the cost of a ~1.2 s empty start).
29. **Ripples round frozen ground** (icy, Seen 0.20-1.80 s): 3 flat ring layers with long lives (1-4.2 s), Size 0 ->
    18-24 on an expo-like curve (67% @10%, 83% @20%), Transparency 0.59 -> 0.68 @10% -> 0.85 @38% -> 1 @80% with
    envelope 0.08-0.15, RotSpeed +-6-24, LE 1, Br 6, 4-6 each: two or three concentric rings with pale rims and dark
    bands reach ~3x the crystal cluster's width; on a dark floor they read as water ripples.
30. **The mesh carries two tones** (Ice, icy, Seen): Glass crystals at Transparency 0 in light grey with a texture
    render white-hot centres and saturated blue tips under bloom (Ice); Glass at Transparency 0.5 in #148CFF renders as
    silvery clear ice with blue highlights (icy). The particles then only need body and ink.

## e. Mistakes / weak spots (avoid)

1. **Emitters placed far below the model's centre** (Ice 11 studs, icy 12.7): anything that places the effect by its
   bounding box (our first replay capture, a dev dragging it, `PivotTo` on a model without PrimaryPart) buries the
   burst. Set the PrimaryPart to the ground anchor.
2. **One colour on every particle layer** (Ice 29/29 #80C8FF, icy 18/18 #BCDCFF): the white comes only from the
   crystal meshes and the ground frost (Seen); mist and rings share one pale tone and there is no ink. None of the four
   real ice/water files has a dark layer.
3. **Stacking copies for opacity** (Ice crater, EmitCount 100 at Transparency 0.74): 100 particles to fake one opaque
   decal. Use 1 particle at the wanted transparency.
4. **No opening beat** (Whirlwind, FrostOs, icy): no flash, so the burst starts on a faint small ring; FrostOs needs
   1.2 s before anything reads.
5. **Rings already 90% transparent at full size** (Whirlwind): the biggest footprint is the faintest; fine for wind,
   too weak for an impact.
6. **Dead and near-dead layers**: Whirlwind `Rocks 2x21` EmitCount 0; polething ~20 additive rings at Br 0.05;
   Ice flash ring LE 0 at Transparency 0.85 (almost invisible).
7. **Budget**: polething 155 emitters, FrostOs 85 beams + 58 emitters (idle showcase), Ice ~280 particles per burst
   incl. the 100 crater copies. Whirlwind does a full vortex with 11 emitters and 49 particles.
8. **Unpreviewable textures**: icy's 8 ground/ring ids and 22 of FrostOs's ids are outside the top-1500 index; some
   may no longer load. Check in Studio before reuse.
9. **Meshes without motion**: both crystal files ship static crystals; any grow-in lives in a missing tweener (Ice's
   all-zero CFrame/Size/Transparency/Duration attributes). Copying the file gives crystals that just appear (Seen: full
   size at 0.03 s in both).
10. **Flat rings vanish from a low camera** (Ice, Seen): Ice's 7 hit flipbooks (to 40 studs) and 6 wind rings show only
    as thin horizontal streaks at 0.20 s from a camera ~15-25 deg above the ground; Whirlwind's and icy's rings read
    because they are brighter (LE 1) and long-lived. For a third-person game camera give each important ground ring a
    FacingCamera twin (polething's pair, d21) or keep it LE 1 with Transparency <= 0.6.
11. **Dark sprite with a visible square edge** (polething, Seen 0.55 s): a LE 0 dark ground sprite shows the straight
    border of its texture. Check every LE 0 texture on a light background before shipping (texture-vocab "on BLACK").

## f. What this adds to PATTERNS.md

- Rule 1 (three tones) holds as a gap here: the ice files are single-tone; build the ink with LE 0 + Br 0.01-0.1 or a
  #0A1430 under-disc.
- New: tint control by near-black x Brightness (d1), solid matter by LE 0 + Br 10 (d3), flat radial fan (d4), born-open
  rings (d6), one-way spin (d9), delayed twinkle (d11), squash wobble (d13), ground frost that lands with the hit
  (d15), LE 0 Br 15 droplets (d17), ripples (d29), crystal meshes as the white core (d30).
- Ice vs water timing: same 0.1-0.35 s impact peak; ice keeps mist/ripples to 1.8 s and ground frost to 2.6-3.6 s,
  water ends by 1.2 s.
- Flat ground rings need a FacingCamera twin or LE 1 to survive a low camera (e10).
- Pipeline: the first capture's bbox-centre pivot sank ground emitters of tall effects; fixed and recaptured (section 0).
- Recipe: `icewater_recipe.luau` (same folder), an untested draft.
