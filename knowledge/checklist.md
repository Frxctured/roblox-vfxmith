# Before you show a version: checklist

Every line is a failure that real directed builds had and a person or reviewer caught. The builds were a sword combo
and a fire punch, but the checks are for EVERY effect type: read "stroke" as your hero shape, "hit" as a beat, "payoff"
as the biggest moment, "caster" as whoever or whatever the effect comes from. Lines about parts your effect does not
have (rocks, a bolt, a wind-up) are "n/a". Answer each with yes / no / n/a from YOUR stills, not from the code.
One "no" = fix it before reporting, or name it as open. `fx:Lint()` (VFXKit) catches the ones marked [L]
automatically; the rest need eyes. "Fix" names the VFXKit block or value that solved it.

**Line 1 is a hard rule for builders AND directors:** everything lives in the caster's space; nothing is turned,
moved, lengthened or brightened toward a camera. A fix that asks for "more on the side the camera sees" breaks it.

## Space and placement
| # | Check | Fix |
|---|---|---|
| 1 | Every plane, path and landing spot is written in caster space; nothing was turned toward a camera to read better. | Kit blocks only take caster-space values. Readability = pose, size, brightness, contrast. |
| 2 | Bird's-eye: the payoff sits ON the look line and the target mark; nothing drifts to one side or behind the caster. | Overhead moves: hold az 0 and take el past 90 (an az lerp carries the limb round the side). |
| 3 | Bird's-eye: a sweep is an arc of the angle the limb travelled (150-200 deg), not a closed ring or hoop. | No ring-shaped wind textures; one wind arc on the stroke's own angle; trail limited to the swept angle. |
| 4 | [L] No hero stroke is edge-on from behind (its plane does not contain the look vector), or it has volume. | Design the cut ACROSS the front (normal 45-60 deg toward forward). A vertical cut gets `fan = 10`, ghosts, side sparks AND a wider crescent 4-6 studs ahead + a flat ground crescent. |
| 5 | The payoff is not hidden by the caster's body from the player camera. | Strike 10-12 studs ahead, column >= 3x caster height, dust ring / sparks / debris thrown past the silhouette to both sides. |
| 6 | Hands / weapon stay outside the body silhouette from behind at every hit pose. | Arm az beyond +-100, lean the torso into heavy hits. |

## Animation (when a character performs the effect; answer from a side pose sheet, one still every 0.1 s)
Take it with the effects off: `fx:PoseOnly(true); fx:Shots(fx:Dense("side", 0, lastKeyTime, 0.1))`, then
`fx:PoseOnly(false)`. The effect follows the pose (`swing = { t0, t1 }`), never the other way round.
| # | Check | Fix |
|---|---|---|
| A1 | [L] No T-pose between hits: upper arms below the shoulders, elbows bent 18-80 degrees, every hit starts from and returns to a guard. | `K.Guard.Mid / Low / High` through `K.Key(t, guard, extra)`. |
| A2 | [L] Two-handed moves have the off hand ON the hilt (guards, wind-ups, heavy cuts); a free hand is a fist at the belly or ribs, not hanging. | Pose key `two = 1` (two-joint IK onto the handle); `K.Guard.Fist / Tuck` when released. |
| A3 | [L] Arms never pass through the body: no hand inside the torso, the swinging arm stays on its own side or goes over the top. | Turn the waist (`wy`) to carry the swing; keep the arm az in about -45..125. |
| A4 | The body commits: a step into each hit, a stride on lunges, the head leads or follows the cut, a lean into spins; nothing slides. | Pose keys `fz`, `st`, `hy`, `rl`. |

## Dark and light
| # | Check | Fix |
|---|---|---|
| 7 | [L] No dark slab: every black layer hugs a bright stroke as a thin rim. | Ink = same texture, 0.9x, Transparency 0.45, ZOffset +0.02..0.06. No LE -5 colour arcs. No twin on strokes within ~8 studs of the camera (`soft = true`). |
| 8 | No solid white mass: the white core is the leading third; the rest is hue, streaked, see-through at the tail; no straight clipped quad edge. | Lower Br / raise Transparency on the body, thin texture for spins, bigger quad. |
| 9 | [L] Not timid: cores Br 25-40 (finisher 60), accents 40-60, LightInfluence 0. | `K.Tier`. Max Brightness below 40 = matte. |
| 10 | [L] Light is local: flash <= 3 frames, PointLight Range <= 16 for ~0.25 s, no world tint, the hero shape stays the brightest thing. | `fx:Flash`, `fx:Light`. ColorCorrection only for the 0.12 s dark beat. |
| 11 | [L] One hue family in every ramp; no stray colour line late in a stroke's life. | `K.Palette(main, deep)`: main -> deep -> dark. A second hue only as a faint wide glow. |
| 12 | Reads in daylight on the mid-grey floor AND at night (one night frame). | Ink rim for day, LE <= 0 cores; impact frame is screen-space so it works at night. |

## Shapes
| # | Check | Fix |
|---|---|---|
| 13 | [L] No stickers: <= 4 star sparkles per hit, life <= 0.15 s; charge-ups live ON the weapon, nothing bigger than it. | Dots for volume (`fx:Dots`), `fx:Charge` for wind-ups. |
| 14 | [L] No planks / pencils: streaks are thin and tapered (Size <= 0.8, Squash 3, life <= 0.12 s); smear ghosts only on vertical heavy cuts. | `fx:Needles`. From the side a needle must not be a white rectangle: Size 0.45, Br 28. |
| 15 | The bolt / beam is a column (thick white core tapering, sheath, glow), not a 1-pixel zigzag; it thins out at the end instead of popping off. | `fx:Bolt` defaults (width 0.9, 20 segments, 3 layers). |
| 16 | Ground marks: ONE scar on the stroke's line + ONE crack at the hit; nothing tiled, no puddles; heat stays in the crack ~1 s. | `fx:GroundScar`, `fx:GroundCrack`. |
| 17 | [L] Rocks are stone, not blobs: 3 sizes, unlit light grey with a hot first 15 %, <= 8 per size, spinning, gravity -90. | `fx:Debris`. |
| 18 | The payoff has a ground burst: white-hot ball 3-4 frames, hard ring 2 -> 14 studs in 6 frames, radial streaks. | `fx:Strike` (Burst + ShockRing + streaks). |
| 19 | Aftermath keeps heat for ~1.5 s: embers rising, crack glowing then dark, dark smoke ~2 s, a few residual arcs. | `fx:Smoke`, `fx:Strike` crackle list. |

## Motion (dense consecutive stills around each beat show these; a live recording shows them best)
| # | Check | Fix |
|---|---|---|
| 20 | Nothing detaches and flies off: no crescent / sliver drifting away after a hit. | Big or long strokes fade at 42-62 % of life (kit does it when size >= 14 or life >= 0.25), RotSpeed 0, Speed 0.001. |
| 21 | Each hero stroke is thick for 5-7 frames, then thins from the tail in 3-4; it is on at full size on the contact frame. | If it is thick for 1 frame only: life 0.25-0.3 with the early fade, or a texture whose frames stay thick. |
| 22 | [L] No dead time: something changes every 2-4 frames; gaps between hits <= 0.15 s of nothing. | Start the next wind-up's crackle inside the recovery. |
| 23 | The wind-up BUILDS (size, rate, light all grow), peaks with a tip glint, then 3-4 silent frames before the hit. | `fx:Charge` + a heat/light ramp in `fx:OnUpdate`. |
| 24 | [L] Hits escalate: each stroke ~15 % bigger than the last, finisher biggest and brightest; a held pose (~8 frames) after each hit. | Sizes 10 / 11.5 / 13.2 / 15.2. |
| 25 | Impact frame registers: 4-5 frames (white, inverted, white) with the hero shapes + ground streaks as silhouettes; the strike starts as it ends. | `fx:ImpactFrame{ focus = ... }`; Strike / Bolt at impact t + 0.07. |
| 26 | [L] Camera shake is declared, small, decaying (0.15 / 0.1 s light, 0.6 / 0.35 s heavy), and the camera returns exactly. | `fx:Shake`. Off in freezes automatically. |
| 27 | Frozen frame = live frame: every moving part, light and beam is driven by the effect clock. | `fx:At`, `fx:OnUpdate`, `fx:TrackBeam`. No task.delay, no tweens. |
| 28 | Played live twice in a row: no errors, the same result, total length matches the brief (+-10 %). | `fx:Play()` twice; compare `fx.duration` and the beat times with the brief. |
