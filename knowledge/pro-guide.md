# Pro guide: how professional Roblox VFX are built (read before you build)

Written from four sources: statistics over the open-source library (about 144,000 emitters, 56,000 of them in
slashes), a values-only study of professionally made effects (about 3,200 aura emitters; none of their files, names
or textures are in this plugin, only the general techniques in our own words), frame-by-frame study of footage from
popular games and anime, and our own tests in Studio. Every texture id below is from the open-source library or the
free VFX Studio catalogue (`kit/scripts/find_textures.py` searches both).
Labels: **[M]** measured from files or footage, **[S]** stated by a practitioner or doc, **[I]** inferred,
**[V]** verified in Studio. H = character height (5 studs). f = one frame at 60 fps (16.7 ms).
ParticleEmitter Size is the HALF-width (Size 4 draws 8 studs) [M]. The values are for every effect type; the slash,
impact and lightning recipes in section 3 are worked examples, not the only use.

How Roblox blends a sprite, in one line [V visually, formula I]:
`pixel = Brightness x Color x texture x alpha  +  background x (1 - alpha x (1 - LightEmission))`.
LE 1 = pure add (background kept). LE 0 = normal alpha. LE < 0 = the background is removed MORE than alpha says:
a black hole grows around the sprite. The coloured part is the same in all three. Everything in rules 1-3 follows.

---

## 1. The 12 rules that matter most

**1. Shine is Brightness, and first drafts are 5-10x too low.**
Values: body layers Br 5-15, hot strokes 15-30, needles and lines 25-55, flashes 15-100, tiny specks 10-10000.
Pro median 5 / p75 15 / p90 25; typical agent first drafts 2 / 3 / max 6 [M]. Good slashes: effect median Br 9, weak 1.1 [M].
Why: Brightness above ~3 drives the bright texels past display white: the core clips to white, the falloff stays
coloured, Bloom catches it. That is "shine". [V]

**2. One mid-tone colour + high Brightness gives the whole ramp (white core, hue rim). Do not tint white.**
Values: a saturated MID-value colour (a medium red, blue or amber such as #FF5A50, #3A50FF, #FFB060; not pastel), LE 0 or negative, Br 10-45.
Why: Color multiplies, so a pale colour clips everywhere (white blob) and a tinted white core cannot exist; a
mid-tone clips only where the texture is brightest. The strongest channel clips first, so red goes
white > yellow > orange > red and blue goes through cyan [M][V].

**3. LightEmission is three tools; LE 1 everywhere is the amateur default.**
- LE 1 (40% of pro emitters): light only. Invisible on white floors and bright sky. Use for faint veils, wind arcs,
  glows, ground light pools.
- LE 0 (42%): paints. Keeps the texture's dark pixels dark (smoky flame cores, dark-cored ink bolts). LE 0 + Br 0 =
  black where alpha is solid.
- LE < 0 (15% of emitters, 19 of 25 good slashes, values -1 to -40): the sprite cuts its own dark rim. With Br 0-0.3
  it is a darkening disc; with Br 10-35 it is saturated colour with a black outline that survives daylight.

**4. Every bright shape gets a dark partner (20 of 25 good slashes, and most premium auras).**
Pick by texture type [V]:
- Thin arc / ring / bolt (shape sits at the sprite's rim): same flipbook, black, **0.9x Size**, ZOffset +-0.02, same
  life and rotation. Leaves a bright outer edge with an ink inner band. A 1.4x copy becomes a detached second arc.
- Centred blob (aura wisp, smoke, glow): black copy **1.4x Size at ZOffset -1**, LE 0, Br 0-1 (0.9x does nothing).
- Either: same-size copy at **LE -5..-10, Br 0**, ZOffset -0.1 = a tight ink outline round the whole shape.
- Or no second emitter: put the bright layer itself at LE -5 (Br 20-40), or use a texture with the dark baked in
  (13806175054 "BlackInside", 16047618456 dark-cored lightning), or burn it to black with the ramp
  (#FFFFFF > #C0C1C2 > #000000).
Why: on a light background a bright additive stroke disappears (white on white). The ink is what you see.

**5. Flipbooks animate; motion does not.** 47% of pro emitters are flipbooks (4x4 mostly), 79% of those OneShot [M].
Pro median particle speed 0.05; first drafts fling theirs [M]. Values: Grid4x4 OneShot, life = the playback time (0.1-0.3 s
for strokes and bolts, 0.5-2 s for smoke and rings). Loop only for creatures and fluids (24-40 fps, StartRandom).
Why: OneShot spreads the sheet over the particle's life, so a 0.2 s life draws and erodes a slash in 12 f [V].

**6. Place sprites on planes; a tiny Speed only sets the facing.** VelocityPerpendicular 44% of slash emitters [M].
Values: Speed 0.001-0.03, SpreadAngle 0, EmissionDirection = the plane's normal, Drag 0. Speed 0 draws NOTHING on
VelocityPerpendicular [V]. Random planes (Spread 100-1000) give 3D cages, gyro rings and strobing bolts.

**7. Bursts for hits, Rate for loops, and know how many are alive.** Good slash crescents use Rate in 2% of layers,
weak ones in 52% [M]. Alive = Rate x Lifetime: 1 = strobe with gaps (37% empty frames), 2 with a triangle fade =
a "static" decal, 7.5 = pro median, 12 = soft stack / concentric rings, 80+ = dust.

**8. Short life for the main shape, long life for the debris.** Core stroke 0.15-0.4 s (median 0.30; weak 0.70) [M];
on screen 9-14 f for a normal hit [M footage]. Bolts 0.05 s. Flashes 0.04-0.12 s. Sparks 0.3-0.9 s. Smoke, ghost
arcs, ground marks 1-2 s at Transparency >= 0.75. Never hold an unchanged shape (the "average" tell: 44 frozen f).

**9. On at full size on the contact frame; flashes are a step.** Good slashes show >= 75% of the sweep on frame 1
[M]; 75% of good cores keep Size constant, 70% of weak ones grow from 0 [M]. A flash jumps in ONE frame, holds
3-6 f, decays 300-800 ms; a dark or empty beat comes before it [M].

**10. Few hot accents over a mid field; one dominant bright mass.** Only 4.7% of pro aura emitters reach Br >= 50;
their median life is 0.5 s and peak size 2 studs [M]. A median aura has ~11 unique layers and ~2 at Br >= 10.
Hot% (luma >= 235) is 1-4% of the frame for a normal hit, 10-14% for a heavy one [M].

**11. Soft volume comes from many faint copies, not one opaque sheet.** Wind arcs Br 0.1-1 at Transparency 0.7-0.9;
aura ground layers peak at ~10% opacity with 12 alive each; veils Br 0.001-0.5 at rate 40 [M]. One sheet at
Transparency 0 = "solid swirl".

**12. One hue family, values from ink to white; contrast with the ground beats size.** 1-2 adjacent hue families in
most premium effects; accents by value (white core, black back) [M]. In one popular game 3-4 H white swirls vanish on a
white map; in another, 1.5 H streaks with a dark edge read [M]. Check every version in daylight on a light floor.

---

## 2. Value cheat sheet

### Brightness tiers
| Role | Pro range | Typical first draft |
|---|---|---|
| Veil, wind arc, haze, linger smoke | 0.02-1 (with Transparency 0.7-0.9) [M] | 1-3, opaque |
| Dark twin / ink | 0 (or 1 with black colour) [M][V] | none |
| Aura body, glow | 3-8 (LE 1) [M] | 2 |
| Stroke core, sigil, ring | 10-30, median 14 [M] | 1.5-3 |
| Negative-LE colour layers | 15-25 (median 15) [M] | never used |
| Speed lines, needles, embers field | 25-55 [M] | 3 |
| Flash, hot body, glitter beam | 55-100 [M] | 4-6 |
| 1-2 px specks | 100 and far above (the smaller the speck, the higher) [M] | 3 |
Beams: median 5, p75 10, p90 20 [M].

### LightEmission modes
| LE | Br | Result | Use |
|---|---|---|---|
| 1 | 0.02-1 | faint light, sums by overlap | veils, wind, ground pool |
| 1 | 3-30 | glow; washes to white on light backgrounds [V] | cores at night, glows |
| 0 | 0 | black at the texture's alpha [V] | ink, dark twin, ground shadow (a very wide glow at a few % opacity) |
| 0 | 1-5 | flat paint; dim smoke curls from any texture | dark-value layers |
| 0 | 10-75 | white core, hue rim, dark texels stay dark [V] | strokes, bolts, flames with dark interiors |
| -1..-3 | 12-25 | saturated colour, thin dark edge | sparks (70% of good sparks, LE -3), smoke sheets |
| -5..-10 | 20-60 | colour + clear black outline [V] | cores in daylight, lightning (13013256540 LE -5 Br 60) |
| -25..-40 | 25-100 | hard black disc round even faint alpha [V] | hero crescents, needles |
| -1..-10 | 0-0.3 | darkening disc / outline | backing under an orb or sigil, ink twin |
Caution [V]: at LE -40 a SOFT texture turns into a hard black disc ~1.5x the visible glow. Use strong negative LE on
crisp textures; on soft glows stay at -1..-5.

### Life, rate, overlap
| Layer | Life (s) | Count |
|---|---|---|
| Strobe bolt | 0.05 | Rate 20 (1 alive) x 2-3 emitters |
| Flash / pop | 0.04-0.12 | Emit 1-2 |
| Speed lines | 0.1-0.2 | Emit 12-16 |
| Slash core | 0.15-0.4 | Emit 1 (2-3 only with +-4 deg jitter) |
| Wind / ghost arcs | 0.2-0.6 (ghosts to 1.1) | Emit 2-5 |
| Sparks | 0.3-0.9 | Emit 6-8 per design, 3-8 designs |
| Aura body wisp | 2-3 | Rate 10 per limb |
| Static decal (sigil) | 1 | Rate 2, triangle transparency 1 > 0 > 1 |
| Concentric rings | 1 (x TimeScale) | Rate 12, size linear 0 > S |
| Smoke / linger | 0.6-2 | Emit 4-9 or Rate 10 |
Near-equal rates that never sync (for example 17, 18.5, 20 and 23 per second) give random bursts and lulls with no script [M].

### Orientation tricks
| Want | Setup |
|---|---|
| Flat ground decal | VelocityPerpendicular, EmissionDirection Top, Spread 0, Speed 0.001-0.015; accel Y +3 wobbles it |
| Slash plane | VPerp, Speed 0.001-0.03, direction = plane normal; mirror with Top<>Bottom / Left<>Right |
| Gyro rings, tumbling cage, strobe bolts | VPerp, SpreadAngle 100-1000 (random plane per particle) |
| Streak / flame tongue pointing along flight | VelocityParallel + Rotation -90 (or +90), Squash 0 > 1-2 |
| Upright riser, sparks | FacingCameraWorldUp |
| Orbit with no path | off-centre texture + RotSpeed 250-600, life 0.5 |
| Panels on a globe | emitter on a PART, Shape Sphere, ShapeStyle Surface, VPerp |
| Body-shaped volume | emitter on each limb MeshPart, Shape Box, Volume (3 layers x 15 parts) |
| Silhouette of a huge aura | one big invisible Part (about 6 H wide, 3 H tall) as the spawn box |
Shape only works on a Part; on an Attachment emission is a point [M].

### Flipbooks
Grid4x4 71% of flipbooks, 8x8 for smoke/water, 2x2 for bolts [M]. OneShot ignores the fps value. A 4x4 over 0.2 s =
16 frames in 12 f. A "rotating" sheet turns the arc without RotSpeed: random start Rotation de-phases copies.
A field-of-dots sheet at Br 45 gives 50-80 embers from 6 particles.

### Squash
| Value | Result |
|---|---|
| const -3 on a VPerp card | long thin cut line |
| 0 > 2-5 (or const 1-3) on VPar | speed line stretching as it flies |
| 0 > 2.6 > 0 | needle that bulges mid-life |
| -2 > -3 | spark into a lens sliver |
| const 2 on two flat cards at Rotation +-50 | X flare on the floor |
| alternating +-1.3 with a double-pulse size | stuttering electric flash |
| 0.5 +- 0.6 random | flicker on a lens streak |
Used on 19-25% of emitters [M].

### Drag and Acceleration
| Motion | Values |
|---|---|
| Pop then hang (clings to body) | Speed 2-5, Drag 5, no accel (travels speed/drag studs) |
| Launch, brake, rise (flame tongues) | Speed 8-17, Spread 360, Drag 12, Accel Y +22, VPar |
| Floating sparks | Speed 4-12, Drag 5, Accel Y +10..15 |
| Hit sparks | Speed 15-140, Drag 10-55, gravity -8..-57, size 0 > 1 @10-20% > 0 |
| Terminal-velocity streaks | Speed 64-320, Drag 100-200, Accel 2000-8000 on one axis, life 0.1-0.2 |
| Finisher debris | rocks Speed 77-288, Drag 4, gravity -57; sparks 107-400, Drag 9.6, gravity -107 |
| Wind bend | one shared world Acceleration (up and to one side) on radial sparks |
Weak sparks: Drag 0-5, Br 3 = confetti [M].

### ZOffset
| Value | Use |
|---|---|
| 0.001 steps | order of coplanar layers (a ground stack of many layers, 0.001 apart) |
| +-0.02 | dark twin just behind or in front of its stroke [V] |
| -0.5 / -1 | ink smear, blob twin, smoke behind the body (body hides it = rim for free) |
| -2 / -4 | haze column, head flames kept off the face |
| +1 / +2 | eye star, bolts and glints in front of hair, coat and smoke |
| +8 | orb interior in front of everything |
Trap [V]: ZOffset -1 moves the sprite 1 stud from the camera; a wall or floor within 1 stud hides it.

### TimeScale
Scales rate, life, speed, rotation and flipbook together; alive count (Rate x Lifetime) is unchanged [V].
Tune at 1, then lower to slow a layer without thinning it. Pros mostly use 0.2-0.6, on about 15% of
emitters, mainly drifting layers [M]. TimeScale 0 freezes for capture [V]. For hit-stop set it to ~0.05.

### LockedToPart
Auras: 65% locked (core, sigil, ground). Leave drip, embers, flames, storm slashes unlocked so movement leaves a
wake [M]. Slash cards: locked.

### Size and transparency curve shapes
| Shape | Use |
|---|---|
| Size constant | slash cores (75% of good ones), sigils, bolts |
| Ease-out grow (12-20 keys: 0 > 25% at 6% > 72% at 22% > 100% at 50%) | rings, rays, shockwaves "snap open, settle" |
| Grow finished in the first 25% of life, then constant | strokes that open fast, then hold |
| Linear 0 > S with 12 alive | concentric ripple rings |
| Swell 0 > max at 10-20% > 0 | sparks |
| Shrink from full | pop flashes (16 > 0 in 0.06 s), glints (1.2 > 0 in 0.2 s) |
| One-key spike (small, 5x for ~2% of life at the middle, small again) | twinkle, pop |
| Double pulse 0 > 5 > 0 > 4.6 > 0 | electric flash |
| Stair steps (a big step, then small ones, every ~5% of life) | ring that throbs outward |
| Flat with one early dip + a very fast RotSpeed | breathing solid ring |
| Transparency flat 0, fade by size or flipbook | strokes, glints (most common string in every set) |
| Transparency 1 > 0 @0.2, 0 @0.6-0.7 > 1 (hold, then fade) | slash bodies |
| Triangle 1 > 0 @0.5 > 1 | decals, loops |
| Faint triangle 1 > 0.89 > 1 | stacked veils |
Size envelopes (a random range per key) are common on pro curves: one emitter looks like many [M].

---

## 3. Recipes

### 3a. Premium aura (idle loop on a character): the layer families
A premium aura is 9-35 unique layers; only about 2 reach Br >= 10 and about 5 sit at LE <= 0 [M]. Build it from these
families, each with its own rate so nothing syncs. Pick textures per role with the texture search.
| # | Family | Host | How (general ranges) |
|---|---|---|---|
| 1 | Body dark back | every limb, Box volume emitter | a soft wisp in black at LE 0, a little bigger than the glow and ~1 stud behind it (ZOffset -1): the body hides most of it, what shows is a rim. Life 2-3 s, Rate ~10, Speed ~0, slow random rotation, fade in and out, locked |
| 2 | Body glow | same | the same wisp at LE 1, Br 3-8, smaller, fade in and out, locked |
| 3 | Drip and embers | same | faint falling or rising bits at low rate, tiny embers Br 10-20; UNLOCKED so movement leaves a wake |
| 4 | Tongues / smoke | limbs | 2-4 flipbook sheets pointing along their flight (VelocityParallel, Rotation -90), launch-brake-rise motion (Speed 2-6, Drag ~5), LE -1..-5 at Br 15-25, ramp white > hue > dark > black, 3-4 sizes, a bigger black twin behind |
| 5 | Core rays + glow | root | soft rays easing out at two sizes, life ~1 s, Rate 2; a glow at LE 1 Br 1-5 |
| 6 | Crackle | torso | a 4x4 bolt sheet, OneShot, life 0.1-0.5, Rate 5-25, negative LE at Br 40-60 |
| 7 | Ground dark | under the feet | a flat darkening disc (negative LE, Br ~0.3), 1-1.5 H wide |
| 8 | Ground mark | same | one flat decal-like sprite 2.5-3.5 H wide: life 1, Rate 2, triangle transparency, fixed rotation, Br 10+ |
| 9 | Ripple rings | same | a ring sheet growing linearly with ~12 alive, very faint, slowed with TimeScale 0.2-0.5 |
| 10 | Pulse ring | same | a fast-spinning ring, life 0.5-1, Rate 2-3, a dip in its size curve so it breathes |
| 11 | Sky halo | 1-1.5 H above the head | smaller copies of 8-10 |
| 12 | Specks | limbs / root | Br 5-10, Size 0.2-0.5 or a spike curve, slow (TimeScale 0.5), Rate 20-40, life ~2 |
| 13 | Hot accent | head or hand | 1-2 layers only: Br 50-100, life <= 0.5, Size <= 2 (for example two crossed thin stars, shrinking, in front of everything) |
| 14 | Side mass | a prop or offset part | one tall accent on ONE side: asymmetry reads as designed |
| 15 | Light | torso | a PointLight Br 1-2, Range 8-10, or a faint particle pool on the floor |
Rhythm: unsynced rates give slow overlapping cycles; a pulse = one burst plus a ~1 s window of extra emission, where
very short-lived layers cut hard and 0.5-1 s layers form the tail [M]. Keep the face clear (negative ZOffset on head
layers).

### 3b. Slash, combo, finisher (attachment at chest height, 1-2 studs ahead; all cards VPerp, Speed 0.001, locked)
One light hit (9 emitters; S = core Size 10-12 = 2 H; heavy 14-22; never under 9 without bigger wind):
| Layer | Texture | LE / Br | Life | Size | Other | Emit @f |
|---|---|---|---|---|---|---|
| Core A | 13780268621 4x4 OneShot | 0 / 25 | 0.17 | const S (or grow in first 25%) | ramp #FFF > #C0C1C2 > #000, fixed Rotation r, RotSpeed 0..-900 | 1 @0 |
| Core B | 134736132144954 | -1..-5 / 20 | 0.2 | 1.15 S | Rotation r-25, RotSpeed -600 | 1 @0 |
| Dark twin | same as A, black | 0 / 0 | 0.17 | 0.9 S | Z +-0.02 | 1 @0 |
| Colour arc | 15124806555 | -0.5 / 25 | 0.2 | 0 > 0.9 S | accent hue, RotSpeed -300..-400 | 2 @0 |
| Wind x2 | 78592280941627, 12018086505 | 1 / 1 | 0.2-0.45 | 0 > 1.3-1.6 S | Transp 0.75 > 1, Spread 10-15 | 3 each @1 |
| Pop | 16892231149 FacingCamera | 0.5 / 15 | 0.06 | 1.5 S > 0 | Z +2, at contact | 1 @1 |
| Lines | 117897352753929 VPar | -1 / 40 | 0.1 | 1.2 > 0, Squash 0 > 2 | Speed 5-40, Drag 9 | 12 @1 |
| Sparks | 17391818367 | -3 / 20 | 0.45-0.8 | 0 > 1.1 @0.2 > 0 | Speed 10-50, Drag 15, gravity -9 | 6 @1 |
| Specks | 15419166595 (off-centre) | -3 / 20 | 0.45-1 | 0 > 0.9 > 0 | RotSpeed +-225, Drag 15 | 6 @1 |
Combo: hit 2 = mirrored plane, r + 90-180 deg; hit 3 Sizes x1.2-1.4; contacts at f8 / f26 / f44-50 (18 f, 18-24 f).
In-effect flurries 0.1-0.15 s apart. A spin = one thin stroke at RotSpeed 1250-1800 for 0.2 s with wide copies at
Transparency 0.9-0.98, never a held ring.
Finisher: wind-up 14 f with a 4-point glint f6-10 at the blade tip; 1-2 empty/dark f; contact f17: heavy stroke set
at S 20-22 with core Br 60-75 on a dark mid-tone, 2-3 strokes offset 10-25 deg, ink behind (9181472195, 1.2x, Z -0.5,
half the spin); line cut 13780268621 Squash -3 Size 26 life 0.14 Br 25 + LE -1 twin; flash 10556525755 Br 100 Size
34 > 0 life 0.16; star 17062416111 0 > 32 > 0 in 0.1 s; shockwave 8505111714 0 > 30 Transp 0.65; shards VPar 7 > 0
x10; rocks; ground crack 13781849388 Squash 0 > 5.4 life 0.9 + Br 0 copy; smoke 0 > 23 at Br 0.1 for 0.5-1.8 s;
faint crescents 0 > 39 at Transp 0.82. At most 2 full-frame flashes.

**Mesh slashes** ([I], details in `mesh-slash.md`; kit block `fx:MeshSlash`): the slashes that shine in daylight and
sit on the blade are an invisible Part + SpecialMesh + Decal with Color3 above 1 (e.g. (2, 7, 8.5)), stacked: a band
with height, a body, a black copy at 0.9x and see-through, a white-hot crescent on top. They grow 2-3x, turn with the
swing, thin, and fade Cubic Out in 0.08-0.25 s. Fit them to the sampled blade path; never bend the arms to an effect.
Sprites stay better for eroding, stylised or camera-close strokes.

**Animation checks** (checklist A1-A4): no T-pose between hits (pass through a guard), the off hand on the hilt for
two-handed moves, arms never through the body, and a side pose sheet every 0.1 s with the effects off before any
effect is judged.

### 3c. Impact / flash
| f | Layer | Values |
|---|---|---|
| -6..-2 | Anticipation | glow shrinks, optional glint 4-5 f; then 1-2 near-empty frames |
| 0 | Flash core | 1-2 sprites, Br 50-100, LE 0.4 or negative, life 0.06-0.16, shrink from 1.5-3 H, or double pulse with Squash +-1.3 |
| 0 | Needle | Star99 10598374841, Size 0 > 22 in 0.05 s, Squash 1, at the weapon's angle |
| 0 | Dark back | black copy LE 0 Br 0 (blob: 1.4x, Z -1) or black claw card Size 19 > 10, life 0.05-0.09 |
| 0-1 | Ring | VPerp 4x4 ring OneShot, ease-out 0 > 14-30, life 0.45-0.85, Transp 0.65-0.75, TimeScale 0.35 for a slow one |
| 1 | Streaks | FCWU / VPar, Speed 64-320, Drag 100-200 or Speed 20-75 Drag 10, life 0.1-0.2, Emit 20-50 |
| 1 | Sparks + shards | 3-8 designs, Br 14-25, LE -3, Drag 15-55; shard spray Speed 14-53, Drag 15, Emit 25 |
| 2-3 | Smoke | 4 sheets, VPar Rot -90, Emit 9, Speed 6-41, Drag 5-10, ramp to black at LE -1/-5 Br 15-25 |
| 0-12 | Light | PointLight Br 3-10, Range 10-14, 0.1-0.2 s; ground pool sprite, same life |
Directional: every part inherits the hit direction (Spread 10-25 along the tangent), else it reads as a bullet hit.

### 3d. Lightning strike (a composite: values [M] per layer from several studied effects, the stack [I])
| f | Layer | Values |
|---|---|---|
| 0-20 | Wind-up crackle on the blade | two short bolt-tangle sheets (2x2; search "lightning"), mid-tone hue, LE 0 Br 10, Size 1.5-3, life 0.05, Rate 20 each, VPerp random plane, Z +2; ink bolts 16047618456 4x4 Size 1.6x |
| 6-10 | Glint | 4-point star at the tip, Size 1.2 > 0, 4-5 f |
| 16-17 | Dark beat | stop emitting; optional 1 f darkening (underglow Br 0) |
| 17 | Leader | thin bolt column top-down in 1-2 f, Br 40-60, LE -5 |
| 18 | Main bolt | 2-3 stacked bolt sprites or one Beam (Segments 20+, Width 3-5), column 6-10 H tall, Br 40-100, LE 0 or -5 on #3fd0ff / #1a6dff so the core clips white; black twin LE -5..-10 Br 0 |
| 18-30 | Restrike strobe | redraw the bolt every 3 f (life 0.05, new rotation/plane), 3-4 times, each dimmer; fill may alternate two hues every 4-8 f |
| 18 | Screen/ground flash | step to white in 1 f, hold 3-4 f, decay 20-30 f; ground flash Br 100, Size 18-34 > 0, life 0.16 |
| 18 | Impact set | 3c at 2-3x size: ring 0 > 30, X floor flare (two cards Rot +-50, Squash 2, Size 7 > 0) |
| 19-40 | Ground arcs | bolts VPerp flat on the floor, Spread 5, Size 4-8, life 0.05, Rate 20 for 0.3 s |
| 18-110 | Scorch + cracks | dark disc LE -1 Br 0.3 Size 6-8; crack 13781849388 Squash 0 > 5.4, LE 1 Br 10 cooling to a Br 0 copy over 1-2 s |
| 20-110 | Tail | white low-Br smoke (Br 0.1-1, life 0.5-1, Speed 5 up, Drag 5), sparks Drag 15-55, embers TimeScale 0.5 |
The glow should live in the textures and the clipped core, not in Bloom.

---

## 4. Timing and feel (60 fps frames)

| Beat | Light hit | Heavy / finisher |
|---|---|---|
| Wind-up pose | 5 f | 14 f, glint f6-10 |
| Draw-on | arc >= 75-80% on frame 1, complete in 2-7 f | same; 1-2 empty f before |
| Full-bright hold | 6-8 f | 12-15 f |
| Fade (tail first, head last) | 3-6 f | 9-20 f |
| Total stroke | 9-14 f | 25-40 f |
| Something changes | every 2-4 f | every 2-4 f |
| Hit-stop (pose hold; pause clocks, TimeScale ~0.05) | 3 f | 5 f medium, 8-10 f finisher |
| Flash | none (thin rim 2 f on hit 3) | 1 f step, hold 3-6 f, decay 300-800 ms |
| Impact frame (inverted / mono) | never | 4-6 f after the flash; battlegrounds-style cinematics 13-30 f |
| Chromatic split | - | 10-20 f |
| Camera shake | 0.1 stud 6 f (Bump: magnitude 1-1.5, roughness 4, fadeOut 0.3) | 0.5 stud 15 f (magnitude 3-5, roughness 10, fadeOut 0.8-1.2), FOV -4..-10 for 3-4 f |
| Combo gap | 18-19 f (game M1 26-30 f) | gap before the finisher +40% (24-27 f) |
| Debris outlives the arc | sparks 300-400 ms | flakes 700 ms, ground ring 800+ ms, scar 1-2 s |
Stagger secondary layers 1-2 f; give every emitter a Lifetime range. Alternate direction each hit; escalate size
and hot area (2% > 4% > 10-14% of the frame). Shake values are recommendations, not measured [I].

---

## 5. Rater complaints > causes > fixes

| Complaint | Cause | Fix |
|---|---|---|
| "Matte, no shine" | Br 1-3, LE 1 everywhere, pale colours, no dark next to the bright | rules 1-4: mid-tone colour at Br 10-30 on strokes, 25-100 on 1-3 tiny accents, LE 0 / negative, ink partner, 4-point glint 4-5 f, chromatic stars (17062416111) |
| "Solid disk" (slash) | closed ring held 0.4 s+, random Rotation with Emit >= 3, grow-from-0, Rate-driven, additive stack clipping the whole shape, no dark | open arc 120-220 deg, fixed Rotation, Emit 1, life 0.15-0.3, constant Size + OneShot flipbook, 0.9x black twin, wind at Transp 0.75+ |
| "Solid swirls" (aura) | one opaque sheet per swirl, one speed | 12 faint copies (peak 10% opacity), thin bright filaments at Br 10+ over them, dark back, 2-3 TimeScales, limb-volume emitters |
| "Pencil beam" | constant width, hard edge, even helix | Width0 0 > Width1, 3-width outline sandwich (black 1.44w Z -0.8, mid 1.0w, hot 0.8w Z +0.1), 2-3 textures at different TextureLength / Speed, root hidden by transparency, soft puffs and VPar streaks along it |
| "Okay, nothing crazy" | no contrast in time | section 4: dark beat, 1 f step flash, hit-stop, shake, one frame that is the biggest and brightest, fast falloff, long quiet tail |
| Vanishes in daylight | additive only | LE 0 / negative layers + ink; test on a white wall (section 6) |
| "Stickers" | hard opaque shape held too long | flash <= 0.1 s, rings thin at Transp 0.65+, shapes that change every 2-4 f |
| Confetti sparks | Drag 0-5, Br 3, round dots | Drag 15-55, Br 14-25, LE -3, swell-then-shrink, stretched shapes |
| World tint ("pink paint") | ColorCorrection / big lights | local pool only: PointLight Range 8-14 or a ground sprite |
| Hero swallowed by glare | accents bigger than the hero | hot accents <= 2 studs, <= 0.5 s; one dominant mass |

---

## 6. Verified in Studio (blank baseplate, daylight ClockTime 14.5, Bloom on, a striped white / grey / dark wall)

1. **LightEmission x Brightness** (a soft glow texture, one mid-tone red; LE 1, 0, -1, -5, -40 against Br 0, 0.3, 1,
   10, 35).
   - LE 1 + Br 0: nothing. LE 0 + Br 0: black, but only as strong as the texture's alpha (a soft dot).
   - Negative LE + Br 0: a black disc that grows with |LE|; at -40 it is hard-edged and ~1.5x the visible glow.
   - Br 10-35 at any LE: white core, pink then red rim (channel clipping). With LE 0 this happens without washing
     the background; with LE -5 / -40 the same core sits in a black ring (most saturated, reads on white).
   - Negative LE at low Br (0.3-1): dark disc with a faint red centre = the "darkening backing".
2. **Dark twin** (crescent 13780268621).
   - Bright alone: disappears on the white stripes.
   - 1.4x black behind (Z -1): a separate, displaced black arc (the arc sits at the sprite rim, so scale moves it).
   - 0.9x black at Z -0.02 and +0.02: ink inner band, bright outer edge; in front is slightly cleaner. Reads best.
   - Same size, LE -10 Br 0, Z -0.1: full black outline, saturated body. One emitter at LE -5 Br 20: same idea.
   - A Z -1 twin vanishes when a wall is 1 stud behind it (the ZOffset trap).
   - Blob (a soft wisp): alone = a pale wash; 1.4x black at Z -1 = full colour with a soft dark halo (Br 0 and Br 1
     look the same when the colour is black); 0.9x = no help; same-size LE -5 Br 0 = deepest colour, crisp dark edge.
3. **TimeScale**: Rate 4, life 2, Speed 2 at TimeScale 1 and 0.25 both show 8 particles at the same spacing. Rate,
   speed and life all scale; density is kept. RotSpeed scales too.
4. **Flipbook crescent on VelocityPerpendicular** (life 0.2, Speed 0.01, frozen at 15 / 35 / 50 / 70 / 90% of life):
   thick short arc > full sweep > thin > hairline. A crisp slash with a tail-first fade from one emitter.
   **Speed 0 on VPerp draws nothing**; Speed 0 on FacingCamera is fine; Size 0 > S looks half-size at mid-life
   (weak); Speed 10 drifts off the plane.
5. **Bolt clipping** (a 2x2 bolt sheet, #3fd0ff): LE 1 Br 10 and LE 0 Br 10 = thin cyan line; LE 0 Br 40 = white core
   with cyan glow; LE -5 Br 40 = the same with a dark outline (best on white); #1a6dff at LE 0 Br 40 = blue with a
   white core.
6. Practical: particles emitted before a camera jump may not be drawn; move the camera, then emit. The same
   crescent looks far glowier close up (Bloom works in screen space): judge shine at the player's distance.

---

## 7. Open questions
- The blend formula is fitted by eye; exact maths, and whether Bloom threshold changes with graphics level.
- Does a strongly negative LE layer darken OTHER particles behind it or only the world? (sorting between emitters)
- Draw order of emitters at equal ZOffset (seemed stable, not tested).
- How these read at graphics level 1-3 and on phones (Bloom off, particle count cut).
- Best single route for a daylight white core: LE 0 Br 40 + twin, or one LE -5 layer? Compare in motion.
- Beam equivalents: does Beam Brightness clip the same way; curved beams at low quality (stated to flatten).
- `Decal.UVOffset` soulercoaster slash on a SpecialMesh: untested.
- Real hit-stop length in top Roblox games (no clip showed a world freeze; numbers come from pose holds).
- Lightning strike stack (3d) is a composite; no pro strike was mapped instance by instance yet.

## 8. Lessons from directed builds (they hold for every effect type)
- **Camera-independent.** Build every plane, path and landing spot in the caster's space (look / right / up vectors).
  Never tilt, lengthen or brighten something toward the review camera to make it read: from any other angle it looks
  skewed, and players see it from every angle. One build's finisher was turned 35 degrees toward the test camera and
  landed forward-right; the person rating it saw it at once. Readability comes from pose (the limb or weapon path
  outside the body silhouette), size, brightness and contrast. Check every version from above and from a front 3/4
  view as well as from behind and from the side.
- **Look every round, from five views.** Versions reported from one camera needed another round for something a
  bird's-eye or side frame showed at once. Dense consecutive stills around each hit show what a single frame hides:
  detached pieces, a stroke that is thick for one frame only, dead time, an impact frame that is too short.
- **A second pair of eyes with one ranked list.** A director that only watches and writes at most 8 ranked fixes per
  round raised scores each round (6.0 > 6.8 in the first test); drip-fed or unranked notes did not.
- **AI reviewers are noisy and harsher than people.** The same unchanged beat moved up to 1.5 points between two
  blind AI reviews, and the person rated about 1.2 above them. Trust the person, then the checklist, then the score.
- **The character sells the effect.** A stiff or tangled pose lowers the whole result: pose first (anticipation,
  swing, held follow-through), then effects read from the pose.
- **Write the reason next to the value.** Every layer gets one line: what it does for the read, which values carry it
  and which are free. Builders then change values for a reason, and a director can tell a load-bearing value from a
  taste value (VFXKit `why`, `fx:Layers()`; `why` on VFXTimeline layers).
- **Additive layers share one light budget.** LE > 0 layers add to each other AND to the background: on a light
  floor or sky a stack of soft glows clips to a white disc long before each layer looks bright (measured: 12 glows at
  a summed Br of ~2 still white against the sky). Normalise stacks with one per-effect gain (VFXKit does it at Build),
  and above all keep the count of overlapping additive layers low: the body is LE 0 with a dark partner.
- **Flowing surfaces are scrolling beam stacks, wrapped in 3D.** Liquid, fire, energy and wind sheets: several Beams
  between the same attachments, each with its own TextureSpeed (spread about 0.3-2.5) and TextureLength (0.8-3.5) so
  the pattern never repeats visibly, a dark low-value body layer under thin bright mask layers, and a flat layer where
  the sheet meets the ground. Never one flat sheet: rows of overlapping panels for a wall, 6-8 panels round a ring for
  a pillar (VFXKit `fx:Curtain`).
- **Know which textures you can tint.** White / grey art is a mask: Color makes it any hue. Coloured art is baked:
  Color only multiplies it (blue x orange = dark mud). Recolour masks; leave baked art untinted or pick a mask twin.
- **Every hit leaves something behind.** For 1-2 s after an impact: faint dust rolling outward along the ground,
  a few tiny glints skidding low, a cooling mark, residual arcs for energy hits. Low and radial, never a rising dome;
  faint (Transparency >= 0.75 for haze). The same holds for the end of any effect: a designed residue, never a cut.