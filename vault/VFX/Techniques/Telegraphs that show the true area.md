---
title: Telegraphs that show the true area
tags: [vfx, gameplay, telegraph, technique]
type: technique
updated: 2026-11-18
source: Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slides 8-9; https://80.lv/articles/from-realism-to-stylization-game-vfx-production; Ryan Zeng, Shape (B) https://www.youtube.com/watch?v=rpttR9r8_BE (00:00-04:28)
---
# Telegraphs that show the true area

> TL;DR
> - If an effect has a gameplay radius or box, the visual must cover exactly that, not more and not less.
> - Bad: an explosion visual covering half the real radius with no ring (Teemo mushroom); an ultimate drawn wider than its hit box (old Sona).
> - Good: a subtle ring showing the true radius; a clear rectangle outline for the box (DJ Sona).
> - Draw ground-based areas at ground level so the camera angle cannot shift where they appear to be.
> - Roblox translation (ours): a ground ring/box sized from the actual hit radius in the server constants, not eyeballed.

## Evidence
Slide 8: Teemo's mushroom blast was about 600 units across but the explosion only filled half of it and no indicator existed; the replacement draws a subtle ring plus a blast matched to it. Slide 9: old Sona sent orange crescents farther than the hit box, so near-misses looked like hits; DJ Sona shows a zig-zag inside an outlined rectangle drawn on the ground.

## Anticipation indicators
80.lv's Meteor Strike: a filling area indicator shows when and in what radius the hit comes; timing adjustable from 0.5 s to 2 s by the spell setting, and the hit plays only when the game logic fires a HIT trigger. Riot's Sion Q (slide 32) shows a visual timer that fills until full range.

## How
- Read the gameplay constant (radius, width, length) and build the visual from it.
- Border is the primary element, fill is secondary ([[Primary and secondary elements]]).
- Indicator fill progress = time left, so players can react.
- Draw flat on the ground plane, relative to the caster ([[Build effects in the caster's space]]), not billboarded.

## Roblox translation (ours)
A flat Part/Beam ring or a decal-textured disc at Y = ground; radius = constant from config. Examples: an enemy's chase radius, a danger zone, meteor impacts; all need an honest ring. UNVERIFIED: how we expose hit sizes to the effect builder; this needs a plugin input.

## The effect's own silhouette as the telegraph (Ryan Zeng, Shape B 00:00-04:28)
Zeng shows God of War, Valorant and Monster Hunter areas drawn by the effect itself: a fire blast whose dense bright
middle matches the hit area (ragged tongues and sparks poke a little past it), a line of lightning pillars, a fire
wall, a breath cone. His point: an outlined square or circle is out of the game world and breaks immersion; a fire line
or a lightning line that IS the area stays in the world and is still exact. For us: where a clean ring is not needed
(cartoon hazards), shape the hazard's dense mass to the hit size and use the ring only for slow, dodgeable warnings.
