---
title: Core push and illumination
tags: [vfx, glow, value, technique]
type: technique
updated: 2026-11-18
source: Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slides 15-16
---
# Core push and illumination

> TL;DR
> - Push the brightest value to the centre of a magical effect; a bomb with no bright centre falls into the background (slide 15).
> - Adding a simple glow turns a flat shape into 'magic'; the same green sigil with and without glow looks dead versus alive (slide 16).
> - Glow also communicates motion, direction and duration, not only beauty.
> - Glow is a separate soft layer behind the hard shape, not extra brightness on the shape itself.
> - Roblox translation (ours): one hard sprite/mesh plus one soft additive glow sprite, 1.5-2x its size, behind it.

## Slide 15: the bomb
Two versions of the same blue bomb. The bad one is evenly mid-blue, the good one has a white-blue hot centre, a purple secondary swirl around it and a few bright specks. The caption: pushing the value to the centre makes players notice the spell in a team fight.

## Slide 16: the sigil
The bad one is dark green with a dim ring. The good one adds a soft light wash over the whole thing plus small bright particles; the ring reads as lit. Riot's point is that illumination is what expresses the magical nature.

## How
1. Hard layer: the actual shape, medium value, clear silhouette.
2. Glow layer: same position, bigger, soft round texture, additive, lower opacity.
3. Hot core: tiny bright sprite at the centre, hue shifted slightly (see [[Value, contrast and glow]]).
4. Specks: a few small bright particles orbiting; they carry the 'energy'.

## Roblox translation (ours)
Glow layer = ParticleEmitter with a soft radial texture, LightEmission 1, Size 1.5-2x of the hard layer, Transparency 0.4-0.7. UNVERIFIED: exact ratio; take from the library's measured effects. Do not also raise a PointLight beyond the limits in [[Value, contrast and glow]].
