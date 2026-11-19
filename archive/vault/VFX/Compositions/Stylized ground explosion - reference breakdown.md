---
title: Stylized ground explosion - reference breakdown
tags: [vfx, explosion, impact, fire, smoke, decal, composition, reference]
type: composition
updated: 2026-11-18
source: Vefects "Anime Stylized VFX - Demo" https://youtu.be/fOTL1CtnZ58 (Explosion Fire Floor 46.95-48.10, Fire Omni 55.0-56.0, Ice Floor 50.8-51.6, Ice Omni 59.7-60.5); Hyeon Woo Jang portfolio https://youtu.be/jfjR8ybC1O0 (white burst 52.0-52.8); study _vfx_os_library/tutorials/REFERENCES_STUDY.md E2
---
# Stylized ground explosion - reference breakdown

> TL;DR
> - Flash first, no anticipation: a spiky-edged white-yellow disc (1.5 R) plus a soft orange glow 4-5 R wide, for only 2-3 frames.
> - The flash is REPLACED (not faded) by a thin half-ring shock arc, a cel fire core and black smoke chunks already inside the fire.
> - Fire lives ~0.3 s; the black smoke clump and a dark spiky ground scorch live ~0.8 s more. Dark residue outlasts the light.
> - 8 layers: flash, ambient glow, shock arc, fire core, black smoke, ground scorch, 4-point star sparkles, embers.
> - Every big shape is a hard-edged 2-tone cel shape; softness only lives in the separate glow layer.
> - The black smoke is reused for fire AND ice variants; only the bright layers change element.

## Beats (Fire Floor, times in the video)
| Time | What is on screen |
|---|---|
| 46.95 | nothing (no wind-up) |
| 47.02 | flash disc with 3-4 long triangular spikes of different length; huge soft orange glow lights the floor |
| 47.11 | thin bright half-ring arc; yellow fire with black smoke chunks mixed in; dark red spiky star on the ground |
| 47.16-47.30 | white 4-point stars with short trails thrown up and out; spark dots |
| 47.30-47.60 | fire cools yellow -> orange -> red embers inside the smoke |
| 47.60-48.10 | only black smoke and black spiky scorch, fading |

## Layers
| # | Layer | Shape and texture | Size | Value / colour | Blend | Motion |
|---|---|---|---|---|---|---|
| 1 | Flash | disc with jagged rim + 3-4 asymmetric spikes | 1.5 R | white core, yellow rim | add | 2 frames, no fade, just gone |
| 2 | Ambient glow | soft round gradient | 4-5 R | orange, low alpha | add | 3 frames, acts as light on floor |
| 3 | Shock arc | thin ring segment (half ring, front) | R | bright orange | add | expands 2-3 frames |
| 4 | Fire core | cel fire flipbook, 2 tones, hard edges | 0.8 R | yellow -> orange -> red over life | add | boils in place |
| 5 | Smoke | cel smoke puffs, 2 tones of near-black | 0.8-1 R | black / dark grey | alpha | appears at 0.1 s inside the fire, rises slightly, outlives it |
| 6 | Scorch | spiky star splat decal | 1.5 R | dark red -> black | alpha | static, fades last |
| 7 | Star sparkles | 4-point stars with short trail | 0.1 R, 6-8 | white | add | thrown up in a cone, decelerate |
| 8 | Embers | dots | tiny | orange | add | short |

## Variants
- Omni (air burst, 55.0): same recipe without the ground; full ring instead of half arc; 2 long spikes; smoke column rises.
- Ice (Floor 50.8, Omni 59.7): cyan-white flash with crystal spikes, white shards instead of fire, the SAME black smoke.
- Hyeon Woo Jang white burst (52.0): flash fills half the screen for 1-2 frames, then a cloud of thin curved streaks,
  grey smoke behind and slow sparks for 0.5 s; same flash-then-residue ratio.

## Why it reads as professional
- Value structure: brightest and darkest values sit side by side (fire inside black smoke), so the core pops even on a
  mid-grey floor.
- Silhouette: asymmetric spikes on the flash and a spiky scorch break the round shape.
- Timing: 2-3 frame peak, then a long dark tail; the eye gets a pop and then a mark.

## Roblox translation (ours)
- Flash: 1 particle, spiky flash texture, LightEmission 1, Lifetime ~0.07, Size fixed (no grow).
- Glow: 1 big soft particle for 2-3 frames + a PointLight tweened from high Brightness to 0 in ~0.1 s.
- Shock arc: flat ring particle or a thin half-ring mesh, scale tween fast-out.
- Fire core: 4x4 cel fire flipbook, ColorSequence yellow -> orange -> red, LightEmission 1.
- Smoke: 4x4 cel smoke flipbook, LightEmission 0, Color near black, ZOffset behind the fire, Lifetime 0.8-1.2.
- Scorch: Decal on a thin flat part (or a flat particle, Orientation VelocityPerpendicular, Speed 0), fade with a tween.
- Sparkles: 4-point star texture, Speed up-cone with Drag, short Trail or Squash for the streak.
- Related: [[Impact burst - flash that breaks into streaks]], [[Endings and residue]], [[Smoke is a volume]],
  [[Value range and dark backing]], [[Flash is huge and brief, residue is long]].
