---
title: Straight lines mean danger, curves mean safety
tags: [vfx, shape, shape-language, impact, finding]
type: finding
updated: 2026-11-18
source: Ryan Zeng, Real-Time VFX Visual Design - Shape (A), https://www.youtube.com/watch?v=0wEvAV_R2Rw (06:17-08:40, 14:35-30:08); Shape (B), https://www.youtube.com/watch?v=rpttR9r8_BE (04:29-08:28)
---
# Straight lines mean danger, curves mean safety

> TL;DR
> - Straight lines read as solid, sharp, cold, hard, fast, technological, offensive, high risk.
> - Curves read as fluid, blunt, warm, soft, safe, slow, protective, organic, magical, defensive, low risk.
> - Pick the language from the effect's meaning: the same lightning drawn jagged is natural and deadly, drawn as curly tendrils it is a wizard's magic.
> - Impacts follow the weapon: sharp weapons get thin straight streaks and directional sparks; blunt weapons get a round ring burst.
> - Mixed themes: the primary meaning sets the silhouette; the secondary only decorates the surface or trail. Never split 50/50.
> - Roblox translation (ours): straight = VelocityParallel streak sprites, thin Beams, spike meshes; curve = curved Beams (CurveSize), swirl flipbooks, ring and dome meshes, soft round glows.

## Evidence (lecture slides and clips)
- Readability (Shape A 06:17, LoL VFX style guide clip): round shuriken in a chain overlap into one blob; long pointed
  lens shapes fanned out stay separate while moving and look harmful.
- Linear (Shape A 16:10-19:27): an ice spike (one tall faceted spike, soft mist only at its base); a sci-fi skill with
  straight glowing ground lines, a thick bright central beam with thinner lines around it and a polygonal burst at the
  target.
- Curve (Shape A 19:30-22:01): a heal/magic effect of a soft swirl disc, a rising curl of light and small 4-point
  sparkles; no hard angle anywhere.
- Lightning both ways (Shape A 22:03-24:40): a jagged bolt with a huge white bloom at the ground (natural, dangerous) vs
  many thin curly tendrils crawling over the ground around a caster (magical).
- Sharp impact (Shape B 04:29, Monster Hunter Rise): white flash core, two or three long thin straight streaks crossing
  it in different hues, orange sparks fanned one way, a thin crescent swing arc.
- Blunt impact (Shape B 06:28, God of War shield bash): a ragged fire ring/doughnut around the struck point plus embers
  sprayed radially.

## Mixed design (Shape A 24:44-30:08)
- Sci-fi shield: protection is primary, so the silhouette is a dome (curve); sci-fi is secondary, so straight lines
  appear only as hexagon cells, visible mostly at the rim, over a soft gradient interior and a bright ground disc.
- Magic arrow (LoL High Noon Ashe ult): the arrow is primary, so a sharp bright triangle tip of straight lines; magic
  is secondary, so curling wisps and a dark smoky trail behind it.
- See [[Primary and secondary elements]] for the general rule.

## For vfxmith (ours)
- Make "meaning" (danger / speed / tech / protect / heal / magic / heavy) an input of the brief and map it to a texture
  family: streaks, spikes, shards, lens blades vs swirls, rings, domes, round glows.
- Hit effects: choose the impact recipe from the weapon (a bat is blunt: ring burst, not crossed
  streaks; UNVERIFIED that this fits the stud-brick look, test it).
- Agrees with [[Direction through blur and stretch]] (pointed teardrops for speed) and [[Soft and sharp texture shape language]].
