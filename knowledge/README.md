# Findings

What studying the open-source Roblox effects taught us (~1,900 catalogued, ~1,200 read layer by layer, 75 played frame by frame). Start with `knowledge/patterns.md` (rules that hold across
effect types), then the category you are building. Each category note has: a breakdown of each studied effect,
the **anatomy** (recurring layer roles with typical property values), a **timing** table, a **techniques**
catalogue with exact property recipes, and the **mistakes** seen. Each `<category>_recipe.luau` is a generic
starting effect for the pipeline runtime (`knowledge/spec-format.md`). Frame-by-frame sheets of the studied
effects are in `gallery/effects/<category>/` (`index.csv` there: source file of each).

Where a note says "the vault" it cites the LihFolk Vault V2, an optional knowledge base (`SKILL.md` section
11); every number you need is written here, nothing requires it.

| Category | Notes | Starting recipe |
|---|---|---|
| Open-source VFX study: aura / charge-up | [aura.md](categories/aura.md) | [aura_recipe.luau](categories/aura_recipe.luau) |
| Open-source VFX study: beam / laser | [beam.md](categories/beam.md) | [beam_recipe.luau](categories/beam_recipe.luau) |
| Dark, void, portal and domain VFX - lessons from 6 open-source effects | [darkportal.md](categories/darkportal.md) | [darkportal_recipe.luau](categories/darkportal_recipe.luau) |
| Explosion VFX - lessons from 7 open-source effects | [explosion.md](categories/explosion.md) | [explosion_recipe.luau](categories/explosion_recipe.luau) |
| Fire and flame VFX - lessons from 7 open-source effects | [fire.md](categories/fire.md) | [fire_recipe.luau](categories/fire_recipe.luau) |
| Open-source VFX study: ice / water | [icewater.md](categories/icewater.md) | [icewater_recipe.luau](categories/icewater_recipe.luau) |
| Impact, slam and ground-hit VFX - lessons from 7 open-source effects | [impact.md](categories/impact.md) | [impact_recipe.luau](categories/impact_recipe.luau) |
| Lightning and electric VFX - lessons from 7 open-source effects | [lightning.md](categories/lightning.md) | [lightning_recipe.luau](categories/lightning_recipe.luau) |
| Open-source VFX study: miscellaneous (holy, light, character and other) | [misc.md](categories/misc.md) | [misc_recipe.luau](categories/misc_recipe.luau) |
| Projectile and orb VFX - craft notes from 7 open-source effects | [projectile.md](categories/projectile.md) | [projectile_recipe.luau](categories/projectile_recipe.luau) |
| Slash and sword VFX - lessons from 6 open-source effects | [slash.md](categories/slash.md) | [slash_recipe.luau](categories/slash_recipe.luau) |

Also: `library-stats.md` (what values artists pick, over every emitter design in the pack),
`knowledge/design-brief.md` (the questionnaire and brief to start every effect with),
`knowledge/texture-vocab.md` (texture ids by role) and `knowledge/os-conventions.md` (how the
effects are driven by attributes).

Two studied effects (`af00e114ff57` iso_textures THUNDER, `f8b7b6d9d087` Jingliu IceExplosion) came from files that
were later left out of the pack as ripped from live games: their notes stay (our own observations),
their frames are not published.
