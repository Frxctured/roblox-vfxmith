---
description: 'Make or find a Roblox VFX effect with vfxmith (e.g. /vfx a frost nova that bursts from the ground)'
argument-hint: [what you want, e.g. "a purple ground slam" | find (description) | replicate (reference path or description)]
---

Use the `vfx` skill (vfxmith plugin) for: $ARGUMENTS

If it starts with "find", run `vfx-find` (`kit/scripts/compose.py`, read-only references) and report the
candidates. If it starts with "replicate", or asks to copy / match / replicate a given reference effect, run
`vfx-replicate` (experimental; its first step is a cost warning). Otherwise run `vfx-make` (START.md: a thin, optional kit; the
design is yours).
