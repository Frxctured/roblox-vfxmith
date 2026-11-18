---
description: 'Make or find a Roblox VFX effect with vfxmith (e.g. /vfx a frost nova that bursts from the ground)'
argument-hint: <what you want, e.g. "a purple ground slam" | find <description>>
---

Use the `vfx` skill (vfxmith plugin) for: $ARGUMENTS

If it starts with "find", run `vfx-find` (`kit/scripts/compose.py`) and report the candidates. Otherwise run
`vfx-make`: brief, find pro compositions, checkpoint 1 (the user picks; auto if they asked for no questions), adapt
and combine the pieces, one objective fault check, checkpoint 2 (their opinion), export `final.luau`.
