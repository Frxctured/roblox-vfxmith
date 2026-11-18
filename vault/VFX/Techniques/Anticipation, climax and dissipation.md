---
title: Anticipation, climax and dissipation
tags: [vfx, timing, technique]
type: technique
updated: 2026-11-18
source: https://80.lv/articles/vfx-staples-shape-color-and-motion; https://80.lv/articles/from-realism-to-stylization-game-vfx-production; Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slides 32-33; https://www.mad-vfx.com/blogs/principles-of-visual-effects; https://www.youtube.com/watch?v=Rexby2jBmRY (09:59-17:59); Ryan Zeng, Timing, https://www.youtube.com/watch?v=CrKcGW5qP5k (3:03-8:07, 19:59-21:22)
---
# Anticipation, climax and dissipation

> TL;DR
> - Every effect has three phases: anticipation (fade-in, build), climax (impact, all elements, biggest contrast and saturation), dissipation (fade-out, low contrast, low opacity).
> - Anticipation length is set by gameplay (how long the player needs to react), not by art.
> - Climax is where the maximum number of elements shows; build-up should be smaller and simpler, dissipation simpler again.
> - Gangplank barrel (slide 33): a small red glowing barrel, then yellow-white, then a big orange burst, then a dark smoke and debris cloud; colour and value change tell the phase.
> - Roblox translation (ours): build three emitter groups with enable windows (start, burst, linger), not one always-on set.

## What the sources say
- 80.lv (Jevremovic): every effect has anticipation or fade-in, climax or impact (maximum elements, biggest contrast, high saturation) and dissipation or fade-out (stay short, low contrast, low opacity). Most spells use around three animations; triggers from gameplay code switch between them.
- 80.lv (Schwartz): build-up telegraphs, the spell must feel impactful, dissipation makes it feel grounded rather than stopping abruptly.
- Riot: all effects need anticipation and dissipation; the Gangplank barrel slide shows three clear frames (slide 33).
- mad-vfx: the bigger the build-up, the bigger the impact; explosion = quick turn from small fire ball to the main blast, then smoke that fades.

## Phase recipe (ours, built from the above)
1. Anticipation: small, one hue, rising value or a warning colour (red to yellow on the barrel); a shrinking or filling indicator for area effects.
2. Climax: all layers on together, brightest values, biggest size, one-frame flash, shake.
3. Dissipation: drop value, saturation, opacity and size together; leave smoke or debris only.

## Timing ratios
None of the sources gives numbers. Our own suggestion, UNVERIFIED and to be tuned on samples: build-up 20-40% of the duration for combat effects, climax short (under 15% flash), dissipation 40-60% but at low opacity. Compare with the hold and fade values in [[Endings and residue]].

## Roblox translation (ours)
Drive group visibility by task.delay windows or per-emitter Enabled and Emit bursts; scale via NumberSequence over Lifetime. Keep anticipation emitters from persisting into the climax unless they carry over.

## Seen in a pro showcase (ghxstying fire slash, 60 fps)
Charge emitters Enabled from ~frame 10, aura added midway, charge switched off just before the release; release at ~frame 96 = flare + circle Emit 1, slash layers Emit 1-2, shards/fire/sparks Emit 7-15, 2-frame impact flashes; embers Enabled from the slash and a spinning ember part for ~8 frames after. So anticipation ~1.5 s, climax a handful of frames, dissipation carried by embers. See [[Syncing effects to a character animation]] and [[Impact frames and colour-correction flashes]].

## Measured phases in Ryan Zeng's examples (CrKcGW5qP5k; my reads at 4 fps, +/-0.25 s, Inferred)
- Fujihara tornado: spark specks rise and arc lines wrap inward ~1.5 s, a small core light ~0.5 s, a vertical beam 0.25-0.5 s, tornado at full size within a quarter second, holds ~3 s, collapses to a red glow ~0.5 s, glow fades ~2.5-3 s. Roughly 2.5 : 3 : 3 for a showcase ultimate.
- His flying-sword barrage: swords gather ~2.2 s, barrage ~3.5 s, big flash, smoke ~1.5 s, then a SECOND anticipation ~0.5-1 s and a final wider flash, smoke ~1.5 s. Two anticipation/climax pairs make "levels of power" (20:47-21:12).
- Impact sparks: bright under 0.17 s, gone by ~0.8 s ([[Impact sparks cool and stretch by curve]]).
What he adds: build in a SMALL screen area, release over a huge one; "the contrast in visual area between the front and back stages greatly enhances the sense of impact" (7:37-7:48). And a squash (inward pull + a few frames of pause) right before the burst. These numbers are showcase pieces, longer than our ~1.5 s combat budget; keep the ratios, not the seconds.
Roblox translation (ours): anticipation emitters with inward Speed (negative or Attractor-like via Acceleration toward centre), a 2-4 frame hold (task.wait(0.05-0.1)) with nothing new emitted, then Emit the climax at 3-5x the anticipation's screen size.
