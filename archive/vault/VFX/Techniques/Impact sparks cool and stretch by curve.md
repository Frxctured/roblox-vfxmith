---
title: Impact sparks cool and stretch by curve
tags: [vfx, timing, sparks, impact, technique]
type: technique
updated: 2026-11-18
source: Ryan Zeng, Real-Time VFX Visual Design - Timing, https://www.youtube.com/watch?v=CrKcGW5qP5k (26:29-29:29, curve panels on frame t01669.1; study.md in tutorials/timing_CrKcGW5qP5k)
---
# Impact sparks cool and stretch by curve

> TL;DR
> - The same hit sparkle goes from weak to strong only by replacing linear over-life curves with shaped ones; nothing else changes.
> - Velocity: full kick, then drop to 20% by 25% of life, then a slow linear tail to 0.
> - Colour intensity: 100% at birth, 10% by 10% of life (the hit heats the spark, it cools fast), then 0.
> - Size: one axis collapses to 20% by 20% of life, the other decays slowly, so sparks are long streaks at speed and near-points when slow.
> - Noise force: 0 until ~70% of life, then rises steeply to full: the air disturbance takes over once velocity is gone.
> - Roblox translation (ours): high Speed + Drag, VelocityParallel streak texture with an early-collapsing Size/Squash, Brightness high with a ColorSequence that darkens by 0.1, plus a slow drifting speck layer to stand in for noise.

## The curves (keys read from the graph, life 0..1)
| Curve | Keys |
|---|---|
| Velocity | (0, 1) eased -> (0.25, 0.2) -> (1, 0) |
| Color | (0, 1) -> (0.1, 0.1) -> (1, 0) |
| Size Y | (0, 1) -> (0.2, 0.2) -> (1, 0) |
| Size X | (0, 1) -> slow convex decay -> (~0.85, 0) |
| Noise | (0, 0) -> (0.68, 0.1) -> (1, 1) |
The linear version (every curve a straight 1 -> 0) is shown beside it as the bad case. Visible lifetime about 0.7-0.8 s, bright for under 0.17 s (my 6 fps read, Inferred).

## The reasons he gives
- Velocity contrast (very fast then very slow) is what reads as impact (27:09-27:17).
- Colour describes heat: hot at the hit, cooling with speed (27:21-27:38).
- Speed-driven stretch is squash and stretch plus the shape chapter's "straight lines = high speed" (27:49-28:36).
- Noise starts at 0 because the initial velocity is stronger; it shows the air distortion after impact (28:40-29:11).

## Roblox translation (ours)
- Speed 30-60, Drag 6-10 (UNVERIFIED) to approximate the velocity curve; Lifetime 0.5-0.8.
- Orientation VelocityParallel, thin tall streak texture; Size NumberSequence (0, 0.6), (0.2, 0.15), (1, 0); or keep Size and use Squash to shorten the streak (sign convention UNVERIFIED).
- LightEmission 1, Brightness 3-6; ColorSequence (0, white-yellow), (0.1, orange), (1, dark red); Transparency (0, 0), (0.1, 0.3), (1, 1).
- Noise: Roblox has no per-particle noise curve; add a second emitter of tiny specks Emit on the same frame with low Speed, small random Acceleration and longer Lifetime (1-1.5 s), which takes over visually as the streaks die. UNVERIFIED.
- Related: [[Easing and dynamic timing]], [[Direction through blur and stretch]], [[Pros animate with flipbooks, particles barely move]].
