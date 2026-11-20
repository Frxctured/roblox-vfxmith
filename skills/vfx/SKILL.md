---
name: vfx
description: Roblox VFX router - use for ANY Roblox visual effect request (explosion, slash, beam, aura, impact, projectile, lightning, fire, ice, portal, holy, combined effects like "a light beam with an explosion"), for "make a VFX", "copy/match/replicate this effect", "find VFX examples", "is this VFX pack safe", or feedback on an effect. Routes to vfx-make, vfx-replicate, vfx-find, vfx-study-pack or vfx-feedback.
---

# Roblox VFX (router)

`ROOT` = two folders above this skill's base directory (`${CLAUDE_PLUGIN_ROOT}`); quote it (spaces).

vfxmith 1.0.0-alpha6 is a thin, optional kit (`ROOT/START.md`): an effect clock with an exact freeze and a
posable R15 dummy, textures drawn in code, a short texture list and pro effects as read-only references. The
design is the builder's own, except in replicate mode, where the reference is the target.

| Request | Skill |
|---|---|
| make / build / remake an effect | `vfx-make` |
| `/vfx replicate <reference path or description>`, or "copy / match / replicate this" with a reference | `vfx-replicate` (closeness to the reference is the goal; costs several normal runs, warns first) |
| "how do pros make X", find examples | `vfx-find` (`kit/scripts/compose.py "<description>"`, read-only) |
| a downloaded pack: is it safe, add it | `vfx-study-pack` |
| the user gives their opinion of an effect | `vfx-feedback` |
