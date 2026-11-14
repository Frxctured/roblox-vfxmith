---
description: 'Make, find or review a Roblox VFX effect with the roblox-vfx library (e.g. /vfx a cool light beam with an explosion)'
argument-hint: <what you want, e.g. "a purple ground slam" | find <description> | review <effect folder>>
---

Use the `vfx` skill (roblox-vfx plugin) for: $ARGUMENTS

If it starts with "find", run `vfx-find` only and report the references. If it starts with "review", run `vfx-review`
on the named effect. Otherwise make the effect with `vfx-find` then `vfx-make`, including the capture, compare and
review loop in Studio, and report what was captured (frames) and the reviewers' scores.
