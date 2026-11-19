---
title: Effects dissolve by breaking up
tags: [vfx, dissipation, ending, break-up, timing, finding]
type: finding
updated: 2026-11-18
source: Vefects https://youtu.be/fOTL1CtnZ58 (Bomb 13.73-14.10, Slash 8.84-9.13, Debuff 35.6-36.2); Hyeon Woo Jang https://youtu.be/jfjR8ybC1O0 (cracks 6.75-7.40, frost carpet 70-72); Tommy https://youtu.be/ijO35e3KBMI (fire axe 48.31-48.55, bubble 28.1-28.6); study _vfx_os_library/tutorials/REFERENCES_STUDY.md
---
# Effects dissolve by breaking up

> TL;DR
> - In the reels big shapes almost never fade uniformly; they erode, thin or fragment.
> - Patterns: noise erosion from inside (dome), thinning to a line then dashes (rings, shells), splitting into pieces along the path (slashes, flame crescents), carpets dissolving from the edges, glow draining before the dark base (cracks).
> - The break-up spawns new small elements (dashes, tongues, droplets), so the effect stays busy while it shrinks.
> - A uniform alpha fade is used only on soft layers (glow pools, smoke).

## Examples
| Effect | How it ends |
|---|---|
| V Bomb dome | inside eroded by noise -> rim shell -> thin line -> dashes (13.73-14.10) |
| V Slash | crescent -> row of short dashes along the arc (8.99) |
| H cracks | glow drains, black cracks break into fragments (6.75-7.40) |
| H frost carpet | dissolves from its edges inward (70-72) |
| T fire axe | flame crescent splits into separate tongues along the arc (48.31) |
| T water bubble | white flash -> cel droplets + floor ripple rings (28.1-28.6) |

## Roblox translation (ours)
- Roblox has no dissolve shader on meshes or particles. Fake it with: (a) flipbooks whose last frames break up,
  (b) a second emitter that spawns fragments along the shape as the main layer dies (dashes along an arc, droplets
  at a rim), (c) Size curves that thin a ring (Squash or a ring texture with a thinner variant).
- Matches [[Endings and residue]] ("break in one frame into pieces") and [[Energy dome burst - reference breakdown]].
