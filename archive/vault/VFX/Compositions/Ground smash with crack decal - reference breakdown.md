---
title: Ground smash with crack decal - reference breakdown
tags: [vfx, slam, smash, ground, crack, decal, impact, composition, reference]
type: composition
updated: 2026-11-18
source: Hyeon Woo Jang portfolio https://youtu.be/jfjR8ybC1O0 (hammer smash 5.3-7.4, ice greatsword 83.3-85.8); Tommy "Unity VFX" https://youtu.be/ijO35e3KBMI (ice summon 109.2-114.6, lightning cracks 57.0-58.0); study _vfx_os_library/tutorials/REFERENCES_STUDY.md E3
---
# Ground smash with crack decal - reference breakdown

> TL;DR
> - The crack decal is two layers of one texture: a black scorch with cracks (alpha) and a glowing copy of the cracks (add). The glow drains first (~0.6 s), the black cracks stay ~1 s more.
> - Before impact: a dark ground smear with a thin bright edge, a light pillar, stacked thin ground rings, slash arcs each paired with a dark twin.
> - Impact frame: one giant crescent sweeping into the ground (white core, element body, dark inner rim) plus white radial spikes at the hit point.
> - The bright parts are vertical/curved and the decal is flat and radial, so they read as separate statements.
> - The decal is the anchor and the last thing on screen.

## Beats (H hammer smash)
| Time | What is on screen |
|---|---|
| 5.30 | dark ground swirl smear with thin teal edge under the character (anticipation) |
| 5.46 | vertical light pillar, stacked ground rings, teal arcs + dark twins |
| 5.63-5.79 | dark arcs spinning, teal dashes and confetti flecks |
| 5.87-5.95 | giant crescent (white core, teal body, slight chromatic fringe) slams down; white radial spikes |
| 6.04-6.58 | black scorch star with glowing teal cracks ~1.5 C across; few motes |
| 6.75 | glow drains out of the cracks; black cracks remain |
| 6.91-7.40 | cracks break into fragments and fade |

## Layers
| Layer | Shape | Value / colour | Blend |
|---|---|---|---|
| Ground smear | curved dark brush stroke on the floor | near-black, teal edge line | alpha + add edge |
| Light pillar | thin vertical beam | white core, teal fringe | add |
| Ground rings | several thin concentric rings | teal | add |
| Slash arcs | thin crescents | teal | add |
| Dark twins | same arcs, slightly behind and delayed | navy/black | alpha |
| Main crescent | thick crescent, sharp outer edge | white core, teal, dark inner rim | add (+ dark rim) |
| Impact spikes | radial white spikes | white | add |
| Crack glow | crack network | teal | add, fades first |
| Crack scorch | same cracks + black splat | black | alpha, fades last |
| Motes | small flecks | teal | add |

## Variants
- H ice greatsword (83.3): a blue arc of ice shards follows the blade, ice splinter decals land on the floor, then a
  vertical eruption of thin crystal shards; residue = one long thin white line on the floor + splinters.
- T ice summon (109.2-114.6): snowflake crystal sprite around the caster, white alpha gust ribbons crossing the frame,
  white starburst splat with a jagged star outline, big blue fresnel dome; residue = a large glowing blue crack network
  under drifting fog for 1.5 s.
- T lightning (57.0): bolts end in ground splashes that leave branching glowing cracks crawling outward (0.6 s).

## Roblox translation (ours)
- Crack decal: two Decals on one thin flat part (or two flat particles with Orientation VelocityPerpendicular, Speed 0):
  the glow copy with a bright Color (LightEmission 1 if a particle) tweened out first, the black copy tweened out later.
  Break-up: swap to a "cracks fragmenting" flipbook or shrink several smaller crack pieces separately.
- Dark twins: clone each arc emitter/mesh with dark Color, LightEmission 0, ZOffset slightly behind, 1-2 frames delay.
- Pillar: Beam with a thin bright texture, Width tween.
- Related: [[Slash with a dark twin - reference breakdown]], [[Every pro effect is anchored to the ground]],
  [[Endings and residue]], [[Telegraphs that show the true area]].
