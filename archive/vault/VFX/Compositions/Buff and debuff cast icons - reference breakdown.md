---
title: Buff and debuff cast icons - reference breakdown
tags: [vfx, buff, debuff, heal, status, icon, composition, reference]
type: composition
updated: 2026-11-18
source: Vefects https://youtu.be/fOTL1CtnZ58 (Buff Cast 19.1-20.3, Buff Loop 25-29, Debuff Cast 35.5-36.3, Debuff Loop 40.7-44.8, Heal Cast 83.2-84.1, Pickup Cast 98.9-100.4); study _vfx_os_library/tutorials/REFERENCES_STUDY.md E8
---
# Buff and debuff cast icons - reference breakdown

> TL;DR
> - Status casts are an ICON effect: a solid 2-tone symbol (up-chevron for buff, down-chevron for debuff) with a disc glow behind it and a thin ring around it.
> - The debuff uses the same parts as the buff but in DARK alpha layers (navy chevron, dark smoke puffs, dark arcs swirling out): "bad" reads by value, not hue.
> - Accents are few 4-point white star sparkles that pop on the ring rim and drift up.
> - Cast is ~0.3 s of pop; then the icon shrinks to a small symbol that holds ~0.6 s; loops are dim and sparse.

## Layers (Buff Cast)
| Layer | Shape | Colour / value | Blend | Motion |
|---|---|---|---|---|
| Icon | solid chevron, 2 tones + white highlight | gold, white | add/opaque | pops in, shrinks to a small red chevron |
| Disc | soft round glow | red | add | behind the icon, fades |
| Ring | thin circle | gold | add | pops to size, fades |
| Stars | 4-point stars, 4-6 | white | add | pop on the rim, drift up, shrink |

## Debuff, heal, pickup
- Debuff: dark navy chevron with a lighter edge, grey-white alpha smoke puffs, dark grey thin ring, dark arcs swirling
  OUT of the ring; almost no glow at all.
- Heal: green ring, thin vertical streaks rising inside it, small sparkles; loop = small green glow with motes.
- Pickup: warm orb with a ring that pops and shrinks; loop = small steady orb with a slow ring.

## Roblox translation (ours)
- One attachment over the head; one ParticleEmitter per layer, emit counts 1 (icon, disc, ring) and 4-6 (stars).
- Icon: a custom icon texture on a particle (no BillboardGui needed), Size keyframes pop -> settle -> shrink.
- Debuff: same emitters with LightEmission 0 and dark Colors; add a dark smoke flipbook.
- Related: [[Character effects - auras and buffs]], [[Value range and dark backing]].
