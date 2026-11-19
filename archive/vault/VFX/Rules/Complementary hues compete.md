---
title: Complementary hues compete
tags: [vfx, color, rule, finding]
type: rule
updated: 2026-11-18
source: Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slide 21; https://www.vfxapprentice.com/blog/color-101-vfx-artists; Ryan Zeng, Color (A), https://www.youtube.com/watch?v=_t4Wvqs2Nyo (12:04-22:15)
---
# Complementary hues compete

> TL;DR
> - Two complementary colours in one effect always fight to be primary, even at different value levels.
> - Ideal is analogous colours; if there are two opposites, one must be demoted to secondary.
> - Demote by desaturating it and giving it low opacity, so it adds richness without competing (Bard Q: dull purple under bright yellow).
> - Bad case: Lulu shield with high-saturation, high-opacity opposites everywhere reads as noise.
> - Roblox translation (ours): ColorSequence with one hue family; a complement only in a small, low-opacity, desaturated layer.

## The rule
Slide 21 sets three complementary pairs (red/green, yellow/purple, orange/blue) as examples of what fights. The negative example is a sparkly shield with every pair at full strength; the positive example is a golden-orange comet with a faint dull violet around it.

## Why
Opposites on the wheel maximise hue contrast, so the eye goes to whichever is more saturated or bigger. If both are strong, nothing is primary. VFX Apprentice defines complementary pairs as opposites on the wheel with strong contrast and interest, which is the same property that causes the fight.

## Recipe
1. Choose a hero hue family (neighbours on the wheel).
2. Choose at most one accent from the opposite side. Make it lower saturation, lower opacity, smaller area than the hero.
3. Keep the accent out of the focal point.

## Roblox translation (ours)
Hero: Color3 near hue H, saturation 0.7-1. Accent: hue H+180 degrees, saturation about half, Transparency at least 0.4, in a layer behind or at the edge. UNVERIFIED: the saturation ratio is our guess.

## Agreement
Matches the 'hue shifted 30-50 degrees' accent in [[Character effects - auras and buffs]] (analogous-to-split, not full complement) and the human preference for bold saturated colour in [[AI review panels disagree with humans]]: bold is fine, but one hero.

## Ryan Zeng's view (_t4Wvqs2Nyo 12:04-22:15)
Agrees that a straight complement is the strongest, most clashing contrast and that one side must win. Adds two ways out:
- Split it: use the two hues 40-60 degrees either side of the opposite instead of the opposite itself (WoW Azerite Breath: yellow head, blue and violet body, 19:49-22:15). The contrast stays, the clash goes.
- Separate it in time/space: the complement lives in the remnant (tail, dissipation), the hero hue at the head. The yellow projectile goes 60 -> 34 -> 359 -> 326 -> 282 degrees head to tail, with lightness 82 -> 13, so the purple never competes.
In both cases the accent wins by value, not area: the yellow head is a few percent of the pixels.
Roblox translation (ours): put the complement at the END of the ColorSequence (key 0.7-1, low lightness) rather than in a parallel layer; see [[Colour travels from attention hue to dissipation hue]].
