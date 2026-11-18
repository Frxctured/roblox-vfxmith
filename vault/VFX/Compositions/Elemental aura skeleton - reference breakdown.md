---
title: Elemental aura skeleton - reference breakdown
tags: [vfx, aura, item, element, ground, set, composition, reference]
type: composition
updated: 2026-11-18
source: Pawel Margacz https://youtu.be/Yyptp7OuCGI (item auras 17-42, ground auras 66-86); Tommy "Unity VFX" https://youtu.be/ijO35e3KBMI (constellation aura 7.5-13); study _vfx_os_library/tutorials/REFERENCES_STUDY.md E12
---
# Elemental aura skeleton - reference breakdown

> TL;DR
> - Five element auras share ONE skeleton: a tall thin plume above the item, 2-3 tilted orbit rings made of DOTTED lines, fine spark streaks swirling, a soft glow pool underneath.
> - Only colour and the plume's shape language change per element (flame tongues, lightning, crystal wisps, leaves, white wind rings).
> - Dotted (beaded) rings are a cheap way to add fine detail; they read as "magic" without adding brightness mass.
> - Ground auras: a crisp emissive outline shape (ring, square, hexagon) as the anchor, with particles rising inside and hugging the outline.

## Item aura layers (P 27.0-30.3, fire version)
| Layer | Shape | Size | Notes |
|---|---|---|---|
| Plume | tall thin flame/energy flipbook | 3-4x item height | leans with a slight angle, flickers |
| Orbit rings | dotted ellipses, tilted at different angles | 1.5-2x item | rotate slowly, beads bright |
| Spark streaks | thin curved streaks | small | swirl around the item |
| Glow pool | soft disc under the item | 2x item | low alpha |

## Ground auras (P 66-86)
- Water: blue ring outline on the floor, rising bubble dots and soft wisps inside the ring.
- Nature: green square outline, green leaf-wisps creeping inside and rising.
- Fire: orange hexagon outline, flame tongues rising from the edges and inside, bright floor glow.

## T constellation (7.5-13)
- Gold 4-point star flares orbit the character linked by a thin blue line graph (dots + straight segments) and soft
  gold/blue ribbons; a neutral-dark body with bright tiny nodes.

## Roblox translation (ours)
- Plume: tall 4x4 flame flipbook particle with Squash < 0 (taller), LightEmission 1.
- Dotted rings: a dotted-ring texture on a flat particle tilted by an attachment (Orientation VelocityPerpendicular with
  EmissionDirection set), RotSpeed slow; or a Beam with a dotted texture and CurveSize bending.
- Ground outline: Decal or flat particle LightEmission 1 with the outline texture.
- Set design: build one module and swap a palette + plume texture per element ([[One style family per game]]).
- Related: [[Character effects - auras and buffs]], [[Pros animate with flipbooks, particles barely move]].
