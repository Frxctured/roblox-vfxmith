---
title: Soft and sharp texture shape language
tags: [vfx, textures, shape, technique]
type: technique
updated: 2026-11-18
source: Riot Games, League of Legends VFX Style Guide 2017 (local copy _vfx_os_library/tutorials/articles/lol_vfx_styleguide.txt + lol_pages/p-NN.png; original URL not recorded, UNVERIFIED), slide 28; https://80.lv/articles/from-realism-to-stylization-game-vfx-production; https://www.mad-vfx.com/blogs/principles-of-visual-effects
---
# Soft and sharp texture shape language

> TL;DR
> - Riot wants textures hand-painted with concise detail and a mix of soft and sharp shapes; not photos, not busy micro-detail.
> - Slide 28 contrast: stylised flame cards are few large tongues with a bright hard core and soft red edge; the 'bad' fire is a photographic fire with fine grainy detail.
> - Stylised effects exaggerate and simplify shapes, motion and colour; fewer micro-details so they read quickly (80.lv).
> - Choose textures with large readable shapes first, fine noise last.
> - Roblox translation (ours): prefer flipbooks/sprites with big clear shapes; if a texture looks like a photo at game distance, it is the wrong texture.

## What the slide shows
Top: eight painted fire shapes, each a single curved flame with a hot yellow core and soft red falloff, clearly different silhouettes frame to frame. Bottom: eight photo-sourced explosion frames, all busy and roughly square. Riot labels the top 'accurate' and the bottom 'noise'.

## Why
Matt Schwartz (80.lv) says stylised textures translate to less micro detail so they read fast; hand painting is the common method. Realistic fire from simulation or photos has fine detail and is for realistic games.

## How to choose a texture
1. Squint: is there one clear shape and a clear edge? Good.
2. Is there at least one hard edge and one soft edge in the shape? Mixed is better than all soft (blob) or all hard (clip art).
3. Does each flipbook frame differ in silhouette? Same-silhouette frames make flicker not motion.
4. Reject if the texture's own detail is the main read.

## Roblox translation (ours)
Our own generated textures risk being 'generic', as found in [[Code-made assets look generic]]; this note gives the test to use on library textures. For a cartoony game a painted, simplified look fits better than photo smoke. UNVERIFIED: whether Roblox's smooth sprite filtering blurs hard edges at distance.

## Tension
[[Smoke is a volume]] asks for overlapping, volumetric puffs; that is about arrangement, and compatible: puff textures should still be big readable blobs, not photos.
