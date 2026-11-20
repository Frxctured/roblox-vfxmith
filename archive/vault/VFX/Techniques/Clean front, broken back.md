---
title: Clean front, broken back
tags: [vfx, shape, silhouette, textures, slash, fireball, direction, technique]
type: technique
updated: 2026-11-18
source: Ryan Zeng, Real-Time VFX Visual Design - Shape (B), https://www.youtube.com/watch?v=rpttR9r8_BE (08:29-15:48); Shape (A), https://www.youtube.com/watch?v=0wEvAV_R2Rw (27:48-30:08)
---
# Clean front, broken back

> TL;DR
> - A moving element reads its direction from edge contrast: the leading edge is one clean curve, the trailing edge is fractal, wispy or toothed.
> - Fireball: smooth front half, turbulent broken back half; this comes from real flow past a sphere (turbulent wake), so it reads as true even when stylized.
> - Slash texture from real motion blur: grayscale wedge (bright at the blade edge, fading back), colour remapped white/yellow -> orange -> crimson, then cut the trailing edge into a few sharp backward hooks.
> - Size the slash from the weapon's real afterimage and the hit area, never a random trail plane.
> - Roblox translation (ours): bake this into the texture or flipbook (crisp leading edge, ragged tail); orient with VelocityParallel or a Beam so the clean edge faces travel.

## Fireball (Shape B 12:32-15:48)
Slide: the fireball beside its black alpha silhouette and textbook drawings of laminar separation and turbulent wakes
behind spheres. The front is clean because the flow is attached; behind it a low-pressure pocket pulls air in and
makes turbulence, so the back breaks up. Even a still frame "flies left" from this contrast alone. The same reasoning
covers water spray, wind and poison smoke: base silhouettes on real physics, then exaggerate.

## Slash texture, step by step (Shape B 09:07-10:52, demo over a katana video)
1. Sketch the motion-blur area as grayscale: thin at the hilt, widest at the tip; white along the blade edge, fading
   toward the trail.
2. Remap colour from the grayscale: white/yellow at the edge, orange in the middle, red/crimson at the trail.
3. Optimise the colour spread (energy shown by brightness).
4. Shape the trailing edge: a few large, sharp, backward-hooked teeth in crimson ("exaggerated corners"). The leading
   edge stays one smooth arc. Sharper corners = faster, sharper, more directional, more dangerous.
5. Match length and width to the weapon and to the gameplay area; fit the project's art style.

## Arrow (Shape A 27:48-30:08)
LoL High Noon Ashe arrow: a sharp white-hot triangular tip, curling wisps and a darker smoky trail behind. Same rule:
crisp front, loose back.

## What a good vs generic texture looks like
| | Good | Generic |
|---|---|---|
| Slash | one crisp bright leading curve, tapering wedge, few big teeth at the trail, hue shift along the width | even-width band, symmetric soft edges, one flat colour |
| Fireball / projectile | clean round front, fractal wispy back, core toward the front | round blob, same noise all around, core centred |
| Smoke puff | lumpy outline with big/medium/small lobes, one flatter side | perfect circle with even noise |

## Roblox translation (ours)
- ParticleEmitter Color multiplies the texture, so a multi-hue slash gradient (yellow to crimson) must be baked into the
  texture or built from 2 layers (bright thin edge layer + wider dark-red tail layer). UNVERIFIED which looks better in
  Roblox; test both.
- Projectiles: VelocityParallel orientation (or a Beam between two Attachments) so the clean side leads; put the
  smaller hot-core sprite on an Attachment slightly ahead of centre.
- Pros stack many thin slash sprites ([[Slashes are many thin sprites on tilted planes]]); each sprite should still have
  this front/back contrast.
- Related: [[Direction through blur and stretch]], [[Colour zones are nested shapes]].
