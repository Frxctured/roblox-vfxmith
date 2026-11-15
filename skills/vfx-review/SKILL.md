---
name: vfx-review
description: Blind 3-reviewer panel for a Roblox VFX effect - shape/scale, timing/motion and colour/layering lenses score the effect against its references and list concrete spec fixes. Use after each capture in vfx-make, or when the user asks to review, score or improve an effect.
---

# Blind review panel

`ROOT` = `<base directory>/../..`. Evidence comes from `vfx-make` steps 5-6: our contact sheets and full frames on
BOTH backdrops (`vN_day/sheet.jpg` + `vN_day/t*.jpg`, `vN/sheet.jpg` + `vN/t*.jpg`, from the capturer), `brief.md`
(what the user asked for), the effect spec, and with a reference `cmp_vN/pairs.png` (reference left, ours right, same
effect times), `compare.png`, `curves.png`, `metrics.json`, the reference frames or video, the reference analysis
(video) or the librarian's `refs.md` (description). The reviewers read the frames; the builder only reads their
reports.

## Run it
Spawn three reviewers in ONE message, in parallel, as the `vfx-reviewer` agent (or general-purpose agents with high
effort), fresh every round, on the session's main model (their reports drive every fix: do not move them to a fast
model). Give each the same evidence block and ONE lens. Never include your own opinion, earlier
rounds or the other reviewers' answers: anchoring makes reviewers confirm instead of look.

The evidence block, the three lenses and the deliverable text are in `knowledge/reviewer-prompts.md`: copy them,
filling the paths. Lenses: (1) shape, scale and composition, (2) timing, rhythm and motion, (3) colour, value and
layering. Each returns scores 0-10 (its lens criteria, Appeal and Overall), the 6 biggest problems with effect
time, layer id, numbers, the backdrop that shows it and a concrete spec fix, and one sentence on what already works.
The prompts carry "What people preferred" from the human polls: the AI panel alone had ranked the effect people
liked second LAST (test 5), so keep that section in every prompt, and give every reviewer `knowledge/taste.md`
(what people liked and disliked: restrained glow, residue that stays, endings as highlights).

**Pick the scale by the request** (texts in `knowledge/reviewer-prompts.md`):
- a reference video or "make it look like this": 10 = indistinguishable from the reference;
- a description ("make a cool ..."): ABSOLUTE quality, 10 = a professional would ship it as a signature effect in a
  top game. The library references are the quality bar, not a target. A resemblance scale here stalls around 6 and
  stops the loop early (blind test, 2026-11-14).

## Merge
- Fix what 2+ reviewers flag first, then the single highest-impact items.
- Skip fixes that contradict something a reviewer said already matches.
- Change by half steps when a reviewer says "much too much": over-correction is the most common failure.
- Reviewers report SCREEN colours (texture x Color x opacity; Neon renders hotter and more saturated): convert to the
  value you author.
- Log the round in `<effect>/LOG.md`: scores per reviewer, merged fix list, what was applied.
- How many rounds: at most TWO panels (vfx-make step 7), or one in quick mode; a third only in polish mode and only if
  the second gained 0.5 or more. Stop earlier when every lens is >= 8.5. In blind test 3 the 0.1.5 loop's third panel
  moved its own score 6.17 -> 6.33 while the outside panel gave the effect 7.5. After the last panel, apply its shared
  fixes, check the final sheets against them yourself and report what still differs and why.

Optional: if `lihfolk:quality-score` is available, also score with its VFX rubric; not required.
