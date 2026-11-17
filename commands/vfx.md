---
description: 'Make, find or review a Roblox VFX effect with the vfxmith library (e.g. /vfx a cool light beam with an explosion)'
argument-hint: <what you want, e.g. "a purple ground slam" | classic <effect> | find <description> | review <effect folder>>
---

Use the `vfx` skill (vfxmith plugin) for: $ARGUMENTS

If it starts with "find", run `vfx-find` only and report the references. If it starts with "review", run `vfx-review`
on the named effect. Otherwise ask the short questionnaire from
`knowledge/design-brief.md` (only what the request leaves open), write the brief, then make the effect with
`vfx-direct`, the directed loop (the default in this beta): a builder agent builds with the tested VFXKit blocks and
checks every version from five cameras, a separate director agent watches each version and writes one ranked fix
list, for at most three director rounds; then show the user the final sheet and ask for their opinion
(`vfx-feedback`). Report the final sheets, the director's score per round and what is still open.

If it starts with "classic", or the user shows a reference video to recreate, use `vfx-make` instead (the 0.1.8 loop:
librarian, data spec, capturer, three blind reviewers; full mode by default, quick only when the user asks for speed).
