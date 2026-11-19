---
title: Our effects look matte - Brightness and LightEmission vs pros
tags: [vfx, brightness, lightemission, glow, matte, stats, finding]
type: finding
updated: 2026-11-18
source: _vfx_os_library/lab/morning/research/STATS_FINDINGS.md (2026-11-17): pro aura pack 137 effects, OS library 6,148 effects, our Hollow Purple builds
---
# Our effects look matte - Brightness and LightEmission vs pros

> TL;DR
> - Pros run particle Brightness median 5, p75 15, p90 25; a few hot accents at 100 or more.
> - Our builders never went above Brightness 6, which reads as matte, no shine.
> - About 1 in 7 pro emitters use negative LightEmission (darkening backing, or saturated colour that doesn't wash out); ours used none.
> - With LightEmission 1, Brightness above 1 is what pushes a sprite into bloom and reads as shine.

## Numbers
| Property | Pro auras | OS library | Our builds |
|---|---|---|---|
| Brightness median / p75 / p90 | 5 / 15 / 25 | 2.1 / 10 / 25 | 2 / ~3 / max 4-6 |
| Brightness >= 20 | 18% | 15% | 0 |
| Negative LightEmission | 15% | 14% | 0 |
| LightEmission 1 / 0 | 40% / 42% | 38% / 34% | mostly 1 |

## Caution
These are averages over many effects, not rules for every layer. Use them to see where our builds sit, not to force
values (see [[Measure to inform, never to gate]]).
