---
title: Effect colour out-ranges its character
tags: [vfx, color, character, finding]
type: finding
updated: 2026-11-18
source: Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slide 20
---
# Effect colour out-ranges its character

> TL;DR
> - A champion's VFX uses a higher and wider range of value and saturation than the champion's own model palette.
> - The model palette is muted and earthy; the effect palette keeps the same hue family but is brighter and more saturated.
> - So effect and character match in hue but the effect always wins the eye.
> - Roblox translation (ours): pull the effect hue from the avatar/tool, then raise saturation and brightness; never match the character's exact values.

## What slide 20 shows
Two colour wheels per skin. Kayle: the model is blue and gold with darks; the VFX wheel is pale yellow, white and light gold, brighter and cleaner. Braum: the model is brown and red; the VFX wheel adds a vivid yellow-orange and red. In both cases the hue family is shared but the effect palette extends further towards light and saturation.

## Use
- Sample the character's two main hues, keep the family, and pick effect colours brighter than anything on the model.
- That gives cohesion (it belongs to this character) plus separation (it is not mistaken for armour or clothing).
- A Roblox avatar is often very saturated already (bright classic colours). There, push value (lighter, glowing) rather than saturation. UNVERIFIED for Roblox avatars; the source only shows a realistic-stylised game.

## Links
Related: [[Character effects - auras and buffs]] (accent hue shifted 30-50 degrees, ours) and [[Value, contrast and glow]]. Riot's slide supports sharing a hue family with the character for the main body of the effect; the accent shift is our own refinement.
