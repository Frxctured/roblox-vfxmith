---
title: Even-angle spawn with jitter for rings
tags: [vfx, ring, shockwave, smoke, particles, technique]
type: technique
updated: 2026-11-18
source: Ryan Zeng, Real-Time VFX Visual Design - Shape (B), https://www.youtube.com/watch?v=rpttR9r8_BE (21:48-24:58)
---
# Even-angle spawn with jitter for rings

> TL;DR
> - Random spawning around a ring leaves gaps; a gapped smoke ring reads as two smoke groups, not a shockwave.
> - Raising the rate or removing randomness gives a perfect circle: unnatural, and many stacked translucent puffs cost overdraw.
> - Fix: spawn one puff at each of N evenly divided angles, then add random offsets to angle, radius, size and rotation; always a full ring, never a perfect one.
> - Check the silhouette in every frame of the ring's life, not just the first.
> - Roblox translation (ours): emit from a script loop over N angles (Emit(1) per Attachment placed at 360/N*i + jitter) instead of one emitter with Rate and random SpreadAngle.

## The demo (Shape B 21:48-24:58)
Three ground smoke rings on a grid floor, played twice, the second time with red outlines:
- Left: random spawn; green dotted marks show the gaps; the ring splits into lumps going two ways.
- Right: high rate, low randomness; nearly perfect circle; "such a perfect circle does not exist in nature".
- Middle (chosen): fixed evenly divided spawn positions plus random values; a full but lumpy ring.

## Roblox translation (ours)
```lua
-- UNVERIFIED sketch: N attachments on a ring, one Emit each
local N, R = 12, 6
for i = 0, N - 1 do
    local a = math.rad(360 / N * i + math.random(-10, 10))
    local r = R * (0.85 + math.random() * 0.3)
    att.Position = Vector3.new(math.cos(a) * r, 0, math.sin(a) * r)
    emitter:Emit(1) -- size and rotation ranges on the emitter give the rest of the variation
end
```
Use [[Shape variation - big, medium, small]] for the puff sizes and [[Smoke is a volume]] for overlap and tone. A
single ring texture ([[Ring pulse from one particle]]) can sit under the puffs as the clean primary read.
