---
title: Pivot-rotated arcs and keyed emits
tags: [vfx, timing, trails, moon-animator, technique]
type: technique
updated: 2026-11-18
source: Plebarae, VFX Academy - How to use Moon Animator for Roblox VFX, https://www.youtube.com/watch?v=2J5n4xqUf3s (0:46-1:50, 2:01-2:30, 3:44-4:40, 5:54, 7:06)
---
# Pivot-rotated arcs and keyed emits

> TL;DR
> - Curved trails and leaping objects: weld the moving part to a root/pivot part at the arc's centre and rotate only the root; the trail draws a perfect arc.
> - Every one-shot layer is an Emit key on a timeline; put the splash's Emit on the same frame as the object's visibility change so the splash hides the pop.
> - Group layers per beat: one attachment for dark ink layers, one for bright layers, names that say the role.
> - A showcase-grade effect can be ~200 emitters in ~10 named groups.

## The rig (Seen 1:10-1:28)
`TrailRoot` (Part, at the arc centre) > `TrailPart` (welded, offset by the radius) > two attachments `Trail0`, `Trail1`
with the Trail between them. Animate TrailRoot's rotation only. Same rig for a fish that dives in and out of the floor
in an arc (3:44). Keying positions point by point "takes forever" and never gives a clean curve.

## Timeline beats (Seen 4:12)
Tracks: `da fish / Transparency`, `splash / Emit`, `hit fish / Emit`, keys aligned on one frame. The object pops in or
out under cover of its own splash. Moon item for a ParticleEmitter can key Emit, Enabled, Size, Color, Transparency.
Beams are keyed by Width/Transparency for open-close.

## Grouping seen in the scene (2:12)
`C1` attachment: Flash1, Glow, Lightning1/2, PullCharge1/2/4, Rays1/2, Wave2/2a, rippler (all the light).
Sibling attachment: Black, Black.9, DetailBlackppl, Smoke (all the ink). Symbol emitters in three attachments
SymbolSpawn / SymbolIdle / SymbolDissolve: one motif split into its three life phases.

## For vfxmith (ours)
- Our timelines are scripted, but the same rule holds: an arc = rotating a pivot CFrame, not lerping points; a reveal
  = visibility flip + burst on the same tick.
- Related: [[Anticipation, climax and dissipation]], [[Direction through blur and stretch]], [[Value range and dark backing]].
