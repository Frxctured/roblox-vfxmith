---
name: vfx-review
description: Blind 3-reviewer panel for a Roblox VFX effect - shape/scale, timing/motion and colour/layering lenses score the effect against its references and list concrete spec fixes. Use after each capture in vfx-make, or when the user asks to review, score or improve an effect.
---

# Blind review panel

`ROOT` = `<base directory>/../..`. Evidence comes from `vfx-make` step 6: `cmp_vN/pairs.png` (reference left, ours
right, same effect times), `compare.png`, `curves.png`, `metrics.json`, plus the reference frames or video, the
reference analysis (video) or library cards (description), and the effect spec.

## Run it
Spawn three reviewers in ONE message, in parallel, as the `vfx-reviewer` agent (or general-purpose agents with high
effort), fresh every round. Give each the same evidence block and ONE lens. Never include your own opinion, earlier
rounds or the other reviewers' answers: anchoring makes reviewers confirm instead of look.

The evidence block, the three lenses and the deliverable text are in `knowledge/reviewer-prompts.md`: copy them,
filling the paths. Lenses: (1) shape, scale and composition, (2) timing, rhythm and motion, (3) colour, value and
layering. Each returns scores 0-10 (10 = indistinguishable from the reference), the 6 biggest differences with effect
time, layer id, numbers and a concrete spec fix, and one sentence on what already matches.

When the reference is a library effect rather than a video, say so in the evidence block and add its card: reviewers
should judge resemblance in look and quality, not copy it one to one, if the user asked for something new.

## Merge
- Fix what 2+ reviewers flag first, then the single highest-impact items.
- Skip fixes that contradict something a reviewer said already matches.
- Change by half steps when a reviewer says "much too much": over-correction is the most common failure.
- Reviewers report SCREEN colours (texture x Color x opacity; Neon renders hotter and more saturated): convert to the
  value you author.
- Log the round in `<effect>/LOG.md`: scores per reviewer, merged fix list, what was applied. Stop when every lens
  is >= 8.5, or after 2 rounds that gain < 0.5 on average (report what still differs and why).

Optional: if `lihfolk:quality-score` is available, also score with its VFX rubric; not required.
