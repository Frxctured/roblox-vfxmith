---
name: vfx
description: Roblox VFX router - use for ANY Roblox visual effect request (explosion, slash, beam, aura, impact, projectile, lightning, fire, ice, portal, holy, combined effects like "a light beam with an explosion"), for "make a VFX", "find VFX examples", "is this VFX pack safe", or feedback on an effect. Routes to vfx-make (build from real pro compositions), vfx-find, vfx-study-pack or vfx-feedback.
---

# Roblox VFX (router)

`ROOT` = two folders above this skill's base directory (`${CLAUDE_PLUGIN_ROOT}`); quote it (spaces).

vfxmith 1.0 builds effects by **starting from real professional compositions** (1,927 open-source pro effects
with exact data), loading their instance trees into Studio and adapting colour, scale, timing and placement. It
never invents textures or layouts. The whole method is in `ROOT/START.md` (read it first) and
`ROOT/knowledge/guide.md`.

| Request | Skill |
|---|---|
| make / build / remake an effect | `vfx-make` |
| "how do pros make X", find examples | `vfx-find` (`kit/scripts/compose.py "<description>"`) |
| a downloaded pack: is it safe, add it | `vfx-study-pack` |
| the user gives their opinion of an effect | `vfx-feedback` |

Do not load `knowledge/archive/` (the 0.1.x pack); search the research vault instead:
`python3 -I "ROOT/vault/_tools/vault.py" "<question>"`.
