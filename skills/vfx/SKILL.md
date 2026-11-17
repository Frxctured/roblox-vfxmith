---
name: vfx
description: Roblox VFX router - use for ANY Roblox visual effect request (explosion, slash, beam, laser, aura, impact, projectile, lightning, fire, ice, water, portal, holy/light, combined effects like "a light beam with an explosion"), for "make a VFX", "make it look like this video", "find VFX examples", "review/improve this effect", or "is this VFX pack safe". Routes to vfx-direct (the directed build loop, default), vfx-make (classic loop), vfx-find, vfx-review or vfx-study-pack and says what to read first.
---

# Roblox VFX (router)

`ROOT` = the plugin root: two folders above this skill's base directory (`<base directory>/../..`, also
`${CLAUDE_PLUGIN_ROOT}`). Every path below is relative to ROOT. Resolve it to an absolute path before running
anything (it may contain spaces: quote it).

## Read first (keep it short: every turn re-reads what you load)
1. `knowledge/taste.md`: what people liked and disliked in real effects (outranks everything else), then
   `knowledge/builder-notes.md`: the rules that decided the blind tests, the traps, and the token rules.
   For the directed loop the agents read their own list (`knowledge/vfxkit.md`, `pro-guide.md`, `checklist.md`,
   `selfcheck.md`); as the lead you only need `skills/vfx-direct/SKILL.md`.
2. The category study for the effect type(s), its anatomy and timing tables: `knowledge/categories/<type>.md`, types:
   explosion, slash, impact, aura, beam, projectile, lightning, fire, icewater, darkportal, misc (holy, light,
   character). Index: `knowledge/README.md`.
For anything else, grep `knowledge/` and read only the matching section.

## Route
| The user wants | Use |
|---|---|
| a new effect from a description ("a cool light beam with an explosion", "an ice slam", "a purple aura"), or "make this better" on one built this way | the short questionnaire + brief (`knowledge/design-brief.md`, skip what the request answers), then `vfxmith:vfx-direct`: the directed loop (a builder with the VFXKit blocks and a 5-camera self-check, a director with one ranked fix list per round, at most 3 rounds, then the user's feedback). The default in this beta |
| the classic loop ("classic", "the old way", a `VFXTimeline` spec from the start) | `vfxmith:vfx-make` (librarian, data spec, capturer, three blind reviewers) |
| an effect that looks like a video they show | `vfxmith:vfx-make` (starts with the video breakdown) |
| examples / "how do pros make X" | `vfxmith:vfx-find` (or grep `knowledge/` and `library/cards/` for a quick answer) |
| a review or "make this better" | `vfxmith:vfx-review`, then fixes with `vfx-make` |
| to learn from or clean a downloaded VFX pack | `vfxmith:vfx-study-pack` |
| to give their opinion of an effect ("rate this", "I liked...", "feedback") | `vfxmith:vfx-feedback` (saves it, teaches the plugin) |

If the skills are not loaded (plain folder use), open `skills/<name>/SKILL.md` and follow it as instructions.

## Non-negotiables
- Design the effect first; library references, house examples and the category note are a guide (techniques,
  timing, values), not a template. Build the hero shape yourself when nothing fits closely.
- Never call an effect done without capturing it in Studio and comparing it with the references.
- Everything is built in the caster's space; nothing is turned, moved or brightened toward a camera (builders,
  directors and reviewers alike).
- Studio is reached through the Studio MCP server. Without it, deliver the spec + install steps and say it is untested.
- Optional: if `lihfolk:*` skills are listed in the session, the LihFolk vault can answer engine-limit questions.
  Nothing here requires it.
