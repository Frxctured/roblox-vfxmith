---
title: Primary and secondary elements
tags: [vfx, composition, technique]
type: technique
updated: 2026-11-18
source: Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slides 6-7; https://80.lv/articles/vfx-staples-shape-color-and-motion; Ryan Zeng, Shape (A) https://www.youtube.com/watch?v=0wEvAV_R2Rw (24:44-30:08)
---
# Primary and secondary elements

> TL;DR
> - Before building, name ONE primary element (the focal point that carries the gameplay meaning) and list the rest as secondary.
> - Primary = high value range, clear silhouette, strong shape, high opacity, intense movement, strong contrast in value or saturation.
> - Secondary = lower value range, blurrier and simpler shape, small, low opacity, subtle movement; it supports theme and pushes value/saturation of the primary.
> - Secondaries may use more hues and a wider saturation range, because they are not what the eye must find.
> - Roblox translation (ours): the primary is usually one Beam/mesh/flipbook layer; everything else is a particle layer with higher Transparency, smaller Size and slower motion.

## The rule
Riot defines every effect by what the player must find first. Its example (slide 6): a shield that explodes around the caster. The primary element is the shield's border, because players need the radius to avoid the blast; the faint electric energy inside is secondary and only carries the skin's theme. Slide 7 shows the same split on one frame: the glowing ring and the blade-shaped projectile are primary, the trailing sparkles and shards are secondary.

## How to apply (checklist per layer)
- Write one sentence: "the player must notice ___". That layer is primary. If you cannot finish the sentence, the effect has no focus.
- Give the primary the strongest silhouette, highest opacity and the brightest value. Give every secondary less of each, never more.
- 80.lv asks the same per element: how important is it, how much attention should it draw, how does it appear and disappear, does adding it make the effect noisy (see [[Element checklist and blockout first]]).
- A secondary that is as bold as the primary is noise, not richness.

## Roblox translation (ours)
- Primary: the hero Beam, mesh or the largest flipbook emitter; Transparency 0 to 0.2 at peak, Brightness high (see [[Our effects look matte - Brightness and LightEmission vs pros]]).
- Secondary: sparkles, dust, small ember emitters with Transparency 0.5+ and small Size curves.
- Check: take a screenshot, squint; whatever you still see should be the primary.

## Agreement with existing notes
Agrees with [[Value, contrast and glow]] (exactly one dominant bright mass) and [[Character effects - auras and buffs]] (one dominant ground layer plus small accents). Adds the vocabulary of what makes a layer secondary.

## Mixed shape language (Ryan Zeng, Shape A 24:44-30:08)
When an effect carries two themes, the primary theme sets the silhouette and the secondary only decorates it: a sci-fi
shield is a curved dome (protection) with straight hexagon cells mostly at the rim (sci-fi); a magic arrow is a sharp
straight-edged tip (arrow) with curling wisps behind (magic). Splitting the two evenly leaves the effect unfocused.
See [[Straight lines mean danger, curves mean safety]].
