---
title: Pros animate with flipbooks, particles barely move
tags: [vfx, flipbook, particles, motion, stats, finding]
type: finding
updated: 2026-11-18
source: STATS_FINDINGS.md (2026-11-17); Plebarae VFX Academy basics https://www.youtube.com/watch?v=UimSdBlsDzo (3:56-4:30)
---
# Pros animate with flipbooks, particles barely move

> TL;DR
> - About 47% of pro aura emitters are flipbooks (mostly 4x4); our builders used almost none.
> - Pro aura particles are placed, not flung: median speed 0.05 studs/s.
> - Life comes from the flipbook, rotation and size curves, not from motion.
> - Squash (1 in 4-5 emitters) and TimeScale below 1 (1 in 7) are standard tools.

## Numbers
| Property | Pro auras | OS library |
|---|---|---|
| Flipbook (2x2/4x4/8x8) | 47% | 40% |
| Particle speed median | 0.05 | 0.6 |
| Lifetime median | 1 s (looping auras) | 0.4 s |
| Squash used | 19% | 25% |
| TimeScale < 1 | 15% | 12% |
| LockedToPart | 65% | - |

## Breaking flipbook repetition (tutorial)
In Plebarae's basics video a 4x4 smoke-puff flipbook (24 fps) reads as one stamp repeated until he turns on
FlipbookStartRandom and sets Rotation to a full random range (-180..180, then -360..360); then every puff looks
different. Both are needed. He keeps LightInfluence 0 and hosts the emitter on an Attachment inside a Part. Source:
video 3:56-4:30.
