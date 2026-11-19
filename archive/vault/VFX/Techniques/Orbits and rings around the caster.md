---
title: Orbits and rings around the caster
tags: [vfx, scripting, orbit, motion, technique]
type: technique
updated: 2026-11-18
source: https://www.youtube.com/watch?v=MtAul-n9JmU (niitroxen, 39:55-58:30)
---
# Orbits and rings around the caster

> TL;DR
> - Orbit position = root CFrame * CFrame.new(sin(a) * r, 0, -cos(a) * r), recomputed every frame from HumanoidRootPart so the orbit walks and turns with the player.
> - N evenly spaced copies: angle_i = 360 / N * i; spawn all on the same frame (a wait inside the spawn loop gives a one-frame stagger instead).
> - Advance the angle by dt * speed (180 deg/s seen), never by a fixed step per frame, or high-FPS players see a faster orbit.
> - Seen sequence: aura layers Enabled while orbiting -> aura off + burst emit at the end -> 0.5-1 s fade (Transparency 1, size up) -> destroy.
> - Radius 6 studs around an R15 character; sign of cos picks the start point (in front vs behind), counting down reverses direction.

## Details
- Single orb: for-loop 0..360 step 2 with task.wait per step (frame-rate dependent; fine for a demo only).
- Ring: 5 orbs (a pentagon) emit their spawn burst together, then each runs its own `task.spawn` loop for one full extra turn (`EndAngle = Angle + 360`), then fades.
- Only the persistent layers (direct children: Fire, Smoke) are Enabled during flight; burst layers stay inside an attachment until the end (see [[Scripted playback - clone, place, emit, clean]]).

## For vfxmith
- Orbiting layers should be a motion type in the spec (`orbit: {radius, degPerSec, count, phase, follow = root}`) evaluated in the caster's space, consistent with [[Build effects in the caster's space]].
- Consider a 1-frame-per-copy stagger option for rings: it reads as a quick sweep instead of a pop. UNVERIFIED as better-looking.
- Related: [[Character effects - auras and buffs]], [[Easing and dynamic timing]].
