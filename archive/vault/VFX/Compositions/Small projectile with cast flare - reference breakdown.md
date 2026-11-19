---
title: Small projectile with cast flare - reference breakdown
tags: [vfx, projectile, fireball, bullet, tracer, muzzle, composition, reference]
type: composition
updated: 2026-11-18
source: Vefects https://youtu.be/fOTL1CtnZ58 (Fireball 67.8-69.3, Gunshot 74.8-80.5); Hyeon Woo Jang https://youtu.be/jfjR8ybC1O0 (rifle 22.8-24.8); Pawel Margacz https://youtu.be/Yyptp7OuCGI (tracers 1-7, galaxy disc 9-15.5); study _vfx_os_library/tutorials/REFERENCES_STUDY.md E4
---
# Small projectile with cast flare - reference breakdown

> TL;DR
> - The head is SMALL and white-hot; length comes from thin lines (a short tapered tail, parallel hair-thin tracers), never from a fat trail.
> - Cast = an anamorphic flare: a horizontal streak 6-8x longer than the core, which shrinks into the hot point before launch (~0.4 s).
> - A thin ring pops at the muzzle on release; fire projectiles drop dark smoke puffs behind them for contrast.
> - Muzzle burst = soft orange flash + a forward FAN of 15-20 hair-thin sparks + a grey smoke plume, then slow falling embers.
> - Impact is small: a flash, a puff and the dark smoke left behind; a floor reflection streak sells the light.

## V Fireball beats
| Time | Beat |
|---|---|
| 67.93 | horizontal flare streak, red-orange with white centre |
| 68.15 | flare shrinks to a hot orange point (charge) |
| 68.41-68.54 | launch: white-hot head + short glow; thin ring pops at the muzzle; dark smoke puffs left on the path |
| 68.66-68.92 | small head with a short tapered flame tail; reflection streak on the floor below |
| 69.05-69.30 | small yellow flash + puff at impact; dark smoke remains |

## Other references
- H rifle (23.4-24.8): blue tracer of bright beads (23.40) vs orange shot (23.91): soft flash, spark fan pointing
  forward with sparks of varied length, grey smoke drifting out, embers falling slowly for 0.6 s.
- P tracers (3.4-5.4): 3-4 parallel hair-thin lines instead of one trail; impact = small white star + spark streaks that
  hug the hit surface; a thin gold ring flashes on the shooter.
- P galaxy disc (9-15.5): flat spiral disc seen at an angle, white core with a horizontal lens streak, faint speed lines
  behind; the disc itself rotates, the particles barely move.

## Roblox translation (ours)
- Head: 1 core particle (small, white) + 1 soft glow particle, LockedToPart; see [[Projectile VFX - head, flight and surface impact]].
- Cast flare: 1 particle Squash-stretched horizontally (or a Beam between two close attachments), size tween to 0.
- Tail: Trail with WidthScale tapering to 0 and a short Lifetime; for tracers, 3 thin Trails with small offsets.
- Smoke behind: alpha particle, world space (not locked), Speed ~0, dark Color, LightEmission 0.
- Muzzle sparks: VelocityParallel streaks, Spread ~15, Drag high; floor reflection: a thin vertical particle under the
  head or a PointLight close to the ground (UNVERIFIED which looks closer).
