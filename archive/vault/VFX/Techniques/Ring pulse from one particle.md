---
title: Ring pulse from one particle
tags: [vfx, ring, shockwave, particles, orientation, technique]
type: technique
updated: 2026-11-18
source: DazMuky, Particles 101, https://www.youtube.com/watch?v=-SKNCFqqvT4 (28:30-38:07; values read off the Properties panel at 31:27-38:07)
---
# Ring pulse from one particle

> TL;DR
> - One ring-outline texture, Rate 1, Lifetime 1, Size 0 -> about 2.7, Transparency 1 -> 0 fast, hold, -> 1 gives an expanding pulse.
> - Orientation decides where the ring lives: FacingCamera(WorldUp) = flat-on hit flash; VelocityPerpendicular = ring lies in the emitter's plane (ground pulse at the feet).
> - Give velocity orientations a tiny Speed (0.01) so they have a direction; rotate the emitter's Part (90 on Z) to stand the ring up as a wall.
> - Raise Speed (6) and Rate (6) on the wall version and it turns into a forward tunnel of rings ("shout" / sonic blast).
> - Glow: LightInfluence 0, LightEmission 1, Brightness pushed high (he used 100), cyan -> blue gradient, RotSpeed -140 for spin.

## Build (as shown)
Invisible, anchored, CanCollide-false Part -> Attachment -> ParticleEmitter. Texture `rbxassetid://7083340510` (thin
soft white ring). Speed 0.01, SpreadAngle 0, Rotation 0, RotSpeed -140, Lifetime 1, Rate 1, Enabled off for one-shot
use and fire with Emit. Size 0 -> 2.69 linear (the ring grows; shrinking looked wrong to him). Transparency
1 @0 -> 0 @~0.19 -> 0 held to somewhere between 0.27 and 0.54 (UNVERIFIED which) -> 1 @1.

## Placements
- Chest hit: Part inside the torso, FacingCameraWorldUp.
- Ground pulse: Part at the feet, VelocityPerpendicular.
- Wall / blast: copy rotated 0,0,90, in front of the character; Speed 6, Rate 6 for the travelling version.

## Caveats
Single layer, beginner demo. A pro shockwave adds a bright core flash, secondary sparks or dust and a darker backing
(see [[Primary and secondary elements]], [[Value range and dark backing]], [[Our effects look matte - Brightness and LightEmission vs pros]]).
Why Speed 0.01 works is our inference, not stated in the video.
