---
title: Slashes are many thin sprites on tilted planes
tags: [vfx, slash, crescent, particles, composition, finding]
type: finding
updated: 2026-11-18
source: Ampro, Roblox VFX Tutorial Part 2 https://www.youtube.com/watch?v=JXoGT2PoOhs (2:10-17:47); STATS_FINDINGS.md (2026-11-17): 1,212 slash-tagged OS effects; DazMuky Particles 101 https://www.youtube.com/watch?v=-SKNCFqqvT4 (38:20-41:54); Ryan Zeng, Shape (B) https://www.youtube.com/watch?v=rpttR9r8_BE (08:29-12:30)
---
# Slashes are many thin sprites on tilted planes

> TL;DR
> - A median pro slash effect has 36 emitters (p90 105).
> - 44% of slash emitters use VelocityPerpendicular orientation: a sprite laid flat on a plane set by its velocity.
> - Only about 23% of slash effects use a MeshPart.
> - A 'solid disk' comes from one big opaque crescent; pros stack many thin, bright, short-lived crescents (life about 0.2-0.4 s).

## Takeaway
A slash is a stack of crescent sprites on tilted planes plus streaks (VelocityParallel), not one shape. Code that draws
a single arc misses this; see [[Code-made assets look generic]].

## Smallest slash unit: a squashed line sprite (tutorial)
DazMuky's beginner slash (https://www.youtube.com/watch?v=-SKNCFqqvT4, 38:20-41:54, values read off the Properties
panel) is one emitter on an Attachment: a thin streak texture (`rbxassetid://8617740974`), Speed 0, Lifetime 0.25-0.75,
Rotation -360..360 (random angle per slash), Squash 0 -> ~1.7 over life, Size 0.25 -> 2, Transparency 1 -> 0 almost
at once, hold to ~0.4, then fade to 1, colour 26,98,255, LightEmission 1, FacingCameraWorldUp, Rate 1-5. It reads as
quick thin cuts across a torso. This is the building block, not a finished slash: a pro slash stacks many of these with
crescents on tilted planes as above.

## A finished horizontal slash, layer by layer (tutorial)
Ampro's slash (https://www.youtube.com/watch?v=JXoGT2PoOhs, 2:10-9:20, values read off Properties; full table in
`_vfx_os_library/tutorials/basic_JXoGT2PoOhs/study.md`) is six emitters on ONE attachment, all VelocityPerpendicular
(so they lie in the attachment's plane), Speed 0.001, LightInfluence 0, LightEmission 1, Brightness 6:
- 1 hero crescent: a 4x4 crescent-sweep flipbook (OneShot), Size 7, Lifetime 0.4, Rotation -90, RotSpeed -400. It
  carries the shape.
- 5 thin arcs (two "slash wind" wisps, three wind crescents) at random start angles (-360..360), random spin
  (-500..-300) and random life (0.4-1.2), colours alternating white / pale blue (184-207, 224-228, 255).
- The wisps grow 0 -> ~9.5 with an ease-out; the crescents instead start fully transparent and pop in at their
  radius, "so it doesn't look like it's expanding from the centre".
- The hit sits on a second attachment on the slash's rim (0,0,-6), not at its centre; see
  [[Impact burst - flash that breaks into streaks]].
Raise the host part a little so you can check the flat layers from below too.


## What each slash sprite should look like (Ryan Zeng, Shape B 08:29-12:30)
Zeng designs the slash texture from the real motion blur of a swung katana: a grayscale wedge bright at the blade edge,
colour remapped white/yellow -> orange -> crimson, a clean leading curve and a few sharp backward teeth on the trailing
edge, sized to the weapon and the hit area. Full steps in [[Clean front, broken back]].
