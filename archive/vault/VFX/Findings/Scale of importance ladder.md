---
title: Scale of importance ladder
tags: [vfx, gameplay, scale, finding]
type: finding
updated: 2026-11-18
source: Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slides 10-11
---
# Scale of importance ladder

> TL;DR
> - A basic attack must always look quieter than an ultimate; if they are equally loud both lose, and the ultimate stops feeling special.
> - Importance is dialled with six knobs: size, shape, timing, value, saturation, opacity.
> - Ladder, quietest to loudest: idle particle, basic attack, defensive spell, damage spell, game changer, ultimate.
> - Defensive/idle things are low saturation, low opacity, blurry, subtle; damage and above go high saturation, high opacity, clear silhouette; the ultimate adds largest size and an impactful animation.
> - Roblox translation (ours): tag each effect with its tier first, then pick Transparency, saturation and Size from the tier, not from taste.

## What the slide shows
Slide 11 lines up six real effects across one frame from left to right and lists the dials per tier. Reading the pictures: the idle orbs and the basic-attack streak are small and pale, the defensive shield is a soft low-saturation bubble, the damage spell is a bright opaque crescent, the game changer is a saturated golden sphere with a clear outline, and the ultimate is the biggest, brightest and most saturated thing in the frame.

## Ladder in numbers-free form
| Tier | Size | Saturation | Opacity | Shape | Motion |
|---|---|---|---|---|---|
| Idle particle | tiny | low | low | blurry | subtle |
| Basic attack | small | normal | normal | clear | quick |
| Defensive spell | medium | low | low | blurry | subtle |
| Damage spell | medium | high | high | clear | strong |
| Game changer | large | high | high | clear, wide value range | intense |
| Ultimate | largest | highest | highest | clear, widest value range | impactful animation |

(The table merges slide 11's bullet lists; the guide gives no numbers.)

## Why it matters for us
Our builds tend to make everything medium-loud. A shield in the guide is deliberately quieter than a damage spell because it is not the thing the viewer should fear. Pick the tier before the colour.

## Roblox translation (ours)
Use the tier to set peak Transparency (idle 0.7+, ultimate 0 to 0.1), emitter count, Size relative to character height (see [[Size effects against the character]]) and Brightness. UNVERIFIED: exact Roblox values per tier are ours to test; the source gives only the ordering.
