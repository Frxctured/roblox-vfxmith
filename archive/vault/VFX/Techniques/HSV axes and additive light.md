---
title: HSV axes and additive light
tags: [vfx, color, theory, technique]
type: technique
updated: 2026-11-18
source: https://www.vfxapprentice.com/blog/color-101-vfx-artists; https://80.lv/articles/vfx-staples-shape-color-and-motion; https://www.youtube.com/watch?v=pAK0cvVQr_4 (Draw like a Sir, colour theory, 2:50-8:40); Ryan Zeng, Color (A), https://www.youtube.com/watch?v=_t4Wvqs2Nyo (7:36-15:07)
---
# HSV axes and additive light

> TL;DR
> - Think in hue, saturation, value as three separate dials; value is brightness from black to white, saturation is purity.
> - Screens add light: mixed light colours get brighter, unlike paint, so overlapping additive layers brighten rather than muddy.
> - Change one dial at a time when fixing colour: wrong mood = hue, washed out = saturation, flat = value.
> - Warm (red, yellow) reads energetic, cool (blue, green) calm or cold; use it for state.
> - Roblox translation (ours): Color3.fromHSV and LightEmission 1 are the dials; stacked additive sprites sum toward white.

## Source points
Dave Shovlin's lesson (VFX Apprentice) stresses three axes in any engine colour picker: hue (which wavelength shade), saturation (vibrance), value (dark to bright). It also notes that monitors add light to black, so secondary colours come out brighter than the primaries, the opposite of paint.

## What that means for effects
- Additive blending (Roblox LightEmission 1) behaves as light: red + green overlap goes yellow, everything overlapping goes white. Over-stacking drives a layer to white; see [[Our effects look matte - Brightness and LightEmission vs pros]] for the opposite failure.
- To fix a dull colour, raise saturation first; to give shine, raise value; only then change hue.
- Match intensity to the dial: Riot lowers value, saturation and opacity together for outros ([[Short lingering outros]]).
- Warm/cool: the article ties warm to energy and cool to calm; 80.lv ties colour to the school of magic (ice blue and white, fire red and orange).

## Roblox translation (ours)
Build ColorSequences with Color3.fromHSV(h, s, v) keyframes: start high s and v at birth, drop v and s toward death. Keep hue drift small (under 30 degrees) unless the effect is meant to change element.

## Note
The article is theory-heavy; no numeric thresholds. Hex-level palette advice is in [[Magic-school palettes and team colour]].

## Colour harmony schemes (Draw like a Sir, pAK0cvVQr_4)
Pick a scheme before choosing Color3 values; it answers "what mood".
- Monochromatic (5:17): one hue, vary value and saturation only. Easiest to read; good for one-element effects (ice, void).
- Analogous (5:48): neighbouring hues; harmonic and calm; our default ColorSequence (e.g. orange to yellow to white for fire).
- Complementary (6:24): opposite hues for contrast, risky ("birthday card"); use to make ONE thing pop (gold core in blue magic), keep the other side small, desaturated and low-opacity ([[Complementary hues compete]]).
- Triad (7:02): hard, the artist usually lets one hue dominate and puts the other two in small areas or the background. For effects: only across a whole scene, not inside one effect.
- Saturation warning (3:43): maxing saturation on every layer looks amateurish; keep the highest saturation in the core, lower in smoke/dust/trails.
Roblox translation (ours): write the scheme name and 1-3 hues in the effect spec; build ColorSequences from it with Color3.fromHSV.

## Harmonies as degree ranges (Ryan Zeng, _t4Wvqs2Nyo 7:36-15:07)
Zeng agrees with the schemes above and turns them into numbers a non-colourist can follow ("you can use the logical thinking", 14:42):
- Monochromatic = main hue +/-15 degrees (one 30-degree block of the 12-colour wheel). Do not lock one exact hue: a small drift inside the block looks refined even if nobody notices it (8:52-9:34).
- Analogous = +/-60 degrees (a third of the wheel, because the primaries sit 120 degrees apart). From red: yellow ok, green too far; pink ok, blue too far.
- Complementary = 180 degrees; any hue within +/-60 of the opposite still works as the contrast, softer the further it sits from the exact opposite.
- Split complementary = cut that 120-degree opposite range in three, drop the middle block, use the two outer ones.
Where he adds something: hue is allowed to TRAVEL along a ramp up to ~90 degrees (analogous) when lightness falls with it, so our "under 30 degrees" above is right for a single layer's identity, too tight for a head-to-tail trail. See [[Colour travels from attention hue to dissipation hue]].
Roblox translation (ours): store the scheme as a base hue H plus allowed offsets (mono +/-0.04, analogous +/-0.17, in Color3.fromHSV units) and generate ColorSequence keys only from inside them.
