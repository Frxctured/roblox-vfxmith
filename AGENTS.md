# AGENTS.md: making Roblox VFX with this folder

You are in **vfxmith**: everything needed to make Roblox visual effects the way experienced artists build them,
learned from ~1,900 catalogued open-source effects (~1,200 read layer by layer, 75 played frame by frame). Works with any AI coding agent (as a Claude Code plugin it adds the
skills in `skills/`; as a plain folder, follow this file). All paths below are relative to this folder.

## What is here
| Folder | Use it for |
|---|---|
| `knowledge/design-brief.md` | the short questionnaire to ask the user first (length, peak moment, purpose, style...; skip what the request answers) and the brief that sets size and timing before any recipe |
| `knowledge/patterns.md` | the rules that hold for every effect type (section 14: fire at t = 0, black twins, opaque glow, fade by colour, Speed/Drag, sizes from one number; section 15: what the blind tests taught). Read first. |
| `knowledge/categories/<type>.md` | one deep study per effect type: explosion, slash, impact, aura, beam, projectile, lightning, fire, icewater, darkportal, misc (holy/light/character). Anatomy with typical values, timing table, techniques, mistakes. |
| `knowledge/categories/<type>_recipe.luau` | a working starting effect per type (layer list for `kit/runtime/VFXTimeline.luau`); how each one plays: `gallery/recipes/<type>_recipe.jpg` |
| `knowledge/texture-vocab.md` | texture asset ids by role (glows, stars, rings, crescents, smoke, fire, lightning...) that load in any game |
| `knowledge/spec-format.md` | how to write an effect as data |
| `library/` | ~1,200 real effects: one card each with exact layer values (`library/cards/<type>/<id>.md`); search with `kit/scripts/find_effects.py` |
| `gallery/effects/<type>/<id>.jpg` | real effects frozen at t = 0.03, 0.1, 0.2 ... s: what good looks like |
| `kit/` | the runtime (with `VFXTimeline.check`, a spec checker), Studio modules (capture on a void stage, a default daylight baseplate or your map; playback of library effects), scripts (search, compare, capture, texture traits, pack tools) |
| the pack (optional) | the cleaned open-source files the cards come from, a separate ~410 MB download: `kit/scripts/get_pack.py` gets it (ask the user first), then `kit/scripts/rbxcut.py --id <card id> --studio` puts any card's effect into Studio to watch. Everything else works without it. |
| `skills/*/SKILL.md` | the detailed workflows below, as plain instructions any agent can follow |

## What the user wants -> what to do
1. **"Make a ... effect"** (from a description, e.g. "a cool light beam with an explosion", "an ice slam"): first
   the short questionnaire and brief (`knowledge/design-brief.md`: ask only what the request leaves open), then
   `python3 kit/scripts/find_effects.py "<their words>"` -> read the `knowledge/categories/<type>.md` it names, the
   2-3 best library cards, and LOOK at their frames in `gallery/` -> start from `<type>_recipe.luau` (merge two recipes
   for a combined effect) -> build, capture, compare and review: `skills/vfx-make/SKILL.md`.
2. **"Make it look like this video"**: `skills/vfx-make/SKILL.md` (reference breakdown first).
3. **"Find me examples of ..."**: `skills/vfx-find/SKILL.md`.
4. **"Review / improve this effect"**: `skills/vfx-review/SKILL.md` (blind 3-reviewer panel).
5. **"Study this VFX pack / is this safe"**: `skills/vfx-study-pack/SKILL.md` (never open a downloaded pack in Studio
   before scanning it).
6. **A quick question** ("how do pros make a flat ring?"): grep `knowledge/` and `library/cards/` first, answer with
   the numbers you find and say where they came from.

## Rules
- **Never build from nothing.** Every effect starts from library references and the category note.
- **Look at your result, in daylight too.** An effect is not done until you have captured it in Studio and compared
  it with the references (`kit/studio/VFXCapture.luau`: `C.hold(name, t)` + a screenshot works on every OS). Capture
  on the black void stage AND on `C.stage("day")` (the default baseplate) or the user's map: the void hides dark
  layers that read as dirt in daylight.
- **Check the spec after every edit:** `C.check(name)` lists silent authoring mistakes (a property outside `props`, a
  missing Transparency, an unknown ease) and the peak particle counts.
- **Check textures before you use them:** `kit/scripts/texture_traits.py <id>` (colour, black/faint card, multi-part,
  effective resolution); a particle's Size is its half-width.
- Roblox Studio is driven through the Studio MCP server (`execute_luau`, `screen_capture`). If it is not connected,
  say so and give the user the spec + install steps instead of claiming the effect looks right.
- Texture ids in the library are other people's uploads: fine to reference while building; tell the user that
  shipping them in a published game is their call (`THIRD_PARTY.md`).
- Optional extra: if the LihFolk plugin is installed, its vault can answer engine-limit questions; nothing here
  requires it.
