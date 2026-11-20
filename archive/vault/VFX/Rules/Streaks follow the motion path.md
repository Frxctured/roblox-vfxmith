---
title: Streaks follow the motion path
tags: [vfx, shape, streak, swirl, vortex, black hole, speed lines, composition]
type: rule
updated: 2026-11-19
source: owner review of the v1 baseline poll (gravity well), with sketch
---

> TL;DR
> - Streaks, speed lines and debris trails take the shape of the motion they show.
> - Swirl, orbit or vortex (black hole, gravity well, tornado): arcs that curve along the spin, around the core.
> - Radial burst, dash or impact: straight lines are right.
> - This is not a preference for curved meshes: a straight stretched part is fine when the motion is straight.

## The case
The no-plugin gravity well (v1 baseline, 2026-11-19) drew straight segments placed in rings around the core. The owner
liked the base, but the straight pieces "didn't match" a black hole, which spins. The owner's sketch:
- what it did: straight dashes around the core, like a broken polygon;
- what fits: curved arc dashes, each bent along the swirl, tightening toward the core.

## How to apply
- Ask what the motion is before choosing a streak shape: inward spiral, orbit, outward burst, forward dash.
- For spin: use curved beams (Beam CurveSize0/1), arc meshes, or particles with orbital velocity, and taper them so they
  read as moving along the arc.
- Check a top-down frame too: arcs that look right from the side can turn into straight chords from above.
