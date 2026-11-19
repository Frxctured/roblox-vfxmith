---
title: Pro reference reels vs AI-built effects
tags: [vfx, quality-bar, composition, layers, texture, timing, finding]
type: finding
updated: 2026-11-18
source: owner-chosen quality bar reels: Vefects https://youtu.be/fOTL1CtnZ58, Hyeon Woo Jang https://youtu.be/jfjR8ybC1O0, Tommy https://youtu.be/ijO35e3KBMI, Pawel Margacz https://youtu.be/Yyptp7OuCGI; study _vfx_os_library/tutorials/REFERENCES_STUDY.md (2026-11-18); comparison against our past tests in [[vfxmith 0.1.x blind test history]]
---
# Pro reference reels vs AI-built effects

> TL;DR
> - Dark partners: almost every bright layer in the reels has a dark alpha layer beside or behind it (black smoke in fire, dark twin arcs, black crack decals). Our builds are nearly all additive light.
> - Timing ratio: a huge 2-3 frame flash, then a long dark residue (0.6-1.5 s). Ours keep a moderate flash and fade every layer together.
> - Shapes: big shapes are hard-edged 2-tone cel shapes with asymmetric spikes; softness lives only in a separate glow layer. Ours default to soft round gradients.
> - Lines: many hair-thin lines (rays, dashes, dotted rings, tracers) give detail; ours use fewer, fatter streaks and trails.
> - Ground anchor and break-up endings: every effect touches the floor (pool, scorch, cracks, ripples) and ends by fragmenting, not fading.

## Layer count
Hero impacts in the reels have 7-10 distinct layers (E2 explosion: flash, glow, shock arc, fire, smoke, scorch, star
sparkles, embers). Each layer has ONE job and a different lifetime, so the effect changes character 3-4 times in half
a second (flash -> fire+arc -> sparkles -> smoke+scorch). The number is less important than the fact that the layers
belong to three families: soft glow, hard cel shapes, tiny bright accents (dots, 4-point stars, dashes), plus one dark family.

## What our past effects lacked (from test history and owner feedback)
- Dark layers: see [[Value range and dark backing]] and [[Our effects look matte - Brightness and LightEmission vs pros]].
- Hand-made shapes: [[Code-made assets look generic]] (plain arcs, centre-fade circles).
- Residue: [[Endings and residue]] (frost removed too early in 0.1.6).

## The other lessons, each with its own note
- [[Flash is huge and brief, residue is long]]
- [[Hard cel shapes, softness only in the glow layer]]
- [[Every pro effect is anchored to the ground]]
- [[Effects dissolve by breaking up]]
- Accent hue: ~85/15 main hue vs complementary accent (magenta + yellow sparks, gold + blue crackles, fire + blue sparks),
  and a neutral alpha layer (grey wind arcs, white smoke) in coloured effects. See [[Complementary hues compete]] for the
  limit: the accent stays small.

## Per-effect breakdowns
[[Stylized ground explosion - reference breakdown]], [[Energy dome burst - reference breakdown]],
[[Ground smash with crack decal - reference breakdown]], [[Slash with a dark twin - reference breakdown]],
[[Small projectile with cast flare - reference breakdown]], [[Ground circle and vortex AoE - reference breakdown]],
[[Lightning strike - reference breakdown]], [[Buff and debuff cast icons - reference breakdown]],
[[Shield sphere - reference breakdown]], [[Elemental aura skeleton - reference breakdown]],
[[Elemental weapon swing - reference breakdown]].

## Roblox translation (ours)
- Give every spec a checklist line per family: glow / cel shape / accents / dark layer / ground anchor / residue.
- Dark layers in Roblox: LightEmission 0 and a dark Color on a normal (alpha) particle; they must render behind the
  bright ones (ZOffset), otherwise they dirty the glow.
