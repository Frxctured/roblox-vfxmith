# Texture vocabulary (open-source Roblox VFX)

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
several ids: take the one with more files and keep the twin as a fallback.

**Light modes.** LightEmission 1 adds the texture onto the scene: black adds nothing, so a texture painted on an opaque
BLACK background (marked "on BLACK"; most of the old `10849xxxxx` series) works ONLY additively, at LE 0 you see a black
square. A texture on transparency works both ways: LE 1 = glow, LE 0 = solid matter that keeps its colour, and with a
dark `Color` it becomes the dark "ink" layer. Negative LightEmission (-0.1 to -15) appears in 14% of emitter layers to
darken and thicken; it is outside the documented 0-1 range (LihFolk vault note "Particle Emitters In Depth", if you have it), re-check after engine
updates. All but a handful of textures are greyscale and are tinted with `Color`; the coloured ones are noted.

**Flipbooks.** One 1024x1024 sheet cut into a grid: `Grid2x2` = 4 frames of 512 px, `Grid4x4` = 16 of 256 px (the
standard: 35% of all emitter designs), `Grid8x8` = 64 of 128 px (smoother, smaller: 3%). Set `FlipbookLayout` to the
grid; 92% of flipbook layers use `FlipbookMode = OneShot`, which plays the sheet once over each particle's Lifetime (so
Lifetime IS the timing); `Loop` uses `FlipbookFramerate` (max 30). Many sheets fill only 6-12 of their 16 cells and
leave the rest empty, so the particle vanishes before it dies: a built-in hard cut. A sheet on the wrong grid (or not
1024x1024) shows as a mosaic or does not animate.

## Role groups

### 1. Specs and dots (centred)
Variants: hard vs soft edge, pin-prick vs disc, single vs scattered, blinking flipbook. Used as sparks (FacingCamera, Size 1-3) or, with VelocityParallel + Squash, as short streaky sparks.

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `16878181512` | small hard white dot, thin soft edge | - | D | 24 | Spec1/Specs/Sparks (520 layers; 193 of them with negative LE) |
| `8030760338` | same small soft dot, a touch blurrier | - | M | 21 | Specs/Orbs/Debris2 |
| `13712002093` | pin-prick dot just below the top edge | - | A | 12 | Specs/Dust |
| `15153511168` | solid white disc with a faint halo | - | M | 6 | Shards2/impact texture: hard orb core |
| `1084962479` | solid white disc with soft glow, on BLACK | - | A | 9 | Core: orb cores |
| `16878191468` | soft dot blinking big/small | 4x4 | M | 7 | Spec4/Sparks3 |
| `13189667061` | glow dot that grows, peaks and shrinks | 4x4 | M | 10 | 23/Glow/Flare11: one-shot twinkle |
| `16511093402` | very tiny glitter specks | 8x8 | M | 10 | Glitter |
| `18450596124` | ~15 tiny specks scattered over one image | - | M | 8 | Multiple Specs 14/Debrisflock: many specs per particle |
| `7231210720` | grainy cluster of grey noise specks | - | M | 8 | smokeSpecs1/Derbi Grid: dust grain |

### 2. Off-centre specs (orbiters)
The dot sits away from the centre, so a random Rotation plus RotSpeed makes it circle the particle centre (radius = offset x Size). Most layers that use them spin (`16171528032` 104/115, `9997556038` 221/246, `8414194072` 32/32, `16879806460` 162/190). Size is tiny (0.4-2).

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `9997556038` | soft dot in the top-left corner | - | M | 18 | ParticleEmitter/Specs/'DotGlowOffset' |
| `16171528032` | sharp dot a quarter in from the top-left | - | D | 17 | OffCentered Spec 46 |
| `8084996370` | soft dot at top centre | - | M | 13 | Specs/'DotNoBGOffset' |
| `11448304274` | bigger soft dot upper-left | - | D | 12 | specs1-3 (80 layers at LE -2) |
| `10205180639` / `8511527728` | fuzzy rough-edged dot, top-left corner (same art) | - | M | 13/7 | Specs3/dots/Embers |
| `8414194072` | solid hard dot top-left | - | A | 8 | Specs/Dots |
| `12942158384` | glowing soft dot top-left | - | M | 8 | Embers1/Specs1 |
| `16879806460` | tiny sharp sliver top-left | - | M | 8 | Spec26 (100 of 190 layers at negative LE) |
| `8242018934` | hard dot at top, right of centre | - | M | 7 | spec2/ember |
| `17334135713` | tiny dot in the bottom-left corner | - | M | 7 | OffCentered Spec 4: wide orbit |
| `1084996976` | soft dot near the bottom edge, on BLACK | - | A | 9 | Absorb/Specs2 |

### 3. Soft glows
Variants: core size (small dot vs frame-filling blob), hot pinpoint centre vs flat, dim haze. Glows are FacingCamera; the smallest-looking ones are used biggest.

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `867619398` | big soft blob filling most of the frame | - | M | 15 | Glow/Corner/GlowIN (237 layers) |
| `77024587778878` | big blurry disc | - | M | 15 | Basic Blurry Spec/auracenter |
| `13712004045` | big soft blob | - | A | 14 | Glow/Cosmic Aura/Hunter Aura |
| `12159555294` | medium glow with a denser core | - | M | 20 | Glow/glowemit/specsemit |
| `1075864321` | wide faint halo with a hot pinpoint centre | - | M | 17 | glow/Light, life ~0.2 s |
| `16879789169` | small soft dot (about 1/5 of the frame) | - | A | 12 | Spec19/Glow: median Size 31.6, life 0.24 s = flash behind a hit |
| `6673021984` | soft halo with a tiny bright centre | - | M | 9 | Glow particle |
| `243664672` | large soft glow | - | M | 6 | Poison/Other1Shock (181 layers, ZOffset ~2) |
| `98046010009179` / `448862775` | dim, low-contrast large haze | - | A/M | 6/7 | Dark/overlayglow/shadow: subtle tint or darkening |
| `121143963977274` | halftone-dot sphere, on BLACK | - | A | 5 | comic-style glow |

### 4. Flares and 4-point stars
Variants: thin cross with a glow core (lens flare), fat concave 'diamond sparkle', X/8-point flare with ring, chromatic. On black = additive only. Mostly short (life 0.1-0.5 s), Brightness 5-77, often squashed.

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `17391818367` | thin long cross, small glow core | - | M | 15 | Star102 (190 names) |
| `14590086212` | long thin cross, vertical arm longer | - | M | 17 | Star113/BrightBlinky (median Brightness 77) |
| `10598374841` | cross with a soft round glow core | - | A | 19 | Star99/Flare1 |
| `17062452122` | small short cross | - | M | 14 | Star12 |
| `17062454177` / `14006783533` | fat concave 4-point sparkle, sharp tips (same art) | - | M | 7/10 | Sparks (285)/Flash; squashed in 393/413 layers |
| `1084970835` / `1053546634` | fat concave sparkle on BLACK (same family) | - | A | 13/6 | E16/Grad/Sparkles |
| `17450657969` | long thin 4-point star | - | D | 5 | Sparks (225), Brightness ~25, life 0.2 |
| `10556525755` | thin cross with glow, on BLACK | - | A | 9 | Flash/Stars/AwakeningAura |
| `17062416111` | cross with RGB-split fringe and dark core (coloured) | - | M | 9 | Sparks (223)/Star3 |
| `7216848832` | X-shaped flare with a faint ring and thin axis rays | - | A | 6 | Flare2/Star |
| `7160024951` | X flare with many fine rays and a ring | - | A | 6 | 1/E1 (all layers spin) |
| `7216849703` | blurry soft 4-point glow | - | M | 7 | Star2a/shard |

### 5. Needles, streaks, speed lines
Variants: soft lens vs hairline vs hard diamond; edge-to-centre ray needles; noisy streak bands. Almost always VelocityParallel + Squash, life 0.05-0.45 s.

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `8030734851` | soft vertical lens streak | - | M | 14 | Shards/Slash3 (squash 110/138) |
| `1315202524` | very thin vertical line | - | M | 11 | Stripes/bigline/line |
| `8970920735` | diamond needle with long thin tips | - | M | 7 | E12/Sparks2 |
| `18118860997` | solid sharp diamond with a thin black outline | - | D | 5 | Slash (86): Size ~24, toon slash streak |
| `10439119562` | small flame-teardrop shard | - | M | 15 | Shards/BShards |
| `3052949762` | horizontal anamorphic lens streak | - | M | 12 | Custom Lens Flare/Glare/FlashingStarSQUASH |
| `9710916533` | horizontal streak with tiny starburst and faint halo | - | M | 9 | Flash (86): life 0.08 s, Size ~24 |
| `1053548563` | needle from the bottom edge tapering to the centre, on BLACK | - | A | 21 | Holy Rays/Rays_Thick: random Rotation = rays from a point |
| `8905957078` | needle from the top edge to the centre | - | M | 7 | big rays/Ray1 |
| `18465146997` | horizontal band of jagged noise streaks | - | D | 11 | SpeedLines (559): squash 606/607, life ~0.09 |
| `18116056206` | blotchy spiky streak noise | - | D | 6 | SpeedLines (660) |
| `11762072190` | ragged vertical flame-like streaks | - | D | 10 | '15' (426 names), mostly LE -2.5 |

### 6. Rings (single image)
Variants: thin/clean, soft/blurred, two-arc crescent ring with dark smear, broken/flecked, bubble rim. Nearly all VelocityPerpendicular (flat, facing along the emit direction) and spinning.

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `18527700887` | two-arc ring: white leading edges trailing into dark-grey smears | - | A | 10 | C1/Crescents (917 layers, all spinning): wind ring |
| `10859315454` / `15269685466` | same two-arc ring art (other uploads; also 13931762875, 17409991165) | - | A | 19/10 | Wind/ring; decay16 |
| `18682826321` | clean soft thin ring | - | A | 6 | ring pulse (180/180 spinning) |
| `8050136743` | crisp thin bright ring | - | D | 6 | Outline/RingsIn |
| `11037291253` / `12442685305` | thin ring with brighter knots, on BLACK (same art) | - | A | 11/5 | ring/wind; Wave4/CIrc |
| `18682835879` | ring with sparkly knots | - | A | 9 | SW1 |
| `10149702982` | soft smoky wispy ring | - | M | 9 | wind/black (472 layers) |
| `10358044068` | soft blurred ring of several loops | - | M | 9 | Impact214 |
| `13440561704` | wobbly thin ring, heavier at the bottom | - | A | 9 | Wave22/Wave31 |
| `15021706755` | broken ring of wind arcs | - | A | 9 | WIDSNMW/winds |
| `8196169974` | bubble: thin bright rim, faint fill | - | D | 8 | Gradient/Charge |
| `1084991215` | sphere rim on BLACK (dark centre, bright edge) | - | A | 9 | Shield1/orb_in |

### 7. Shock discs, spiky rings, starbursts
Variants: hairy ring (spikes on the inner edge), radial-streak disc, starburst around a hollow centre, ray sunburst.

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `7417145436` / `8904012224` | ring with a spiky inner fringe (same art) | - | A/D | 14/6 | Impact446; 23qddf2 (234) |
| `115692375305535` | hairy ring, spikes both sides | - | M | 6 | Shockwave/Impact7 |
| `14538969234` | ragged spiky ring with debris spikes | - | A | 5 | Shockwave/Red'pikeyShockwave |
| `9659008631` / `11820076505` | soft disc: glowing rim + radial streaks inward (same art) | - | A/M | 8/7 | Shock (life 0.07, Size ~31); Imp/Shockwave |
| `15333808121` | radial-streak fringe ring | - | M | 6 | Impact117 |
| `10176632695` | radial-streak ring in broken segments | - | M | 8 | Impact245/shock |
| `11198241185` | spiky radial burst round a hollow centre | - | M | 8 | Shock/airWaves |
| `8048608283` / `111453160791180` | faint starburst of soft spikes round a hollow (same art) | - | A/D | 13/5 | C3/SW2/wave/flash (620 layers, Size ~24) |
| `1084975295` | sunburst of rays, on BLACK | - | A | 6 | Rays/Ray/Hit2 |
| `1084999891` | soft radial rays round a dark centre, on BLACK | - | A | 10 | flare/Light |

### 8. Rainbow and chromatic
Coloured textures are rare (the others: `17062416111` chromatic star, `12401154143` chromatic shards); use them untinted (white Color).

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `12105193694` | soft double rainbow halo | - | A | 11 | Flare170New/Rainbow3 |
| `85664013418740` | thinner rainbow ring | - | A | 10 | Rainbow3 |
| `15020647902` | rainbow crescent on BLACK | - | A | 7 | Floor3/rainbow |
| `96288653875185` | two rainbow arcs ( ) on BLACK | - | A | 7 | Rainbow6 |
| `12188469991` | thin ring with blue/orange fringe, on BLACK | - | A | 6 | PulseRipple |
| `8114157061` | orange-red spark streak (coloured) | - | M | 8 | Sparks1-3 |

### 9. Ring and shockwave flipbooks
Variants: thick ring thinning to a hairline, thin ring breaking, ring of puffs/fragments, ring that forms then crumbles. `14687560696` is the most-used ring flipbook (Circle, 473 layers, 4x4, M) but **does not load any more** ("not approved"); use another ring below. It had no thumbnail: check it in Studio before use.

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `126034245450101` / `13675192481` | thick white ring thinning to a hairline, then breaking (same art; also 14762708319) | 4x4 | M/A | 7/7 | circleFlipbook2; ring half |
| `12906276200` | thin ring expanding and breaking | 4x4 | M | 12 | Thin realistic shockwave |
| `16877839414` | thin circle outlines | 4x4 | M | 9 | Circle2/GuardBoom |
| `11865130475` | pixel-style thick ring expanding | 4x4 | M | 6 | Pixel circle expanding |
| `110017652984281` | ring of puffs fading | 4x4 | M | 6 | Fancy Shockwave (median Size 75) |
| `13795445083` | soft flower-shaped ring with spikes dispersing | 4x4 | M | 10 | Web Shockwave/RBurst |
| `12844593455` | ring of soft fragments | 4x4 | M | 6 | Flipbook Energy Shockwave/DarkImpact |
| `13795988483` | crumbly ring that forms, then breaks apart | 4x4 | M | 10 | Breaking Returning AOE |

### 10. Crescents and slashes
Single crescents spin (VelocityPerpendicular + RotSpeed) as wind arcs; flipbooks play a slash once (life 0.15-1 s).

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `13225943898` | sharp thin arc across the top | - | A | 6 | Wave2 (196/198 spinning) |
| `1084996536` | sharp top arc on BLACK | - | A | 9 | Wave/wind4 |
| `17388367001` | soft blurred top arc | - | A | 7 | C2 (248 layers, all spinning) |
| `8528430235` | bottom-heavy wispy smear arc | - | A | 7 | Wave1 (squashed 145/150) |
| `10558510611` | thin crescent at bottom-right | - | M | 10 | clashcircle |
| `15737239528` | two thick dark-edged slash arcs | - | M | 6 | E17 |
| `1084963972` | clean thick crescent moon | - | A | 5 | Particles/Wave |
| `13780268621` | thick crescent with dark inner edge thinning to a hairline | 4x4 | M | 13 | Slashed/Layered Slash |
| `13805841956` | crescent filled with dark ink shading | 4x4 | M | 11 | Alpha/Layered Dark Slash |
| `17085222506` | thin crescents fading | 4x4 | M | 15 | Black Cresents/SLICE |
| `16026345008` | thick crescent ring that bursts and fades in ~7 frames | 4x4 | A | 5 | decay8 (427), 573 layers |
| `14973797453` | four bold toon crescent slashes, slightly cream | 2x2 | M | 6 | Flat3d/Drawn Crescent, life ~0.14 |

### 11. Wind swirls and vortex

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `109440284900004` / `17006200673` | thick swirling white wind circle shredding into wisps (same art) | 4x4 | M | 13/20 | CIrc/LBG wind (639 layers); Circle72 |
| `127940423551603` / `131070767868542` | pair of wispy comma swirls fading (same art) | 4x4 | D/M | 14/9 | C1/Wind (401 layers); Crescents1 |
| `91230378159183` | curved crescent-shaped smoke wisps | 4x4 | D | 5 | smoke/wind |
| `15048784530` | curved ink-stroke flicks | 4x4 | M | 9 | Absorb Swirl |
| `15011464541` | faint tornado | 8x8 | M | 11 | tornado13/Crimson Aura |
| `12191903502` | twisting helix ribbon strands (beam) | - | M | 9 | Beam5/Wind |
| `119473092655714` | dark vortex of noisy wisps, on BLACK | - | A | 10 | slash/fog-galaxy |
| `12685367098` | hooked wispy swirl, on BLACK | - | A | 6 | Wind1/RealLinger |
| `10856287046` | thick ring of black/white swirl bands | - | A | 6 | colorwind/ring |
| `14004151283` | ring of puffs growing outward | 4x4 | D | 6 | Vortex/Burst |

### 12. Smoke: soft and realistic
Variants: wispy vs dense billow, rising from the ground, 8x8 small puffs (smoother motion, 128 px frames).

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `11871320339` / `16867347280` | soft wispy puff curling and fading (same art) | 4x4 | D/M | 13/8 | Smoke (295 names, 407 layers) |
| `16867490141` | faint low-contrast grey smoke | 4x4 | M | 12 | Smoke/Smoke32 (life ~2.4 s) |
| `15415212938` | dense billowing realistic cumulus | 4x4 | D | 11 | Billowing |
| `14945509165` | realistic dust puff growing and fading | 4x4 | D | 10 | Linger/Dust2 |
| `11866744589` | smoke rising from the ground, bottom-anchored | 4x4 | D | 10 | wavy/UpSmoke/Darkening realism |
| `11627083142` | small soft blurry grey puffs | 8x8 | D | 9 | Dark Grey Smoke 2 |
| `11799607237` | tiny soft puffs, small in frame | 8x8 | D | 18 | Smoke/Cut Smoke |
| `73401626133942` | realistic layered fog | 8x8 | D | 6 | Realistic Layered Fog |
| `8527116276` | single grey fluffy realistic puff | - | D | 14 | Plume5/smoke/ImpactSmoke |
| `7216851093` | single grainy dirty dust cloud | - | D | 6 | dust/WallDust (340 layers, life ~2 s) |

### 13. Smoke: toon and stylised
Hard-edged puffs that break into crescent bits. As LE 0 they read as solid matter; with dark shading they are the 'ink' layer.

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `16867483883` | solid white toon cloud breaking into crescent bits | 4x4 | D | 11 | Smoke30 (417 layers) |
| `139474473857712` | flat cel-shaded grey puffs | 4x4 | M | 9 | Stuff2/sm3/Smoke5 |
| `16867397491` | flat grey toon swirl with a lighter top | 4x4 | M | 6 | smoksmok |
| `16867460128` | hard-edged white puffs | 8x8 | D | 5 | Smoke27 |
| `11822996479` | toon puffs dissolving | 4x4 | M | 12 | Fancy Dissapearing Smoke |
| `11858203067` | stylised puffs with dark detail | 4x4 | M | 11 | Stylized Smoke8/Black1 |
| `74149687949243` | toon smoke with dark outlines and inner shading | 4x4 | D | 5 | smoke/wind |
| `138231890129613` | toon puff with dark speckles | 4x4 | D | 11 | smh/new smoer |

### 14. Fire and flame

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `15413764911` / `14005903992` | sharp toon flame tongue flick, ~6 frames then empty (same art) | 4x4 | D/M | 16/7 | FLAME SHARDS/SpikeFlip1: VelocityParallel + squash |
| `11846119288` | soft-edged toon fire blob splitting into flicks | 4x4 | D | 13 | Fire 2/11.n |
| `11844017484` | single S-shaped flame tongue | 4x4 | M | 9 | 2aura/RealisticFire |
| `11841348746` | soft toon flame puffs | 4x4 | M | 7 | firetooney/5aura |
| `16847071704` | flat horizontal flame wisps | 4x4 | D | 10 | Fire20/firey |
| `17006172452` | grey blobs with black jagged outlines | 4x4 | D | 7 | cursed energy/Toon Fire 4 |
| `16860307403` | swirling flame ellipse breaking up | 4x4 | M | 9 | Fire38 |
| `11458438415` | realistic energy fire | 8x8 | A | 9 | EnergyVFX10/realistic fire |
| `13997926164` | flame-shaped flash flicking upward | 4x4 | D | 13 | Sparkflipx2/Hit/Downward Impact |

### 15. Lightning and electric

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `243098098` | single branching realistic bolt | - | M | 11 | Lightning/ExplosionBrightspot |
| `13780092154` | thick electric curls | 4x4 | M | 12 | Lightning/zipzap |
| `11492870634` | big curly arcs | 4x4 | M | 7 | Lightning1 |
| `13013256540` | smoky electric squiggle | 4x4 | M | 10 | Purple Lightning |
| `12848554034` | horizontal jagged crackle lines | 4x4 | M | 8 | Lightning 2/LightningRing |
| `13390196434` | small zigzag arcs | 4x4 | D | 6 | moving lightning |
| `126275989641021` | tiny branching sparks | 4x4 | M | 6 | Breaking Apart Lightning |
| `14379744080` | horizontal bolt-shaped flicks | 4x4 | D | 7 | Shorter impact 2 |
| `85772363699785` | toon jagged white swoosh (beam/trail) | - | M | 7 | Beam100/Trail |

### 16. Impact bursts and splash stars
Single images are short 'impact frames' (life 0.03-0.25 s); flipbooks play the whole pop.

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `18118762332` | spiky starburst flash | - | A | 10 | flash/Impact (life 0.03 s, Size ~20) |
| `16892231149` | spiky splash burst, hollow centre | - | D | 8 | Impact15 |
| `16892226410` | spiky star with long rays, hollow centre | - | M | 6 | Impact13 |
| `9132707475` | toon explosion splat star | - | D | 6 | Blast3 |
| `18140248952` / `13634052022` | toon smack: flash, 4-spike star with dark spikes, broken ring (8 frames; same art) | 4x4 | D/M | 15/5 | Circular Smack/ImpactCartoon; ToonImpact |
| `115475105765006` | toon explosion star growing, then hollowing | 4x4 | D | 8 | Full short impact |
| `13736805356` | spiky pop: star becomes a ring of spikes | 4x4 | D | 9 | wavy/Wave2/UpWave |
| `18457400581` | four sharp spiky star shards | 2x2 | M | 11 | Spike Impact 2x2 |
| `16879949189` | spiky stars that scatter | 4x4 | M | 10 | Impact1/Purple1 |
| `115257157082446` | ring of fragments dispersing | 4x4 | M | 10 | Impact61 |
| `15118104864` | horizontal claw slashes | 4x4 | M | 9 | Claw impact |

### 17. Debris, rocks, shards
Debris is sprites, not meshes: FacingCamera, Size 0.3-0.7, mostly spinning, long life (0.85-2 s).

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `15441282898` | four grey low-poly rocks | 2x2 | D | 10 | Rocks 2x2 (Loop = tumbling silhouette) |
| `626588936` | painted beige cartoon rock | - | D | 14 | Rocks (Size ~0.3, 111/122 spinning) |
| `6730730442` | photo rock, grey with moss | - | D | 6 | Rocks |
| `15841621175` | small ice/glass shards | 8x8 | D | 5 | Ice/glass3 |
| `15702022878` | grass blades and leaves | 8x8 | D | 5 | grass_blade/leaves (Loop) |
| `16879808635` | small triangular shard | - | M | 5 | Spec27/Debris (194/241 spinning) |
| `12919895706` | cluster of vertical spike shards | - | M | 6 | spikesTypeD/WindShard |
| `8708744804` | jagged crown of white spikes | - | M | 5 | 1/Shards/StrongParticle |

### 18. Blood, water, liquid
Hard-edged white shapes tinted red/blue, LE 0 or negative so they stay opaque.

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `14431663347` | solid toon splat breaking into droplets | 4x4 | D | 11 | Blood/blood splatter |
| `14601007537` | tiny drip splats | 4x4 | D | 6 | Blood/Bloodup/Paint Splatter |
| `16865903588` | branching droplet spray | 4x4 | D | 7 | Water12 |
| `13795304468` | splash crown breaking into droplets | 4x4 | D | 8 | Breaking Splash |
| `11794599322` | toon arrow-shaped splat breaking | 4x4 | D | 7 | flip/Splash |
| `12893271073` | small spiky splat crown shrinking | 4x4 | D | 9 | Particle_1/2 |
| `10718317753` | wavy liquid caustic streaks (beam, Wrap) | - | M | 6 | Beam4/Trail2 |
| `71693355161247` | white toon vein/cell pattern (beam) | - | M | 6 | Beam117 |

### 19. Ground cracks
VelocityPerpendicular ground sprites, long life (0.8-3.7 s).

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `13782885260` | dark spidery cracks round a white impact point, fading | 4x4 | D | 11 | Fading dark ground crack |
| `13783882492` | darker spidery crack, white centre | 4x4 | D | 8 | Crack/Ground |
| `130658933079638` | realistic crater with cracks | - | D | 6 | Ground15/GlowCrack |
| `91578195629955` | bright spiky glowing crack bursts | 8x8 | D | 6 | Ground15 |
| `17137667240` | white cracked debris clusters | 4x4 | M | 6 | crack1 |
| `99911247720869` | single bright crack starburst | - | M | 5 | Crack2/floor2 |

### 20. Beam and trail textures
Almost all TextureMode Stretch.

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `16892453445` / `13712010449` | smeared flowing soft noise (same art) | - | M | 11/7 | Beam11 (152); used by 445 beams |
| `105185967968678` | crossing wispy curves with sparkles | - | A | 11 | Beam109/AuraBeam |
| `10240434007` | hard-edged white blob streak (toon) | - | M | 9 | BeamDrag smoke |
| `12823611043` | thin intertwining smoke strands | - | A | 8 | BeamSmoke beam 3 (311 beams) |
| `128120435243451` | noisy smoke stream | - | M | 9 | Beam |
| `6091474388` | glittery vertical noise streaks | - | M | 7 | Beam3/Redlines |
| `118613370531472` | jagged white flame-mountain shape | - | M | 6 | Beam75 |
| `12251461261` | soft vertical fog wisps | - | M | 6 | BeamWavey fog |
| `12991508490` | black torn blob with a white centre | - | M | 6 | Beam/outerslash/Beam Slash |

### 21. Energy and aura misc

| id | looks like | grid | light | files | typical use |
|---|---|---|---|---|---|
| `13992197350` | faint fractal outlines | 4x4 | D | 12 | Pulse/Fractal/BlackStuff |
| `16511790647` | realistic energy pulse | 8x8 | M | 9 | Realistic Energy Pulse |
| `12683695494` | aura cloud | 8x8 | M | 6 | AuraCloud/BlackAura/PurpleAura |
| `12401154143` | chromatic shards (coloured) | 8x8 | A | 6 | Chromatic Shards |

## Starter kit (33 ids)

These show up in 29% of the 6,148 effects and 44% of the pack files. Texture use is a long tail though (14.5k distinct
ids; the top 384 cover 37% of emitter layers, the top 1500 cover 63%), so treat this as the shared core.

- spark dot -> `16878181512` (D) | orbiting spec -> `9997556038` soft, `16171528032` sharp
- big soft glow -> `867619398` | flash behind a hit (small dot used at Size ~30) -> `16879789169`
- thin lens star -> `17391818367` | fat sparkle -> `17062454177`
- spark streak (VelocityParallel + Squash) -> `8030734851` | speed lines -> `18465146997`
- light rays from a point (random Rotation, additive) -> `1053548563`
- spinning wind ring -> `18527700887` | clean thin ring -> `18682826321`
- hairy shock ring -> `7417145436` | shock disc -> `9659008631` | soft starburst -> `8048608283`
- ring flipbook, thick to hairline -> `126034245450101` (4x4)
- crescent slash -> `13780268621` (4x4) | crescent ring burst -> `16026345008` (4x4)
- wind swirl -> `109440284900004` (4x4)
- soft smoke -> `11871320339` (4x4) | toon smoke -> `16867483883` (4x4) | dense billow -> `15415212938` (4x4)
- lingering dust cloud -> `7216851093`
- toon fire -> `11846119288` (4x4) | flame flick -> `15413764911` (4x4)
- lightning -> `13780092154` (4x4)
- toon impact pop -> `18140248952` (4x4) | impact flash frame -> `18118762332`
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
