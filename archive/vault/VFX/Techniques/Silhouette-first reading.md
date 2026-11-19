---
title: Silhouette-first reading
tags: [vfx, silhouette, shape, technique]
type: technique
updated: 2026-11-18
source: Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slides 7, 29; https://80.lv/articles/vfx-staples-shape-color-and-motion; Ryan Zeng, Shape (A) https://www.youtube.com/watch?v=0wEvAV_R2Rw (06:17-08:40)
---
# Silhouette-first reading

> TL;DR
> - Read every effect as a flat black silhouette first; if you cannot tell what it is or where it is going, details will not save it.
> - Slide 29: the bad effect has many details and contrast everywhere, so you cannot tell the object's shape; the good one is a few simple bright slash-shapes with a wide value range.
> - Simple shapes with a wide value range create a focal point; complex shapes with low range create noise.
> - Primary elements get a clear silhouette; secondaries may be blurry (slide 7).
> - Roblox translation (ours): capture, then threshold or view in black; review the shape before colour.

## The test
Fill the effect with solid black on a white or mid background (or just squint and blur). Questions:
- Can you name the shape (arc, spear, ring, burst) in under a second?
- Can you tell direction of travel?
- Is the size right against the character ([[Size effects against the character]])?
- Does one shape dominate?

## Evidence (slide 29)
Left: a chain of blue lightning crescents with dozens of sparkles, all medium contrast; the viewer cannot say where it is moving. Right: six sharp orange-red streaks fanned out from a creature; simple, directional, bright.

## How
- Few big shapes; 3-7 per effect, not 30.
- Edges: keep one hard edge for the silhouette; soft falloff behind it ([[Soft and sharp texture shape language]]).
- Silhouette should change over time (fan out, thin, break), not stay the same disc.

## Roblox translation (ours)
Add a 'silhouette pass' to review: render the capture with high contrast; or composite the effect alone on black and threshold at 30% brightness.

## Tension with existing finding
[[Slashes are many thin sprites on tilted planes]] shows pros stack dozens of thin crescents (median 36 emitters). Compatible if they all align into one clear arc silhouette; the source rule is about the read, not the emitter count. UNVERIFIED how to measure that automatically.

## Round repeats merge, pointed ones stay apart (Ryan Zeng, Shape A 06:17-08:40)
A LoL style-guide clip: a vertical chain of spinning round shuriken overlaps into one messy blob that you cannot count
while it moves; six long pointed lens shapes fanned out stay separate and look dangerous. "Complex can be good, but
clear is better." When several copies of one shape fly together, give them pointed, elongated silhouettes and spacing
so they do not overlap. See [[Straight lines mean danger, curves mean safety]] and [[Shape variation - big, medium, small]].
