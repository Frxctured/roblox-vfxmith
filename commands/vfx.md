---
description: 'Make, find or review a Roblox VFX effect with the vfxmith library (e.g. /vfx a cool light beam with an explosion)'
argument-hint: <what you want, e.g. "a purple ground slam" | find <description> | review <effect folder>>
---

Use the `vfx` skill (vfxmith plugin) for: $ARGUMENTS

If it starts with "find", run `vfx-find` only and report the references. If it starts with "review", run `vfx-review`
on the named effect. Otherwise ask the short questionnaire from
`knowledge/design-brief.md` (only what the request leaves open), write the brief, then make the effect with
`vfx-make` (full mode by default, at most two review panels; quick mode only when the
user asks for speed). Its helpers do the heavy work: the librarian finds references, the capturer takes the frames on
both backdrops (void and daylight) and returns contact sheets, three blind reviewers score. Report the final sheets
and the reviewers' scores.
