---
title: Direction through blur and stretch
tags: [vfx, motion, shape, technique]
type: technique
updated: 2026-11-18
source: Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slide 30; https://www.mad-vfx.com/blogs/principles-of-visual-effects; https://80.lv/articles/from-realism-to-stylization-game-vfx-production
---
# Direction through blur and stretch

> TL;DR
> - Fast things need directional shape: a streak, trail or motion-blur sprite shows where it is going; a hard round sprite flying fast reads as flicker.
> - Slide 30 bad: spiky round yellow star bursts jumping, 'illusion of frame drop'; good: teardrop-shaped blue comet with a soft tail pointing back.
> - Stretch the shape along its travel axis (squash and stretch); Schwartz scales the arm along its outward axis as the texture reveals (80.lv).
> - Mad-vfx claims round shapes mean speed and angular mean tension; that conflicts with the slide, UNVERIFIED and probably wrong.
> - Roblox translation (ours): VelocityParallel orientation with stretched sprites or Trails/Beams for fast things.

## What the slide shows
Left (bad): a round spiky sun sprite and a small star burst, no direction. Right (good): a falling blue comet shaped like a flame with a soft, longer tail, and a cyan jet drop-shape; the shape itself points the way.

## Rules
- Head sharp and bright, tail soft and fading; the length scales with speed.
- Stretch and squash by scaling along the velocity axis, then relax to normal at the end of the move.
- Slow things can be round; the direction cue is needed only where the eye must track.

## Roblox translation (ours)
ParticleEmitter: FacingCamera is wrong for streaks; use VelocityParallel (or Perpendicular for slashes, see [[Slashes are many thin sprites on tilted planes]]), a stretched texture and a tail-length via LockedToPart off plus Size X/Y ratio; or a Trail between two Attachments with a Transparency gradient. See also [[Pros animate with flipbooks, particles barely move]] for the other end: calm things barely move.

## Disagreement
mad-vfx (https://www.mad-vfx.com/blogs/principles-of-visual-effects) states round shapes suggest speed. The Riot slide shows the opposite use (directional teardrops for speed). We follow Riot; mad-vfx text is generic and gives no example.
