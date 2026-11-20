---
title: Short lingering outros
tags: [vfx, timing, dissipation, rule]
type: rule
updated: 2026-11-18
source: Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slides 32, 36
---
# Short lingering outros

> TL;DR
> - An outro is a secondary effect: lower value, lower saturation, lower opacity than the main moment.
> - Riot deliberately minimises how long an effect stays on screen to cut visual noise in team fights.
> - Bad (slide 36): Snow Day Syndra W is intensely opaque and lingers; good: Justicar Syndra W fades fast and is slightly transparent even at its peak.
> - Fading energy can be expressed by changing value, hue, saturation, opacity or size.
> - Roblox translation (ours): in busy scenes or repeated abilities cut the linger; keep long residue only for one-shot cinematic or ground marks.

## The rule
Slide 36 puts two ground effects side by side. The blue splat is saturated and fully opaque and sits there; the golden burst has a smoky, partially transparent halo and is already thinning. The guide says the first would dominate other effects in the same area.

## Fade dials (slide 32)
Value down, saturation down, hue toward a cooler or duller tone, opacity down, size down; combine two or three, do not only fade opacity.

## Tension and reconciliation with existing notes
[[Endings and residue]] says residue holds at 90% or more until about 80% of its linger, then fades softly. Riot's guide wants lingering minimised, because League has ten players casting at once. In most Roblox games only a few effects overlap, so our longer residue is acceptable for hero moments; for repeating, spammable abilities use Riot's short outros. UNVERIFIED which better matches the owner's taste; ask when a test shows both.

## Roblox translation (ours)
Last 30-40% of a layer's life: NumberSequence Transparency rises to 1, Size shrinks 10-30%, Color toward darker hue family; kill emitters on Lifetime rather than letting Rate=0 trail off. Add a per-effect 'linger' budget in the spec.
