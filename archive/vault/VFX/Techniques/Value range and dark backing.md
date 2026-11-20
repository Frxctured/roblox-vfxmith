---
title: Value range and dark backing
tags: [vfx, value, contrast, technique]
type: technique
updated: 2026-11-18
source: Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slides 13, 14, 17; https://80.lv/articles/vfx-staples-shape-color-and-motion; Plebarae Moon Animator video https://www.youtube.com/watch?v=2J5n4xqUf3s (3:02-3:42, 7:01-7:12); reference reels https://youtu.be/fOTL1CtnZ58 (46.95-48.10), https://youtu.be/jfjR8ybC1O0 (5.3-7.4, 10.6-13.2, 32.6-33.4, 37-43), https://youtu.be/ijO35e3KBMI (21.3-23.2, 32.3-37.0)
---
# Value range and dark backing

> TL;DR
> - Effects live in a wider and higher value range than the world: the VFX band spans from dark up to the very brightest values, above the environment and the character.
> - Higher value range draws focus; contrast makes the area of effect or focal point clear.
> - Avoid pure 100% and 0% values: they get confused with the environment or UI (slide 13).
> - When an effect cannot get enough focus, add a dark backing/ink behind it, but sparingly, because it clashes with other effects in busy scenes.
> - Check in greyscale: the effect must still separate from the ground.

## What the slides show
Slide 13 draws four vertical value bands: environment lowest and darkest, character above it, UI at the very top, and the VFX band spanning almost the whole bar (it overlaps all the others). Slide 14 repeats it on a greyscale frame: ground and grass sit in mid-to-dark greys, the character mid-light, the projectile is near-white. Slide 17 shows high contrast as either a bright shape on dark or a dark shape on bright, and a low-contrast middle where focus is weakest.

## Rules
- Make the effect the brightest (or, with ink, the darkest) thing locally; place it in the band the world does not use.
- Do not use pure white and pure black everywhere. Riot's reason is that UI and environment already own those ends.
- Dark backing: a soft dark smear under a bright shape (the Varus and Vel'Koz examples on slide 17). Overuse makes the effect clash in team fights.

## Roblox translation (ours)
- Bright layers: LightEmission 1 with Brightness above 1 (see [[Our effects look matte - Brightness and LightEmission vs pros]]).
- Dark backing: an emitter with LightEmission 0 or negative and a dark Color under the bright one (matches the ink layer in [[Value, contrast and glow]]).
- Test: render a greyscale or desaturated capture; the effect must stay readable.

## Agreement and tension
Agrees with [[Value, contrast and glow]] (dark ink beside the brightest shape). Tension: that note allows white-hot 1-3 focal points; Riot says avoid exactly 100%. Reconcile: keep white-hot points tiny and tinted a hair off pure white (UNVERIFIED which reads better in Roblox).

## Example: a fully monochrome ink effect
Plebarae's ink-wash showcase uses only black ink and white light on a dark grey floor, no hue at all. It still reads
because every white beat (electric ring, flash with radial streaks, trail edge lines) sits inside or in front of black
splatter, and the ground slash is a dark smear framed by two thin white edge lines. Darks and lights live on separate
attachments per beat. Lesson: value contrast alone carries an effect; hue is optional. Source: video 3:02-3:42, 7:01-7:12.

## Reference reels: the dark partner (2026-11-18)
The owner's four quality-bar reels use dark layers far more than "sparingly" for stylised effects:
- Fire with black smoke chunks inside it from 0.1 s, outliving the fire (Vefects Fire Floor 47.11-48.10).
- Every bright slash arc paired with a dark navy twin just behind it that lingers 2-3 frames longer (Hyeon Woo Jang 5.46,
  10.84-11.07; red barrage crescents with grey/black twins 33.04).
- Glowing ground cracks over a black scorch copy of the same cracks (H 6.04-7.40).
- A vortex whose bed is dark purple-black smoke under bright sparks (H 37-40).
- Neutral alpha layers (grey-white wind arcs, white smoke) carrying the motion of coloured effects (Tommy 21.3, 33.6, 36.2).
- Debuff = buff layout in dark values (Vefects 35.6).
Lesson: in a single-effect showcase the dark layer is standard, not an emergency fix; the "sparingly" warning is about
busy multi-player scenes. Details: [[Pro reference reels vs AI-built effects]], [[Slash with a dark twin - reference breakdown]].
