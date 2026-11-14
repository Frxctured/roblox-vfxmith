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

## 14. What the open-source library teaches (11 category studies, ~1,900 effects, 2026-11-14)
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
