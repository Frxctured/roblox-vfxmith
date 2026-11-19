---
title: Colour travels from attention hue to dissipation hue
tags: [vfx, color, timing, trails, finding]
type: finding
updated: 2026-11-18
source: Ryan Zeng, Real-Time VFX Visual Design - Color (A), https://www.youtube.com/watch?v=_t4Wvqs2Nyo (15:17-26:30); values sampled from his gradient bars (frames t00958.5, t01380.0; study.md in tutorials/color__t4Wvqs2Nyo)
---
# Colour travels from attention hue to dissipation hue

> TL;DR
> - Over an effect's life (or along a trail, head to tail) colour moves from a high-attention colour to a low-attention one, then disappears.
> - High attention = bright, warm or light (red, yellow-white, sky blue) at the head/core; low attention = dark, still saturated, usually purple/violet at the tail/edge.
> - The hue may travel up to about 90 degrees (inside the 120-degree analogous range), or cross to a split complement; the drop in lightness (L ~45-80 down to ~10) carries the phase more than the hue.
> - Three differently coloured projectiles all ended in the same dark purple (hue 280-316, L 10-13): the head colour is the identity, the dissipation colour can be shared.
> - Roblox translation (ours): ColorSequence over Lifetime (or Trail/Beam Color head->tail) = hot tint -> theme hue -> dark saturated purple; with LightEmission 1 the dark end fades by itself.

## Evidence
Etienne POV's projectile in three colourings (15:17-19:38). Sampled HSL tail <- head:
- Red (analogous): 348 S100 L43 at the head -> 333 L30 -> 301 L17 -> 279 L10.
- Yellow (split complementary): 60 S100 L82 -> 34 L74 -> 359 L55 -> 326 L26 -> 282 L13.
- Blue (analogous): 178 S100 L74 -> 216 L61 -> 266 L29 -> 316 L10.
Zeng: put the eye-catching colour "in the front of the attack" and use "darker colors, low eye-catching colors" for the dissipation (19:02-19:25). In Sarah Carmody's WoW Azerite Breath the yellow head is a tiny area yet holds the eye at speed; the blue-violet body is large, soft and "ready dissipating, so do not want to use too strong colors" (21:32).

## Monochromatic version
In Sakthivel Radhakrishna's portals (22:29-26:30) the same rule runs from the energy centre outward: core near-white with the hue nudged warm (red set: core hue 36, edge 0), edge high saturation and L 4-20. Zeng: without the small hue shift the effect has "no colour contrast, no visual focus" (24:07). His range is +/-15 degrees; my samples show 36-42 degrees across the ramp (UNVERIFIED, JPEG and glow).

## Why it works
Attention follows lightness and saturation; putting the brightest, most saturated value at the leading point tells the player where the effect is and where it goes, while the remnant still shows the energy's path without competing. It is the colour form of [[Anticipation, climax and dissipation]] and the time form of [[Complementary hues compete]] (the complement is allowed, but in the remnant).

## Roblox translation (ours)
- Particle: ColorSequence keys (0, near-white tinted toward the hot hue), (0.15-0.25, theme hue full saturation), (1, Color3.fromHSV(0.8, 0.85, 0.12)) for a shared dark purple remnant. Brightness 2-4 at birth comes from the emitter, the sequence darkens it.
- Trail/Beam: Attachment0 = head (hot), Attachment1 = tail (dark purple), Transparency rising toward the tail.
- Skin sets / rarities: change only the head hue per skin, keep the shared remnant colour so the set reads as one family ([[One style family per game]]).
- UNVERIFIED in game: on bright backgrounds (sand zone) a dark additive tail vanishes early; check on dark and light backdrops ([[Colour context and depth shift]]).
