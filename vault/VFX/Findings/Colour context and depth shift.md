---
title: Colour context and depth shift
tags: [vfx, colour, depth, finding]
type: finding
updated: 2026-11-18
source: https://www.youtube.com/watch?v=pAK0cvVQr_4 (Draw like a Sir, colour theory, 9:03-13:38)
---
# Colour context and depth shift

> TL;DR
> - The same colour looks different on different backgrounds: judge an effect only on its real background.
> - Aerial perspective: farther things shift their hue toward the background/sky colour, get less saturated and lighter; nearer things keep true hue, more saturation, darker.
> - It is a shift, not a recolour (a brown trunk goes slightly greenish, not blue).
> - Things that skip it "stick out" and do not belong to the picture; characters should pick up a hint of the environment tint too.
> - Roblox translation (ours): test on 2 or more real backdrops, use Atmosphere and distance-based dimming for far effects, keep near/foreground effects the most saturated and darkest.

## What the video shows
- Colour context (9:03-9:47): a red nearly vanishes on one background and pops on another; skin looks dark on white, pale once the rest is coloured.
- Aerial perspective (9:47-12:15): trees further back go bluer, less saturated, lighter; reverse for the foreground (11:28-12:02). A palm tree with plain colours in the blue scene sticks out (12:59-13:19); a dark, saturated foreground palm works (13:19-13:38).
- Characters take the environment tint too (10:39-11:13): "blending into the environment".

## Roblox translation (ours)
- Capture each effect on at least two real zone backdrops (green Meadow, yellow Sand, dark black-hole area); an orange effect that glows on night blue can vanish on sand. Adjust value/saturation, not just hue.
- Far effects (distant meteors, backdrop skins): lower saturation, raise brightness slightly toward the Atmosphere Color, or raise Transparency with distance; Atmosphere Haze/Decay does it for parts.
- Near/foreground effects: full hue, highest saturation, darker values, highest contrast, as the primary ([[Primary and secondary elements]]).
- Hero effects deliberately break this (the Sun must out-range its scene: [[Effect colour out-ranges its character]]); apply it to secondary and scenic layers.
- UNVERIFIED in game; additive glow brightens rather than desaturates, so dim far glow instead of washing it out.

See also [[HSV axes and additive light]], [[Value range and dark backing]].
