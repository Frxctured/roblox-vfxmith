---
title: Ground circle and vortex AoE - reference breakdown
tags: [vfx, aoe, magic-circle, vortex, ground, decal, composition, reference]
type: composition
updated: 2026-11-18
source: Hyeon Woo Jang https://youtu.be/jfjR8ybC1O0 (purple vortex 36.6-43.5, frost carpet 64.5-72.5, item spawn pad 87.6-93.8); Vefects https://youtu.be/fOTL1CtnZ58 (Lightning telegraph ring 91.0-97.0); study _vfx_os_library/tutorials/REFERENCES_STUDY.md E6
---
# Ground circle and vortex AoE - reference breakdown

> TL;DR
> - Ground circles live in two states: LIT (additive, bright) and BURNED-IN (dark etched decal); the dark state is the residue that closes the effect.
> - The bed of a vortex is DARK: purple-black smoke blades spiralling flat on the ground, with bright streak sparks orbiting on top.
> - One accent hue: ~85% magenta sparks with ~15% yellow sparks.
> - AoE carpets are thousands of tiny shards filling the area, with a few hair-thin vertical lines (falling icicles) and thin ring halos hovering above.
> - Rings draw themselves as rotating partial arcs before they close.

## H purple vortex beats
| Time | Beat |
|---|---|
| 36.6 | white-violet core bursts magenta streak sparks and black ink flecks |
| 37.2-40.4 | dark smoke blades spiral flat around the core; magenta + yellow streak sparks orbit on top; dark etched circle under it |
| 41.0 | smoke clears; the magic circle lights up pink; star glint above |
| 41.6 | motes drift up |
| 42.2-43.5 | circle stays as a dark etched decal, fades |

## H frost carpet (64.5-72.5)
- 3 s wind-up: white circle of several thin concentric rings, a dotted ring and runes, drawn by a sweeping light.
- Then a flat oval of tiny white shards about 4 C wide appears in the target area; thin ring halos hover above it,
  icicles fall as single thin white lines; the carpet dissolves from its edges inward.

## H item spawn pad (87.6-93.8)
- Partial hologram arcs rotate and close into rings; a translucent light cylinder with rising motes; a 4-arm sigil;
  the reward cube pops with 12-16 thin radial rays and gold motes; the sigil remains as a dark etched decal.

## Roblox translation (ours)
- Circle: Decal (or flat particle, Orientation VelocityPerpendicular, Speed 0) in two copies: lit (bright Color, LightEmission 1)
  and etched (dark Color, alpha). Cross-fade lit -> etched at the end.
- Rotating partial arcs: flat particles with RotSpeed and a partial-ring texture, or thin rotating parts with Beams.
- Vortex smoke: flat dark particles with RotSpeed under the sparks; sparks orbit with tangential speed
  ([[Orbits and rings around the caster]]), Orientation VelocityParallel.
- Carpet: many small flat shard particles in an area emitter (Shape = Box/Disc on a flat part), short random lifetimes.
- Related: [[Telegraphs that show the true area]], [[Every pro effect is anchored to the ground]].
