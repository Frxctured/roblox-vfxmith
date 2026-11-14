---
name: vfx-find
description: Find real Roblox VFX examples for a description in the library of ~1,200 open-source effects ("light beam with an explosion", "dark purple slash", "ice ground crack", "how do pros make a shockwave ring") - returns the closest effects with their exact layer values, frame-by-frame sheets and the matching category study and starting recipe. Use before building any effect, or to answer "how is X usually made".
---

# Find VFX references in the library

`ROOT` = `<base directory>/../..` (also `${CLAUDE_PLUGIN_ROOT}`); quote it. For a long search you can hand this to the
`vfx-librarian` agent (it returns a compact reference brief).

## 1. Search
```bash
python3 -I "ROOT/kit/scripts/find_effects.py" "<the request in the user's words>" [-k 8] [--category beam] [--frames-only]
```
It splits combined requests ("beam with an explosion") into parts and, per part, prints the category study, the
starting recipe and the best matching effects: `id, category, layers, length, source file :: instance`, the card path
and (when captured) the frames path. Categories: explosion, slash, impact, aura, beam, projectile, lightning, fire,
icewater, darkportal, misc (holy, light, character).

If the words miss, search the cards directly: `grep -ril "<word>" "ROOT/library/cards"` (layer names often say what a
layer is: `shockwave`, `flare`, `crack`, `smoke`), or list a category: `ls "ROOT/library/cards/<category>"`.

## 2. Read and look
- **Card** (`library/cards/<category>/<id>.md`): one line per layer in firing order: texture id (+ light mode A/D/M,
  flipbook grid, common name), colour ramp, LightEmission / LightInfluence / Brightness, lifetime, Size curve shape,
  Transparency shape, Speed / Drag / Spread / Acceleration, orientation, Squash, flipbook, ZOffset, and how it fires
  (`EMIT n @delay` = burst, `RATE` = continuous). "Fired by" says whether the numbers alone reproduce it or whether the
  original relied on its own scripts (then some motion is missing from the card).
- **Frames** (`gallery/effects/<category>/<id>.jpg`): the effect frozen at t = 0.03, 0.1, 0.2 ... s (exact times in
  `gallery/effects/index.csv`). LOOK at them: size relative to the frame, how fast it peaks, what lingers, three tones.
- **Category study** (`knowledge/categories/<category>.md`): the anatomy table (typical values per layer role), timing
  table and techniques: use it to tell which card values are typical and which are one artist's quirk.

Summarise for the build: per part, 2-3 chosen references with ids, the layer roles you will copy (with their numbers)
and what to avoid (the category's "mistakes").

## 3. See an effect that has no frames yet (optional, needs Studio + the pack)
The cards come from the cleaned open-source pack, a separate download (`PACK.md`). The first line `find_effects.py`
prints says whether it is installed. If it is not and the user wants to watch references, ask them first (about
410 MB download, 490 MB unpacked), then:
```bash
python3 -I "ROOT/kit/scripts/get_pack.py"                   # download, check the SHA-256, unpack (~/.vfxmith/pack)
python3 -I "ROOT/kit/scripts/get_pack.py" --link <folder>   # or: use a copy they already have
```
To watch one effect, cut it into Studio's content folder (every script removed by construction):
```bash
python3 -I "ROOT/kit/scripts/rbxcut.py" --id <card id> --studio      # writes <content>/vfxlib/fx_<id>.rbxmx
```
In Studio (MCP `execute_luau`, Edit), with the kit installed (`vfx-make` section 3):
```lua
local P = require(game.ServerStorage.VFXDev.VFXLibPlayer:Clone())
P.stage("grey"); P.load("fx_<id>"); P.frame(); P.play()
```
then MCP `screen_capture` a few times while it plays (or `P.batch` + `stills.py --follow` for frozen stills). The
player follows the attribute conventions in `knowledge/os-conventions.md`; motion an effect's own scripts made is
missing. Never open pack files in Studio directly and never press Play in them (`SECURITY.md`).
