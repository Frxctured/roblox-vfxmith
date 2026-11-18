---
title: Impact burst - flash that breaks into streaks
tags: [vfx, hit, impact, block, flash, shards, debris, technique]
type: technique
updated: 2026-11-18
source: Ampro, Roblox VFX Tutorial Part 2 https://www.youtube.com/watch?v=JXoGT2PoOhs (9:37-17:47); Ampro, Roblox VFX Tutorial 5k Special https://www.youtube.com/watch?v=o2021uP4mzE (5:18-14:45)
---
# Impact burst - flash that breaks into streaks

> TL;DR
> - Build a hit outward from ONE big short flash (0.15-0.3 s, emit 1); everything else is the flash "breaking apart".
> - Add 12-16 thin spikes or streaks (VelocityParallel, so they point along their flight), Speed 30-50, high Drag (7-12) so they shoot out and stop, Lifetime 0.1-0.3 (white pop) or about 1 (lingering specks).
> - Then 12 smaller debris bits / dots (FacingCamera, random rotation) and optionally one spinning crescent (RotSpeed 400-600).
> - Size curves rise then fall ("stretch and shrink"), never constant. Thin pieces get more Brightness (12) than the soft flash (3).
> - A block/parry is the same skeleton recoloured blue and with a ring or flare flipbook in place of spikes and crescent.

## Two versions by the same artist
| | Slash hit (JXoGT2PoOhs) | Punch hit (o2021uP4mzE) |
|---|---|---|
| Flash | long thin line streak (16010390262), VelocityParallel, Squash-squeezed so it reads longer, Size triangle to ~5.4, Lifetime 0.3 | soft star flash (9509570418), FacingCamera, Size 0 -> ~3 @0.33 -> 0, Lifetime 0.15, Rotation 0..180, Brightness 3 |
| Spikes | streak pieces + classic shards, Rotation 90, Speed -50..50 with EmissionDirection Left and InAndOut (both ways along one line), Spread 0-15, Drag ~12 | spikes 7994629137, Speed 30-40, Spread 360 (all directions), Drag 7, Brightness 12, emit 16 |
| Small bits | offset dots, Squash ~0.15 (oval), Speed -50..50, Drag 12, emit 12 | debris 8788474862, FacingCamera, Rotation 0..360, Drag 9, Brightness 7, emit 12 |
| Extra | white duplicate of the shards at Transparency 0.8-0.9 as a faint backing | one crescent (10927170198), RotSpeed 400-600, emit 1 |
| Colour | pale blue 181,219,255; LightEmission 0 on the pieces "so it doesn't get overwhelmed by white" | all white, LightEmission 1 |

## Placement
- On a slash, the hit is a second attachment on the slash rim (0,0,-6 from the slash centre): the hit happens where
  the blade meets the target, and the streaks run along the cut direction (one axis, both ways).
- A punch hit sits at chest height in front of the body; the spikes go in all directions.
- Host: a 1x1x1 sphere MeshPart at Transparency 0.8 as a visible emit marker (punch video), or a small part.

## Block / parry variant
Duplicate the hit, change colour family (Flash 96,207,255, Ring 85,130,255, Brightness 5), swap the soft flash for a
4x4 flare flipbook (OneShot) and the crescent/spikes for a ring outline (12239789629), keep Debris and the same
timing (0.15-0.3 s). Defence reads as a ring / barrier, attack as spikes.

## Why it works (artist + ours)
- "It looks like a main beam just separated into little beams" (JXoGT2PoOhs 13:20): the flash and the streaks share a
  direction and colour, so the eye reads one event, a flash that shatters.
- Drag, not short lifetime, makes the pieces stop: fast start, sudden stop, then fade (see
  [[Easing and dynamic timing]]).
- Ours: matches [[Primary and secondary elements]] (flash = primary, spikes/debris = secondary) and the value rule in
  [[Value, contrast and glow]] (flashes 0.1-0.15 s).
- Compare [[Slashes are many thin sprites on tilted planes]] for the slash this hit sits on.
