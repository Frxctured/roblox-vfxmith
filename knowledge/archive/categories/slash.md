---
title: Slash and sword VFX - lessons from 6 open-source effects
source: open-source VFX library (Discord packs) studied 2026-11-13
tags: [vfx, slash, sword, crescent, flipbook, particles, roblox, os-library, brightness, light-emission, ink, three-tone, speed-lines, sparks]
---

# Slash / sword: what 6 open-source effects teach

Evidence: freeze-frame stills from the Edit-mode replayer (recapture 2026-11-14 with placement and framing fixed:
`gallery/effects/slash/<id>.jpg`; the first capture the first capture (not shipped) only where noted), the layer tables
(`library/cards/<category>/<id>.md`), the raw property dumps (the decoded pack files (`kit/scripts/rbxdump.py`), read for exact curves) and
the packs' own scripts (read as text: `glassComboScript`, MoltenSlashes `Event Codes!!`, SacredSwords `Gate/Event`).
Library-wide numbers come from `catalog/effects.jsonl` (1,212 effects tagged `slash`). Nothing was run in Studio.
Extends `PATTERNS.md` and the vault note "Slash VFX Recipes - Crescent and Ring"; it does not repeat them.

Honest scope: only 3 of the 6 are real slash hits (glassSlash2, Molten Slash1/Attachment1, pizza). The others were
tagged by keyword: a sword-summon portal (SacredSwords), a weapon idle aura (axe) and a small ground "pull" burst. They
still teach sparks, flashes and dark discs, and they are used for that only.

**Every layer in all 6 fires at t = 0** (no EmitDelay anywhere). The stagger on screen comes from flipbooks drawing the
sweep, Size curves starting at 0, fade-in Transparency keys and drag. The sequencing between bursts (slash 1, 2, 3)
lives in the game's animation events, not in the effect.

S below = the slash card size of that effect (the main crescent sprite's Size, ~2x the swing radius).

**Recapture (2026-11-14):** the first sheets placed Molten, glass, pizza and the portal too low and framed some
badly. All phases below are re-read from the recapture (effects standing on the floor, camera re-aimed and locked,
a lighter blue-grey stage). It changed Molten most: one horizontal crescent, a flash caught at 0.03 s, and the body
gone by 0.35 s (a large vertical arc in the first capture was a framing artifact). The 2-4-frame flashes are hit
and miss between the two captures (glass and the portal showed theirs at 0.03 s only in the first capture).

---------------------------------------------------------------------------------------------------------------

## a. The effects

### e68be036caa3 glassSlash2 (glassComboOS) - violet/cream glass slash, ~0.5 s, the cleanest of the group
- Phases: pop 0-0.06 s (violet-white Star99 cross, Size 20.5-24.6 -> 0 in 0.06 s, plus Impact591 radial burst
  0 -> 16 in 0.03 s, ZOffset 4; seen at 0.03 s in the first capture, missed in the recapture where 0.03 s is empty);
  0.10 s peak: a wide white crescent with an ice-blue fringe lying in the horizontal plane, violet-outlined glass
  diamonds and blue specks flying up, soft blue-white puffs under the arc; **0.20 s the crescent has turned violet
  (the ramp's end) and a solid black band hugs its inner side** (the Br-0 ink cards), cream and blue specks, faint wind
  arcs on the floor; 0.35 s crescent gone, dark grey toon puffs (`11857153748`/`16867377762`) and a few specks;
  0.55 s a few specks; 0.80 s empty. S = 14 (cards 8-15.2).
- Layers: flat VelocityPerpendicular cards, EmissionDirection Top, Speed 0.0014, life 0.3, Transparency
  `1 -> 0 @0.2, 0 @0.7 -> 1`: hot opaque body `84127812322926` (LE 0, Br 10, ramp cream #FFE19C -> #82B2F0 @0.39 ->
  violet #7B70F8 @0.66, RotSpeed 0); additive copy `109175499924375` (LE 1, Br 10, RotSpeed -360); ink `9181472195`
  (LE 0, **Br 0**, RotSpeed -360, ZOffset -0.5) and three ink `81933089813046` cards (Br 0, sizes 8.0/13.8/15.2,
  RotSpeed -180); each card has its own fixed Rotation 270/300/320/340/360.
- Techniques: (1) one hot opaque card stays still while the flipbook draws, the additive copy and the inks turn
  -360 deg/s (108 deg over life) and -180 deg/s (54 deg), so the dark smear lags further behind every frame;
  (2) the same shard and spec layers are pasted as three palette copies (cream, blue, violet) instead of a colour ramp;
  (3) a frame-1 pop that starts at full size and shrinks; (4) ground rings with a Size envelope (11.2 +-5.6 -> 20) so
  every ring has a different radius.
- Missing from the stills (script `glassComboScript`): the 3 curved beams (CurveSize -14.9, 40 segments, widths 0->30,
  5->25, 0.8->25 from attributes) on a part yawed -175 deg in 0.25 s linear while the widths tween to 0 (a sweeping arc
  smear), the Neon wind MeshParts (Size0 -> Size1 Quad Out, random 0.x s), sword Trails and a Highlight.
- Weak: 6 of 40 emitters are near-dead (Blurred Spec 6 at Br 0.005, Fancy Dissapearing Smoke Br 0.02, a
  `13780268621` card at LE 1 Br 0.01); specks move only 4-14 studs/s with no drag, so they drift like confetti instead
  of bursting; 40 emitters but 24 distinct designs (copies on 3 attachments).

### 63020ef9dca0 MoltenSlashes Slash1/Attachment1 - molten red/yellow crescent, ~1.2 s, best colour work
- Phases: **0.03 s pop: a long diagonal orange-white needle with a 4-point star at its centre** (Star99 0 -> 21.9 in
  0.051 s with Squash 1, Star145, ZOffset 10) over a thin red crescent with a black inner band already drawn; **0.10 s
  peak: horizontal crescent with a yellow-white core and orange body**, glowing red blobs (off-centre specks, Size
  3.9 -> 0, LE 0 Br 40), red streak sparks; 0.20 s crescent thinner, yellow at its head, blobs spread; 0.35 s the
  crescent is gone except a faint red ghost arc and a red hook, a dim red haze (the 18.7-stud glow) and red specks;
  0.55 s a few specks and haze; 0.80 s last specks; 1.2 s gone. S = 15.3 (cards 10-22).
- Layers: the cards use EmissionDirection Top/Bottom and Left/Right on differently placed attachments, but the
  recapture shows a single horizontal crescent (no vertical card set is visible). Body `133081786271698`/`113437526450803`/`131322386208077` at **colour #721A00, LE 0, Br 55-75**,
  life 0.5-0.63, Transparency 0 to 0.4 of life then out (yet nothing of them shows after 0.35 s: their sheets
  presumably run out of drawn cells early, unverified); `115403448342847` "Main slash" ramp #FF815C -> #DB3100 @0.45 ->
  **#0A0A0A from 0.64** (burns to black, life 0.25); black `17308625856` (Br 0, size 18.1, RotSpeed only -40);
  details spinning +157..+627 and -282..-1270 deg/s; ghost crescents (Meshed Linger `104185000871508`, Thin Winds
  `123392140151112`, Crescent `129605283585453`...) growing 0 -> 16-22 over 0.32-1.7 s, never more opaque than 0.36-0.38.
- Techniques: (1) HDR hue shift: dark red x Brightness 75 at LE 0 clips the bright texels to yellow-white and leaves
  the soft ones red (the molten look, no white layer needed); (2) almost everything is LE 0 (58 of 62 emitters), so
  stacked layers occlude instead of washing out, while Br 6-75 still feeds bloom; (3) the same 4-layer spark set copied
  on 6 attachments along the arc, 1-2 particles each, Speed 7.3 backwards + Acceleration -8.5 X: sparks peel off the
  arc and drift behind; (4) micro ZOffsets 0.001-0.004 sort coplanar cards.
- Missing: the pack fires 5 attachments from animation events (`Attachment`, `Attachment1`, `Attachment2`, `Attachment5`
  bursts, `Attachment4` enabled between two events); this is one of them. 16 beams (CurveSize 15.8-19, 50 segments)
  are authored at Width 0 with widths only in attributes; no beam arc shows in the recapture.
- Weak: 62 emitters for one hit, and the long-life body cards (0.5-0.63 s) add nothing visible after 0.35 s.

### f4fefa4bc478 pizza (slashes.rbxm) - red streak slash with a glowing crescent, 0.8 s+ in the stills
- Phases (unchanged in the recapture): 0.03 s empty in both captures (no flash layer, every layer starts at Size 0 or
  Transparency 1); 0.10 s parallel red speed lines and a few sparks; 0.20 s a hot pink-white spark cluster, red fog and
  two white-hot streaks; 0.35-0.55 s full crescent (hot pink-white outer edge, red body) with red flame wisps streaming
  behind, black flecks inside the wisps (the black LE 0.5-0.7 copies); 0.80 s the crescent alone. S = 15.3 (crescents 14.5-18.9, overlay 29.2).
- Layers: crescents `70757453255007` / `139843022964858` (VelocityPerpendicular, Size const, Squash -0.2..-0.5,
  Transparency `1 -> 0 @0.5 -> 1`, life 0.4-0.7, **Enabled with Rate 5-8, no EmitCount**); black crescents behind
  (`yes` black LE 0.7 Br 5, `yea` black LE -0.25 Br 0.2, size 18.9 = 1.25x); a 2x overlay `137926940506348` at
  Transparency 0.9; streaks: VelocityParallel, Speed 36-153, Drag 1-15, Squash growing to 0.5-5, life 0.15-0.2.
- Techniques: (1) speed lines `139843022964858`: Size 5 -> 0 while Squash 0 -> 5, Speed 72-144, Drag 5 = streaks
  that stretch while thinning; (2) a dark twin of the same streak (#0C0405, LE -0.5, Br 45); (3) red and black copies
  of one flipbook (`13013256540`, LE 0.67) with opposite Squash (-0.2 / +0.2) and a later dark peak (0.5 vs 0.8 of
  life) so the dark one peeks out round the bright one; (4) a 360 deg spark burst with Acceleration {600, -50, 0}
  (Speed 76-153, Drag 15) that the "wind" bends into the swing direction within ~0.1 s.
- Weak: all 18 emitters are saved Enabled = true (Rate 4-50/s) and the pack has no script, so the stills mix the
  bursts with endless streams (the crescent is still bright at 0.8 s); in a game it needs on/off timing. No flash layer at all (no pop).

### 7332b80f6ea7 SacredSwords Portal - golden sword-summon portal, ~1.8 s visible (est 3.5 s)
- Phases: flash `10198439352` x5 (Size 47.6 -> 0, life 0.06-0.12, Br 25, ZOffset 7) filled the frame at 0.03 s in
  the first capture and is missed in the recapture (0.03 s empty); 0.10 s a bright golden disc with a white-hot core
  and a spark burst; 0.20-0.35 s concentric spinning rings open, gold specks and streaks fly out in every direction
  (Halo `12591390025` RotSpeed 90, `127305503135163`/`97043414581087` -30..-50, Spread 30); 0.55-0.8 s wider faint
  outer rings, specks; 1.2 s rings still turning (no dip: the first capture's dip was the bug); 1.8 s only dim gold
  flecks; 2.6 s gone. The disc stands vertical and centred at floor level, so its lower half is under the floor in
  both captures (in game it floats 45 studs up).
- Layers: vertical VelocityPerpendicular discs (EmissionDirection Front, 5-19 studs, mostly LockedToPart), a dark core
  disc `93425112299725` at **LE -3**, ZOffset -1 behind the bright rings; burst: 5 flame-flick flipbooks
  (VelocityParallel, Speed 35-58, Drag 5.15, Spread 15, Squash 0.5-1), SparksLinger `7922645282` x2 (25 each, Br 35),
  `15394198783`/`125523015121474` dots (Br 35-45, Speed 41-110, Drag 6.9), `6889406891` needles (20, Speed 68-102,
  Drag 20, Squash -3 -> 3 @0.1 -> -3).
- Techniques: (1) sparks that pop and hang: Size swell 0 -> 0.41 at 6% of a 0.58-1.75-s life, Speed 14-97, Drag 5.15;
  (2) the negative-LE disc makes a dark hole in the middle of a bright portal; (3) a Squash curve that flips -3 -> +3
  -> -3 so a needle flickers wide/long/wide.
- Missing (script `Gate/Event`): in game the `Main` emitters run continuously (`dots`, `Lines` have EmitCount 0) for
  ~1.9 s, the `Explode` burst fires at 0.5 s (here at 0), a sword fades in over 1 s and launches in 0.4 s Back-In, and
  15 portals open 0.2 s apart. The 1-frame flash is ~4x the ring size: fine once, too big for a repeated hit.

### 0096e92dbea5 MoltenSlashes PullVFX - small sword-pull spark burst, ~1.2 s visible (est 3 s)
- Phases (recapture, framed close): 0.03 s a little grey dust; 0.10 s a white-orange fan of flame flicks shooting up;
  0.20 s an upward spark spray over grey dust; 0.35 s sparks at the top of their rise, embers and grey smoke; 0.55 s
  sparks arcing back down (gravity -15); 0.80 s scattered embers; 1.2 s a few embers; 1.8 s almost nothing; 2.6 s gone.
- Layers: sparks `18446116252` x75 and `15287960804` x20 (VelocityParallel, Speed 18-35, Drag 4, gravity -15.3, life
  1.1-2.6, Size 0.49 -> 0); grey smoke (#747474, **LE 0.1-0.2** so it is not dead black, Speed 0-25.6, Drag 4.8-5.5,
  gravity -10); flame flicks `13734332372`/`13829787503` (Squash 0.5-2.1, life 0.05-0.6); rocks tinted to the floor
  (`UseGroundColor`, LightInfluence 0.75).
- Weak: authored tiny (sparks 0.5, smoke 0.8-1.4, rocks Size **0.08** = invisible). Framed close it reads as a good
  spark fountain; at game distance it is a 2-3-stud event, so scale it up 3-5x for a sword hit.

### 2c929d480787 "dull ur axe" - weapon idle aura, not a hit
- 42 continuous emitters (6 copies of one 7-layer set on the axe mesh): yellow glow (dark olive #6A6630 x Br 5-30 ->
  yellow), tiny sparkle flipbooks at Size 0.025-0.05 (sub-pixel), dark specks at **LE -4 Br 30**, a horizontal lens
  streak (`3052949762`, Squash -1/-2) and a `17495955576` aura flipbook (LE 0, LI 1). The stills show it building up to
  a steady glow by 0.8 s. Lesson: Squash -1..-2 on a lens-flare sprite = a flat horizontal glint line; the rest is
  outside this category.

---------------------------------------------------------------------------------------------------------------

## b. Anatomy of a slash / sword effect

All layers fire at 0; "visible" is when the layer reads on screen. Sizes relative to S (slash card size, 10-19.6 here,
median 12 in the library). Flat = Orientation VelocityPerpendicular, Speed 0.0008-0.002, EmissionDirection = the swing
plane's normal (Top/Bottom = horizontal swing, Left/Right/Front = vertical), SpreadAngle 0-2.

| # | Role (visible) | Texture role, ids from these effects | LE / LI / Br | Lifetime s | Size (x S) and curve | Transparency | Motion | Orientation, Squash, flipbook | Emit | ZOffset |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | Pop flash (0-0.06) | thin cross `10598374841`, `14198353638`; radial burst on black `11037528577`; dusty impact 4x4 `10198439352` | 1 / 0 / 5-10 (25 for a summon) | 0.03-0.06 (0.06-0.12) | 1.1-1.75 S (4 S summon); full -> 0 (glass) or 0 -> full in 0.03-0.05 | 0 flat, out after 0.65 | 0 | FacingCamera; Squash 0 or 1 | 1 (5) | 4-10 |
| 2 | Soft glow (0-0.4) | blurred spec `11037772334` | 1 / 0 / 2 | 0.77 | 1.2 S const | min 0.85 | 0 | FacingCamera | 1 | 5 |
| 3 | Hot body (0.05-0.3) | 4x4 slash sheets `84127812322926`, `133081786271698`, `113437526450803`, `115403448342847`, `125350560833478`, `13580362430`, `99925185052573`, `71361063421189` | **0 / 0 / 6-75** (median ~20) | 0.25-0.63 (glass 0.3) | 0.7-1.3 S const | `1->0 @0.2, 0 @0.7 ->1` (glass) or `0 to 0.4-0.5 ->1` (molten) | flat | Grid4x4 OneShot (16 cells in 0.25-0.63 s = 25-64 cells/s); fixed Rotation; RotSpeed 0 (flipbook sweeps) or +-150-630 | 1 (3 for thin strands) | 0-1.6 |
| 4 | Additive halo copy (0.05-0.3) | `109175499924375`, Glowing Slash `13580352351` | 1 / 0 / 10-20 | 0.3-0.38 | 1.0-1.15 S | 0 (glass) or 0.93 (faint) | flat, -360 deg/s | Grid4x4 OneShot | 1 | -0.2..0.1 |
| 5 | Dark ink (0.03-0.3) | `9181472195`, `81933089813046`, `17308625856`, `88366169080988`, `135150783493688`, `77344368783840`; pizza `70757453255007` black | **0 / 0 / 0** (any Color) or colour #0A0A0A at Br 6-20; partial ink = black at LE 0.5-0.7; LE -0.25 | 0.25-0.63 (often the longest card) | 0.6-1.25 S, usually bigger than the body | as body; ambient ink min 0.46 | flat; slower than body (-180 vs -360, -40) or fast (-634) | Grid4x4 OneShot | 1 (3 sizes) | -0.5..-0.1, or +0.003 |
| 6 | Spinning detail (0.05-0.35) | `81209435473973`, `9893305384`, `99925185052573`, `13580362430` | 0 / 0 / 3-30 | 0.25-0.38 | 0.75-1 S | 0 or fade-in to 0.19 | flat, **+-600-1270 deg/s**, opposite to its neighbours | Grid4x4 or single | 1-3 | 0-0.1 |
| 7 | Ground wind ring (0.05-0.3) | `79454007816524`, `15556415618` | 1 / 0 / 0.05 (faint grey) | 0.2-0.4 | 0.8 S +-0.4 envelope -> 1.4 S | 0 -> 1 linear | flat Top, Spread 10, RotSpeed -180..-90 | single | 1 + 4 | 1 |
| 8 | Speed lines / wisps (0.03-0.25) | `139843022964858`, `137666963718741`, `70505492288623`, `6889406891`, `119578487108713` | 0 / 0 / 12-45 (dark twin LE -0.5) | 0.1-0.2 (wisps 0.4-0.7) | 0.35-1.1 S; shrink 5->0 or grow 0->6 | `1->0 @0.3, 0 @0.8 ->1` | VelocityParallel, Speed 36-153, Drag 1-20 (5 typical), along the swing | Squash grow 0 -> 0.5-5 (or -3/+3 flip) | 4-25 | 0.1-2.5 |
| 9 | Sparks / specks (0.03-1.0) | ember specs `88848729824097`, SparksLinger `7922645282`, off-centre `16171528032`/`15419189769`, dots `15394198783`, `125523015121474`, `6897736795` | 0 / 0 / 10-45, or 1 / 0 / 35 | 0.2-0.64 (hangers 0.58-1.75) | 0.03-0.07 S (specks in a big frame: 3.75-6 const) | 0 flat or fade-in to 0.3 | Speed 4-153, Drag 4-15, sometimes gravity -8..-15 or lateral +600 | swell peak at 6-31% of life; VelocityParallel for streaky ones | 1-25 (2-5 typical) | 0-3.5 |
| 10 | Shards (0.03-0.5) | `17842430380` 2x2, `102909815587367` 8x8, `15831917569`, chromatic `12401154143` | 0 / 0 / 5-10 (chromatic 1 / 0 / 2) | 0.2-0.84 | 0.05-0.08 S, shrink -> 0 | 0 flat | Speed 4-17, Spread 0, along the swing | FacingCamera; Loop 0.001 = frozen frame | 2-4 per colour copy | 0 |
| 11 | Smoke / fog (0.05-0.8) | toon `11857153748`, `16867377762`, `11822996479`; streaming `73401626133942`, `11799607237` | 0-0.7 / 0 / 1-12 | 0.15-0.8 | 0.5 S grow 0->7, or streams to 1.1 S | min 0.63-0.68 (faint) | toon: still (Disc); streams: VelocityParallel 45-123 | 4x4/8x8 OneShot | 4-5 | 0.1-2 |
| 12 | Ghost crescents (0.3-0.55, faint; the linger) | `104185000871508`, `123392140151112`, `129605283585453`, `134426751278151`, `122687516597260`, `16398621184` | 0 / 0 / 0 (black) or 22-32 on dark brown #481000 | 0.32-1.7 | 0 -> 1.1-1.5 S (envelope +-2.7-3.6), fast-start curve (65% of size by 0.2 of life) | `1 -> 0.36 @0.1 -> 0.53 @0.3 -> 0.9 @0.45 -> 1` | flat, Spread 12-32, Speed 0.0012-0.4, RotSpeed -17..+6 | single | 2-4 | 0-0.002 |
| 13 | Tint overlay (whole hit) | `137926940506348` 8x8 | 0 / 0 / 1 | 0.4-0.7 | 2 S const, Squash -0.3 | min 0.90 | flat | Grid8x8 OneShot | 1 | -0.1 |

Library check (1,212 slash-tagged effects, 4,036 slash/crescent-named layers): median life 0.45 s (flipbook 0.34,
single image 0.54), median peak size 12, 85% VelocityPerpendicular, 68% spin (median |RotSpeed| 100, p90 952 deg/s),
47% flipbook (99% of those OneShot), median LE 0, median Br 3.5, 12% negative LE. Spark-named layers: median Br 14,
24% negative LE, median Drag 7, 33% squashed. Median 2 slash layers per effect (p90 8); median effect length 2.05 s.
No light, sound or camera shake is inside any of the 6 effects.

---------------------------------------------------------------------------------------------------------------

## c. Timing (seconds after the hit)

| Phase | glassSlash2 | Molten Slash1 | pizza | Fits all slashes | Spread |
|---|---|---|---|---|---|
| Pop (flash) | 0-0.06 (seen at 0.03 only in the first capture) | 0-0.05, seen at 0.03 | none | 0-0.06 | 2-4 frames; summon flash 0.06-0.12 |
| Sweep (flipbook draw-in, fade-in to 0.2 of life) | 0-0.10 | 0-0.10 (thin red + black arc at 0.03) | 0.10-0.20 | 0-0.1 | x2 |
| Peak (full crescent, hot core) | 0.10 white, 0.20 violet + black ink | 0.10 yellow core, 0.20 thinner | 0.35-0.55 (stream) | 0.1-0.2 | x2 |
| Body out | by 0.35 | by 0.35 (ghost arc only) | (stream) | 0.25-0.35 | small |
| Linger (specks, puffs, ghost arcs, haze) | dark puffs 0.2-0.4, specks to 0.55 | haze to 0.55, specks to 0.8 | to 0.8+ | 0.55-0.8 | x1.5 |
| Total readable | ~0.55 | ~0.8 (gone at 1.2) | 0.8+ | 0.55-0.8 | |

All three columns are read from the recapture (2026-11-14).

Rule of the group: the hot body reads 0.1-0.3 s and is gone by 0.35 s, even where its cards live 0.5-0.63 s (Molten);
the ink shows exactly at the hand-over from white to colour (glass 0.20 s, Molten 0.03-0.10 s), and the linger is
specks, dark puffs and faint ghost arcs, not the crescent. Ghost crescents live up to 1.7 s by the table but are
effectively invisible after ~45% of life (Transparency 0.9).

---------------------------------------------------------------------------------------------------------------

## d. Techniques catalogue (exact recipes)

1. **Flat slash card**: Orientation VelocityPerpendicular, Speed 0.001, SpreadAngle 0 (2 = slight random tilt),
   EmissionDirection = swing-plane normal, Grid4x4 OneShot, Lifetime 0.25-0.4, Size constant. The flipbook draws the
   sweep; do not grow the size.
2. **Brightness 0 = black ink**: LE 0 + LI 0 + Brightness 0 renders black whatever Color holds (glass x4, Molten
   Black Slash2/Thin Winds/Black Linger). Seen in the recapture: glass's Br-0 cards (Color ramps violet/cream) show
   as a solid black band hugging the violet crescent at 0.20 s, darker than the floor; Molten's crescent carries a
   black inner band at 0.03 s.
3. **HDR hue shift (molten core)**: Color #721A00 (dark red), LE 0, Brightness 55-75: bright texels clip through orange
   to yellow-white, soft ones stay red. Same idea: olive #6A6630 x 30 -> yellow glow (axe), red #FF4E53 x 45 -> pink-white
   (pizza). Look in Studio: tone mapping decides the exact hue.
4. **Opaque-but-glowing stack**: put the whole slash at LE 0 with Br 6-75 (Molten 58 of 62 emitters). Layers occlude
   in ZOffset order instead of adding to white, and still bloom. Use LE 1 only for the flash, the glow and one halo copy.
5. **Rotation lag**: body card RotSpeed 0 (flipbook sweeps), additive copy and first ink -360 deg/s, second ink
   -180 deg/s on a 0.3-s life: the smear falls 54 deg behind by the end. Molten's slowest ink: -40 deg/s for 0.63 s.
6. **Stacked offsets**: 3-5 cards with fixed Rotation 20-30 deg apart (270/300/320/340/360) and sizes 0.6/1.0/1.1 S
   build a thick layered crescent from thin texture strokes.
7. **Counter-rotating detail**: inner detail cards at +-600-1270 deg/s, half one way, half the other, life 0.25-0.38 s:
   reads as turbulent shredded fill, not as spinning.
8. **Burn-out ramp**: body Color #FF815C -> #DB3100 @0.45 -> #0A0A0A @0.64..1 at LE 0: the slash chars black instead of
   fading. Flicker variant: #FF774F -> #0A0A0A @0.5 -> #E73400.
9. **Palette copies, not ramps**: the same shard layer three times with fixed colours (cream #FFE19C, blue #5586C6,
   violet #7B70F8), EmitCount 2 each, so each shard keeps its own hue.
10. **Twin bright/dark copies**: one flipbook as a red layer (LE 0.67) and a black one (LE 0.67) with Squash -0.2 vs
    +0.2 and the black peak later (Transparency minimum at 0.8 vs 0.5 of life): the dark edge peeks out.
11. **Partial ink**: black at LE 0.5-0.7 darkens only 30-50% (pizza smoke, fog, crescent): a soft shadow, not a hole.
12. **Negative LE darkeners**: near-black streak #0C0405 at LE -0.5 Br 45 (pizza); portal core disc LE -3, ZOffset -1;
    axe specks LE -4 Br 30. Outside the documented 0-1 range (vault: Particle Emitters In Depth): re-check after updates.
13. **Speed lines**: VelocityParallel, Speed 72-144, Drag 5, Size 5 -> 0, Squash 0 -> 5, Lifetime 0.15-0.2,
    Transparency `1 -> 0 @0.3, 0 @0.8 -> 1`, EmitCount 4, along the swing.
14. **Lateral wind on sparks**: SpreadAngle 360, Speed 76-153, Drag 15, Acceleration {600, -50, 0} (world space):
    a radial burst swept into the swing direction in ~0.1 s.
15. **Curling sparks**: off-centre spec `16171528032` + RotSpeed +-1000 + VelocityParallel, Speed 61-153, Drag 8.
16. **Pop-and-hang sparks**: Size swell 0 -> 0.41 at 6% of life, Lifetime 0.58-1.75, Speed 14-97, Drag 5.15, Br 35,
    LE 1, ZOffset 3.5: a bright pop, then dots that hang where drag stopped them.
17. **Flicker needle**: Squash -3 -> +3 @0.1 -> -3, Speed 68-102, Drag 20, Lifetime 0.2-0.8 (portal `6889406891`).
18. **Sparks along the arc**: one small spark set on each of 6 attachments along the arc, 1-2 particles per layer,
    Speed 7.3 backwards, Acceleration -8.5 along the swing axis: sparks peel off the whole arc, not one point.
19. **Frame-1 pop**: Star99 `10598374841` Size 20.5-24.6 -> 0 over 0.06 s, Transparency 0 to 0.65, ZOffset 4 (glass),
    or 0 -> 21.9 over 0.051 s with Squash 1, which turns the cross into a long diagonal needle with a star at its
    centre (Molten, clearly visible at 0.03 s). Both last 3-4 frames, so a still or a dropped frame can miss them (glass
    and the portal were caught in one capture, not the other): give the pop >= 0.06 s if it must always land.
20. **Size envelope for variety**: Size keypoint envelopes +-2.4-5.6 on rings, ghost crescents and thin strands give
    each particle a different size from one EmitCount, no extra layers.
21. **Ghost crescents**: flat, Size 0 -> 1.1-1.5 S on a fast-start curve, Transparency 1 -> 0.36 @0.1 -> 0.9 @0.45 -> 1,
    Lifetime 0.32-1.7, SpreadAngle 12-32, Speed up to 0.4, RotSpeed -17: a fan of faint crescents that keep opening.
22. **Micro ZOffset ladder**: 0.001-0.004 between coplanar cards, ink -0.5..-0.1, flashes 4-10, sparks 1-3.5.
23. **2x tint overlay**: one card at 2 S, Transparency 0.9, Squash -0.3: tints the whole area cheaply.
24. **Frozen random frame**: Grid2x2 Loop at FlipbookFramerate 0.001 (glass shard specs) = a still shape per particle.
25. **Lens glint line**: `3052949762` with Squash -1 to -2 = a flat horizontal glint (axe, 0.55 s still).
26. **Script sweeps** (game code, not in stills): yaw a part -175 deg in 0.25 s linear while its curved beams' widths
    tween 30 -> 0 (glass): the arc smear that follows the blade.

---------------------------------------------------------------------------------------------------------------

## e. Mistakes and weak spots (avoid)

- **Too small and too thin against the swinger (round 1, 2026-11-16: "the slash is a bit small; unclear what it is
  meant for").** Two quick slashes ~7 studs wide (1.3 H) with a narrow band read as weightless next to the
  character; the same combo's ~13-stud (2.5 H) finisher read. The studied slashes are 10-19.6 studs (2-4 H): keep
  light attacks at 2 H or more with the band's widest point thicker than a limb (0.4 H+), show where the blade is
  (the arc starts at the hand and sweeps through the target side), give each one white edge, body and a dark
  trailing ink, and capture beside the figure. Dust from a ground hit stays low and off the body (a pale cloud
  over a pale character hid it).

- **Missing first-frame pop**: pizza has no flash layer and every layer starts at Size 0 or Transparency 1, so 0.03 s
  is empty in both captures and the hit starts with thin streaks at 0.10 s. Give the hit one full-size layer on frame 1
  (glass: 20.5-24.6 -> 0; Molten's 0.051-s needle shows at 0.03 s).
- **Dead layers**: additive layers at Brightness 0.005-0.05 add ~0-5% (6 of glass's 40 emitters; portal `83890933225244`
  at 0.025). Each still costs fill. Delete or raise them.
- **Copy-paste bulk**: 40/62/42 emitters but 24/39/18 distinct designs. Copies on extra attachments are fine when they
  spread sparks along the arc (Molten); otherwise raise EmitCount instead.
- **Saved-enabled streams**: pizza's 18 emitters are Enabled = true with Rate 4-50 and no script; dropped into a game
  they never stop. A slash should be bursts only; enable streams for a measured window.
- **Wrong scale**: PullVFX sparks 0.5, rocks 0.08, axe sparkles 0.025-0.05: sub-pixel at game distance. Check Size
  against S before tuning anything else.
- **Weak spark motion**: glass specks 4-14 studs/s with Drag 0 spread as a loose drifting cloud (0.10-0.55 s in the
  recapture), not a burst; impact sparks in this group that
  read well use 14-153 studs/s with Drag 4-15.
- **Runtime-only layers**: beams authored at Width 0 with widths in attributes (glass 3, Molten 16) are invisible
  without the pack's script or a Forge-style runtime; bake real widths or drive them yourself.
- **Huge summon flash**: portal flash Size 47.6 x5 at Br 25 filled the frame at 0.03 s in the first capture (missed by
  the recapture's stills) for 0.06-0.12 s; fine once, too much on a
  repeated combo hit (photosensitivity rule in PATTERNS 3: cap at 2 flashes per hit).
- **Radial portal as slash**: SacredSwords' disc is a 360 deg shape; for a sword hit keep the vault's frontal rule.
