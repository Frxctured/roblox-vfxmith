---
title: Easing and dynamic timing
tags: [vfx, timing, easing, technique]
type: technique
updated: 2026-11-18
source: Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slide 35; https://80.lv/articles/from-realism-to-stylization-game-vfx-production; https://www.mad-vfx.com/blogs/principles-of-animation-in-visual-effects; Ryan Zeng, Timing, https://www.youtube.com/watch?v=CrKcGW5qP5k (15:13-17:09, 26:04-31:55)
---
# Easing and dynamic timing

> TL;DR
> - Linear motion looks cheap: Riot's Ekko R uses a fast-start, slow-settle curve and calls the linear cast-to-blast version 'less interesting'.
> - Schwartz animates on curves, easing in and out, because little in nature moves linearly.
> - Mad-vfx's slow in / slow out: start slow, speed up, slow at the end.
> - For impacts specifically Riot's good curve is ease-out: most of the distance covered in the first moments.
> - Roblox translation (ours): TweenService with Enum.EasingStyle.Quint/Expo Out for expansions; NumberSequence keypoints, not two-point ramps.

## The slide
Two graphs of position over time. Good: a curve that rockets up and flattens (ease-out), applied to Ekko's cast and blast. Bad: a straight diagonal. The text states dynamic timing gives higher satisfaction and a more interesting moment.

## Pick the curve by phase
- Anticipation: ease-in (slow start, gathers) or a small pull-back before the move.
- Impact expansion (rings, bursts, shockwaves): ease-out, so most growth is in the first 20-30% of life; this reads as force.
- Dissipation: ease-in-out so the fade does not drop off a cliff.
- Mad-vfx: slow-in/slow-out as the general default.

## Roblox translation (ours)
- Ring radius: Tween Size with Quad/Quint Out.
- ParticleEmitter Size over life: NumberSequence with 4-6 keypoints that front-load growth, never `NumberSequence.new(a, b)`.
- Transparency: hold then rise; not a straight ramp.
- Beams: tween Width and Transparency separately with different eases (overlapping action, see [[Animation principles applied to effects]]).

## Agreement
Agrees with [[Pros animate with flipbooks, particles barely move]] that life comes from Size and Transparency curves rather than raw motion.

## Ryan Zeng: curves are the whole job (CrKcGW5qP5k)
Agrees: avoid linear except for machines/tech (15:42); nothing starts or stops at uniform speed, and neither does dissipation ("no uniform rate of dissipation", 16:03). An artist only animates position, rotation, scale and colour over time, so "everything is about the curve" (26:04).
New:
- A worked before/after with real curve keys: [[Impact sparks cool and stretch by curve]] (velocity, colour, two-axis size and noise, each with a different shape and timing).
- Style ladder (29:35-31:55): ease-out to 100% (realistic) -> overshoot ~110% and settle -> bigger overshoot plus a second bounce -> X and Y on separate out-of-phase curves. The realistic curve is kept underneath every stylised one; stylisation adds variation on top of it, never a different direction.
Roblox translation (ours): realistic pops = Quint/Expo Out; stylised = Back Out (one overshoot) or Elastic Out (bounces); cartoon squash = tween X and Z scale with different durations or a slight delay between them.
