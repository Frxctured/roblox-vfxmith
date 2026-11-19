---
title: Shield sphere - reference breakdown
tags: [vfx, shield, bubble, dome, water, composition, reference]
type: composition
updated: 2026-11-18
source: Hyeon Woo Jang https://youtu.be/jfjR8ybC1O0 (hex shield dome 74.6-80.8); Tommy "Unity VFX" https://youtu.be/ijO35e3KBMI (water bubble 24.3-28.6, water splash 92.4-97.0); study _vfx_os_library/tutorials/REFERENCES_STUDY.md E9
---
# Shield sphere - reference breakdown

> TL;DR
> - A shield is mostly EMPTY in the middle: a fresnel rim plus a sparse surface pattern; the character stays readable inside.
> - Life comes from something moving ON or AROUND the surface: crawling colour patches on a hex grid, water ribbons orbiting the bubble.
> - A ground element anchors it: a hot ring at the base, splash rings popping on the floor.
> - It assembles from the ground (sigil with arrows ~0.5 s) and ends in 2 frames or one white flash that bursts into drops and floor ripples.

## H hex dome (74.6-80.8)
- 74.6: ground sigil (circuit lines, small arrows pointing in) assembles.
- 75.5-79.9: translucent dome, white triangle-hex wire pattern, RED patches crawling over it (two colours on one surface),
  hot white-orange ring at the base, one ring segment orbiting the base.
- 80.8: gone in 2 frames; a soft floor light remains briefly.

## T water bubble (24.3-28.6) and splash (92.4-97.0)
- Bubble: clear sphere, cyan fresnel rim, soft caustic swirls inside; thin white-edged water ribbons orbit; small
  splash rings pop on the floor; ends with a white flash -> cel droplets + floor ripple rings.
- Splash: hard-edged cel water blobs (cyan body, white edge) spread on the ground, white starburst, droplets and bubbles
  with white rims fly out; many thin floor ripple rings remain as residue.

## Roblox translation (ours)
- Sphere: MeshPart with ForceField material (gives a rim-like look) or a sphere mesh with a fresnel-ish texture; keep it
  transparent in the middle.
- Moving pattern: Texture on the mesh with animated OffsetStudsU/V (UNVERIFIED on curved MeshParts), or particles
  LockedToPart scattered on the surface.
- Ribbons: Trails on attachments that orbit the centre (tween CFrame or rotate a parent part).
- Floor: flat ring particles for ripples; base ring = flat ring particle LightEmission 1.
- Related: [[Energy dome burst - reference breakdown]], [[Orbits and rings around the caster]].
