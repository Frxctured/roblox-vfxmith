---
title: Cartoon fire from inner and outer flame flipbooks
tags: [vfx, fire, flame, flipbook, embers, layering, technique]
type: technique
updated: 2026-11-18
source: Ampro, Roblox VFX Tutorial 5k Special https://www.youtube.com/watch?v=o2021uP4mzE (14:45-24:25; no captions, values read off Properties)
---
# Cartoon fire from inner and outer flame flipbooks

> TL;DR
> - Use the SAME flame flipbook twice: a wide Outer layer (red-orange 255,51,0, Spread 15-45, Speed 7, Rate 16) and a tight Inner core (orange 255,157,0, Spread 0, spinning RotSpeed 10-20, Rate 30).
> - Both: Grid4x4 OneShot, LightEmission 1, LightInfluence 0, Brightness 3, Lifetime 0.3-0.7, Rotation -10..10 (outer), Acceleration 0,5,0.
> - Add round sparks (Brightness 10, deep red 212,46,12, Speed 30, Spread 45, Drag 10, Rate 10) and streak embers (copy of the sparks, VelocityParallel, Rotation 90, rising Acceleration 0,5,0).
> - The core is the brightest, warmest value; colour falls off yellow-orange -> red-orange -> deep red at the edges.
> - When you add layers, lower the rates; tighten the outer spread if the fire looks unfocused.

## Build order (as shown)
1. Sphere MeshPart helper (2978733208, 1x1x1, Transparency 0.8), emitter directly inside it.
2. Flame flipbook 11388840312, Grid4x4 OneShot, white: on its own it reads as a grey smoke column. Tint 255,51,0 and it
   becomes fire (the same sheet doubles as smoke).
3. Tune lifetime (0.5 -> 0.3-0.5), rate (20 -> 30), rotation (-10..10), spread (45), size curve (gentle wave about 1.1
   then down), transparency curve -> **Outer**.
4. "Gonna add a center flame to make it look stronger there": duplicate into an Attachment, colour 255,157,0,
   Spread 0, Rotation -180..180, RotSpeed 10-20 -> **Inner**.
5. **Dots** (8511527728): sparks that burst out and stop (Speed 30, Drag 10, Lifetime 0.7-1.4, RotSpeed -500..500,
   Size falls to 0).
6. Duplicate to **Embers** (8599882518): VelocityParallel + Rotation 90 so the streaks point along their path, rising.
7. "Decrease the rate because there are more particles now"; "the outer flame needs a little more focus": Outer
   Rate 30 -> 16, Spread 45 -> 15, Lifetime 0.4-0.7.
8. Check it in day AND night lighting ("It looks good at night too").

## Why it works
- Two copies of one texture at two scales/colours give depth without a new asset; the narrow bright core over a wider
  darker body is the value structure in [[Value, contrast and glow]].
- Flipbooks do the flame motion; the particles barely move (Speed 5-7) - see
  [[Pros animate with flipbooks, particles barely move]].
- Sparks with drag + embers that rise give the secondary motion ([[Primary and secondary elements]]).
- Large readable flame tongues, not photo fire: [[Soft and sharp texture shape language]].

## Caveats
One tutorial; no smoke layer and no light source in the final build. Exact NumberSequence points for size and
transparency were not readable (UNVERIFIED beyond the shapes described).
