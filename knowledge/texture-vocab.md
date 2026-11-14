# Texture vocabulary (open-source Roblox VFX)

**Search first:** `kit/scripts/find_textures.py "<role words>" --sheet out.jpg` searches this vocabulary's textures and
the ~9,200-texture VFX Studio catalogue (gallery/textures/vfxstudio_index.json, ~2,750 flipbooks) together, with the
measured traits below, and shows the hits on one sheet. The tables here are the textures real library effects use.


Pick a texture by ROLE ("soft glow", "4-point star", "crescent flipbook", "dark smoke 4x4") instead of guessing ids.
Built 2026-11-13 from the pack (decoded with `kit/scripts/rbxdump.py`) (378 open-source VFX pack files shared on Discord,
6,148 effects, 106k distinct emitter designs). Every id below was looked at on a contact sheet.

**Source and permission.** These are public Roblox image asset ids that the pack authors uploaded. Using one in a game
you ship (credit, asking the author) is the user's call; this file only records what exists and how it is used. Ids can
stop loading (moderation, deletion), so check any pick in Studio first.

**Load test (2026-11-14, a fresh place owned by a different account than the uploaders):** of the 1,470 texture ids
used by the 77 studied effects, **1,461 loaded** and 9 did not: `14687560696` and `100300862060592`, `16225387272`,
`10384449683` ("Asset is not approved"), `18227138407` and `131180188083481` (no permission), `203785492` (archived),
`17515545038` and `125921838360800` (wrong asset type). Do not use those; everything else in this file loaded.

**See them.** `textures/sheet_NN.png` (48 per sheet, ranked by number of pack files using the id; index `k` is on sheet
`k // 48`, cell `k % 48`), single 150 px thumbnails in `textures/thumbs/<id>.png`, data in `textures/index.json`
(top 1500: names, LE values, flipbook layouts). Find more of a role by layer name:
`python3 -c "import json;d=json.load(open('gallery/textures/index.json'));[print(k,v['id'],v['light'],v['flip'][:1],v['names'][:3]) for k,v in d.items() if any('crack' in n.lower() for n,_ in v['names'])]"`

**Columns.** `files` = pack files using the id (popularity). `light` = how artists use it: **A** additive (LightEmission
~1), **D** dark/normal (LightEmission <= 0), **M** both. `grid` = flipbook layout (`-` = single image). `typical use` =
the layer names artists gave it (most common first) plus measured usage. "Same art" = identical image uploaded under
several ids: take the one with more files and keep the twin as a fallback. `traits` = measured on the original upload
by `kit/scripts/texture_traits.py` (all 1,538 ids in `gallery/textures/traits.json`): background (`clear`;
**BLACK card** = no alpha or an opaque dark border, additive only; **DARK haze** = dark semi-transparent haze round
bright art, additive only; **FAINT** = mostly low-alpha haze, reads weak and, tinted dark, darkens a soft card round
the art), colour (`white` / `grey` / `black` tint cleanly; `black+white` = dark art with white parts, additive shows
only the white; `pale <hue>` = slight tint; a hue = coloured, `Color` multiplies it; `multicolour` = use untinted),
parts (separate shapes; `N lines` = parallel streaks, a comb when used as one streak; `scatter` = many tiny bits),
`eff` = effective resolution in px per image or flipbook cell (it looks soft or stair-stepped once drawn bigger than
~1.25 x eff pixels on screen; on 1080p a particle is ~1540 x Size / camera distance px across, since Size is a half-width; a beam ~770 x width /
distance; `smooth` = a soft
blur with no edges to lose: right for glows and smoke, but a "spiky" texture that measures smooth is already blurry), `fill` = share of the frame the art covers, `N/16 cells` = flipbook cells that hold art. `~` = only the
700 px thumbnail is public (privacy-restricted upload), so eff is rough. Check any other id:
`python3 -I kit/scripts/texture_traits.py <id>` (add `:4x4` for a flipbook, `--json` for the raw values).

**Light modes.** LightEmission 1 adds the texture onto the scene: black adds nothing, so a texture painted on an opaque
BLACK background (marked "on BLACK"; most of the old `10849xxxxx` series) works ONLY additively, at LE 0 you see a black
square. A texture on transparency works both ways: LE 1 = glow, LE 0 = solid matter that keeps its colour, and with a
dark `Color` it becomes the dark "ink" layer. Negative LightEmission (-0.1 to -15) appears in 14% of emitter layers to
darken and thicken; it is outside the documented 0-1 range (LihFolk vault note "Particle Emitters In Depth", if you have it), re-check after engine
updates. Measured over the 1,495 loadable ids of the top 1,500: 1,449 are neutral (1,175 white, 222 grey, 52 black
or black+white) and are tinted with `Color`; 19 are pale-tinted (warm-grey smoke sheets, beige rocks, a few pale-blue
ice pieces, a pale-red spark), 7 are coloured (4 blue, 1 dark violet, 1 yellow, 1 cyan) and 20 multicolour
(rainbows, chromatic fringes). The `traits` column names the colour of each.

**Flipbooks.** One 1024x1024 sheet cut into a grid: `Grid2x2` = 4 frames of 512 px, `Grid4x4` = 16 of 256 px (the
standard: 35% of all emitter designs), `Grid8x8` = 64 of 128 px (smoother, smaller: 3%). Set `FlipbookLayout` to the
grid; 92% of flipbook layers use `FlipbookMode = OneShot`, which plays the sheet once over each particle's Lifetime (so
Lifetime IS the timing); `Loop` uses `FlipbookFramerate` (max 30). Many sheets fill only 6-12 of their 16 cells and
leave the rest empty, so the particle vanishes before it dies: a built-in hard cut. A sheet on the wrong grid (or not
1024x1024) shows as a mosaic or does not animate.

## Traps (measured)

What the `traits` column caught that the contact sheets did not (a blind test lost most of its first six versions to
these). Measured over the 1,495 loadable ids of the top 1,500; the swap is a clean texture of the same role.

- **Coloured art tinted another colour** (7 coloured, 19 pale, 20 multicolour): `Color` multiplies, so a blue texture
  tinted gold goes olive/teal. The rune card `75751709312199` is dark blue (and 16:9, so a square particle stretches
  it) -> white rune circles `135141028133816` / `13600029796`. RGB-split cross `17062416111` -> `17062452122`.
- **Black cards, additive only** (74; every row marked "on BLACK" measured black). Below LightEmission 1 the square
  shows: the Holy Rays needle `1053548563` fills 1% of a black frame, so at LE < 1 it renders as grey planks.
- **Dark haze, additive only** (29): the crack `130848219849162` sits in a dark semi-transparent haze that cut the
  ground rings with a dark outline at LE 0 -> `99911247720869` (clean crack starburst) or `13782885260` (4x4). In the
  tables: the starter-kit soft starburst `8048608283` / `111453160791180` (dark-grey spikes: a grey smudge at LE 0),
  `7160024951`, `9710916533` (a dark disc round the streak), `16511790647`.
- **Faint cards** (238, mostly glows, smoke and lens stars whose soft glow fills the frame, e.g. `17391818367`,
  `14590086212`, `10598374841`): fine additively, but tinted dark they drag a soft dark square. "Black Flash"
  `8133065785` is ~90% faint haze and darkened every ring near it -> `13621316962` as a black spiky twin; for a star's
  black twin use the halo-less `17450657969`.
- **Streak direction**: a VelocityParallel streak follows the texture's long axis. A horizontally drawn streak shows
  across its motion until `Rotation = 90` (blind test 3).
- **Several streaks in one image** (10): `7136536841` holds 12 parallel streaks; used as one VelocityParallel or
  FacingCameraWorldUp streak it reads as a barcode comb -> `8030734851` (one soft lens streak) or `1315202524`.
- **Low-res art drawn big**: the older spiky starbursts of group 16 are all low-res: `18118762332` / `11187665050`
  (420 px, eff 110: soft above Size ~2.7 at 30 studs, a particle being 2 x Size across; all six blind-test reviewers flagged their spikes),
  `16892231149` (108), `9132707475` (86), `16892226410` (a 128 px image) -> `17296456452` (radial spike burst, eff
  247) or `16892332741` (crisp toon star, eff 266). Thin cross `17391818367` (eff 183) -> the same look sharper in
  `14590086212` (eff 354).
- **Swaps change the size on screen**: `fill` differs between look-alikes (`18118762332` 22 %, `17296456452`
  32 %). Scale the layer's Size by old fill / new fill when you swap, or the flash whites out (checked in Studio on
  the explosion and impact recipes: Size x0.7).
- **Not loadable**: 5 of the 1,500 (`14687560696`, `100300862060592`, `13378717718`, `139646456766666`: thumbnail
  blocked; `18227138407`: unknown-image placeholder); all 9 failures of the load test above fail here too. 323 more
  need authentication for the original; their traits come from the public thumbnail (eff marked `~`).

## Role groups

### 1. Specs and dots (centred)
Variants: hard vs soft edge, pin-prick vs disc, single vs scattered, blinking flipbook. Used as sparks (FacingCamera, Size 1-3) or, with VelocityParallel + Squash, as short streaky sparks.

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `16878181512` | small hard white dot, thin soft edge | - | D | 24 | Spec1/Specs/Sparks (520 layers; 193 of them with negative LE) | clear, white, 1 part, eff 61, fill 3% |
| `8030760338` | same small soft dot, a touch blurrier | - | M | 21 | Specs/Orbs/Debris2 | clear, white, 1 part, eff 61, fill 3% |
| `13712002093` | pin-prick dot just below the top edge | - | A | 12 | Specs/Dust | clear, white, 1 part, eff 373, fill <1% |
| `15153511168` | solid white disc with a faint halo | - | M | 6 | Shards2/impact texture: hard orb core | FAINT, white, 1 part, eff 76, fill 47% |
| `1084962479` | solid white disc with soft glow, on BLACK | - | A | 9 | Core: orb cores | BLACK card, white, 1 part, eff 80, fill 49% |
| `16878191468` | soft dot blinking big/small | 4x4 | M | 7 | Spec4/Sparks3 | clear, white, 1 part, eff 23 smooth, fill 9% |
| `13189667061` | glow dot that grows, peaks and shrinks | 4x4 | M | 10 | 23/Glow/Flare11: one-shot twinkle | clear, white, 1 part, eff 24 smooth, fill 6% |
| `16511093402` | very tiny glitter specks | 8x8 | M | 10 | Glitter | clear, white, scatter, eff 49, fill 5% |
| `18450596124` | ~15 tiny specks scattered over one image | - | M | 8 | Multiple Specs 14/Debrisflock: many specs per particle | clear, white, 14 parts, eff ~291, fill 4% |
| `7231210720` | grainy cluster of grey noise specks | - | M | 8 | smokeSpecs1/Derbi Grid: dust grain | clear, pale orange, scatter, eff 203, fill 7% |

### 2. Off-centre specs (orbiters)
The dot sits away from the centre, so a random Rotation plus RotSpeed makes it circle the particle centre (radius = offset x Size). Most layers that use them spin (`16171528032` 104/115, `9997556038` 221/246, `8414194072` 32/32, `16879806460` 162/190). Size is tiny (0.4-2).

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `9997556038` | soft dot in the top-left corner | - | M | 18 | ParticleEmitter/Specs/'DotGlowOffset' | clear, white, 1 part, eff 68, fill 3% |
| `16171528032` | sharp dot a quarter in from the top-left | - | D | 17 | OffCentered Spec 46 | clear, white, 1 part, eff 57, fill 3% |
| `8084996370` | soft dot at top centre | - | M | 13 | Specs/'DotNoBGOffset' | clear, white, 1 part, eff 63, fill 2% |
| `11448304274` | bigger soft dot upper-left | - | D | 12 | specs1-3 (80 layers at LE -2) | clear, white, 1 part, eff 40 smooth, fill 7% |
| `10205180639` / `8511527728` | fuzzy rough-edged dot, top-left corner (same art) | - | M | 13/7 | Specs3/dots/Embers | clear, white, 1 part, eff 92, fill 1%; twin eff 191 |
| `8414194072` | solid hard dot top-left | - | A | 8 | Specs/Dots | clear, white, 1 part, eff 199, fill 1% |
| `12942158384` | glowing soft dot top-left | - | M | 8 | Embers1/Specs1 | clear, white, 1 part, eff 38 smooth, fill 5% |
| `16879806460` | tiny sharp sliver top-left | - | M | 8 | Spec26 (100 of 190 layers at negative LE) | clear, white, 1 part, eff 169, fill 1% |
| `8242018934` | hard dot at top, right of centre | - | M | 7 | spec2/ember | clear, white, 1 part, eff ~186, fill 1% |
| `17334135713` | tiny dot in the bottom-left corner | - | M | 7 | OffCentered Spec 4: wide orbit | clear, white, 1 part, eff ~63, fill 1% |
| `1084996976` | soft dot near the bottom edge, on BLACK | - | A | 9 | Absorb/Specs2 | BLACK card, white, 1 part, eff 75, fill 2% |

### 3. Soft glows
Variants: core size (small dot vs frame-filling blob), hot pinpoint centre vs flat, dim haze. Glows are FacingCamera; the smallest-looking ones are used biggest.

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `867619398` | big soft blob filling most of the frame | - | M | 15 | Glow/Corner/GlowIN (237 layers) | clear, white, 1 part, eff 16 smooth, fill 58% |
| `77024587778878` | big blurry disc | - | M | 15 | Basic Blurry Spec/auracenter | clear, white, 1 part, eff 16 smooth, fill 42% |
| `13712004045` | big soft blob | - | A | 14 | Glow/Cosmic Aura/Hunter Aura | clear, white, 1 part, eff 16 smooth, fill 45% |
| `12159555294` | medium glow with a denser core | - | M | 20 | Glow/glowemit/specsemit | FAINT, white, 1 part, eff 29 smooth, fill 25% |
| `1075864321` | wide faint halo with a hot pinpoint centre | - | M | 17 | glow/Light, life ~0.2 s | clear, white, 1 part, eff 24 smooth, fill 65% |
| `16879789169` | small soft dot (about 1/5 of the frame) | - | A | 12 | Spec19/Glow: median Size 31.6, life 0.24 s = flash behind a hit | clear, white, 1 part, eff 16 smooth, fill 9% |
| `6673021984` | soft halo with a tiny bright centre | - | M | 9 | Glow particle | FAINT, white, 1 part, eff ~142, fill 27% |
| `243664672` | large soft glow | - | M | 6 | Poison/Other1Shock (181 layers, ZOffset ~2) | FAINT, white, 1 part, eff 188, fill 34% |
| `98046010009179` / `448862775` | dim, low-contrast large haze | - | A/M | 6/7 | Dark/overlayglow/shadow: subtle tint or darkening | FAINT, white, 1 part, eff 381, fill 36%; twin: clear, white, 1 part, eff ~268, fill 45% |
| `121143963977274` | halftone-dot sphere, on BLACK | - | A | 5 | comic-style glow | BLACK card, white, 1 part, eff ~233, fill 25% |

### 4. Flares and 4-point stars
Variants: thin cross with a glow core (lens flare), fat concave 'diamond sparkle', X/8-point flare with ring, chromatic. On black = additive only. Mostly short (life 0.1-0.5 s), Brightness 5-77, often squashed.

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `17391818367` | thin long cross, small glow core | - | M | 15 | Star102 (190 names) | FAINT, white, 1 part, eff 183, fill 15% |
| `14590086212` | long thin cross, vertical arm longer | - | M | 17 | Star113/BrightBlinky (median Brightness 77) | FAINT, white, 1 part, eff 354, fill 14% |
| `10598374841` | cross with a soft round glow core | - | A | 19 | Star99/Flare1 | FAINT, white, 1 part, eff 133, fill 8% |
| `17062452122` | small short cross | - | M | 14 | Star12 | clear, white, 1 part, eff 126, fill 2% |
| `17062454177` / `14006783533` | fat concave 4-point sparkle, sharp tips (same art) | - | M | 7/10 | Sparks (285)/Flash; squashed in 393/413 layers | clear, white, 1 part, eff 224, fill 8%; twin eff 564: prefer `14006783533` (1024 px) |
| `1084970835` / `1053546634` | fat concave sparkle on BLACK (same family) | - | A | 13/6 | E16/Grad/Sparkles | BLACK card, white, 1 part, eff 485, fill 29%; twin eff 202 |
| `17450657969` | long thin 4-point star | - | D | 5 | Sparks (225), Brightness ~25, life 0.2 | clear, white, 1 part, eff 151, fill 6% |
| `10556525755` | thin cross with glow, on BLACK | - | A | 9 | Flash/Stars/AwakeningAura | BLACK card, white, 1 part, eff 354, fill 14% |
| `17062416111` | cross with RGB-split fringe and dark core (coloured) | - | M | 9 | Sparks (223)/Star3 | clear, multicolour, 1 part, eff 179, fill 11% |
| `7216848832` | X-shaped flare with a faint ring and thin axis rays | - | A | 6 | Flare2/Star | clear, white, 1 part, eff 117, fill 7% |
| `7160024951` | X flare with many fine rays and a ring | - | A | 6 | 1/E1 (all layers spin) | DARK haze, grey, 1 part, eff 127, fill 15% |
| `7216849703` | blurry soft 4-point glow | - | M | 7 | Star2a/shard | FAINT, grey, 1 part, eff 41 smooth, fill 12% |

### 5. Needles, streaks, speed lines
Variants: soft lens vs hairline vs hard diamond; edge-to-centre ray needles; noisy streak bands. Almost always VelocityParallel + Squash, life 0.05-0.45 s.

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `8030734851` | soft vertical lens streak | - | M | 14 | Shards/Slash3 (squash 110/138) | clear, white, 1 part, eff 117, fill 9% |
| `1315202524` | very thin vertical line | - | M | 11 | Stripes/bigline/line | clear, white, 1 part, eff 117, fill 6% |
| `8970920735` | diamond needle with long thin tips | - | M | 7 | E12/Sparks2 | clear, white, 1 part, eff 235, fill 7% |
| `18118860997` | solid sharp diamond with a thin black outline | - | D | 5 | Slash (86): Size ~24, toon slash streak | clear, white, 1 part, eff 203, fill 3% |
| `10439119562` | small flame-teardrop shard | - | M | 15 | Shards/BShards | clear, white, 1 part, eff 105, fill 3% |
| `3052949762` | horizontal anamorphic lens streak | - | M | 12 | Custom Lens Flare/Glare/FlashingStarSQUASH | FAINT, white, 1 part, eff ~217, fill 24% |
| `9710916533` | horizontal streak with tiny starburst and faint halo | - | M | 9 | Flash (86): life 0.08 s, Size ~24 | DARK haze, grey, 1 part, eff 170, fill 8% |
| `1053548563` | needle from the bottom edge tapering to the centre, on BLACK | - | A | 21 | Holy Rays/Rays_Thick: random Rotation = rays from a point | BLACK card, white, 1 part, eff 263, fill 1% |
| `8905957078` | needle from the top edge to the centre | - | M | 7 | big rays/Ray1 | clear, white, 1 part, eff 456, fill 2% |
| `18465146997` | horizontal band of jagged noise streaks | - | D | 11 | SpeedLines (559): squash 606/607, life ~0.09 | clear, white, 3 parts, eff 160, fill 25% |
| `18116056206` | blotchy spiky streak noise | - | D | 6 | SpeedLines (660) | FAINT, white, 5 parts, eff 85, fill 45% |
| `11762072190` | ragged vertical flame-like streaks | - | D | 10 | '15' (426 names), mostly LE -2.5 | clear, white, 3 parts, eff 78, fill 20% |

### 6. Rings (single image)
Variants: thin/clean, soft/blurred, two-arc crescent ring with dark smear, broken/flecked, bubble rim. Nearly all VelocityPerpendicular (flat, facing along the emit direction) and spinning.

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `18527700887` | two-arc ring: white leading edges trailing into dark-grey smears | - | A | 10 | C1/Crescents (917 layers, all spinning): wind ring | clear, black+white, 3 parts, eff 137, fill 6% |
| `10859315454` / `15269685466` | same two-arc ring art (other uploads; also 13931762875, 17409991165) | - | A | 19/10 | Wind/ring; decay16 | clear, black+white, 3 parts, eff 158, fill 6%; twin eff 137 |
| `18682826321` | clean soft thin ring | - | A | 6 | ring pulse (180/180 spinning) | FAINT, white, 1 part, eff 69, fill 20% |
| `8050136743` | crisp thin bright ring | - | D | 6 | Outline/RingsIn | FAINT, white, 1 part, eff 235, fill 16% |
| `11037291253` / `12442685305` | thin ring with brighter knots, on BLACK (same art) | - | A | 11/5 | ring/wind; Wave4/CIrc | BLACK card, white, 2 parts, eff 114, fill 7%; twin: BLACK card, white, 1 part, eff ~129, fill 8% |
| `18682835879` | ring with sparkly knots | - | A | 9 | SW1 | FAINT, white, 2 parts, eff 57, fill 18% |
| `10149702982` | soft smoky wispy ring | - | M | 9 | wind/black (472 layers) | FAINT, white, 1 part, eff 43 smooth, fill 36% |
| `10358044068` | soft blurred ring of several loops | - | M | 9 | Impact214 | clear, white, 1 part, eff 51, fill 30% |
| `13440561704` | wobbly thin ring, heavier at the bottom | - | A | 9 | Wave22/Wave31 | clear, white, 5 parts, eff ~78, fill 11% |
| `15021706755` | broken ring of wind arcs | - | A | 9 | WIDSNMW/winds | clear, white, 6 parts, eff 211, fill 11% |
| `8196169974` | bubble: thin bright rim, faint fill | - | D | 8 | Gradient/Charge | clear, white, 1 part, eff 222, fill 26% |
| `1084991215` | sphere rim on BLACK (dark centre, bright edge) | - | A | 9 | Shield1/orb_in | BLACK card, white, 1 part, eff 160, fill 27% |

### 7. Shock discs, spiky rings, starbursts
Variants: hairy ring (spikes on the inner edge), radial-streak disc, starburst around a hollow centre, ray sunburst.

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `7417145436` / `8904012224` | ring with a spiky inner fringe (same art) | - | A/D | 14/6 | Impact446; 23qddf2 (234) | clear, white, 1 part, eff 72, fill 17%; twin eff 74 |
| `115692375305535` | hairy ring, spikes both sides | - | M | 6 | Shockwave/Impact7 | clear, white, 1 part, eff 78, fill 17% |
| `14538969234` | ragged spiky ring with debris spikes | - | A | 5 | Shockwave/Red'pikeyShockwave | clear, grey, 4 parts, eff 37 smooth, fill 35% |
| `9659008631` / `11820076505` | soft disc: glowing rim + radial streaks inward (same art) | - | A/M | 8/7 | Shock (life 0.07, Size ~31); Imp/Shockwave | clear, white, 1 part, eff 195, fill 40%; twin eff 47 smooth |
| `15333808121` | radial-streak fringe ring | - | M | 6 | Impact117 | clear, white, 1 part, eff 158, fill 27% |
| `10176632695` | radial-streak ring in broken segments | - | M | 8 | Impact245/shock | FAINT, white, 6 parts, eff 102, fill 13% |
| `11198241185` | spiky radial burst round a hollow centre | - | M | 8 | Shock/airWaves | clear, white, 2 parts, eff 85, fill 31% |
| `8048608283` / `111453160791180` | faint starburst of soft spikes round a hollow (same art) | - | A/D | 13/5 | C3/SW2/wave/flash (620 layers, Size ~24) | DARK haze, grey, 5 parts, eff 92, fill 23%; twin eff 93 |
| `1084975295` | sunburst of rays, on BLACK | - | A | 6 | Rays/Ray/Hit2 | BLACK card, white, 11 parts, eff 93, fill 27% |
| `1084999891` | soft radial rays round a dark centre, on BLACK | - | A | 10 | flare/Light | BLACK card, white, 5 parts, eff 99, fill 13% |

### 8. Rainbow and chromatic
Coloured textures are rare (the others: `17062416111` chromatic star, `12401154143` chromatic shards); use them untinted (white Color).

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `12105193694` | soft double rainbow halo | - | A | 11 | Flare170New/Rainbow3 | FAINT, multicolour, 2 parts, eff ~245, fill 35% |
| `85664013418740` | thinner rainbow ring | - | A | 10 | Rainbow3 | FAINT, multicolour, 4 parts, eff 105, fill 27% |
| `15020647902` | rainbow crescent on BLACK | - | A | 7 | Floor3/rainbow | BLACK card, multicolour, 2 parts, eff 52, fill 21% |
| `96288653875185` | two rainbow arcs ( ) on BLACK | - | A | 7 | Rainbow6 | BLACK card, multicolour, 4 parts, eff 28 smooth, fill 18% |
| `12188469991` | thin ring with blue/orange fringe, on BLACK | - | A | 6 | PulseRipple | BLACK card, multicolour, 1 part, eff 91, fill 14% |
| `8114157061` | orange-red spark streak (coloured) | - | M | 8 | Sparks1-3 | clear, pale red, 1 part, eff 371, fill 13% |

### 9. Ring and shockwave flipbooks
Variants: thick ring thinning to a hairline, thin ring breaking, ring of puffs/fragments, ring that forms then crumbles. `14687560696` is the most-used ring flipbook (Circle, 473 layers, 4x4, M) but **does not load any more** ("not approved"); use another ring below. It had no thumbnail: check it in Studio before use.

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `126034245450101` / `13675192481` | thick white ring thinning to a hairline, then breaking (same art; also 14762708319) | 4x4 | M/A | 7/7 | circleFlipbook2; ring half | clear, white, 1 part, eff ~69, fill 15%, 12/16 cells; twin eff 100 |
| `12906276200` | thin ring expanding and breaking | 4x4 | M | 12 | Thin realistic shockwave | clear, white, 7 parts, eff ~59, fill 5% |
| `16877839414` | thin circle outlines | 4x4 | M | 9 | Circle2/GuardBoom | clear, white, 5 parts, eff 45 smooth, fill 7%, 10/16 cells |
| `11865130475` | pixel-style thick ring expanding | 4x4 | M | 6 | Pixel circle expanding | clear, white, 2 parts, eff 138, fill 10%, 10/16 cells |
| `110017652984281` | ring of puffs fading | 4x4 | M | 6 | Fancy Shockwave (median Size 75) | clear, white, 7 parts, eff 87, fill 5% |
| `13795445083` | soft flower-shaped ring with spikes dispersing | 4x4 | M | 10 | Web Shockwave/RBurst | FAINT, white, 4 parts, eff 83, fill 21%, 15/16 cells |
| `12844593455` | ring of soft fragments | 4x4 | M | 6 | Flipbook Energy Shockwave/DarkImpact | clear, white, 6 parts, eff 68, fill 8%, 14/16 cells |
| `13795988483` | crumbly ring that forms, then breaks apart | 4x4 | M | 10 | Breaking Returning AOE | clear, white, 13 parts, eff 119, fill 9%, 15/16 cells |

### 10. Crescents and slashes
Single crescents spin (VelocityPerpendicular + RotSpeed) as wind arcs; flipbooks play a slash once (life 0.15-1 s).

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `13225943898` | sharp thin arc across the top | - | A | 6 | Wave2 (196/198 spinning) | clear, white, 2 parts, eff ~251, fill 2% |
| `1084996536` | sharp top arc on BLACK | - | A | 9 | Wave/wind4 | BLACK card, white, 1 part, eff 198, fill 1% |
| `17388367001` | soft blurred top arc | - | A | 7 | C2 (248 layers, all spinning) | clear, white, 1 part, eff 85, fill 4% |
| `8528430235` | bottom-heavy wispy smear arc | - | A | 7 | Wave1 (squashed 145/150) | clear, white, 3 parts, eff ~150, fill 5% |
| `10558510611` | thin crescent at bottom-right | - | M | 10 | clashcircle | clear, white, 1 part, eff 123, fill 3% |
| `15737239528` | two thick dark-edged slash arcs | - | M | 6 | E17 | clear, grey, 4 parts, eff 122, fill 5% |
| `1084963972` | clean thick crescent moon | - | A | 5 | Particles/Wave | clear, white, 1 part, eff 198, fill 9% |
| `13780268621` | thick crescent with dark inner edge thinning to a hairline | 4x4 | M | 13 | Slashed/Layered Slash | clear, white, 1 part, eff 92, fill 10%, 15/16 cells |
| `13805841956` | crescent filled with dark ink shading | 4x4 | M | 11 | Alpha/Layered Dark Slash | clear, grey, 1 part, eff 90, fill 17%, 15/16 cells |
| `17085222506` | thin crescents fading | 4x4 | M | 15 | Black Cresents/SLICE | clear, white, 2 parts, eff 87, fill 5%, 8/16 cells |
| `16026345008` | thick crescent ring that bursts and fades in ~7 frames | 4x4 | A | 5 | decay8 (427), 573 layers | clear, white, 2 parts, eff 53, fill 5%, 7/16 cells |
| `14973797453` | four bold toon crescent slashes, slightly cream | 2x2 | M | 6 | Flat3d/Drawn Crescent, life ~0.14 | clear, white, 1 part, eff 227, fill 10% |

### 11. Wind swirls and vortex

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `109440284900004` / `17006200673` | thick swirling white wind circle shredding into wisps (same art) | 4x4 | M | 13/20 | CIrc/LBG wind (639 layers); Circle72 | clear, white, 2 parts, eff 106, fill 10%, 14/16 cells; twin eff 116 |
| `127940423551603` / `131070767868542` | pair of wispy comma swirls fading (same art) | 4x4 | D/M | 14/9 | C1/Wind (401 layers); Crescents1 | clear, white, 3 parts, eff 75, fill 4%, 10/16 cells |
| `91230378159183` | curved crescent-shaped smoke wisps | 4x4 | D | 5 | smoke/wind | clear, white, 5 parts, eff 108, fill 4%, 13/16 cells |
| `15048784530` | curved ink-stroke flicks | 4x4 | M | 9 | Absorb Swirl | clear, white, 2 parts, eff 111, fill 2%, 13/16 cells |
| `15011464541` | faint tornado | 8x8 | M | 11 | tornado13/Crimson Aura | clear, white, 1 part, eff 56, fill 1%, 52/64 cells |
| `12191903502` | twisting helix ribbon strands (beam) | - | M | 9 | Beam5/Wind | FAINT, white, 2 parts, eff 97, fill 19% |
| `119473092655714` | dark vortex of noisy wisps, on BLACK | - | A | 10 | slash/fog-galaxy | BLACK card, white, 1 part, eff 302, fill 24% |
| `12685367098` | hooked wispy swirl, on BLACK | - | A | 6 | Wind1/RealLinger | BLACK card, white, 3 parts, eff ~69, fill 20% |
| `10856287046` | thick ring of black/white swirl bands | - | A | 6 | colorwind/ring | FAINT, grey, 3 parts, eff 140, fill 26% |
| `14004151283` | ring of puffs growing outward | 4x4 | D | 6 | Vortex/Burst | FAINT, white, 1 part, eff 74, fill 18%, 13/16 cells |

### 12. Smoke: soft and realistic
Variants: wispy vs dense billow, rising from the ground, 8x8 small puffs (smoother motion, 128 px frames).

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `11871320339` / `16867347280` | soft wispy puff curling and fading (same art) | 4x4 | D/M | 13/8 | Smoke (295 names, 407 layers) | clear, white, 1 part, eff 31 smooth, fill 28%, 13/16 cells; twin eff 28 smooth |
| `16867490141` | faint low-contrast grey smoke | 4x4 | M | 12 | Smoke/Smoke32 (life ~2.4 s) | clear, grey, 1 part, eff 39 smooth, fill 26%, 12/16 cells |
| `15415212938` | dense billowing realistic cumulus | 4x4 | D | 11 | Billowing | clear, grey, 1 part, eff 54, fill 50% |
| `14945509165` | realistic dust puff growing and fading | 4x4 | D | 10 | Linger/Dust2 | clear, white, 1 part, eff 63, fill 27% |
| `11866744589` | smoke rising from the ground, bottom-anchored | 4x4 | D | 10 | wavy/UpSmoke/Darkening realism | clear, white, 1 part, eff 81, fill 20%, 13/16 cells |
| `11627083142` | small soft blurry grey puffs | 8x8 | D | 9 | Dark Grey Smoke 2 | clear, white, 1 part, eff 25 smooth, fill 38% |
| `11799607237` | tiny soft puffs, small in frame | 8x8 | D | 18 | Smoke/Cut Smoke | clear, grey, 2 parts, eff 36 smooth, fill 17%, 54/64 cells |
| `73401626133942` | realistic layered fog | 8x8 | D | 6 | Realistic Layered Fog | clear, white, 1 part, eff 35 smooth, fill 13%, 53/64 cells |
| `8527116276` | single grey fluffy realistic puff | - | D | 14 | Plume5/smoke/ImpactSmoke | clear, white, 1 part, eff 84, fill 57% |
| `7216851093` | single grainy dirty dust cloud | - | D | 6 | dust/WallDust (340 layers, life ~2 s) | clear, grey, 1 part, eff 108, fill 39% |

### 13. Smoke: toon and stylised
Hard-edged puffs that break into crescent bits. As LE 0 they read as solid matter; with dark shading they are the 'ink' layer.

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `16867483883` | solid white toon cloud breaking into crescent bits | 4x4 | D | 11 | Smoke30 (417 layers) | clear, white, 1 part, eff 45 smooth, fill 13%, 15/16 cells |
| `139474473857712` | flat cel-shaded grey puffs | 4x4 | M | 9 | Stuff2/sm3/Smoke5 | clear, white, 3 parts, eff 51, fill 15%, 14/16 cells |
| `16867397491` | flat grey toon swirl with a lighter top | 4x4 | M | 6 | smoksmok | clear, white, 1 part, eff 107, fill 9%, 15/16 cells |
| `16867460128` | hard-edged white puffs | 8x8 | D | 5 | Smoke27 | clear, white, 1 part, eff 30 smooth, fill 23% |
| `11822996479` | toon puffs dissolving | 4x4 | M | 12 | Fancy Dissapearing Smoke | clear, white, 1 part, eff 55, fill 20%, 15/16 cells |
| `11858203067` | stylised puffs with dark detail | 4x4 | M | 11 | Stylized Smoke8/Black1 | clear, grey, 1 part, eff 56, fill 28%, 13/16 cells |
| `74149687949243` | toon smoke with dark outlines and inner shading | 4x4 | D | 5 | smoke/wind | clear, grey, 1 part, eff 56, fill 28%, 13/16 cells |
| `138231890129613` | toon puff with dark speckles | 4x4 | D | 11 | smh/new smoer | clear, white, 1 part, eff 43 smooth, fill 26%, 12/16 cells |

### 14. Fire and flame

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `15413764911` / `14005903992` | sharp toon flame tongue flick, ~6 frames then empty (same art) | 4x4 | D/M | 16/7 | FLAME SHARDS/SpikeFlip1: VelocityParallel + squash | clear, white, 3 parts, eff 82, fill 12%, 7/16 cells; twin eff 57 |
| `11846119288` | soft-edged toon fire blob splitting into flicks | 4x4 | D | 13 | Fire 2/11.n | clear, white, 1 part, eff 99, fill 15%, 15/16 cells |
| `11844017484` | single S-shaped flame tongue | 4x4 | M | 9 | 2aura/RealisticFire | clear, white, 1 part, eff 47 smooth, fill 14%, 15/16 cells |
| `11841348746` | soft toon flame puffs | 4x4 | M | 7 | firetooney/5aura | clear, white, 1 part, eff 45 smooth, fill 18%, 13/16 cells |
| `16847071704` | flat horizontal flame wisps | 4x4 | D | 10 | Fire20/firey | clear, grey, 3 parts, eff ~59, fill 9%, 14/16 cells |
| `17006172452` | grey blobs with black jagged outlines | 4x4 | D | 7 | cursed energy/Toon Fire 4 | clear, grey, 6 parts, eff 91, fill 16% |
| `16860307403` | swirling flame ellipse breaking up | 4x4 | M | 9 | Fire38 | FAINT, grey, 4 parts, eff 93, fill 25%, 10/16 cells |
| `11458438415` | realistic energy fire | 8x8 | A | 9 | EnergyVFX10/realistic fire | clear, white, 2 parts, eff 39 smooth, fill 13%, 52/64 cells |
| `13997926164` | flame-shaped flash flicking upward | 4x4 | D | 13 | Sparkflipx2/Hit/Downward Impact | clear, white, 1 part, eff 117, fill 12%, 7/16 cells |

### 15. Lightning and electric

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `243098098` | single branching realistic bolt | - | M | 11 | Lightning/ExplosionBrightspot | FAINT, white, 2 parts, eff 299, fill 4% |
| `13780092154` | thick electric curls | 4x4 | M | 12 | Lightning/zipzap | FAINT, white, 5 parts, eff 107, fill 4%, 13/16 cells |
| `11492870634` | big curly arcs | 4x4 | M | 7 | Lightning1 | FAINT, white, 3 parts, eff 46 smooth, fill 9% |
| `13013256540` | smoky electric squiggle | 4x4 | M | 10 | Purple Lightning | clear, white, 2 parts, eff 43 smooth, fill 12% |
| `12848554034` | horizontal jagged crackle lines | 4x4 | M | 8 | Lightning 2/LightningRing | clear, white, 2 parts, eff 109, fill 5%, 13/16 cells |
| `13390196434` | small zigzag arcs | 4x4 | D | 6 | moving lightning | clear, white, 2 parts, eff 79, fill 7%, 10/16 cells |
| `126275989641021` | tiny branching sparks | 4x4 | M | 6 | Breaking Apart Lightning | clear, white, 4 parts, eff 95, fill 3%, 10/16 cells |
| `14379744080` | horizontal bolt-shaped flicks | 4x4 | D | 7 | Shorter impact 2 | clear, white, 1 part, eff 104, fill 6%, 6/16 cells |
| `85772363699785` | toon jagged white swoosh (beam/trail) | - | M | 7 | Beam100/Trail | clear, white, 3 parts, eff 105, fill 17% |

### 16. Impact bursts and splash stars
Single images are short 'impact frames' (life 0.03-0.25 s); flipbooks play the whole pop.

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `18118762332` | spiky starburst flash | - | A | 10 | flash/Impact (life 0.03 s, Size ~20) | clear, white, 1 part, eff 110, fill 22% |
| `16892231149` | spiky splash burst, hollow centre | - | D | 8 | Impact15 | clear, white, 1 part, eff 108, fill 27% |
| `16892226410` | spiky star with long rays, hollow centre | - | M | 6 | Impact13 | clear, white, 1 part, eff 42 smooth, fill 21% |
| `9132707475` | toon explosion splat star | - | D | 6 | Blast3 | clear, white, 1 part, eff 86, fill 26% |
| `18140248952` / `13634052022` | toon smack: flash, 4-spike star with dark spikes, broken ring (8 frames; same art) | 4x4 | D/M | 15/5 | Circular Smack/ImpactCartoon; ToonImpact | clear, white, 2 parts, eff ~67, fill 11%, 7/16 cells; twin eff 107 |
| `115475105765006` | toon explosion star growing, then hollowing | 4x4 | D | 8 | Full short impact | clear, white, 1 part, eff ~65, fill 16%, 8/16 cells |
| `13736805356` | spiky pop: star becomes a ring of spikes | 4x4 | D | 9 | wavy/Wave2/UpWave | clear, white, 2 parts, eff 81, fill 12%, 14/16 cells |
| `18457400581` | four sharp spiky star shards | 2x2 | M | 11 | Spike Impact 2x2 | clear, white, 6 parts, eff 220, fill 5% |
| `16879949189` | spiky stars that scatter | 4x4 | M | 10 | Impact1/Purple1 | clear, white, 4 parts, eff 46 smooth, fill 8%, 8/16 cells |
| `115257157082446` | ring of fragments dispersing | 4x4 | M | 10 | Impact61 | clear, white, 7 parts, eff 87, fill 5% |
| `15118104864` | horizontal claw slashes | 4x4 | M | 9 | Claw impact | clear, white, 3 parts, eff 47 smooth, fill 7%, 8/16 cells |
| `17296456452` / `13621316962` | soft radial spike burst round a hollow centre, 1024 px (same art) | - | A/M | 4/4 | SW2/Hit13; WavesInner: a high-res flash for big sizes | clear, white, 1 part, eff 247, fill 32% |
| `16892332741` | crisp toon star splat, five long points, 601 px | - | D | 5 | Impact40: solid (LE 0) toon star | clear, white, 1 part, eff 266, fill 24% |

### 17. Debris, rocks, shards
Debris is sprites, not meshes: FacingCamera, Size 0.3-0.7, mostly spinning, long life (0.85-2 s).

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `15441282898` | four grey low-poly rocks | 2x2 | D | 10 | Rocks 2x2 (Loop = tumbling silhouette) | clear, grey, 1 part, eff 51, fill 52% |
| `626588936` | painted beige cartoon rock | - | D | 14 | Rocks (Size ~0.3, 111/122 spinning) | clear, pale orange, 1 part, eff ~311, fill 72% |
| `6730730442` | photo rock, grey with moss | - | D | 6 | Rocks | clear, grey, 1 part, eff 376, fill 43% |
| `15841621175` | small ice/glass shards | 8x8 | D | 5 | Ice/glass3 | clear, white, 1 part, eff 57, fill 6%, 62/64 cells |
| `15702022878` | grass blades and leaves | 8x8 | D | 5 | grass_blade/leaves (Loop) | clear, grey, 1 part, eff 50, fill 19% |
| `16879808635` | small triangular shard | - | M | 5 | Spec27/Debris (194/241 spinning) | clear, white, 1 part, eff 173, fill 2% |
| `12919895706` | cluster of vertical spike shards | - | M | 6 | spikesTypeD/WindShard | clear, white, 1 part, eff 154, fill 14% |
| `8708744804` | jagged crown of white spikes | - | M | 5 | 1/Shards/StrongParticle | clear, white, 1 part, eff 159, fill 21% |

### 18. Blood, water, liquid
Hard-edged white shapes tinted red/blue, LE 0 or negative so they stay opaque.

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `14431663347` | solid toon splat breaking into droplets | 4x4 | D | 11 | Blood/blood splatter | clear, white, 2 parts, eff 104, fill 15%, 15/16 cells |
| `14601007537` | tiny drip splats | 4x4 | D | 6 | Blood/Bloodup/Paint Splatter | clear, white, 4 parts, eff 85, fill 3% |
| `16865903588` | branching droplet spray | 4x4 | D | 7 | Water12 | clear, grey, 3 parts, eff 102, fill 6%, 14/16 cells |
| `13795304468` | splash crown breaking into droplets | 4x4 | D | 8 | Breaking Splash | clear, white, 5 parts, eff 108, fill 5%, 14/16 cells |
| `11794599322` | toon arrow-shaped splat breaking | 4x4 | D | 7 | flip/Splash | clear, white, 2 parts, eff 42 smooth, fill 9%, 15/16 cells |
| `12893271073` | small spiky splat crown shrinking | 4x4 | D | 9 | Particle_1/2 | clear, white, 1 part, eff 86, fill 5%, 9/16 cells |
| `10718317753` | wavy liquid caustic streaks (beam, Wrap) | - | M | 6 | Beam4/Trail2 | clear, white, 4 parts, eff 84, fill 35% |
| `71693355161247` | white toon vein/cell pattern (beam) | - | M | 6 | Beam117 | clear, white, 4 parts, eff 233, fill 19% |

### 19. Ground cracks
VelocityPerpendicular ground sprites, long life (0.8-3.7 s).

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `13782885260` | dark spidery cracks round a white impact point, fading | 4x4 | D | 11 | Fading dark ground crack | clear, black+white, 8 parts, eff 105, fill 11%, 14/16 cells |
| `13783882492` | darker spidery crack, white centre | 4x4 | D | 8 | Crack/Ground | clear, black+white, 4 parts, eff 81, fill 23%, 15/16 cells |
| `130658933079638` | realistic crater with cracks | - | D | 6 | Ground15/GlowCrack | clear, white, 1 part, eff 110, fill 41% |
| `91578195629955` | bright spiky glowing crack bursts | 8x8 | D | 6 | Ground15 | clear, white, 1 part, eff 37 smooth, fill 43%, 58/64 cells |
| `17137667240` | white cracked debris clusters | 4x4 | M | 6 | crack1 | clear, white, 4 parts, eff ~42 smooth, fill 25%, 15/16 cells |
| `99911247720869` | single bright crack starburst | - | M | 5 | Crack2/floor2 | clear, white, 1 part, eff 129, fill 16% |

### 20. Beam and trail textures
Almost all TextureMode Stretch.

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `16892453445` / `13712010449` | smeared flowing soft noise (same art) | - | M | 11/7 | Beam11 (152); used by 445 beams | clear, white, 2 parts, eff 74, fill 59% |
| `105185967968678` | crossing wispy curves with sparkles | - | A | 11 | Beam109/AuraBeam | FAINT, white, 3 parts, eff 83, fill 61% |
| `10240434007` | hard-edged white blob streak (toon) | - | M | 9 | BeamDrag smoke | clear, white, 2 parts, eff 170, fill 19% |
| `12823611043` | thin intertwining smoke strands | - | A | 8 | BeamSmoke beam 3 (311 beams) | clear, white, 2 parts, eff 139, fill 21% |
| `128120435243451` | noisy smoke stream | - | M | 9 | Beam | FAINT, white, 6 parts, eff 298, fill 33% |
| `6091474388` | glittery vertical noise streaks | - | M | 7 | Beam3/Redlines | clear, white, 3 lines, eff 315, fill 35% |
| `118613370531472` | jagged white flame-mountain shape | - | M | 6 | Beam75 | clear, white, 2 parts, eff 112, fill 35% |
| `12251461261` | soft vertical fog wisps | - | M | 6 | BeamWavey fog | clear, white, 1 part, eff 44 smooth, fill 58% |
| `12991508490` | black torn blob with a white centre | - | M | 6 | Beam/outerslash/Beam Slash | clear, grey, 1 part, eff 492, fill 25% |

### 21. Energy and aura misc

| id | looks like | grid | light | files | typical use | traits |
|---|---|---|---|---|---|---|
| `13992197350` | faint fractal outlines | 4x4 | D | 12 | Pulse/Fractal/BlackStuff | clear, white, 9 parts, eff 91, fill 6%, 11/16 cells |
| `16511790647` | realistic energy pulse | 8x8 | M | 9 | Realistic Energy Pulse | DARK haze, grey, 1 part, eff 27 smooth, fill 44% |
| `12683695494` | aura cloud | 8x8 | M | 6 | AuraCloud/BlackAura/PurpleAura | clear, white, 1 part, eff 34 smooth, fill 14%, 45/64 cells |
| `12401154143` | chromatic shards (coloured) | 8x8 | A | 6 | Chromatic Shards | clear, multicolour, 7 parts, eff 44 smooth, fill 7% |

## Starter kit (33 ids)

These show up in 29% of the 6,148 effects and 44% of the pack files. Texture use is a long tail though (14.5k distinct
ids; the top 384 cover 37% of emitter layers, the top 1500 cover 63%), so treat this as the shared core.

- spark dot -> `16878181512` (D) | orbiting spec -> `9997556038` soft, `16171528032` sharp
- big soft glow -> `867619398` | flash behind a hit (small dot used at Size ~30) -> `16879789169`
- thin lens star -> `17391818367` | fat sparkle -> `14006783533` (the 1024 px twin of `17062454177`)
- spark streak (VelocityParallel + Squash) -> `8030734851` | speed lines -> `18465146997`
- light rays from a point (random Rotation, additive) -> `1053548563` (BLACK card: never below LE 1)
- spinning wind ring -> `18527700887` | clean thin ring -> `18682826321`
- hairy shock ring -> `7417145436` | shock disc -> `9659008631` | soft starburst -> `8048608283` (DARK haze: additive
  only)
- ring flipbook, thick to hairline -> `126034245450101` (4x4)
- crescent slash -> `13780268621` (4x4) | crescent ring burst -> `16026345008` (4x4)
- wind swirl -> `109440284900004` (4x4)
- soft smoke -> `11871320339` (4x4) | toon smoke -> `16867483883` (4x4) | dense billow -> `15415212938` (4x4)
- lingering dust cloud -> `7216851093`
- toon fire -> `11846119288` (4x4) | flame flick -> `15413764911` (4x4)
- lightning -> `13780092154` (4x4)
- toon impact pop -> `18140248952` (4x4) | impact flash frame -> `18118762332` (eff 110: brief and small only; big
  flash -> `17296456452`)
- rocks -> `15441282898` (2x2) | blood/liquid splat -> `14431663347` (4x4) | ground crack -> `13782885260` (4x4)
- beam energy flow -> `16892453445` | beam smoke strands -> `12823611043`

## Patterns in how artists use them

- **One sheet, two jobs.** M textures carry both an additive glow copy and an opaque copy: `109440284900004` has 262
  LE-1 and 355 LE-0 layers; on `14687560696` the LE-1 layers are white (median colour luminance 255) and the LE-0 layers
  dark (96). LE-0 layers are tinted dark (darkest colour key < 25%) twice as often as additive ones (28.5% vs 13.5%).
- **Negative LightEmission is common** (14% of emitter layers) and comes with high Brightness (median 13-15). It sits
  on specs, sparks and speed lines: `16878181512` 193/520 layers, `11762072190` 302/475, `16879806460` 100/190.
- **Small texture, huge Size.** A small soft dot scaled up gives a glow with no hard edge: `16879789169` at median Size
  31.6 for 0.24 s, `9659008631` at Size ~31 for 0.07 s, `110017652984281` at Size ~75. Flares and specs get ZOffset 2-3
  to sit in front of the rest (`16878181512`, `17062454177`, `17450657969`, `10598374841`).
- **Impact frames last a few frames**: `18118762332` lives 0.03 s (2 frames at 60 fps), `9710916533` 0.08 s,
  `16892231149` 0.09 s.
- **Rings and crescents are flat and spinning**: VelocityPerpendicular (41% of all designs) + RotSpeed; the two-arc ring
  `18527700887` spins in 917 of 917 layers. FacingCamera is 35%, VelocityParallel 21%.
- **Streaks are squashed sprites**: VelocityParallel + Squash (25% of designs squash), speed lines live 0.05-0.1 s.
- **Off-centre dots orbit** (see group 2) and **edge-to-centre needles make ray bursts** (`1053548563` 109/162 layers
  spin, named "Holy Rays").
- **Debris is sprites**, not meshes: rock images at Size 0.3-0.7, FacingCamera, mostly spinning, 0.85-2 s; `15441282898` loops
  its four rocks so a tumbling rock changes shape.
- **Bursts, not streams**: 88% of designs carry an `EmitCount` attribute for scripted `:Emit()`, 9% emit
  continuously. 51% have Lifetime max <= 0.5 s, 86% LightInfluence 0, 55% Brightness above 1.
- **Popular art is re-uploaded**: the two-arc ring exists as 5 ids (`18527700887`, `10859315454`, `15269685466`,
  `13931762875`, `17409991165`), the thinning ring as 3, and a dozen more pairs are marked "same art" above.
