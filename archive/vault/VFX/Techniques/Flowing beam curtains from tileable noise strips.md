---
title: Flowing beam curtains from tileable noise strips
tags: [vfx, beam, texture, fire, curtain, scrolling, noise]
type: technique
updated: 2026-11-18
source: anderdingus vault by Discord @1635 (free to use, confirmed by its owner 2026-11-18; local copy ~/Documents/Vaults/anderdingus), technique 'Rising Fire Wall With Scrolling Beams' (tested in Studio)
---
# Flowing beam curtains from tileable noise strips

> TL;DR
> - A wall of flame or energy is many camera-facing Beams around a line, each scrolling a vertically tileable strip.
> - Make the strip tileable for free by filtering white noise in FFT space with a long vertical feature size, then smoothstep it into tongues.
> - A positive TextureSpeed moves the texture from Attachment0 toward Attachment1; the image's top row sits at Attachment0.
> - Slow reads better: final speeds were TextureSpeed 0.07-0.12; fast scrolling looked cheap.
> - Move each strip's top attachment on two sines with its own phase so the top edge licks like real fire.

## Build
- Strip texture 256 x 512, grayscale (Color tints it), edges faded with sin(pi x).
- One Beam every ~2.2 studs, Attachment0 at the floor, Attachment1 ~6 studs up, TextureMode Wrap, TextureLength 4.5-9,
  width tapering 3.4 -> 1.4, colour hot white -> pink -> purple -> violet, transparency fading to the top.
- Add flame-tongue particles (negative Squash = taller) and embers rising 3-5 studs/s.
- A turning anchor (one turn per 45-90 s) with particles not locked to it makes the flames swirl.

## Related
[[Fire and smoke flipbooks from a Blender fluid sim]] (the later, simulated version), [[Judge glow in play, not in an edit preview]].
