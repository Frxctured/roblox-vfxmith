---
title: Fire and smoke flipbooks from a Blender fluid sim
tags: [vfx, flipbook, fire, smoke, blender, asset, texture, organic]
type: technique
updated: 2026-11-18
source: anderdingus vault by Discord @1635 (free to use, confirmed by its owner 2026-11-18; local copy ~/Documents/Vaults/anderdingus), technique 'Blender Fire Sim as a Roblox Flipbook' (verified in their game)
---
# Fire and smoke flipbooks from a Blender fluid sim

> TL;DR
> - Organic fire comes from a real Mantaflow gas sim rendered to a flipbook, not from gradients or noise.
> - Render it white (emission from the flame attribute, density 0) on black so Roblox's Color tints it.
> - Make the sim domain about 3x the flame width or the walls cut straight edges into it.
> - Keep the emission multiplier under about 2, or the core flattens to white.
> - Pack 64 frames 8x8 (frame 0 top-left) into 1024 px; in Roblox use Grid8x8, OneShot, FacingCameraWorldUp.

## Their working settings
- Gas domain about 2.8 x 2.8 x 3.8, resolution 112; vorticity 0.55, flame vorticity 1.4, burning rate 0.55, no smoke.
- Flow: a small FIRE inflow disc, inflow keyed on for the first 70 frames; a Turbulence field (strength 3, size 0.35)
  makes the flames lick and curl.
- Baking from a script needs a window/area context override; about 1 minute for 100 frames.
- Shading: Principled Volume, density 0, emission = flame^1.25 x 1.7, white. Orthographic camera, 256 px, 40 samples,
  frames 12-75 downsampled to 128 px; alpha = max(rgb) x 1.35, colour un-premultiplied.
- Blender pixel rows run bottom-up: place row r at 1024 - (r+1) x 128 when packing.

## In Roblox (their values)
Grid8x8, OneShot (born small, burns, dies), FacingCameraWorldUp, Size 6, Lifetime 2.6-3.2, Rate 0.5, Speed 0.2-0.5,
LightEmission 0.6; the attachment sits Size x 0.45 above the surface so the flame base touches it.

## For vfxmith (ours)
This is the planned route for organic stock assets (v1 phase 4): smoke uses the same sim with smoke density instead of
flame emission. See [[Code-made assets look generic]].
