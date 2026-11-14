# Blind reviewer prompts

Spawn all three in ONE message (parallel), `subagent_type: general-purpose`, `effort: high`, background. Give each the
same evidence and only its own lens. Never include your own opinion of what is wrong, earlier rounds' notes or the other
reviewers' answers (anchoring makes them confirm instead of look).

## Pick the scale first
- **Match request** (a reference video, "make it look like this", "copy this effect"): 10 = indistinguishable from the
  reference. Differences from the reference are the faults.
- **Description request** ("make a cool light beam with an explosion", "an ice slam"): score ABSOLUTE quality. The
  references show the quality bar, not a target to copy; a difference from them is a fault only when it makes the
  effect worse. In the blind test a resemblance scale stalled the builder's panels at ~6 (and the loop stopped on
  "no gain") while outside reviewers gave the same effect 7.5.
Put the chosen scale's text (below) into the deliverable.

## Shared evidence block (fill the paths)
```
Evidence (Read every image; they are your evidence):
- <cmp>/pairs.png: N rows, REF (left) vs OURS (right) at the same effect time (labelled). Tall: read it in parts
  (crop with python PIL into strips in the same folder).
- OURS comes in two backdrops at the same times: the void stage (black, <effect>/vN/) and daylight (the default Roblox
  baseplate under the sky, or the user's own map: <effect>/vN_day/). Judge readability on BOTH; daylight is what
  players see in most games.
- <cmp>/compare.png, <cmp>/curves.png (coverage/brightness/value over time, REF yellow, OURS blue), <cmp>/metrics.json
  (per time: coverage, bright share, mean colour, hue, saturation, value, dark share, bounding box as frame fractions).
- Reference breakdown: <reference folder>/analysis.md, full-size reference frames in .../frames/, the video
  .../source.mp4 (cycle starts at <t0> s; ffmpeg frames into the scratchpad if useful). For a library reference: its
  card (library/cards/...) and frames.
- The brief: <effect folder>/brief.md (what the user asked for: purpose, length, peak time, sizes, style). Judge
  against it: an effect that ignores the brief is wrong even if it looks good.
- Our effect spec: <effect folder>/<Name>.luau; runtime + format: kit/runtime/
  VFXTimeline.luau and knowledge/spec-format.md (layers: t start, life, at, rot, pivot, size, props, tracks
  {time, value, ease}, copies, emit {t, count, over}). A particle's Size is its HALF-width (Size N = 2N studs across);
  beam widths and part sizes are full widths.
  Meshes: <list with one line each>. The camera is fixed; the effect origin is on the ground at frame centre. The
  capture camera sits on the -Z side: world +X appears on SCREEN LEFT. Describe positions in SCREEN terms and give spec
  fixes in world coordinates.
Ignore: Studio toolbar/marker cubes at OUR frame's edges, particle randomness, compression, the reference's background
noise.
```

## Lenses
1. **Shape, scale and composition**: silhouettes of each layer, relative sizes, placement, how much of the frame each
   phase fills, what reads at a glance, one hero shape per beat vs clutter. Scores: Shapes/silhouettes,
   Scale/placement, Overall.
2. **Timing, rhythm and motion**: when each phase starts/peaks/ends, pops vs grows, the quiet beat before the payoff,
   linger length, easing. Scores: Timing/rhythm, Motion/easing, Overall.
3. **Colour, value and layering**: palette per phase, white core vs saturated body vs dark ink, brightness/glow, how
   colours age, density of small detail (sparkles, curls, smoke, orbs), clutter vs emptiness, how the dark layers read
   in daylight (ink vs dirt), stair-stepped or card-edged textures. Scores: Colour/value, Layering/detail density,
   Overall. Add to its prompt: "A particle's ON-SCREEN colour is roughly texture brightness x Color x opacity; Neon
   renders hotter and more saturated. Give the value to AUTHOR, not only the target on screen."

## Deliverable (append to every prompt, with ONE of the two scale lines)
```
Deliver (under 500 words):
1. Scores 0-10 for your lens's criteria + Overall.
   [match]       Scale: 10 = indistinguishable from the reference.
   [description] Scale: absolute quality. 10 = a professional would ship it as a signature effect in a top Roblox game;
                 8 = clearly shippable in a good game; 6 = fine but generic or with visible flaws; 4 = amateur.
                 Use the references as the bar, not as a target to copy.
2. The 6 most important problems, ranked by impact. For each: effect time(s), layer id from the spec (or "missing
   layer"), what is wrong (concrete numbers: "~1.5x wider", "3 studs too high", "0.1 s late", "#hex vs #hex"),
   which backdrop shows it (void, daylight, both), and a CONCRETE spec fix (field and value, or a new layer with its
   key params).
3. One sentence on what already works well (so the fixes don't break it).
Be honest and specific; do not edit any files.
```

## Merging
- Fix what 2+ reviewers flag first; then the single highest-impact items; skip fixes that contradict a "works well".
- Keep a round log: scores per reviewer, the merged fix list, what was applied.
- Fresh reviewers each round (new agents, not continued ones) so earlier rounds don't anchor them.
