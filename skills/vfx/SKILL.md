---
name: vfx
description: Roblox VFX router - use for ANY Roblox visual effect request (explosion, slash, beam, aura, impact, projectile, lightning, fire, ice, portal, holy, combined effects like "a light beam with an explosion"), for "make a VFX", "find VFX examples", "is this VFX pack safe", or feedback on an effect. Routes to vfx-make, vfx-find, vfx-study-pack or vfx-feedback.
---

# Roblox VFX (router)

`ROOT` = two folders above this skill's base directory (`${CLAUDE_PLUGIN_ROOT}`); quote it (spaces).

vfxmith 1.0.0-alpha3 is a thin, optional kit (`ROOT/START.md`): an effect clock with an exact freeze and a
posable R15 dummy, textures drawn in code, a short texture list and pro effects as read-only references. The
design is the builder's own.

| Request | Skill |
|---|---|
| make / build / remake an effect | `vfx-make` |
| "how do pros make X", find examples | `vfx-find` (`kit/scripts/compose.py "<description>"`, read-only) |
| a downloaded pack: is it safe, add it | `vfx-study-pack` |
| the user gives their opinion of an effect | `vfx-feedback` |
