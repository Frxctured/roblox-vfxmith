---
title: Slash with a dark twin - reference breakdown
tags: [vfx, slash, sword, bow, crescent, composition, reference]
type: composition
updated: 2026-11-18
source: Hyeon Woo Jang portfolio https://youtu.be/jfjR8ybC1O0 (katana 10.6-13.2 and 16.5-19.5, red bow barrage 32.6-33.4); Tommy "Unity VFX" https://youtu.be/ijO35e3KBMI (gold bow 21.3-23.2); Vefects https://youtu.be/fOTL1CtnZ58 (Slash 8.7-9.7); study _vfx_os_library/tutorials/REFERENCES_STUDY.md E5
---
# Slash with a dark twin - reference breakdown

> TL;DR
> - A pro slash is three things: a bright THIN leading edge, a dark or desaturated twin of the same arc just behind it, and debris (short dashes) thrown along the arc.
> - The dark twin lingers 2-3 frames longer than the bright arc, so the slash ends dark, not bright.
> - Ground slashes are long thin lines lying on the floor that fade from the tail.
> - Barrages vary size and angle of every crescent; black slivers sit among the red ones.
> - Neutral alpha layers (grey-white wind arcs) carry the swing motion behind coloured effects.

## H katana (10.6-13.2)
- Crescent wall: bright thin outer edge, soft body, stud of short white dashes along the arc.
- Behind it: the same arc in deep navy, alpha, offset a little behind and lasting longer.
- 12.02: one arc with a rainbow chromatic fringe on its outer edge (used once as an accent, not on every slash).
- 12.73: a ground slash, a hair-thin white line 3-4 C long curving on the floor, fading from its tail.

## H red bow barrage (32.6-33.4)
| Time | Beat |
|---|---|
| 32.60-32.82 | anticipation: 2 concentric dashed red rings + crosshair line on the target (reticle) |
| 32.89-32.96 | impact frame: whole screen tinted red for 2 frames |
| 33.04-33.40 | 6-8 crescents of different sizes and angles, each with a grey/black twin; long thin red dashes fly past; small black slivers |

## T gold bow (21.3-23.2)
- A triangle sigil drawn in thin gold lines with a tiny bright core; the bow pull shows grey-white ALPHA wind arcs
  (no glow) streaming behind the character.
- Impact: big soft gold bloom for ~3 frames with a few lightning-blue crackles (accent hue), then gold sparks and the
  wind arcs curling away.

## Vefects slash (8.7-9.7)
- Thick yellow crescent with a darker yellow-olive smear on the inner (concave) edge; lives ~0.15 s; then the arc
  breaks into a row of short dashes along its path.

## Roblox translation (ours)
- Arc: crescent mesh with a fading/scrolling texture, or a slash flipbook sprite on a tilted plane
  ([[Slashes are many thin sprites on tilted planes]], [[Pivot-rotated arcs and keyed emits]]).
- Dark twin: duplicate the arc, Color dark navy/black, LightEmission 0, ZOffset behind, delay 1 frame, Lifetime +0.05-0.1 s.
- Dashes: VelocityParallel particles emitted along the arc (attachment chain or a rotating emitter).
- Ground slash: a long thin flat particle or a Beam lying on the floor, Transparency NumberSequence fading from the tail.
- Impact frame: ColorCorrectionEffect tint for 2 frames ([[Impact frames and colour-correction flashes]]).
- Related: [[Value range and dark backing]], [[Ground smash with crack decal - reference breakdown]].
