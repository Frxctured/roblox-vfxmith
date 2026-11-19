---
title: Element checklist and blockout first
tags: [vfx, process, composition, technique]
type: technique
updated: 2026-11-18
source: Ampro https://www.youtube.com/watch?v=o2021uP4mzE (1:30-5:30) and https://www.youtube.com/watch?v=JXoGT2PoOhs (0:28-2:10); https://80.lv/articles/vfx-staples-shape-color-and-motion; https://80.lv/articles/from-realism-to-stylization-game-vfx-production; https://www.mad-vfx.com/blogs/principles-of-visual-effects
---
# Element checklist and blockout first

> TL;DR
> - Split every effect into elements (shape, colour, motion influences) and run each through the same questions before keeping it.
> - Block out first with all elements and rough timing, so gameplay can test it; polish later, like key poses in animation.
> - Ask for feedback early, including from non-gamers; remove elements that do not add value even if you like them (a spinning centre piece got cut for moving unlike the rest).
> - Reuse textures: grayscale textures tinted in the shader, channels packed for colour/emission/alpha.
> - Roblox translation (ours): plugin steps = gameplay brief, element list, block-out capture, review, then polish.

## Checklist per element (Jevremovic, 80.lv)
1. How important is it; is it the primary focus?
2. How much attention should it draw?
3. When and how does it appear and disappear?
4. How does it blend with the other elements?
5. Does it make the effect noisy?

## Spell checklist (before starting)
Who uses it; how powerful; logic (pre-cast, duration, status, area); rarity (rare = bigger budget); is there concept art.

## Process
- Block out first with reused assets and basic timing, include all elements, push it into the game so design can test (both sources).
- Schwartz: block out the broad strokes to find timing and tonal problems early; add flourishes (squash/stretch, ease) after.
- Feedback early; Schwartz's example removed an element that fitted nothing.
- Reuse: grayscale textures reused with gradient LUTs in the shader; the red channel for colour, green for emission, blue for alpha lets one texture hold two separately animated parts (the meteor crack and its glowing core). Roblox has no such shader channel; the translation below applies.
- Optimise: particles only when needed; meshes with scrolling textures fake particles cheaper; overdraw kills mobile.
- Gameplay first: tone effects down for feedback and clarity.

## Roblox translation (ours)
- Block-out = low-count emitters, final colours, rough timing; capture before adding detail.
- Reuse: one greyscale soft texture tinted by Color; two layers of one flipbook at different Size/Color substitute for channel packing.
- Scrolling texture meshes are available via Beams (TextureSpeed) and Trails; cf. [[Pros animate with flipbooks, particles barely move]].
- Judge with [[Measure to inform, never to gate]] and the caution in [[AI review panels disagree with humans]]: the checklist is for decisions, not scoring.

## Studio bench before the first emitter (Ampro, two tutorials)
Seen in both of his build videos: he sets up the bench before any emitter.
- A folder per skill set (`Workspace.WIP.Test`), a Dummy next to the work "for size referencing", and an emit plugin
  that stores `EmitCount` / `EmitDelay` per emitter so one button replays the whole effect.
- Lighting first (o2021uP4mzE 2:22-5:08): custom sky, Atmosphere with Haze ~1.9, SunRays, ColorShift top/bottom,
  Environment scales ~0.4, soft shadows, clouds. Then he checks the effect in day and at night.
- He works from the hero layer outward: lay out all textures first (JXoGT2PoOhs 0:28: "it's really just eight
  textures"), build the layer that carries the shape, then the secondaries, then compare side by side with the
  reference copy.
- "Always name your particle emitters" (o2021uP4mzE 6:57).

