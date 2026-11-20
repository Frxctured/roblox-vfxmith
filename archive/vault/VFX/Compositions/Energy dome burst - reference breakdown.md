---
title: Energy dome burst - reference breakdown
tags: [vfx, explosion, dome, shockwave, dissolve, composition, reference]
type: composition
updated: 2026-11-18
source: Vefects "Anime Stylized VFX - Demo" https://youtu.be/fOTL1CtnZ58 (Bomb 13.59-14.13, repeat 18.09-18.63); Tommy "Unity VFX" https://youtu.be/ijO35e3KBMI (ice dome 111.6-112.7); study _vfx_os_library/tutorials/REFERENCES_STUDY.md E1
---
# Energy dome burst - reference breakdown

> TL;DR
> - 0.5 s total. The solid white dome exists for only 2 frames; the rest is the dome ERODING into a rim shell.
> - Impact frame: a tiny white core with 15-20 hair-thin radial rays reaching 3-4x the dome radius (1-2 frames).
> - The dome dissolves from the inside out with a jagged noise mask while its rim stays bright; it never fades uniformly.
> - A second, torn outer shell fragment, inward speed lines and a soft blue ground pool add depth.
> - Exit: the rim thins to a line, breaks into dashes, streak sparks fly out.

## Beats (Bomb, times in the video)
| Time | What is on screen |
|---|---|
| 13.59 | idle bomb (cartoon sphere, dark band, small glow) |
| 13.64 | white-hot core + thin radial rays to 3-4 R |
| 13.68 | solid half dome, white centre, cyan-blue fresnel edge |
| 13.73 | dark blue noise holes eat the dome from the centre |
| 13.78-13.87 | rim shell with ragged inner edge; inner radial dashes; torn outer shell above; blue ground pool |
| 13.91-14.05 | rim is a thin line, breaks into arcs and dashes; streak sparks out |
| 14.10 | gone |

## Layers
| Layer | Shape | Size | Value / colour | Blend | Motion |
|---|---|---|---|---|---|
| Radial rays | hair-thin lines | 3-4 R long | white | add | 1-2 frames |
| Core flash | disc | 0.3 R | white | add | 2 frames |
| Dome | half sphere, fresnel rim, noise dissolve | R | white -> cyan -> blue | add | scale pop, then erode |
| Outer shell | larger dome fragment | 1.2 R | cyan | add | tears off, breaks |
| Inner speed lines | short dashes pointing at centre | 0.5 R | white | add | 3-4 frames |
| Ground pool | soft blob | R | blue | add | holds under shell |
| Exit sparks | streaks and dots | small | cyan-white | add | fly out, stretch |

## Why it reads as professional
- The erosion edge is chunky cel noise (big blobs plus small holes); no soft gradient inside the shell.
- One big shape only; rays give a 1-frame silhouette 3x bigger than the dome, then everything thins.
- T ice dome (111.6) uses the same idea at hero scale: blue fresnel dome full of white sparkle points over a white
  starburst splat, gone in ~0.5 s.

## Roblox translation (ours)
- Roblox meshes have no dissolve shader. Options: (a) a camera-facing flipbook particle with hand-made "dome eroding"
  frames (best match), (b) a hemisphere MeshPart (ForceField material gives a rim look) tweened bigger while
  Transparency rises, plus a ring of dark noise particles at the rim to fake erosion (weaker).
- Rays: one emitter, 16-20 thin line particles, Orientation VelocityParallel, Lifetime 0.05-0.1.
- Ground pool: flat soft particle (VelocityPerpendicular, Speed 0) + PointLight.
- Related: the "magic" twin of [[Stylized ground explosion - reference breakdown]]; see also
  [[Effects dissolve by breaking up]] and [[Flash is huge and brief, residue is long]].
