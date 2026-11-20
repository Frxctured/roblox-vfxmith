---
title: Animation principles applied to effects
tags: [vfx, animation, principles, finding]
type: finding
updated: 2026-11-18
source: https://www.mad-vfx.com/blogs/principles-of-animation-in-visual-effects; https://80.lv/articles/from-realism-to-stylization-game-vfx-production; https://www.youtube.com/watch?v=uDqjIdI4bF4 (AlanBeckerTutorials, 12 principles, timestamps below); Ryan Zeng, Timing, https://www.youtube.com/watch?v=CrKcGW5qP5k (2:57-25:07)
---
# Animation principles applied to effects

> TL;DR
> - Squash and stretch gives weight and speed but only sparingly, or effects look cartoony.
> - Anticipation: exaggerate the build-up and the climax hits harder; keep the audience interested during it.
> - Follow-through and overlapping action: not everything moves in sync; parts lag and settle after the main hit.
> - Secondary actions (rocks floating beside the main effect, embers) must fit the main effect in texture, colour and light.
> - Exaggeration helps believability; arcs and clear staging (size, colour, motion supporting the intent) make actions readable.

## Notes per principle (mad-vfx; examples ours)
- Squash and stretch: stretch a projectile along its path, squash an impact ring at the contact moment. Fits [[Direction through blur and stretch]].
- Anticipation: a pull-in or glint before a slash or blast; bigger build-up means a bigger hit.
- Staging: size and placement, colour and motion should support the effect's intention and draw the eye ([[Primary and secondary elements]]).
- Follow-through and overlap: debris, dust, glow fade later than the flash; different layers start and end at slightly different times.
- Slow in/slow out and arcs: see [[Easing and dynamic timing]].
- Secondary action: embers, floating pieces; must share the palette and light of the primary.
- Timing: duration controls speed; short timelines feel faster.
- Exaggeration: make it obvious, but stay below 'over the top'.

## Weakness of the source
The mad-vfx article is generic text without frame-by-frame examples or numbers. Schwartz (80.lv) is more concrete: blocking with key poses, squash/stretch added by scaling along the outward axis during the reveal, slow in/out always applied.

## Roblox translation (ours)
Offsets: give each layer its own Delay/Start time (0.03-0.1 s staggers, UNVERIFIED) and a different lifetime; avoid starting every emitter on the same frame. Add one secondary layer that outlasts the primary slightly. Links: [[Anticipation, climax and dissipation]], [[Endings and residue]].

## Additions from the 12-principles video (uDqjIdI4bF4)
- Squash and stretch: keep VOLUME constant (long = thin, flat = wide); stretch only near the end of a fall/flight, not the whole way; more deformation = softer object (1:06-2:03). Ours: scale the mesh along travel axis and shrink the other two; impact disc squashed wide on contact then settles.
- Anticipation (2:06-4:10): no wind-up = weak hit; viewer must see it with no competing action; can be layered (wind-up of the wind-up). Ours: a 0.15-0.5 s charge layer with inward particles and a shrinking ring before the burst.
- Pose to pose vs straight ahead (6:33-9:13): structured effects get keys, then extremes, then breakdowns (NumberSequence keys); fire, smoke, dust, explosions are "straight ahead": rely on emitter randomness and tune by eye; add appendages (embers, trails) after the main motion works.
- Follow-through: tip arrives last and overshoots most; delay = mass (9:13-11:17). Ours: staggered Delay, secondary layer outlasting primary, scale overshoot to about 1.1 then settle.
- Slow in/out exception (11:17-12:56): do not ease into a collision (impact lands hard) but ease the rebound/settle. Spacing tighter at the ends, wider in the middle.
- Arcs: a smear is a filled arc between start and end pose, same colour, semi-transparent and fragmented at the end (14:20-14:37). Ours: a crescent smear layer behind a slash.
- Timing: the same move reads as hit, twitch or stretch purely by frame count; drawing on twos gives sparkle (16:10-18:21). Ours: 0.1-0.2 s = violent, 0.6 s+ = floaty; do not smooth everything.
- Exaggeration: fast motion needs more exaggeration; push until too much, then back off (18:21-19:55). Ours: overshoot size/brightness in a test pass, dial down.
- Solid drawing / appeal: avoid symmetric "twinning" (randomise rotation/size), overlap layers to show depth, one clear silhouette, drop details that do not read (19:55-23:25).
See the full per-principle table in the study.md of the source folder (tutorials/principles_uDqjIdI4bF4). Mappings are ours, UNVERIFIED in game.

## Ryan Zeng's VFX definitions and examples (CrKcGW5qP5k)
Same principles, with a "For VFX" line each and a pro example (full table in tutorials/timing_CrKcGW5qP5k/study.md). Points that add to the above:
- Squash and stretch applies to the TIMELINE, not only to shapes: Battlefront II explosion pulls inward, pauses a few frames, then bursts much bigger (3:03-5:57). The size curve dips before it rises.
- Staging: "only one main character in each stage"; when every layer is bright and busy, "no one's the real star" (8:08-9:01). Stages hand the star role on (cards -> projectiles -> big bang).
- Straight-ahead / pose-to-pose for VFX = one primary energy flow; secondary elements follow the same track and order, so the path stays in the eye after the effect ends (10:37-13:16).
- Follow-through: secondary particles dragged by the main flow keep moving in their inertia direction when the flow fades, slowing, never freezing and never continuing to swirl; anything flowing against the main flow without a source creates "two conflicting dynamic fields" (13:17-14:55).
- Secondary action carries the aftermath: rock distance = force, central smoke = heat cooling (19:12-19:56).
- Exaggeration scales with rarity/level/paid skins (21:26).
Roblox translation (ours): give secondary emitters the primary's direction (same EmissionDirection / inherited velocity), switch them off rather than freezing them, and let Drag slow them; never add an opposing swirl layer.
