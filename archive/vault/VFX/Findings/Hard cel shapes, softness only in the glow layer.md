---
title: Hard cel shapes, softness only in the glow layer
tags: [vfx, texture, shape, stylized, cel, finding]
type: finding
updated: 2026-11-18
source: Vefects https://youtu.be/fOTL1CtnZ58 (Fire Floor 47.05-47.45, Bomb 13.73-13.87, Buff 19.3-19.6); Tommy https://youtu.be/ijO35e3KBMI (fire axe 48.07-48.78, water splash 93.6-96.2); Hyeon Woo Jang https://youtu.be/jfjR8ybC1O0 (hammer 5.87); study _vfx_os_library/tutorials/REFERENCES_STUDY.md
---
# Hard cel shapes, softness only in the glow layer

> TL;DR
> - In all four reels the big shapes (fire, smoke, water, dome erosion, slashes, icons) are hard-edged cel shapes with 2 tones: a light core and a darker rim.
> - Softness is a SEPARATE layer: a soft additive glow disc behind or around the hard shape, never a soft edge on the shape itself.
> - Silhouettes are asymmetric: 3-4 spikes of different length on a flash, jagged erosion edges, spiky scorch splats.
> - Fine detail comes from many tiny hard accents (4-point stars, dashes, dots), not from noise inside big shapes.
> - Hand-made look = clear big shape + 2 tones + uneven edge; generic look = round gradient that fades from the centre.

## Examples
- Fire core (V Fire Floor): yellow body, orange shadow shapes, hard edges; smoke is black with a dark grey inner tone.
- Water (T splash): cyan blobs with a white edge band, flat fill, no gradient.
- Dome erosion (V Bomb): holes are cel noise blobs, big and small, with sharp edges.
- Slash (T fire axe): flame crescent with a hard outer edge that splits into separate tongues.
- Icons (V buff): solid chevron, 2 tones + one white highlight shape.

## Relation to other notes
Extends [[Soft and sharp texture shape language]] (Riot: big readable shapes, soft and sharp mixed) and explains why
[[Code-made assets look generic]] (centre-fade circles are the "soft shape" mistake). Pro shapes are still not photos:
[[Cartoon fire from inner and outer flame flipbooks]] is the Roblox version of the 2-tone fire.

## Roblox translation (ours)
- Pick or make textures with a hard alpha edge and a 2-tone fill (alpha cutoff look), then add one soft glow particle
  behind them instead of blurring the texture.
- Flipbooks (4x4 or 8x8) give the boiling cel motion; a single static soft sprite cannot.
- Texture budget: Roblox particle textures are capped at 1024 px per side (from vault notes, UNVERIFIED for flipbooks);
  an 8x8 flipbook at 1024 gives 128 px cells, enough for cel shapes because they have no fine noise.
