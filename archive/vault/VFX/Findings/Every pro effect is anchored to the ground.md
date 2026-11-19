---
title: Every pro effect is anchored to the ground
tags: [vfx, ground, decal, composition, anchor, finding]
type: finding
updated: 2026-11-18
source: Vefects https://youtu.be/fOTL1CtnZ58 (Fire Floor 47.11, Bomb ground pool 13.78, Lightning floor glow 97.15); Hyeon Woo Jang https://youtu.be/jfjR8ybC1O0 (cracks 6.04, vortex circle 37-43, frost carpet 68-71, shield ring 75-80, spawn pad 88-93); Tommy https://youtu.be/ijO35e3KBMI (lightning cracks 57.0, water ripples 96.2, ice cracks 113-114); Pawel Margacz https://youtu.be/Yyptp7OuCGI (ground auras 66-86); study _vfx_os_library/tutorials/REFERENCES_STUDY.md
---
# Every pro effect is anchored to the ground

> TL;DR
> - Nearly every effect in the four reels touches the floor with at least one layer, even air bursts and projectiles (floor glow, reflection streak).
> - Four ground layer types recur: a soft glow pool (fake light), a dark scorch/crack decal, thin rings/ripples, and an etched circle or outline.
> - The ground layer usually outlives everything else and is the effect's last word (residue).
> - Ground layers are flat and radial; the effect's bright body is vertical or curved, so the two never compete.

## Ground layer types
| Type | Blend | Examples |
|---|---|---|
| Glow pool / floor light | add, soft, 3-5 R | V Fire Floor orange glow, V Lightning purple floor glow, V Bomb blue pool, P ground auras |
| Scorch / cracks | alpha black + add glow copy | V scorch star, H teal cracks, T ice crack network, T lightning cracks |
| Rings / ripples | add, thin | H hammer ground rings, T water floor ripples, T bubble splash rings |
| Etched circle / outline | add when lit, dark when spent | H purple vortex circle, H spawn pad sigil, P ring/square/hexagon outlines |

## Exceptions
Small UI-like effects (V buff icons, pickups) and the T boss sphere sequence have no ground layer; air bursts (V Omni)
replace the ground with a rising smoke column.

## Roblox translation (ours)
- Decals on a thin, CanCollide false, Anchored, Transparency 1 part laid on the surface (raycast down for the floor
  height and normal); or flat particles (Orientation VelocityPerpendicular, EmissionDirection Top, Speed 0).
- Fake floor light: a big flat soft particle plus a PointLight/SurfaceLight with a short tween.
- Related: [[Ground smash with crack decal - reference breakdown]], [[Ground circle and vortex AoE - reference breakdown]],
  [[Endings and residue]].
