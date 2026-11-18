---
title: Flash is huge and brief, residue is long
tags: [vfx, timing, flash, residue, impact, finding]
type: finding
updated: 2026-11-18
source: Vefects https://youtu.be/fOTL1CtnZ58 (Fire Floor 46.95-48.10, Bomb 13.59-14.13, Lightning 97.06-97.80); Hyeon Woo Jang https://youtu.be/jfjR8ybC1O0 (hammer 5.87-7.40, white burst 52.0-52.8, red barrage 32.89-32.96); Tommy https://youtu.be/ijO35e3KBMI (ice 112.6-114.1); study _vfx_os_library/tutorials/REFERENCES_STUDY.md
---
# Flash is huge and brief, residue is long

> TL;DR
> - Impact flashes in the reels last 2-3 frames (0.05-0.1 s) and are 1.5-5x the effect's main radius, often with a soft glow lighting the floor.
> - The flash is REPLACED in one frame by the next layer set; it does not fade out.
> - The bright phase of an impact is ~0.3 s; the dark residue (smoke clump, scorch, cracks, etched circle) lasts 0.6-1.5 s more.
> - Full-screen tints (red, white) are used for only 2 frames, on hero moments.
> - Ratio to aim for: flash : bright body : residue about 1 : 4 : 10 in time.

## Measured
| Effect | Flash | Bright body | Residue |
|---|---|---|---|
| V Fire Floor | 47.02-47.08 (2-3 frames, 1.5 R disc + 4-5 R glow) | to ~47.35 | to 48.10 (black smoke + scorch) |
| V Bomb | 13.64-13.68 (rays 3-4 R) | dome shell to 13.95 | dashes to 14.10 (short, no dark residue) |
| V Lightning | 97.15 (dome with spikes, 3 R floor glow) | to 97.31 | wisps/sparkles to 97.80 |
| H hammer | 5.87-5.95 crescent + spikes | crack glow to 6.6 | black cracks to 7.4 |
| H white burst | 52.16 (half the screen, 1-2 frames) | streak cloud to 52.4 | sparks and smoke to 52.8 |
| H red barrage | 32.89-32.96 full-screen red | crescents to 33.2 | dashes to 33.4 |
| T ice summon | 111.6 starburst + dome | to 112.7 | glowing cracks under fog to 114.1 |

## Why it works
A 2-frame peak is read as "pop" without hiding the gameplay; the long dark tail tells the player where it happened
and that it mattered. Matches [[Endings and residue]] (residue holds, then fades) and [[Anticipation, climax and dissipation]].

## Roblox translation (ours)
- Flash particle Lifetime 0.05-0.1 with Transparency 0 until the end (or simply let it die), not a slow fade curve.
- Use the residue emitters' Lifetime for the length of the effect, not the flash.
- ColorCorrectionEffect tints: tween in and out within ~0.07 s ([[Impact frames and colour-correction flashes]]).
- Roblox renders at the client's frame rate; a 2-frame flash at 60 fps is ~0.033 s, which may be missed at low fps;
  0.05-0.07 s is a safer minimum (UNVERIFIED, test on a 30 fps client).
