---
title: Shape variation - big, medium, small
tags: [vfx, shape, silhouette, textures, composition, technique]
type: technique
updated: 2026-11-18
source: Ryan Zeng, Real-Time VFX Visual Design - Shape (A), https://www.youtube.com/watch?v=0wEvAV_R2Rw (08:43-14:33, slide art credited @MitchLeeuwe); Shape (B), https://www.youtube.com/watch?v=rpttR9r8_BE (23:57-24:20)
---
# Shape variation - big, medium, small

> TL;DR
> - Four things kill a shape: uniform (same-looking parts), mirrored/symmetrical, even volumes, high-frequency detail.
> - Four things fix it: more dynamic, more variation, curves, volume contrast.
> - Use at least three size levels (big, medium, small) and also long vs short; build from the big shapes down.
> - Asymmetry gives direction: a flame leaning one way, waves and grass bent by one wind, smoke curves that grow.
> - The same rules apply to moving shapes, in every frame of their life (Shape B 23:57).
> - Roblox translation (ours): never one Size for a layer; split a puff/spark layer into 2-3 emitters of clearly different sizes and counts, and offset them so the group is lopsided.

## The slide (Shape A 08:43)
Red "Not do" list and green "Can do" list beside paired drawings:
- Chimney smoke: two equal S-curves, "lines are too parallel" (bad); first curve small, second bigger, a break near the
  top, "more dynamic and realistic" (good).
- Cloud: equal circles (bad) vs lumps of many sizes with a small detached puff (good).
- Flame: mirror-symmetric teardrop (bad) vs a flame leaning one way with uneven tongues (good).
- Water and grass: even teeth (bad) vs three wave sizes and blades all blown one way (good).

## Recipe (cloud panels on the same slide)
1. Start with big shapes: one big, one medium, one small.
2. Add straight vs curved: a long flat base under round tops gives direction.
3. Draw on top of the shape: small shapes inside the big ones.
4. Add ground/base colour.
The author's summary (13:03-13:47): the minimum three-level contrast big/medium/small, plus long vs short, then connect
all forms into one silhouette.

## Why
Uniform and mirrored shapes look rigid and man-made; varied ones read as natural and show which way things move. High-
frequency detail spread evenly is noise; the eye needs one big read first ([[Silhouette-first reading]]).

## Roblox translation (ours)
- Puffs, sparks, debris: 2-3 emitters per role with sizes about 3:1.5:1 or wider, counts inverse (few big, many small).
  Agrees with [[Smoke is a volume]] (about 3x size variety).
- Avoid emitting a cluster at the exact centre with SpreadAngle 360 equal in every axis; bias with an offset
  Attachment, a non-zero Acceleration or an asymmetric shape so the group leans.
- Flipbook frames and mesh shells: check that the silhouette is not mirror-symmetric; rotate (Rotation random range)
  so repeated sprites do not line up.
- Size checks against the character still apply: [[Size effects against the character]].
