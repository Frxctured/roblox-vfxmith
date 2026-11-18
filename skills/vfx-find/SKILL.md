---
name: vfx-find
description: Find real Roblox VFX examples for a description in the library of 1,927 open-source pro effects ("light beam with an explosion", "dark purple slash", "how do pros make a shockwave ring") - returns the closest effects per part of the request with their exact layer tables and a command to load each into Studio. Use before building any effect, or to answer "how is X usually made".
---

# Find pro compositions

`ROOT` = `<base directory>/../..`; quote it.

```
python3 -I "ROOT/kit/scripts/compose.py" "<description>" [-k 5] [--lines 20]
python3 -I "ROOT/kit/scripts/compose.py" --show <id>          # one effect's full layer table
python3 -I "ROOT/kit/scripts/compose.py" --cut <id> ...       # into Studio's content folder, scripts removed
python3 -I "ROOT/kit/scripts/compose.py" --swap <texture id>  # same-role pro textures
```
Report per part: the top ids, what their primary element, ground layer, dark partner and flash are (read off the
table), and the frames if `gallery/effects/` has them. For "how is X made" questions also search the research vault:
`python3 -I "ROOT/vault/_tools/vault.py" "<question>"`.
