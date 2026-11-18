---
title: Lightning strike - reference breakdown
tags: [vfx, lightning, bolt, strike, telegraph, composition, reference]
type: composition
updated: 2026-11-18
source: Vefects https://youtu.be/fOTL1CtnZ58 (Lightning 91.0-97.8); Tommy "Unity VFX" https://youtu.be/ijO35e3KBMI (lightning summon 54.6-58.0); study _vfx_os_library/tutorials/REFERENCES_STUDY.md E7
---
# Lightning strike - reference breakdown

> TL;DR
> - Bolts are brief (2-3 frames) and thin with a white core; the read comes from the GROUND contact: splash flash, wide floor glow pool and crawling cracks.
> - Telegraph: a thin ground ring marks the target ~1 s before the strike while the source orb charges with a 4-point lens flare.
> - Impact: a white flash dome with 3-4 triangular spikes and a floor glow 3x its size, then element shards and curly wisps at ground level.
> - Hero version: forked bolts from body to floor, RGB chromatic split on the bolts, and branching ground cracks that crawl outward and fade over 0.6 s.

## V Lightning beats (95.9-97.8)
| Time | Beat |
|---|---|
| 96.1-96.9 | purple orb with 4-point flare charges in the air; thin ring on the ground (telegraph) |
| 97.06 | one thin jagged bolt, white core, orb -> ring |
| 97.15 | white flash dome with spikes; wide purple floor glow |
| 97.23-97.31 | shards burst, half shock arc |
| 97.39-97.80 | curly white wisps and 4-point sparkles at ground level; short vertical light shaft fades |

## T lightning summon (54.6-58.0)
- Character lifts; forked bolts arc from the body to the floor, each ending in a bright splash; a huge diagonal beam
  enters from off screen; vertical bolts rain down with red/cyan chromatic fringes; a white-blue ground pool;
  residue = branching glowing cracks crawling outward.

## Roblox translation (ours)
- Bolt: Beam with a jagged bolt texture, texture swapped or offset every frame, Lifetime 2-3 frames; or several short
  Beams between jittered attachments.
- Ground splash: flash particle + PointLight burst; floor glow = big flat soft particle.
- Cracks: flat crack flipbook that grows, or Decals scaled up then faded.
- Chromatic split: two extra Beams in red and cyan offset by a few studs' fraction (UNVERIFIED how it reads at Roblox scale).
- Related: [[Ground smash with crack decal - reference breakdown]], [[Telegraphs that show the true area]].
