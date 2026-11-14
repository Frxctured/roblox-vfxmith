# VFX patterns seen across all analysed videos

Source folders are named in brackets. Claims are Seen in the videos unless marked Inferred. Engine limits: `knowledge/gotchas.md` of the VFX pipeline skill (optionally also the LihFolk vault and its `lihfolk-vfx` skill). "The vault" below means the LihFolk Vault V2: an optional extra, never required.

## 1. Three-tone rule: bright core, saturated body, BLACK ink
Every effect that looks professional has a white/pale core, one saturated hue, and a dark layer (black ink band, black bolts between bright ones, dark core gap in a beam). [iaido: black band inside yellow ring; katana: dark-core lightning; purple: ink rings/bolts; cyber: dark tetromino interiors with neon edges; chisa: black ink needles]
- Roblox: dark layer = Beam/Part with LightEmission 0; bright layer = LightEmission 1 on top.

## 2. Pops, not fades
Hits appear at FULL size on frame 1 (often 1.2-1.4x, settling in 2 frames) and die in 3-8 frames with ease-out. Only auras, debris and shards linger. [iaido ring 0.23 s; dual-aura bursts; katana starburst 3 frames; purple splats]
- 3-frame value ramp per hit: white (1 frame) -> lavender/colour (1) -> dark navy (1-2) -> gone. Swap colours by elapsed time, don't tween. [purple]
- High Drag (10-16) on VelocityParallel particles makes bursts shoot out and STOP DEAD, forming star shapes. [dual-aura]

## 3. Impact frames
1-2 rendered frames of white-out / black-white inversion / flat-colour silhouette on a big hit. Tools: Highlight fill swap on the target, ColorCorrectionEffect (Brightness +-0.5..0.8, Contrast 1, Saturation -1), big white sprite behind the target. [dual-aura, katana, chisa, purple]
- The videos use up to 10-12 flips in <1 s = photosensitivity risk. ALWAYS cap at 2 per hit, >= 1/30 s each, never > 3 flashes/s, honour `GuiService.ReducedMotionEnabled` + an in-game setting, give ColorCorrection one owner.

## 4. Silhouette + additive colour
Near-black characters (#04050b) on a dark navy/grey world make every additive layer read at full value with few particles. Build the world grey/dark with materials and sky, NOT with a grade (a global desaturate also kills the effect colours). [dual-aura, katana, purple]
- Darken the world via Lighting (ClockTime 0, Brightness 0, ambient black) in ~0.1 s and keep effects Neon / LightInfluence 0 so they stay bright. [purple]

## 5. Lightning builder
Jagged polyline of straight Beams (Segments 1, FaceCamera), body + white/dark core as two beams on the same Attachment chain, ends pinned, reshape every 0.033-0.05 s, remove after 0.07-0.13 s without fade. One builder serves limbs, sky bolts, orb filaments, ink bolts. Beam count explodes (12 bolts x 8 segments = 192 beams): pool and cap. [katana, purple]

## 6. Aura rig
One ParticleEmitter per body part ON THE PART (not Attachment): Shape Box, ShapeStyle Surface, LockedToPart, ZOffset -1 (behind body so the silhouette stays black), LightEmission 1. Faction contrast: hero additive blue-white, enemy crimson LightEmission 0. Optional outline-only Highlight. [dual-aura]

## 7. World-space UI as VFX (no textures)
SurfaceGui on an invisible Part (FixedSize canvas, LightInfluence 0, Brightness 2-3), dark fill + bright UIStroke, pop with Size X Back Out 0.12 s then flicker Enabled 3-5x. BillboardGui lens flare/reticle from Frames (UIGradient 1-0-1 streak, UICorner(1,0) ring). Neon cubes + one Highlight (FillTransparency 1) = glowing outline blocks. [cyber, chisa]

## 8. Camera and cut rhythm
Hard cuts and whip frames replace camera shake (shake is usually <= 3% of view height). Scriptable camera shot table with drift, roll up to +-22 deg, FOV 38 (macro) to 95 (tunnels), Dutch angle on finales. Hide cuts with dolly-to-dark, ink wipes, smears, whiteouts. Rhythm: slow shots -> dense strobe -> one big wash -> long calm with lingering marks. Restore camera on end/death. [chisa, cyber, dual-aura]

## 9. Colour meaning and alternation
One dominant hue per shot, white only in cores. Warm/cold alternation shot to shot (crimson/orange vs pink/lilac/blue) so the eye never adapts. System=blue/cyan, glitch=violet, threat=red, physical payoff=orange. [chisa, cyber]

## 10. Escalation structure
Each tier adds ONE new big shape (river, pillar, dome) instead of more copies; every move ends on one clear payoff beat; splat size 1.5x body -> third of screen -> full screen. Anticipation ~0.4 s -> flash -> beat -> payoff -> cool-down with small echoes (chips, glint). [purple, iaido]

## 11. Lingering aftermath
Debris hang (Quint Out throw 0.15-0.35 s, hold ~0.6 s, then Quad In drop + fade), thin crescents/streaks left in the air, shards and orbs drifting ~1 s, small glint at hilt. [katana, chisa, iaido, dual-aura]

## Engine pitfalls collected (verify in Studio once)
- `CylinderHandleAdornment` flat ring: height along local Z, rotate 90 deg about X; where `Angle` starts and the InnerRadius behaviour UNVERIFIED.
- Beam `CurveSize1` sign (flip if streaks bulge inward); Beam ZOffset core-over-glow sorting UNVERIFIED.
- Studio-inserted emitters default LightInfluence 1: set 0 in code.
- Hairline beams fatten under bloom: low Brightness (1-2), width <= 0.15.
- Additive over additive washes to white: keep one non-additive layer per stack.
- One Highlight per object: reuse/restore existing ones.
- 360 deg rings only for explicit spin/AoE moves (vault frontal rule); else clamp to ~200 deg arc.
- Red splatter reads as blood: stylise (dark red/black) for content ratings.
- Emit() ignores graphics quality: thin counts yourself; Rate cap 400/s (100 mobile).
- Several systems writing one ColorCorrectionEffect fight: one owner.

## 12. Black hole / accretion disc (from blackhole-reference)
Pure-black unlit sphere with only a warm lower rim; wide additive disc of untextured Beam streaks (arc handle = 4/3*tan(theta/4)*r, Transparency sequence = comet shape, FaceCamera on) on rings rotating one direction with speed ~ 1/radius (~1.1 rad/s inner, ~0.46 outer); a camera-facing lensing arch (3 thin half-ring bands at 1.06/1.17/1.29 R, re-aimed at the camera each frame) fakes gravitational lensing; warm core + cool blue haze rim; sparse 4-point twinkles popped at full size. Less is more: no lightning/jets needed to read as a black hole.

## 13. Process (from building VoidRend with the pipeline, 2026-11-13)
Build effects with the skill the plugin: data spec -> Studio capture -> compare -> 3 blind
reviewers -> merge -> repeat. Lessons: fix framing and capture bugs before trusting reviews; reviewers report SCREEN
colours (texture x Color x opacity, Neon hotter and more saturated), so convert before authoring; steer layers that
oscillate (linger) by the coverage curve, not words; a world grade with high Contrast clips dark violets to pure blue
(keep ~0.25 on dark effects). The worked run (9 versions, 4 review rounds, 4.5 -> 6.2) is in its kit/examples/VoidRend/log.

## 14. What the open-source library teaches (11 category studies over the ~1,900-effect catalogue, 2026-11-14)
Category notes and recipes: `os-library/<category>.md` + `<category>_recipe.luau`. Rules seen in most categories:
1. **Fire everything at t = 0; lifetimes make the timeline.** Flash 0.015-0.16 s (one frame = 0.0153 s), core
   0.05-0.2, rings 0.1-1.1, smoke 0.35-2.5 (about 2.5x the ring's life), ground marks 0.5-2.5 (up to 7). Visible length
   0.5-2.5 s. Staging comes from Size-from-0 curves, flipbooks and fade-ins, not from delays. [impact, slash, explosion]
2. **Brightness 0 = black ink from any texture and colour** (LightInfluence 0). Give every bright shape a black twin:
   same texture and motion, 1.0-1.6x the size, ZOffset 0.01-0.2 lower. Effects without ink read as white blobs.
   [aura, darkportal, explosion, impact, lightning, slash]
3. **Opaque glowing layers beat additive stacks.** 44% of all designs use LightEmission <= 0. LE 0 with Brightness 5-75
   keeps colours saturated and lets layers cover each other instead of summing to white. Brightness >= 1 / (smallest
   colour channel) whitens the bright texels and keeps the fringe's hue: one layer is both core and body (dark red
   #721A00 at Br 55-75 = molten core; near-black #13100D at LE 1 Br 150 = white-hot with a warm fringe).
   [slash, impact, projectile, beam, misc, ice]
4. **Negative LightEmission with high Brightness** (-1 to -10, Br 10-150) gives crisp, solid sprites and dark outline
   twins (x1.07 size, ZOffset -0.5). Undocumented: keep a fallback. [aura, darkportal, impact, explosion]
5. **Fade by colour, not transparency.** Colour ramps ending at #000000 fade additive layers cleanly and cool
   normal-blend layers to ink; one shared colour ramp on every layer ties an effect into one look (red -> violet ->
   lavender in 0.35 s with no tracks). [explosion, lightning, fire, misc]
6. **Pop, then settle.** Flashes appear at full size and shrink to 0 (55% of the library's flash layers); rings grow
   from 0 and reach 25-50% of their size by 10% of life; transparency is already 0.4-0.8 by then. [explosion, impact]
7. **Burst and stop: travel ~= Speed / Drag.** Sparks 66-350 studs/s with Drag 5-30; snaps of 500-1000 studs/s with
   Drag ~76 cover 6-13 studs in two frames. [impact, explosion, projectile, beam, lightning]
8. **Flat rings: VelocityPerpendicular + Speed ~0.005.** SpreadAngle 0-15 = flat ring, 3333 = a shell of random tilts
   (sphere); spin with RotSpeed in ONE direction per layer (random signs only drift). [explosion, darkportal, ice]
9. **Size everything from one number** (D = the main ring's peak size): glow 0.8-1.9 D, flames 0.25-0.5, smoke
   0.3-0.75, cracks 0.5-0.7, sparks 0.04-0.13. **Brightness by screen area**: veils 0.05-0.16, rings 1-3, sparks
   15-35, embers 50-200; rings 3R or wider sit at transparency 0.64-0.97. [explosion, darkportal]
10. **One particle, several events**: multi-key Size curves (0 -> 14 -> 0 -> 8 -> 0 -> 16 -> 0) pulse or blink with no
    script; Squash keys make streaks (0 -> 3..10), liquid pops and electric filaments. [aura, lightning, projectile]
11. **Mistakes that recur**: thousands of particles per second (Rate above the 400/s cap), stacked additive cards
    washing to white and showing card edges, layers held at transparency 0.85-0.98 (invisible), EmitCount below 1
    (emits nothing), lifetimes shorter than a frame, no ink layer, no white core.

## 15. Lessons from the blind tests (2026-11-14), for every effect type
Two blind tests had an agent with this plugin and one without build "a cool light beam with an explosion", scored by
blind reviewers on frames captured in the same daylight scene. Test 1 (full loop): 7.5 vs 7.0 for the plugin. Test 2
(quick mode: one review round, no second check): 5.5 vs 7.5 against it. The request was a beam, but what decided the
scores holds for any effect:
1. **Daylight decides.** Most games are daylight: tune on the default baseplate (`C.stage("day")`) or the user's map as
   much as on the void stage. Dark layers that vanish on black read as dirt in daylight: **ink smoke cools to warm
   dark grey and thins out** (fade by transparency from about half its life) instead of ending pure black (a solid
   black puff floating mid-air reads as a hole); **a dark band or ink layer stays thin and warm** (amber-brown, about
   a third of the body's width), or it reads as a grey-brown smear. Pure-black twins work at small sizes and short
   lives (sparks, a 1-2 frame flash twin).
2. **One hero shape per beat; cap the peak, not just the total.** At each beat one big shape leads (the fireball, the
   crescent, the ring, the pillar, the portal mouth); streaks, needles and shards support it. Test 1's blast was called
   cluttered where `VFXTimeline.check` counted 58 bright-white elongated particles (white streaks and needles:
   VelocityParallel / FacingCameraWorldUp / Squash with a near-white colour) over a ~170-particle peak. Keep
   bright-white elongated particles at a beat to about 25 or fewer (most recipes peak at 0-23), unless the streaks ARE
   the hero shape (lightning bolts, speed lines of a dash), and no more than 2-3 white layers overlapping at once.
3. **The payoff is the biggest beat, sized for the request.** Decide size and timing in the brief
   (`knowledge/design-brief.md`) before opening a recipe: recipes are sized for an average library effect. In test 2
   the plugin's payoff (the blast) was about 1/6 of the screen under a sky-high beam and was gone in under 2 s; the
   baseline's filled about a third of the screen and lingered 3 s, and won clearly. A signature move's payoff fills
   ~1/3 of the screen at gameplay distance and leaves an aftermath for 1-3 s; a basic hit stays about a character's size.
4. **Repeated beats differ and escalate.** Two flashes, slashes, rings or pulses in one effect get different shapes and
   the later one is bigger and longer (test 1: the same starburst for the beam's slam and the blast made the payoff
   feel like a repeat). The anticipation must be long enough to read (at least ~0.2 s, 0.5-1.5 s for a big move):
   test 2's 0.27 s charge with a faint rune "almost missing".
5. **Textures carry traps.** A coloured texture tinted to another hue goes muddy (a blue rune tinted gold turned
   olive), a texture on a black or faint card shows its square at LightEmission < 1, a multi-line texture used as one
   streak clumps into a comb, low-resolution art drawn big is stair-stepped, and a swapped texture that fills more of
   its card changes the on-screen size. `knowledge/texture-vocab.md` lists measured traits; check any other id with
   `kit/scripts/texture_traits.py <id>`.
6. **Particle Size is a half-width** (Size N = 2N studs across; Beam widths and part sizes are full widths):
   `knowledge/gotchas.md`.
7. **One rendering style per effect, the one the user wants.** Match the game's look: a toon style (flat shapes, dark
   outlines, hard cel steps) or a soft glowing one (additive glows, gradients, soft smoke). Both are fine; mixing them is
   not, unless the user asks for it. In test 2 a flat orange star with a black outline, added to a soft glowing beam
   effect, was called "a sticker that clashes" by all 3 reviewers. When a review says a dark layer "reads as a grey
   smudge", fix it in the effect's own style (a crisper soft ink layer in a glowing effect), not by switching style
   for one beat. No style given: say which you chose and keep to it.
8. **Fire and explosions need body and a slow cool** (the category case from test 1; explosion.md has the numbers).
   The blast went white -> flat red puffs -> a floating black ball in under 0.5 s. Reach orange by ~0.2 s, as the
   library does, then give the body time (fire puffs and flame tongues living ~0.6-0.9 s, spending the extra time in
   orange -> red -> ember); holding yellow-hot longer, or starting white, clipped to a shapeless white blob in daylight.

Test 3 (a void rift: a boss ultimate held open, peak at the END, dark effect in daylight, inward pull; no plugin vs
0.1.5 quick vs full, all captured in the same daylight scene) scored 6.0 / 7.0 / 7.5 and added five rules:
9. **Rings and shockwaves travel.** All three arms got it wrong: one ring was born at full size and barely grew (a flat
   UI circle), one stopped growing and faded in place, one was a soft haze ball smaller than the rift it replaced.
   Start at 20% of the final size or less, ease out (quad/quint out) and keep growing while fading, reaching about 80%
   of the size in the first 40% of the life; give it thickness or a soft glow band behind; in daylight no grey dark
   twin ring (it reads as a soap bubble): only thin, deep, saturated ink, or none.
10. **A daylight flash is a small white core inside a big coloured bloom.** The winning effect's flash was a
   shapeless white ball about 14 studs across that hid the implosion (all 3 reviewers). Keep full white to a 3-6 stud
   core for about 0.1 s, and let a bright coloured bloom around it carry the size (as wide as the payoff);
   `VFXTimeline.check` warns on a big ROUND near-white sprite. Do not shrink the whole flash: in test 4 a 4-stud core
   with no real bloom read as "a tiny sparkle, no white-hot moment" and that effect came last (rule 14). Test 5 refined
   this (rule 15): the fault is the round soft shape, not the size; a 32-stud white starburst with thin Neon lines won.
11. **Sizes come from the brief, in studs, and get checked; the payoff's size is a floor.** Asked 15-20 studs, the
   shockwaves came out ~13, ~18-21 and 24-28; the 24-28 one won. Write each beat's size in the brief and compare the
   capture against it before the panel; a payoff under the asked size always lost.
12. **No dead air at the snap.** The collapsing rift vanished 0.1 s before the payoff fired and the reviewers read the
   gap as an empty frame. Keep the closing shape on screen (a hot slit shrinking to a pinpoint) until the payoff; a
   quiet beat is 0.05-0.1 s of reduced light, not nothing.
13. **The linger ends at the asked length, not before or after.** One effect showed an empty screen at 4.0 s of a 4 s
   brief (a hard cut for an ultimate); another's smoke ran to 4.6 s and turned muddy. `C.check(name, { length = s })`
   reports when the effect is last visible. A sustained hold must also BUILD (pulses growing and speeding up, a hotter
   rim, an accelerating pull with visible debris): the thin, static holds lost points in every lens.

Test 4 (2026-11-14, the same void rift with plugin 0.1.6-beta, one panel with all four effects: 0.1.5 full 8.0,
no plugin 6.5, 0.1.5 quick 6.5, 0.1.6-beta 6.0) added one more:
14. **Don't let a rule shrink the payoff, and read the references.** The beta's builder copied rules 10 and 11 as
   caps (a 4-stud white core, a ring to 18 studs) and got a 7-stud flash and a 12-14 stud ring: "the biggest beat
   reads as the smallest", last in every lens. It also worked from a 2.5 KB summary of the references instead of the
   cards, and built a smooth, symmetric lens ("a portal or an eye"). The payoff is the biggest thing on screen at its
   peak (rule 3); read the cards for ideas and technique (test 5 showed the shape itself should be designed, rule 16).
   A fireball also needs a value range (a hot core, an orange body, dark red-brown edges, dark smoke behind): test 2's
   flat single-value orange read as "jelly". Smoke cools to warm grey, rises from low down, with a dust skirt in front.

Test 5 (2026-11-14, ice slam, a NEW prompt; one panel with four effects, then a human poll): no plugin 8.0 and the
people's clear favourite; 0.1.5 full 7.0; beta3 7.0; beta2 6.5 for the panel but the people's second choice. Full
analysis: blindtest run_2026-11-14e COMPARE_B2_N2.md and PROCESS_B2_N2.md. It added:
15. **A flash is about shape, not size.** The winner's hit: an 8-stud white Neon dome for 0.11 s, a 32-stud sparkle
   STAR, 22 thin Neon speed lines; one frame after contact the white was at 88% of its peak (the runner-up 33%, its
   brightest moment 83 ms late). A builder that shrank its flash under the old 8-stud warning ended with "a roundish
   white blob". The wind-up must peak INTO contact (a falling comet brightest on the frame before), not fade out.
16. **Design the hero; the library is a guide (any effect).** Build the hero shape for the design, with its own value
   range on it, and let references supply technique and numbers. In test 5 three plugin builds used library meshes
   tinted as a whole:
   "smooth cones", "a pincushion", "one flat colour" after two panels. The winner built faceted crystals in code
   (deep base -> cyan -> white tip, alternating facet tones; now `ctx.Crystal`), pieces as their own angular shapes
   (7 / 4 / 3 per spike, landing with gravity), stumps that stay. Its whole object story was in v1.
17. **People reward bold colour.** The panel marked the runner-up down for vivid azure glow ("sapphire, not icy cyan";
   its hue was in fact on brief); people liked it. Saturation and glow in the asked hue family are a plus. Ground
   marks as Decals stay visible in daylight; flat particles wash out; grey smoke reads as dust.
