---
title: Elemental weapon swing - reference breakdown
tags: [vfx, fire, nature, swing, weapon, slash, composition, reference]
type: composition
updated: 2026-11-18
source: Tommy "Unity VFX" https://youtu.be/ijO35e3KBMI (fire axe 47.6-50.2, axe fire tornado 98.4-101.8, thorn vines 32.3-37.0); study _vfx_os_library/tutorials/REFERENCES_STUDY.md E10
---
# Elemental weapon swing - reference breakdown

> TL;DR
> - The swing crescent is made of the element itself (cel flame body, orange rim) and it BREAKS UP into separate flame tongues along the arc instead of fading.
> - Impact: a fan of element spikes plus a ground line of fire running forward; dark smoke tufts sit on the far side of the fire.
> - Every coloured effect has a neutral alpha layer that carries the motion: grey-white wind arcs, white cel smoke puffs (not green) at the vine roots.
> - A complementary accent hue appears in small amounts (blue sparks inside the fire tornado).
> - Residue: burnt dark ground patch with embers, small flames lingering ~1 s.

## T fire axe (47.6-50.2)
| Time | Beat |
|---|---|
| 47.6-47.8 | axe head on fire (small flame flipbook), embers scattered from the previous swing |
| 48.07 | swing crescent of cel flame, bright yellow body, orange rim, hard edges |
| 48.31-48.55 | crescent breaks into flame tongues scattered along the arc |
| 48.78 | impact: fan of flame spikes, ground fire line forward, dark smoke tufts |
| 49.0-50.2 | fire line burns down into embers and small flames |

## T thorn vines (32.3-37.0)
- Wind-up: a green ring trail around the staff hand.
- Vines with thorns rise from glowing ground cracks; bright green slash lines cross them; grey alpha wind arcs sweep
  behind; finish = white cel smoke puffs at the roots, green motes drifting up.

## T axe fire tornado (98.4-101.8)
- Long cel flame ribbons spiralling up, a bright ground disc, blue spark accents, radial speed lines on the ground;
  ends with flame blobs scattered around the character and a dark burnt patch.

## Roblox translation (ours)
- Flame crescent: slash flipbook in cel-flame style on a tilted plane, plus flame particles emitted along the arc that
  live longer than the crescent (the break-up).
- Ground fire line: a row of flame flipbook particles from a moving attachment, dark smoke particles behind.
- Neutral wind arcs: alpha crescent particles with grey-white Color, LightEmission 0.
- Related: [[Cartoon fire from inner and outer flame flipbooks]], [[Slash with a dark twin - reference breakdown]].
