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
  baseplate under the sky, or the user's own map: <effect>/vN_day/). Each folder has sheet.jpg (all times, labelled)
  and the full frames t<time>.jpg (vN_day/ also has focus.jpg: the payoff moments at 640 px). Read the sheets
  first, all in one message, then open the single frames you need to judge details (shape edges, facets, colour at
  the payoff). Judge readability on BOTH backdrops; daylight is what players see in most games.
- Motion strip: <effect>/vN_motion/sheet.jpg + frames: consecutive frames 1/30 s apart through the payoff, then 0.1 s
  apart through the hold (and <effect>/vN.mp4 if a real-time video exists: cut frames with ffmpeg). Read it frame to
  frame; stills of separate moments cannot show motion. Freeze frames re-roll particle positions: judge layers,
  sizes and brightness over time, not where single particles sit.
- The grey block figure in OUR frames is one character, H = 5.2 studs tall: measure every beat against it.
- <cmp>/compare.png, <cmp>/curves.png (coverage/brightness/value over time, REF yellow, OURS blue), <cmp>/metrics.json
  (per time: coverage, bright share, mean colour, hue, saturation, value, dark share, bounding box as frame fractions).
- Reference breakdown: <reference folder>/analysis.md, full-size reference frames in .../frames/, the video
  .../source.mp4 (cycle starts at <t0> s; ffmpeg frames into the scratchpad if useful). For a library reference: its
  card (library/cards/...) and frames.
- The brief: <effect folder>/brief.md (what the user asked for: purpose, length, peak time, sizes, style). Read it as
  INTENT: hue family, timing, size, motion, mood. An effect that ignores the brief is wrong even if it looks good,
  but a different take on the asked palette is not a fault by itself. Judge colour by whether it suits the effect:
  a clear value range (white core or tips, a body colour, a deeper tone) in the asked hue family is right; washed-out
  grey-white, neon-loud saturation on a natural material, and glow that floods the floor or hides the shapes are
  wrong. Read `knowledge/taste.md` (what people liked and disliked) before scoring; it overrides your own taste.
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
   phase fills, what reads at a glance, one hero shape per beat vs clutter. Give each beat's size in H against the
   figure (attack arcs under ~2 H or thinner than a limb, and hits that stay inside the target's silhouette, read
   small). On a character: a ground layer as the biggest element, a head accent with the face clear, one
   off-centre accent, the body not hidden. Scores: Shapes/silhouettes, Scale/placement, Overall.
2. **Timing, rhythm and motion**: when each phase starts/peaks/ends, pops vs grows, the quiet beat before the payoff,
   linger length, easing. From the motion strip: is the hit at full size one frame after contact; do sharp shapes
   (slashes, arcs, needles) change within 1-3 frames or sit like stickers; does the payoff leave a tail of a
   different kind for 0.3 s or more; does the hold look the same in two frames (a static shape that only turns, a
   visible loop, no pulses)? Name the frames. Scores: Timing/rhythm, Motion/easing, Overall.
3. **Colour, value and layering**: palette per phase, white core vs saturated body vs dark ink, brightness/glow, how
   colours age, density of small detail (sparkles, curls, smoke, orbs), clutter vs emptiness, how the dark layers read
   in daylight (ink vs dirt), stair-stepped or card-edged textures. Check: a dark ink layer beside the brightest shape;
   exactly one dominant bright mass; the figure not washed out or the same value as the effect over it; smoke as an
   overlapping two-tone volume (not separate faint puffs or a flat cloud); leftover particles in several sizes and
   shapes (not identical dots). Scores: Colour/value, Layering/detail density,
   Overall. Add to its prompt: "A particle's ON-SCREEN colour is roughly texture brightness x Color x opacity; Neon
   renders hotter and more saturated. Give the value to AUTHOR, not only the target on screen."

Every lens also scores **Appeal**: would a player who sees this in a game say "wow"? People, not checklists, decide
whether an effect is good (see "What people preferred" below); Overall must not sit far below Appeal because of small
deviations from the brief's wording.

## What people preferred (human polls on the owner's server; calibrate with these)
What people reward, in every test so far: crisp, characterful hero shapes; punchy colour and contrast; a clear, big
payoff; things breaking into pieces you can see. What they punish: generic primitives, washed-out or blown-out
colour, tiny payoffs. The two polls:
- Test 5, ice slam (2026-11-15): first, clearly, an effect with sharp FACETED crystals (deep blue base -> cyan ->
  white tips, lighter/darker facets), a falling "fist comet" into the impact, and spikes that break into 3-7 chunky
  shards leaving stumps; second, a VIVID electric-blue one whose spikes come up white-hot and cool to saturated blue
  with neon glow. Far behind: pale smooth cones ("a pincushion") and blown-out white. The AI panel had ranked the vivid
  one LAST for being "sapphire, not icy cyan": people liked it more than the panel did. Later the owner rated the
  winner 8/10 and preferred it over 0.1.6's ice for LESS glow and frost that stayed longer, and said the winner could be
  a little LESS saturated: saturation should suit the effect, and glow should be restrained (`knowledge/taste.md`).
- Test 3, void rift (2026-11-14): people picked the jagged, torn rift with a nebula inside and a layered, big payoff
  (5 of 7 votes); the panel agreed.

## Deliverable (append to every prompt, with ONE of the two scale lines)
```
Deliver (under 500 words):
1. Scores 0-10 for your lens's criteria + Appeal + Overall.
   [match]       Scale: 10 = indistinguishable from the reference.
   [description] Scale: absolute quality, the owner's. 10 = professional, expensive work: nothing a paid VFX artist
                 would redo; 8.5-9 = a signature effect of a top Roblox game; 7 = good and usable, a professional
                 would still fix several things; 5.5 = the idea reads but a main part is small, thin, static or
                 weightless; 4.5 = a cheap-looking part (flat smoke, a flat disc, plain dots); 3 = amateur.
                 Score what a player sees at gameplay distance in daylight. If unsure between two scores, give the
                 lower. Use the references as the bar, not as a target to copy.
2. The 6 most important problems, ranked by impact. For each: effect time(s), layer id from the spec (or "missing
   layer"), what is wrong (concrete numbers: "~1.5x wider", "3 studs too high", "0.1 s late", "#hex vs #hex"),
   which backdrop shows it (void, daylight, both), and a CONCRETE spec fix (field and value, or a new layer with its
   key params).
3. Never recommend removing, shortening or fading out early something the brief asks for or `knowledge/taste.md`
   says people like (residue, resting pieces, a break flash): say how it should look instead. In the ice re-run a
   panel's "frost plate" and "shards freezing" advice made the builder remove exactly what the owner liked most.
4. If a problem can't be fixed by values (the mesh, texture or construction can't reach the look), write REBUILD and
   what to build instead (e.g. "REBUILD the hero: a jagged shape with its own white edge and deep shadow side,
   not the tinted library mesh").
5. One sentence on what already works well (so the fixes don't break it).
Be honest and specific; do not edit any files.
```

**Calibration, round 1 (2026-11-16, four effects; a server member's score -> the owner's):** dark charge aura 9 -> 7
(liked, but a static cage, no ground layer, pale body under it); sword combo 7 -> 5.5 ("the slash is a bit small;
unclear what it is meant for"); ground portal 6 -> 4.5 ("the smoke is kinda low quality"; a flat centre where
depth was asked); magic missile "pretty good; the particles at the end could be higher quality". Casual viewers score about 1.5-2 points above the owner: an 8 from you must mean the effect stands beside paid work.

## Merging
- Fix what 2+ reviewers flag first; then the single highest-impact items; skip fixes that contradict a "works well".
- Keep a round log: scores per reviewer, the merged fix list, what was applied.
- Fresh reviewers each round (new agents, not continued ones) so earlier rounds don't anchor them.
