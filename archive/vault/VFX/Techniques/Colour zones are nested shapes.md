---
title: Colour zones are nested shapes
tags: [vfx, shape, colour, value, silhouette, technique]
type: technique
updated: 2026-11-18
source: Ryan Zeng, Real-Time VFX Visual Design - Shape (B), https://www.youtube.com/watch?v=rpttR9r8_BE (15:48-21:44)
---
# Colour zones are nested shapes

> TL;DR
> - Every value/colour zone inside an effect is a shape too ("colour silhouette"): core, mid tone, outer/dissipating.
> - Nest them: the mid zone echoes the outer silhouette, the core echoes the mid zone, all pointing the same way as the motion.
> - A single flat fill looks flat; adding a directional mid tone and highlight makes it volumetric and readable.
> - Bad: highlights scattered evenly over the whole shape (fractal, noisy) - you cannot find the core, mid or fading area.
> - Roblox translation (ours): build zones as separate layers - a small bright core sprite, a medium mid-tone layer, a large soft outer layer - offset toward the leading side, not concentric copies.

## Fireball demo (Shape B 15:48-18:57)
Slide sequence: alpha silhouette; flat single-colour fill (flat); + mid tone; + highlight. The final frame is annotated
with three nested chevron/cone outlines (core, mid, outer) all opening toward the back and pointing the travel
direction (white arrow). Two messages the shape must send: fluid, and directional; colour has to send the same two.

## Tornado comparison (Shape B 18:57-21:44)
- Good (fire tornado, by Fujihara): a bright yellow core column the author traces at 20:40, an orange mid zone that
  follows the funnel, rings and debris outside. Reads solid and powerful.
- Bad (blue tornado): white highlight patches spread evenly over the whole funnel; noisy, no core, "some might think it
  is not a tornado at all". The outer shape was fine; the colour silhouette failed. (Side assignment from the
  transcript order and the author's annotation; fairly sure.)

## Roblox translation (ours)
- Core: small, high Brightness/LightEmission, low Transparency; mid: 1.5-2x size, lower brightness; outer: soft, larger,
  higher Transparency. Same orientation for all three so they point the same way.
- For projectiles, place the core layer's Attachment toward the front (see [[Clean front, broken back]]).
- Avoid textures whose bright specks are spread evenly; prefer textures with one bright region.
- Agrees with [[Core push and illumination]] and [[Value, contrast and glow]]; adds that the zones must be shaped and
  directional, not concentric circles.
