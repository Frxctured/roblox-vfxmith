# Blind reviewer prompts

Spawn all three in ONE message (parallel), `subagent_type: general-purpose`, `effort: high`, background. Give each the
same evidence and only its own lens. Never include your own opinion of what is wrong, earlier rounds' notes or the other
reviewers' answers (anchoring makes them confirm instead of look).

## Shared evidence block (fill the paths)
```
Evidence (Read every image; they are your evidence):
- <cmp>/pairs.png: N rows, REF (left) vs OURS (right) at the same effect time (labelled). Tall: read it in parts
  (crop with python PIL into strips in the same folder).
- <cmp>/compare.png, <cmp>/curves.png (coverage/brightness/value over time, REF yellow, OURS blue), <cmp>/metrics.json
  (per time: coverage, bright share, mean colour, hue, saturation, value, dark share, bounding box as frame fractions).
- Reference breakdown: <reference folder>/analysis.md, full-size reference frames in .../frames/, the video
  .../source.mp4 (cycle starts at <t0> s; ffmpeg frames into the scratchpad if useful).
- Our effect spec: <effect folder>/<Name>.luau; runtime + format: kit/runtime/
  VFXTimeline.luau and knowledge/spec-format.md (layers: t start, life, at, rot, pivot, size, props, tracks
  {time, value, ease}, copies, emit {t, count, over}).
  Meshes: <list with one line each>. The camera is fixed; the effect origin is on the ground at frame centre. The
  capture camera sits on the -Z side: world +X appears on SCREEN LEFT. Describe positions in SCREEN terms and give spec
  fixes in world coordinates.
Ignore: Studio toolbar/marker cubes at OUR frame's edges, particle randomness, compression, the reference's background
noise. Our stage is black on purpose.
```

## Lenses
1. **Shape, scale and composition**: silhouettes of each layer, relative sizes, placement, how much of the frame each
   phase fills, what reads at a glance. Scores: Shapes/silhouettes, Scale/placement, Overall.
2. **Timing, rhythm and motion**: when each phase starts/peaks/ends, pops vs grows, the quiet beat before the payoff,
   linger length, easing. Scores: Timing/rhythm, Motion/easing, Overall.
3. **Colour, value and layering**: palette per phase, white core vs saturated body vs dark ink, brightness/glow, how
   colours age, density of small detail (sparkles, curls, smoke, orbs), clutter vs emptiness. Scores: Colour/value,
   Layering/detail density, Overall. Add to its prompt: "A particle's ON-SCREEN colour is roughly texture brightness x
   Color x opacity; Neon renders hotter and more saturated. Give the value to AUTHOR, not only the target on screen."

## Deliverable (append to every prompt)
```
Deliver (under 500 words):
1. Scores 0-10 (10 = indistinguishable) for your lens's criteria + Overall resemblance.
2. The 6 most important differences, ranked by impact. For each: effect time(s), layer id from the spec (or "missing
   layer"), what is different (concrete numbers: "~1.5x wider", "3 studs too high", "0.1 s late", "#hex vs #hex"),
   and a CONCRETE spec fix (field and value, or a new layer with its key params).
3. One sentence on what already matches well (so the fixes don't break it).
Be honest and specific; do not edit any files.
```

## Merging
- Fix what 2+ reviewers flag first; then the single highest-impact items; skip fixes that contradict a "matches well".
- Keep a round log: scores per reviewer, the merged fix list, what was applied.
- Fresh reviewers each round (new agents, not continued ones) so earlier rounds don't anchor them.
